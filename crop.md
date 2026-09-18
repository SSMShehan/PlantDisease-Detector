# CropGuard LK — Technical Build Plan (v2, Supabase)

**Project:** Photo-Based Crop Disease Identification Application
**Course:** IT3060 — Human Computer Interaction | Group WD_21
**Members:** DEEPTHIKA H M L S · KURUPPU K A S D · MADUSANKA S H S S · AMARSURIYA E M K N
**Scope:** Android-first Flutter app (farmer + student) · React officer dashboard · Supabase backend · Python inference service

> Supersedes v1. The change: Supabase replaces the hand-written FastAPI CRUD backend. FastAPI survives as a single-purpose inference service. Roughly 40% of the original backend work disappears, and that capacity moves to the ML model — which is where the project's real risk sits.

---

## Table of Contents

1. [Why Supabase](#1-why-supabase)
2. [System Architecture](#2-system-architecture)
3. [Technology Stack](#3-technology-stack)
4. [Database Schema (complete SQL)](#4-database-schema-complete-sql)
5. [Row Level Security Policies](#5-row-level-security-policies)
6. [Storage Buckets & Policies](#6-storage-buckets--policies)
7. [The Inference Service](#7-the-inference-service)
8. [Data Access Contract](#8-data-access-contract)
9. [Folder Structure](#9-folder-structure)
10. [Offline & Sync Design](#10-offline--sync-design)
11. [Work Split — 4 Members](#11-work-split--4-members)
12. [Build Plan — 12 Weeks](#12-build-plan--12-weeks)
13. [Git Workflow & Conventions](#13-git-workflow--conventions)
14. [Definition of Done](#14-definition-of-done)
15. [Risks](#15-risks)
16. [Requirements Traceability](#16-requirements-traceability)
17. [Immediate Next Actions](#17-immediate-next-actions)

---

## 1. Why Supabase

Supabase is Postgres with a managed convenience layer on top. That matters because your data model is genuinely relational — `diagnoses → diseases → treatments → escalations` with foreign keys throughout — and a document store would force you to denormalise all of it.

**What you stop having to build:**

| Capability | Hand-rolled cost | With Supabase |
|---|---|---|
| Auth (signup, login, sessions, JWT refresh) | ~1 week | SDK call |
| CRUD endpoints for 8 tables | ~1.5 weeks | Auto-generated |
| Image storage + signed URLs | ~3 days | SDK call |
| Per-role access control | Middleware on every route | 2–3 SQL policies per table |
| Live officer queue updates | WebSocket server | `.stream()` subscription |
| Database migrations & admin UI | Alembic + psql | Built-in SQL editor |

**What Supabase cannot do for you:** run the TensorFlow model. Edge Functions execute Deno (TypeScript), not Python. Inference therefore stays in a small FastAPI service deployed separately. This is the one seam in the architecture, and it's a clean one — a single endpoint, image in, prediction out.

**Defending this choice in the viva:** you chose Postgres because the domain is relational and because Row Level Security lets access rules live next to the data rather than scattered across application code — a farmer physically cannot read another farmer's diagnosis, even if the client is compromised. That's a stronger security argument than "our API checks the user ID."

---

## 2. System Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                      FARMER PHONE (Flutter)                  │
│                                                              │
│  Capture ──► preprocess 224×224 ──► TFLite (on-device)       │
│                                        │                     │
│                              ┌─────────▼──────────┐          │
│                              │  CONFIDENCE GATE   │          │
│                              │  ≥70%  → show      │          │
│                              │  40-70% → flag     │          │
│                              │  <40%  → escalate  │          │
│                              └─────────┬──────────┘          │
│                                        │                     │
│  Drift/SQLite  ◄── write-through ──────┘                     │
│  (history + outbox queue)                                    │
└───────┬──────────────────────────────┬───────────────────────┘
        │ supabase_flutter SDK         │ HTTPS multipart
        │ (auth, data, storage,        │ (only when online &
        │  realtime)                   │  confidence is low)
        ▼                              ▼
┌───────────────────────────┐   ┌────────────────────────────┐
│        SUPABASE           │   │  INFERENCE SERVICE         │
│  ┌─────────────────────┐  │   │  FastAPI + TF (Render)     │
│  │ Postgres + RLS      │  │   │                            │
│  │  profiles           │  │   │  POST /predict             │
│  │  diseases           │  │   │   → {label, confidence,    │
│  │  treatments         │  │   │      top_3}                │
│  │  diagnoses          │  │   │                            │
│  │  escalations        │  │   │  Higher-accuracy full      │
│  │  farm_logs, tips    │  │   │  model (not quantised)     │
│  └─────────────────────┘  │   └────────────────────────────┘
│  Auth  │ Storage │ Realtime│
└───────────┬───────────────┘
            │ realtime subscription on escalations
            ▼
┌──────────────────────────────────────────────────────────────┐
│         OFFICER DASHBOARD (React + supabase-js)              │
│  Live queue → case detail (photo + AI guess) → verdict       │
└──────────────────────────────────────────────────────────────┘
```

**Two-tier inference, deliberately.** The quantised TFLite model on the phone is fast and works offline — it handles the common case. The full-precision model on the server is more accurate but needs a connection. The phone only reaches for the server when the local model is unsure *and* connectivity exists. This is a direct implementation of your research finding that 38.5% of respondents have limited internet access.

---

## 3. Technology Stack

### 3.1 Core

| Layer | Technology | Notes |
|---|---|---|
| Mobile | **Flutter 3.19+ / Dart 3** | Android-first, iOS-capable |
| State | **Riverpod 2.x** | `AsyncNotifier` for anything touching the network |
| Backend-as-a-service | **Supabase** | Postgres 15, Auth, Storage, Realtime |
| Supabase client | `supabase_flutter` ^2.5.0 | Handles session persistence automatically |
| Local DB | **Drift** ^2.16 (SQLite) | Offline history, cached content, outbox |
| On-device AI | **TFLite** via `tflite_flutter` ^0.10 | INT8 quantised, ~4 MB |
| Inference service | **FastAPI** + `tensorflow-cpu` | Single endpoint, Render free tier |
| ML training | **TensorFlow/Keras** on Google Colab | Free T4 GPU |
| Base model | **MobileNetV3-Small**, transfer learning | ImageNet weights, fine-tune last blocks |
| Dashboard | **React 18 + Vite + TypeScript + Tailwind** | `@supabase/supabase-js` |
| Charts | **Recharts** | District/crop disease trends |
| Notifications | **Firebase Cloud Messaging** | Officer replies → farmer |
| Weather | **Open-Meteo** | No API key, no quota — simpler than OpenWeatherMap |
| Localisation | Flutter `intl` + ARB | `en`, `si`, `ta` |
| Fonts | Noto Sans Sinhala, Noto Sans Tamil | Bundled, not system-dependent |
| CI/CD | GitHub Actions | `flutter analyze`, tests, and Firebase App Distribution |
| Monitoring | **Firebase Crashlytics** | Catch offline sync and camera errors |

### 3.2 Flutter dependencies

```yaml
dependencies:
  flutter: {sdk: flutter}
  flutter_localizations: {sdk: flutter}

  # Backend
  supabase_flutter: ^2.5.0

  # State
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Local persistence
  drift: ^2.16.0
  sqlite3_flutter_libs: ^0.5.20
  path_provider: ^2.1.2
  shared_preferences: ^2.2.2

  # ML
  tflite_flutter: ^0.10.4
  image: ^4.1.7

  # Camera & media
  camera: ^0.10.5
  image_picker: ^1.0.7
  flutter_image_compress: ^2.2.0

  # Platform
  connectivity_plus: ^5.0.2
  firebase_core: ^2.27.0
  firebase_messaging: ^14.7.19
  geolocator: ^11.0.0
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.8
  drift_dev: ^2.16.0
  riverpod_generator: ^2.4.0
  flutter_lints: ^3.0.1
```

### 3.3 Rejected alternatives

| Option | Why not |
|---|---|
| Firebase Firestore | Forces denormalisation of a relational model; joins become client-side loops |
| Raw Postgres on a VPS | You'd rebuild auth, storage, and access control by hand for no academic gain |
| Full FastAPI CRUD backend | ~1.5 weeks of work Supabase gives you free; that time goes to the model instead |
| Supabase Edge Functions for inference | Deno runtime — no Python, no TensorFlow |
| Cloud-only inference | Contradicts your own finding on limited rural connectivity |
| Gemini / GPT-4 Vision for diagnosis | Per-call cost, requires internet, and it isn't *your* model — weak academically |

---

## 4. Database Schema (complete SQL)

Run these in the Supabase SQL Editor in order. Keep each block in `supabase/migrations/` in the repo so the schema is version-controlled and reproducible.

### 4.1 Extensions and enums

```sql
create extension if not exists "uuid-ossp";

create type user_role      as enum ('farmer', 'officer', 'student', 'admin');
create type diagnosis_src  as enum ('on_device', 'cloud');
create type diagnosis_stat as enum ('auto', 'uncertain', 'escalated', 'reviewed');
create type escalation_stat as enum ('pending', 'claimed', 'answered');
create type treatment_kind as enum ('organic', 'chemical', 'cultural');
```

### 4.2 Profiles

Supabase owns `auth.users`. You never touch that table directly — you mirror it into a public `profiles` table.

```sql
create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  full_name       text,
  phone           text,
  role            user_role not null default 'farmer',
  district        text,
  preferred_lang  text not null default 'si'
                  check (preferred_lang in ('si','ta','en')),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- Auto-create a profile row whenever a user signs up
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, phone)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    new.phone
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
```

### 4.3 Content tables

```sql
create table public.diseases (
  id            uuid primary key default uuid_generate_v4(),
  crop          text not null,
  model_label   text unique not null,     -- must match labels.txt exactly
  name_en       text not null,
  name_si       text not null,
  name_ta       text,
  symptoms_en   text,
  symptoms_si   text,
  symptoms_ta   text,
  severity      text check (severity in ('low','medium','high')),
  reference_image_url text,
  updated_at    timestamptz not null default now()
);

create index on public.diseases (crop);
create index on public.diseases (model_label);

create table public.treatments (
  id            uuid primary key default uuid_generate_v4(),
  disease_id    uuid not null references public.diseases(id) on delete cascade,
  kind          treatment_kind not null,
  steps_en      text,
  steps_si      text not null,
  steps_ta      text,
  precautions   text,
  est_cost_lkr  numeric(10,2),
  sort_order    int not null default 0,
  updated_at    timestamptz not null default now()
);

create index on public.treatments (disease_id);

create table public.tips (
  id         uuid primary key default uuid_generate_v4(),
  crop       text,
  season     text,
  title_si   text not null,
  body_si    text not null,
  title_en   text,
  body_en    text,
  published_at timestamptz not null default now()
);
```

### 4.4 Transactional tables

```sql
create table public.diagnoses (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  image_path    text,                   -- storage object path, not a URL
  disease_id    uuid references public.diseases(id),
  confidence    real check (confidence between 0 and 1),
  top_3         jsonb,                  -- [{label, confidence}, ...]
  source        diagnosis_src not null default 'on_device',
  status        diagnosis_stat not null default 'auto',
  crop_hint     text,
  district      text,
  client_uuid   uuid unique,            -- idempotency key from the phone
  created_at    timestamptz not null default now()
);

create index on public.diagnoses (user_id, created_at desc);
create index on public.diagnoses (status) where status = 'escalated';
create index on public.diagnoses (district, disease_id);

create table public.escalations (
  id            uuid primary key default uuid_generate_v4(),
  diagnosis_id  uuid not null references public.diagnoses(id) on delete cascade,
  farmer_id     uuid not null references public.profiles(id) on delete cascade,
  officer_id    uuid references public.profiles(id),
  farmer_note   text,
  officer_verdict_disease_id uuid references public.diseases(id),
  officer_response text,
  status        escalation_stat not null default 'pending',
  created_at    timestamptz not null default now(),
  claimed_at    timestamptz,
  responded_at  timestamptz
);

create index on public.escalations (status, created_at);
create index on public.escalations (officer_id);
create index on public.escalations (farmer_id);

create table public.farm_logs (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  log_date   date not null default current_date,
  activity   text not null,   -- watering | fertiliser | spraying | harvest | other
  notes      text,
  created_at timestamptz not null default now()
);

create index on public.farm_logs (user_id, log_date desc);

create table public.devices (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  fcm_token  text not null,
  platform   text,
  updated_at timestamptz not null default now(),
  unique (user_id, fcm_token)
);
```

### 4.5 Analytics view (officer dashboard)

```sql
create view public.disease_trends as
select
  d.district,
  ds.name_en   as disease,
  ds.crop,
  date_trunc('week', d.created_at) as week,
  count(*)     as case_count
from public.diagnoses d
join public.diseases ds on ds.id = d.disease_id
where d.district is not null
group by 1,2,3,4;
```

> A view inherits RLS from its underlying tables only if created with `security_invoker`. For a read-only aggregate that officers and students should see, either mark it `security_invoker = on` and grant officers broad read on `diagnoses`, or expose it through a `security definer` function that returns only aggregate rows. The second is safer — aggregates leak nothing about individual farmers.

---

## 5. Row Level Security Policies

**Turn RLS on for every table.** A table without RLS in a Supabase project is publicly readable by anyone holding the anon key, and the anon key ships inside your APK. This is the single most important section of this document.

### 5.1 Helper functions

```sql
create or replace function public.current_role()
returns user_role
language sql stable security definer set search_path = public
as $$
  select role from public.profiles where id = auth.uid();
$$;

create or replace function public.is_officer()
returns boolean
language sql stable security definer set search_path = public
as $$
  select coalesce(public.current_role() in ('officer','admin'), false);
$$;
```

### 5.2 Enable RLS everywhere

```sql
alter table public.profiles    enable row level security;
alter table public.diseases    enable row level security;
alter table public.treatments  enable row level security;
alter table public.tips        enable row level security;
alter table public.diagnoses   enable row level security;
alter table public.escalations enable row level security;
alter table public.farm_logs   enable row level security;
alter table public.devices     enable row level security;
```

### 5.3 Profiles

```sql
create policy "own profile readable"
  on public.profiles for select
  using (id = auth.uid());

create policy "officers read all profiles"
  on public.profiles for select
  using (public.is_officer());

create policy "own profile updatable"
  on public.profiles for update
  using (id = auth.uid())
  with check (id = auth.uid() and role = public.current_role());
  -- the role check stops a farmer promoting themselves to officer
```

### 5.4 Content — read-only to everyone signed in

```sql
create policy "content readable by authenticated"
  on public.diseases for select
  to authenticated using (true);

create policy "treatments readable by authenticated"
  on public.treatments for select
  to authenticated using (true);

create policy "tips readable by authenticated"
  on public.tips for select
  to authenticated using (true);

-- Writes: admins only
create policy "admins manage diseases"
  on public.diseases for all
  using (public.current_role() = 'admin')
  with check (public.current_role() = 'admin');

create policy "admins manage treatments"
  on public.treatments for all
  using (public.current_role() = 'admin')
  with check (public.current_role() = 'admin');

create policy "admins manage tips"
  on public.tips for all
  using (public.current_role() = 'admin')
  with check (public.current_role() = 'admin');
```

### 5.5 Diagnoses — the important one

```sql
create policy "farmer reads own diagnoses"
  on public.diagnoses for select
  using (user_id = auth.uid());

create policy "farmer inserts own diagnoses"
  on public.diagnoses for insert
  with check (user_id = auth.uid());

create policy "farmer updates own diagnoses"
  on public.diagnoses for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "farmer deletes own diagnoses"
  on public.diagnoses for delete
  using (user_id = auth.uid());

-- Officers see ONLY cases that were escalated to them.
-- Not all diagnoses — only the ones a farmer chose to share.
create policy "officers read escalated diagnoses"
  on public.diagnoses for select
  using (
    public.is_officer()
    and exists (
      select 1 from public.escalations e
      where e.diagnosis_id = diagnoses.id
    )
  );
```

That last policy is worth a sentence in your report. A farmer's photos are private by default; escalating is an explicit, revocable act of consent. That is a privacy-by-design decision, and it maps to the officer persona's concern about knowing which cases actually need attention.

### 5.6 Escalations

```sql
create policy "farmer reads own escalations"
  on public.escalations for select
  using (farmer_id = auth.uid());

create policy "farmer creates escalation for own diagnosis"
  on public.escalations for insert
  with check (
    farmer_id = auth.uid()
    and exists (
      select 1 from public.diagnoses d
      where d.id = diagnosis_id and d.user_id = auth.uid()
    )
  );

create policy "officers read queue"
  on public.escalations for select
  using (public.is_officer());

create policy "officers claim and respond"
  on public.escalations for update
  using (
    public.is_officer()
    and (officer_id is null or officer_id = auth.uid())
  )
  with check (
    public.is_officer()
    and officer_id = auth.uid()
  );
```

The `officer_id is null or officer_id = auth.uid()` condition prevents two officers from stepping on each other's cases — once claimed, only the claiming officer can respond.

### 5.7 Farm logs and devices — strictly private

```sql
create policy "own farm logs"
  on public.farm_logs for all
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "own devices"
  on public.devices for all
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
```

### 5.8 Keep status in sync automatically

```sql
create or replace function public.on_escalation_created()
returns trigger
language plpgsql security definer set search_path = public
as $$
begin
  update public.diagnoses
     set status = 'escalated'
   where id = new.diagnosis_id;
  return new;
end;
$$;

create trigger escalation_created
  after insert on public.escalations
  for each row execute function public.on_escalation_created();

create or replace function public.on_escalation_answered()
returns trigger
language plpgsql security definer set search_path = public
as $$
begin
  if new.status = 'answered' and old.status <> 'answered' then
    update public.diagnoses
       set status = 'reviewed',
           disease_id = coalesce(new.officer_verdict_disease_id, disease_id)
     where id = new.diagnosis_id;
  end if;
  return new;
end;
$$;

create trigger escalation_answered
  after update on public.escalations
  for each row execute function public.on_escalation_answered();
```

The officer's verdict overwrites the AI's guess. That's the correct hierarchy — and it also means your `disease_trends` view gradually becomes expert-verified data rather than model output, which is a genuinely nice property to mention in the report.

### 5.9 Testing your policies

Do not skip this. In the Supabase SQL Editor:

```sql
-- Impersonate a specific farmer
set local role authenticated;
set local request.jwt.claims = '{"sub":"<farmer-uuid>","role":"authenticated"}';

select count(*) from public.diagnoses;   -- should equal only THEIR diagnoses
select * from public.farm_logs;          -- should be only theirs

reset role;
```

Write one such check per table and paste the results into your report as evidence. Marks are available for demonstrating you tested security, not just that you configured it.

---

## 6. Storage Buckets & Policies

```sql
insert into storage.buckets (id, name, public)
values ('leaf-images', 'leaf-images', false);
```

Private bucket. Access happens through signed URLs generated by the SDK, valid for a limited window.

**Path convention:** `{user_id}/{diagnosis_client_uuid}.jpg` — the first path segment being the user ID is what makes the policies below possible.

```sql
create policy "users upload to own folder"
  on storage.objects for insert
  with check (
    bucket_id = 'leaf-images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "users read own images"
  on storage.objects for select
  using (
    bucket_id = 'leaf-images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "users delete own images"
  on storage.objects for delete
  using (
    bucket_id = 'leaf-images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "officers read escalated images"
  on storage.objects for select
  using (
    bucket_id = 'leaf-images'
    and public.is_officer()
    and exists (
      select 1
        from public.diagnoses d
        join public.escalations e on e.diagnosis_id = d.id
       where d.image_path = storage.objects.name
    )
  );
```

**Compress before upload.** 1 GB free tier sounds like a lot until 26 test users upload full-resolution 4 MB photos. Resize to max 1024px and re-encode at quality 80 in Flutter:

```dart
final compressed = await FlutterImageCompress.compressWithFile(
  file.path, minWidth: 1024, minHeight: 1024, quality: 80,
);
// ~4 MB → ~200 KB, and the model only sees 224×224 anyway
```

---

## 7. The Inference Service

The only hand-written backend left. Keep it deliberately small.

```python
# inference-service/app/main.py
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import numpy as np, tensorflow as tf, io, json

app = FastAPI(title="CropGuard Inference", version="1.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"],
                   allow_headers=["*"])

MODEL = tf.keras.models.load_model("models/crop_disease_v1.keras")
LABELS = json.load(open("models/labels.json"))
SIZE = (224, 224)

def preprocess(raw: bytes) -> np.ndarray:
    img = Image.open(io.BytesIO(raw)).convert("RGB").resize(SIZE)
    return np.expand_dims(np.asarray(img, dtype=np.float32) / 255.0, 0)

@app.get("/health")
def health():
    return {"status": "ok", "classes": len(LABELS)}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if file.content_type not in ("image/jpeg", "image/png"):
        raise HTTPException(415, "JPEG or PNG only")
    raw = await file.read()
    if len(raw) > 5 * 1024 * 1024:
        raise HTTPException(413, "Image too large")

    probs = MODEL.predict(preprocess(raw), verbose=0)[0]
    order = probs.argsort()[-3:][::-1]
    top3 = [{"label": LABELS[i], "confidence": round(float(probs[i]), 4)}
            for i in order]
    return {"label": top3[0]["label"],
            "confidence": top3[0]["confidence"],
            "top_3": top3}
```

**Deployment:** Render free tier (or Railway). Add `/health` to a free uptime monitor pinging every 10 minutes so the instance doesn't cold-start during your demo.

**Auth on this endpoint:** verify the Supabase JWT so it isn't an open image-classification API for the internet. Pass the access token as a bearer header from Flutter and validate it against your project's JWT secret.

---

## 8. Data Access Contract

Most "endpoints" are now SDK calls. Document these in `docs/data-contract.md` so all four members code against the same shapes.

| Operation | Call | Traces to |
|---|---|---|
| Sign up / sign in | `supabase.auth.signInWithOtp(email:)` | — |
| Current profile | `from('profiles').select().eq('id', uid).single()` | — |
| Save diagnosis | `from('diagnoses').insert({...})` | FR-01, FR-02 |
| Upload image | `storage.from('leaf-images').upload(path, file)` | FR-01 |
| Signed image URL | `storage.from('leaf-images').createSignedUrl(path, 3600)` | — |
| Diagnosis history | `from('diagnoses').select('*, diseases(*)').order('created_at')` | — |
| Disease catalogue | `from('diseases').select('*, treatments(*)')` | FR-05 |
| Treatment steps | filter `treatments` by `kind`, read `steps_si` | FR-04, FR-07 |
| Escalate a case | `from('escalations').insert({...})` | FR-06 |
| **Officer live queue** | `from('escalations').stream(primaryKey:['id']).eq('status','pending')` | FR-06 |
| Officer claims case | `from('escalations').update({officer_id, status:'claimed'})` | FR-06 |
| Officer responds | `from('escalations').update({officer_response, status:'answered'})` | FR-06 |
| Farm log entry | `from('farm_logs').insert({...})` | open response #7 |
| Tips feed | `from('tips').select().order('published_at')` | FR-10 |
| Cloud inference | `POST {INFERENCE_URL}/predict` | FR-02 |
| Weather | `GET api.open-meteo.com/v1/forecast?...` | FR-09 |

**Realtime officer queue in React:**

```ts
useEffect(() => {
  const channel = supabase
    .channel('escalation-queue')
    .on('postgres_changes',
        { event: '*', schema: 'public', table: 'escalations' },
        () => refetchQueue())
    .subscribe();
  return () => { supabase.removeChannel(channel); };
}, []);
```

A new farmer escalation appearing on the dashboard without a refresh is a strong 10 seconds of demo video.

---

## 9. Folder Structure

### 9.1 Repository

```
cropguard-lk/
├── README.md
├── .github/workflows/
│   ├── flutter-ci.yml
│   └── inference-ci.yml
├── docs/
│   ├── data-contract.md
│   ├── rls-policies.md
│   ├── rls-test-results.md          ← evidence for the report
│   ├── setup-guide.md
│   └── milestone-01.pdf
├── supabase/
│   ├── migrations/
│   │   ├── 001_enums.sql
│   │   ├── 002_profiles.sql
│   │   ├── 003_content.sql
│   │   ├── 004_transactional.sql
│   │   ├── 005_rls.sql
│   │   ├── 006_storage.sql
│   │   └── 007_triggers.sql
│   └── seed/
│       ├── diseases.sql             ← EN + SI + TA content
│       └── treatments.sql
├── mobile/                          # Flutter    → Members A & C
├── inference-service/               # FastAPI    → Member B
├── ml/                              # Training   → Member B
└── dashboard/                       # React      → Member D
```

### 9.2 `mobile/` — Flutter, feature-first

```
mobile/
├── pubspec.yaml
├── assets/
│   ├── models/
│   │   ├── crop_disease_v1.tflite
│   │   └── labels.txt
│   ├── fonts/
│   │   ├── NotoSansSinhala-Regular.ttf
│   │   └── NotoSansTamil-Regular.ttf
│   ├── seed/
│   │   └── diseases_bundle.json     ← ships offline content on first run
│   └── images/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/                        # no imports from features/, ever
│   │   ├── config/
│   │   │   ├── env.dart             # SUPABASE_URL, ANON_KEY, INFERENCE_URL
│   │   │   └── thresholds.dart      # 0.70 / 0.40 confidence gates
│   │   ├── supabase/
│   │   │   ├── supabase_client.dart
│   │   │   └── auth_gate.dart
│   │   ├── database/                # Drift
│   │   │   ├── app_database.dart
│   │   │   ├── tables/
│   │   │   │   ├── cached_diagnoses.dart
│   │   │   │   ├── cached_diseases.dart
│   │   │   │   └── outbox.dart
│   │   │   └── daos/
│   │   ├── sync/
│   │   │   ├── sync_service.dart
│   │   │   ├── outbox_processor.dart
│   │   │   └── connectivity_service.dart
│   │   ├── localization/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   ├── errors/
│   │   └── widgets/                 # AppButton, EmptyState, OfflineBanner
│   │
│   ├── features/
│   │   ├── onboarding/
│   │   ├── auth/
│   │   ├── diagnosis/               ◄ Member A
│   │   │   ├── data/
│   │   │   │   ├── tflite_service.dart
│   │   │   │   ├── image_preprocessor.dart
│   │   │   │   ├── inference_api.dart
│   │   │   │   └── diagnosis_repository.dart
│   │   │   ├── domain/
│   │   │   │   ├── diagnosis_result.dart
│   │   │   │   └── confidence_gate.dart   ← pure function, unit-tested
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── capture_screen.dart
│   │   │       │   ├── analyzing_screen.dart
│   │   │       │   └── result_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── confidence_badge.dart
│   │   │       │   └── photo_guide_overlay.dart
│   │   │       └── providers/
│   │   ├── history/                 ◄ Member A
│   │   ├── treatment/               ◄ Member C
│   │   ├── expert_consult/          ◄ Member D
│   │   ├── weather/                 ◄ Member D
│   │   ├── tips/                    ◄ Member D
│   │   └── farm_log/                ◄ Member D
│   │
│   └── shared/
│       ├── providers/
│       └── utils/
└── test/
    ├── unit/
    │   ├── confidence_gate_test.dart
    │   └── outbox_processor_test.dart
    └── widget/
```

**The rule that prevents merge hell:** nothing in `features/x/` may import from `features/y/`. Shared code moves up to `core/` or `shared/`, and moving it is a conversation, not a unilateral act.

### 9.3 `inference-service/`

```
inference-service/
├── requirements.txt
├── Dockerfile
├── render.yaml
├── .env.example
├── app/
│   ├── main.py
│   ├── config.py
│   ├── auth.py                      # verify Supabase JWT
│   └── preprocess.py
├── models/
│   ├── crop_disease_v1.keras
│   └── labels.json
└── tests/
    └── test_predict.py
```

### 9.4 `ml/`

```
ml/
├── notebooks/
│   ├── 01_data_exploration.ipynb
│   ├── 02_training.ipynb
│   └── 03_evaluation.ipynb
├── data/
│   ├── raw/                         # .gitignore
│   ├── processed/
│   └── field_photos/                ← your own Sri Lankan captures
├── src/
│   ├── dataset.py
│   ├── augment.py
│   ├── train.py
│   ├── evaluate.py
│   └── export_tflite.py
├── models/
└── reports/
    ├── confusion_matrix.png
    ├── per_class_metrics.csv
    └── metrics.json
```

### 9.5 `dashboard/`

```
dashboard/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── lib/
│   │   └── supabase.ts
│   ├── features/
│   │   ├── auth/
│   │   ├── review-queue/            # realtime escalation list
│   │   ├── case-detail/             # photo | AI guess | verdict form
│   │   ├── analytics/               # district & crop trends
│   │   └── content-admin/           # manage diseases/treatments
│   ├── components/
│   └── hooks/
│       ├── useRealtimeQueue.ts
│       └── useProfile.ts
└── index.html
```

---

## 10. Offline & Sync Design

This is the architectural heart of the project — it's what makes the app usable for the 38.5% with limited connectivity.

**Write-through with an outbox.** Every diagnosis writes to Drift first and returns immediately. A row also lands in an `outbox` table. When connectivity returns, `OutboxProcessor` drains it in order.

```
capture ──► TFLite ──► write to Drift ──► show result   (always, instantly)
                            │
                            └──► enqueue outbox row
                                       │
                    connectivity restored
                                       ▼
                        upload image → Storage
                        insert row  → Supabase
                        mark synced in Drift
```

**Idempotency.** Each diagnosis carries a `client_uuid` generated on the phone and stored as `unique` in Postgres. If a sync half-completes and retries, the duplicate insert fails harmlessly instead of creating two records.

**Content caching.** Ship `diseases_bundle.json` inside the APK so a brand-new user has full treatment content before ever connecting. Refresh via delta sync using `updated_at > last_sync`.

**What genuinely requires connectivity:** cloud inference fallback, escalation to an officer, weather, and the tips feed. Each of these must fail with a clear, non-alarming message and an automatic retry — never a raw error dialog. Everything else works on a plane.

---

## 11. Work Split — 4 Members

Each member owns a vertical slice: their screens, their data layer, their tests. Ownership means accountability, not exclusivity.

### Member A — DEEPTHIKA H M L S · Core Diagnosis Flow

The centrepiece of every demo. Highest risk, starts first.

- Camera capture screen with framing overlay and photo-quality guidance (Stage 3 pain point in your journey map)
- Image preprocessing: EXIF rotation fix, centre crop, resize 224×224, normalise
- TFLite integration — load model, run inference, map outputs to labels
- **Confidence gate** as a pure Dart function with unit tests covering boundaries at 0.40 and 0.70
- Analysing screen with genuine progress feedback (NFR-08)
- Result screen: disease name in the user's language, symptoms, confidence badge, "ask an officer" CTA (FR-03, NFR-04, NFR-09)
- Cloud inference fallback via `inference_api.dart` when local confidence is low and a connection exists
- Diagnosis history list and detail
- **Performance budget:** capture → result under 3 seconds on a mid-range Android (NFR-02). Measure it, record the number, put it in the report.

**Owns:** `features/diagnosis/`, `features/history/`
**Traces to:** FR-01, FR-02, FR-03, NFR-02, NFR-04, NFR-08, NFR-09

---

### Member B — KURUPPU K A S D · ML Model + Supabase Schema + Inference Service

Supabase absorbed the CRUD work, so this role now goes deeper on the model — which is the right trade, because model quality is what the project lives or dies on.

- **Dataset:** PlantVillage subset (8–12 classes across tomato, chilli, paddy, banana) **plus 200+ self-collected Sri Lankan field photos**
- Augmentation pipeline: rotation, brightness, blur, occlusion, cluttered backgrounds — this is what closes the lab-versus-field gap
- Transfer learning on MobileNetV3-Small; target ≥ 85% validation accuracy
- INT8 quantisation → `.tflite`; verify accuracy loss under 3%; hand the model plus `labels.txt` to Member A
- Confusion matrix, per-class precision/recall, error analysis for the report
- **Supabase project setup:** run all migrations, seed content, configure buckets
- **Author and test every RLS policy**; produce `docs/rls-test-results.md`
- FastAPI inference service with JWT verification, deployed to Render
- Model v2 retrain in Sprint 4 using field photos gathered during testing
- **Model Retraining Pipeline**: Script to export officer verdicts (`status = 'reviewed'`) and images to continuously retrain the model

**Owns:** `ml/`, `inference-service/`, `supabase/`
**Traces to:** FR-02, FR-05, and the entire data and security layer

---

### Member C — MADUSANKA S H S S · Offline, Sync, Localisation, Treatment Content

Implements the two largest findings from your own research.

- Drift schema: cached diagnoses, cached content, outbox
- Offline-first repository pattern — read local, refresh from Supabase opportunistically
- `OutboxProcessor` with exponential backoff, idempotent retry, and conflict handling
- Connectivity service plus a calm, persistent offline banner (never a blocking dialog)
- **Full i18n:** ARB files for `en`/`si`/`ta`, language picker in onboarding, bundled Noto fonts. **Test Sinhala rendering on a real Android 9 device in Week 1** — this breaks in unexpected ways and you do not want to find out in Week 11
- **Data Privacy & Consent:** Clear UI explaining *why* location/camera access is needed during onboarding, adhering to privacy best practices
- Treatment detail screen: step-by-step, organic/chemical/cultural tabs, precautions, estimated cost (FR-04)
- Disease comparison view for visually similar symptoms (FR-05, HMW3)
- Offline content bundle + delta sync
- Accessibility: 1.3× font scaling, minimum 48dp tap targets, icon-first navigation

**Owns:** `core/database/`, `core/sync/`, `core/localization/`, `features/treatment/`
**Traces to:** FR-04, FR-05, FR-07, FR-08, NFR-03, NFR-06

---

### Member D — AMARSURIYA E M K N · Escalation + Officer Dashboard + Support Features

Owns the second persona end to end, which gives you a two-device demo.

- **Mobile:** expert consult flow — attach diagnosis, add note, submit, track status, view officer reply
- FCM push notification when an officer responds
- **Mobile:** weather widget via Open-Meteo, district-based (FR-09)
- **Mobile:** market prices view (integrated via API or admin entry) to help farmers make financial decisions
- **Mobile:** tips feed and farm activity log (FR-10, open response #7)
- **Mobile:** onboarding, auth screens, profile, language selection UI
- **Dashboard:** officer login with role-gated routing
- **Dashboard:** realtime review queue via Supabase subscription, sorted by age
- **Dashboard:** case detail — signed image URL, AI's guess with confidence, confirm-or-override control, response composer
- **Dashboard:** district and crop trend analytics (serves your tertiary stakeholder — students and researchers)

**Owns:** `features/expert_consult|weather|tips|farm_log|auth|onboarding/`, `dashboard/`
**Traces to:** FR-06, FR-09, FR-10, NFR-01, NFR-09

---

### Shared (all four)

Design tokens agreed in Week 2 — after that, nobody hard-codes a colour. Figma wireframes for Milestone 02. Code review: no merge to `develop` without one approval. Usability testing sessions in Week 10. Final report and demo video.

---

## 12. Build Plan — 12 Weeks

### Sprint 0 · Week 1 — Foundations

| Who | Task |
|---|---|
| All | Repo, branch protection, environments green (`flutter doctor` with zero red) |
| All | App name, package ID (`lk.sliit.wd21.cropguard`), colour palette, typography |
| B | Supabase project created; migrations 001–004 applied; dataset downloaded, classes chosen |
| A | Flutter scaffold, `core/` skeleton, theme, routing |
| C | Drift setup; **Sinhala font spike on a real Android 9 device** |
| D | React + Vite scaffold, Supabase JS client connected, Figma dashboard frames |

**Exit:** every member runs the app locally; `docs/data-contract.md` drafted and signed off by all four.

### Sprint 1 · Weeks 2–3 — Vertical slices

| Who | Task |
|---|---|
| B | Baseline model trained end to end (60% accuracy is fine — prove the pipeline). RLS policies written and tested |
| A | Capture → preprocess → result screen with a **hardcoded** result |
| C | Drift schema, offline repository, language switcher working in all three languages |
| D | Auth + onboarding screens; dashboard login; empty review queue rendering |

**Exit:** app captures a photo and displays a fake diagnosis in Sinhala. RLS test results committed.

### Sprint 2 · Weeks 4–5 — Real AI

| Who | Task |
|---|---|
| B | Model at ≥85% val accuracy, TFLite exported and handed over. Inference service deployed |
| A | **Real on-device inference.** Confidence gate implemented and unit-tested |
| C | Disease + treatment seed content complete in EN/SI/TA. Treatment screen built |
| D | Escalation flow (mobile) + realtime review queue (dashboard) against live Supabase |

**Exit:** a real leaf photo produces a real diagnosis, in airplane mode. This is your midpoint proof — record a video of it.

### Sprint 3 · Weeks 6–7 — Integration

| Who | Task |
|---|---|
| B | Storage policies live; cloud inference fallback wired; model error analysis |
| A | History, cloud fallback, performance tuning against the 3-second budget |
| C | Outbox sync with retry; offline banner; delta content updates |
| D | Escalation end to end; officer verdict overwrites AI guess; FCM notifications |

**Exit:** farmer escalates → officer sees it appear live → replies → farmer receives a push notification. Demo this to your lecturer and get feedback while there's still time to act on it.

### Sprint 4 · Weeks 8–9 — Supporting features & polish

| Who | Task |
|---|---|
| D | Weather, tips feed, farm log, dashboard analytics |
| A | Photo guidance overlay, empty and error states, loading skeletons |
| C | Tamil pass, accessibility audit, font-scaling verification |
| B | Model v2 with field photos; hard-negative mining; redeploy both models |

### Sprint 5 · Week 10 — Usability testing

Recruit 5–8 participants — your 26 survey respondents are a ready pool, and re-contacting them strengthens the research narrative. Run task-based sessions:

> *"Your tomato leaves have brown spots. Find out what's wrong and what you should do about it."*

Measure task completion rate, time on task, error count, and assists required. Record observations rather than opinions. Produce a prioritised fix list (P0/P1/P2). This is your direct evidence for LO6.

### Sprint 6 · Weeks 11–12 — Fixes, report, demo

Fix all P0 and P1 issues. Write the report with before-and-after usability evidence. Record a five-minute demo showing phone and dashboard side by side, including one offline diagnosis and one live escalation. Tag a release and produce a signed APK.

---

## 13. Git Workflow & Conventions

```
main            ← protected, release tags only
└── develop     ← integration branch, all PRs target this
    ├── feat/diagnosis-tflite          (A)
    ├── feat/ml-training               (B)
    ├── feat/offline-outbox            (C)
    └── feat/officer-dashboard         (D)
```

**Commits:** `feat(diagnosis): add confidence badge to result screen`
**Rules:** no direct pushes to `develop`; one approving review per PR; rebase before opening.

**`.gitignore` must cover:** `ml/data/raw/`, `.env`, `*.keystore`, `build/`, `**/service-account.json`.

**A note on the anon key:** the Supabase anon key is designed to be public and will sit in your APK — that is expected and fine, *provided RLS is enabled on every table*. The `service_role` key is the opposite: it bypasses RLS entirely and must never appear in the mobile app, the dashboard, or the repository. It belongs only in the inference service's server-side environment variables, if it's needed there at all.

---

## 14. Definition of Done

A feature is done when it works offline or degrades gracefully with a clear message; renders correctly in Sinhala at 1.3× font scale; has visible loading, empty, and error states; has at least one unit test on its business logic; integration tests pass for core offline flows (e.g. Outbox); passes `flutter analyze` with no warnings; is reviewed and merged to `develop`; and is traced to an FR or NFR ID in the report.

---

## 15. Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Model accuracy collapses on real field photos | **High** | Field photos from Week 1; heavy augmentation; the confidence gate degrades to escalation rather than a confident wrong answer |
| RLS misconfigured — data leaks between farmers | **High impact** | Policies written in Sprint 1, not late; documented test results per table; never ship a table with RLS disabled |
| Sinhala fonts break on older Android | Medium | Bundle Noto explicitly; test on Android 9 in Week 1 |
| Supabase free project pauses after ~7 days idle | Medium | Weekly activity; restore and verify the day before any demo |
| Inference service cold start delays the demo | Medium | Uptime monitor pinging `/health` every 10 minutes |
| Storage quota exhausted by test uploads | Low | Client-side compression to ~200 KB; periodic cleanup of test data |
| Phone OTP SMS costs money | Medium | Use email magic links for the academic build; document phone OTP as the production design |
| One member's slice blocks the others | Medium | Vertical slices, mocked dependencies, weekly 20-minute sync |
| Officer dashboard descoped under time pressure | Medium | Build the review queue in Sprint 2 — it carries the second persona and real marks |

---

## 16. Requirements Traceability

| Req | Implemented by | Member |
|---|---|---|
| FR-01 capture/upload photo | `capture_screen.dart` + Storage upload | A |
| FR-02 analyse image | TFLite on-device + `/predict` fallback | A, B |
| FR-03 show disease + confidence | `result_screen.dart`, `confidence_badge.dart` | A |
| FR-04 treatment recommendations | `treatments` table, treatment screen | C |
| FR-05 symptoms & comparison | `diseases` table, comparison view | C |
| FR-06 expert escalation | `escalations` + realtime dashboard | D |
| FR-07 Sinhala content | ARB files + `*_si` columns | C |
| FR-08 offline identification | TFLite + Drift + outbox | A, C |
| FR-09 weather updates | Open-Meteo integration | D |
| FR-10 farming tips | `tips` table + feed | D |
| NFR-01 simple interface | Design system, icon-first navigation | All |
| NFR-02 fast response | 3-second budget, measured | A |
| NFR-03 poor connectivity | Offline-first architecture | C |
| NFR-04 clear results | Result screen hierarchy | A |
| NFR-05 reliable information | Officer verdict overwrites AI guess | B, D |
| NFR-06 Sinhala accessible | Bundled fonts, full i18n | C |
| NFR-07 lightweight | INT8 quantised model (~4 MB) | B |
| NFR-08 clear feedback | Analysing screen, sync indicators | A, C |
| NFR-09 transparency | Confidence gate + escalation path | A, D |

---

## 17. Immediate Next Actions

1. Create the GitHub org and repo; add all four members; protect `main` and `develop`.
2. Create the Supabase project. Member B runs migrations 001–004 today.
3. Confirm the app name and package ID before anyone generates a project.
4. Member B: download PlantVillage and finalise the disease class list.
5. Member C: bundle Noto Sans Sinhala and render a test string on a real Android 9 device. If this fails, you need to know now.
6. All four: sign off `docs/data-contract.md`.
7. **Book the first field-photo collection trip.** It's the longest-lead item in the entire project and everything downstream depends on it.

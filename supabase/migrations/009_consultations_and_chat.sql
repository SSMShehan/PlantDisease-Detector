-- ============================================================
-- Migration: 009_consultations_and_chat.sql
-- Creates consultation sessions and real-time messages tables
-- ============================================================

-- Consultations table: links a scan (case) to an officer chat session
CREATE TABLE IF NOT EXISTS public.consultations (
  id              uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  scan_id         uuid REFERENCES public.scans(id) ON DELETE CASCADE,
  farmer_id       uuid REFERENCES public.profiles(id) ON DELETE CASCADE,
  officer_id      uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  status          text NOT NULL DEFAULT 'pending', -- pending | open | resolved
  disease_name    text,
  severity        text,
  image_url       text,
  location        text,
  notes           text,
  created_at      timestamptz DEFAULT now(),
  resolved_at     timestamptz,
  updated_at      timestamptz DEFAULT now()
);

-- Messages table: real-time chat messages per consultation
CREATE TABLE IF NOT EXISTS public.consultation_messages (
  id                 uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  consultation_id    uuid REFERENCES public.consultations(id) ON DELETE CASCADE NOT NULL,
  sender_id          uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  sender_role        text NOT NULL DEFAULT 'farmer', -- farmer | officer
  content            text NOT NULL,
  created_at         timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.consultations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consultation_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for consultations
DROP POLICY IF EXISTS "Farmers can view their own consultations" ON consultations;
CREATE POLICY "Farmers can view their own consultations"
  ON consultations FOR SELECT USING (auth.uid() = farmer_id);

DROP POLICY IF EXISTS "Officers can view all consultations" ON consultations;
CREATE POLICY "Officers can view all consultations"
  ON consultations FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'officer'
    )
  );

DROP POLICY IF EXISTS "Farmers can insert consultations" ON consultations;
CREATE POLICY "Farmers can insert consultations"
  ON consultations FOR INSERT WITH CHECK (auth.uid() = farmer_id);

DROP POLICY IF EXISTS "Officers can update consultations" ON consultations;
CREATE POLICY "Officers can update consultations"
  ON consultations FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'officer'
    )
  );

DROP POLICY IF EXISTS "Farmers can update own consultations" ON consultations;
CREATE POLICY "Farmers can update own consultations"
  ON consultations FOR UPDATE USING (auth.uid() = farmer_id);

-- RLS Policies for consultation_messages
DROP POLICY IF EXISTS "Participants can view messages" ON consultation_messages;
CREATE POLICY "Participants can view messages"
  ON consultation_messages FOR SELECT USING (
    auth.uid() = sender_id OR
    EXISTS (
      SELECT 1 FROM public.consultations c
      WHERE c.id = consultation_id AND (c.farmer_id = auth.uid() OR c.officer_id = auth.uid())
    ) OR
    EXISTS (
      SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'officer'
    )
  );

DROP POLICY IF EXISTS "Participants can insert messages" ON consultation_messages;
CREATE POLICY "Participants can insert messages"
  ON consultation_messages FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND (
      EXISTS (
        SELECT 1 FROM public.consultations c
        WHERE c.id = consultation_id AND (c.farmer_id = auth.uid() OR c.officer_id = auth.uid())
      ) OR
      EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'officer'
      )
    )
  );

-- Enable Realtime for messages table
ALTER PUBLICATION supabase_realtime ADD TABLE public.consultation_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.consultations;

-- Index for fast lookup
CREATE INDEX IF NOT EXISTS idx_consultations_farmer ON public.consultations(farmer_id);
CREATE INDEX IF NOT EXISTS idx_consultations_officer ON public.consultations(officer_id);
CREATE INDEX IF NOT EXISTS idx_consultations_status ON public.consultations(status);
CREATE INDEX IF NOT EXISTS idx_messages_consultation ON public.consultation_messages(consultation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created ON public.consultation_messages(created_at);

-- Trigger to update updated_at on consultations
CREATE OR REPLACE FUNCTION update_consultation_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS set_consultation_updated_at ON public.consultations;
CREATE TRIGGER set_consultation_updated_at
  BEFORE UPDATE ON public.consultations
  FOR EACH ROW EXECUTE FUNCTION update_consultation_updated_at();

NOTIFY pgrst, 'reload schema';

-- ============================================================
-- Migration: 010_admin_dashboard_tables.sql
-- Creates the 5 new tables needed for the React Admin Dashboard
-- ============================================================

-- 1. Regions (Agricultural Zones)
CREATE TABLE IF NOT EXISTS public.regions (
  id              uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  name            text NOT NULL,
  province        text NOT NULL,
  district        text,
  area_km2        numeric,
  officer_count   integer DEFAULT 0,
  farmer_count    integer DEFAULT 0,
  is_active       boolean DEFAULT true,
  created_at      timestamptz DEFAULT now(),
  updated_at      timestamptz DEFAULT now()
);

-- 2. Crop Categories
CREATE TABLE IF NOT EXISTS public.crop_categories (
  id              uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  name            text NOT NULL,
  name_si         text,
  name_ta         text,
  icon_url        text,
  season          text,
  is_active       boolean DEFAULT true,
  sort_order      integer DEFAULT 0,
  created_at      timestamptz DEFAULT now()
);

-- 3. Announcements (Push Notifications to Mobile App)
CREATE TABLE IF NOT EXISTS public.announcements (
  id              uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  title           text NOT NULL,
  body            text NOT NULL,
  image_url       text,
  category        text DEFAULT 'General',
  target_role     text DEFAULT 'all', -- 'all', 'farmer', 'officer'
  target_district text,               -- null means all districts
  is_published    boolean DEFAULT false,
  published_at    timestamptz,
  created_by      uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at      timestamptz DEFAULT now(),
  updated_at      timestamptz DEFAULT now()
);

-- 4. Feedback & Bug Reports
CREATE TABLE IF NOT EXISTS public.feedback (
  id              uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id         uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  type            text NOT NULL DEFAULT 'feedback', -- 'feedback', 'bug', 'feature_request'
  subject         text,
  message         text NOT NULL,
  status          text NOT NULL DEFAULT 'open',     -- 'open', 'in_progress', 'resolved', 'wontfix'
  priority        text NOT NULL DEFAULT 'normal',   -- 'low', 'normal', 'high', 'critical'
  admin_notes     text,
  resolved_at     timestamptz,
  created_at      timestamptz DEFAULT now(),
  updated_at      timestamptz DEFAULT now()
);

-- 5. System Settings (Dynamic Configuration)
CREATE TABLE IF NOT EXISTS public.system_settings (
  key             text PRIMARY KEY,
  value           text NOT NULL,
  label           text,
  description     text,
  data_type       text DEFAULT 'string', -- 'string', 'number', 'boolean', 'json'
  category        text DEFAULT 'General',
  updated_by      uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  updated_at      timestamptz DEFAULT now()
);

-- ============================================================
-- Indexes
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_regions_province ON public.regions(province);
CREATE INDEX IF NOT EXISTS idx_announcements_published ON public.announcements(is_published, published_at);
CREATE INDEX IF NOT EXISTS idx_feedback_status ON public.feedback(status);
CREATE INDEX IF NOT EXISTS idx_feedback_type ON public.feedback(type);

-- ============================================================
-- Row Level Security (RLS)
-- Note: Admin Dashboard uses the regular anon key but relies on 
-- policies checking `role = 'admin'`
-- ============================================================

ALTER TABLE public.regions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crop_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;

-- Regions (Read: All, Write: Admin)
CREATE POLICY "Anyone can read regions" ON regions FOR SELECT USING (true);
CREATE POLICY "Admins can manage regions" ON regions FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Crop Categories (Read: All, Write: Admin)
CREATE POLICY "Anyone can read crop_categories" ON crop_categories FOR SELECT USING (true);
CREATE POLICY "Admins can manage crop_categories" ON crop_categories FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Announcements (Read: Published or Admin, Write: Admin)
CREATE POLICY "Users can read published announcements" ON announcements FOR SELECT USING (
  is_published = true OR 
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Admins can manage announcements" ON announcements FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Feedback (Read: Own or Admin, Write: Authenticated, Update/Delete: Admin)
CREATE POLICY "Users can view their own feedback" ON feedback FOR SELECT USING (
  auth.uid() = user_id OR 
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Users can submit feedback" ON feedback FOR INSERT WITH CHECK (
  auth.uid() = user_id
);
CREATE POLICY "Admins can manage feedback" ON feedback FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Admins can delete feedback" ON feedback FOR DELETE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- System Settings (Read: All, Write: Admin)
CREATE POLICY "Anyone can read system_settings" ON system_settings FOR SELECT USING (true);
CREATE POLICY "Admins can manage system_settings" ON system_settings FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- ============================================================
-- Realtime Subscriptions
-- ============================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.feedback;

NOTIFY pgrst, 'reload schema';

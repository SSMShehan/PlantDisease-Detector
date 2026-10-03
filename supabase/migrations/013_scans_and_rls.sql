-- 1. Create policy for Admins to view all consultations
DROP POLICY IF EXISTS "Admins can view all consultations" ON consultations;
CREATE POLICY "Admins can view all consultations"
  ON consultations FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- 2. Create policy for Admins to view all scans
DROP POLICY IF EXISTS "Admins can view all scans" ON scans;
CREATE POLICY "Admins can view all scans"
  ON scans FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- 3. Create some mock scans for the dashboard chart to show real data.
-- We will insert random scans for the past 7 days.
DO $$
DECLARE
  farmer_uuid uuid;
  i int;
  d timestamptz;
BEGIN
  -- Get the first farmer
  SELECT id INTO farmer_uuid FROM public.profiles WHERE role = 'farmer' LIMIT 1;
  
  IF farmer_uuid IS NOT NULL THEN
    FOR i IN 0..6 LOOP
      d := now() - (i || ' days')::interval;
      -- insert multiple scans per day
      FOR j IN 1..(floor(random() * 20 + 10)) LOOP
        INSERT INTO public.scans (user_id, disease_name, latin_name, crop_type, confidence_score, severity, treatable, scanned_at)
        VALUES (
          farmer_uuid, 
          'Tomato Early Blight', 
          'Alternaria solani', 
          'Tomato', 
          0.85, 
          'medium', 
          true, 
          d
        );
      END LOOP;
    END LOOP;
  END IF;
END $$;

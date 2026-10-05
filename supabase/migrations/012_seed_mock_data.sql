-- Seed realistic mock data for the university assignment
-- This runs as postgres superuser, bypassing RLS.

-- 1. Update Profiles with realistic names and info
UPDATE public.profiles 
SET full_name = 'Nimal Perera', email = 'nimal.p@example.com', district = 'Kandy', farm_name = 'Green Valley Farms', phone = '+94712345678' 
WHERE role = 'farmer';

UPDATE public.profiles 
SET full_name = 'Dr. Sunimal Silva', email = 'sunimal.s@agri.gov.lk', district = 'Nuwara Eliya', phone = '+94776543210' 
WHERE role = 'officer';

-- 2. Seed Crop Categories
INSERT INTO public.crop_categories (name, name_si, season, is_active) VALUES
('Tomato', 'තක්කාලි', 'Yala & Maha', true),
('Potato', 'අර්තාපල්', 'Maha', true),
('Rice', 'වී', 'Yala & Maha', true);

-- 3. Seed Announcements
INSERT INTO public.announcements (title, body, category, target_role, is_published, published_at) VALUES
('New Disease Alert: Tomato Blight', 'Please advise farmers to watch out for early signs of blight due to recent rains.', 'Alert', 'officer', true, now()),
('System Maintenance', 'The Lumina AI API will be down for 2 hours this Sunday.', 'System', 'all', true, now());

-- 4. Seed Feedback
INSERT INTO public.feedback (type, message, status, priority) VALUES
('bug', 'The camera scan freezes on my older Android device.', 'open', 'high'),
('feedback', 'I love the new UI, but Sinhalese translations are missing in some parts.', 'in_progress', 'normal');

-- 5. Seed Regions
INSERT INTO public.regions (name, province, district, area_km2, farmer_count) VALUES
('Kandy Central', 'Central', 'Kandy', 120, 3450),
('Nuwara Eliya North', 'Central', 'Nuwara Eliya', 85, 2100);

-- 6. Seed System Settings
INSERT INTO public.system_settings (key, value, label, description, data_type) VALUES
('ALLOW_PUBLIC_REGISTRATION', 'true', 'Allow Public Registration', 'Can anyone create a farmer account?', 'boolean'),
('MAX_SCAN_LIMIT', '50', 'Daily Scan Limit', 'Maximum disease scans per day per farmer', 'number')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- 7. Seed Diseases and Treatments (using DO block to handle UUIDs)
DO $$
DECLARE
  disease1_id uuid;
  disease2_id uuid;
  farmer_uuid uuid;
BEGIN
  -- Insert diseases and get IDs
  INSERT INTO public.diseases (name_en, name_si, name_ta, crop, model_label) VALUES ('Tomato Bacterial Spot', 'තක්කාලි බැක්ටීරියා ලප', 'தக்காளி பாக்டீரியா புள்ளி', 'Tomato', 'Tomato___Bacterial_spot') RETURNING id INTO disease1_id;
  INSERT INTO public.diseases (name_en, name_si, name_ta, crop, model_label) VALUES ('Potato Early Blight', 'අර්තාපල් මුල් අංගමාරය', 'உருளைக்கிழங்கு ஆரம்ப கருகல்', 'Potato', 'Potato___Early_blight') RETURNING id INTO disease2_id;

  -- Insert treatments
  INSERT INTO public.treatments (disease_id, kind, steps_en, steps_si, steps_ta, sort_order) VALUES (disease1_id, 'chemical', 'Apply copper-based fungicides immediately.', 'වහාම කොපර් අඩංගු දිලීර නාශක යොදන්න.', 'உடனடியாக காப்பர் பூசணக்கொல்லிகளைப் பயன்படுத்துங்கள்.', 1);
  INSERT INTO public.treatments (disease_id, kind, steps_en, steps_si, steps_ta, sort_order) VALUES (disease2_id, 'chemical', 'Apply chlorothalonil or mancozeb.', 'ක්ලෝරොතලෝනිල් හෝ මන්කොසෙබ් යොදන්න.', 'குளோரோதலோனில் அல்லது மாங்கோசெப் பயன்படுத்தவும்.', 1);

  -- Get the first farmer
  SELECT id INTO farmer_uuid FROM public.profiles WHERE role = 'farmer' LIMIT 1;

  -- Insert consultations
  IF farmer_uuid IS NOT NULL THEN
    INSERT INTO public.consultations (farmer_id, disease_name, status) VALUES (farmer_uuid, 'Tomato Bacterial Spot', 'pending');
    INSERT INTO public.consultations (farmer_id, disease_name, status) VALUES (farmer_uuid, 'Potato Early Blight', 'resolved');
  END IF;
END $$;

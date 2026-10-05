-- 1. Update profiles table with new fields
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS farm_name text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS farm_size text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS bio text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS primary_crops text[];
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS avatar_url text;

-- 2. Update diseases table with new fields
ALTER TABLE public.diseases ADD COLUMN IF NOT EXISTS description text;
ALTER TABLE public.diseases ADD COLUMN IF NOT EXISTS symptoms text[];
ALTER TABLE public.diseases ADD COLUMN IF NOT EXISTS causes text[];
ALTER TABLE public.diseases ADD COLUMN IF NOT EXISTS treatments text[];

-- Ensure buckets exist
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT DO NOTHING;

-- Avatars bucket policies
CREATE POLICY "Avatar images are publicly accessible."
  ON storage.objects FOR SELECT
  USING ( bucket_id = 'avatars' );

CREATE POLICY "Anyone can upload an avatar."
  ON storage.objects FOR INSERT
  WITH CHECK ( bucket_id = 'avatars' );

CREATE POLICY "Anyone can update their own avatar."
  ON storage.objects FOR UPDATE
  USING ( bucket_id = 'avatars' );

-- 3. Seed data for the 5 Sri Lankan diseases
-- Clear existing to avoid duplicates if re-run
DELETE FROM public.diseases WHERE name_en IN ('Rice Blast', 'Blister Blight', 'Early Blight', 'Papaya Ringspot Virus (PRSV)', 'White Root Disease');

INSERT INTO public.diseases (model_label, crop, name_en, name_si, name_ta, severity, reference_image_url, description, symptoms, causes, treatments) VALUES 
(
  'rice_blast', 'Paddy / Rice', 'Rice Blast', 'ගොයම් පිපිරීම', 'நெல்லின் குலை நோய்', 'high', 
  'https://images.unsplash.com/photo-1596541570197-047cf395bc24?q=80&w=800&auto=format&fit=crop',
  'Rice blast is one of the most destructive diseases of rice worldwide and a major threat to paddy cultivation in Sri Lanka. It can affect all above-ground parts of the plant.',
  ARRAY['Diamond-shaped lesions on leaves with gray centers and dark borders.', 'Lesions on the neck of the panicle causing it to rot and break over (neck blast).', 'Stunted growth and empty grains.'],
  ARRAY['Caused by the fungus Magnaporthe oryzae.', 'High humidity and frequent, prolonged rain showers.', 'Excessive nitrogen fertilization.'],
  ARRAY['Use blast-resistant rice varieties recommended by the Department of Agriculture.', 'Apply nitrogen fertilizers in split doses rather than all at once.', 'Apply systemic fungicides such as Tricyclazole or Isoprothiolane at the first sign of symptoms.', 'Maintain proper field sanitation by destroying infected crop residue.']
),
(
  'blister_blight', 'Tea', 'Blister Blight', 'තේ බිබිලි රෝගය', 'தேயிலை கொப்புள நோய்', 'high',
  'https://images.unsplash.com/photo-1557999813-f61b3692be2c?q=80&w=800&auto=format&fit=crop',
  'A highly destructive leaf disease affecting tea plantations, especially in the hill country of Sri Lanka during monsoon seasons. It affects the young harvestable shoots.',
  ARRAY['Translucent spots on young leaves that later become circular.', 'Blister-like swellings on the underside of the leaf, which eventually turn white and powdery.', 'Curling and distortion of young shoots.'],
  ARRAY['Caused by the fungus Exobasidium vexans.', 'Thrives in high humidity, low sunlight, and misty conditions typical of up-country Sri Lanka.'],
  ARRAY['Modify shade in the plantation to increase sunlight penetration.', 'Adjust plucking rounds (shorter intervals) during the wet season to remove infected shoots early.', 'Spray copper-based fungicides (like Copper Oxychloride) immediately after plucking.']
),
(
  'early_blight', 'Tomato', 'Early Blight', 'මුල් අංගමාරය', 'ஆரம்ப கருகல் நோய்', 'medium',
  'https://images.unsplash.com/photo-1592841200221-a6898f307baa?q=80&w=800&auto=format&fit=crop',
  'A very common fungal disease affecting tomato plants across Sri Lanka, leading to significant defoliation and yield reduction if left unchecked.',
  ARRAY['Dark, concentric rings (target-like spots) on older, lower leaves.', 'Yellowing of the tissue surrounding the spots.', 'Dark, sunken lesions on stems and fruit rot at the stem end.'],
  ARRAY['Caused by the fungus Alternaria solani.', 'Survives in soil and plant debris; spread by wind and splashing rain.', 'Warm, humid weather followed by dry spells.'],
  ARRAY['Practice crop rotation (do not plant tomatoes or potatoes in the same soil consecutively).', 'Stake or cage plants to keep foliage off the ground and improve air circulation.', 'Apply organic mulches to prevent soil from splashing onto leaves.', 'Use protectant fungicides like Mancozeb or Chlorothalonil preventatively.']
),
(
  'prsv', 'Papaya', 'Papaya Ringspot Virus (PRSV)', 'පැපොල් මුදු පුල්ලි වෛරසය', 'பப்பாளி வளையப் புள்ளி வைரஸ்', 'high',
  'https://images.unsplash.com/photo-1616688753890-482a87474400?q=80&w=800&auto=format&fit=crop',
  'A devastating viral disease that severely impacts papaya cultivation in Sri Lanka, causing drastic reductions in fruit yield and quality.',
  ARRAY['Yellow mottling and severe distortion of leaves.', 'Distinct dark green rings or spots on the fruit surface.', 'Water-soaked streaks on the leaf stalks and upper stem.'],
  ARRAY['Transmitted by several species of aphids (insects).', 'Spread rapidly when infected plants are left in the field.'],
  ARRAY['There is no chemical cure for the virus.', 'Immediately uproot and destroy (burn) infected plants to prevent the virus from spreading.', 'Control aphid populations using insecticidal soaps or neem oil.', 'Plant PRSV-tolerant or resistant papaya varieties if available.']
),
(
  'white_root_disease', 'Rubber', 'White Root Disease', 'සුදු මුල් රෝගය', 'வெள்ளை வேர் நோய்', 'high',
  'https://images.unsplash.com/photo-1610408544577-09d9f582776c?q=80&w=800&auto=format&fit=crop',
  'One of the most lethal root diseases affecting rubber plantations in Sri Lanka. It spreads underground and can wipe out entire patches of trees.',
  ARRAY['Yellowing and premature shedding of leaves.', 'White, thread-like fungal mycelium on the surface of the roots.', 'Wood of the root becomes soft and rotted, eventually killing the tree.'],
  ARRAY['Caused by the fungus Rigidoporus microporus.', 'Spreads via root contact from infected stumps left in the soil from previous clearings.'],
  ARRAY['Thoroughly clear and burn old infected stumps and roots before replanting.', 'Isolate infected trees by digging isolation trenches (at least 2 feet deep) around them.', 'Apply sulfur to the soil around infected areas to alter the soil pH, which inhibits fungal growth.', 'Drench the root zone with recommended systemic fungicides in early stages of infection.']
);

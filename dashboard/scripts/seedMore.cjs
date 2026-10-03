const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://zoqameluujemvtpfbrmm.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvcWFtZWx1dWplbXZ0cGZicm1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk0OTQxNzIsImV4cCI6MjEwNTA3MDE3Mn0.i-zPCIfhKMLCKJXcGzGYsOxJJ0AH7Sd0oxueIPtVWZE'
);

async function seedMore() {
  console.log('Seeding more mock data...');
  
  // Get farmer and officer
  const { data: profiles } = await supabase.from('profiles').select('*');
  const farmer = profiles?.find(p => p.role === 'farmer');
  const officer = profiles?.find(p => p.role === 'officer');

  // 1. Seed Consultations (Cases)
  if (farmer) {
    const cases = [
      { farmer_id: farmer.id, disease_name: 'Tomato Bacterial Spot', status: 'pending' },
      { farmer_id: farmer.id, disease_name: 'Potato Early Blight', status: 'resolved' },
    ];
    for (const c of cases) {
      await supabase.from('consultations').insert(c);
    }
    console.log('Consultations seeded.');
  }

  // 2. Seed Regions
  const regions = [
    { name: 'Kandy Central', province: 'Central', district: 'Kandy', area_km2: 120, farmer_count: 3450 },
    { name: 'Nuwara Eliya North', province: 'Central', district: 'Nuwara Eliya', area_km2: 85, farmer_count: 2100 }
  ];
  for (const r of regions) {
    await supabase.from('regions').insert(r);
  }
  console.log('Regions seeded.');

  // 3. Seed System Settings
  const settings = [
    { key: 'ALLOW_PUBLIC_REGISTRATION', value: 'true', label: 'Allow Public Registration', description: 'Can anyone create a farmer account?', data_type: 'boolean' },
    { key: 'MAX_SCAN_LIMIT', value: '50', label: 'Daily Scan Limit', description: 'Maximum disease scans per day per farmer', data_type: 'number' }
  ];
  for (const s of settings) {
    await supabase.from('system_settings').upsert(s);
  }
  console.log('System settings seeded.');

  // 4. Seed Treatments (need diseases first)
  const diseases = [
    { name_en: 'Tomato Bacterial Spot', crop: 'Tomato', model_label: 'Tomato___Bacterial_spot' },
    { name_en: 'Potato Early Blight', crop: 'Potato', model_label: 'Potato___Early_blight' }
  ];
  for (const d of diseases) {
    const { data: dResponse } = await supabase.from('diseases').insert(d).select();
    if (dResponse && dResponse[0]) {
      await supabase.from('treatments').insert({
        disease_id: dResponse[0].id,
        kind: 'chemical',
        steps_en: 'Apply copper-based fungicides immediately.',
        sort_order: 1
      });
    }
  }
  console.log('Diseases and Treatments seeded.');

  console.log('All done!');
}

seedMore().catch(console.error);

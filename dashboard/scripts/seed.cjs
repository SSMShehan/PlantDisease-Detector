const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://zoqameluujemvtpfbrmm.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvcWFtZWx1dWplbXZ0cGZicm1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk0OTQxNzIsImV4cCI6MjEwNTA3MDE3Mn0.i-zPCIfhKMLCKJXcGzGYsOxJJ0AH7Sd0oxueIPtVWZE'
);

async function seed() {
  console.log('Seeding mock data...');
  
  // 1. Seed some crop categories
  const crops = [
    { name: 'Tomato', name_si: 'තක්කාලි', season: 'Yala & Maha', is_active: true },
    { name: 'Potato', name_si: 'අර්තාපල්', season: 'Maha', is_active: true },
    { name: 'Rice', name_si: 'වී', season: 'Yala & Maha', is_active: true }
  ];
  
  for (const c of crops) {
    await supabase.from('crop_categories').insert(c);
  }
  console.log('Crops seeded.');

  // 2. Seed Announcements
  const announcements = [
    { title: 'New Disease Alert: Tomato Blight', body: 'Please advise farmers to watch out for early signs of blight due to recent rains.', category: 'Alert', target_role: 'officer', is_published: true, published_at: new Date().toISOString() },
    { title: 'System Maintenance', body: 'The Lumina AI API will be down for 2 hours this Sunday.', category: 'System', target_role: 'all', is_published: true, published_at: new Date().toISOString() }
  ];
  for (const a of announcements) {
    await supabase.from('announcements').insert(a);
  }
  console.log('Announcements seeded.');

  // 3. Seed Feedback
  const feedbacks = [
    { type: 'bug', message: 'The camera scan freezes on my older Android device.', status: 'open', priority: 'high' },
    { type: 'feedback', message: 'I love the new UI, but Sinhalese translations are missing in some parts.', status: 'in_progress', priority: 'normal' }
  ];
  for (const f of feedbacks) {
    await supabase.from('feedback').insert(f);
  }
  console.log('Feedback seeded.');

  // 4. Update the profiles to have realistic fake names and districts
  // We'll update the existing ones
  const { data: profiles } = await supabase.from('profiles').select('*');
  if (profiles) {
    for (const p of profiles) {
      if (p.role === 'farmer') {
        await supabase.from('profiles').update({
          full_name: 'Nimal Perera',
          email: 'nimal.p@example.com',
          district: 'Kandy',
          farm_name: 'Green Valley Farms',
          phone: '+94712345678'
        }).eq('id', p.id);
      } else if (p.role === 'officer') {
        await supabase.from('profiles').update({
          full_name: 'Dr. Sunimal Silva',
          email: 'sunimal.s@agri.gov.lk',
          district: 'Nuwara Eliya',
          phone: '+94776543210'
        }).eq('id', p.id);
      }
    }
    console.log('Profiles updated with realistic data.');
  }

  console.log('Done!');
}

seed().catch(console.error);

-- Enable Realtime for all tables so the Admin Dashboard stays synced instantly
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.diseases;
ALTER PUBLICATION supabase_realtime ADD TABLE public.treatments;
ALTER PUBLICATION supabase_realtime ADD TABLE public.crop_categories;
ALTER PUBLICATION supabase_realtime ADD TABLE public.announcements;
ALTER PUBLICATION supabase_realtime ADD TABLE public.regions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.system_settings;

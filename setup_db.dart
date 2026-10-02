import 'dart:io';
import 'package:postgres/postgres.dart';

void main() async {
  print('Connecting to database...');
  final connection = PostgreSQLConnection(
    'db.zoqameluujemvtpfbrmm.supabase.co',
    5432,
    'postgres',
    username: 'postgres',
    password: 'zUVppiZDGEdyzL7H',
    useSSL: true,
  );

  try {
    await connection.open();
    print('Connected successfully!');

    final statements = [
      'DROP TABLE IF EXISTS public.community_likes CASCADE',
      'DROP TABLE IF EXISTS public.community_comments CASCADE',
      'DROP TABLE IF EXISTS public.community_posts CASCADE',
      '''
CREATE TABLE public.community_posts (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  title text,
  content text not null,
  image_url text,
  category text default 'General',
  likes_count integer default 0,
  comments_count integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now())
)
      ''',
      '''
CREATE TABLE public.community_comments (
  id uuid default uuid_generate_v4() primary key,
  post_id uuid references public.community_posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  content text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
)
      ''',
      '''
CREATE TABLE public.community_likes (
  id uuid default uuid_generate_v4() primary key,
  post_id uuid references public.community_posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  unique(post_id, user_id)
)
      ''',
      'alter table public.community_posts enable row level security',
      'drop policy if exists "Posts viewable by everyone." on community_posts',
      'create policy "Posts viewable by everyone." on community_posts for select using (true)',
      'drop policy if exists "Users can insert their own posts." on community_posts',
      'create policy "Users can insert their own posts." on community_posts for insert with check (auth.uid() = user_id)',
      
      'alter table public.community_comments enable row level security',
      'drop policy if exists "Comments viewable by everyone." on community_comments',
      'create policy "Comments viewable by everyone." on community_comments for select using (true)',
      'drop policy if exists "Users can insert their own comments." on community_comments',
      'create policy "Users can insert their own comments." on community_comments for insert with check (auth.uid() = user_id)',
      
      'alter table public.community_likes enable row level security',
      'drop policy if exists "Likes viewable by everyone." on community_likes',
      'create policy "Likes viewable by everyone." on community_likes for select using (true)',
      'drop policy if exists "Users can insert their own likes." on community_likes',
      'create policy "Users can insert their own likes." on community_likes for insert with check (auth.uid() = user_id)',
      'drop policy if exists "Users can delete their own likes." on community_likes',
      'create policy "Users can delete their own likes." on community_likes for delete using (auth.uid() = user_id)',
      
      '''
CREATE OR REPLACE FUNCTION increment_like(pid uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS \$\$
  UPDATE public.community_posts SET likes_count = likes_count + 1 WHERE id = pid;
\$\$
      ''',
      '''
CREATE OR REPLACE FUNCTION decrement_like(pid uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS \$\$
  UPDATE public.community_posts SET likes_count = GREATEST(likes_count - 1, 0) WHERE id = pid;
\$\$
      ''',
      '''
CREATE OR REPLACE FUNCTION increment_comment(pid uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS \$\$
  UPDATE public.community_posts SET comments_count = comments_count + 1 WHERE id = pid;
\$\$
      ''',
      "NOTIFY pgrst, 'reload schema'"
    ];

    print('Running SQL setup...');
    for (var i = 0; i < statements.length; i++) {
      try {
        await connection.query(statements[i]);
        print('Executed statement \${i + 1}/\${statements.length}');
      } catch (e) {
        print('Error on statement \${i + 1}: \$e');
        // Stop execution if a core table fails
        if (i < 6) rethrow; 
      }
    }
    
    print('SQL Setup completed successfully! All tables created.');
  } catch (e) {
    print('Fatal Error: \$e');
  } finally {
    await connection.close();
  }
}

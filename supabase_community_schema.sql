-- Drop existing tables to fix the foreign key issue
DROP TABLE IF EXISTS public.community_likes CASCADE;
DROP TABLE IF EXISTS public.community_comments CASCADE;
DROP TABLE IF EXISTS public.community_posts CASCADE;

-- Create Posts Table
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
);

-- Create Comments Table
CREATE TABLE public.community_comments (
  id uuid default uuid_generate_v4() primary key,
  post_id uuid references public.community_posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  content text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create Likes Table (to prevent multiple likes from same user)
CREATE TABLE public.community_likes (
  id uuid default uuid_generate_v4() primary key,
  post_id uuid references public.community_posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  unique(post_id, user_id)
);

-- Enable RLS for Posts
alter table public.community_posts enable row level security;
drop policy if exists "Posts viewable by everyone." on community_posts;
create policy "Posts viewable by everyone." on community_posts for select using (true);

drop policy if exists "Users can insert their own posts." on community_posts;
create policy "Users can insert their own posts." on community_posts for insert with check (auth.uid() = user_id);

-- Enable RLS for Comments
alter table public.community_comments enable row level security;
drop policy if exists "Comments viewable by everyone." on community_comments;
create policy "Comments viewable by everyone." on community_comments for select using (true);

drop policy if exists "Users can insert their own comments." on community_comments;
create policy "Users can insert their own comments." on community_comments for insert with check (auth.uid() = user_id);

-- Enable RLS for Likes
alter table public.community_likes enable row level security;
drop policy if exists "Likes viewable by everyone." on community_likes;
create policy "Likes viewable by everyone." on community_likes for select using (true);

drop policy if exists "Users can insert their own likes." on community_likes;
create policy "Users can insert their own likes." on community_likes for insert with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own likes." on community_likes;
create policy "Users can delete their own likes." on community_likes for delete using (auth.uid() = user_id);

-- RPC Functions for Incrementing/Decrementing Likes and Comments
CREATE OR REPLACE FUNCTION increment_like(pid uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
  UPDATE public.community_posts SET likes_count = likes_count + 1 WHERE id = pid;
$$;

CREATE OR REPLACE FUNCTION decrement_like(pid uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
  UPDATE public.community_posts SET likes_count = GREATEST(likes_count - 1, 0) WHERE id = pid;
$$;

CREATE OR REPLACE FUNCTION increment_comment(pid uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
  UPDATE public.community_posts SET comments_count = comments_count + 1 WHERE id = pid;
$$;

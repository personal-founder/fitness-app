-- metadata_version: 1
-- purpose: "Owner-only profiles; clients cannot assign immutable IDs or random tags."
-- owner: unassigned
-- related_adrs: [ADR-0015]
create schema if not exists extensions;
create extension if not exists pgcrypto with schema extensions;
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null check (length(first_name) between 1 and 80),
  last_name text not null check (length(last_name) between 1 and 80),
  nickname text check (length(nickname) between 1 and 80),
  display_name_mode text not null default 'full_name'
    check (display_name_mode in ('full_name', 'nickname')),
  account_tag text not null unique check (account_tag ~ '^#[A-Z]{2}[0-9]{4}$'),
  avatar_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (display_name_mode <> 'nickname' or nickname is not null),
  check (avatar_path is null or avatar_path like id::text || '/%')
);
alter table public.profiles enable row level security;
revoke all on public.profiles from public, anon, authenticated;
grant select on public.profiles to authenticated;
grant update (first_name, last_name, nickname, display_name_mode, avatar_path)
  on public.profiles to authenticated;
create policy profile_owner_read on public.profiles for select
  to authenticated using ((select auth.uid()) = id);
create policy profile_owner_update on public.profiles for update
  to authenticated using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create function public.touch_profile() returns trigger language plpgsql
  set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end;
$$;
revoke all on function public.touch_profile() from public, anon, authenticated;
create trigger profile_updated before update on public.profiles
  for each row execute function public.touch_profile();

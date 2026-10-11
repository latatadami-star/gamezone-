-- Run this entire file in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;
create extension if not exists btree_gist;

create table if not exists public.games (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text not null default '',
  cover_url text not null default '',
  compatible_consoles text[] not null default array['PS3']::text[],
  active boolean not null default true,
  created_at timestamptz not null default now(),
  constraint games_console_check check (compatible_consoles <@ array['PS3','PS4']::text[] and cardinality(compatible_consoles) > 0)
);

create table if not exists public.console_units (
  id uuid primary key default gen_random_uuid(),
  console_type text not null check (console_type in ('PS3','PS4')),
  unit_name text not null unique,
  active boolean not null default true
);

create table if not exists public.settings (
  id integer primary key default 1 check (id = 1),
  brand_name text not null default 'GAME ZONE',
  owner_name text not null default 'Bittu',
  developer_name text not null default 'Nodit',
  logo_url text not null default '',
  opening_time time not null default '10:00',
  closing_time time not null default '22:00',
  ps3_one_hour integer not null default 50 check (ps3_one_hour >= 0),
  ps3_two_hour integer not null default 90 check (ps3_two_hour >= 0),
  ps4_one_hour integer not null default 80 check (ps4_one_hour >= 0),
  ps4_two_hour integer not null default 150 check (ps4_two_hour >= 0),
  discount_percent integer not null default 0 check (discount_percent between 0 and 100),
  offer_text text not null default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  booking_code text not null unique default ('GZ-' || upper(substr(replace(gen_random_uuid()::text,'-',''),1,8))),
  user_id uuid not null,
  customer_name text not null,
  customer_phone text not null,
  console_type text not null check (console_type in ('PS3','PS4')),
  console_unit_id uuid not null references public.console_units(id),
  game_id uuid not null references public.games(id),
  start_at timestamptz not null,
  end_at timestamptz not null,
  duration_hours integer not null check (duration_hours in (1,2)),
  players integer not null check (players in (1,2)),
  base_price integer not null check (base_price >= 0),
  discount_percent integer not null default 0 check (discount_percent between 0 and 100),
  final_price integer not null check (final_price >= 0),
  status text not null default 'pending' check (status in ('pending','confirmed','cancelled','completed')),
  created_at timestamptz not null default now(),
  constraint booking_time_valid check (end_at > start_at),
  constraint booking_no_overlap exclude using gist (
    console_unit_id with =,
    tstzrange(start_at, end_at, '[)') with &&
  ) where (status in ('pending','confirmed'))
);

create index if not exists bookings_user_created_idx on public.bookings(user_id, created_at desc);
create index if not exists bookings_start_idx on public.bookings(start_at);

-- Browser clients are not allowed to read/write tables directly. All data access goes through
-- authenticated server routes. Service role key stays server-side only.
alter table public.games enable row level security;
alter table public.console_units enable row level security;
alter table public.settings enable row level security;
alter table public.bookings enable row level security;
drop policy if exists "deny browser games access" on public.games;
drop policy if exists "deny browser console access" on public.console_units;
drop policy if exists "deny browser settings access" on public.settings;
drop policy if exists "deny browser bookings access" on public.bookings;
create policy "deny browser games access" on public.games for all using (false) with check (false);
create policy "deny browser console access" on public.console_units for all using (false) with check (false);
create policy "deny browser settings access" on public.settings for all using (false) with check (false);
create policy "deny browser bookings access" on public.bookings for all using (false) with check (false);

insert into public.settings(id) values (1) on conflict (id) do nothing;
insert into public.console_units(console_type,unit_name) values ('PS3','PS3-1'),('PS4','PS4-1') on conflict (unit_name) do nothing;
insert into public.games(name,description,compatible_consoles) values
 ('FIFA','Football gaming session',array['PS3','PS4']),
 ('GTA V','Open-world action game',array['PS4']),
 ('Tekken','Fighting game session',array['PS3','PS4']),
 ('God of War','Action adventure',array['PS3','PS4'])
on conflict do nothing;

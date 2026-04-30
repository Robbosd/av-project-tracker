-- AnyVan Project Tracker — Supabase Schema
-- Run this in the Supabase SQL Editor

-- Migration (run in Supabase SQL editor for existing installs):
-- alter table projects add column if not exists session_length_mins integer default 90;
-- alter table projects add column if not exists sessions_scheduled integer default 0;
-- (then create scheduled_sessions table as below)

create table projects (
  id text primary key,
  name text not null,
  description text,
  status text default 'BACKLOG',
  bu text,
  owner text,
  priority text default 'Medium',
  impact text,
  hours_saved integer default 0,
  effort text,
  progress integer default 0,
  start_date date,
  end_date date,
  dependencies text,
  tags text[],
  github_url text,
  problem text,
  scope text,
  constraints text,
  dod text,
  stakeholders text,
  rag text,
  rag_note text,
  code text,
  code_lang text default 'python',
  completed_date date,
  added_date date default current_date,
  session_length_mins integer default 90,
  sessions_scheduled integer default 0,
  created_at timestamptz default now(),
  user_id uuid references auth.users(id)
);

create table tasks (
  id text primary key,
  project_id text references projects(id) on delete cascade,
  text text not null,
  done boolean default false,
  priority text default 'Medium',
  due_date date,
  sort_order integer default 0,
  created_at timestamptz default now()
);

create table subtasks (
  id text primary key,
  task_id text references tasks(id) on delete cascade,
  text text not null,
  done boolean default false,
  sort_order integer default 0
);

create table notes (
  id text primary key,
  project_id text references projects(id) on delete cascade,
  text text not null,
  author text,
  created_at timestamptz default now()
);

create table links (
  id text primary key,
  project_id text references projects(id) on delete cascade,
  label text,
  url text not null
);

create table scheduled_sessions (
  id text primary key,
  project_id text references projects(id) on delete cascade,
  calendar_event_id text,
  scheduled_date date not null,
  duration_mins integer default 90,
  title text,
  created_at timestamptz default now()
);

-- Row level security
alter table projects enable row level security;
alter table tasks enable row level security;
alter table subtasks enable row level security;
alter table notes enable row level security;
alter table links enable row level security;
alter table scheduled_sessions enable row level security;

create policy "Users own their projects" on projects
  for all using (auth.uid() = user_id);

create policy "Users access their tasks" on tasks
  for all using (project_id in (select id from projects where user_id = auth.uid()));

create policy "Users access their subtasks" on subtasks
  for all using (task_id in (select id from tasks where project_id in (select id from projects where user_id = auth.uid())));

create policy "Users access their notes" on notes
  for all using (project_id in (select id from projects where user_id = auth.uid()));

create policy "Users access their links" on links
  for all using (project_id in (select id from projects where user_id = auth.uid()));

create policy "Users access their sessions" on scheduled_sessions
  for all using (project_id in (select id from projects where user_id = auth.uid()));

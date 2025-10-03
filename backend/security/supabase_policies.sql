-- Enable row-level security on user generated tables
alter table if exists public.notes enable row level security;
alter table if exists public.lesson_progress enable row level security;
alter table if exists public.messages enable row level security;
alter table if exists public.cohorts enable row level security;
alter table if exists public.cohort_members enable row level security;

-- Notes
create policy "Own notes read" on public.notes
  for select using (auth.uid() = user_id);
create policy "Own notes write" on public.notes
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "Admin notes access" on public.notes
  for all using (exists (
    select 1
    from public.user_roles
    where user_roles.user_id = auth.uid()
      and user_roles.role in ('admin', 'mentor')
  ));

-- Lesson progress
create policy "Own progress" on public.lesson_progress
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "Mentor progress read" on public.lesson_progress
  for select using (exists (
    select 1
    from public.cohort_members cm
    where cm.cohort_id = lesson_progress.cohort_id
      and cm.user_id = auth.uid()
      and cm.role in ('mentor', 'admin')
  ));

-- Messages
create policy "Class messages" on public.messages
  for select using (
    auth.uid() = user_id or
    exists (
      select 1
      from public.class_members m
      where m.class_id = messages.class_id
        and m.user_id = auth.uid()
    )
  );
create policy "Post message" on public.messages
  for insert with check (auth.uid() = user_id);
create policy "Manage own message" on public.messages
  for update using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "Admin message moderation" on public.messages
  for delete using (exists (
    select 1 from public.user_roles
    where user_roles.user_id = auth.uid()
      and user_roles.role = 'admin'
  ));

-- Cohort membership metadata
create policy "View assigned cohorts" on public.cohorts
  for select using (
    exists (
      select 1 from public.cohort_members cm
      where cm.cohort_id = cohorts.id
        and cm.user_id = auth.uid()
    )
  );
create policy "Manage cohort as admin" on public.cohorts
  for all using (exists (
    select 1 from public.user_roles
    where user_roles.user_id = auth.uid()
      and user_roles.role = 'admin'
  ));

-- Utility table describing user roles
alter table if exists public.user_roles enable row level security;
create policy "Users view own roles" on public.user_roles
  for select using (auth.uid() = user_id);
create policy "Admins manage roles" on public.user_roles
  for all using (exists (
    select 1 from public.user_roles r
    where r.user_id = auth.uid()
      and r.role = 'admin'
  ));

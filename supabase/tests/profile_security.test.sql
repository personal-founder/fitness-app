-- metadata_version: 1
-- purpose: "Run with Supabase's database test runner against a disposable local database."
-- owner: unassigned
-- related_adrs: [ADR-0015, ADR-0017]
begin;
create extension if not exists pgtap with schema extensions;
select plan(10);
insert into auth.users(id, raw_user_meta_data) values
  ('00000000-0000-0000-0000-000000000001', '{"first_name":"Alpha","last_name":"Test"}'),
  ('00000000-0000-0000-0000-000000000002', '{"first_name":"Beta","last_name":"Test"}');
select matches(account_tag, '^#[A-Z]{2}[0-9]{4}$', 'server tag format')
  from public.profiles where id = '00000000-0000-0000-0000-000000000001';
select is((select count(distinct account_tag)::int from public.profiles), 2,
  'independent accounts receive distinct tags');
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000001"}', true);
select is((select count(*)::int from public.profiles), 1, 'A sees only A');
select is((select count(*)::int from public.profiles
  where id = '00000000-0000-0000-0000-000000000002'), 0, 'A cannot read B');
select lives_ok($$update public.profiles set nickname = 'Alias', display_name_mode = 'nickname'
  where id = '00000000-0000-0000-0000-000000000001'$$, 'A edits safe own fields');
select throws_ok($$update public.profiles set account_tag = '#ZZ0000'$$,
  '42501', null, 'client cannot reassign tags');
select throws_ok($$update public.profiles set id = gen_random_uuid()$$,
  '42501', null, 'client cannot reassign owner');
with changed as (update public.profiles set first_name = 'Intruder'
  where id = '00000000-0000-0000-0000-000000000002' returning id)
select is((select count(*)::int from changed), 0, 'A cannot update B');
select throws_ok($$delete from public.profiles$$, '42501', null, 'client deletion denied');
set local role anon;
select throws_ok($$select * from public.profiles$$, '42501', null, 'anonymous reads denied');
select * from finish();
rollback;

-- metadata_version: 1
-- purpose: "Exercise bucket privacy and cross-user object policy without uploading photos."
-- owner: unassigned
-- related_adrs: [ADR-0015, ADR-0017]
begin;
select plan(6);
select is((select public from storage.buckets where id = 'avatars'), false,
  'avatar bucket is private');
insert into storage.objects(bucket_id, name) values
  ('avatars', '00000000-0000-0000-0000-000000000001/a.png'),
  ('avatars', '00000000-0000-0000-0000-000000000002/b.png');
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000001"}', true);
select is((select count(*)::int from storage.objects where bucket_id = 'avatars'),
  1, 'A can only see own avatar');
select throws_ok($$insert into storage.objects(bucket_id, name) values
  ('avatars', '00000000-0000-0000-0000-000000000002/injected.png')$$,
  '42501', null, 'A cannot upload into B folder');
with deleted as (delete from storage.objects where bucket_id = 'avatars'
  and name = '00000000-0000-0000-0000-000000000002/b.png' returning id)
select is((select count(*)::int from deleted), 0, 'A cannot delete B avatar');
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000002"}', true);
select is((select count(*)::int from storage.objects where bucket_id = 'avatars'),
  1, 'B can only see own avatar');
set local role anon;
select is((select count(*)::int from storage.objects where bucket_id = 'avatars'),
  0, 'anonymous cannot list private avatars');
select * from finish();
rollback;

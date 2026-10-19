-- metadata_version: 1
-- purpose: "Cryptographic, unbiased independent symbols; UNIQUE retries are transactional."
-- owner: unassigned
-- related_adrs: [ADR-0016]
create function public.initialize_profile() returns trigger
language plpgsql security definer set search_path = '' as $$
declare
  tag text;
  alphabet constant text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  digits constant text := '0123456789';
  symbol integer;
  position integer;
  attempt integer;
  first_value text := left(trim(coalesce(new.raw_user_meta_data->>'first_name', '')), 80);
  last_value text := left(trim(coalesce(new.raw_user_meta_data->>'last_name', '')), 80);
  nick_value text := nullif(left(trim(new.raw_user_meta_data->>'nickname'), 80), '');
begin
  -- This application only creates named email accounts; malformed metadata fails.
  if first_value = '' or last_value = '' then
    raise exception 'Required profile metadata missing';
  end if;
  for attempt in 1..100 loop
    tag := '#';
    for position in 1..6 loop
      loop
        symbol := get_byte(extensions.gen_random_bytes(1), 0);
        exit when (position <= 2 and symbol < 234) or
          (position > 2 and symbol < 250);
      end loop;
      tag := tag || case when position <= 2
        then substr(alphabet, symbol % 26 + 1, 1)
        else substr(digits, symbol % 10 + 1, 1) end;
    end loop;
    begin
      insert into public.profiles
        (id, first_name, last_name, nickname, display_name_mode, account_tag)
      values (new.id, first_value, last_value, nick_value,
        case when new.raw_user_meta_data->>'display_name_mode' = 'nickname'
          and nick_value is not null then 'nickname' else 'full_name' end, tag);
      return new;
    exception when unique_violation then
      -- Retry only a tag collision, not an unrelated integrity failure.
      if exists (select 1 from public.profiles where id = new.id) then
        raise;
      end if;
    end;
  end loop;
  raise exception 'Unable to allocate account tag';
end;
$$;
revoke all on function public.initialize_profile() from public, anon, authenticated;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.initialize_profile();

-- Schéma appliqué au projet Supabase « planning-dev » (aiatoobtuudshpadkvxy).
-- Une table de documents JSON : config/team, config/redmine, weeks/<lundi>, actuals/<AAAA-MM>.
create table public.planning_docs (
  collection text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);
alter table public.planning_docs replica identity full;
alter table public.planning_docs enable row level security;

-- Toute personne connectée (lien magique par e-mail) peut lire et modifier.
create policy "lecture equipe" on public.planning_docs for select to authenticated using (true);
create policy "ajout equipe" on public.planning_docs for insert to authenticated with check (true);
create policy "modif equipe" on public.planning_docs for update to authenticated using (true) with check (true);
create policy "suppression equipe" on public.planning_docs for delete to authenticated using (true);

create or replace function public.jsonb_deep_merge(a jsonb, b jsonb)
returns jsonb language plpgsql immutable set search_path = '' as $$
declare k text; r jsonb;
begin
  if a is null or jsonb_typeof(a) <> 'object' or jsonb_typeof(b) <> 'object' then return b; end if;
  r := a;
  for k in select jsonb_object_keys(b) loop
    if r ? k then r := r || jsonb_build_object(k, public.jsonb_deep_merge(r->k, b->k));
    else r := r || jsonb_build_object(k, b->k); end if;
  end loop;
  return r;
end $$;

create or replace function public.planning_merge(p_collection text, p_id text, p_patch jsonb)
returns void language plpgsql security invoker set search_path = '' as $$
begin
  update public.planning_docs
     set data = public.jsonb_deep_merge(data, p_patch), updated_at = now()
   where collection = p_collection and id = p_id;
  if not found then raise exception 'not_found' using errcode = 'P0002'; end if;
end $$;
revoke execute on function public.planning_merge(text, text, jsonb) from anon, public;
grant execute on function public.planning_merge(text, text, jsonb) to authenticated;

alter publication supabase_realtime add table public.planning_docs;

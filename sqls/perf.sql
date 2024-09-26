-- dbに200件のレコードをinsertするSQL
-- https://sms-kaipoke.esa.io/posts/39999#%E3%83%91%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%B3%E3%82%B9%E6%A4%9C%E8%A8%BC


SET search_path = inventory;

--perf tests
begin transaction isolation level serializable;

drop table if exists tracers;

create table tracers
  ( id uuid primary key
  , created_at timestamptz not null
  )
  ;

insert into tracers (id, created_at)
  select gen_random_uuid() as id
       , current_timestamp as created_at
  from generate_series(1, 200)
  ;

commit;

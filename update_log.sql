begin transaction;
select datetime() || " addrwatch(pre) = " || count(*) from addrwatch;
select datetime() || " addrwatch_log(pre) = " || count(*) from addrwatch_log;

update addrwatch_log
   set update_time = (
         select max(timestamp)
           from addrwatch as a
          where a.mac_address = addrwatch_log.mac_address and
                a.ip_address = addrwatch_log.ip_address
          group by mac_address, ip_address
       )
 where exists (
         select max(timestamp)
           from addrwatch as a
          where a.mac_address = addrwatch_log.mac_address and
                a.ip_address = addrwatch_log.ip_address and
                a.timestamp > addrwatch_log.update_time
          group by mac_address, ip_address
         )
;
insert into addrwatch_log
select a.mac_address, a.ip_address, a.timestamp, a.timestamp
  from addrwatch as a
 where not exists (
       select l.mac_address, l.ip_address
         from addrwatch_log as l
        where l.mac_address = a.mac_address and
              l.ip_address  = a.ip_address)
;

delete from addrwatch;

select datetime() || " addrwatch(post) = " || count(*) from addrwatch;
select datetime() || " addrwatch_log(post) = " || count(*) from addrwatch_log;

commit;

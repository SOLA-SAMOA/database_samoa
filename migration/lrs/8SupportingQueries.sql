 select * from lrs.titleestate where sola_rrr_nr = 'LRS23219'

select titleref, count(*)
FROM lrs.sola_lease where insttype IN (7, 34) and status = 'current'
group by titleref HAVING count(*) > 1

select t.titlereference from lrs.title t, lrs.instrumenttitle it
where titlereference = '2309/6377'
and t.titleid = it.title



select t.titlereference, i.instrumentreference, cl.description, i.status, i.memorialrecital, d.registrationdate, d.status, d.dealingid, it.status,
i.instrumentid, instrumenttype
from lrs.title t, 
lrs.instrumenttitle it, 
lrs.instrument i,
lrs.instrumenttypecodelist cl,
lrs.dealing d
where t.titlereference IN ('2003/4953')
and  it.title = t.titleid
and i.instrumentid = it.instrument
and i.instrumenttype = cl.code
and d.dealingid = i.dealing
and it.status IS NOT NULL
and it.status IN (30, 33)
order by t.titlereference, COALESCE(d.registrationdate, '29 JAN 2009') DESC


select t.titlereference, i.instrumentreference, cl.description
from lrs.title t, 
lrs.instrumenttitle it, 
lrs.instrument i,
lrs.instrumenttypecodelist cl,
lrs.dealing d
where  it.title = t.titleid
and i.instrumentid = it.instrument
and i.instrumenttype = cl.code
and d.dealingid = i.dealing
and it.status IS NOT NULL
and it.status IN (34)
GROUP BY  t.titlereference,i.instrumentreference, cl.description
ORDER BY t.titlereference, i.instrumentreference


select * from lrs.statuscodelist where code in (33, 30, 31, 34, 12)

select it.* from lrs.title t, lrs.instrumenttitle it
where t.titlereference ='638/3082'
and it.title = t.titleid

select distinct status from lrs.instrumenttitle


SELECT (ARRAY (SELECT i.instrumentid
FROM  	lrs.title t, 
	lrs.instrumenttitle it, 
	lrs.instrument i,
	lrs.dealing d
WHERE 	t.titlereference ='638/3082'
AND 	it.title = t.titleid
AND	i.instrumentid = it.instrument
AND 	i.instrumenttype = 2 -- Transfer Instrument
AND 	d.dealingid = i.dealing
AND	d.status = 24 -- Registered Dealing
AND     it.status IS NOT NULL -- Spurious entries? - seems to affect mortgages, etc - see title 638/3082 where 35354 adn 35802 duplicated
ORDER BY d.registrationdate))[1] IS NULL 

DROP TABLE IF EXISTS lrs.sola_mortgage;
CREATE TABLE lrs.sola_mortgage (
   sola_rrr_id VARCHAR(40),
   sola_rrr_nr VARCHAR(20),
   titleid VARCHAR(40),
   instids VARCHAR(250),
   titleref VARCHAR(20),
   instref VARCHAR(20),
   insttype SMALLINT, 
   memorial VARCHAR(100),
   regdate timestamp without time zone);
INSERT INTO lrs.sola_mortgage (titleid, instids, titleref, instref, insttype, memorial, regdate)
SELECT t.titleid, string_agg(DISTINCT i.instrumentid, '!'), t.titlereference, i.instrumentreference,
   i.instrumenttype, MAX(i.memorialrecital), MAX(COALESCE(d.registrationdate, '1/1/1970')) AS reg_date
FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, lrs.dealing d
WHERE it.title = t.titleid
AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                    -- see title 638/3082 where 35354 and 35802 are duplicated
AND   i.instrumentid = it.instrument
AND   i.instrumenttype IN (12,13,99) -- Lease (7), Transfer of Lease (8) Surrender of Lease (9)
                                  -- Sub Lease (34), Termination of Lease (35), Renewal of Lease (36)
AND   d.dealingid = i.dealing
AND   d.status = 24  -- Registered Dealing
GROUP BY t.titleid, t.titlereference, i.instrumentreference, i.instrumenttype
order by titlereference, reg_date DESC;

UPDATE lrs.sola_mortgage
SET sola_rrr_id = uuid_generate_v1(); 

select * from lrs.sola_mortgage where  split_part(instids,'!',5) != ''
select * from lrs.sola_mortgage where titleref = '1109/6233'
order by titleref, regdate DESC

select titleref, count(*)
FROM lrs.sola_mortgage where insttype = 4 and status = 'current'
group by titleref HAVING count(*) > 1



select * from lrs.instrument where instrumenttype = 21




 select cl.description, cl.code, count(*) from lrs.instrument i , lrs.instrumenttypecodelist cl 
 where i.instrumenttype = cl.code group by cl.code, cl.description
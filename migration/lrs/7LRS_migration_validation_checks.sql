-- Pending titles that have not been registered in the LRS. 
SELECT titlereference, dateofcurrenttitle  
FROM   lrs.title
WHERE lrs.title.status IN (5, 9) 

-- Power of Attorney in LRS with no matching document image
SELECT s.la_nr, poa.attorney_name, poa.person_name, s.submission, s.status_code
FROM source.source s, 
   source.power_of_attorney poa
WHERE s.id = poa.id
AND   s.ext_archive_id IS NULL;

  
-- Power of Attorney documents in SOLA with no POA details in LRS
SELECT reference_nr FROM source.source s 
WHERE type_code = 'powerOfAttorney'
AND id not in (SELECT id FROM source.power_of_attorney)

-- LRS Standard Memoradum with no document image in SOLA
SELECT 	la_nr, description, submission, status_code
FROM 	source.source 
WHERE 	ext_archive_id IS NULL
AND     type_code = 'standardDocument';


-- Parcel linkages --
-- Same parcel used in two or more current/pending ba_units
SELECT b.name, co.name_firstpart || ' PLAN ' || co.name_lastpart as coname,  b.status_code 
FROM administrative.ba_unit_contains_spatial_unit, 
administrative.ba_unit b,
cadastre.cadastre_object co 
WHERE ba_unit_id = b.id
AND co.id = spatial_unit_id
AND spatial_unit_id IN (
SELECT spatial_unit_id 
FROM administrative.ba_unit_contains_spatial_unit
GROUP BY spatial_unit_id
HAVING count(*) > 1)
ORDER BY coname, b.name

-- All ba units with more than one parcel linked to them. 
SELECT b.name, b.status_code, count(*) 
FROM administrative.ba_unit_contains_spatial_unit, 
administrative.ba_unit b
WHERE ba_unit_id = b.id
GROUP BY b.name, b.status_code
HAVING count(*) > 1 --and b.status_code = 'current'


-- Titles with more than one pending Transfer 
select t.titlereference, count(*)
from lrs.title t, lrs.instrument i , lrs.instrumenttitle it
where it.title = t.titleid
and it.instrument = i.instrumentid
and i.instrumenttype = 2
and i.status = 34
group by t.titlereference having count(*) > 1;

-- Titles with more than one primary current RRR
  SELECT b.name, count(*) 
FROM administrative.rrr r, 
administrative.ba_unit b
WHERE r.ba_unit_id = b.id
and r.status_code = 'current'
and b.status_code = 'current'
and r.is_primary
GROUP BY b.name
HAVING count(*) > 1 

-- Shares with 0 nomintor or denominator 
select DISTINCT ba.name
from administrative.ba_unit ba, administrative.rrr r,
administrative.rrr_share rs
where r.ba_unit_id = ba.id
and rs.rrr_id = r.id
and (rs.nominator = 0 OR rs.denominator = 0)

-- Titles not migrated to SOLA, Ignores titles that were not approved. 
SELECT t.titlereference, cl.description
FROM lrs.title t, lrs.statuscodelist cl
WHERE t.status = cl.code
AND t.status != 5
AND NOT EXISTS (SELECT id from administrative.ba_unit WHERE id = t.titleid)

-- Estate RRRs that are not migrated into SOLA
SELECT t.titlereference
FROM lrs.title t, lrs.titleestate te
WHERE t.estate = te.titleestateid
AND  t.status != 5
AND te.sola_rrr_id_curr IS NOT NULL
AND   NOT EXISTS (SELECT id from administrative.rrr WHERE id = te.sola_rrr_id_curr)
UNION
SELECT t.titleid
FROM lrs.title t, lrs.titleestate te
WHERE t.estate = te.titleestateid
AND t.status != 5
AND te.sola_rrr_id_hist IS NOT NULL
AND   NOT EXISTS (SELECT id from administrative.rrr WHERE id = te.sola_rrr_id_hist)

-- Titles with more than 1 current mortgage
select titleref, count(*)
FROM lrs.sola_mortgage where insttype = 4 and status = 'current'
group by titleref HAVING count(*) > 1

-- Titles with more than 1 current lease or sub-lease
select titleref, count(*)
FROM lrs.sola_lease where insttype IN (7, 34) and status = 'current'
group by titleref HAVING count(*) > 1

-- Titles with more than 1 current caveat
select titleref, count(*)
FROM lrs.sola_caveat where insttype IN (10) and status = 'current'
group by titleref HAVING count(*) > 1

-- Pending Instruments not migrated into SOLA
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

-- Life Estates that need to be verified with correct info
SELECT b.name, count(*) 
FROM administrative.rrr r, 
administrative.ba_unit b
WHERE r.ba_unit_id = b.id
and r.type_code = 'lifeEstate'

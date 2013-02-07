-- Script to load LRS Title record and match the title record to the SamoaView parcel record using the Lot - Plan convention for title identification
--Neil Pullar 6 April 2012
-- Script run time approx 90 seconds

-- Make temp schema AND make queries, functions you might need

UPDATE administrative.ba_unit 
SET name = name_firstpart || '/' || name_lastpart 
WHERE type_code = 'basicPropertyUnit'; 

DELETE FROM administrative.ba_unit_contains_spatial_unit;

-- Batch insert into the linking table by joining across LRS and SOLA data. Note that
-- spatial_unit.label is popuplated with a cleaned parcel appellation by the DCDB migration. 
-- The cleaned appellation removes the text  Lot, Pt, . from the DCDB parcelnumber.
INSERT INTO administrative.ba_unit_contains_spatial_unit (ba_unit_id, spatial_unit_id, change_user)
SELECT 	DISTINCT ba.id, su.id, 'test'
FROM    administrative.ba_unit ba, 
	cadastre.spatial_unit su,
	cadastre.cadastre_object co,
	lrs.parcel p,
	lrs.instrumentTitle it,
	lrs.title t
WHERE   ba.type_code = 'basicPropertyUnit'
AND     ba.status_code = 'current'
AND     ba.id not in (SELECT ba_unit_id FROM administrative.ba_unit_contains_spatial_unit)
AND	co.id = su.id
AND	su.label IS NOT NULL
AND	p.parcelorcgnumber || '/' || p.plannumber = su.label
AND     it.parcel = p.parcelid
AND	it.title = t.titleid
AND     t.titlereference = ba.name;

--Load (non-spatial) LRS Parcels
INSERT INTO cadastre.spatial_unit(id, dimension_code, label, surface_relation_code, change_user)
SELECT parcelid, '0D', pl.parcelorcgnumber || '/' || pl.plannumber, 'onSurface', 'test' FROM lrs.parcel pl
WHERE NOT EXISTS (SELECT su.id FROM cadastre.spatial_unit su WHERE su.label = pl.parcelorcgnumber || '/' || pl.plannumber); 
 
INSERT INTO cadastre.cadastre_object(id, type_code, source_reference, name_firstpart, name_lastpart, status_code, transaction_id, change_user)
  SELECT parcelid, 'parcel', 'LRS', parcelorcgnumber, plannumber, 'current', 'adm-transaction', 'test' 
  FROM lrs.parcel pl, cadastre.spatial_unit su
  WHERE pl.parcelid = su.id;

INSERT INTO administrative.ba_unit_contains_spatial_unit (spatial_unit_id, ba_unit_id, change_user)
SELECT DISTINCT it.parcel, it.title, 'test-id'
FROM    lrs.instrumenttitle it,
		administrative.ba_unit ba,
		cadastre.spatial_unit su
WHERE   ba.id = it.title  
AND     su.id = it.parcel
AND		su.level_id IS NULL
AND		NOT EXISTS (SELECT ba_unit_id FROM administrative.ba_unit_contains_spatial_unit 
                     WHERE ba_unit_id = ba.id);
  

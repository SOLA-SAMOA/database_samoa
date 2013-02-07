-- Script to load LRS Title record into the SOLA ba_unit and associated primary rrr tables
--Neil Pullar 17 June 2012

-- Script run time approx 10 minutes. 

-- Make temp schema AND make queries, functions you might need

DROP SCHEMA IF EXISTS samoa_etl CASCADE;
CREATE SCHEMA samoa_etl;

CREATE OR REPLACE FUNCTION pc_chartoint(chartoconvert character varying)
  RETURNS integer AS
$BODY$
SELECT CASE WHEN trim($1) SIMILAR TO '[0-9]+' 
        THEN CAST(trim($1) AS integer) 
	ELSE NULL END;

$BODY$
  LANGUAGE 'sql' IMMUTABLE STRICT;

--

CREATE OR REPLACE FUNCTION samoa_etl.load_title() RETURNS varchar
AS
$BODY$
DECLARE 
    rec record;
    parcel_id varchar;
    name1 varchar;
    name2 varchar;

BEGIN

    FOR rec IN EXECUTE 'SELECT title.id, title.name_firstpart AS firstpart, title.name_lastpart AS lastpart
                FROM administrative.ba_unit title
                WHERE type_code = ''basicPropertyUnit''
                AND title.id NOT IN (SELECT ba_unit_id FROM administrative.ba_unit_contains_spatial_unit)'
	LOOP
		RAISE NOTICE 'Processing Parcel WKB record (%)', rec.firstpart || '/' || rec.lastpart;
		name1 = TRIM(rec.firstpart);
		name2 = TRIM(rec.lastpart);
		SELECT id into parcel_id  
		FROM cadastre.cadastre_object
		WHERE type_code = 'parcel'
		AND TRIM(name_firstpart) = name1
		AND TRIM(name_lastpart) = name2;
		if parcel_id is not null then
			INSERT INTO administrative.ba_unit_contains_spatial_unit (ba_unit_id, spatial_unit_id, change_user)
				VALUES (rec.id, parcel_id, 'test-id');
		RAISE NOTICE 'Matched';
		end if;
	END LOOP;
    RETURN 'ok';
END;

$BODY$
  LANGUAGE plpgsql;
--
--SOLA Data Model Required Corrections
--INSERT INTO administrative.ba_unit_type(code, display_value, description, status) values('administrativeUnit', 'Administrative Unit::::Unita Administrata', 'This is an administrative unit', 'c');
  

-- Go on with the script
--
-- Remove any previous records
DELETE FROM administrative.ba_unit_contains_spatial_unit;
DELETE FROM application.application_property;
DELETE FROM administrative.rrr;
DELETE FROM administrative.ba_unit_area;
DELETE FROM administrative.ba_unit_historic;
DELETE FROM administrative.required_relationship_baunit;
DELETE FROM administrative.ba_unit;
--Load Ownership details for primary rrr
DELETE FROM party.party WHERE id IN (SELECT party_id FROM administrative.party_for_rrr);
DELETE FROM administrative.party_for_rrr;
DELETE FROM administrative.rrr_share;
-- INSERT VALUES INTO public SCHEMA TABLES FROM LRS SCHEMA TABLES
INSERT INTO transaction.transaction(id, status_code, approval_datetime, change_user) 
SELECT 'adm-transaction', 'approved', now(), 'test-id' WHERE NOT EXISTS 
(SELECT id FROM transaction.transaction WHERE id = 'adm-transaction');

INSERT INTO administrative.ba_unit (id, type_code, name_firstpart, name_lastpart, status_code, transaction_id, change_user)
                SELECT gazzetterid, 'administrativeUnit', "name", 'Island', 'current', 'adm-transaction', 'test-id'  FROM lrs.island
                WHERE gazzetterid NOT IN (SELECT id FROM administrative.ba_unit);

INSERT INTO administrative.ba_unit (id, type_code, name_firstpart, name_lastpart, status_code, transaction_id, change_user)
                SELECT gazzetterid, 'administrativeUnit', "name", 'District', 'current', 'adm-transaction', 'test-id'  FROM lrs.landdistrict
                WHERE gazzetterid NOT IN (SELECT id FROM administrative.ba_unit);
                
INSERT INTO administrative.ba_unit (id, type_code, name_firstpart, name_lastpart, status_code, transaction_id, change_user)
                SELECT gazzetterid, 'administrativeUnit', "name", 'Village', 'current', 'adm-transaction', 'test-id'  FROM lrs.village
                WHERE gazzetterid NOT IN (SELECT id FROM administrative.ba_unit);
                
--Current Titles
--Caveat on Titles            
INSERT INTO administrative.ba_unit (id, type_code, name_firstpart, name_lastpart, status_code, creation_date, transaction_id, change_user)
                SELECT titleid, 'basicPropertyUnit', substring(titlereference, 0, position ('/' in titlereference)) AS firstpart, 
                substring(titlereference, position ('/' in titlereference) + 1, length(titlereference)) AS secondpart, 'current', dateofcurrenttitle, 'adm-transaction', 'test-id'   
                FROM lrs.title
                WHERE lrs.title.status IN (1, 6)
                AND titleid NOT IN (SELECT id FROM administrative.ba_unit);
                
--Cancelled Titles
--Referenced Titles - assume historic status
--Continuation (Deeds Registers)
INSERT INTO administrative.ba_unit (id, type_code, name_firstpart, name_lastpart, status_code, creation_date, transaction_id, change_user)
                SELECT titleid, 'basicPropertyUnit', substring(titlereference, 0, position ('/' in titlereference)) AS firstpart, 
                substring(titlereference, position ('/' in titlereference) + 1, length(titlereference)) AS secondpart, 'historic', dateofcurrenttitle, 'adm-transaction', 'test-id'   
                FROM lrs.title
                WHERE lrs.title.status IN (2,  4, 8)
                AND titleid NOT IN (SELECT id FROM administrative.ba_unit);

--update for expiration_date where status is historic
UPDATE administrative.ba_unit SET expiration_date = t.cancelDate FROM
	(SELECT t1.titleid AS titleID, t2.dateofcurrenttitle AS cancelDate FROM lrs.title t1
		INNER JOIN lrs.title t2 ON ((t1.supersedingtitle = t2.titleid) AND (t1.supersedingtitle IS NOT NULL) AND (t2.dateofcurrenttitle IS NOT NULL)) ) t
WHERE id = t.titleID
AND status_code = 'historic';

--Draft Titles
--Captured Titles - assume pending status 
-- AM > Don't copy through pending BA Units as they cannot be registered unless they are linked to an application that is approved. 
-- INSERT INTO administrative.ba_unit (id, type_code, name_firstpart, name_lastpart, status_code, creation_date, transaction_id, change_user)
--                SELECT titleid, 'basicPropertyUnit', substring(titlereference, 0, position ('/' in titlereference)) AS firstpart, 
--                substring(titlereference, position ('/' in titlereference) + 1, length(titlereference)) AS secondpart, 'pending', dateofcurrenttitle, 'adm-transaction', 'test-id'   
--                FROM lrs.title
--                WHERE lrs.title.status IN (5, 9) 
--                AND titleid NOT IN (SELECT id FROM administrative.ba_unit);



-- Insert extra relationship type codes. Islands and District set to x to prevent display in drop down lists. 
INSERT INTO administrative.ba_unit_rel_type (code, display_value, description, status)
(SELECT 'island_District' AS code, 'Island::::Motu' AS display_value, 'Island - Districts' AS description, 'x' AS status 
WHERE NOT EXISTS (SELECT 1 FROM administrative.ba_unit_rel_type WHERE code = 'island_District')); 
		
INSERT INTO administrative.ba_unit_rel_type (code, display_value, description, status)
(SELECT 'district_Village' AS code, 'District::::Itumalo' AS display_value, 'District - Villages' AS description, 'x' AS status
WHERE NOT EXISTS (SELECT 1 FROM administrative.ba_unit_rel_type WHERE code = 'district_Village')); 

INSERT INTO administrative.ba_unit_rel_type (code, display_value, description, status)
(SELECT 'title_Village' AS code, 'Village::::Nuu' AS display_value, 'Title - Village' AS description, 'c' AS status 
WHERE NOT EXISTS (SELECT 1 FROM administrative.ba_unit_rel_type WHERE code = 'title_Village'));

-- Remove any island/district/village mappings
DELETE FROM administrative.required_relationship_baunit where relation_code IN (
'island_District', 'district_Village', 'title_Village');
          
-- Island > District
INSERT INTO administrative.required_relationship_baunit (from_ba_unit_id, to_ba_unit_id, relation_code)
                SELECT island, gazzetterid, 'island_District' AS relationship
                FROM lrs.landdistrict;
          
-- District > Village                
INSERT INTO administrative.required_relationship_baunit (from_ba_unit_id, to_ba_unit_id, relation_code)
                SELECT landdistrict, gazzetterid, 'district_Village' AS relationship
                FROM lrs.village;
          
-- Village > Title
INSERT INTO administrative.required_relationship_baunit (from_ba_unit_id, to_ba_unit_id, relation_code)
                SELECT village, titleid, 'title_Village' AS relationship
                FROM lrs.title
                WHERE village IS NOT NULL
                AND titleid IN (SELECT id FROM administrative.ba_unit);      

--Add ba_unit_area
INSERT INTO administrative.ba_unit_area (id, ba_unit_id, type_code, size)
	(SELECT uuid_generate_v1(), title, 'officialArea', SUM(CAST(hectares AS NUMERIC(19,4)))*10000 FROM lrs.instrumenttitle 
	INNER JOIN lrs.parcel ON (lrs.instrumenttitle.parcel = lrs.parcel.parcelid)
	WHERE hectares IS NOT NULL
	AND EXISTS (SELECT id FROM administrative.ba_unit WHERE title = id)
	GROUP BY title); 
	

--Add Prior Titles
INSERT INTO administrative.required_relationship_baunit (from_ba_unit_id, to_ba_unit_id, relation_code)
                SELECT priortitle, titleid, 'priorTitle' AS relationship
                FROM lrs.title
                WHERE priortitle IS NOT NULL
                AND titleid IN (SELECT id FROM administrative.ba_unit)
                AND priortitle IN (SELECT id FROM administrative.ba_unit)
                AND priortitle NOT IN (SELECT from_ba_unit_id FROM administrative.required_relationship_baunit WHERE relation_code = 'priorTitle')
                AND titleid NOT IN (SELECT to_ba_unit_id FROM administrative.required_relationship_baunit WHERE relation_code = 'priorTitle');


-- Fix titles with duplicate names by adding a (2) or a (3) on the end
UPDATE 	administrative.ba_unit SET name = COALESCE(name_firstpart, '') || '/' || COALESCE(name_lastpart, '');
WITH dup_title AS (
  SELECT name AS dup_name, string_agg(id,'!') AS dup_ids 
  FROM administrative.ba_unit 
   GROUP by name having count(*) > 1)
UPDATE administrative.ba_unit SET name_lastpart = name_lastpart || '(2)'
FROM dup_title t
WHERE name = t.dup_name
AND  split_part(t.dup_ids,'!',2) = id;

WITH dup_title AS (
  SELECT name AS dup_name, string_agg(id,'!') AS dup_ids 
  FROM administrative.ba_unit 
   GROUP by name having count(*) > 1)
UPDATE administrative.ba_unit SET name_lastpart = name_lastpart || '(3)'
FROM dup_title t
WHERE name = t.dup_name
AND  split_part(t.dup_ids,'!',3) != ''
AND  split_part(t.dup_ids,'!',3) = id;



-- Setup the squence to use for RRR numbering
DROP SEQUENCE IF EXISTS administrative.rrr_nr_seq;
CREATE SEQUENCE  administrative.rrr_nr_seq
  INCREMENT 1
  MINVALUE 10000
  MAXVALUE 200000
  START 10000
  CACHE 1;

  -- Remove columns if already exist on the lrs.title estate table. 
  ALTER TABLE lrs.titleestate 
  DROP COLUMN IF EXISTS sola_rrr_id_curr, 
  DROP COLUMN IF EXISTS sola_rrr_id_hist, 
  DROP COLUMN IF EXISTS instrument_ref_arrary, 
  DROP COLUMN IF EXISTS sola_rrr_nr;

  -- Add the sequence number on the title estate table to use for the primary rrrs
  ALTER TABLE lrs.titleestate 
  ADD sola_rrr_id_curr VARCHAR(40),
  ADD sola_rrr_id_hist VARCHAR(40),
  ADD instrument_ref_arrary VARCHAR(40)[],
  ADD sola_rrr_nr VARCHAR(20); 

  -- Determine the tiles with current, historic or both estates based on the status of the 
  -- interestholders linked to the estate
  UPDATE lrs.titleestate 
  SET sola_rrr_id_curr = uuid_generate_v1()
  WHERE EXISTS (SELECT s.sharedinterest FROM lrs.share s, lrs.interestholder ih  
  WHERE s.sharedinterest = lrs.titleestate.sharedinterest
  AND ih.share = s.shareid
  AND ih.interest = 1
  AND ih.status = 40); -- current owner
  
  UPDATE lrs.titleestate 
  SET sola_rrr_id_hist = uuid_generate_v1()
  WHERE EXISTS (SELECT s.sharedinterest FROM lrs.share s, lrs.interestholder ih  
  WHERE s.sharedinterest = lrs.titleestate.sharedinterest
  AND ih.share = s.shareid
  AND ih.interest = 1
  AND ih.status = 41); -- historic owner
  
  -- Create an array with all of the Transfer instruments linked to the title and order the instruments
  -- by dealing registration date so that its possible to determine the lastest transfer applied to the title.  
  WITH transfers AS 
   ( SELECT t.estate AS eid, i.instrumentid AS iid,  
       COALESCE(d.registrationdate, '29 JAN 2009') AS reg_date -- Use the LRS migration date for sorting purposes only
	 FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, 
	      lrs.dealing d
	 WHERE it.title = t.titleid
	 AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                             -- see title 638/3082 where 35354 and 35802 are duplicated
	 AND   i.instrumentid = it.instrument
	 AND   i.instrumenttype = 2 -- Transfer Instrument 
	 AND   d.dealingid = i.dealing
	 AND   d.status = 24) -- Registered Dealing
 UPDATE lrs.titleestate
  SET instrument_ref_arrary = 
	(SELECT (ARRAY (SELECT t.iid
	 FROM  	transfers t
	 WHERE  t.eid = lrs.titleestate.titleestateid
	 ORDER BY t.reg_date DESC))) 
 WHERE sola_rrr_id_curr IS NOT NULL
 OR sola_rrr_id_hist IS NOT NULL;
 
  -- Allocate a suitable RRR nr for each estate
  UPDATE lrs.titleestate 
  SET sola_rrr_nr = trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'))
  WHERE sola_rrr_id_curr IS NOT NULL 
  OR sola_rrr_id_hist IS NOT NULL;  
  
--Create primary rrr record for each ba_unit with type = basicPropertyUnit
--Create primary rrr record
--Ownership interests
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_curr, titleid, 'ownership', 'current', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr, 
				COALESCE((CASE WHEN instrument_ref_arrary[1] IS NOT NULL THEN 
				   (SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
				    WHERE i.instrumentid = instrument_ref_arrary[1]
					AND d.dealingid = i.dealing) ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle), 
					'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate IN (1)
				AND sola_rrr_id_curr IS NOT NULL
                AND NOT EXISTS (SELECT titlewithqualifiedestate -- Life Estates to be processed separately
				                FROM lrs.titleestate
				                WHERE titlewithqualifiedestate IS NOT NULL 
								AND titlewithqualifiedestate = lrs.title.titleid
								AND titleestateid != '5EA8F21D-D056-4C02-80A3-A5483623B997') -- This title is no longer under Life Estate
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr);

-- Historic Owners				
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_hist, titleid, 'ownership', 'historic', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr,
				    -- Get the registration date for the appropriate instrument or use the title registration dates.  
					COALESCE((CASE WHEN sola_rrr_id_curr IS NULL AND instrument_ref_arrary[1] IS NOT NULL THEN 
							(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[1]
							AND d.dealingid = i.dealing)
					  WHEN sola_rrr_id_curr IS NOT NULL AND instrument_ref_arrary[2] IS NOT NULL THEN
					  		(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[2]
							AND d.dealingid = i.dealing)
					  ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle),
				'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate IN (1)
				AND sola_rrr_id_hist IS NOT NULL
				AND NOT EXISTS (SELECT titlewithqualifiedestate -- Life Estates to be processed separately
								FROM lrs.titleestate
								WHERE titlewithqualifiedestate IS NOT NULL 
								AND titlewithqualifiedestate = lrs.title.titleid
								AND titleestateid != '5EA8F21D-D056-4C02-80A3-A5483623B997') -- This title is no longer under Life Estate
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist);
          

--Leasehold interests
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_curr, titleid, 'leaseHold', 'current', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr,
				COALESCE((CASE WHEN instrument_ref_arrary[1] IS NOT NULL THEN 
				   (SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
				    WHERE i.instrumentid = instrument_ref_arrary[1]
					AND d.dealingid = i.dealing) ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle),				
				'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate = 2
				AND sola_rrr_id_curr IS NOT NULL
                --AND lrs.title.dateoforiginaltitle IS NOT NULL
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr);
				
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_hist, titleid, 'leaseHold', 'historic', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr, 
				    -- Get the registration date for the appropriate instrument or use the title registration dates.  
					COALESCE((CASE WHEN sola_rrr_id_curr IS NULL AND instrument_ref_arrary[1] IS NOT NULL THEN 
							(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[1]
							AND d.dealingid = i.dealing)
					  WHEN sola_rrr_id_curr IS NOT NULL AND instrument_ref_arrary[2] IS NOT NULL THEN
					  		(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[2]
							AND d.dealingid = i.dealing)
					  ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle),
					'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate = 2
				AND sola_rrr_id_hist IS NOT NULL
                --AND lrs.title.dateoforiginaltitle IS NOT NULL
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist);


--Customary interests
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_curr, titleid, 'customaryType', 'current', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr, 
				COALESCE((CASE WHEN instrument_ref_arrary[1] IS NOT NULL THEN 
				   (SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
				    WHERE i.instrumentid = instrument_ref_arrary[1]
					AND d.dealingid = i.dealing) ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle), 
				'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate = 3
				AND sola_rrr_id_curr IS NOT NULL
                --AND lrs.title.dateoforiginaltitle IS NOT NULL
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr);
				
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_hist, titleid, 'customaryType', 'historic', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr, 
				    -- Get the registration date for the appropriate instrument or use the title registration dates.  
					COALESCE((CASE WHEN sola_rrr_id_curr IS NULL AND instrument_ref_arrary[1] IS NOT NULL THEN 
							(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[1]
							AND d.dealingid = i.dealing)
					  WHEN sola_rrr_id_curr IS NOT NULL AND instrument_ref_arrary[2] IS NOT NULL THEN
					  		(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[2]
							AND d.dealingid = i.dealing)
					  ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle), 
				'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate = 3
				AND sola_rrr_id_hist IS NOT NULL
                --AND lrs.title.dateoforiginaltitle IS NOT NULL
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist);
				
				
--Government interests
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_curr, titleid, 'stateOwnership', 'current', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr, 
				COALESCE((CASE WHEN instrument_ref_arrary[1] IS NOT NULL THEN 
				   (SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
				    WHERE i.instrumentid = instrument_ref_arrary[1]
					AND d.dealingid = i.dealing) ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle), 
				'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate = 4
				AND sola_rrr_id_curr IS NOT NULL
                --AND lrs.title.dateoforiginaltitle IS NOT NULL
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr);
				
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
                SELECT sola_rrr_id_hist, titleid, 'stateOwnership', 'historic', -- administrative.ba_unit.status_code, 
				TRUE, sola_rrr_nr, 
				    -- Get the registration date for the appropriate instrument or use the title registration dates.  
					COALESCE((CASE WHEN sola_rrr_id_curr IS NULL AND instrument_ref_arrary[1] IS NOT NULL THEN 
							(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[1]
							AND d.dealingid = i.dealing)
					  WHEN sola_rrr_id_curr IS NOT NULL AND instrument_ref_arrary[2] IS NOT NULL THEN
					  		(SELECT d.registrationdate FROM lrs.dealing d, lrs.instrument i
							WHERE i.instrumentid = instrument_ref_arrary[2]
							AND d.dealingid = i.dealing)
					  ELSE NULL END), dateoforiginaltitle, dateofcurrenttitle), 
				'adm-transaction', 'test-id' FROM lrs.title
                INNER JOIN lrs.titleestate ON (lrs.title.estate = lrs.titleestate.titleestateid)
                INNER JOIN administrative.ba_unit ON (lrs.title.titleid = administrative.ba_unit.id)
                WHERE lrs.titleestate.estate = 4
				AND sola_rrr_id_hist IS NOT NULL
                --AND lrs.title.dateoforiginaltitle IS NOT NULL
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist);	
				
--Life Estates interests - Current ownership
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
  WITH life_estate AS (
  SELECT te.titleestateid AS teId, te.estate, t.titleid AS tId
  FROM  lrs.titleestate te, lrs.title t
  WHERE te.titlewithqualifiedestate IS NOT NULL
  AND   t.titleid = te.titlewithqualifiedestate
  AND   t.titlereference NOT IN ('V23/112', 'V46/235', 'V33/302', '2420/6618')) -- No longer a life estate or not setup correctly
  SELECT DISTINCT te.sola_rrr_id_curr, t.titleid, 'ownership', 'current', 
				TRUE, sola_rrr_nr, COALESCE(t.dateoforiginaltitle, t.dateofcurrenttitle), 
					'adm-transaction', 'test-id'
				FROM lrs.title t, lrs.titleestate te, life_estate le, 
				     administrative.ba_unit ba
				WHERE te.titleestateid = le.teId 
				AND   le.tId = t.titleid
				-- The owners are the remainder estate unless there is no remainder estate
				AND te.estate = (SELECT max(estate) FROM life_estate WHERE tid = t.titleId)		
				AND ba.id = t.titleid
				AND sola_rrr_id_curr IS NOT NULL 
                AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr);
				
				
--update for expiration_date where status is historic
UPDATE administrative.rrr SET expiration_date = ba.expiration_date
FROM administrative.ba_unit ba
WHERE administrative.rrr.ba_unit_id = ba.id
AND ba.expiration_date IS NOT NULL 
AND administrative.rrr.status_code = 'historic';

--
--Create rrr_share records for current primary rrr
-- Single share in shareholding 1/1
--Modified 8 October 2012
-- Add a unique id column to lrs.share for creating the current shares
  
  ALTER TABLE lrs.share
  DROP COLUMN IF EXISTS sola_share_id_curr, 
  DROP COLUMN IF EXISTS sola_share_id_hist; 
  
  -- Add unique ids to use for the share id of the current shares and the historic shares
  ALTER TABLE lrs.share
  ADD sola_share_id_curr VARCHAR(40),
  ADD sola_share_id_hist VARCHAR(40);
  
  -- Determine the current and historic shares
  UPDATE lrs.share
  SET sola_share_id_curr = uuid_generate_v1()
  WHERE EXISTS (SELECT ih.share FROM lrs.interestholder ih  
  WHERE ih.share = lrs.share.shareid
  AND ih.interest = 1
  AND ih.status = 40); -- current share
  
 UPDATE lrs.share
  SET sola_share_id_hist = uuid_generate_v1()
  WHERE EXISTS (SELECT ih.share FROM lrs.interestholder ih  
  WHERE ih.share = lrs.share.shareid
  AND ih.interest = 1
  AND ih.status = 41); -- historic share

  -- Create all current 1/1 shares
INSERT INTO administrative.rrr_share (id, rrr_id, nominator, denominator, change_user)
               SELECT DISTINCT sola_share_id_curr, sola_rrr_id_curr, 1, 1, 'test-id' 
			     FROM lrs.titleestate te, lrs.share s
				WHERE s.sharedinterest = te.sharedinterest
				AND sola_share_id_curr IS NOT NULL
				AND sola_rrr_id_curr IS NOT NULL
				AND s.sharedescription = 'All'
				AND EXISTS (SELECT id from administrative.rrr WHERE id = sola_rrr_id_curr)
				AND NOT EXISTS (SELECT id FROM administrative.rrr_share WHERE id = sola_share_id_curr);	 
				
  -- Create all historic 1/1 shares
INSERT INTO administrative.rrr_share (id, rrr_id, nominator, denominator, change_user)
               SELECT sola_share_id_hist, sola_rrr_id_hist, 1, 1, 'test-id' 
			     FROM lrs.titleestate te, lrs.share s
				WHERE s.sharedinterest = te.sharedinterest
				AND sola_share_id_hist IS NOT NULL
				AND sola_rrr_id_hist IS NOT NULL
				AND s.sharedescription = 'All'
				AND EXISTS (SELECT id from administrative.rrr WHERE id = sola_rrr_id_hist)
				AND NOT EXISTS (SELECT id FROM administrative.rrr_share WHERE id = sola_share_id_hist);	
				
-- Several shares in shareholding x/n (current)
INSERT INTO administrative.rrr_share (id, rrr_id, nominator, denominator, change_user)
               SELECT sola_share_id_curr, sola_rrr_id_curr, 
			   -- Bring through the share as 0 if the sharedescription is not valid - it will need to be reported and fixed 
			   COALESCE(pc_chartoint(substring(sharedescription, 0, position ('/' in sharedescription))), 0) AS nominator,
			   COALESCE(pc_chartoint(substring(sharedescription, position ('/' in sharedescription) + 1, length(sharedescription))),0) AS denominator, 
			   'test-id' 
			    FROM lrs.titleestate te, lrs.share s
				WHERE s.sharedinterest = te.sharedinterest
				AND sola_share_id_curr IS NOT NULL
				AND sola_rrr_id_curr IS NOT NULL
				AND s.sharedescription != 'All'
				AND EXISTS (SELECT id from administrative.rrr WHERE id = sola_rrr_id_curr)
				AND NOT EXISTS (SELECT id FROM administrative.rrr_share WHERE id = sola_share_id_curr);	

-- Several shares in shareholding x/n (historic)
INSERT INTO administrative.rrr_share (id, rrr_id, nominator, denominator, change_user)
               SELECT sola_share_id_hist, sola_rrr_id_hist, 
			   -- Bring through the share as 0 if the sharedescription is not valid - it will need to be reported and fixed 
			   COALESCE(pc_chartoint(substring(sharedescription, 0, position ('/' in sharedescription))), 0) AS nominator,
			   COALESCE(pc_chartoint(substring(sharedescription, position ('/' in sharedescription) + 1, length(sharedescription))),0) AS denominator, 
			   'test-id' 
			    FROM lrs.titleestate te, lrs.share s
				WHERE s.sharedinterest = te.sharedinterest
				AND sola_share_id_hist IS NOT NULL
				AND sola_rrr_id_hist IS NOT NULL
				AND s.sharedescription != 'All'
				AND EXISTS (SELECT id from administrative.rrr WHERE id = sola_rrr_id_hist)
				AND NOT EXISTS (SELECT id FROM administrative.rrr_share WHERE id = sola_share_id_hist);	


-- Add individual owners into party.party table (current and historic)
INSERT INTO party.party (id, type_code, name, last_name, alias, change_user)
                SELECT interestholderid, 'naturalPerson', firstname, substring(lastname from 1 for 50), aliasinterestholder, 'test-id' FROM lrs.interestholder
                WHERE interest = 1
                AND corporatename IS NULL
				AND NOT EXISTS (SELECT id FROM party.party WHERE id = interestholderid);	

-- Add corporate owners into party.party table (current and historic)
INSERT INTO party.party (id, type_code, name, change_user)
                SELECT interestholderid, 'nonNaturalPerson', corporatename, 'test-id' FROM lrs.interestholder
                WHERE interest = 1
                AND corporatename IS NOT NULL
                AND NOT EXISTS (SELECT id FROM party.party WHERE id = interestholderid);

				
-- Create administrative.party_for_rrr  (current)             
INSERT INTO administrative.party_for_rrr (rrr_id, party_id, share_id, change_user)
			SELECT sola_rrr_id_curr, ih.interestholderid, sola_share_id_curr, 'test-id'
				FROM lrs.titleestate te, lrs.share s, lrs.interestholder ih
				WHERE s.sharedinterest = te.sharedinterest
				AND ih.share = s.shareid
				AND sola_share_id_curr IS NOT NULL
				AND sola_rrr_id_curr IS NOT NULL
				AND ih.interest = 1
				AND ih.status = 40
				AND EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr); 				

-- Create administrative.party_for_rrr  (historic)             
INSERT INTO administrative.party_for_rrr (rrr_id, party_id, share_id, change_user)
			SELECT sola_rrr_id_hist, ih.interestholderid, sola_share_id_hist, 'test-id'
				FROM lrs.titleestate te, lrs.share s, lrs.interestholder ih
				WHERE s.sharedinterest = te.sharedinterest
				AND ih.share = s.shareid
				AND sola_share_id_hist IS NOT NULL
				AND sola_rrr_id_hist IS NOT NULL
				AND ih.interest = 1
				AND ih.status = 41
				AND EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist);

-- Notations
-- Current RRR
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
		SELECT uuid_generate_v1(), sola_rrr_id_curr, 'adm-transaction', 'test-id', 
				d.registrationdate, 'current', 
				COALESCE(i.memorialrecital, (CASE WHEN i.instrumenttype = 2 THEN 'Transfer' ELSE 'Transmission' END)),
				i.instrumentreference
	    FROM   lrs.titleestate te, lrs.instrument i, lrs.dealing d
		WHERE  sola_rrr_id_curr IS NOT NULL AND instrument_ref_arrary[1] IS NOT NULL
		AND  i.instrumentid = instrument_ref_arrary[1] AND d.dealingid = i.dealing
		AND EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_curr)
		AND NOT EXISTS (SELECT rrr_id FROM administrative.notation WHERE rrr_id = sola_rrr_id_curr); -- RRR can only have 1 notation
	
-- Historic RRR - use the first instrument	
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
		SELECT uuid_generate_v1(), sola_rrr_id_hist, 'adm-transaction', 'test-id', 
				d.registrationdate, 'historic', 
				COALESCE(i.memorialrecital, (CASE WHEN i.instrumenttype = 2 THEN 'Transfer' ELSE 'Transmission' END)),
				i.instrumentreference
	    FROM   lrs.titleestate te, lrs.instrument i, lrs.dealing d
		WHERE  sola_rrr_id_hist IS NOT NULL AND sola_rrr_id_curr IS NULL -- Use the first instrument
		AND     instrument_ref_arrary[1] IS NOT NULL
		AND  i.instrumentid = instrument_ref_arrary[1] AND d.dealingid = i.dealing
		AND EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist)
		AND NOT EXISTS (SELECT rrr_id FROM administrative.notation WHERE rrr_id = sola_rrr_id_hist); -- RRR can only have 1 notation

-- Historic RRR - use the second instrument			
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
		SELECT uuid_generate_v1(), sola_rrr_id_hist, 'adm-transaction', 'test-id', 
				d.registrationdate, 'historic', 
				COALESCE(i.memorialrecital, (CASE WHEN i.instrumenttype = 2 THEN 'Transfer' ELSE 'Transmission' END)),
			 i.instrumentreference
	    FROM   lrs.titleestate te, lrs.instrument i, lrs.dealing d
		WHERE  sola_rrr_id_hist IS NOT NULL AND sola_rrr_id_curr IS NULL -- Use the second instrument
		AND     instrument_ref_arrary[2] IS NOT NULL
		AND  i.instrumentid = instrument_ref_arrary[2] AND d.dealingid = i.dealing
		AND EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id_hist)
		AND NOT EXISTS (SELECT rrr_id FROM administrative.notation WHERE rrr_id = sola_rrr_id_hist); -- RRR can only have 1 notation
		
				
-- Add the structure for the life estates that are not setup correctly
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
SELECT  'V23_112', t.titleid, 'ownership', 'current', TRUE, trim(to_char(nextval('administrative.rrr_nr_seq'), '000000')),
    COALESCE(t.dateoforiginaltitle, t.dateofcurrenttitle), 'adm-transaction', 'test-id'
FROM lrs.title t WHERE t.titlereference = 'V23/112' 
AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = 'V23_112') ;

INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
SELECT  'V46_235', t.titleid, 'ownership', 'current', TRUE, trim(to_char(nextval('administrative.rrr_nr_seq'), '000000')),
    COALESCE(t.dateoforiginaltitle, t.dateofcurrenttitle), 'adm-transaction', 'test-id'
FROM lrs.title t WHERE t.titlereference = 'V46/235' 
AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = 'V46_235');

INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
SELECT  'V33_302', t.titleid, 'ownership', 'current', TRUE, trim(to_char(nextval('administrative.rrr_nr_seq'), '000000')),
    COALESCE(t.dateoforiginaltitle, t.dateofcurrenttitle), 'adm-transaction', 'test-id'
FROM lrs.title t WHERE t.titlereference = 'V33/302' 
AND NOT EXISTS (SELECT id FROM administrative.rrr WHERE id = 'V33_302');

-- Add Shares for Life Estates
INSERT INTO administrative.rrr_share (id, rrr_id, nominator, denominator, change_user)
SELECT s.shareid, r.id, 1 AS nominator,1 AS denominator, 'test-id' 
		FROM administrative.rrr r, lrs.titleestate te, lrs.share s,
		lrs.interestholder ih
		WHERE r.id IN ( 'V33_302', 'V46_235', 'V23_112' )
		AND  te.titlewithqualifiedestate IS NOT NULL
		AND  te.titlewithqualifiedestate = r.ba_unit_id
		AND  s.sharedinterest = te.sharedinterest
		AND  te.estate = 11
		AND  ih.share = s.shareid
		AND   ih.interest = 1
		AND   ih.status = 40
		AND   s.sharedescription = 'All'
		AND NOT EXISTS (SELECT id FROM administrative.rrr_share WHERE rrr_id = r.id);

INSERT INTO administrative.rrr_share (id, rrr_id, nominator, denominator, change_user)
SELECT s.shareid, r.id, 
	   COALESCE(pc_chartoint(substring(sharedescription, 0, position ('/' in sharedescription))), 0) AS nominator,
	   COALESCE(pc_chartoint(substring(sharedescription, position ('/' in sharedescription) + 1, length(sharedescription))),0) AS denominator, 
	   'test-id' 
		FROM administrative.rrr r, lrs.titleestate te, lrs.share s,
		lrs.interestholder ih
		WHERE r.id IN ( 'V33_302', 'V46_235', 'V23_112' )
		AND  te.titlewithqualifiedestate IS NOT NULL
		AND  te.titlewithqualifiedestate = r.ba_unit_id
		AND  s.sharedinterest = te.sharedinterest
		AND  te.estate = 11
		AND  ih.share = s.shareid
		AND   ih.interest = 1
		AND   ih.status = 40
		AND   s.sharedescription != 'All'
		AND NOT EXISTS (SELECT id FROM administrative.rrr_share WHERE rrr_id = r.id);	

INSERT INTO administrative.party_for_rrr (rrr_id, party_id, share_id, change_user)
SELECT r.id, ih.interestholderid, s.shareid, 'test-id'
	FROM administrative.rrr r, lrs.titleestate te, lrs.share s,
		lrs.interestholder ih
		WHERE r.id IN ( 'V33_302', 'V46_235', 'V23_112' )
		AND  te.titlewithqualifiedestate IS NOT NULL
		AND  te.titlewithqualifiedestate = r.ba_unit_id
		AND  s.sharedinterest = te.sharedinterest
		AND  te.estate = 11
		AND  ih.share = s.shareid
		AND   ih.interest = 1
		AND   ih.status = 40;


DELETE FROM administrative.notation WHERE rrr_id IN 
 (SELECT id FROM administrative.rrr WHERE type_code = 'lifeEstate');
DELETE FROM administrative.rrr WHERE type_code = 'lifeEstate';
				
-- Add the life estate RRRs
INSERT INTO administrative.rrr (id, ba_unit_id, type_code, status_code, is_primary, nr, registration_date,  transaction_id, change_user)
  WITH life_estate AS (
SELECT DISTINCT t.titleid AS tId
  FROM  lrs.titleestate te, lrs.title t
  WHERE te.titlewithqualifiedestate IS NOT NULL
  AND   t.titleid = te.titlewithqualifiedestate
  AND   t.titlereference NOT IN ('2420/6618')
  AND   te.estate = 10
  GROUP BY t.titleid)
SELECT uuid_generate_v1(), le.tid, 'lifeEstate', 'current', FALSE, trim(to_char(nextval('administrative.rrr_nr_seq'), '000000')),
    NULL, 'adm-transaction', 'test-id'
FROM life_estate le
WHERE EXISTS (SELECT id FROM administrative.ba_unit WHERE id = le.tid); 

INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr)
 WITH life_estate AS (
SELECT DISTINCT t.titleid AS tId, string_agg(ih.firstname || ' ' || ih.lastname, ', ') AS rightholders
  FROM  lrs.titleestate te, lrs.title t, lrs.share s, 
   lrs.interestholder ih
  WHERE te.titlewithqualifiedestate IS NOT NULL
  AND   t.titleid = te.titlewithqualifiedestate
  AND   t.titlereference NOT IN ('2420/6618')
  AND   te.estate = 10
  AND   s.sharedinterest = te.sharedinterest
  AND   ih.share = s.shareid
  AND   ih.interest = 1
  AND   ih.status = 40
  GROUP BY t.titleid) 
SELECT uuid_generate_v1(), r.id, 'adm-transaction', 'test-id',  NULL, 'current', 'Life Estate for ' || le.rightholders, ''
FROM   life_estate le, administrative.rrr r
WHERE  le.tId = r.ba_unit_id
AND    r.type_code = 'lifeEstate';
		
		
DROP SCHEMA IF EXISTS samoa_etl CASCADE;

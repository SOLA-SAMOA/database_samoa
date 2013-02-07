-- Script to load LRS Instrument record into the SOLA administrative.rrr and associated  tables
-- Modified Neil Pullar 09 August 2012
--
-- Script run time approx 5 minutes.
--
-- Make temp schema AND make queries, functions you might need

DROP SCHEMA IF EXISTS samoa_etl CASCADE;

-- Remove any previously loaded records
DELETE FROM administrative.rrr WHERE NOT is_primary
AND type_code NOT IN ('lifeEstate');
DELETE FROM administrative.notation WHERE NOT EXISTS 
   (SELECT id FROM administrative.rrr WHERE id = administrative.notation.rrr_id);
  
   
   
-- Create functions to process the different instrument types
CREATE OR REPLACE FUNCTION lrs.process_mortgage() RETURNS VARCHAR
AS
$BODY$
DECLARE 
    rec RECORD;
	rrr_id VARCHAR(40);
    curr_tid VARCHAR(40) := '';
	tid VARCHAR(40);
    insttype SMALLINT;
	curr_status VARCHAR(20) := '';
	rrr_nr VARCHAR(40) := ''; 
	hist_count INT := 0;
BEGIN
    -- Process each mortgage and attempt to determine if the mortgage should be
	-- historic or current depending on how many mortgage discharges the title 
	-- has. Each mortgage instrument is assigned a new RRR number because the original
	-- mortgage + any variations must remain current on the title until discharged.
    FOR rec IN EXECUTE 'SELECT sola_rrr_id, titleid, insttype
                FROM lrs.sola_mortgage
                ORDER BY titleid, regdate DESC'
	LOOP
		tid := rec.titleid;
		insttype := rec.insttype;
		rrr_id := rec.sola_rrr_id;
		IF tid != curr_tid THEN
		   curr_tid := tid;
		   curr_status := 'current';
		   hist_count := 0; 
		END IF;
		
		IF insttype = 5 THEN
		   -- Discharge of mortagage - set the rrr to historic so all subsequent
		   -- RRRs are noted as historic as well. 
		   curr_status := 'historic';
		   hist_count = hist_count + 1;	
		END IF;
	
		 UPDATE lrs.sola_mortgage 
		 SET status = curr_status, 
		     sola_rrr_nr = 'LRS' || trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'))
		 WHERE sola_rrr_id = rrr_id; 
		 
		 IF insttype = 4 THEN
		    -- New Mortgage
		   IF hist_count > 1 THEN
		      hist_count := hist_count - 1; 
		   END IF;
		   
		   IF hist_count = 0 THEN
              -- Only change the status if all of the discharges have been accounted for. 		   
		      curr_status := 'current';
		   END IF;
		 END IF; 
		 
	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;
  
CREATE OR REPLACE FUNCTION lrs.process_lease() RETURNS VARCHAR
AS
$BODY$
DECLARE 
    rec RECORD;
	rrr_id VARCHAR(40);
    curr_tid VARCHAR(40) := '';
	tid VARCHAR(40);
    insttype SMALLINT;
	curr_status VARCHAR(20) := '';
	rrr_nr VARCHAR(40) := ''; 
	hist_count INT := 0;
BEGIN
    
	-- Process each lease. 
    FOR rec IN EXECUTE 'SELECT sola_rrr_id, titleid, insttype
                FROM lrs.sola_lease
                ORDER BY titleid, regdate DESC'
	LOOP
		tid := rec.titleid;
		insttype := rec.insttype;
		rrr_id := rec.sola_rrr_id;
		IF tid != curr_tid THEN
		   curr_tid := tid;
		   rrr_nr := 'LRS' || trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));
		   curr_status := 'current';
		   hist_count := 0; 
		END IF;
		
		IF insttype IN (9, 35) THEN
		   -- Surrender Lease or Terminate Leease - set the rrr to historic so all subsequent
		   -- RRRs are noted as historic as well. 
		   curr_status := 'historic';
		   hist_count = hist_count + 1; 
		END IF;
		
		 UPDATE lrs.sola_lease 
		 SET status = curr_status, sola_rrr_nr = rrr_nr
		 WHERE sola_rrr_id = rrr_id; 
		 
		 IF insttype IN (7, 34)  THEN
		   -- New Lease or Sublease
		   IF hist_count > 1 THEN
		      hist_count := hist_count - 1; 
		   END IF;
		   
		   IF hist_count = 0 THEN
              -- Only change the status if all of the discharges have been accounted for. 		   
		      curr_status := 'current';
		   END IF;
		   
		   rrr_nr := 'LRS' || trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));
		 END IF; 
		 
	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;
  
 
CREATE OR REPLACE FUNCTION lrs.process_caveat() RETURNS VARCHAR
AS
$BODY$
DECLARE 
    rec RECORD;
	rrr_id VARCHAR(40);
    curr_tid VARCHAR(40) := '';
	tid VARCHAR(40);
    insttype SMALLINT;
	curr_status VARCHAR(20) := '';
	rrr_nr VARCHAR(40) := ''; 
	hist_count INT := 0;
BEGIN
    
    FOR rec IN EXECUTE 'SELECT sola_rrr_id, titleid, insttype
                FROM lrs.sola_caveat
                ORDER BY titleid, regdate DESC'
	LOOP
		tid := rec.titleid;
		insttype := rec.insttype;
		rrr_id := rec.sola_rrr_id;
		IF tid != curr_tid THEN
		   curr_tid := tid;
		   rrr_nr := 'LRS' || trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));
		   curr_status := 'current';
		   hist_count := 0; 
		END IF;
		
		IF insttype IN (11) THEN
		   -- Withdraw Caveat. 
		   curr_status := 'historic';
		   hist_count = hist_count + 1; 
		END IF;
		
		 UPDATE lrs.sola_caveat
		 SET status = curr_status, sola_rrr_nr = rrr_nr
		 WHERE sola_rrr_id = rrr_id; 
		 
		 IF insttype IN (10)  THEN
		   -- New Caveat
		   IF hist_count > 1 THEN
		      hist_count := hist_count - 1; 
		   END IF;
		   
		   IF hist_count = 0 THEN
              -- Only change the status if all of the discharges have been accounted for. 		   
		      curr_status := 'current';
		   END IF;
		   
		   rrr_nr := 'LRS' || trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));
		 END IF; 
		 
	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;
  
 CREATE OR REPLACE FUNCTION lrs.process_transmission() RETURNS VARCHAR
AS
$BODY$
DECLARE 
    rec RECORD;
	rrr_id VARCHAR(40);
    curr_tid VARCHAR(40) := '';
	tid VARCHAR(40);
    insttype SMALLINT;
	curr_status VARCHAR(20) := '';
BEGIN
    
	-- Process each transmission. 
    FOR rec IN EXECUTE 'SELECT sola_rrr_id, titleid, insttype
                FROM lrs.sola_transmission
                ORDER BY titleid, regdate DESC'
	LOOP
		tid := rec.titleid;
		insttype := rec.insttype;
		rrr_id := rec.sola_rrr_id;
		IF tid != curr_tid THEN
		   curr_tid := tid;
		   curr_status := 'current';
		END IF;
		
		-- The transmission can only be current if it is the first instrument on the title, otherwise
		-- it must be historic as they are discharged by either transfer or other transmission intruments. 
		IF insttype IN (3) THEN
		   UPDATE lrs.sola_transmission
		   SET status = curr_status, sola_rrr_nr = 'LRS' || trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'))
		   WHERE sola_rrr_id = rrr_id;   
		END IF;
		
		curr_status := 'historic'; 
				 
	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;



 
-- *** Mortgages *** 
-- Create a table to help process the mortgage rrrs 
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
   regdate timestamp without time zone, 
   status VARCHAR(20));
   
-- Get all of the mortgage records, attempting to remove any duplicates based on instrument ref  
INSERT INTO lrs.sola_mortgage (titleid, instids, titleref, instref, insttype, memorial, regdate, status )
SELECT t.titleid, string_agg(DISTINCT i.instrumentid, '!'), t.titlereference, i.instrumentreference,
   i.instrumenttype, MAX(i.memorialrecital), MAX(COALESCE(d.registrationdate, '29 JAN 2009')) AS reg_date,
   (CASE WHEN i.instrumenttype IN (4, 6) AND MAX(it.status) = 30 THEN 'current' ELSE 'historic' END) AS status
FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, lrs.dealing d
WHERE it.title = t.titleid
AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                        -- see title 638/3082 where 35354 and 35802 are duplicated
AND   i.instrumentid = it.instrument
AND   i.instrumenttype IN (4, 5, 6) -- Mortgage (4), Variation (6) and Discharge (5)
AND   d.dealingid = i.dealing
AND   d.status = 24  -- Registered Dealing
AND   it.status IN (30, 33) -- Current Instrument (30), Registered Discharges (33)
GROUP BY t.titleid, t.titlereference, i.instrumentreference, i.instrumenttype;

UPDATE lrs.sola_mortgage
SET sola_rrr_id = uuid_generate_v1(),
    sola_rrr_nr =  trim(to_char(nextval('administrative.rrr_nr_seq'), '000000')); 

-- Don't try to sequence the mortages, use the instrument status instead
--SELECT lrs.process_mortgage(); 

-- Add the mortgage rrr's
INSERT INTO administrative.rrr(id, ba_unit_id, is_primary, registration_date, type_code, status_code, nr, transaction_id, change_user)
SELECT sola_rrr_id, titleid, FALSE, CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
    'mortgage', status, sola_rrr_nr, 'adm-transaction', 'test-id'
FROM lrs.sola_mortgage
WHERE EXISTS (SELECT id FROM administrative.ba_unit WHERE id = titleid); 

-- Add the mortgage notations
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
SELECT uuid_generate_v1(), sola_rrr_id, 'adm-transaction', 'test-id', CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
	  status, COALESCE(memorial, (CASE insttype WHEN 4 THEN 'Mortgage' WHEN 5 THEN 'Discharge of Mortgage' ELSE 'Variation of Mortgage' END)),
 	  COALESCE(instref, '')
FROM  lrs.sola_mortgage
WHERE EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id);

 
-- *** Leases ***
-- Create a table to help process the lease rrrs 
DROP TABLE IF EXISTS lrs.sola_lease;
CREATE TABLE lrs.sola_lease (
   sola_rrr_id VARCHAR(40),
   sola_rrr_nr VARCHAR(20),
   titleid VARCHAR(40),
   instids VARCHAR(250),
   titleref VARCHAR(20),
   instref VARCHAR(20),
   insttype SMALLINT, 
   memorial VARCHAR(100),
   regdate timestamp without time zone,
   status VARCHAR(20));
   
-- Get all of the lease records, attempting to remove any duplicates based on instrument ref  
INSERT INTO lrs.sola_lease (titleid, instids, titleref, instref, insttype, memorial, regdate, status)
SELECT t.titleid, string_agg(DISTINCT i.instrumentid, '!'), t.titlereference, i.instrumentreference,
   i.instrumenttype, MAX(i.memorialrecital), MAX(COALESCE(d.registrationdate, '29 JAN 2009')) AS reg_date, 
   (CASE WHEN i.instrumenttype IN (7, 8,34,36) AND MAX(it.status) = 30 THEN 'current' ELSE 'historic' END) AS status
FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, lrs.dealing d
WHERE it.title = t.titleid
AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                        -- see title 638/3082 where 35354 and 35802 are duplicated
AND   i.instrumentid = it.instrument
AND   i.instrumenttype IN (7,8,9, 34, 35, 36) -- Lease (7), Transfer of Lease (8) Surrender of Lease (9)
                                              -- Sub Lease (34), Termination of Lease (35), Renewal of Lease (36)
AND   d.dealingid = i.dealing
AND   d.status = 24  -- Registered Dealing
AND   it.status IN (30, 33) -- Current Instrument (30), Registered Discharges (33)
GROUP BY t.titleid, t.titlereference, i.instrumentreference, i.instrumenttype;

UPDATE lrs.sola_lease
SET sola_rrr_id = uuid_generate_v1(),
    sola_rrr_nr =  trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));  

--SELECT lrs.process_lease(); 

-- Add the lease rrr's
INSERT INTO administrative.rrr(id, ba_unit_id, is_primary, registration_date, type_code, status_code, nr, transaction_id, change_user)
SELECT sola_rrr_id, titleid, FALSE, CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
    'lease', status, sola_rrr_nr, 'adm-transaction', 'test-id'
FROM lrs.sola_lease
WHERE EXISTS (SELECT id FROM administrative.ba_unit WHERE id = titleid); 

-- Add the lease notations
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
SELECT uuid_generate_v1(), sola_rrr_id, 'adm-transaction', 'test-id', CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
	  status, COALESCE(memorial, (CASE insttype WHEN 7 THEN 'Lease' WHEN 8 THEN 'Transfer of Lease' 
	                              WHEN 9 THEN 'Surrender of Lease' WHEN 34 THEN 'Sub Lease' WHEN 35 THEN 'Termination of Lease'
								  ELSE 'Renewal of Lease' END)),
 	  COALESCE(instref, '')
FROM  lrs.sola_lease
WHERE EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id);
 

 
-- *** Caveats ***
-- Create a table to help process the lease rrrs 
DROP TABLE IF EXISTS lrs.sola_caveat;
CREATE TABLE lrs.sola_caveat (
   sola_rrr_id VARCHAR(40),
   sola_rrr_nr VARCHAR(20),
   titleid VARCHAR(40),
   instids VARCHAR(250),
   titleref VARCHAR(20),
   instref VARCHAR(20),
   insttype SMALLINT, 
   memorial VARCHAR(100),
   regdate timestamp without time zone,
   status VARCHAR(20));
   
-- Get all of the caveats records, attempting to remove any duplicates based on instrument ref  
INSERT INTO lrs.sola_caveat (titleid, instids, titleref, instref, insttype, memorial, regdate, status)
SELECT t.titleid, string_agg(DISTINCT i.instrumentid, '!'), t.titlereference, i.instrumentreference,
   i.instrumenttype, MAX(i.memorialrecital), MAX(COALESCE(d.registrationdate, '29 JAN 2009')) AS reg_date,
   (CASE WHEN i.instrumenttype IN (10) AND MAX(it.status) = 30 THEN 'current' ELSE 'historic' END) AS status
FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, lrs.dealing d
WHERE it.title = t.titleid
AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                        -- see title 638/3082 where 35354 and 35802 are duplicated
AND   i.instrumentid = it.instrument
AND   i.instrumenttype IN (10,11) -- Caveat (10), Withdraw Caveat (11)
AND   d.dealingid = i.dealing
AND   d.status = 24  -- Registered Dealing
AND   it.status IN (30, 33) -- Current Instrument (30), Registered Discharges (33)
GROUP BY t.titleid, t.titlereference, i.instrumentreference, i.instrumenttype;

UPDATE lrs.sola_caveat
SET sola_rrr_id = uuid_generate_v1(),
    sola_rrr_nr =  trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));

--SELECT lrs.process_caveat(); 

-- Add the cavaet rrr's
INSERT INTO administrative.rrr(id, ba_unit_id, is_primary, registration_date, type_code, status_code, nr, transaction_id, change_user)
SELECT sola_rrr_id, titleid, FALSE, CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
    'caveat', status, sola_rrr_nr, 'adm-transaction', 'test-id'
FROM lrs.sola_caveat
WHERE EXISTS (SELECT id FROM administrative.ba_unit WHERE id = titleid); 

-- Add the caveat notations
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
SELECT uuid_generate_v1(), sola_rrr_id, 'adm-transaction', 'test-id', CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
	  status, COALESCE(memorial, (CASE insttype WHEN 10 THEN 'Caveat' ELSE 'Withdrawal of Caveat' END)),
 	  COALESCE(instref, '')
FROM  lrs.sola_caveat
WHERE EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id);



-- *** Transmission
-- Create a table to help process transmission rrrs 
DROP TABLE IF EXISTS lrs.sola_transmission;
CREATE TABLE lrs.sola_transmission (
   sola_rrr_id VARCHAR(40),
   sola_rrr_nr VARCHAR(20),
   titleid VARCHAR(40),
   instids VARCHAR(250),
   titleref VARCHAR(20),
   instref VARCHAR(20),
   insttype SMALLINT, 
   memorial VARCHAR(100),
   regdate timestamp without time zone,
   status VARCHAR(20));
   
-- Get all of the transmissions and transfers. Transmissions can be cancelled by either a transfer or another transmission  
INSERT INTO lrs.sola_transmission (titleid, instids, titleref, instref, insttype, memorial, regdate, status)
SELECT t.titleid, string_agg(DISTINCT i.instrumentid, '!'), t.titlereference, i.instrumentreference,
   i.instrumenttype, MAX(i.memorialrecital), MAX(COALESCE(d.registrationdate, '29 JAN 2009')) AS reg_date,
   (CASE WHEN MAX(it.status) = 30 THEN 'current' ELSE 'historic' END) AS status
FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, lrs.dealing d
WHERE it.title = t.titleid
AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                        -- see title 638/3082 where 35354 and 35802 are duplicated
AND   i.instrumentid = it.instrument
AND   i.instrumenttype IN (3) -- Transmission (3)
AND   d.dealingid = i.dealing
AND   d.status = 24  -- Registered Dealing
AND   it.status IN (30, 33) -- Current Instrument (30), Registered Discharges (33)
GROUP BY t.titleid, t.titlereference, i.instrumentreference, i.instrumenttype;

UPDATE lrs.sola_transmission
SET sola_rrr_id = uuid_generate_v1(),
    sola_rrr_nr =  trim(to_char(nextval('administrative.rrr_nr_seq'), '000000'));

-- Add the cavaet rrr's
INSERT INTO administrative.rrr(id, ba_unit_id, is_primary, registration_date, type_code, status_code, nr, transaction_id, change_user)
SELECT sola_rrr_id, titleid, FALSE, CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
    'transmission', status, sola_rrr_nr, 'adm-transaction', 'test-id'
FROM lrs.sola_transmission
WHERE insttype = 3
AND EXISTS (SELECT id FROM administrative.ba_unit WHERE id = titleid); 

-- Add the caveat notations
INSERT INTO  administrative.notation(id, rrr_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
SELECT uuid_generate_v1(), sola_rrr_id, 'adm-transaction', 'test-id', CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
	  status, COALESCE(memorial, 'Transmission'),
 	  COALESCE(instref, '')
FROM  lrs.sola_transmission
WHERE insttype = 3
AND EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id);


-- *** Proclamations, Court Orders, Registry Dealings and Miscellaneous intruments ***
-- Create a table to help process the other rrrs 
DROP TABLE IF EXISTS lrs.sola_other_rrr;
CREATE TABLE lrs.sola_other_rrr (
   sola_rrr_id VARCHAR(40),
   sola_rrr_nr VARCHAR(20),
   titleid VARCHAR(40),
   instids VARCHAR(250),
   titleref VARCHAR(20),
   instref VARCHAR(20),
   insttype SMALLINT, 
   memorial VARCHAR(100),
   regdate timestamp without time zone,
   status VARCHAR(20));
   
-- Get all of the Proclamations, Court Orders and Miscellaneous, attempting to remove any duplicates based on instrument ref  
INSERT INTO lrs.sola_other_rrr (titleid, instids, titleref, instref, insttype, memorial, regdate, status)
SELECT t.titleid, string_agg(DISTINCT i.instrumentid, '!'), t.titlereference, i.instrumentreference,
   i.instrumenttype, MAX(i.memorialrecital), MAX(COALESCE(d.registrationdate, '29 JAN 2009')) AS reg_date,
    (CASE WHEN i.instrumenttype IN (12,13,99) AND MAX(it.status) = 30 THEN 'current' ELSE 'historic' END) AS status
FROM lrs.title t, lrs.instrumenttitle it, lrs.instrument i, lrs.dealing d
WHERE it.title = t.titleid
AND   it.status IS NOT NULL -- Spurious inst-title entries? - seems to affect mortgages, etc
	                        -- see title 638/3082 where 35354 and 35802 are duplicated
AND   i.instrumentid = it.instrument
AND   i.instrumenttype IN (12,13,99, 21) -- Proclamation (12), Court Order (13), Miscellaneous (99),
                                         -- Registry Dealing (21) (Reg dealing should always be historic
AND   d.dealingid = i.dealing
AND   d.status = 24  -- Registered Dealing
AND   it.status IN (30, 33) -- Current Instrument (30), Registered Discharges (33)
GROUP BY t.titleid, t.titlereference, i.instrumentreference, i.instrumenttype;


-- No processing required for these instruments, make them all current.
UPDATE lrs.sola_other_rrr
 SET sola_rrr_id = uuid_generate_v1(),
     sola_rrr_nr = trim(to_char(nextval('administrative.rrr_nr_seq'), '000000')); 

-- Add the other rrr's - note that registry dealing notations will be logged to historic miscellaneous rrrs
INSERT INTO administrative.rrr(id, ba_unit_id, is_primary, registration_date, type_code, status_code, nr, transaction_id, change_user)
SELECT sola_rrr_id, titleid, FALSE, (CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END), 
    (CASE insttype WHEN 12 THEN 'proclamation' WHEN 13 THEN 'order' ELSE 'miscellaneous' END), 
	(CASE insttype WHEN 21 THEN 'historic' ELSE 'current' END), sola_rrr_nr, 'adm-transaction', 'test-id'
FROM lrs.sola_other_rrr
WHERE sola_rrr_id IS NOT NULL
AND EXISTS (SELECT id FROM administrative.ba_unit WHERE id = titleid); 

-- Add the other notations. Registry dealing notations are historic, the others are set to current. 
INSERT INTO  administrative.notation(id, rrr_id, ba_unit_id, transaction_id, change_user, notation_date, status_code, notation_text, reference_nr) 
SELECT uuid_generate_v1(), sola_rrr_id, (CASE WHEN sola_rrr_id IS NULL THEN titleid ELSE NULL END), 
     'adm-transaction', 'test-id', CASE WHEN regdate = '29 JAN 2009' THEN NULL ELSE regdate END, 
	  status, COALESCE(memorial, (CASE insttype WHEN 12 THEN 'Proclamation' WHEN 13 THEN 'Court Order' 
	    WHEN 21 THEN 'Registry Dealing' ELSE 'Miscellaneous' END)),
 	  COALESCE(instref, '')
FROM  lrs.sola_other_rrr
WHERE EXISTS (SELECT id FROM administrative.rrr WHERE id = sola_rrr_id)
OR (sola_rrr_id IS NULL AND EXISTS (SELECT id FROM administrative.ba_unit WHERE id = titleid));
 

DROP SCHEMA IF EXISTS samoa_etl CASCADE;

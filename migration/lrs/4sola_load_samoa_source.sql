-- Script to load LRS Power of Attorney record into the SOLA administrative.power_of_attorney and associated  tables
--Neil Pullar 17 September 2012
-- approx run time 2 minutes

-- !!! MUST LOAD MIGRATED SOURCE RECORDS FIRST !!!

-- Remove any previously loaded records

DELETE FROM source.power_of_attorney;

--INSERT INTO source.archive(id, name) VALUES ('regnArchive', 'MNRE Registration Archive');
--INSERT INTO source.archive(id, name) VALUES ('qaArchive', 'MNRE Quality Assurance Archive');
--Update existing source records
UPDATE source.source
   SET maintype = 'imageDigital', archive_id = 'regnArchive', availability_status_code = 'available', transaction_id = 'adm-transaction', version = '1', change_user = 'test'
 WHERE type_code != 'cadastralSurvey';

 UPDATE source.source
   SET maintype = 'imageDigital', archive_id = 'qaArchive', availability_status_code = 'available', transaction_id = 'adm-transaction', version = '1', change_user = 'test'
 WHERE type_code = 'cadastralSurvey';

-- Update Power of Attorney Source records created by the SOLA Document migration with details from LRS. Make sure the type code is set to POA as some
-- documents may not have been placed in the correct network folders. 
UPDATE source.source 
   SET id = t.poaId, status_code = 'current', acceptance = t.lodgeDate, submission = t.lodgeDate, 
       description = 'POA migrated from LRS', change_user = 'test' FROM
	(SELECT poa.powerofattorneyid AS poaId, ldg.lodgementdate AS lodgeDate, sd.reference AS poaRef FROM lrs.lodgement ldg
		INNER JOIN lrs.supportingdocument sd ON (ldg.lodgementid = sd.lodgement)
		INNER JOIN lrs.powerofattorney poa ON (sd.supportingdocumentid = poa.supportingdocument)) t
WHERE source.la_nr = t.poaRef
AND source.type_code = 'powerOfAttorney';
 
INSERT INTO source.source(id, maintype, la_nr, reference_nr, archive_id, submission, acceptance, availability_status_code, 
			type_code, description, status_code, transaction_id, version, change_user)
		SELECT DISTINCT ON (sd1.reference) poa1.powerofattorneyid, 'imageDigital', sd1.reference, sd1.reference, 'regnArchive', lg1.lodgementdate, lg1.lodgementdate,
			'available', 'powerOfAttorney', 'POA migrated from LRS', 'current', 'adm-transaction', '1', 'test' FROM lrs.powerofattorney poa1
			INNER JOIN lrs.supportingdocument sd1 ON ((poa1.supportingdocument = sd1.supportingdocumentid) AND (sd1.reference IS NOT NULL))
			INNER JOIN lrs.lodgement lg1 ON (sd1.lodgement = lg1.lodgementid)
		WHERE 	sd1.reference NOT IN (SELECT la_nr FROM source.source WHERE type_code = 'powerOfAttorney');

-- Load source.power_of_attorney from lrs.PowerOfAttorney table
INSERT INTO source.power_of_attorney(id, person_name, attorney_name, change_user)
		SELECT DISTINCT ON (sd2.reference) poa2.powerofattorneyid, poa2.interestholder, poa2.attorneyinfact, 'test' FROM lrs.powerofattorney poa2
			INNER JOIN lrs.supportingdocument sd2 ON ((poa2.supportingdocument = sd2.supportingdocumentid) AND (sd2.reference IS NOT NULL))
			INNER JOIN source.source sc2 ON (sd2.reference = sc2.la_nr)
		WHERE poa2.powerofattorneyid IN (SELECT id FROM source.source WHERE type_code = 'powerOfAttorney')
		AND poa2.powerofattorneyid NOT IN (SELECT id FROM source.power_of_attorney);
--Update cancelled POA
UPDATE source.source SET  status_code = 'historic', expiration_date = NOW()
WHERE source.id IN 	(SELECT id FROM source.power_of_attorney WHERE SUBSTRING(attorney_name FROM 1 for 12) = 'CANCELLED - ');

UPDATE source.power_of_attorney SET  
 attorney_name = SUBSTRING(attorney_name FROM 13 for (CHAR_LENGTH(attorney_name) - 12)),
 person_name = SUBSTRING(person_name FROM 13 for (CHAR_LENGTH(person_name) - 12))
WHERE SUBSTRING(attorney_name FROM 1 for 12) = 'CANCELLED - ';


-- Standard Memorandum

-- Standard Memorandum are loaded as memorandum into SOLA. Update the la_nr to be consistent with the LRS 
-- document numbering convention of 21000 and above
 UPDATE source.source
 SET la_nr = SUBSTRING(la_nr FROM 1 FOR 5)
 WHERE type_code IN ( 'memorandum' , 'standardDocument'); 

-- Update the SOLA standard docs with details from LRS. 
UPDATE source.source 
   SET id = t.sdId, status_code = 'current', type_code = 'standardDocument', acceptance = t.lodgeDate, submission = t.lodgeDate, 
       description = t.docDesc, change_user = 'test' FROM
	(SELECT sd.supportingdocumentid AS sdId, ldg.lodgementdate AS lodgeDate, sd.reference AS docRef, sd.description AS docDesc FROM lrs.lodgement ldg
		INNER JOIN lrs.supportingdocument sd ON (ldg.lodgementid = sd.lodgement)
		WHERE sd.reference IS NOT NULL
		AND   sd.reference like '21%') t
WHERE source.la_nr = t.docRef;

-- Insert any standard memorandum from LRS that do not have attachments in SOLA. 
INSERT INTO source.source(id, maintype, la_nr, reference_nr, archive_id, submission, acceptance, availability_status_code, 
			type_code, description, status_code, transaction_id, version, change_user)
SELECT DISTINCT ON (sd.reference) sd.supportingdocumentid, 'imageDigital', sd.reference, sd.reference, 'regnArchive', ldg.lodgementdate, ldg.lodgementdate,
	'available', 'standardDocument', sd.description, 'current', 'adm-transaction', '1', 'test' 
FROM 	lrs.lodgement ldg INNER JOIN lrs.supportingdocument sd ON (ldg.lodgementid = sd.lodgement)
WHERE 	sd.reference IS NOT NULL
AND   	sd.reference like '21%'
AND 	sd.reference NOT IN (SELECT la_nr FROM source.source WHERE type_code = 'standardDocument');
 

--Title image links

--UPDATE administrative.ba_unit SET name = name_firstpart || '-' || name_lastpart
--WHERE type_code = 'basicPropertyUnit';

DELETE FROM  administrative.source_describes_ba_unit; 

INSERT INTO administrative.source_describes_ba_unit(ba_unit_id, source_id, change_user)
SELECT ba.id, sc.id, 'test' FROM administrative.ba_unit ba
		INNER JOIN source.source sc ON (ba.name_firstpart || '-' || ba.name_lastpart = sc.la_nr)
	WHERE ba.id NOT IN (Select ba_unit_id FROM administrative.source_describes_ba_unit);


UPDATE source.source 
   SET acceptance = t.issueDate, status_code = 'current', change_user = 'test' FROM
	(SELECT tt.dateofcurrenttitle AS issueDate, ba.name_firstpart || '-' || ba.name_lastpart AS titleRef FROM administrative.ba_unit ba
		INNER JOIN lrs.title tt ON (ba.id = tt.titleid)) t
WHERE type_code = 'newFormFolio'
AND source.la_nr = t.titleRef;

--Registered Instruments
DELETE FROM administrative.source_describes_rrr; 

INSERT INTO administrative.source_describes_rrr(rrr_id, source_id, change_user)
SELECT DISTINCT rr.id, sc.id, 'test' FROM administrative.rrr rr, administrative.notation n, source.source sc
WHERE rr.id = n.rrr_id and n.reference_nr = sc.la_nr
AND NOT EXISTS (SELECT rrr_id FROM administrative.source_describes_rrr 
 WHERE rrr_id = rr.id AND source_id = sc.id);

UPDATE source.source 
   SET acceptance = t.regnDate, status_code = 'current', change_user = 'test' FROM
  (SELECT MIN(r.registration_date) AS regnDate, n.reference_nr AS docRef 
	 FROM administrative.rrr r, administrative.notation n
	 WHERE r.id = n.rrr_id and r.registration_date IS NOT NULL
	 GROUP BY n.reference_nr) t
WHERE type_code = 'registered'
AND source.la_nr = t.docRef;

--Application Documents 
DELETE FROM application.application_uses_source; 

INSERT INTO application.application_uses_source(application_id, source_id, change_user)
WITH instruments AS (
	SELECT DISTINCT d.lodgement AS lId, i.instrumentreference AS instRef 
	FROM lrs.dealing d, lrs.instrument i
	WHERE i.dealing = d.dealingid
	AND d.rejecteddealing IS NULL
	AND d.registrydealingreason IS NULL
	AND COALESCE(i.instrumentreference, '') != '')
SELECT DISTINCT lId, sc.id, 'test' FROM instruments, source.source sc
WHERE sc.la_nr = instRef
AND NOT EXISTS (SELECT application_id FROM application.application_uses_source
 WHERE application_id = lId AND source_id = sc.id);



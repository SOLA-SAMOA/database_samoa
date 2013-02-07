-- Script to load LRS Lodgement record into the SOLA application and associated  tables
--Neil Pullar 20 June 2012

-- Script run time approx 2 minute.
--
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

--
--SOLA Data Model Required Corrections
 
-- Disable all triggers
ALTER TABLE application.application DISABLE TRIGGER ALL;
ALTER TABLE application.service DISABLE TRIGGER ALL;

-- Go on with the script
--
-- Remove any previous records
--DELETE FROM address.address;
DELETE FROM application.service;
DELETE FROM application.application_property;
DELETE FROM application.application;
--DELETE FROM party.party WHERE id IN (SELECT party.party.id FROM party.party, party.party_role WHERE party.party.id = party.party_role.party_id AND party.party_role.type_code = 'lodgingAgent');
--DELETE FROM party.party_role WHERE type_code = 'lodgingAgent';
--DELETE FROM system.appuser WHERE id != 'test-id';
    
-- Load Agents
INSERT INTO address.address(id, description, change_user)      
                SELECT agentid, TRIM(address1 || ' ' || COALESCE(address2, '')), 'test-id' FROM lrs.lodgingagent 
                WHERE address1 IS NOT NULL
                AND agentid NOT IN (SELECT id FROM address.address);
                
INSERT INTO party.party(id, ext_id, type_code, name, phone, fax, change_user)
                SELECT agentid, 'LRS LODGING AGENT', 'nonNaturalPerson', TRIM(firstname || ' ' || lastname), phone, fax, 'test-id' FROM lrs.lodgingagent
                WHERE agentid NOT IN (SELECT id FROM party.party);

INSERT INTO party.party(id, type_code, name, change_user) 
		SELECT DISTINCT '99', 'nonNaturalPerson', 'Agent Not Known in LRS Migrated Data', 'test-id' FROM lrs.lodgingagent
		WHERE '99' NOT IN (SELECT id FROM party.party);

UPDATE party.party SET address_id = id WHERE ext_id = 'LRS LODGING AGENT' AND id IN (SELECT id FROM address.address);

-- Lodging Agents for Samoa already loaded so don't add unnecesary duplicates
-- INSERT INTO party.party_role(party_id, type_code)
-- 		SELECT agentid, 'lodgingAgent' FROM lrs.lodgingagent
-- 		WHERE agentid IN (SELECT id FROM party.party)
-- 		AND agentid NOT IN (SELECT party_id FROM party.party_role);
-- 		
-- INSERT INTO party.party_role(party_id, type_code) VALUES ('99', 'lodgingAgent');

-- Load MNRE Staff
--lrs.loginname are not unique - triplicates exist
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active)
		SELECT  DISTINCT ON (loginname) userid, loginname, firstname, lastname, '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', status FROM lrs.users
		WHERE userid NOT IN (SELECT id FROM system.appuser);

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active)
		SELECT  DISTINCT ON (us.loginname) us.userid, us.loginname || '2', us.firstname, us.lastname, '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', us.status FROM lrs.users us
			INNER JOIN system.appuser au ON ((us.loginname = au.username)  AND (us.userid != au.id))
		WHERE us.userid NOT IN (SELECT id FROM system.appuser);

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active)
		SELECT  DISTINCT ON (us2.loginname) us2.userid, us2.loginname || '3', us2.firstname, us2.lastname, '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', us2.status FROM lrs.users us2
			INNER JOIN system.appuser au ON ((us2.loginname = au.username)  AND (us2.userid != au.id))
		WHERE us2.userid NOT IN (SELECT id FROM system.appuser);

-- Load Lodgements For Instruments (into SOLA application.application)
/*INSERT INTO application.application(id, nr, agent_id, contact_person_id, lodging_datetime, expected_completion_date, assignee_id, assigned_datetime, services_fee, tax, total_amount_paid, fee_paid, action_code, status_code, change_user, change_time, rowversion)
		SELECT DISTINCT ON (lodgementid) lodgementid, instrumentreference, COALESCE(lodgingagent, '99'), lodgingagent, lodgementdate, lodgementdate, currentlyassigned, CASE WHEN currentlyassigned IS NOT NULL THEN lodgementdate END, 0.00, 0.00, 0.00, TRUE, 
		CASE WHEN lrs.dealing.status = 10 THEN 'archive' WHEN lrs.dealing.status = 24 THEN 'archive' WHEN lrs.dealing.status = 11 THEN 'cancel'  WHEN lrs.dealing.status = 12 THEN 'withdraw'  WHEN lrs.dealing.status = 13 THEN 'lapse' WHEN lrs.dealing.status = 23 THEN 'requisition' ELSE 'lodge' END,
		CASE WHEN lrs.dealing.status = 10 THEN 'completed' WHEN lrs.dealing.status = 24 THEN 'completed' WHEN lrs.dealing.status = 11 THEN 'annulled' WHEN lrs.dealing.status = 12 THEN 'annulled'  WHEN lrs.dealing.status = 13 THEN 'annulled' WHEN lrs.dealing.status = 23 THEN 'requisitioned' ELSE 'lodged' END, 
		   'test-id', COALESCE(lrs.dealing.registrationdate, lrs.lodgement.lodgementdate), 1 FROM lrs.lodgement
		INNER JOIN lrs.dealing ON (lrs.lodgement.lodgementid = lrs.dealing.lodgement)
		INNER JOIN lrs.instrument ON (lrs.dealing.dealingid = lrs.instrument.dealing)
		WHERE instrumentreference IS NOT NULL
		AND lodgementid NOT IN (SELECT id FROM application.application)
		AND COALESCE(lodgingagent, '99') IN (SELECT id FROM party.party);*/
		
INSERT INTO application.application(id, nr, agent_id, contact_person_id, lodging_datetime, expected_completion_date, 
assignee_id, assigned_datetime, services_fee, tax, total_amount_paid, fee_paid, action_code, status_code, 
change_user, change_time, rowversion)		
WITH lodgements AS (
	SELECT l.lodgementid AS lId, MIN(i.instrumentreference) AS instRef
	FROM lrs.lodgement l, lrs.dealing d, lrs.instrument i
	WHERE d.lodgement = l.lodgementid
	AND i.dealing = d.dealingid
	AND d.rejecteddealing IS NULL
	AND d.registrydealingreason IS NULL
	AND COALESCE(i.instrumentreference, '') != ''
	AND d.lodgement != '1' -- Make sure the LRS migration lodgement is not migrated to SOLA
	GROUP BY l.lodgementid)
SELECT lId, instRef, COALESCE(l.lodgingagent, '99') AS agent, l.lodgingagent, l.lodgementdate, l.lodgementdate, l.currentlyassigned, 
	CASE WHEN l.currentlyassigned IS NOT NULL THEN l.lodgementdate END, 0.00, 0.00, 0.00, TRUE, 
	CASE MAX(d.status) WHEN 10 THEN 'archive' WHEN 24 THEN 'archive' WHEN 11 THEN 'cancel'  WHEN 12 THEN 'withdraw'  WHEN 13 THEN 'lapse' WHEN 23 THEN 'requisition' ELSE 'lodge' END,
	CASE MAX(d.status) WHEN 10 THEN 'completed' WHEN 24 THEN 'completed' WHEN 11 THEN 'annulled' WHEN 12 THEN 'annulled'  WHEN 13 THEN 'annulled' WHEN 23 THEN 'requisitioned' ELSE 'lodged' END, 
	   'test-id', COALESCE(MIN(d.registrationdate), l.lodgementdate), 1 FROM 
	lrs.lodgement l, lrs.dealing d, lodgements
	WHERE lId = l.lodgementId
	AND   d.lodgement = lId
	AND lId NOT IN (SELECT id FROM application.application)
	AND COALESCE(l.lodgingagent, '99') IN (SELECT id FROM party.party)
	GROUP BY lId, instRef, agent, l.lodgingagent, l.lodgementdate, l.currentlyassigned;

-- Load Lodgements For Powers of Attorney (into SOLA application.application)
INSERT INTO application.application(id, nr, agent_id, contact_person_id, lodging_datetime, expected_completion_date, assignee_id, assigned_datetime, services_fee, tax, total_amount_paid, fee_paid, action_code, status_code, change_user, change_time, rowversion)
		SELECT DISTINCT ON (lodgementid) lodgementid, 'POA' || reference, COALESCE(lodgingagent, '99'), lodgingagent, lodgementdate, lodgementdate, currentlyassigned, CASE WHEN currentlyassigned IS NOT NULL THEN lodgementdate END, 0.00, 0.00, 0.00, TRUE, 
		 'archive',  'completed', 'test-id', lrs.lodgement.lodgementdate, 1 FROM lrs.lodgement
		INNER JOIN lrs.supportingdocument ON (lrs.lodgement.lodgementid = lrs.supportingdocument.lodgement)
		INNER JOIN lrs.powerofattorney ON (lrs.supportingdocument.supportingdocumentid = lrs.powerofattorney.supportingdocument)
		WHERE attorneyinfact IS NOT NULL
		AND reference IS NOT NULL
		AND lodgementid NOT IN (SELECT id FROM application.application)
		AND COALESCE(lodgingagent, '99') IN (SELECT id FROM party.party);

-- Load Lodgements For Standard Documents(into SOLA application.application)
INSERT INTO application.application(id, nr, agent_id, contact_person_id, lodging_datetime, expected_completion_date, assignee_id, assigned_datetime, services_fee, tax, total_amount_paid, fee_paid, action_code, status_code, change_user, change_time, rowversion)
		SELECT DISTINCT ON (lodgementid) lodgementid, 'STD' || reference, COALESCE(lodgingagent, '99'), lodgingagent, lodgementdate, lodgementdate, currentlyassigned, CASE WHEN currentlyassigned IS NOT NULL THEN lodgementdate END, 0.00, 0.00, 0.00, TRUE, 
		 'archive',  'completed', 'test-id', lrs.lodgement.lodgementdate, 1 FROM lrs.lodgement
		INNER JOIN lrs.supportingdocument ON (lrs.lodgement.lodgementid = lrs.supportingdocument.lodgement)
		WHERE reference IS NOT NULL
		AND lodgementid NOT IN (SELECT id FROM application.application)
		AND COALESCE(lodgingagent, '99') IN (SELECT id FROM party.party);

-- Load any remainingLodgements (into SOLA application.application)		
INSERT INTO application.application(id, nr, agent_id, contact_person_id, lodging_datetime, expected_completion_date, assignee_id, assigned_datetime, services_fee, tax, total_amount_paid, fee_paid, action_code, status_code, change_user, change_time, rowversion)
		SELECT DISTINCT ON (lodgementid) lodgementid, lodgementreference, COALESCE(lodgingagent, '99'), lodgingagent, lodgementdate, lodgementdate, currentlyassigned, CASE WHEN currentlyassigned IS NOT NULL THEN lodgementdate END, 0.00, 0.00, 0.00, TRUE, 'archive', 'completed', 
		'test-id', lodgementdate, 1 FROM lrs.lodgement
		WHERE lodgementid NOT IN (SELECT id FROM application.application)
		AND COALESCE(lodgingagent, '99') IN (SELECT id FROM party.party);

--Load application.service for Powers of Attorney
INSERT INTO application.service(id, application_id, request_type_code, service_order, lodging_datetime, expected_completion_date, status_code, action_code, base_fee, area_fee, value_fee, change_user, change_time, rowversion) 		
		SELECT DISTINCT ON (supportingdocumentid) supportingdocumentid, lodgementid, 'regnPowerOfAttorney', 1, lodgementdate, lodgementdate, 'completed', 'complete', 0.00, 0.00, 0.00, 'test-id', app.change_time, 1 
		FROM lrs.supportingdocument INNER JOIN lrs.lodgement ON (lrs.supportingdocument.lodgement = lrs.lodgement.lodgementid)
		INNER JOIN lrs.powerofattorney ON (lrs.supportingdocument.supportingdocumentid = lrs.powerofattorney.supportingdocument), 
		application.application app
		WHERE lrs.supportingdocument.reference IS NOT NULL
		AND lrs.supportingdocument.supportingdocumentid IN (SELECT supportingdocument FROM lrs.powerofattorney) 
		AND supportingdocumentid NOT IN (SELECT id FROM application.service)
		AND lodgementid = app.id;

-- Load application.service for (Standard) Supporting Documents
INSERT INTO application.service(id, application_id, request_type_code, service_order, lodging_datetime, expected_completion_date, status_code, action_code, base_fee, area_fee, value_fee, change_user, change_time, rowversion) 		
		SELECT DISTINCT ON (supportingdocumentid) supportingdocumentid, lodgementid, 'regnStandardDocument', 1, lodgementdate, lodgementdate, 'completed', 'complete', 0.00, 0.00, 0.00, 'test-id', app.change_time, 1
		FROM lrs.supportingdocument INNER JOIN lrs.lodgement ON (lrs.supportingdocument.lodgement = lrs.lodgement.lodgementid),
		application.application app
		WHERE lrs.supportingdocument.reference IS NOT NULL
		AND supportingdocumentid NOT IN (SELECT id FROM application.service)
		AND lodgementid = app.id;

-- Load application.service from lrs.dealing table (ignoring rejected dealing and registry dealing reason fields)
INSERT INTO application.service(id, application_id, request_type_code, service_order, lodging_datetime, 
expected_completion_date, status_code, action_code, base_fee, area_fee, 
value_fee, change_user, change_time, rowversion)
WITH instruments AS (
	SELECT d.lodgement AS lId, i.instrumentreference AS instRef, 
	      i.instrumenttype AS instType,
	      MIN(i.instrumentId) AS instId,
	      MAX(d.status) AS dstatus, 
	      MIN(i.registrationdate) AS regDate
	FROM lrs.dealing d, lrs.instrument i
	WHERE i.dealing = d.dealingid
	AND d.rejecteddealing IS NULL
	AND d.registrydealingreason IS NULL
	AND COALESCE(i.instrumentreference, '') != ''
	GROUP BY d.lodgement, i.instrumentreference, i.instrumenttype)
SELECT instId, lId,
CASE  WHEN instType = 2 THEN 'newOwnership' 
	WHEN instType = 3 THEN 'transmission' 
	WHEN instType = 4 THEN 'mortgage' 
	WHEN instType = 5 THEN 'removeRestriction' 
	WHEN instType = 6 THEN 'variationMortgage' 
	WHEN instType = 7 THEN 'registerLease' 
	WHEN instType = 8 THEN 'varyLease' 
	WHEN instType = 9 THEN 'removeRight' 
	WHEN instType = 10 THEN 'caveat' 
	WHEN instType = 11 THEN 'removeCaveat' 
	WHEN instType = 12 THEN 'proclamation'
	WHEN instType = 13 THEN 'order'
	WHEN instType = 18 THEN 'certifiedCopy' 
	WHEN instType = 20 THEN 'cadastreChange' 
	WHEN instType = 21 THEN 'registrarCorrection' 
	--WHEN instType = 22 THEN 'transferWithEasement' Service does not exist in SOLA Samoa
	--WHEN instType = 23 THEN 'transferWithRestrict' Service does not exist in SOLA Samoa
	WHEN instType = 31 THEN 'regnPowerOfAttorney' 
	WHEN instType = 34 THEN 'subLease' 
	WHEN instType = 35 THEN 'removeRight' 
	WHEN instType = 36 THEN 'varyLease'
	WHEN instType = 99 THEN 'miscellaneous' 			
	END,
 1, app.lodging_datetime, app. expected_completion_date,
CASE dstatus WHEN 10 THEN 'completed' WHEN 24 THEN 'completed' WHEN 11 THEN 'cancelled' WHEN 12 THEN 'cancelled'  WHEN 13 THEN 'cancelled' ELSE 'lodged' END,
CASE dstatus WHEN 10 THEN 'complete' WHEN 24 THEN 'complete' WHEN 11 THEN 'cancel'  WHEN 12 THEN 'cancel'  WHEN 13 THEN 'cancel' ELSE 'lodge' END,
0.00, 0.00, 0.00, 'test-id', COALESCE(regDate, app.change_time), 1  
FROM instruments, application.application app
WHERE app.id = lid
AND NOT EXISTS (SELECT id FROM application.service WHERE id = instId);


-- Add all properties to the applications. 
INSERT INTO application.application_property(id, application_id, name_firstpart, name_lastpart, area, ba_unit_id, change_user)
WITH app_props AS (
	SELECT d.lodgement AS lId, it.title AS tId 
	FROM lrs.dealing d, lrs.instrument i,
	     lrs.instrumenttitle it
	WHERE i.dealing = d.dealingid
	AND   it.instrument = i.instrumentid
	AND d.rejecteddealing IS NULL
	AND d.registrydealingreason IS NULL
	AND COALESCE(i.instrumentreference, '') != ''
	GROUP BY d.lodgement, it.title)
SELECT uuid_generate_v1(), lId, ba.name_firstpart, ba.name_lastpart, ar.size, ba.id, 'test'  
	FROM  administrative.ba_unit ba, administrative.ba_unit_area ar, app_props
	WHERE ba.id = tId
	AND   ar.ba_unit_id = ba.id 
	AND   EXISTS (SELECT id FROM application.application WHERE id = lId);  


DROP SCHEMA IF EXISTS samoa_etl CASCADE;

ALTER TABLE application.application ENABLE TRIGGER ALL;
ALTER TABLE application.service ENABLE TRIGGER ALL;

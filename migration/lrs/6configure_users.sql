 SET search_path = public, pg_catalog;


-- Configure users and roles for SOLA Samoa
-- Add users not migrated from LRS  
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'andrew', 'Andrew', 'McDowell', '7e2dff3c8e56a95708bf095ffaf0213ff756319606541b3ac89d1ad60705d0cd', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'andrew'));
   
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'hilton', 'Hilton', 'So''o', '7e2dff3c8e56a95708bf095ffaf0213ff756319606541b3ac89d1ad60705d0cd', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'hilton'));
   
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'tufi', 'Tufi', 'Auelua', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'tufi'));
   
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'semi', 'Semi', 'Peteru', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'semi'));
   
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'ese', 'Ese', 'Suisala', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'ese'));
   
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'tuaoloa', 'Tuaoloa', 'Pokati', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'tuaoloa'));

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'pasese', 'Pasese', 'Pasese', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'pasese'));  

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'larry', 'Larry', 'Fasimaau', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'larry'));     
   
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'petania', 'Petania', 'Tuala', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'petania'));  

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'fenika', 'Fenika', 'Oloapu', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'fenika'));    

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'toelau', 'Safuta Toelau', 'Iulio', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'toelau'));    

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'pisila', 'Pisila', 'Pauli', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'pisila')); 

INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'laavasa', 'Taule''ale''ausumai La''avasa', 'Malua', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'laavasa')); 
   
-- Update, remove and disable user accounts as required. 
DELETE FROM system.appuser_appgroup; 
DELETE FROM system.appuser WHERE username IN ('qauser', 'landreguser'); 
DELETE FROM system.appuser WHERE username = 'admin'; 
UPDATE system.appuser SET username = LOWER(username);
UPDATE system.appuser SET active = 'f' WHERE username IN ('dcdb-migration', 'test');

UPDATE system.appuser SET passwd = '7e2dff3c8e56a95708bf095ffaf0213ff756319606541b3ac89d1ad60705d0cd'
WHERE username IN ('admin', 'admin2', 'neil'); 

UPDATE system.appuser SET first_name = 'SOLA'
WHERE username IN ('admin', 'admin2'); 
UPDATE system.appuser SET last_name = 'Admin (2)'
WHERE username IN ('admin2'); 
UPDATE system.appuser SET username = 'pele'
WHERE username = 'pcm'; 
UPDATE system.appuser SET username = 'peta'
WHERE username = 'e-leato';  
UPDATE system.appuser SET username = 'tuii'
WHERE username = 'tuii.taua';    

-- Hide the super users from the list of users that can be assigned to applications
DELETE FROM system.approle_appgroup 
WHERE approle_code = 'ApplnAssignSelf' AND appgroup_id = 'super-group-id';  

-- Tidy up some of the duplicate usernames
DELETE FROM system.appuser WHERE username IN ('fala2', 'niko2', 'tavita2', 'tavita3', 'tua2', 'tua3')
AND NOT EXISTS (SELECT id FROM application.application a WHERE a.assignee_id = system.appuser.id);
UPDATE 	system.appuser SET 	last_name = last_name || ' (2)', active = 'f'
WHERE 	username IN ('fala2', 'niko2', 'tavita2', 'tua2');
UPDATE 	system.appuser SET 	last_name = last_name || ' (3)', active = 'f'
WHERE 	username IN ('tavita3', 'tua3');
   
-- Disable user accounts on the production system and enable as required. 
UPDATE system.appuser SET active = 'f' 
WHERE username NOT IN ('andrew', 'admin', 'admin2'); 

-- Security Role Configurations
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'andrew'), 'super-group-id'); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'neil'), 'super-group-id'); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'hilton'), 'super-group-id'); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'admin'), (SELECT id FROM system.appgroup WHERE "name" = 'Administrator'));  
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'admin2'), (SELECT id FROM system.appgroup WHERE "name" = 'Administrator'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'pele'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'pele'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'pele'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'peta'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'peta'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader')); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tufi'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tufi'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'semi'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tuaoloa'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'ese'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'ese'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader')); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'pasese'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'larry'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'dennis'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'fala'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'fala'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'isitolo'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'moira'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'niko'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'niko'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'nimo'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'pati'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'petelo'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'sapati'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'sefo'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'sita'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'sita'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tavita'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tua'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tua'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'tuii'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'petania'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'fenika'), (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'toelau'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'toelau'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'pisila'), (SELECT id FROM system.appgroup WHERE "name" = 'Accounts'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'laavasa'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'laavasa'), (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'));
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'laavasa'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'));


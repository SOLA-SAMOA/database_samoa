
-- Load Firms (Hilton: 16-May-2012) 
ALTER TABLE application.application 
	ALTER COLUMN agent_id SET NOT NULL,
	ALTER COLUMN contact_person_id DROP NOT NULL;

INSERT INTO party.party (id,type_code,name, change_user)
SELECT '1','nonNaturalPerson','Other Agent','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '1');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '1','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '1' AND type_code = 'lodgingAgent');
	
INSERT INTO address.address (id,description,change_user)
SELECT '7','Matafele, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '7');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '7','nonNaturalPerson','Piki Surveying Firm','7','24577', 'Piki','Tuala','tuala.surveying@yahoo.com',null, 'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '7');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '7','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '7' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '7','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '7' AND type_code = 'surveyor');

INSERT INTO address.address (id,description,change_user)
SELECT '8','Tamaligi, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '8');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '8','nonNaturalPerson','Soloi Survey Services','8','30877', 'Keilani L','Soloi','surveys@ipasefika.net',null,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '8');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '8','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '8' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '8','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '8' AND type_code = 'surveyor');

INSERT INTO address.address (id,description,change_user)
SELECT '9','Vaitele, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '9');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '9','nonNaturalPerson','Sepulona Surveying Firm','9','7772871', 'Sooalo Viliamu','Sepulona',null,null,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '9');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '9','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '9' AND type_code = 'lodgingAgent');  
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '9','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '9' AND type_code = 'surveyor');

INSERT INTO address.address (id,description,change_user)
SELECT '10','Tufuiopa, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '10');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '10','nonNaturalPerson','National Surveyor','10','20900', 'Alaisa Sagalala','Salanoa',null,null,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '10');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '10','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '10' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '10','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '10' AND type_code = 'surveyor');

INSERT INTO address.address (id,description,change_user)
SELECT '11','Tamaligi, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '11');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '11','nonNaturalPerson','Pelo Surveying Firm','11','24572', 'Lemalu Enokati','Pelo',null,null,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '11');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '11','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '11' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '11','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '11' AND type_code = 'surveyor');

INSERT INTO address.address (id,description,change_user)
SELECT '12','Vaitele, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '12');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '12','nonNaturalPerson','Samoa Land Corporation','12','24481','Levei','Tanoi-Auelua','l.auelua@samoaland.gov.ws',null,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '12');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '12','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '12' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '12','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '12' AND type_code = 'surveyor');

INSERT INTO address.address (id,description,change_user)
SELECT '15','Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '15');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile, change_user)
SELECT '15','nonNaturalPerson','MNRE Surveying','15',null,null,null,null,null,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '15');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '15','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '15' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '15','surveyor','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '15' AND type_code = 'surveyor');

-- Lawyers
INSERT INTO address.address (id,description,change_user)
SELECT '50','Matafele','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '50');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '50','nonNaturalPerson','Latu Lawyers','50','30363',NULL,NULL,'heather-latu@latulaw.com',null,'30365','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '50');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '50','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '50' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '50','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '50' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '51','Tamaligi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '51');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '51','nonNaturalPerson','Raymond Schuster','51','29281',NULL,NULL,'raymond@schusterananndale.com',NULL,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '51');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '51','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '51' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '51','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '51' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '52','Tamaligi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '52');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '52','nonNaturalPerson','Roma & Fepuleai','52','24646',NULL,NULL,'fepuleai@lesamoa.net', '30295' ,'23048','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '52');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '52','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '52' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '52','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '52' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '53','Tamaligi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '53');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '53','nonNaturalPerson','Leung Wai','53','22231',NULL,NULL,'LW.law@ipasifika.net', '30233' ,'20600','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '53');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '53','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '53' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '53','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '53' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '54','Savalalo','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '54');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '54','nonNaturalPerson','Brunt Lawyers','54','30627',NULL,NULL,'bruntkeli@ipasifika.net', NULL ,'30629','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '54');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '54','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '54' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '54','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '54' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '55','Saleufi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '55');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '55','nonNaturalPerson','Salma Hazelman','55','32564',NULL,NULL,'hazelman@lesamoa.net', '32563' ,'32566','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '55');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '55','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '55' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '55','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '55' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '56','Saleufi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '56');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '56','nonNaturalPerson','Meredith','56','24135',NULL,NULL,'malaw@ipasifika.net', '26927' ,'23713','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '56');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '56','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '56' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '56','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '56' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '57','Matafele','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '57');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '57','nonNaturalPerson','Stevenson','57','21751',NULL,NULL,'stevelaw@ipasifik.net', '21754' ,'24166','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '57');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '57','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '57' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '57','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '57' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '58','Levili','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '58');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '58','nonNaturalPerson','Toailoa','58','26383',NULL,NULL,'toalaw@ipasifika.net', '32572' ,'24504','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '58');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '58','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '58' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '58','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '58' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '59','Savalalo','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '59');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '59','nonNaturalPerson','Tuala & Tuala','59','21649',NULL,NULL,'st@t3lawsamoa.ws', '21660' ,'32394','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '59');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '59','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '59' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '59','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '59' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '60','Savalalo','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '60');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '60','nonNaturalPerson','Drake & Company','60','20025',NULL,NULL,NULL, '24280' ,'23253','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '60');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '60','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '60' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '60','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '60' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '61','Matafele','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '61');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '61','nonNaturalPerson','Enari','61','21406',NULL,NULL,NULL, '21758' ,'21407','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '61');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '61','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '61' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '61','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '61' AND type_code = 'lawyer');


INSERT INTO address.address (id,description,change_user)
SELECT '62','Fugalei','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '62');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '62','nonNaturalPerson','Vaai & Tamati','62','20545',NULL,NULL,'lanivaa@gmail.com', '25919' ,'24103','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '62');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '62','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '62' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '62','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '62' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '63','Max Building, Saleufi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '63');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '63','nonNaturalPerson','Rosela Papalii','63','27430',NULL,NULL,'rvpapalii@gmail.com', NULL ,'27433','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '63');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '63','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '63' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '63','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '63' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '64','Matafele','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '64');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '64','nonNaturalPerson','Clarke Lawyers','64','28012',NULL,NULL,'admin@clarkelawyers.net', NULL ,'28014','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '64');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '64','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '64' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '64','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '64' AND type_code = 'lawyer');

INSERT INTO address.address (id,description,change_user)
SELECT '65','Malifi','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '65');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '65','nonNaturalPerson','Ainuu','65','28441',NULL,NULL,'fkainuu@ipasifika.net', NULL ,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '65');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '65','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '65' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '65','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '65' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '66','nonNaturalPerson','Tasi Malifa',NULL,'30461',NULL,NULL,NULL, '30462' ,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '66');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '66','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '66' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '66','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '66' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '67','nonNaturalPerson','Sarona & Ponifasio',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '67');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '67','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '67' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '67','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '67' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '68','nonNaturalPerson','Treena Atoa',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '68');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '68','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '68' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '68','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '68' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '69','nonNaturalPerson','Tima Leavai',NULL,'22005',NULL,NULL,NULL,NULL,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '69');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '69','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '69' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '69','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '69' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '70','nonNaturalPerson','Maiava Peteru',NULL,'24310',NULL,NULL,NULL,'20799',NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '70');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '70','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '70' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '70','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '70' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '71','nonNaturalPerson','Tony Pereira',NULL,'25236',NULL,NULL,NULL,NULL,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '71');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '71','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '71' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '71','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '71' AND type_code = 'lawyer');

INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '72','nonNaturalPerson','Pereira-Philipp',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '72');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '72','lodgingAgent','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '72' AND type_code = 'lodgingAgent');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '72','lawyer','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '72' AND type_code = 'lawyer');


-- Add Banks into SOLA
INSERT INTO address.address (id,description,change_user)
SELECT '200','Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '200');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '200','nonNaturalPerson','Development Bank of Samoa','200','22861',NULL,NULL,'info@dbsamoa.ws',NULL,'23888','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '200');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '200','bank','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '200' AND type_code = 'bank');

INSERT INTO address.address (id,description,change_user)
SELECT '201','Methodist Church Building, Matafele, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '201');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '201','nonNaturalPerson','Samoa Commercial Bank Limited','201','31233',NULL,NULL,'info@scbl.ws',NULL,'30250','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '201');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '201','bank','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '201' AND type_code = 'bank');

INSERT INTO address.address (id,description,change_user)
SELECT '203','ACB Building, Beach Road, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '203');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '203','nonNaturalPerson','National Bank of Samoa','203','26766',NULL,NULL,NULL,NULL,'23477','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '203');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '203','bank','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '203' AND type_code = 'bank');

INSERT INTO address.address (id,description,change_user)
SELECT '204','Beach Road, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '204');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '204','nonNaturalPerson','ANZ Bank (Samoa) Limited','204','69999',NULL,NULL,NULL,NULL,'24595','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '204');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '204','bank','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '204' AND type_code = 'bank');

INSERT INTO address.address (id,description,change_user)
SELECT '205','Beach Road, Apia','test'
WHERE NOT EXISTS (SELECT id FROM address.address WHERE id = '205');
INSERT INTO party.party (id,type_code,name, address_id, phone, fathers_name, fathers_last_name, email,mobile,fax, change_user)
SELECT '205','nonNaturalPerson','Westpac Bank Samoa Limited','205','20000',NULL,NULL,'westpacsamoa@westpac.com.au',NULL,'22848','test'
WHERE NOT EXISTS (SELECT id FROM party.party WHERE id = '205');
INSERT INTO party.party_role (party_id,type_code,change_user)
SELECT '205','bank','test'
WHERE NOT EXISTS (SELECT party_id FROM party.party_role WHERE party_id = '205' AND type_code = 'bank');


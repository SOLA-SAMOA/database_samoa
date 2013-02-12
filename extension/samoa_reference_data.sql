-- Configure Samoan Language Translations for Code Reference values
DELETE FROM system.language; 
INSERT INTO system.language (code, display_value, active, is_default, item_order)
VALUES ('en', 'English::::Faapalagi', TRUE, TRUE, 1);
INSERT INTO system.language (code, display_value, active, is_default, item_order)
VALUES ('sm', 'Samoan::::Faasamoa', TRUE, FALSE, 2);

-- Add Samoan Transalations for reference codes. 
UPDATE source.availability_status_type SET display_value = 'Converted::::Faaliliuina' WHERE code = 'archiveConverted';
UPDATE source.availability_status_type SET display_value = 'Incomplete::::Lei maea' WHERE code = 'incomplete';
UPDATE source.availability_status_type SET display_value = 'Unknown::::Le maua' WHERE code = 'archiveUnknown';
UPDATE source.availability_status_type SET display_value = 'Available::::Avanoa' WHERE code = 'available';

UPDATE source.spatial_source_type SET display_value = 'Field Sketch::::Ata Faatusa Laufanua' WHERE code = 'fieldSketch';
UPDATE source.spatial_source_type SET display_value = 'GNSS (GPS) Survey::::GNSS (GPS) Fuataga.' WHERE code = 'gnssSurvey';
UPDATE source.spatial_source_type SET display_value = 'Orthophoto::::Ata o le Faafanua' WHERE code = 'orthoPhoto';
UPDATE source.spatial_source_type SET display_value = 'Relative Measurements::::Fua Fesootai' WHERE code = 'relativeMeasurement';
UPDATE source.spatial_source_type SET display_value = 'Topographical Map::::Faafanua o le Laufanua' WHERE code = 'topoMap';
UPDATE source.spatial_source_type SET display_value = 'Video::::Ata Vito' WHERE code = 'video';
UPDATE source.spatial_source_type SET display_value = 'Cadastral Survey::::Fuataga o Tuaoi' WHERE code = 'cadastralSurvey';
UPDATE source.presentation_form_type SET display_value = 'Digital Document::::Faamaumauga o faamatalaga i Komepiuta' WHERE code = 'documentDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Document::::Kopi malo/pepa o faamatalaga' WHERE code = 'documentHardcopy';
UPDATE source.presentation_form_type SET display_value = 'Digital Image::::Ata o lo''o faamaumau i komepiuta' WHERE code = 'imageDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Image::::Kopi Malo o Ata' WHERE code = 'imageHardcopy';
UPDATE source.presentation_form_type SET display_value = 'Digital Map::::Faafanua o lo''o faamaumau i komepiuta' WHERE code = 'mapDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Map::::Kopi malo/pepa o Faafanua' WHERE code = 'mapHardcopy';
UPDATE source.presentation_form_type SET display_value = 'Digital Model::::Faamaumauga o le Ituaiga i komepiuta' WHERE code = 'modelDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Model::::Kopi malo/pepa o le Ituaiga' WHERE code = 'modelHarcopy';
UPDATE source.presentation_form_type SET display_value = 'Digital Profile::::Faamaumauga o le Talatalaga i komepiuta' WHERE code = 'profileDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Profile::::kopi malo/pepa o le Talatalaga' WHERE code = 'profileHardcopy';
UPDATE source.presentation_form_type SET display_value = 'Digital Table::::Faamaumauga o Laulau o Faamatalaga i komepiuta' WHERE code = 'tableDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Table::::Kopi malo/pepa o laulau o faamatalaga' WHERE code = 'tableHardcopy';
UPDATE source.presentation_form_type SET display_value = 'Digital Video::::Faamaumauga o Ata Video i komepiuta' WHERE code = 'videoDigital';
UPDATE source.presentation_form_type SET display_value = 'Hardcopy Video::::Kopi Malo o le Ata Tifaga/Video' WHERE code = 'videoHardcopy';
UPDATE party.party_type SET display_value = 'Natural Person::::Tagata na umia muamua' WHERE code = 'naturalPerson';
UPDATE party.party_type SET display_value = 'Non-natural Person::::E le o ia na umiaina muamua' WHERE code = 'nonNaturalPerson';
UPDATE party.party_type SET display_value = 'Basic Administrative Unit::::Vaega o Pulega Amata' WHERE code = 'baunit';
UPDATE party.group_party_type SET display_value = 'Association::::Auaufaatasi' WHERE code = 'association';
UPDATE party.group_party_type SET display_value = 'Family::::Aiga' WHERE code = 'family';
UPDATE party.party_role_type SET display_value = 'Notary::::Faaailogaina' WHERE code = 'notary';
UPDATE party.party_role_type SET display_value = 'Licenced Surveyor::::Fuafanua Laiseneina' WHERE code = 'certifiedSurveyor';
UPDATE party.party_role_type SET display_value = 'Bank::::Fale Tupe' WHERE code = 'bank';
UPDATE party.party_role_type SET display_value = 'Money Provider::::Aumaia Tupe' WHERE code = 'moneyProvider';
UPDATE party.party_role_type SET display_value = 'Citizen::::Tagatanuu' WHERE code = 'citizen';
UPDATE party.party_role_type SET display_value = 'Registrar / Approving Surveyor::::Resitala / Fuafanua Pasiaina' WHERE code = 'stateAdministrator';
UPDATE party.party_role_type SET display_value = 'Land Officer::::Tagata Ofisa o Eleele' WHERE code = 'landOfficer';
UPDATE party.party_role_type SET display_value = 'Lodging Agent::::Vaega mo le Tuuina mai' WHERE code = 'lodgingAgent';
UPDATE party.party_role_type SET display_value = 'Power of Attorney::::Malosiaga o le Loia Sili' WHERE code = 'powerOfAttorney';
UPDATE party.party_role_type SET display_value = 'Transferee (to)::::Tagata e Ave I ai' WHERE code = 'transferee';
UPDATE party.party_role_type SET display_value = 'Transferor (from)::::Tagata e Aumai ai' WHERE code = 'transferor';
UPDATE party.party_role_type SET display_value = 'Applicant::::Tagata Talosaga' WHERE code = 'applicant';
UPDATE party.communication_type SET display_value = 'e-Mail::::Fetusiaiga Faakomipiuta' WHERE code = 'eMail';
UPDATE party.communication_type SET display_value = 'Fax::::Masini lafo meli' WHERE code = 'fax';
UPDATE party.communication_type SET display_value = 'Post::::Lafo' WHERE code = 'post';
UPDATE party.communication_type SET display_value = 'Phone::::Telefoni' WHERE code = 'phone';
UPDATE party.communication_type SET display_value = 'Courier::::Avefeau' WHERE code = 'courier';
UPDATE party.id_type SET display_value = 'National ID::::Pepa faamaonia Tagatanuu' WHERE code = 'nationalID';
UPDATE party.id_type SET display_value = 'National Passport::::Tusifolau Tagatanuu' WHERE code = 'nationalPassport';
UPDATE party.id_type SET display_value = 'Other Passport::::Isi Tusifolau' WHERE code = 'otherPassport';
UPDATE party.gender_type SET display_value = 'Male::::Alii' WHERE code = 'male';
UPDATE party.gender_type SET display_value = 'Female::::Tamaitai' WHERE code = 'female';
UPDATE administrative.ba_unit_type SET display_value = 'Basic Property Unit::::Vaega mo Meatotino Amata' WHERE code = 'basicPropertyUnit';
UPDATE administrative.ba_unit_type SET display_value = 'Administrative Unit::::Vaega o Pulega' WHERE code = 'administrativeUnit';
UPDATE administrative.ba_unit_type SET display_value = 'Basic Parcel::::Poloka Amata' WHERE code = 'basicParcel';

UPDATE administrative.mortgage_type SET display_value = 'Level Payment::::Totogi tutusa' WHERE code = 'levelPayment';
UPDATE administrative.mortgage_type SET display_value = 'Linear::::Laina' WHERE code = 'linear';
UPDATE administrative.mortgage_type SET display_value = 'microCredit::::Aitalafu la''ititi' WHERE code = 'microCredit';
UPDATE cadastre.area_type SET display_value = 'Calculated Area::::Tele ua Vevaeina' WHERE code = 'calculatedArea';
UPDATE cadastre.area_type SET display_value = 'Non-official Area::::Tele e lei faailoaina' WHERE code = 'nonOfficialArea';
UPDATE cadastre.area_type SET display_value = 'Official Area::::Tele ua faailoaina' WHERE code = 'officialArea';
UPDATE cadastre.area_type SET display_value = 'Surveyed Area::::Tele ua Fuaina' WHERE code = 'surveyedArea';
UPDATE cadastre.surface_relation_type SET display_value = 'On Surface::::Foligavaaia' WHERE code = 'onSurface';
UPDATE cadastre.register_type SET display_value = 'All::::Mea uma' WHERE code = 'all';
UPDATE cadastre.register_type SET display_value = 'Forest::::Vaomatua' WHERE code = 'forest';
UPDATE cadastre.register_type SET display_value = 'Mining::::Eliga' WHERE code = 'mining';
UPDATE cadastre.register_type SET display_value = 'Public Space::::Avanoa Faitele' WHERE code = 'publicSpace';
UPDATE cadastre.register_type SET display_value = 'Rural::::Nuu I Tua' WHERE code = 'rural';
UPDATE cadastre.register_type SET display_value = 'Urban::::Nuu I le Taulaga' WHERE code = 'urban';
UPDATE cadastre.structure_type SET display_value = 'Point::::Faailoga' WHERE code = 'point';
UPDATE cadastre.structure_type SET display_value = 'Polygon::::Tafatele' WHERE code = 'polygon';
UPDATE cadastre.structure_type SET display_value = 'Sketch::::Ata Faataitai' WHERE code = 'sketch';
UPDATE cadastre.structure_type SET display_value = 'Text::::Mataitusi' WHERE code = 'text';
UPDATE cadastre.structure_type SET display_value = 'Topological::::Ta''atiaga o le fanua' WHERE code = 'topological';
UPDATE cadastre.level_content_type SET display_value = 'Primary Right::::Saolotoga Muamua' WHERE code = 'primaryRight';
UPDATE cadastre.level_content_type SET display_value = 'Restriction::::Faamalosia' WHERE code = 'restriction';
UPDATE cadastre.level_content_type SET display_value = 'Geographic Locators::::Faaailoga e iloa ai' WHERE code = 'geographicLocator';
UPDATE cadastre.building_unit_type SET display_value = 'Individual::::Taitoatasi' WHERE code = 'individual';
UPDATE cadastre.building_unit_type SET display_value = 'Shared::::fefa''asoaa''i' WHERE code = 'shared';
UPDATE cadastre.utility_network_status_type SET display_value = 'In Use::::O loo Faaaoga' WHERE code = 'inUse';
UPDATE cadastre.utility_network_status_type SET display_value = 'Out of Use::::Ua leo Faaogaina' WHERE code = 'outOfUse';
UPDATE cadastre.utility_network_status_type SET display_value = 'Planned::::Fuafua' WHERE code = 'planned';
UPDATE cadastre.utility_network_type SET display_value = 'Chemicals::::Vailaau' WHERE code = 'chemical';
UPDATE cadastre.utility_network_type SET display_value = 'Electricity::::Eletise' WHERE code = 'electricity';
UPDATE cadastre.utility_network_type SET display_value = 'Gas::::Kesi' WHERE code = 'gas';
UPDATE cadastre.utility_network_type SET display_value = 'Heating::::Faavevela' WHERE code = 'heating';
UPDATE cadastre.utility_network_type SET display_value = 'Oil::::Suauu' WHERE code = 'oil';
UPDATE cadastre.utility_network_type SET display_value = 'Telecommunication::::Faafesootaiga' WHERE code = 'telecommunication';
UPDATE cadastre.utility_network_type SET display_value = 'Water::::Suavai' WHERE code = 'water';
UPDATE cadastre.dimension_type SET display_value = '0D::::OD' WHERE code = '0D';
UPDATE cadastre.dimension_type SET display_value = '1D::::1D' WHERE code = '1D';
UPDATE cadastre.dimension_type SET display_value = '2D::::2D' WHERE code = '2D';
UPDATE cadastre.dimension_type SET display_value = '3D::::3D' WHERE code = '3D';
UPDATE cadastre.cadastre_object_type SET display_value = 'Parcel::::Poloka' WHERE code = 'parcel';
UPDATE cadastre.cadastre_object_type SET display_value = 'Building Unit::::Iunite o le Fale' WHERE code = 'buildingUnit';
UPDATE cadastre.cadastre_object_type SET display_value = 'Utility Network::::feso''ota''iga i auala mana''omia' WHERE code = 'utilityNetwork';
UPDATE application.request_category_type SET display_value = 'Registration Services::::Auaunaga o Resitaraina' WHERE code = 'registrationServices';
UPDATE application.request_category_type SET display_value = 'Information Services::::Auaunaga o Faamatalaga' WHERE code = 'informationServices';
UPDATE application.application_action_type SET display_value = 'Lodgement Notice Prepared::::Ua saunia faamatalaga mo le Tuuina mai' WHERE code = 'lodge';
UPDATE application.application_action_type SET display_value = 'Add document::::Faaopopo Faamatalaga' WHERE code = 'addDocument';
UPDATE application.application_action_type SET display_value = 'Withdraw application::::Toe faafoi le Talosaga' WHERE code = 'withdraw';
UPDATE application.application_action_type SET display_value = 'Cancel application::::Soloia Talosaga' WHERE code = 'cancel';
UPDATE application.application_action_type SET display_value = 'Requisition::::Tusifaasao' WHERE code = 'requisition';
UPDATE application.application_action_type SET display_value = 'Quality Check Fails::::Ua le pasia siaki mo le Faamautuina' WHERE code = 'validateFailed';
UPDATE application.application_action_type SET display_value = 'Quality Check Passes::::Ua pasia siaki mo le Faamautuina' WHERE code = 'validatePassed';
UPDATE application.application_action_type SET display_value = 'Approve::::Pasia' WHERE code = 'approve';
UPDATE application.application_action_type SET display_value = 'Archive::::Teu maluina ' WHERE code = 'archive';
UPDATE application.application_action_type SET display_value = 'Despatch::::Fa''afo''i ese ina atu' WHERE code = 'despatch';
UPDATE application.application_action_type SET display_value = 'Lapse::::Ua lape/Ua faaleaogaina' WHERE code = 'lapse';
UPDATE application.application_action_type SET display_value = 'Assign::::Tofia ' WHERE code = 'assign';
UPDATE application.application_action_type SET display_value = 'Unassign::::Le Tofia' WHERE code = 'unAssign';
UPDATE application.application_action_type SET display_value = 'Resubmit::::Toe Aumaia' WHERE code = 'resubmit';
UPDATE application.application_action_type SET display_value = 'Validate::::Aso Aoga' WHERE code = 'validate';
UPDATE application.service_status_type SET display_value = 'Lodged::::Ua Faaulu' WHERE code = 'lodged';
UPDATE application.service_status_type SET display_value = 'Completed::::Ua Maea' WHERE code = 'completed';
UPDATE application.service_status_type SET display_value = 'Pending::::Faamalumalu' WHERE code = 'pending';
UPDATE application.service_status_type SET display_value = 'Cancelled::::Ua Soloia' WHERE code = 'cancelled';
UPDATE application.service_action_type SET display_value = 'Lodge::::Faaulu' WHERE code = 'lodge';
UPDATE application.service_action_type SET display_value = 'Start::::Amata' WHERE code = 'start';
UPDATE application.service_action_type SET display_value = 'Cancel::::Soloia' WHERE code = 'cancel';
UPDATE application.service_action_type SET display_value = 'Complete::::Maea' WHERE code = 'complete';
UPDATE application.service_action_type SET display_value = 'Revert::::Se''ei i ai' WHERE code = 'revert';
UPDATE application.application_status_type SET display_value = 'Lodged::::Ua Faaulu' WHERE code = 'lodged';
UPDATE application.application_status_type SET display_value = 'Approved::::Ua Pasia' WHERE code = 'approved';
UPDATE application.application_status_type SET display_value = 'Anulled::::Ua le fa''aaogaina' WHERE code = 'anulled';
UPDATE application.application_status_type SET display_value = 'Completed::::Ua Maea' WHERE code = 'completed';
UPDATE application.application_status_type SET display_value = 'Requisitioned::::Ua Tusifaasao' WHERE code = 'requisitioned';
UPDATE application.type_action SET display_value = 'New::::Fou ' WHERE code = 'new';
UPDATE application.type_action SET display_value = 'Vary::::Fetuunai' WHERE code = 'vary';
UPDATE application.type_action SET display_value = 'Cancel::::Soloia' WHERE code = 'cancel';
UPDATE system.config_map_layer_type SET display_value = 'WMS server with layers::::VMS Teuina ma Loia' WHERE code = 'wms';
UPDATE system.config_map_layer_type SET display_value = 'Shapefile::::Faila o Meafaitino' WHERE code = 'shape';
UPDATE system.config_map_layer_type SET display_value = 'Pojo layer::::Itulau o le Pojo' WHERE code = 'pojo';
UPDATE system.br_severity_type SET display_value = 'Critical::::Tulaga Matautia' WHERE code = 'critical';
UPDATE system.br_severity_type SET display_value = 'Medium::::Ogatotonu' WHERE code = 'medium';
UPDATE system.br_severity_type SET display_value = 'Warning::::Lapataiga' WHERE code = 'warning';
UPDATE system.br_validation_target_type SET display_value = 'Application::::Talosaga' WHERE code = 'application';
UPDATE system.br_validation_target_type SET display_value = 'Service::::Auaunaga' WHERE code = 'service';
UPDATE system.br_validation_target_type SET display_value = 'Right or Restriction::::Aia Faatonutonu' WHERE code = 'rrr';
UPDATE system.br_validation_target_type SET display_value = 'Administrative Unit::::Iunite Pulega' WHERE code = 'ba_unit';
UPDATE system.br_validation_target_type SET display_value = 'Source::::Tupuaga' WHERE code = 'source';
UPDATE system.br_validation_target_type SET display_value = 'Cadastre Object::::Faamaumauga i totonu o le faafanua' WHERE code = 'cadastre_object';
UPDATE transaction.reg_status_type SET display_value = 'Current::::Taimi nei' WHERE code = 'current';
UPDATE transaction.reg_status_type SET display_value = 'Pending::::Faamalumalu' WHERE code = 'pending';
UPDATE transaction.reg_status_type SET display_value = 'Historic/Cancelled::::Faasolopito' WHERE code = 'historic';
UPDATE transaction.reg_status_type SET display_value = 'Previous::::Tuanai' WHERE code = 'previous';
UPDATE transaction.transaction_status_type SET display_value = 'Approved::::Ua Pasia' WHERE code = 'approved';
UPDATE transaction.transaction_status_type SET display_value = 'Cancelled::::Ua Soloia' WHERE code = 'cancelled';
UPDATE transaction.transaction_status_type SET display_value = 'Pending::::Faamalumalu' WHERE code = 'pending';
UPDATE transaction.transaction_status_type SET display_value = 'Completed::::Ua Maea' WHERE code = 'completed';

-- Reference Code Customizations for Samoa
UPDATE party.party_role_type SET status = 'c', display_value = 'Surveyor::::Fuafanua' WHERE code = 'surveyor';
INSERT INTO party.party_role_type (code, status, display_value)
SELECT 'lawyer','c','Lawyer::::SAMOAN'
WHERE NOT EXISTS (SELECT code FROM party.party_role_type WHERE code = 'lawyer');

  
-- Reconfigure the Request Categories by adding Cadastral Services and Non Registration Services. Used by Application Numbering Business rule. 
INSERT INTO application.request_category_type (code, display_value, description, status)
SELECT 'cadastralServices', 'Cadastral Services', NULL, 'c' WHERE 'cadastralServices' NOT IN 
(SELECT code FROM application.request_category_type); 
INSERT INTO application.request_category_type (code, display_value, description, status)
SELECT 'nonRegServices', 'Non Registration Services', NULL, 'c' WHERE 'nonRegServices' NOT IN 
(SELECT code FROM application.request_category_type);

-- Reset the Request Types (i.e. Service types) and Right Types available for SOLA Samoa

-- Need to create some temp codes for teh br_validation table so that its easier to clean up 
-- the existing request types. 
INSERT INTO application.request_type(code, request_category_code, display_value)
    SELECT  DISTINCT '1_' || LEFT(target_request_type_code,18), 
			'nonRegServices',
			target_request_type_code
	FROM	system.br_validation WHERE target_request_type_code IS NOT NULL; 
 		
UPDATE 	system.br_validation SET target_request_type_code = '1_' || LEFT(target_request_type_code,18)
WHERE target_request_type_code IS NOT NULL; 
 
DELETE FROM application.request_type_requires_source_type; 
DELETE FROM application.request_type WHERE code NOT LIKE '1_%'; 
DELETE FROM administrative.rrr_type; 


-- Update existing RRR Group types and add an additional group type
UPDATE administrative.rrr_group_type SET display_value = 'Rights::::Aiatatau' WHERE code = 'rights';
UPDATE administrative.rrr_group_type SET display_value = 'Restrictions::::Aiaiga' WHERE code = 'restrictions';
UPDATE administrative.rrr_group_type SET status = 'x' WHERE code = 'responsibilities';
INSERT INTO  administrative.rrr_group_type (code, display_value, status, description)
VALUES ('system', 'System', 'x', 'Groups RRRs that exist solely to support SOLA system functionality'); 

-- Add the revised list of RRR Types for Samoa
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('primary', 'system', 'Primary', FALSE, FALSE, FALSE, 'x', 'System RRR type used by SOLA to represent the group of primary rights.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('easement', 'system', 'Easement', FALSE, FALSE, FALSE, 'x', 'System RRR type used by SOLA to represent the group of rights associated with easements (i.e. servitude and dominant.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('customaryType', 'rights', 'Customary::::SAMOAN', TRUE, TRUE, TRUE, 'c', 'Primary right indicating the property is owned under customary title.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('leaseHold', 'rights', 'Leasehold::::SAMOAN', TRUE, TRUE, TRUE, 'c', 'Primary right indicating the property is subject to a long term leasehold agreement.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('ownership', 'rights', 'Freehold::::SAMOAN', TRUE, TRUE, TRUE, 'c', 'Primary right indicating the property is owned under a freehold (Fee Simple Estate) title.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('stateOwnership', 'rights', 'Government::::SAMOAN', TRUE, TRUE, TRUE, 'c', 'Primary right indicating the property is state land owned by the Government of Samoa.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('mortgage', 'restrictions', 'Mortgage::::Nono le Fanua', FALSE, FALSE, FALSE, 'c', 'Indicates the property is under mortgage.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('lease', 'rights', 'Lease::::Lisi', FALSE, FALSE, TRUE, 'c', 'Indicates the property is subject to a short or medium term lease agreement.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('caveat', 'restrictions', 'Caveat::::Tusi Taofi', FALSE, FALSE, TRUE, 'c', 'Indicates the property is subject to restrictions imposed by a caveat.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('order', 'restrictions', 'Court Order::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'Indicates the property is subject to restrictions imposed by a court order.');	
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('proclamation', 'restrictions', 'Proclamation::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'Indicates the property is subject to restrictions imposed by a proclamation that has completed the necessary statutory process.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('lifeEstate', 'restrictions', 'Life Estate::::SAMOAN', FALSE, FALSE, TRUE, 'c', 'Indicates the property is subject to a life estate.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('servitude', 'restrictions', 'Servient Estate::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'Indicates the property is subject to an easement as the servient estate.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('dominant', 'rights', 'Dominant Estate::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'Indicates the property has been granted rights to an easement over another property as the dominant estate.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('transmission', 'rights', 'Transmission::::SAMOAN', FALSE, FALSE, TRUE, 'c', 'Transmission.');
INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('miscellaneous', 'rights', 'Miscellaneous::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'Miscellaneous');
	
	
-- Add Registration Services
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('lifeEstate','registrationServices','Record Life Estate::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Life Estate for <name1> with Remainder Estate in <name2, name3>','lifeEstate','new','Life Estate');	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeLifeEstate','registrationServices','Cancel Life Estate::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Life Estate <reference> cancelled','lifeEstate','cancel','Cancel Life Estate');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('newFreehold','registrationServices','Create New Title::::SAMOAN','c',5,0.00,0.00,0.00,1,
	'New <estate type> title',NULL,NULL,'Create New Title');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('varyTitle','registrationServices','Change Estate Type::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Title changed from <original estate type> to <new estate type>','primary',NULL,'Change Estate Type');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('regnOnTitle','registrationServices','Change Right or Restriction::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'<memorial>',NULL,'vary','Miscellaneous');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('registerLease','registrationServices','Record Lease::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Lease of <nn> years to <name> until <date>','lease','new','Lease or Sub Lease');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('newOwnership','registrationServices','Transfer::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Transfer to <name>','primary','vary','Transfer');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('mortgage','registrationServices','Record Mortgage::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Mortgage to <lender>','mortgage','new','Mortgage');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('easement','registrationServices','Record Easement::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Servient <easement type> over <parcel1> in favour of <parcel2> / Dominant <easement type>
	in favour of <parcel1> over <parcel2>','easement','new','Easement');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeEasement','registrationServices','Cancel Easement::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Easement <reference> cancelled','easement','cancel','Cancel Easement');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('caveat','registrationServices','Record Caveat::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Caveat in the name of <name>','caveat','new','Caveat');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeCaveat','registrationServices','Cancel Caveat::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Caveat <reference> cancelled','caveat','cancel','Withdrawal of Caveat');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('varyLease','registrationServices','Change Lease or Sublease::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Variation of lease <reference> for <nn> years to <name> until <date>','lease','vary','Transfer or Renew Lease');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeRight','registrationServices','Cancel Lease or Sublease::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Lease <reference> cancelled','lease','cancel','Terminate Lease');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('newDigitalTitle','registrationServices','Convert to Title::::SAMOAN','c',5,0.00,0.00,0.00,1,
	'Title converted from paper',NULL,NULL,'Conversion');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeRestriction','registrationServices','Cancel Mortgage::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Mortgage <reference> cancelled','mortgage','cancel','Discharge of Mortgage');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('variationMortgage','registrationServices','Change Mortgage::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Variation of mortgage <reference>','mortgage','vary','Variation of Mortgage');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('proclamation','registrationServices','Record Proclamation::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Proclamation <proclamation>','proclamation','new','Proclamation');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('order','registrationServices','Record Court Order::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Court Order <order>','order','new','Order');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('subLease','registrationServices','Record Sub Lease::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Sub Lease of nn years to <name> until <date>','lease','new','Sub Lease');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('registrarCorrection','registrationServices','Correct Registry::::SAMOAN','c',5,0.00,0.00,0.00,1,
	'Correction by Registrar to <reference>',NULL,NULL,'Registry Dealing');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('registrarCancel','registrationServices','Correct Registry (Cancel Right)::::SAMOAN','c',5,0.00,0.00,0.00,1,
	'Correction by Registrar to <reference>',NULL,'cancel','Registry Dealing');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeOrder','registrationServices','Cancel Court Order::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Court Order <reference> cancelled','order','cancel','Revocation of Order');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeProclamation','registrationServices','Cancel Proclamation::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Proclamation <reference> cancelled','proclamation','cancel','Revocation of Proclamation');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cancelProperty','registrationServices','Cancel Title::::SAMOAN','c',5,0.00,0.00,0.00,1,
	NULL,NULL,'cancel','Cancel Title');	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('varyCaveat','registrationServices','Change Caveat::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Variation of caveat <reference>','caveat','vary','Variation of Caveat');
	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('transmission','registrationServices','Record Transmission::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Transmission to <name>','transmission','new','Transmission');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('removeTransmission','registrationServices','Cancel Transmission::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Transmission <reference> canceled','transmission','cancel','Cancel Transmission');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('miscellaneous','registrationServices','Record Miscellaneous::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'<memorial>','miscellaneous','new','Miscellaneous');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cancelMisc','registrationServices','Cancel Miscellaneous::::SAMOAN','c',5,100.00,0.00,0.00,1,
	'Miscellaneous <reference> canceled','miscellaneous','cancel','Cancel Miscellaneous');
	
-- Special zero fee services
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cnclMortgagePOS','registrationServices','Cancel Mortgage under Power of Sale::::SAMOAN','c',5,0.00,0.00,0.00,1,
	'Mortgage <reference> cancelled','mortgage','cancel','Discharge of Mortgage under Power of Sale');
	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cnclTransmissonAdmin','registrationServices','Cancel Transmission under Transfer by Administrator::::SAMOAN','c',5,0.00,0.00,0.00,1,
	'Transmission <reference> canceled','transmission','cancel','Cancel Transmission');
	
-- Survey Services 
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cadastreChange','cadastralServices','Record Plan::::SAMOAN','c',30,23.00,0.00,11.50,1,
	NULL,NULL,NULL,'Plan');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('redefineCadastre','cadastralServices','Change Map::::SAMOAN','c',30,0.00,0.00,0.00,0,
	NULL,NULL,NULL,NULL);
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('planNoCoords','cadastralServices','Record Plan with No Coordinates::::SAMOAN','c',30,23.00,0.00,11.50,0,
	NULL,NULL,NULL,'Record Plan with no coordinates');

	
-- Other Services	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('regnStandardDocument','nonRegServices','Record Standard Memorandum::::SAMOAN','c',3,100.00,0.00,0.00,0,
	NULL,NULL,NULL,'Standard Memoranda');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('regnPowerOfAttorney','nonRegServices','Record Power of Attorney::::SAMOAN','c',3,100.00,0.00,0.00,0,
	NULL,NULL,NULL,'Power of Attorney');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cnclPowerOfAttorney','nonRegServices','Cancel Power of Attorney::::SAMOAN','c',3,100.00,0.00,0.00,0,
	NULL,NULL,'cancel','Revocation of Power of Attorney');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cnclStandardDocument','nonRegServices','Cancel Standard Memorandum::::SAMOAN','c',3,100.00,0.00,0.00,0,
	NULL,NULL,'cancel','Revocation of Standard Memoranda');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('certifiedCopy','informationServices','Produce/Print a Certified Copy::::SAMOAN','c',2,100.00,0.00,0.00,0,
	NULL,NULL,NULL,'Application for a Certified True Copy');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cadastrePrint','informationServices','Map Print::::SAMOAN','x',1,0.00,0.00,0.00,0,
	NULL,NULL,NULL,'');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cadastreExport','informationServices','Map Export::::SAMOAN','x',1,0.00,0.00,0.00,0,
	NULL,NULL,NULL,'');
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
    VALUES ('cadastreBulk','informationServices','Bulk Map Export::::SAMOAN','x',1,0.00,0.00,0.00,0,
	NULL,NULL,NULL,'');

	
-- Recreate the constraints that were dropped above and correct any known code changes in the 
-- br_validation table.  
UPDATE 	system.br_validation SET target_request_type_code = 'variationMortgage' 
WHERE  target_request_type_code = '1_varyMortgage'; 

-- Reset the br_validation references to the request_type table
UPDATE 	system.br_validation 
SET target_request_type_code = REQ.display_value
FROM application.request_type REQ
WHERE target_request_type_code IS NOT NULL
AND  target_request_type_code LIKE '1_%'
AND  REQ.code = target_request_type_code;  

-- Clean up the temp codes. 
DELETE FROM application.request_type WHERE code LIKE '1_%'; 
	    
	  
-- Customize the document types used in Samoa	  
DELETE FROM source.administrative_source_type; 
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('agreement','Agreement::::Autasiga','c','FALSE');  
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('application','Request Form::::SAMOAN','c','FALSE'); 
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('caveat','Caveat::::SAMOAN','c','FALSE'); 
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('circuitPlan','Circuit Plan::::SAMOAN','c','FALSE'); 
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('coastalPlan','Coastal Plan::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('courtOrder','Court Order::::Faatonuga a le Faamasinoga','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('deed','Deed::::Pepa o le Fanua','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('landClaimPlan','Land Claim (LC) Plan::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('landClaims','Land Claim::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('lease','Lease::::Lisi','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('memorandum','Memorandum::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('other','Miscellaneous::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('mortgage','Mortgage::::Mokesi','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('cadastralSurvey','Plan::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('powerOfAttorney','Power of Attorney::::Paoa o le Loia Sili','c','TRUE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('proclamation','Proclamation::::Faasalalauga Faaletulafono','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('note','Office Note::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('idVerification','Proof of Identity::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('recordMaps','Record Map::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('registered','Migrated::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('requisitionNotice','Requisition Notice::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('schemePlan','Scheme Plan::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('standardForm','Standard Form::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('standardDocument','Standard Memorandum::::SAMOAN','c','TRUE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('surveyDataFile','Survey Data File::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('newFormFolio','New Form Folio::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('titlePlan','Title Plan::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('waiver','Waiver::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('will','Probated Will::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('qaChecklist','QA Checklist::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('consent','Consent Form::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('traverse','Traverse Sheet::::SAMOAN','c','FALSE');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
VALUES ('flurPlan','Flur Plan::::SAMOAN','c','FALSE');



-- Customize the documents to service associations
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('mortgage', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('variationMortgage', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('transmission', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('newOwnership', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('registerLease', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('subLease', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('registrarCorrection', 'note');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('registrarCancel', 'note');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('newFreehold', 'cadastralSurvey');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('caveat', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('removeCaveat', 'application');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('regnOnTitle', 'note');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('cadastreChange', 'cadastralSurvey');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('redefineCadastre', 'note');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('regnPowerOfAttorney', 'powerOfAttorney');
INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('regnStandardDocument', 'standardDocument');

INSERT INTO application.request_type_requires_source_type (request_type_code, source_type_code)
VALUES('planNoCoords', 'cadastralSurvey');
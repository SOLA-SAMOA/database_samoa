
-- Security Role Configurations

-- Samoa specific Roles
INSERT INTO system.approle (code, display_value, status, description)
SELECT 'ApplnNr', 'Set Application Number', 'c', 'Set application number to match number allocated by LRS' 
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'ApplnNr');

INSERT INTO system.approle (code, display_value, status, description)
SELECT 'FeePayment', 'Record Fee Payment', 'c', 'Allows the user to set the Fee Paid flag on the Application Details screen' 
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'FeePayment');

INSERT INTO system.approle (code, display_value, status, description)
SELECT 'ApplnCompleteDate', 'Edit Application Completion Date', 'c', 'Allows the user to update the completion date for the application on the Application Details screen' 
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'ApplnCompleteDate');

INSERT INTO system.approle (code, display_value, status, description)
SELECT 'ManageUserPassword', 'Manager User Details and Password', 'c', 'Allows the user to update their user details and/or password' 
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'ManageUserPassword');

INSERT INTO system.approle (code, display_value, status, description)
SELECT 'ViewSource', 'View Source Details', 'c', 'Allows the user to view source and document details.' 
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'ViewSource');

INSERT INTO system.approle (code, display_value, status, description)
SELECT 'PartySearch', 'Search Party', 'c', 'Allows the user access to the Party Search so they can edit existing parties (i.e. Lodging Agent and Bank details).' 
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'PartySearch');

INSERT INTO system.approle (code, display_value, status, description)
SELECT 'ExportMap', 'Export Map','c', 'Export a selected map feature to KML for display in Google Earth'
WHERE NOT EXISTS (SELECT code FROM system.approle WHERE code = 'ExportMap');


-- Add new roles to the super group id
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnNr', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'ApplnNr' AND appgroup_id = 'super-group-id'));  

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'FeePayment', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'FeePayment' AND appgroup_id = 'super-group-id'));

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnCompleteDate', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'ApplnCompleteDate' AND appgroup_id = 'super-group-id'));

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'ManageUserPassword' AND appgroup_id = 'super-group-id'));

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'ViewSource' AND appgroup_id = 'super-group-id'));

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySearch', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'PartySearch' AND appgroup_id = 'super-group-id'));

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ExportMap', 'super-group-id' 
WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup WHERE approle_code = 'ExportMap' AND appgroup_id = 'super-group-id'));

-- Configure roles for services
INSERT INTO system.approle (code, display_value, status)
SELECT req.code, req.display_value, 'c'
FROM   application.request_type req
WHERE  NOT EXISTS (SELECT r.code FROM system.approle r WHERE req.code = r.code); 

UPDATE  system.approle SET display_value = req.display_value
FROM 	application.request_type req
WHERE   system.approle.code = req.code; 

-- This delete will cascade delete from the system.approle_appgroup table. 
DELETE FROM system.approle WHERE code IN ('buildingRestriction', 'documentCopy', 'historicOrder', 'limtedRoadAccess', 
'newApartment', 'serviceEnquiry', 'servitude', 'surveyPlanCopy', 'titleSearch', 'varyMortgage', 'varyRight'); 

-- Add any missing roles to the super-group-id
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) 
(SELECT r.code, 'super-group-id' 
 FROM   system.approle r
 WHERE NOT EXISTS (SELECT approle_code FROM system.approle_appgroup rg
                 WHERE  rg.approle_code = r.code
				 AND    rg.appgroup_id = 'super-group-id')); 

-- Administrator Role
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '10', 'Administrator', 'MNRE IT Services Unit. Users assigned this role have the ' ||
     'ability to configure and administer the SOLA application. E.g. Add users, configure roles, ' ||
	 'update system codes, edit business rules etc.'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Administrator' )); 
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageBR', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageRefdata', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageSettings', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageSecurity', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnView', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitSearch', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSearch', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewMap', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ReportGenerate', id FROM system.appgroup WHERE "name" = 'Administrator');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Administrator'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySearch', id FROM system.appgroup WHERE "name" = 'Administrator');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySave', id FROM system.appgroup WHERE "name" = 'Administrator');

-- View Property Information Role
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '20', 'Search and View Property Information', 'Allows users to search and view property information. ' ||
                                'All Land Registry and QA staff have this role by default. Other staff (Technical, Accounts, etc) ' ||
                                'can be assigned this role as required.'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Property Information' )); 
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Property Information'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitSearch', id FROM system.appgroup WHERE "name" = 'Search and View Property Information'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Search and View Property Information');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Search and View Property Information');

-- Search and View Only Role   
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '30', 'Search and View Only', 'Allows users to search and view application and document details ' ||
                                'as well as the Map. Printing documents, map or application details is not permitted'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only' )); 
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Search and View Only'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnView', id FROM system.appgroup WHERE "name" = 'Search and View Only');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSearch', id FROM system.appgroup WHERE "name" = 'Search and View Only');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewMap', id FROM system.appgroup WHERE "name" = 'Search and View Only');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Search and View Only');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Search and View Only');

-- Technical Division   
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '80', 'Technical Division', 'The Technical Division can search and view application and document details as well as ' ||
                                ' view, print and export features from the Map'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Technical Division' )); 
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Technical Division'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnView', id FROM system.appgroup WHERE "name" = 'Technical Division');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSearch', id FROM system.appgroup WHERE "name" = 'Technical Division');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewMap', id FROM system.appgroup WHERE "name" = 'Technical Division');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Technical Division');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Technical Division');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PrintMap', id FROM system.appgroup WHERE "name" = 'Technical Division');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ExportMap', id FROM system.appgroup WHERE "name" = 'Technical Division');

-- Team Leader Role   
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '40', 'Team Leader', 'Team Leaders (and ACEOs) can approve applications, re-assign applications to other staff and generate lodgement reports. ' ||
                              'This role should be combined with the appropriate staff role (e.g. Land Registry or Quality Assurance ' ||
							  'so that the team leader has access suitable for thier section.'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader' )); 
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Team Leader'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ReportGenerate', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnAssignOthers', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnUnassignOthers', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'FeePayment', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnCompleteDate', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnNr', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySearch', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnApprove', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnReject', id FROM system.appgroup WHERE "name" = 'Team Leader');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnWithdraw', id FROM system.appgroup WHERE "name" = 'Team Leader');


-- Accounts Role   
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '50', 'Accounts', 'The Accounts staff of the Accounting Division have access to set the fee payment details for lodged ' ||
                                          'applications. '
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Accounts' )); 
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Accounts'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnEdit', id FROM system.appgroup WHERE "name" = 'Accounts');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnView', id FROM system.appgroup WHERE "name" = 'Accounts');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnValidate', id FROM system.appgroup WHERE "name" = 'Accounts');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewUnassign', id FROM system.appgroup WHERE "name" = 'Accounts');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSave', id FROM system.appgroup WHERE "name" = 'Accounts'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Accounts');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Accounts'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'FeePayment', id FROM system.appgroup WHERE "name" = 'Accounts');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySave', id FROM system.appgroup WHERE "name" = 'Accounts');

 
-- Land Registry Staff Role
INSERT INTO system.appgroup(id, "name", description)
  (SELECT '60', 'Land Registry', 'The Land Registry staff of the Land Management Division. ' ||
  'Users assigned this role can lodge and edit land registry applications as well as generate folio certificates.'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry' ));  
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnEdit', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'TransactionCommit', id FROM system.appgroup WHERE "name" = 'Land Registry');   
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnArchive', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ArchiveApps', id FROM system.appgroup WHERE "name" = 'Land Registry');    
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnAssignSelf', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'CancelService', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'CompleteService', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnDispatch', id FROM system.appgroup WHERE "name" = 'Land Registry');    
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnStatus', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnCreate', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PrintMap', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourcePrint', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnRequisition', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnResubmit', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnView', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSearch', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnValidate', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewAssign', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewMap', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewOwn', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewUnassign', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'StartService', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySave', id FROM system.appgroup WHERE "name" = 'Land Registry');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnUnassignSelf', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitCertificate', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitNotatSave', id FROM system.appgroup WHERE "name" = 'Land Registry');   
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitParcelSave', id FROM system.appgroup WHERE "name" = 'Land Registry');   
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitSave', id FROM system.appgroup WHERE "name" = 'Land Registry');   
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitSearch', id FROM system.appgroup WHERE "name" = 'Land Registry');   
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BauunitrrrSave', id FROM system.appgroup WHERE "name" = 'Land Registry');   
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'RevertService', id FROM system.appgroup WHERE "name" = 'Land Registry');    
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSave', id FROM system.appgroup WHERE "name" = 'Land Registry');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ParcelSave', id FROM system.appgroup WHERE "name" = 'Land Registry'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Land Registry'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Land Registry'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnApprove', id FROM system.appgroup WHERE "name" = 'Land Registry');

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) 
(SELECT r.code, g.id FROM system.appgroup g, application.request_type r 
 WHERE g."name" = 'Land Registry'
 AND   r.request_category_code IN ('registrationServices', 'nonRegServices', 'informationServices'));
 
-- Quality Assurance Staff
 INSERT INTO system.appgroup(id, "name", description)
  (SELECT '70', 'Quality Assurance', 'The Quality Assurance Staff of the Technical Division. ' ||
  'Users assigned this role can lodge and edit applications to process survey plans as well as view ' ||
  'property information.  They cannot generate folio certificates.'
   WHERE NOT EXISTS (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
   
DELETE FROM system.approle_appgroup WHERE appgroup_id = (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnEdit', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnAssignSelf', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ParcelSave', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PartySave', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSave', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnDispatch', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnStatus', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'PrintMap', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourcePrint', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnView', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'BaunitSearch', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'SourceSearch', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnValidate', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewAssign', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewMap', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewOwn', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'DashbrdViewUnassign', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnUnassignSelf', id FROM system.appgroup WHERE "name" = 'Quality Assurance'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnNr', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnCreate', id FROM system.appgroup WHERE "name" = 'Quality Assurance'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnArchive', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnRequisition', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ApplnResubmit', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ArchiveApps', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'RevertService', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'StartService', id FROM system.appgroup WHERE "name" = 'Quality Assurance'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'CancelService', id FROM system.appgroup WHERE "name" = 'Quality Assurance');  
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'TransactionCommit', id FROM system.appgroup WHERE "name" = 'Quality Assurance'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ManageUserPassword', id FROM system.appgroup WHERE "name" = 'Quality Assurance'); 
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ViewSource', id FROM system.appgroup WHERE "name" = 'Quality Assurance');    
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'CompleteService', id FROM system.appgroup WHERE "name" = 'Quality Assurance');
INSERT INTO system.approle_appgroup (approle_code, appgroup_id) (SELECT 'ExportMap', id FROM system.appgroup WHERE "name" = 'Quality Assurance');   

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) 
(SELECT r.code, g.id FROM system.appgroup g, application.request_type r 
 WHERE g."name" = 'Quality Assurance'
 AND   r.request_category_code IN ('cadastralServices')); 
 
 
-- Setup default test users for the different roles  
INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'admin', 'MNRE', 'Admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'admin'));
DELETE FROM system.appuser_appgroup WHERE appuser_id = (SELECT id FROM system.appuser WHERE username = 'admin'); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'admin'), (SELECT id FROM system.appgroup WHERE "name" = 'Administrator')); 


INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'landreguser', 'Land Registry', 'User', '3a1fbe3718bec66761c29cbfd640b6b245fd9a728a6115d7ac0e342a39224eef', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'landreguser'));
DELETE FROM system.appuser_appgroup WHERE appuser_id = (SELECT id FROM system.appuser WHERE username = 'landreguser'); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'landreguser'), (SELECT id FROM system.appgroup WHERE "name" = 'Land Registry')); 


INSERT INTO system.appuser(id, username, first_name, last_name, passwd, active, change_user)
  (SELECT uuid_generate_v1(), 'qauser', 'Quality Assurance', 'User', 'eadf21066c938cd862cf4bb59f1e36b9a75334b4a8445bb1053e0661446ebcd9', TRUE, 'test'
   WHERE NOT EXISTS (SELECT id FROM system.appuser WHERE username = 'qauser'));
DELETE FROM system.appuser_appgroup WHERE appuser_id = (SELECT id FROM system.appuser WHERE username = 'qauser'); 
INSERT INTO system.appuser_appgroup (appuser_id, appgroup_id)
VALUES ((SELECT id FROM system.appuser WHERE username = 'qauser'), (SELECT id FROM system.appgroup WHERE "name" = 'Quality Assurance'));
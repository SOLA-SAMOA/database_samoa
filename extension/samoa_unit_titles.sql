-- See samoa_table_changes for the table changes to support unit titles. 

-- RRRR Types
UPDATE administrative.rrr_group_type 
SET status = 'c',
	display_value = 'Responsibilities::::SAMOAN'
WHERE code = 'responsibilities';  

INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
SELECT 'unitEntitlement', 'rights', 'Unit Entitlement::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'Indicates the unit entitlement the unit has in relation to the unit development.'
WHERE NOT EXISTS (SELECT code FROM administrative.rrr_type WHERE code = 'unitEntitlement');

INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
SELECT 'bodyCorpRules', 'responsibilities', 'Body Corporate Rules::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'The body corporate rules for a unit development.'
WHERE NOT EXISTS (SELECT code FROM administrative.rrr_type WHERE code = 'bodyCorpRules');

INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
SELECT 'addressForService', 'responsibilities', 'Address for Service::::SAMOAN', FALSE, FALSE, FALSE, 'c', 'The body corporate address for service.'
WHERE NOT EXISTS (SELECT code FROM administrative.rrr_type WHERE code = 'addressForService');

INSERT INTO administrative.rrr_type(code, rrr_group_type_code, display_value, is_primary, share_check, party_required, status, description)
    VALUES ('commonProperty', 'system', 'Common Property', FALSE, FALSE, FALSE, 'x', 'System RRR type used by SOLA to represent the unit development body corporate responsibilities');

	
-- Document Types
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
SELECT 'unitPlan','Unit Plan::::SAMOAN','c','FALSE'
WHERE NOT EXISTS (SELECT code FROM source.administrative_source_type WHERE code = 'unitPlan');
INSERT INTO source.administrative_source_type (code,display_value,status,is_for_registration)
SELECT 'bodyCorpRules','Body Corporate Rules::::SAMOAN','c','FALSE'
WHERE NOT EXISTS (SELECT code FROM source.administrative_source_type WHERE code = 'bodyCorpRules');


-- Services
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
SELECT 'unitPlan','cadastralServices','Record Unit Plan::::SAMOAN','c',30,23.00,0.00,11.50,1,NULL,NULL,NULL,'Unit Plan'
WHERE NOT EXISTS (SELECT code FROM application.request_type WHERE code = 'unitPlan');
	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
SELECT 'newUnitTitle','registrationServices','Create Unit Titles::::SAMOAN','c',5,0.00,0.00,0.00,1, 'New <estate type> unit title',NULL,NULL,'Create Unit Titles'
WHERE NOT EXISTS (SELECT code FROM application.request_type WHERE code = 'newUnitTitle');

INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
SELECT 'varyCommonProperty','registrationServices','Change Common Property::::SAMOAN','c',5,100.00,0.00,0.00,1,NULL,NULL,NULL,'Vary Common Property'
WHERE NOT EXISTS (SELECT code FROM application.request_type WHERE code = 'varyCommonProperty');
	
INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
SELECT 'cancelUnitPlan','registrationServices','Cancel Unit Plan::::SAMOAN','c',5,100.00,0.00,0.00,1, NULL,NULL,NULL,'Unit Plan Cancellation'
WHERE NOT EXISTS (SELECT code FROM application.request_type WHERE code = 'cancelUnitPlan');

INSERT INTO application.request_type(code, request_category_code, display_value, 
            status, nr_days_to_complete, base_fee, area_base_fee, value_base_fee, 
            nr_properties_required, notation_template, rrr_type_code, type_action_code, 
            description)
SELECT 'changeBodyCorp','registrationServices','Change Body Corporate::::SAMOAN','c',5,100.00,0.00,0.00,1, 'Change Body Corporate Rules / Change Address for Service to <address>','commonProperty','vary','Variation to Body Corporate'
WHERE NOT EXISTS (SELECT code FROM application.request_type WHERE code = 'changeBodyCorp');


-- Add User Rights for the new Services
-- Configure roles for services
INSERT INTO system.approle (code, display_value, status)
SELECT req.code, req.display_value, 'c'
FROM   application.request_type req
WHERE  NOT EXISTS (SELECT r.code FROM system.approle r WHERE req.code = r.code)
AND    req.code IN ('unitPlan', 'newUnitTitle', 'varyCommonProperty', 'cancelUnitPlan', 'changeBodyCorp'); 

INSERT INTO system.approle (code, display_value, status)
SELECT 'StrataUnitCreate', 'Create Strata Property', 'c'
WHERE  NOT EXISTS (SELECT code FROM system.approle WHERE code = 'StrataUnitCreate'); 

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) 
(SELECT r.code, g.id FROM system.appgroup g, system.approle  r 
 WHERE g."name" = 'Land Registry'
 AND   r.code IN ('newUnitTitle', 'varyCommonProperty', 'cancelUnitPlan', 'changeBodyCorp', 'StrataUnitCreate' )
 AND   NOT EXISTS (SELECT approle_code FROM system.approle_appgroup 
				   WHERE r.code = approle_code AND appgroup_id = g.id));

INSERT INTO system.approle_appgroup (approle_code, appgroup_id) 
(SELECT r.code, g.id FROM system.appgroup g, system.approle  r
 WHERE g."name" = 'Quality Assurance'
 AND   r.code IN ('unitPlan')
 AND   NOT EXISTS (SELECT approle_code FROM system.approle_appgroup  
				   WHERE r.code = approle_code AND appgroup_id = g.id));
 
 INSERT INTO system.approle_appgroup (approle_code, appgroup_id) 
(SELECT r.code, 'super-group-id' FROM system.approle  r 
 WHERE r.code IN ('newUnitTitle', 'varyCommonProperty', 'cancelUnitPlan', 'unitPlan', 'changeBodyCorp', 'StrataUnitCreate')
 AND   NOT EXISTS (SELECT approle_code FROM system.approle_appgroup 
				   WHERE r.code = approle_code AND appgroup_id = 'super-group-id'));
 
 
-- *** Titles Configuration for Unit Titles ***
-- BA Unit Relationship Types
INSERT INTO administrative.ba_unit_rel_type (code, display_value, status)
SELECT 'commonProperty', 'Common Property::::SAMOAN', 'c' 
WHERE NOT EXISTS (SELECT code FROM administrative.ba_unit_rel_type WHERE code = 'commonProperty');

-- BA Unit Type for Common Property and Principal Units is Strata Unit. 
INSERT INTO administrative.ba_unit_type (code, display_value, status)
SELECT 'strataUnit', 'Strata Property Unit::::SAMOAN', 'c' 
WHERE NOT EXISTS (SELECT code FROM administrative.ba_unit_type WHERE code = 'strataUnit');

-- BA Unit Status applied to the underlying parcel of a unit development. 
INSERT INTO transaction.reg_status_type (code, display_value, status)
SELECT 'dormant', 'Dormant::::SAMOAN', 'c' 
WHERE NOT EXISTS (SELECT code FROM transaction.reg_status_type WHERE code = 'dormant');

-- *** Survey Configuration for Unit Titles ***

-- Parcel Types
INSERT INTO cadastre.cadastre_object_type (code,display_value,status)
SELECT 'principalUnit', 'Principal Unit::::SAMOAN', 'c' 
WHERE NOT EXISTS (SELECT code FROM cadastre.cadastre_object_type WHERE code = 'principalUnit');

INSERT INTO cadastre.cadastre_object_type (code,display_value,status)
SELECT 'accessoryUnit', 'Accessory Unit::::SAMOAN', 'c' 
WHERE NOT EXISTS (SELECT code FROM cadastre.cadastre_object_type WHERE code = 'accessoryUnit');

INSERT INTO cadastre.cadastre_object_type (code,display_value,status)
SELECT 'commonProperty', 'Common Property::::SAMOAN', 'c' 
WHERE NOT EXISTS (SELECT code FROM cadastre.cadastre_object_type WHERE code = 'commonProperty');

-- Level for the various unit parcels (Principal Unit, Accessory Unit and Common Property)
INSERT INTO cadastre.level (id, name, register_type_code, type_code)
SELECT uuid_generate_v1(), 'Unit Parcels', 'all', 'primaryRight'
WHERE NOT EXISTS (SELECT name FROM cadastre.level WHERE name = 'Unit Parcels');

CREATE OR REPLACE VIEW cadastre.unit_parcels AS 
 SELECT co.id, (btrim(co.name_firstpart) || ' PLAN ') || btrim(co.name_lastpart) AS label, co.geom_polygon AS "theGeom"
   FROM cadastre.cadastre_object co, cadastre.spatial_unit_in_group sug
  WHERE sug.spatial_unit_id = co.id AND co.type_code = 'parcel' AND co.status_code = 'current' 
  AND co.geom_polygon IS NOT NULL AND sug.unit_parcel_status_code = 'current';
  
DELETE FROM geometry_columns WHERE f_table_name = 'unit_parcels'; 
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'unit_parcels', 'theGeom', 2, 32702, 'POLYGON');

----Unit Parcels Layer----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_unit_parcel';

DELETE FROM system.config_map_layer
 WHERE "name" = 'unit_parcel';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_unit_parcel', 
 'SpatialResult.getUnitParcel');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getUnitParcel', 
 'SELECT co.id, cadastre.formatParcelNrLabel(co.name_firstpart, co.name_lastpart) as label,  st_asewkb(co.geom_polygon) as the_geom 
  FROM cadastre.cadastre_object co, cadastre.spatial_unit_in_group sug
  WHERE sug.spatial_unit_id = co.id AND co.type_code = ''parcel'' AND co.status_code = ''current'' 
  AND co.geom_polygon IS NOT NULL AND sug.unit_parcel_status_code = ''current''
  AND ST_Intersects(co.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))'); 
 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_unit_parcel', 
	'WITH unit_plan_parcels AS 
	  (SELECT co_unit.id AS unit_id,
	          sug2.spatial_unit_group_id AS group_id,
			  CASE co_unit.type_code 
				WHEN ''commonProperty'' THEN 1 
				WHEN ''principalUnit'' THEN 2
				WHEN ''accessoryUnit'' THEN 3 END  AS unit_type, 
			  co_unit.name_firstpart AS unit_name, 
			  co_unit.name_lastpart AS plan_num
	   FROM   cadastre.cadastre_object co_unit, 
	          cadastre.spatial_unit_in_group sug2
	   WHERE  co_unit.status_code = ''current''
	   AND    co_unit.type_code != ''parcel''
	   AND    sug2.spatial_unit_id = co_unit.id
	   AND    sug2.unit_parcel_status_code = ''current''
	   ORDER BY unit_type, plan_num, unit_name)
	SELECT co.id, 
			cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as parcel_nr,
		   (SELECT  string_agg(unit_name, '', '') 
			FROM 	unit_plan_parcels
			WHERE   group_id = sg.id) || '' PLAN '' || sg.name AS unit_parcels,
		   (SELECT string_agg(ba.name_firstpart || ''/'' || ba.name_lastpart, '', '') 
			FROM 	unit_plan_parcels, 
					administrative.ba_unit_contains_spatial_unit bas, 
					administrative.ba_unit ba
			WHERE	group_id = sg.id 
			AND     bas.spatial_unit_id = unit_id 
			AND     bas.ba_unit_id = ba.id
			AND     ba.status_code = ''current'') AS unit_properties,
			st_asewkb(co.geom_polygon) as the_geom
	FROM 	cadastre.cadastre_object co, 
	        cadastre.spatial_unit_in_group sug,
			cadastre.spatial_unit_group sg
	WHERE 	co.type_code= ''parcel'' 
	AND 	co.status_code= ''current''  
	AND     sug.unit_parcel_status_code = ''current''
    AND     sug.spatial_unit_id = co.id
	AND     sg.id = sug.spatial_unit_group_id
	AND		co.geom_polygon IS NOT NULL
	AND 	ST_Intersects(co.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))'); 

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_unit_parcel', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_unit_parcel', 1, 'parcel_nr', 'Parcel number::::Poloka numera');

 INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_unit_parcel', 2, 'unit_parcels', 'Unit Parcels::::SAMOAN');  

 INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_unit_parcel', 3, 'unit_properties', 'Strata Properties::::SAMOAN'); 
 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_unit_parcel', 4, 'the_geom', null); 

 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('unit_parcel', 'Unit Parcels::::SAMOAN', 'pojo', 'SpatialResult.getUnitParcel', 'theGeom:Polygon,label:""', 
  'dynamic.informationtool.get_unit_parcel', 'samoa_unit_parcel.xml', TRUE, 35, FALSE); 


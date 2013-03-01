  
----- Existing Layer Updates ----
-- Remove layers from core SOLA that are not used by Samoa
DELETE FROM system.config_map_layer WHERE "name" IN ('place-names', 'survey-controls', 'roads'); 
DELETE FROM system.query_field WHERE query_name IN ('dynamic.informationtool.get_place_name', 
  'dynamic.informationtool.get_road', 'dynamic.informationtool.get_survey_control'); 
DELETE FROM system.query WHERE "name" IN ('SpatialResult.getSurveyControls',
'SpatialResult.getRoads', 'SpatialResult.getPlaceNames', 'dynamic.informationtool.get_place_name', 
'dynamic.informationtool.get_road', 'dynamic.informationtool.get_survey_control');

---- Update existing layers to use correct sytles and item_order ----- 

-- Disable this map layer for the time being. MNRE have requested 
-- orhtophotos, but this layer needs further configuration before
-- it is made availalbe.  
UPDATE system.config_map_layer
SET item_order = 10, 
    visible_in_start = FALSE,
	active = FALSE
WHERE "name" = 'orthophoto';

UPDATE system.config_map_layer
SET style = 'samoa_parcel.xml', 
    item_order = 30
WHERE "name" = 'parcels'; 

UPDATE system.config_map_layer
SET item_order = 40, 
    visible_in_start = FALSE
WHERE "name" = 'parcel-nodes';

UPDATE system.config_map_layer
SET item_order = 50, 
    visible_in_start = FALSE
WHERE "name" = 'parcels-historic-current-ba';  
  
UPDATE system.config_map_layer
SET style = 'samoa_application.xml', 
    item_order = 140, 
	visible_in_start = TRUE
WHERE "name" = 'applications'; 

UPDATE system.config_map_layer
SET item_order = 130, 
	visible_in_start = FALSE
WHERE "name" = 'pending-parcels';

-- Name Translations
UPDATE system.config_map_layer SET title = 'Applications::::Talosaga' WHERE "name" = 'applications';
UPDATE system.config_map_layer SET title = 'Parcels::::Poloka' WHERE "name" = 'parcels';
UPDATE system.config_map_layer SET title = 'Pending Parcels::::Poloka Faamalumalu' WHERE "name" = 'pending-parcels';
UPDATE system.config_map_layer SET title = 'Hydro::::eleele susu' WHERE "name" = 'hydro';
UPDATE system.config_map_layer SET title = 'Orthophoto::::SAMOAN' WHERE "name" = 'orthophoto';
UPDATE system.config_map_layer SET title = 'Historic Parcels with Current Titles::::Talaaga o le Fanua' WHERE "name" = 'parcels-historic-current-ba';
UPDATE system.config_map_layer SET title = 'Parcel Nodes::::Nota o le poloka' WHERE "name" = 'parcel-nodes';

UPDATE system.query_field SET display_value = 'Number::::Numera' WHERE "name" = 'nr';
UPDATE system.query_field SET display_value = 'Parcel number::::Poloka numera' WHERE "name" = 'parcel_nr'; 
UPDATE system.query_field SET display_value = 'Properties::::Meatotino' WHERE "name" = 'ba_units'; 
UPDATE system.query_field SET display_value = 'Official area (m2)::::Tele o le poloka ua faailoaina' WHERE "name" = 'area_official_sqm'; 
UPDATE system.query_field SET display_value = 'Name::::Igoa' WHERE "name" = 'label'; 
 
-- Function to assist the formatting of the parcel number
CREATE OR REPLACE FUNCTION cadastre.formatParcelNr(first_part CHARACTER VARYING(20), last_part CHARACTER VARYING(50))
  RETURNS CHARACTER VARYING(100) AS $BODY$
  BEGIN
    RETURN first_part || ' PLAN ' || last_part; 
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION cadastre.formatParcelNr(CHARACTER VARYING(20), CHARACTER VARYING(50)) 
  IS 'Formats the number/appellation to use for the parcel';
  
CREATE OR REPLACE FUNCTION cadastre.formatParcelNrLabel(first_part CHARACTER VARYING(20), last_part CHARACTER VARYING(50))
  RETURNS CHARACTER VARYING(100) AS $BODY$
  BEGIN
    RETURN first_part || chr(10) || last_part; 
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION cadastre.formatParcelNrLabel(CHARACTER VARYING(20), CHARACTER VARYING(50)) 
  IS 'Formats the number/appellation for the parcel over 2 lines';

-- Information Tool Queries (existing layers) 
CREATE OR REPLACE FUNCTION cadastre.formatAreaMetric(area NUMERIC(29,2))
  RETURNS CHARACTER VARYING(40) AS $BODY$
  BEGIN
	CASE WHEN area IS NULL THEN RETURN NULL;
	WHEN area < 1 THEN RETURN '    < 1 m' || chr(178);
	WHEN area < 10000 THEN RETURN to_char(area, '999,999 m') || chr(178);
	ELSE RETURN to_char((area/10000), '999,999.999 ha'); 
	END CASE; 
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION cadastre.formatAreaMetric(NUMERIC(29,2)) 
  IS 'Formats a metric area to m2 or hectares if area > 10,000m2';

  
CREATE OR REPLACE FUNCTION cadastre.formatareaimperial(area numeric)
  RETURNS character varying AS
$BODY$
   DECLARE perches NUMERIC(29,12); 
   DECLARE roods   NUMERIC(29,12); 
   DECLARE acres   NUMERIC(29,12);
   DECLARE remainder NUMERIC(29,12);
   DECLARE result  CHARACTER VARYING(40) := ''; 
   BEGIN
	IF area IS NULL THEN RETURN NULL; END IF; 
	acres := (area/4046.8564); -- 1a = 4046.8564m2     
	remainder := acres - trunc(acres,0);  
	roods := (remainder * 4); -- 4 roods to an acre
	remainder := roods - trunc(roods,0);
	perches := (remainder * 40); -- 40 perches to a rood
	IF acres >= 1 THEN
	  result := trim(to_char(trunc(acres,0), '9,999,999a')); 
	END IF; 
	-- Allow for the rounding introduced by to_char by manually incrementing
	-- the roods if perches are >= 39.95
	IF perches >= 39.95 THEN
	   roods := roods + 1;
	   perches = 0; 
	END IF; 
	IF acres >= 1 OR roods >= 1 THEN
	  result := result || ' ' || trim(to_char(trunc(roods,0), '99r'));
	END IF; 
	  result := result || ' ' || trim(to_char(perches, '00.0p'));
	RETURN '('  || trim(result) || ')';  
    END; 
    $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cadastre.formatareaimperial(numeric)
  OWNER TO postgres;
COMMENT ON FUNCTION cadastre.formatareaimperial(numeric) IS 'Formats a metric area to an imperial area measurement consisting of arces, roods and perches';

-- Add official area and calculated area to the parcel information
UPDATE system.query SET sql = 
	'SELECT co.id, 
			cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as parcel_nr,
		   (SELECT string_agg(ba.name_firstpart || ''/'' || ba.name_lastpart, '','') 
			FROM 	administrative.ba_unit_contains_spatial_unit bas, 
					administrative.ba_unit ba
			WHERE	spatial_unit_id = co.id and bas.ba_unit_id = ba.id) AS ba_units,
			cadastre.formatAreaMetric(sva.size) || '' '' || cadastre.formatAreaImperial(sva.size) AS official_area,
			CASE WHEN sva.size IS NOT NULL THEN NULL
			     ELSE cadastre.formatAreaMetric(CAST(st_area(co.geom_polygon) AS NUMERIC(29,2))) || '' '' ||
			cadastre.formatAreaImperial(CAST(st_area(co.geom_polygon) AS NUMERIC(29,2))) END AS calculated_area,
			st_asewkb(co.geom_polygon) as the_geom
	FROM 	cadastre.cadastre_object co LEFT OUTER JOIN cadastre.spatial_value_area sva 
			ON sva.spatial_unit_id = co.id AND sva.type_code = ''officialArea''
	WHERE 	co.type_code= ''parcel'' 
	AND 	co.status_code= ''current''      
	AND 	ST_Intersects(co.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))'
WHERE "name" = 'dynamic.informationtool.get_parcel';

-- Update the query fields for the get_parcel information tool
DELETE FROM system.query_field WHERE query_name = 'dynamic.informationtool.get_parcel'; 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel', 1, 'parcel_nr', 'Parcel number::::Poloka numera'); 

 INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel', 2, 'ba_units', 'Properties::::Meatotino'); 
 
  INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel', 3, 'official_area', 'Official area::::SAMOAN'); 
 
  INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel', 4, 'calculated_area', 'Calculated area::::SAMOAN'); 
 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel', 5, 'the_geom', null); 

 
-- Add official area and calculated area to the pending parcel information
UPDATE system.query SET sql = 
	'SELECT co.id, 
			cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as parcel_nr,
			cadastre.formatAreaMetric(sva.size) || '' '' || cadastre.formatAreaImperial(sva.size) AS official_area,
			CASE WHEN sva.size IS NOT NULL THEN NULL
			     ELSE cadastre.formatAreaMetric(CAST(st_area(co.geom_polygon) AS NUMERIC(29,2))) || '' '' ||
			cadastre.formatAreaImperial(CAST(st_area(co.geom_polygon) AS NUMERIC(29,2))) END AS calculated_area,
			st_asewkb(co.geom_polygon) as the_geom
	FROM 	cadastre.cadastre_object co LEFT OUTER JOIN cadastre.spatial_value_area sva 
			ON sva.spatial_unit_id = co.id AND sva.type_code = ''officialArea''
	WHERE   co.type_code= ''parcel'' 
	AND   ((co.status_code = ''pending''    
	AND 	ST_Intersects(co.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid})))   
	   OR  (co.id in (SELECT 	cadastre_object_id           
					  FROM 		cadastre.cadastre_object_target co_t,
								transaction.transaction t
					  WHERE 	ST_Intersects(co_t.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid})) 
					  AND 		co_t.transaction_id = t.id
					  AND		t.status_code not in (''approved''))))'
WHERE "name" = 'dynamic.informationtool.get_parcel_pending';

-- Update the query fields for the get_parcel_pending information tool
DELETE FROM system.query_field WHERE query_name = 'dynamic.informationtool.get_parcel_pending'; 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_pending', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_pending', 1, 'parcel_nr', 'Parcel number::::Poloka numera'); 
 
  INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_pending', 2, 'official_area', 'Official area::::SAMOAN'); 
 
  INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_pending', 3, 'calculated_area', 'Calculated area::::SAMOAN'); 
 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_pending', 4, 'the_geom', null); 
 
-- Add official area and calculated area to the historic parcel, current title information
UPDATE system.query SET sql = 
	'SELECT co.id, 
			cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as parcel_nr,
		   (SELECT string_agg(ba.name_firstpart || ''/'' || ba.name_lastpart, '','') 
			FROM 	administrative.ba_unit_contains_spatial_unit bas, 
					administrative.ba_unit ba
			WHERE	spatial_unit_id = co.id and bas.ba_unit_id = ba.id) AS ba_units,
			cadastre.formatAreaMetric(sva.size) || '' '' || cadastre.formatAreaImperial(sva.size) AS official_area,
			CASE WHEN sva.size IS NOT NULL THEN NULL
			     ELSE cadastre.formatAreaMetric(CAST(st_area(co.geom_polygon) AS NUMERIC(29,2))) || '' '' ||
			cadastre.formatAreaImperial(CAST(st_area(co.geom_polygon) AS NUMERIC(29,2))) END AS calculated_area,
			st_asewkb(co.geom_polygon) as the_geom
	FROM 	cadastre.cadastre_object co LEFT OUTER JOIN cadastre.spatial_value_area sva 
			ON sva.spatial_unit_id = co.id AND sva.type_code = ''officialArea'', 
			administrative.ba_unit_contains_spatial_unit ba_co, 
			administrative.ba_unit ba
	WHERE 	co.type_code= ''parcel'' 
	AND 	co.status_code= ''historic''      
	AND 	ST_Intersects(co.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))
	AND     ba_co.spatial_unit_id = co.id
	AND		ba.id = ba_co.ba_unit_id
	AND		ba.status_code = ''current'''
WHERE "name" = 'dynamic.informationtool.get_parcel_historic_current_ba';

-- Update the query fields for the get_parcel_pending information tool
DELETE FROM system.query_field WHERE query_name = 'dynamic.informationtool.get_parcel_historic_current_ba'; 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 1, 'parcel_nr', 'Parcel number::::Poloka numera'); 

 INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 2, 'ba_units', 'Properties::::Meatotino'); 
 
  INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 3, 'official_area', 'Official area::::SAMOAN'); 
 
  INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 4, 'calculated_area', 'Calculated area::::SAMOAN'); 
 
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 5, 'the_geom', null); 
 
 

-- Setup Spatial Config for Samoa
-- CLEAR CADASTRE DATABASE TABLES
DELETE FROM cadastre.spatial_value_area;
DELETE FROM cadastre.spatial_unit;
DELETE FROM cadastre.spatial_unit_historic;
DELETE FROM cadastre.level;
DELETE FROM cadastre.cadastre_object;
DELETE FROM cadastre.cadastre_object_historic;

--SET NEW SRID and OTHER SAMOA PARAMETERS
UPDATE public.geometry_columns SET srid = 32702; 
UPDATE application.application set location = null;
UPDATE system.setting SET vl = '32702' WHERE "name" = 'map-srid'; 
UPDATE system.setting SET vl = '300500' WHERE "name" = 'map-west'; 
UPDATE system.setting SET vl = '8439000' WHERE "name" = 'map-south'; 
UPDATE system.setting SET vl = '461900' WHERE "name" = 'map-east'; 
UPDATE system.setting SET vl = '8518000' WHERE "name" = 'map-north'; 

-- Reset the SRID check constraints
ALTER TABLE cadastre.spatial_unit DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.spatial_unit ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);
ALTER TABLE cadastre.spatial_unit_historic DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.spatial_unit_historic ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);

ALTER TABLE cadastre.spatial_unit DROP CONSTRAINT IF EXISTS enforce_srid_reference_point;
ALTER TABLE cadastre.spatial_unit ADD CONSTRAINT enforce_srid_reference_point CHECK (st_srid(reference_point) = 32702);
ALTER TABLE cadastre.spatial_unit_historic DROP CONSTRAINT IF EXISTS enforce_srid_reference_point;
ALTER TABLE cadastre.spatial_unit_historic ADD CONSTRAINT enforce_srid_reference_point CHECK (st_srid(reference_point) = 32702);

ALTER TABLE cadastre.cadastre_object DROP CONSTRAINT IF EXISTS enforce_srid_geom_polygon;
ALTER TABLE cadastre.cadastre_object ADD CONSTRAINT enforce_srid_geom_polygon CHECK (st_srid(geom_polygon) = 32702);
ALTER TABLE cadastre.cadastre_object_historic DROP CONSTRAINT IF EXISTS enforce_srid_geom_polygon;
ALTER TABLE cadastre.cadastre_object_historic ADD CONSTRAINT enforce_srid_geom_polygon CHECK (st_srid(geom_polygon) = 32702);

ALTER TABLE cadastre.cadastre_object_target DROP CONSTRAINT IF EXISTS enforce_srid_geom_polygon;
ALTER TABLE cadastre.cadastre_object_target ADD CONSTRAINT enforce_srid_geom_polygon CHECK (st_srid(geom_polygon) = 32702);
ALTER TABLE cadastre.cadastre_object_target_historic DROP CONSTRAINT IF EXISTS enforce_srid_geom_polygon;
ALTER TABLE cadastre.cadastre_object_target_historic ADD CONSTRAINT enforce_srid_geom_polygon CHECK (st_srid(geom_polygon) = 32702);

ALTER TABLE cadastre.cadastre_object_node_target DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.cadastre_object_node_target ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);
ALTER TABLE cadastre.cadastre_object_node_target_historic DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.cadastre_object_node_target_historic ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);

ALTER TABLE application.application DROP CONSTRAINT IF EXISTS enforce_srid_location;
ALTER TABLE application.application ADD CONSTRAINT enforce_srid_location CHECK (st_srid(location) = 32702);
ALTER TABLE application.application_historic DROP CONSTRAINT IF EXISTS enforce_srid_location;
ALTER TABLE application.application_historic ADD CONSTRAINT enforce_srid_location CHECK (st_srid(location) = 32702);

ALTER TABLE cadastre.survey_point DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.survey_point ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);
ALTER TABLE cadastre.survey_point_historic DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.survey_point_historic ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);

ALTER TABLE cadastre.survey_point DROP CONSTRAINT IF EXISTS enforce_srid_original_geom;
ALTER TABLE cadastre.survey_point ADD CONSTRAINT enforce_srid_original_geom CHECK (st_srid(original_geom) = 32702);
ALTER TABLE cadastre.survey_point_historic DROP CONSTRAINT IF EXISTS enforce_srid_original_geom;
ALTER TABLE cadastre.survey_point_historic ADD CONSTRAINT enforce_srid_original_geom CHECK (st_srid(original_geom) = 32702);

-- Configure the Level data for Samoa
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code, change_action, change_user, change_time)
                VALUES (uuid_generate_v1(), 'Parcels', 'all', 'polygon', 'primaryRight', 'i', 'test-id', now());
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Court Grants', 'all', 'point', 'primaryRight');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
         VALUES (uuid_generate_v1(), 'Road Centerlines', 'all', 'unStructuredLine', 'network');				
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Survey Plans', 'all', 'point', 'primaryRight');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Hydro Features', 'all', 'polygon', 'geographicLocator');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Record Sheets', 'all', 'polygon', 'geographicLocator');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Islands', 'all', 'point', 'geographicLocator');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Districts', 'all', 'point', 'geographicLocator');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Villages', 'all', 'point', 'geographicLocator');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Roads', 'all', 'polygon', 'geographicLocator');
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Flur', 'all', 'polygon', 'geographicLocator');
			
-- Create Views for each layer. Note that these views are not used by the application, but can be used
-- from AtlasStyler to assist with layer styling. 
-- Remove views that are not relevant to Samoa
DROP VIEW IF EXISTS cadastre.place_name;
DROP VIEW IF EXISTS cadastre.road;
DROP VIEW IF EXISTS cadastre.survey_control;

CREATE OR REPLACE VIEW cadastre.court_grants AS 
 SELECT su.id, su.label, su.reference_point AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Court Grants'::text;

CREATE OR REPLACE VIEW cadastre.current_parcels AS 
 SELECT co.id, (btrim(co.name_firstpart::text) || ' Plan '::text) || btrim(co.name_lastpart::text) AS label, co.geom_polygon AS "theGeom"
   FROM cadastre.cadastre_object co
  WHERE co.type_code::text = 'parcel'::text AND co.status_code::text = 'current'::text;

CREATE OR REPLACE VIEW cadastre.districts AS 
 SELECT su.id, su.label, su.reference_point AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Districts'::text;

CREATE OR REPLACE VIEW cadastre.hydro_features AS 
 SELECT su.id, su.label, su.geom AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Hydro Features'::text;

CREATE OR REPLACE VIEW cadastre.islands AS 
 SELECT su.id, su.label, su.reference_point AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Islands'::text;

CREATE OR REPLACE VIEW cadastre.pending_parcels AS 
 SELECT co.id, (btrim(co.name_firstpart::text) || ' Plan '::text) || btrim(co.name_lastpart::text) AS label, co.geom_polygon AS "theGeom"
   FROM cadastre.cadastre_object co
  WHERE co.type_code::text = 'parcel'::text AND co.status_code::text = 'pending'::text;

CREATE OR REPLACE VIEW cadastre.record_sheets AS 
 SELECT su.id, su.label, su.geom AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Record Sheets'::text;

CREATE OR REPLACE VIEW cadastre.road_centerlines AS 
 SELECT su.id, su.label, su.geom AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Road Centerlines'::text;

CREATE OR REPLACE VIEW cadastre.survey_plans AS 
 SELECT su.id, su.label, su.reference_point AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Survey Plans'::text;

CREATE OR REPLACE VIEW cadastre.villages AS 
 SELECT su.id, su.label, su.reference_point AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Villages'::text; 

CREATE OR REPLACE VIEW cadastre.roads AS 
 SELECT su.id, su.label, su.geom AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Roads'::text;  
  
CREATE OR REPLACE VIEW cadastre.flur AS 
 SELECT su.id, su.label, su.geom AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id::text AND l.name::text = 'Flur'::text; 

DELETE FROM geometry_columns WHERE f_table_name = 'current_parcels'; 
DELETE FROM geometry_columns WHERE f_table_name = 'pending_parcels'; 
DELETE FROM geometry_columns WHERE f_table_name = 'road_centerlines'; 
DELETE FROM geometry_columns WHERE f_table_name = 'hydro_features'; 
DELETE FROM geometry_columns WHERE f_table_name = 'survey_plans'; 
DELETE FROM geometry_columns WHERE f_table_name = 'court_grants'; 
DELETE FROM geometry_columns WHERE f_table_name = 'districts'; 
DELETE FROM geometry_columns WHERE f_table_name = 'islands'; 
DELETE FROM geometry_columns WHERE f_table_name = 'villages'; 
DELETE FROM geometry_columns WHERE f_table_name = 'record_sheets';
DELETE FROM geometry_columns WHERE f_table_name = 'roads'; 
DELETE FROM geometry_columns WHERE f_table_name = 'flur'; 

INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'current_parcels', 'theGeom', 2, 32702, 'POLYGON');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'pending_parcels', 'theGeom', 2, 32702, 'POLYGON');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'road_centerlines', 'theGeom', 2, 32702, 'LINESTRING');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'hydro_features', 'theGeom', 2, 32702, 'POLYGON');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'survey_plans', 'theGeom', 2, 32702, 'POINT');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'court_grants', 'theGeom', 2, 32702, 'POINT');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'districts', 'theGeom', 2, 32702, 'POINT');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'islands', 'theGeom', 2, 32702, 'POINT');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'villages', 'theGeom', 2, 32702, 'POINT');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'record_sheets', 'theGeom', 2, 32702, 'POLYGON');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'roads', 'theGeom', 2, 32702, 'POLYGON');
INSERT INTO geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'flur', 'theGeom', 2, 32702, 'POLYGON');


-- Reset the query used for display of the Parcels Layer
UPDATE system.query SET sql = 
 'select co.id, cadastre.formatParcelNrLabel(co.name_firstpart, co.name_lastpart) as label,  st_asewkb(co.geom_polygon) as the_geom from cadastre.cadastre_object co where type_code= ''parcel'' and status_code= ''current'' 
 and ST_Intersects(co.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))'
 WHERE "name" = 'SpatialResult.getParcels'; 
 
-- Create Layers to be used by the SOLA for display	
-- Villages Layer --		
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_villages';

DELETE FROM system.config_map_layer
 WHERE "name" = 'villages';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_villages', 
 'SpatialResult.getVillages');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getVillages', 
 'select su.id, su.label,  st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Villages'' and ST_Intersects(su.reference_point, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_villages', 
 'select su.id, su.label, st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Villages''  and ST_Intersects(su.reference_point, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_villages', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_villages', 1, 'label', 'Village::::Nuu'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_villages', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('villages', 'Villages::::Nuu', 'pojo', 'SpatialResult.getVillages', 'theGeom:Point,label:""', 
  'dynamic.informationtool.get_villages', 'samoa_village.xml', TRUE, 120, TRUE);
 

 
----- District Layer-----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_districts';

DELETE FROM system.config_map_layer
 WHERE "name" = 'districts';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_districts', 
 'SpatialResult.getDistricts');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getDistricts', 
 'select su.id, su.label,  st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Districts'' and ST_Intersects(su.reference_point, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_districts', 
 'select su.id, su.label, st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Districts''  and ST_Intersects(su.reference_point, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_districts', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_districts', 1, 'label', 'District::::Itumalo'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_districts', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('districts', 'Districts::::Itumalo', 'pojo', 'SpatialResult.getDistricts', 'theGeom:Point,label:""', 
  'dynamic.informationtool.get_districts', 'samoa_district.xml', TRUE, 80, FALSE);

  
  
-----Court Grant Layer----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_courtGrant';

DELETE FROM system.config_map_layer
 WHERE "name" = 'courtGrant';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_courtGrant', 
 'SpatialResult.getCourtGrant');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getCourtGrant', 
 'select su.id, su.label,  st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Court Grants'' and ST_Intersects(su.reference_point, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_courtGrant', 
 'select su.id, su.label, st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Court Grants''  and ST_Intersects(su.reference_point, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_courtGrant', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_courtGrant', 1, 'label', 'Court Grant::::Iuga o le Faamasinoga'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_courtGrant', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('courtGrant', 'Court Grant::::Iuga o le Faamasinoga', 'pojo', 'SpatialResult.getCourtGrant', 'theGeom:Point,label:""', 
  'dynamic.informationtool.get_courtGrant', 'samoa_court_grant.xml', TRUE, 100, FALSE); 

  
  
----Hydro Layer----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_hydro';

DELETE FROM system.config_map_layer
 WHERE "name" = 'hydro';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_hydro', 
 'SpatialResult.getHydro');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getHydro', 
 'select su.id, su.label,  st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Hydro Features'' and ST_Intersects(su.geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_hydro', 
 'select su.id, su.label, st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Hydro Features''  and ST_Intersects(su.geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
  -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_hydro', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_hydro', 1, 'label', 'Name::::Igoa'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_hydro', 2, 'the_geom', null); 
 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('hydro', 'Hydro::::eleele susu', 'pojo', 'SpatialResult.getHydro', 'theGeom:Polygon,label:""', 
  'dynamic.informationtool.get_hydro', 'samoa_hydro.xml', TRUE, 20, TRUE);


  -----Islands Layer----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_islands';

DELETE FROM system.config_map_layer
 WHERE "name" = 'islands';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_islands', 
 'SpatialResult.getIslands');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getIslands', 
 'select su.id, su.label,  st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Islands'' and ST_Intersects(su.reference_point, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_islands', 
 'select su.id, su.label, st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Islands''  and ST_Intersects(su.reference_point, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_islands', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_islands', 1, 'label', 'Island::::Motu'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_islands', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('islands', 'Islands::::Motu', 'pojo', 'SpatialResult.getIslands', 'theGeom:Point,label:""', 
  'dynamic.informationtool.get_islands', 'samoa_island.xml', TRUE, 70, TRUE); 

  
  
  -----Record Sheets----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_recordSheets';

DELETE FROM system.config_map_layer
 WHERE "name" = 'recordSheet';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_recordSheets', 
 'SpatialResult.getRecordSheets');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getRecordSheets', 
 'select su.id, su.label,  st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Record Sheets'' and ST_Intersects(su.geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_recordSheets', 
 'select su.id, su.label, st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Record Sheets''  and ST_Intersects(su.geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_recordSheets', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_recordSheets', 1, 'label', 'Record Sheet::::Faamaumauga o fuataga'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_recordSheets', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('recordSheet', 'Record Sheets::::Faamaumauga o fuataga', 'pojo', 'SpatialResult.getRecordSheets', 'theGeom:Polygon,label:""', 
  'dynamic.informationtool.get_recordSheets', 'samoa_record_sheet.xml', TRUE, 60, FALSE); 
  
  
  
-----Survey Plan Reference Points----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_surveyPlan';

DELETE FROM system.config_map_layer
 WHERE "name" = 'survey_plan';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_surveyPlan', 
 'SpatialResult.getSurveyPlan');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getSurveyPlan', 
 'select su.id, su.label,  st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Survey Plans'' and ST_Intersects(su.reference_point, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_surveyPlan', 
 'select su.id, su.label, st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Survey Plans''  and ST_Intersects(su.reference_point, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_surveyPlan', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_surveyPlan', 1, 'label', 'Survey Plan::::Fuataga o Fanua'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_surveyPlan', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('survey_plan', 'Survey Plan::::Fuataga o Fanua', 'pojo', 'SpatialResult.getSurveyPlan', 'theGeom:Point,label:""', 
  'dynamic.informationtool.get_surveyPlan', 'samoa_survey_plan.xml', TRUE, 90, FALSE); 
  

-----Road Centrelines----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_roadCL';

DELETE FROM system.config_map_layer
 WHERE "name" = 'road_cl';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_roadCL', 
 'SpatialResult.getRoadCL');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getRoadCL', 
 'select su.id, su.label,  st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Road Centerlines'' and ST_Intersects(su.geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_roadCL', 
 'select su.id, su.label, st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Road Centerlines''  and ST_Intersects(su.geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_roadCL', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_roadCL', 1, 'label', 'Road Name::::SAMOAN'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_roadCL', 2, 'the_geom', null); 

 
 -- Disable the Road Centerline layer in favour of the Roads layer. 
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('road_cl', 'Road Centrelines::::Ogatotonu o le auala', 'pojo', 'SpatialResult.getRoadCL', 'theGeom:LineString,label:""', 
  'dynamic.informationtool.get_roadCL', 'samoa_road_cl.xml', TRUE, 110, TRUE); 
  

  
------ Offical Parcel Area Layer ------		
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.config_map_layer
 WHERE "name" = 'parcel_area';

DELETE FROM system.query
 WHERE "name" IN ('SpatialResult.getParcelAreas');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getParcelAreas', 
 'select co.id, trim(cadastre.formatAreaMetric(sva.size)) || chr(10) || cadastre.formatAreaImperial(sva.size) AS label,  st_asewkb(co.geom_polygon) as the_geom from cadastre.cadastre_object co, cadastre.spatial_value_area sva 
 WHERE co.type_code= ''parcel'' and co.status_code= ''current'' AND sva.spatial_unit_id = co.id AND sva.type_code = ''officialArea'' 
 AND ST_Intersects(co.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');
 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('parcel_area', 'Parcel Area::::Tele o le poloka', 'pojo', 'SpatialResult.getParcelAreas', 
 'theGeom:Polygon,label:""', NULL, 'samoa_parcel_area.xml', TRUE, 25, FALSE);
 

 
 ----Roads Layer----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_road';

DELETE FROM system.config_map_layer
 WHERE "name" = 'road';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_road', 
 'SpatialResult.getRoad');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getRoad', 
 'select su.id, su.label,  st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Roads'' and ST_Intersects(su.geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_road', 
 'select su.id, su.label, st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Roads''  and ST_Intersects(su.geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_road', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_road', 1, 'label', 'Road Name::::Auala'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_road', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('road', 'Roads::::Auala', 'pojo', 'SpatialResult.getRoad', 'theGeom:Polygon,label:""', 
  'dynamic.informationtool.get_road', 'samoa_road.xml', TRUE, 105, FALSE); 
   

 ----Flur Layer----
-- Remove any pre-existing data for the new navigation layer
DELETE FROM system.query_field
 WHERE query_name = 'dynamic.informationtool.get_flur';

DELETE FROM system.config_map_layer
 WHERE "name" = 'flur';

DELETE FROM system.query
 WHERE "name" IN ('dynamic.informationtool.get_flur', 
 'SpatialResult.getFlur');

 -- Add the necessary dynamic queries
INSERT INTO system.query("name", sql)
 VALUES ('SpatialResult.getFlur', 
 'select su.id, su.label,  st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Flur'' and ST_Intersects(su.geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))');

 
INSERT INTO system.query("name", sql)
 VALUES ('dynamic.informationtool.get_flur', 
 'select su.id, su.label, st_asewkb(su.geom) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''Flur''  and ST_Intersects(su.geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))');

 -- Configure the query fields for the Object Information Tool
INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_flur', 0, 'id', null); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_flur', 1, 'label', 'Flur Number::::SAMOAN'); 

INSERT INTO system.query_field(query_name, index_in_query, "name", display_value) 
 VALUES ('dynamic.informationtool.get_flur', 2, 'the_geom', null); 

 
 -- Configure the new Navigation Layer
INSERT INTO system.config_map_layer ("name", title, type_code, pojo_query_name, pojo_structure, pojo_query_name_for_select, style, active, item_order, visible_in_start)
 VALUES ('flur', 'Flur::::SAMOAN', 'pojo', 'SpatialResult.getFlur', 'theGeom:Polygon,label:""', 
  'dynamic.informationtool.get_flur', 'samoa_flur.xml', TRUE, 102, FALSE); 
   
 
 
 ----- Spatial Search Configuration -----
 UPDATE system.map_search_option
 SET   title = 'Property Number::::Meatotino Numera'
 WHERE code = 'BAUNIT';
 
 UPDATE system.map_search_option
 SET   title = 'Parcel Number::::Poloka Numera'
 WHERE code = 'NUMBER';
 
 UPDATE system.map_search_option
 SET   title = 'Property Owner::::Meatotino O e Pule'
 WHERE code = 'OWNER_OF_BAUNIT';
 
 -- Road Search
DELETE FROM system.map_search_option
 WHERE query_name = 'map_search.road';
 
 DELETE FROM system.query
 WHERE "name" = 'map_search.road';
 
 INSERT INTO system.query("name", sql)
 VALUES ('map_search.road', 
 'SELECT su.id, su.label, st_asewkb(su.geom) as the_geom 
  FROM cadastre.spatial_unit su, cadastre.level l 
  WHERE su.level_id = l.id and l."name" = ''Road Centerlines''  
  AND compare_strings(#{search_string}, su.label)
  AND su.label IS NOT NULL
  AND su.geom IS NOT NULL');
 
 INSERT INTO system.map_search_option(code, title, query_name, active, min_search_str_len, zoom_in_buffer)
 VALUES ('ROAD', 'Road Name::::Auala', 'map_search.road', TRUE, 3, 100); 
 
 -- Flur Search
DELETE FROM system.map_search_option
 WHERE query_name = 'map_search.flur';
 
 DELETE FROM system.query
 WHERE "name" = 'map_search.flur';
 
 INSERT INTO system.query("name", sql)
 VALUES ('map_search.flur', 
 'SELECT su.id, su.label, st_asewkb(su.geom) as the_geom 
  FROM cadastre.spatial_unit su, cadastre.level l 
  WHERE su.level_id = l.id and l."name" = ''Flur''  
  AND compare_strings(#{search_string}, su.label)
  AND su.label IS NOT NULL
  AND su.geom IS NOT NULL');
 
 INSERT INTO system.map_search_option(code, title, query_name, active, min_search_str_len, zoom_in_buffer)
 VALUES ('FLUR', 'Flur Number::::SAMOAN', 'map_search.flur', TRUE, 1, 300); 
 
 
 -- Village Search
 DELETE FROM system.map_search_option
 WHERE query_name = 'map_search.village';
 
 DELETE FROM system.query
 WHERE "name" = 'map_search.village';
 
 INSERT INTO system.query("name", sql)
 VALUES ('map_search.village', 
 'SELECT su.id, su.label, st_asewkb(su.reference_point) as the_geom 
  FROM cadastre.spatial_unit su, cadastre.level l 
  WHERE su.level_id = l.id and l."name" = ''Villages''  
  AND compare_strings(#{search_string}, su.label)
  AND su.reference_point IS NOT NULL');
 
 INSERT INTO system.map_search_option(code, title, query_name, active, min_search_str_len, zoom_in_buffer)
 VALUES ('VILLAGE', 'Village::::Nuu', 'map_search.village', TRUE, 2, 300); 
 
 
 -- Court Grant Search
DELETE FROM system.map_search_option
 WHERE query_name = 'map_search.court_grant';
 
DELETE FROM system.query
 WHERE "name" = 'map_search.court_grant';
 
 INSERT INTO system.query("name", sql)
 VALUES ('map_search.court_grant', 
 'SELECT MIN(su.id) as id, su.label, st_asewkb(ST_Union(su.reference_point)) as the_geom 
  FROM cadastre.spatial_unit su, cadastre.level l 
  WHERE su.level_id = l.id and l."name" = ''Court Grants''  
  AND compare_strings(#{search_string}, su.label)
  AND su.reference_point IS NOT NULL
  GROUP BY su.label');
 
 INSERT INTO system.map_search_option(code, title, query_name, active, min_search_str_len, zoom_in_buffer)
 VALUES ('COURT_GRANT', 'Court Grant::::Iuga o le Faamasinoga', 'map_search.court_grant', TRUE, 1, 200); 
 
  -- Survey Plan and Application Search
 DELETE FROM system.map_search_option
 WHERE query_name = 'map_search.survey_plan';
 
 DELETE FROM system.query
 WHERE "name" = 'map_search.survey_plan';
 
 INSERT INTO system.query("name", sql)
 VALUES ('map_search.survey_plan', 
 'SELECT MIN(su.id) as id, su.label, st_asewkb(ST_Union(su.reference_point)) as the_geom 
  FROM cadastre.spatial_unit su, cadastre.level l 
  WHERE su.level_id = l.id and l."name" = ''Survey Plans''  
  AND compare_strings(#{search_string}, su.label)
  AND su.reference_point IS NOT NULL
  GROUP BY su.label
  UNION
  SELECT app.id as id, app.nr as label, st_asewkb(app.location) as the_geom
  FROM application.application app
  WHERE app.location IS NOT NULL
  AND   app.status_code != ''annulled''
  AND compare_strings(#{search_string}, app.nr)');
 
 INSERT INTO system.map_search_option(code, title, query_name, active, min_search_str_len, zoom_in_buffer)
 VALUES ('SURVEY_PLAN', 'Survey Plan::::Fuataga o Fanua', 'map_search.survey_plan', TRUE, 2, 100); 
 
  -- Property Owner Search fix
 UPDATE system.query SET sql = 'SELECT DISTINCT co.id,  
       coalesce(p.name, '''') || '' '' || coalesce(p.last_name, '''') || '' > '' || cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as label,  
       st_asewkb(co.geom_polygon) as the_geom 
FROM   party.party p,
       administrative.party_for_rrr pfr,
       administrative.rrr rrr,
       administrative.ba_unit bau,
       administrative.ba_unit_contains_spatial_unit bas,
       cadastre.cadastre_object  co
WHERE  compare_strings(#{search_string}, coalesce(p.name, '''') || '' '' || coalesce(p.last_name, '''') || '' '' || coalesce(p.alias, ''''))
AND    pfr.party_id = p.id
AND    rrr.id = pfr.rrr_id
AND    rrr.status_code = ''current''
AND    rrr.type_code = ''ownership''
AND    bau.id = rrr.ba_unit_id
AND    bas.ba_unit_id = bau.id
AND    co.id = bas.spatial_unit_id
AND    co.geom_polygon IS NOT NULL
AND   (co.status_code = ''current'' OR bau.status_code = ''current'')
LIMIT 30'
WHERE "name" = 'map_search.cadastre_object_by_baunit_owner'; 


-- Update layer and information tool queries to reflect the naming convention used for parcels in Samoa
UPDATE system.query SET sql = 
'SELECT id,  cadastre.formatParcelNr(name_firstpart, name_lastpart) as label, st_asewkb(geom_polygon) as the_geom  FROM cadastre.cadastre_object WHERE transaction_id IN (  SELECT cot.transaction_id FROM (administrative.ba_unit_contains_spatial_unit ba_su     INNER JOIN cadastre.cadastre_object co ON ba_su.spatial_unit_id = co.id)     INNER JOIN cadastre.cadastre_object_target cot ON co.id = cot.cadastre_object_id     WHERE ba_su.ba_unit_id = #{search_string})  AND (SELECT COUNT(1) FROM administrative.ba_unit_contains_spatial_unit WHERE spatial_unit_id = cadastre_object.id) = 0 AND geom_polygon IS NOT NULL AND status_code = ''current'''
WHERE "name" = 'system_search.cadastre_object_by_baunit_id';

UPDATE system.query SET sql = 
'select distinct co.id,  ba_unit.name_firstpart || ''/'' || ba_unit.name_lastpart || '' > '' || cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as label,  st_asewkb(geom_polygon) as the_geom from cadastre.cadastre_object  co    inner join administrative.ba_unit_contains_spatial_unit bas on co.id = bas.spatial_unit_id     inner join administrative.ba_unit on ba_unit.id = bas.ba_unit_id  where (co.status_code= ''current'' or ba_unit.status_code= ''current'') and co.geom_polygon IS NOT NULL  and compare_strings(#{search_string}, ba_unit.name_firstpart || '' / '' || ba_unit.name_lastpart) limit 30'
 WHERE "name" = 'map_search.cadastre_object_by_baunit';

-- #89 Updated Map Find by Parcel Number to match functionality of Parcel Search 
UPDATE system.query SET sql = 
'SELECT id, cadastre.formatParcelNr(name_firstpart, name_lastpart) as label, st_asewkb(geom_polygon) as the_geom  
 FROM cadastre.cadastre_object  
 WHERE status_code= ''current'' 
 AND geom_polygon IS NOT NULL 
 AND compare_strings(#{search_string}, name_firstpart || '' PLAN '' || name_lastpart) 
 ORDER BY lpad(regexp_replace(name_firstpart, ''\\D*'', '''', ''g''), 5, ''0'') || name_firstpart || name_lastpart
 LIMIT 30'
WHERE "name" = 'map_search.cadastre_object_by_number';
 
UPDATE system.query SET sql = 
'select co.id, cadastre.formatParcelNrLabel(co.name_firstpart, co.name_lastpart) as label,  st_asewkb(co.geom_polygon) as the_geom from cadastre.cadastre_object co inner join administrative.ba_unit_contains_spatial_unit ba_co on co.id = ba_co.spatial_unit_id   inner join administrative.ba_unit ba_unit on ba_unit.id= ba_co.ba_unit_id where co.type_code=''parcel'' and co.status_code= ''historic'' and ba_unit.status_code = ''current'' and ST_Intersects(co.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))'
 WHERE "name" = 'SpatialResult.getParcelsHistoricWithCurrentBA';
 
 UPDATE system.query SET sql = 
'select co.id, cadastre.formatParcelNrLabel(co.name_firstpart, co.name_lastpart) as label,  st_asewkb(co.geom_polygon) as the_geom  from cadastre.cadastre_object co  where type_code= ''parcel'' and status_code= ''pending''   and ST_Intersects(co.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) union select co.id, cadastre.formatParcelNr(co.name_firstpart, co.name_lastpart) as label,  st_asewkb(co_t.geom_polygon) as the_geom  from cadastre.cadastre_object co inner join cadastre.cadastre_object_target co_t on co.id = co_t.cadastre_object_id and co_t.geom_polygon is not null where ST_Intersects(co_t.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))       and co_t.transaction_id in (select id from transaction.transaction where status_code not in (''approved'')) '
 WHERE "name" = 'SpatialResult.getParcelsPending';
 
 
 -- Filter out annulled applications from the applications layer
UPDATE system.query
SET sql = 
'select id, nr as label, st_asewkb(location) as the_geom FROM application.application 
WHERE location IS NOT NULL AND status_code != ''annulled''
AND ST_Intersects(location, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))'
WHERE "name" = 'SpatialResult.getApplications'; 

UPDATE system.query
SET sql = 
'select id, nr, st_asewkb(location) as the_geom FROM application.application 
where location IS NOT NULL AND status_code != ''annulled''
AND  ST_Intersects(location, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))'
WHERE "name" = 'dynamic.informationtool.get_application';
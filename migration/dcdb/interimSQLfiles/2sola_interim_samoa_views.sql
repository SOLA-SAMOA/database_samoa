-- Create various views within the cadastre schema for the SamoaView customisation
-- 09 April 2012
-- Neil Pullar
--Modified 16 September 2012 to incorporate Road Polygons
--Remove cadastre schema views not relevant in Samoa
DROP VIEW IF EXISTS cadastre.place_name;
DROP VIEW IF EXISTS  cadastre.survey_control;
DROP VIEW IF EXISTS  cadastre.road;

--Current Parcels
CREATE OR REPLACE VIEW cadastre.current_parcels AS
	SELECT co.id, TRIM(co.name_firstpart) || ' Plan ' || TRIM(co.name_lastpart) AS label, co.geom_polygon AS "theGeom" 
	FROM cadastre.cadastre_object co
	WHERE type_code = 'parcel'  
	AND status_code = 'current';

DELETE FROM public.geometry_columns WHERE f_table_name = 'current_parcels';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'current_parcels', 'theGeom', 2, 32702, 'POLYGON');
	
--Pending Parcels
CREATE OR REPLACE VIEW cadastre.pending_parcels AS
	SELECT co.id, TRIM(co.name_firstpart) || ' Plan ' || TRIM(co.name_lastpart) AS label, co.geom_polygon AS "theGeom" 
	FROM cadastre.cadastre_object co
	WHERE type_code = 'parcel'  
	AND status_code = 'pending';

DELETE FROM public.geometry_columns WHERE f_table_name = 'pending_parcels';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'pending_parcels', 'theGeom', 2, 32702, 'POLYGON');

--Road Centrelines
CREATE OR REPLACE VIEW cadastre.roads AS
	SELECT su.id, su.label, su.geom AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Roads';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'roads';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'roads', 'theGeom', 2, 32702, 'LINESTRING');
--Road Polygons
CREATE OR REPLACE VIEW cadastre.road_polygons AS 
 SELECT su.id, su.label, su.geom AS "theGeom"
   FROM cadastre.spatial_unit su, cadastre.level l
  WHERE su.level_id::text = l.id
  AND l.name::text = 'Road Polygon Features';

DELETE FROM public.geometry_columns WHERE f_table_name = 'road_polygons';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'road_polygons', 'theGeom', 2, 32702, 'POLYGON');

--Hydro Polygons
CREATE OR REPLACE VIEW cadastre.hydro_features AS
	SELECT su.id, su.label, su.geom AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Hydro Features';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'hydro_features';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'hydro_features', 'theGeom', 2, 32702, 'POLYGON');

--Survey Plans
CREATE OR REPLACE VIEW cadastre.survey_plans AS
	SELECT su.id, su.label, su.reference_point AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Survey Plans';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'survey_plans';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'survey_plans', 'theGeom', 2, 32702, 'POINT');

--Court Grants
CREATE OR REPLACE VIEW cadastre.court_grants AS
	SELECT su.id, su.label, su.reference_point AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Court Grants';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'court_grants';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'court_grants', 'theGeom', 2, 32702, 'POINT');

--Districts
CREATE OR REPLACE VIEW cadastre.districts AS
	SELECT su.id, su.label, su.reference_point AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Districts';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'districts';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'districts', 'theGeom', 2, 32702, 'POINT');


--Islands
CREATE OR REPLACE VIEW cadastre.islands AS
	SELECT su.id, su.label, su.reference_point AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Islands';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'islands';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'islands', 'theGeom', 2, 32702, 'POINT');


--Villages
CREATE OR REPLACE VIEW cadastre.villages AS
	SELECT su.id, su.label, su.reference_point AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Villages';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'villages';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'villages', 'theGeom', 2, 32702, 'POINT');

--Record Sheets
CREATE OR REPLACE VIEW cadastre.record_sheets AS
	SELECT su.id, su.label, su.geom AS "theGeom" 
	FROM cadastre.spatial_unit su, cadastre.level l
	WHERE su.level_id = l.id
	AND l.name = 'Record Sheets';  

DELETE FROM public.geometry_columns WHERE f_table_name = 'record_sheets';

INSERT INTO public.geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
	VALUES('', 'cadastre', 'record_sheets', 'theGeom', 2, 32702, 'POLGON');
--
-- PostgreSQL Samoa Map Layer Definitions
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.0.1
-- Modified from Waiheke Test Data Definitions
-- Neil Pullar 
-- Started on 2012-04-09 09:14:14

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = system, pg_catalog;
--
-- Clear any existing map configuration records
--
DELETE FROM system.query_field;
DELETE FROM system.config_map_layer;
DELETE FROM system.query;
--
--
-- TOC entry 3652 (class 0 OID 206390)
-- Dependencies: 3329
-- Data for Name: query_field; Type: TABLE DATA; Schema: system; Owner: postgres
--
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel', 1, 'parcel_nr', 'Parcel number::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel', 2, 'ba_units', 'Properties::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel', 3, 'area_official_sqm', 'Official area (m2)::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel', 4, 'the_geom', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel_pending', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel_pending', 1, 'parcel_nr', 'Parcel number::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel_pending', 2, 'area_official_sqm', 'Official area (m2)::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_parcel_pending', 3, 'the_geom', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_village_name', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_village_name', 1, 'label', 'Name::::Nome');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_village_name', 2, 'reference_point', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_district_name', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_district_name', 1, 'label', 'Name::::Nome');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_district_name', 2, 'reference_point', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_island_name', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_island_name', 1, 'label', 'Name::::Nome');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_island_name', 2, 'reference_point', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_road', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_road', 1, 'label', 'Name::::Nome');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_road', 2, 'the_geom', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_application', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_application', 1, 'nr', 'Number::::Numero');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_application', 2, 'the_geom', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_survey_plan', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_survey_plan', 1, 'label', 'Label::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_survey_plan', 2, 'reference_point', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_court_grant', 0, 'id', NULL);
INSERT INTO query_field VALUES ('dynamic.informationtool.get_court_grant', 1, 'label', 'Label::::ITALIANO');
INSERT INTO query_field VALUES ('dynamic.informationtool.get_court_grant', 2, 'reference_point', NULL);

--
-- TOC entry 3657 (class 0 OID 206363)
-- Dependencies: 3325
-- Data for Name: config_map_layer; Type: TABLE DATA; Schema: system; Owner: postgres
--

INSERT INTO config_map_layer VALUES ('parcels', 'Parcels::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getParcels', 'theGeom:Polygon,label:""', 'dynamic.informationtool.get_parcel', NULL, 'parcel.xml', true, 1);
INSERT INTO config_map_layer VALUES ('pending-parcels', 'Pending parcels::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getParcelsPending', 'theGeom:Polygon,label:""', 'dynamic.informationtool.get_parcel_pending', NULL, 'pending_parcels.xml', true, 2);
INSERT INTO config_map_layer VALUES ('roads', 'Roads::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getRoads', 'theGeom:MultiPolygon,label:""', 'dynamic.informationtool.get_road', NULL, 'road.xml', true, 3);
INSERT INTO config_map_layer VALUES ('survey-plans', 'Survey Plans::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getSurveyPlans', 'theGeom:Point,label:""', 'dynamic.informationtool.get_survey_plan', NULL, 'survey_plan.xml', true, 4);
INSERT INTO config_map_layer VALUES ('court-grants', 'Court Grants::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getCourtGrants', 'theGeom:Point,label:""', 'dynamic.informationtool.get_court_grant', NULL, 'court_grant.xml', true, 5);
INSERT INTO config_map_layer VALUES ('village-names', 'Village names::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getVillageNames', 'theGeom:Point,label:""', 'dynamic.informationtool.get_village_name', NULL, 'village_name.xml', true, 5);
INSERT INTO config_map_layer VALUES ('district-names', 'District names::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getDistrictNames', 'theGeom:Point,label:""', 'dynamic.informationtool.get_district_name', NULL, 'district_name.xml', true, 5);
INSERT INTO config_map_layer VALUES ('island-names', 'Island names::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getIslandNames', 'theGeom:Point,label:""', 'dynamic.informationtool.get_island_name', NULL, 'island_name.xml', true, 5);
INSERT INTO config_map_layer VALUES ('applications', 'Applications::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getApplications', 'theGeom:MultiPoint,label:""', 'dynamic.informationtool.get_application', NULL, 'application.xml', true, 6);

--
-- TOC entry 3646 (class 0 OID 206384)
-- Dependencies: 3328
-- Data for Name: query; Type: TABLE DATA; Schema: system; Owner: postgres
--

INSERT INTO query VALUES ('SpatialResult.getParcels', 'SELECT co.id, co.name_firstpart || ''/'' || co.name_lastpart AS label,  st_asewkb(co.geom_polygon) AS the_geom FROM cadastre.cadastre_object co WHERE type_code= ''parcel'' AND status_code= ''current'' AND ST_Intersects(co.geom_polygon, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getParcelsPending', 'SELECT co.id, co.name_firstpart || ''/'' || co.name_lastpart AS label,  st_asewkb(co.geom_polygon) AS the_geom  FROM cadastre.cadastre_object co  WHERE type_code= ''parcel'' AND status_code= ''pending''   AND ST_Intersects(co.geom_polygon, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) UNION SELECT co.id, co.name_firstpart || ''/'' || co.name_lastpart AS label,  st_asewkb(co_t.geom_polygon) AS the_geom  FROM cadastre.cadastre_object co INNER JOIN cadastre.cadastre_object_target co_t ON co.id = co_t.cadastre_object_id AND co_t.geom_polygon IS NOT NULL WHERE ST_Intersects(co_t.geom_polygon, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))       AND co_t.transaction_id in (SELECT id FROM transaction.transaction WHERE status_code NOT IN (''approved'')) ', NULL);
INSERT INTO query VALUES ('SpatialResult.getSurveyPlans', 'SELECT id, label, st_asewkb(geom) AS the_geom FROM cadastre.survey_plan  WHERE ST_Intersects(geom, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getRoads', 'SELECT id, label, st_asewkb(geom) AS the_geom FROM cadastre.road WHERE ST_Intersects(geom, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getVillageNames', 'select id, label, st_asewkb(geom) AS the_geom FROM cadastre.place_name WHERE ST_Intersects(geom, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getDistrictNames', 'select id, label, st_asewkb(geom) AS the_geom FROM cadastre.district_name WHERE ST_Intersects(geom, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getIslandNames', 'select id, label, st_asewkb(geom) AS the_geom FROM cadastre.island_name WHERE ST_Intersects(geom, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getCourtGrants', 'select id, label, st_asewkb(geom) AS the_geom FROM cadastre.court_grant WHERE ST_Intersects(geom, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('SpatialResult.getApplications', 'select id, nr as label, st_asewkb(location) as the_geom from application.application where ST_Intersects(location, SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_parcel', 'SELECT co.id, co.name_firstpart || ''/'' || co.name_lastpart AS parcel_nr,      (SELECT string_agg(ba.name_firstpart || ''/'' || ba.name_lastpart, '','')      FROM administrative.ba_unit_contains_spatial_unit bas, administrative.ba_unit ba      WHERE spatial_unit_id= co.id AND bas.ba_unit_id= ba.id) AS ba_units,      ( SELECT spatial_value_area.size FROM cadastre.spatial_value_area      WHERE spatial_value_area.type_code=''officialArea'' AND spatial_value_area.spatial_unit_id = co.id) AS area_official_sqm,       st_asewkb(co.geom_polygon) AS the_geom      FROM cadastre.cadastre_object co      WHERE type_code= ''parcel'' AND status_code= ''current''      AND ST_Intersects(co.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_parcel_pending', 'SELECT co.id, co.name_firstpart || ''/'' || co.name_lastpart AS parcel_nr,       ( SELECT spatial_value_area.size FROM cadastre.spatial_value_area         WHERE spatial_value_area.type_code=''officialArea'' AND spatial_value_area.spatial_unit_id = co.id) AS area_official_sqm,   st_asewkb(co.geom_polygon) AS the_geom    FROM cadastre.cadastre_object co  WHERE type_code= ''parcel'' AND ((status_code= ''pending''    AND ST_Intersects(co.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid})))   OR (co.id IN (SELECT cadastre_object_id           FROM cadastre.cadastre_object_target co_t INNER JOIN transaction.transaction t ON co_t.transaction_id=t.id           WHERE ST_Intersects(co_t.geom_polygon, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid})) AND t.status_code NOT IN (''approved''))))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_village_name', 'SELECT id, label,  st_asewkb(geom) AS the_geom FROM cadastre.village_name WHERE ST_Intersects(geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_district_name', 'SELECT id, label,  st_asewkb(geom) AS the_geom FROM cadastre.district_name WHERE ST_Intersects(geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_island_name', 'SELECT id, label,  st_asewkb(geom) AS the_geom FROM cadastre.island_name WHERE ST_Intersects(geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_court_grant', 'SELECT id, label,  st_asewkb(geom) AS the_geom FROM cadastre.court_grant WHERE ST_Intersects(geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_road', 'select id, label,  st_asewkb(geom) as the_geom from cadastre.road where ST_Intersects(geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_application', 'SELECT id, nr,  st_asewkb(location) AS the_geom FROM application.application WHERE ST_Intersects(location, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query VALUES ('dynamic.informationtool.get_survey_plan', 'SELECT id, label,  st_asewkb(geom) AS the_geom FROM cadastre.survey_plan WHERE ST_Intersects(geom, ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);


-- Completed on 2012-04-09 09:14:15

--
-- PostgreSQL database dump complete
--


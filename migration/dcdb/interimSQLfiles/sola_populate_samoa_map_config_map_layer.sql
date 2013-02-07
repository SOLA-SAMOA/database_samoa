--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.0.1
-- Started on 2012-04-09 10:10:13

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = system, pg_catalog;

--
-- TOC entry 3657 (class 0 OID 206363)
-- Dependencies: 3325
-- Data for Name: config_map_layer; Type: TABLE DATA; Schema: system; Owner: postgres
--

INSERT INTO config_map_layer VALUES ('parcels', 'Parcels::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getParcels', 'theGeom:Polygon,label:""', 'dynamic.informationtool.get_parcel', NULL, 'parcel.xml', true, 1);
INSERT INTO config_map_layer VALUES ('pending-parcels', 'Pending parcels::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getParcelsPending', 'theGeom:Polygon,label:""', 'dynamic.informationtool.get_parcel_pending', NULL, 'pending_parcels.xml', true, 2);
INSERT INTO config_map_layer VALUES ('roads', 'Roads::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getRoads', 'theGeom:MultiPolygon,label:""', 'dynamic.informationtool.get_road', NULL, 'road.xml', true, 3);
INSERT INTO config_map_layer VALUES ('survey-controls', 'Survey controls::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getSurveyControls', 'theGeom:Point,label:""', 'dynamic.informationtool.get_survey_control', NULL, 'survey_control.xml', true, 4);
INSERT INTO config_map_layer VALUES ('place-names', 'Places names::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getPlaceNames', 'theGeom:Point,label:""', 'dynamic.informationtool.get_place_name', NULL, 'place_name.xml', true, 5);
INSERT INTO config_map_layer VALUES ('applications', 'Applications::::ITALIANO', 'pojo', NULL, NULL, 'SpatialResult.getApplications', 'theGeom:MultiPoint,label:""', 'dynamic.informationtool.get_application', NULL, 'application.xml', true, 6);


-- Completed on 2012-04-09 10:10:13

--
-- PostgreSQL database dump complete
--


--TO POPULATE THE SOLA DATABASE WITH SAMOA VIEW DATA (FROM SQL SERVER (WITH MAPINFO SPATIALWARE) DCDB DATABASE TABLES)
--INTO LADM RELATED TABLES
--Revised 29 March 2012 - Neil Pullar
--Revised 16 September 2012 - Neil Pullar (addition of RoadPolygon, remove references to RoadCentrelineSegment2)

DROP SCHEMA IF EXISTS test_etl CASCADE;
CREATE SCHEMA test_etl;
  
CREATE OR REPLACE FUNCTION test_etl.load_parcel() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    the_id varchar;
    first_part varchar;
    last_part varchar;
    transaction_id_vl varchar;
    the_count integer;

BEGIN
    transaction_id_vl = 'cadastre-transaction';
    DELETE FROM transaction.transaction WHERE id = transaction_id_vl;
    INSERT INTO transaction.transaction(id, status_code, approval_datetime, change_user) VALUES(transaction_id_vl, 'approved', now(), 'test-id');
    
-- Add srid for West Samoa Integrated Grid (based on WSG1972) for where this has been used instead of SMG (based on WSG1984)
    DELETE FROM public.spatial_ref_sys WHERE srid = 97362;
    INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 97362, 'sr-org', 7362, '+proj=tmerc +lat_0=0 +lon_0=-172 +k=1 +x_0=700000 +y_0=7000000 +ellps=WGS72 +units=m +no_defs ', 'PROJCS["WSIG",GEOGCS["GCS_WGS_1972",DATUM["D_WGS_1972",SPHEROID["WGS_1972",6378135.0,298.26]],PRIMEM["Greenwich",0.0],UNIT["Degree",2.0]],PROJECTION["Transverse_Mercator"],PARAMETER["False_Easting",700000.0],PARAMETER["False_Northing",7000000.0],PARAMETER["Central_Meridian",-1.500983156715124],PARAMETER["Scale_Factor",1.0],PARAMETER["Latitude_Of_Origin",0.0],UNIT["Meter",1.0]]');

	FOR rec IN EXECUTE 'SELECT DISTINCT(PARCELSPATIAL.sw_member), parcelnumber, plannumber, ''current'' AS parcel_status, ST_geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmpparcelbinaryexport PARCELSPATIAL
			INNER JOIN "SamoaView".dcdbparcelpolygon ON (PARCELSPATIAL.sw_member = "SamoaView".dcdbparcelpolygon.sw_member) 
			WHERE ogcbinary IS NOT NULL AND ST_IsValid(ogcbinary)'  
    
	LOOP
		RAISE NOTICE 'Processing Parcel WKB record (%)', rec.sw_member;

		the_id = (SELECT sola_id FROM "SamoaView".dcdbparcelpolygon WHERE sw_member = rec.sw_member);

		IF rec.parcelnumber IS NULL THEN
			first_part = 'QCcheck';
		ELSE
			first_part = rec.parcelnumber;
		END IF;
		first_part = SUBSTRING(first_part FROM 1 FOR 20);
				
		IF rec.plannumber IS NULL THEN 
			last_part = 'QC, ID='|| rec.sw_member;
		ELSE
			last_part = rec.plannumber;
		END IF;
		last_part = SUBSTRING(last_part FROM 1 FOR 50);

		IF geometrytype(rec.the_geom) = 'POLYGON'::text THEN
			the_count = (SELECT count(*) FROM cadastre.cadastre_object WHERE name_firstpart = first_part AND name_lastpart = last_part);
			IF (the_count > 0) THEN
				last_part = 'QC ' || last_part || ' ' || rec.sw_member;
				last_part = SUBSTRING(last_part FROM 1 FOR 50);
			END IF;

			INSERT INTO cadastre.cadastre_object (id, name_firstpart, name_lastpart, transaction_id, status_code, geom_polygon, change_action, change_user, change_time )
				VALUES (the_id, first_part, last_part, transaction_id_vl, rec.parcel_status, rec.the_geom, 'i', 'test-id', now());						
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_etl.load_surveyplan() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    the_id varchar;

BEGIN
   FOR rec IN EXECUTE 'SELECT sw_member, geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmpsurveyplanbinaryexport WHERE IsValid(ogcbinary) = true'
	LOOP
		RAISE NOTICE 'Processing Survey Plan WKB record (%)', rec.sw_member;

		IF geometrytype(rec.the_geom) = 'POINT'::text THEN
			UPDATE "SamoaView".surveyplanreferencepoint
				SET the_geom = rec.the_geom
			WHERE sw_member =  rec.sw_member; 
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_etl.load_courtgrant() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    the_id varchar;

BEGIN
   FOR rec IN EXECUTE 'SELECT sw_member, geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmpcourtgrantbinaryexport WHERE IsValid(ogcbinary) = true'
	LOOP
		RAISE NOTICE 'Processing Court Grant WKB record (%)', rec.sw_member;

		IF geometrytype(rec.the_geom) = 'POINT'::text THEN
			UPDATE "SamoaView".courtgrantreferencepoint
				SET the_geom = rec.the_geom
			WHERE sw_member =  rec.sw_member; 
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_etl.load_hydropolygon() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    the_id varchar;

BEGIN
   FOR rec IN EXECUTE 'SELECT sw_member, geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmphydrobinaryexport WHERE IsValid(ogcbinary) = true'
	LOOP
		RAISE NOTICE 'Processing Hydro Polygon WKB record (%)', rec.sw_member;

		IF geometrytype(rec.the_geom) = 'POLYGON'::text THEN
			UPDATE "SamoaView".hydropolygon
				SET the_geom = rec.the_geom
			WHERE sw_member =  rec.sw_member; 
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;
  
--Addition 16 September 2012

CREATE OR REPLACE FUNCTION test_etl.load_roadpolygon() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    the_id varchar;

BEGIN
   FOR rec IN EXECUTE 'SELECT sw_member, geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmproadbinaryexport WHERE IsValid(ogcbinary) = true'
	LOOP
		RAISE NOTICE 'Processing Road Polygon WKB record (%)', rec.sw_member;

		IF geometrytype(rec.the_geom) = 'POLYGON'::text THEN
			UPDATE "SamoaView".roadpolygon
				SET the_geom = rec.the_geom
			WHERE sw_member =  rec.sw_member; 
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION test_etl.load_roadcentreline() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    the_id varchar;

BEGIN
   FOR rec IN EXECUTE 'SELECT sw_member, geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmproadcentrelinebinaryexport WHERE IsValid(ogcbinary) = true'
--   FOR rec IN EXECUTE 'SELECT sw_member, st_transform(st_setsrid(geometryn(GeomFromWKB(ogcbinary, 97326), 1), 97362), 32702) AS the_geom FROM "SamoaView".tmproadcentrelinebinaryexport WHERE IsValid(ogcbinary) = true'
	LOOP
		RAISE NOTICE 'Processing Road Centreline WKB record (%)', rec.sw_member;

		IF geometrytype(rec.the_geom) = 'LINESTRING'::text THEN
			UPDATE "SamoaView".roadcentrelinesegment
				SET the_geom = rec.the_geom
			WHERE sw_member =  rec.sw_member; 
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_etl.load_recordsheet() RETURNS varchar
 AS
$BODY$
DECLARE 
    rec record;
    sheetRef varchar;

BEGIN
   FOR rec IN EXECUTE 'SELECT sw_member, geometryn(GeomFromWKB(ogcbinary, 32702), 1) AS the_geom FROM "SamoaView".tmprecordsheetbinaryexport WHERE IsValid(ogcbinary) = true'
	LOOP
		RAISE NOTICE 'Processing Record Sheet WKB record (%)', rec.sw_member;

		IF geometrytype(rec.the_geom) = 'POLYGON'::text THEN
			UPDATE "SamoaView".upgradedrsoutlinepolygon
				SET the_geom = rec.the_geom
			WHERE sw_member =  rec.sw_member; 
		END IF;

	END LOOP;
    RETURN 'ok';
END;
$BODY$
  LANGUAGE plpgsql;

BEGIN;
-- CLEAR DATABASE TABLES
DELETE FROM cadastre.spatial_value_area;
DELETE FROM cadastre.spatial_unit;
DELETE FROM cadastre.spatial_unit_historic;
DELETE FROM cadastre.level;
DELETE FROM cadastre.cadastre_object;
DELETE FROM cadastre.cadastre_object_historic;
DELETE FROM source.source;
DELETE FROM source.archive;
--SET NEW SRID and OTHER SAMOA PARAMETERS
UPDATE public.geometry_columns SET srid = 32702; 
UPDATE application.application set location = null;
UPDATE system.setting SET vl = '32702' WHERE "name" = 'map-srid'; 
UPDATE system.setting SET vl = '300500' WHERE "name" = 'map-west'; 
UPDATE system.setting SET vl = '8439000' WHERE "name" = 'map-south'; 
UPDATE system.setting SET vl = '461900' WHERE "name" = 'map-east'; 
UPDATE system.setting SET vl = '8518000' WHERE "name" = 'map-north'; 

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
ALTER TABLE cadastre.cadastre_object DISABLE TRIGGER trg_geommodify;

--INSERT FIELDS FOR THE SAMOA DCDB PARCELS
ALTER TABLE "SamoaView".dcdbparcelpolygon
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".dcdbparcelpolygon 
	ADD sola_id uuid;
UPDATE "SamoaView".dcdbparcelpolygon 
	SET sola_id = uuid_generate_v1();
	
--IDENTIFY QC CONCERNS IN DCDBPARCELPOLYGON DATA
UPDATE "SamoaView".dcdbparcelpolygon SET parcelnumber = 'QCcheck' WHERE parcelnumber IS NULL;
UPDATE "SamoaView".dcdbparcelpolygon SET plannumber = 'QCcheck' WHERE plannumber IS NULL;

--LOAD PARCEL RELATED DATA
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code, change_action, change_user, change_time)
                VALUES (uuid_generate_v1(), 'Parcels', 'all', 'polygon', 'primaryRight', 'i', 'test-id', now());
			
INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, level_id, change_action, change_user, change_time) 
	SELECT sola_id, '2D', parcelnumber || ' Plan ' || plannumber, 'onSurface',  
	(SELECT id FROM cadastre.level WHERE name='Parcels') As l_id, 'i' as ch_action, 'test-id' AS ch_user, now()   
	FROM "SamoaView".dcdbparcelpolygon;

UPDATE cadastre.spatial_unit SET level_id = (SELECT id FROM cadastre.level WHERE name = 'Parcels') 
			WHERE (level_id IS NULL);

SELECT test_etl.load_parcel();

INSERT INTO cadastre.spatial_value_area (spatial_unit_id, type_code, size, change_action, change_user, change_time)
	SELECT 	sola_id, 'officialArea', hectares * 10000, 'i' as ch_action, 'test-id' AS ch_user, now() FROM "SamoaView".dcdbparcelpolygon;

--LOAD ARCHIVE RELATED DATA
INSERT INTO source.archive (id, name, change_action, change_user, change_time) VALUES (uuid_generate_v1(), 'MNRE SamoaView', 'i', 'test-id', now()); 
--modified maintype and type_code 16 September
INSERT INTO source.source (id, archive_id, la_nr, submission, maintype, type_code, content, availability_status_code, change_action, change_user, change_time)
                VALUES (uuid_generate_v1(), (SELECT id FROM source.archive WHERE name = 'MNRE SamoaView'), 'SamoaView', '2011-06-29', 'mapDigital', 'recordMaps', 'MNRE SamoaView', 'available', 'i', 'test-id', now());


--INSERT VALUES FOR THE SAMOA ROAD CENTRELINE NETWORK
--modified 16 September 2012
ALTER TABLE "SamoaView".roadcentrelinesegment 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".roadcentrelinesegment
	ADD sola_id uuid;
UPDATE "SamoaView".roadcentrelinesegment
	SET sola_id = uuid_generate_v1();
ALTER TABLE "SamoaView".roadcentrelinesegment
	DROP COLUMN IF EXISTS the_geom;
ALTER TABLE "SamoaView".roadcentrelinesegment 
	ADD the_geom geometry;

SELECT test_etl.load_roadcentreline();

DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Roads'); 
DELETE FROM cadastre.level WHERE name = 'Roads';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
         VALUES (uuid_generate_v1(), 'Roads', 'all', 'unStructuredLine', 'network');
--modified to remove reference to roadcentrelinesegment2 16 September 2012
INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, geom, level_id) 
	SELECT sola_id, '2D', label, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Roads') As l_id 
	FROM "SamoaView".roadcentrelinesegment WHERE the_geom IS NOT NULL;

--INSERT VALUES FOR THE SAMOA ROAD Polygon Features
--added 16 September 2012
ALTER TABLE "SamoaView".roadpolygon 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".roadpolygon 
	ADD sola_id uuid;
UPDATE "SamoaView".roadpolygon 
	SET sola_id = uuid_generate_v1();
ALTER TABLE "SamoaView".roadpolygon
	DROP COLUMN IF EXISTS the_geom;
ALTER TABLE "SamoaView".roadpolygon 
	ADD the_geom geometry;

SELECT test_etl.load_roadpolygon();
	
DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Road Polygon Features'); 
DELETE FROM cadastre.level WHERE name = 'Road Polygon Features';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Road Polygon Features', 'all', 'polygon', 'geographicLocator');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, geom, level_id) 
	SELECT sola_id, '2D', dedicationreference, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Road Polygon Features') As l_id 
	FROM "SamoaView".roadpolygon WHERE the_geom IS NOT NULL;

--INSERT VALUES FOR THE SAMOA COURT GRANT REFERENCE POINTS
ALTER TABLE "SamoaView".courtgrantreferencepoint 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".courtgrantreferencepoint 
	ADD sola_id uuid;
UPDATE "SamoaView".courtgrantreferencepoint 
	SET sola_id = uuid_generate_v1();
ALTER TABLE "SamoaView".courtgrantreferencepoint
	DROP COLUMN IF EXISTS the_geom;
ALTER TABLE "SamoaView".courtgrantreferencepoint 
	ADD the_geom geometry;

SELECT test_etl.load_courtgrant();

DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Court Grants'); 
DELETE FROM cadastre.level WHERE name = 'Court Grants';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Court Grants', 'all', 'point', 'primaryRight');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, reference_point, level_id) 
	SELECT sola_id, '2D', parcelnumber, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Court Grants') As l_id 
	FROM "SamoaView".courtgrantreferencepoint WHERE (parcelnumber IS NOT NULL) AND (the_geom IS NOT NULL);


--INSERT VALUES FOR THE SAMOA SURVEY PLAN REFERENCE POINTS
ALTER TABLE "SamoaView".surveyplanreferencepoint 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".surveyplanreferencepoint 
	ADD sola_id uuid;
UPDATE "SamoaView".surveyplanreferencepoint 
	SET sola_id = uuid_generate_v1();
ALTER TABLE "SamoaView".surveyplanreferencepoint
	DROP COLUMN IF EXISTS the_geom;
ALTER TABLE "SamoaView".surveyplanreferencepoint 
	ADD the_geom geometry;

SELECT test_etl.load_surveyplan();

DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Survey Plans'); 
DELETE FROM cadastre.level WHERE name = 'Survey Plans';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Survey Plans', 'all', 'point', 'primaryRight');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, reference_point, level_id) 
	SELECT sola_id, '2D', plannumber, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Survey Plans') As l_id 
	FROM "SamoaView".surveyplanreferencepoint WHERE (plannumber IS NOT NULL) AND (the_geom IS NOT NULL);

--INSERT VALUES FOR THE SAMOA Hydro Features
ALTER TABLE "SamoaView".hydropolygon 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".hydropolygon 
	ADD sola_id uuid;
UPDATE "SamoaView".hydropolygon 
	SET sola_id = uuid_generate_v1();
ALTER TABLE "SamoaView".hydropolygon
	DROP COLUMN IF EXISTS the_geom;
ALTER TABLE "SamoaView".hydropolygon 
	ADD the_geom geometry;

SELECT test_etl.load_hydropolygon();
	
DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Hydro Features'); 
DELETE FROM cadastre.level WHERE name = 'Hydro Features';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Hydro Features', 'all', 'polygon', 'geographicLocator');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, geom, level_id) 
	SELECT sola_id, '2D', label, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Hydro Features') As l_id 
	FROM "SamoaView".hydropolygon WHERE the_geom IS NOT NULL;

--INSERT VALUES FOR THE SAMOA Record Sheets
ALTER TABLE "SamoaView".upgradedrsoutlinepolygon 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaView".upgradedrsoutlinepolygon 
	ADD sola_id uuid;
UPDATE "SamoaView".upgradedrsoutlinepolygon 
	SET sola_id = uuid_generate_v1();
ALTER TABLE "SamoaView".upgradedrsoutlinepolygon
	DROP COLUMN IF EXISTS the_geom;
ALTER TABLE "SamoaView".upgradedrsoutlinepolygon 
	ADD the_geom geometry;

SELECT test_etl.load_recordsheet();
	
DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Record Sheets'); 
DELETE FROM cadastre.level WHERE name = 'Record Sheets';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Record Sheets', 'all', 'polygon', 'geographicLocator');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, geom, level_id) 
	SELECT sola_id, '2D', rssheetreference, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Record Sheets') As l_id 
	FROM "SamoaView".upgradedrsoutlinepolygon WHERE the_geom IS NOT NULL;

--INSERT VALUES FOR THE SAMOA ISLANDS
ALTER TABLE "SamoaPlaceNames"."SamoaGPNGazzetterIslands" 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaPlaceNames"."SamoaGPNGazzetterIslands" 
	ADD sola_id uuid;
UPDATE "SamoaPlaceNames"."SamoaGPNGazzetterIslands" 
	SET sola_id = uuid_generate_v1();

DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Islands'); 
DELETE FROM cadastre.level WHERE name = 'Islands';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Islands', 'all', 'point', 'geographicLocator');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, reference_point, level_id) 
	SELECT sola_id, '2D', name, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Islands') As l_id 
	FROM "SamoaPlaceNames"."SamoaGPNGazzetterIslands" WHERE the_geom IS NOT NULL;

--INSERT VALUES FOR THE SAMOA LAND DISTRICTS
ALTER TABLE "SamoaPlaceNames"."SamoaGPNGazzetterLandDistricts" 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaPlaceNames"."SamoaGPNGazzetterLandDistricts" 
	ADD sola_id uuid;
UPDATE "SamoaPlaceNames"."SamoaGPNGazzetterLandDistricts" 
	SET sola_id = uuid_generate_v1();

DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Districts'); 
DELETE FROM cadastre.level WHERE name = 'Districts';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Districts', 'all', 'point', 'geographicLocator');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, reference_point, level_id) 
	SELECT sola_id, '2D', name, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Districts') As l_id 
	FROM "SamoaPlaceNames"."SamoaGPNGazzetterLandDistricts" WHERE the_geom IS NOT NULL;

--INSERT VALUES FOR THE SAMOA VILLAGES
ALTER TABLE "SamoaPlaceNames"."SamoaVillageNamesPoint_SMG" 
	DROP COLUMN IF EXISTS sola_id;
ALTER TABLE "SamoaPlaceNames"."SamoaVillageNamesPoint_SMG" 
	ADD sola_id uuid;
UPDATE "SamoaPlaceNames"."SamoaVillageNamesPoint_SMG" 
	SET sola_id = uuid_generate_v1();

DELETE FROM cadastre.spatial_unit WHERE level_id IS NULL; 
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id FROM cadastre.level WHERE name='Villages'); 
DELETE FROM cadastre.level WHERE name = 'Villages';
INSERT INTO cadastre.level (id, name, register_type_code, structure_code, type_code)
                VALUES (uuid_generate_v1(), 'Villages', 'all', 'point', 'geographicLocator');

INSERT INTO cadastre.spatial_unit (id, dimension_code, label, surface_relation_code, reference_point, level_id) 
	SELECT sola_id, '2D', viname, 'onSurface', the_geom, (SELECT id FROM cadastre.level WHERE name='Villages') As l_id 
	FROM "SamoaPlaceNames"."SamoaVillageNamesPoint_SMG" WHERE the_geom IS NOT NULL;
--Reset Trigger
ALTER TABLE cadastre.cadastre_object ENABLE TRIGGER trg_geommodify;

COMMIT;

DROP SCHEMA IF EXISTS test_etl CASCADE;


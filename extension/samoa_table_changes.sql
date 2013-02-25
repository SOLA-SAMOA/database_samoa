-- Add fields to store number of new lots created by survey, and plan costs (Hilton: 17-May-2012)
ALTER TABLE application.application
ADD new_lots integer NOT NULL DEFAULT 0;

-- Load Firms (Hilton: 16-May-2012) 
ALTER TABLE application.application 
	ALTER COLUMN agent_id SET NOT NULL,
	ALTER COLUMN contact_person_id DROP NOT NULL;

-- Add the new column to the application_historic table. Make sure it is before the
-- change_time_valid_until column as the trigger inserts based on column position. 
ALTER TABLE application.application_historic
DROP change_time_valid_until; 

ALTER TABLE application.application_historic
ADD new_lots integer NOT NULL DEFAULT 0, 
ADD change_time_valid_until timestamp without time zone NOT NULL DEFAULT now();

-- Create a new table to act as a staging table for changes to Road Centerlines and Hydro parcels. (Andrew: 20-Jun-2012)
DROP TABLE IF EXISTS cadastre.spatial_unit_change;
CREATE TABLE cadastre.spatial_unit_change
(
  id character varying(40) NOT NULL, 
  transaction_id character varying(40) NOT NULL,
  spatial_unit_id character varying(40),
  label character varying(255),
  level_id character varying(40),
  delete_on_approval boolean NOT NULL DEFAULT false,
  geom geometry,
  rowidentifier character varying(40) NOT NULL DEFAULT uuid_generate_v1(),
  rowversion integer NOT NULL DEFAULT 0,
  change_action character(1) NOT NULL DEFAULT 'i'::bpchar,
  change_user character varying(50),
  change_time timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT spatial_unit_change_pkey PRIMARY KEY (id),
  CONSTRAINT spatial_unit_change_spatial_unit_id_fk FOREIGN KEY (spatial_unit_id)
      REFERENCES cadastre.spatial_unit (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT spatial_unit_change_transaction_id_fk FOREIGN KEY (transaction_id)
      REFERENCES transaction.transaction (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702),
  CONSTRAINT enforce_valid_geom CHECK (st_isvalid(geom))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE cadastre.spatial_unit_change
  OWNER TO postgres;
COMMENT ON TABLE cadastre.spatial_unit_change
  IS 'Used to capture pending changes to spatial unit records (e.g. Roads and Hydro) that are to be applied when the associated transaction is approved.
  Spatial Unit does not include a status field, so new records are captured with no spatial_unit_id reference';

-- Index: cadastre.index_spatial_unit_change_spatial_unit_id_fk

-- DROP INDEX cadastre.index_spatial_unit_change_spatial_unit_id_fk;

CREATE INDEX index_spatial_unit_change_spatial_unit_id_fk
  ON cadastre.spatial_unit_change
  USING btree
  (spatial_unit_id COLLATE pg_catalog."default" );

-- Index: cadastre.index_spatial_unit_change_geom

-- DROP INDEX cadastre.index_spatial_unit_change_geom;

CREATE INDEX index_spatial_unit_change_geom
  ON cadastre.spatial_unit_change
  USING gist
  (geom );

-- Index: cadastre.spatial_unit_change_index_on_rowidentifier

-- DROP INDEX cadastre.spatial_unit_change_index_on_rowidentifier;

CREATE INDEX spatial_unit_change_index_on_rowidentifier
  ON cadastre.spatial_unit_change
  USING btree
  (rowidentifier COLLATE pg_catalog."default" );

-- Index: cadastre.spatial_unit_change_transaction_id_fk105_ind

-- DROP INDEX cadastre.spatial_unit_change_transaction_id_fk105_ind;

CREATE INDEX spatial_unit_change_transaction_id_fk105_ind
  ON cadastre.spatial_unit_change
  USING btree
  (transaction_id COLLATE pg_catalog."default" );


-- Trigger: __track_changes on cadastre.spatial_unit_change

-- DROP TRIGGER __track_changes ON cadastre.spatial_unit_change;

CREATE TRIGGER __track_changes
  BEFORE INSERT OR UPDATE
  ON cadastre.spatial_unit_change
  FOR EACH ROW
  EXECUTE PROCEDURE f_for_trg_track_changes();

-- Trigger: __track_history on cadastre.spatial_unit_change

-- DROP TRIGGER __track_history ON cadastre.spatial_unit_change;

CREATE TRIGGER __track_history
  AFTER UPDATE OR DELETE
  ON cadastre.spatial_unit_change
  FOR EACH ROW
  EXECUTE PROCEDURE f_for_trg_track_history();
  
-- Table: cadastre.spatial_unit_change_historic

DROP TABLE IF EXISTS cadastre.spatial_unit_change_historic;
CREATE TABLE cadastre.spatial_unit_change_historic
(
  id character varying(40), 
  transaction_id character varying(40),
  spatial_unit_id character varying(40),
  label character varying(255),
  level_id character varying(40),
  delete_on_approval boolean,
  geom geometry,
  rowidentifier character varying(40),
  rowversion integer,
  change_action character(1),
  change_user character varying(50),
  change_time timestamp without time zone,
  change_time_valid_until timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702),
  CONSTRAINT enforce_valid_geom CHECK (st_isvalid(geom))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE cadastre.spatial_unit_change_historic
  OWNER TO postgres;

-- Index: cadastre.spatial_unit_change_historic_index_on_geom

-- DROP INDEX cadastre.spatial_unit_change_historic_index_on_geom;

CREATE INDEX spatial_unit_change_historic_index_on_geom
  ON cadastre.spatial_unit_change_historic
  USING gist
  (geom );
  
-- Index: cadastre.spatial_unit_change_historic_index_on_rowidentifier

-- DROP INDEX cadastre.spatial_unit_change_historic_index_on_rowidentifier;

CREATE INDEX spatial_unit_change_historic_index_on_rowidentifier
  ON cadastre.spatial_unit_change_historic
  USING btree
  (rowidentifier COLLATE pg_catalog."default" );

-- Add the new tables into geometry_columns  
DELETE FROM public.geometry_columns WHERE f_table_name = 'spatial_unit_change'; 
DELETE FROM public.geometry_columns WHERE f_table_name = 'spatial_unit_change_historic'; 
INSERT INTO public.geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'spatial_unit_change', 'geom', 2, 32702, 'GEOMETRY');
INSERT INTO public.geometry_columns (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) VALUES ('', 'cadastre', 'spatial_unit_change_historic', 'geom', 2, 32702, 'GEOMETRY');

-- Function to retrieve the Village from the title ba unit ID (Hilton: 31-Aug-2012)
CREATE OR REPLACE FUNCTION administrative.getVillageId(baUnitId varchar)
  RETURNS varchar AS $BODY$
  DECLARE
	villageId VARCHAR := NULL; 
  BEGIN
  
    WHILE villageId IS NULL LOOP
		EXIT WHEN baUnitId IS NULL;  
		
		SELECT  from_ba_unit_id
		INTO    villageId
		FROM 	administrative.required_relationship_baunit
		WHERE	to_ba_unit_id = baUnitId
		AND		relation_code = 'title_Village';
		
		IF villageId IS NULL THEN
			baUnitId := administrative.getPriorTitleId(baUnitId);
		END IF;
	END LOOP; 	

	RETURN villageId;
			
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION administrative.getVillageId(varchar) 
  IS 'Retrieves the Village Id for the ba unit';
  
  CREATE OR REPLACE FUNCTION administrative.getVillage(baUnitId varchar)
  RETURNS varchar AS $BODY$
  BEGIN
  
    IF baUnitId IS NULL THEN
	 RETURN NULL; 
	END IF; 
	
	RETURN (SELECT  name_firstpart
			FROM 	administrative.ba_unit
			WHERE	id = administrative.getVillageId(baUnitId)); 
			
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION administrative.getVillage(varchar) 
  IS 'Retrieves the Village name for the given ba unit';
  
  CREATE OR REPLACE FUNCTION administrative.getDistrictId(baUnitId varchar)
  RETURNS varchar AS $BODY$
  BEGIN
  
    IF baUnitId IS NULL THEN
	 RETURN NULL; 
	END IF; 
	
	RETURN (SELECT  from_ba_unit_id
			FROM 	administrative.required_relationship_baunit
			WHERE	to_ba_unit_id = administrative.getVillageId(baUnitId)
			AND		relation_code = 'district_Village'); 
			
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION administrative.getDistrictId(varchar) 
  IS 'Retrieves the District Id for the ba unit';

CREATE OR REPLACE FUNCTION administrative.getDistrict(baUnitId varchar)
  RETURNS varchar AS $BODY$
  DECLARE
	districtId VARCHAR; 
  BEGIN
  
    IF baUnitId IS NULL THEN
	 RETURN NULL; 
    END IF; 

    districtId := administrative.getDistrictId(baUnitId); 

    IF districtId IS NULL THEN
		RETURN NULL;
    END IF; 
	
    RETURN (SELECT  name_firstpart
			FROM 	administrative.ba_unit
			WHERE	id = districtId);  
			
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION administrative.getDistrict(varchar) 
  IS 'Retrieves the District name for the ba unit';

  -- Function to retrieve the Prior Title from the ba_unit Id Hilton: 13-Sep-2012)
CREATE OR REPLACE FUNCTION administrative.getPriorTitleId(baUnitId varchar)
  RETURNS varchar AS $BODY$
  BEGIN
  
	IF baUnitId IS NULL THEN
		RETURN NULL; 
	END IF; 
	
	RETURN (SELECT  from_ba_unit_id
			FROM 	administrative.required_relationship_baunit
			WHERE	to_ba_unit_id = baUnitId
			AND		relation_code = 'priorTitle'
			LIMIT 1); 
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION administrative.getPriorTitleId(varchar) 
  IS 'Retrieves the Prior Title Id for the ba unit';
  
  CREATE OR REPLACE FUNCTION administrative.getPriorTitle(baUnitId varchar)
  RETURNS varchar AS $BODY$
  BEGIN
  
	IF baUnitId IS NULL THEN
		RETURN NULL; 
	END IF; 
	
	RETURN (SELECT  name_firstpart ||  '/' || name_lastpart
			FROM 	administrative.ba_unit
			WHERE	id = administrative.getPriorTitleId(baUnitId)); 
			
  END; $BODY$
  LANGUAGE plpgsql VOLATILE;
  COMMENT ON FUNCTION administrative.getPriorTitle(varchar) 
  IS 'Retrieves the Prior Title reference for the ba unit id';
 
  
-- Replace the application.get_concatenated_name function as this does not work properly. It lists the
-- application properties but should list the properites the service is associated with instead. 
  -- Function: application.get_concatenated_name(character varying)

-- DROP FUNCTION application.get_concatenated_name(character varying);

CREATE OR REPLACE FUNCTION application.get_concatenated_name(service_id character varying)
  RETURNS character varying AS
$BODY$
declare
  rec record;
  category varchar; 
  name character varying; 
  plan varchar; 
  
BEGIN
	name = '';
	
	IF service_id IS NULL THEN
	 RETURN NULL; 
	END IF;
      
    SELECT  rt.request_category_code
	INTO    category
	FROM 	application.service ser,
			application.request_type rt
	WHERE	ser.id = service_id
	AND		rt.code = ser.request_type_code; 
	
	IF (category = 'cadastralServices') THEN
		FOR rec IN 
			SELECT co.name_firstpart as parcel_num,
				   co.name_lastpart  as plan
			FROM   transaction.transaction t,
				   cadastre.cadastre_object co
			WHERE  t.from_service_id = service_id
			AND	   co.transaction_id = t.id
			ORDER BY co.name_firstpart, co.name_lastpart
		
		LOOP
			name = name || ', ' || rec.parcel_num;
			IF plan IS NULL THEN plan = rec.plan; END IF; 
			IF plan != rec.plan THEN
				name = name || ' PLAN ' || plan; 
				plan = rec.plan; 
			END IF; 
		END LOOP;
		
		IF name != '' THEN  
			name = name || ' PLAN ' || plan;
		END IF;		
		
	ELSE
	    -- Registration Services	
		FOR rec IN 
			SELECT bu.name_firstpart || '/' || bu.name_lastpart  as prop
			FROM   transaction.transaction t,
				  administrative.ba_unit bu
			WHERE  t.from_service_id = service_id
			AND	  bu.transaction_id = t.id
			UNION
			SELECT bu.name_firstpart || '/' || bu.name_lastpart  as prop
			FROM   transaction.transaction t,
				  administrative.ba_unit bu,
				  administrative.rrr r
			WHERE  t.from_service_id = service_id
			AND	  r.transaction_id = t.id
			AND    bu.id = r.ba_unit_id
			UNION
			SELECT bu.name_firstpart || '/' || bu.name_lastpart  as prop
			FROM   transaction.transaction t,
				  administrative.ba_unit bu,
				  administrative.notation n
			WHERE  t.from_service_id = service_id
			AND	  n.transaction_id = t.id
			AND    n.rrr_id IS NULL
			AND    bu.id = n.ba_unit_id
			UNION
			SELECT bu.name_firstpart || '/' || bu.name_lastpart  as prop
			FROM   transaction.transaction t,
				  administrative.ba_unit bu,
				  administrative.ba_unit_target tar
			WHERE  t.from_service_id = service_id
			AND	  tar.transaction_id = t.id
			AND    bu.id = tar.ba_unit_id

		LOOP
		   name = name || ', ' || rec.prop;
		END LOOP;
	END IF;

    if name = '' then
	  return name;
	end if;

	if substr(name, 1, 1) = ',' then
          name = substr(name,2);
    end if;
return name;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION application.get_concatenated_name(character varying)
  OWNER TO postgres;
COMMENT ON FUNCTION application.get_concatenated_name(character varying) IS 'Returns the list properties that have been changed due to the service.';


-- Table changes to support Unit Titles

-- Add field to flag when a unit is removed from the group of unit parcels.
ALTER TABLE cadastre.spatial_unit_in_group
ADD delete_on_approval BOOLEAN NOT NULL DEFAULT FALSE, 
ADD unit_parcel_status_code VARCHAR(20) NOT NULL DEFAULT 'pending', 
ADD CONSTRAINT spatial_unit_in_group_status_code_fk FOREIGN KEY (unit_parcel_status_code)
      REFERENCES transaction.reg_status_type (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;   

-- Add the new column to the spatial_unit_in_group_historic table.  
ALTER TABLE cadastre.spatial_unit_in_group_historic
ADD delete_on_approval BOOLEAN NOT NULL DEFAULT FALSE,
ADD unit_parcel_status_code VARCHAR(20);  

ALTER TABLE transaction.transaction
ADD  spatial_unit_group_id VARCHAR(40),  
ADD CONSTRAINT transaction_spatial_unit_group_id_fk6 FOREIGN KEY (spatial_unit_group_id)
      REFERENCES cadastre.spatial_unit_group (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE transaction.transaction_historic
ADD spatial_unit_group_id VARCHAR(40); 

ALTER TABLE cadastre.spatial_unit_group DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.spatial_unit_group ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);
ALTER TABLE cadastre.spatial_unit_group_historic DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE cadastre.spatial_unit_group_historic ADD CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 32702);

ALTER TABLE cadastre.spatial_unit_group DROP CONSTRAINT IF EXISTS enforce_srid_reference_point;
ALTER TABLE cadastre.spatial_unit_group ADD CONSTRAINT enforce_srid_reference_point CHECK (st_srid(reference_point) = 32702);
ALTER TABLE cadastre.spatial_unit_group_historic DROP CONSTRAINT IF EXISTS enforce_srid_reference_point;
ALTER TABLE cadastre.spatial_unit_group_historic ADD CONSTRAINT enforce_srid_reference_point CHECK (st_srid(reference_point) = 32702);

-- changeset08a.sql Add a unique index over ba_unit_name to prevent duplicately named BA Units. 
CREATE UNIQUE INDEX ba_unit_name_unique_ind
   ON administrative.ba_unit (name_firstpart ASC NULLS LAST, name_lastpart ASC NULLS LAST);

   
-- Lodgement Report Functions
-- Update to Lodgement Statistics Report Function 
-- *** To be run on sola_prod and the sola_training database
CREATE OR REPLACE FUNCTION application.get_work_summary(from_date DATE, to_date DATE)
  RETURNS TABLE (
      req_type VARCHAR(100), -- The service request type
      req_cat VARCHAR(100), -- The service request category type
      group_idx INT, -- Used for grouping/sorting the services by request category
      in_progress_from INT, -- Count of the services in progress as at the from_date
      on_requisition_from INT, -- Count of the services on requisition as at the from_date
      lodged INT, -- Count of the services lodged during the reporting period
      requisitioned INT, -- Count of the services requisitioned during the reporting period
      registered INT, -- Count of the services registered during the reporting period
      cancelled INT, -- Count of the services cancelled + the services associated to applications that have been rejected or lapsed
      withdrawn INT, -- Count of the serices associated to an application that was withdrawn 
      in_progress_to INT, -- Count of the services in progress as at the to_date
      on_requisition_to INT, -- Count of the services on requisition as at the to_date
      overdue INT, -- Count of the services exceeding their expected_completion_date at end of the reporting period
      overdue_apps TEXT, -- The list of applications that are overdue
      requisition_apps TEXT -- The list of applications on Requisition
) AS
$BODY$
DECLARE 
   tmp_date DATE; 
BEGIN

   IF to_date IS NULL OR from_date IS NULL THEN
      RETURN;
   END IF; 

   -- Swap the dates so the to date is after the from date
   IF to_date < from_date THEN 
      tmp_date := from_date; 
      from_date := to_date; 
      to_date := tmp_date; 
   END IF; 
   
   -- Go through to the start of the next day. 
   to_date := to_date + 1; 

   RETURN query 
   
      -- Identifies all services lodged during the reporting period. Uses the
	  -- change_time instead of lodging_datetime to ensure all datetime comparisons 
	  -- across all subqueries yield consistent results 
      WITH service_lodged AS
	   ( SELECT ser.id, ser.application_id, ser.request_type_code
         FROM   application.service ser
         WHERE  ser.change_time BETWEEN from_date AND to_date
		 AND    ser.rowversion = 1
		 UNION
         SELECT ser_hist.id, ser_hist.application_id, ser_hist.request_type_code
         FROM   application.service_historic ser_hist
         WHERE  ser_hist.change_time BETWEEN from_date AND to_date
		 AND    ser_hist.rowversion = 1),
		 
      -- Identifies all services cancelled during the reporting period. Once cancelled
	  -- a service cannot be reinstated, so only need to check the application.service table. 	  
	  service_cancelled AS 
        (SELECT ser.id, ser.application_id, ser.request_type_code
         FROM   application.service ser
         WHERE  ser.change_time BETWEEN from_date AND to_date
		 AND    ser.status_code = 'cancelled'
     -- Verify that the service actually changed status during the reporting period
	 -- rather than just being updated. 
         AND  NOT EXISTS (SELECT ser_hist.status_code 
                          FROM application.service_historic ser_hist
                          WHERE ser_hist.id = ser.id
                          AND  (ser.rowversion - 1) = ser_hist.rowversion
                          AND  ser.status_code = ser_hist.status_code )),
		
      -- All services in progress at the end of the reporting period		
      service_in_progress AS (  
         SELECT ser.id, ser.application_id, ser.request_type_code, ser.expected_completion_date
	 FROM application.service ser
	 WHERE ser.change_time <= to_date
	 AND ser.status_code IN ('pending', 'lodged')
      UNION
	 SELECT ser_hist.id, ser_hist.application_id, ser_hist.request_type_code, 
	        ser_hist.expected_completion_date
	 FROM  application.service_historic ser_hist,
	       application.service ser
	 WHERE ser_hist.change_time <= to_date
	 AND   ser.id = ser_hist.id
	 -- Filter out any services that have not been changed since the to_date as these
	 -- would have been picked up in the first select if they were still active
	 AND   ser.change_time > to_date
	 AND   ser_hist.status_code IN ('pending', 'lodged')
	 AND   ser_hist.rowversion = (SELECT MAX(ser_hist2.rowversion)
				      FROM  application.service_historic ser_hist2
				      WHERE ser_hist.id = ser_hist2.id
				      AND   ser_hist2.change_time <= to_date )),
	
    -- All services in progress at the start of the reporting period	
	service_in_progress_from AS ( 
     SELECT ser.id, ser.application_id, ser.request_type_code, ser.expected_completion_date
	 FROM application.service ser
	 WHERE ser.change_time <= from_date
	 AND ser.status_code IN ('pending', 'lodged')
     UNION
	 SELECT ser_hist.id, ser_hist.application_id, ser_hist.request_type_code, 
	        ser_hist.expected_completion_date
	 FROM  application.service_historic ser_hist,
	       application.service ser
	 WHERE ser_hist.change_time <= from_date
	 AND   ser.id = ser_hist.id
	 -- Filter out any services that have not been changed since the from_date as these
	 -- would have been picked up in the first select if they were still active
	 AND   ser.change_time > from_date
	 AND   ser_hist.status_code IN ('pending', 'lodged')
	 AND   ser_hist.rowversion = (SELECT MAX(ser_hist2.rowversion)
				      FROM  application.service_historic ser_hist2
				      WHERE ser_hist.id = ser_hist2.id
				      AND   ser_hist2.change_time <= from_date )),
				      
    app_changed AS ( -- All applications that changed status during the reporting period
	                 -- If the application changed status more than once, it will be listed
					 -- multiple times
         SELECT app.id, 
	 -- Flag if the application was withdrawn
	 app.status_code,
	 CASE app.action_code WHEN 'withdrawn' THEN TRUE ELSE FALSE END AS withdrawn
	 FROM   application.application app
	 WHERE  app.change_time BETWEEN from_date AND to_date
	 -- Verify that the application actually changed status during the reporting period
	 -- rather than just being updated
	 AND  NOT EXISTS (SELECT app_hist.status_code 
			  FROM application.application_historic app_hist
			  WHERE app_hist.id = app.id
			  AND  (app.rowversion - 1) = app_hist.rowversion
			  AND  app.status_code = app_hist.status_code )
      UNION  
	 SELECT app_hist.id, 
	 app_hist.status_code,
	 CASE app_hist.action_code WHEN 'withdrawn' THEN TRUE ELSE FALSE END AS withdrawn
	 FROM  application.application_historic app_hist
	 WHERE app_hist.change_time BETWEEN from_date AND to_date
	 -- Verify that the application actually changed status during the reporting period
	 -- rather than just being updated
	 AND  NOT EXISTS (SELECT app_hist2.status_code 
			  FROM application.application_historic app_hist2
			  WHERE app_hist.id = app_hist2.id
			  AND  (app_hist.rowversion - 1) = app_hist2.rowversion
			  AND  app_hist.status_code = app_hist2.status_code )), 
                          
     app_in_progress AS ( -- All applications in progress at the end of the reporting period
	 SELECT app.id, app.status_code, app.expected_completion_date, app.nr
	 FROM application.application app
	 WHERE app.change_time <= to_date
	 AND app.status_code IN ('lodged', 'requisitioned')
	 UNION
	 SELECT app_hist.id, app_hist.status_code, app_hist.expected_completion_date, app_hist.nr
	 FROM  application.application_historic app_hist, 
	       application.application app
	 WHERE app_hist.change_time <= to_date
	 AND   app.id = app_hist.id
	 -- Filter out any applications that have not been changed since the to_date as these
	 -- would have been picked up in the first select if they were still active
	 AND   app.change_time > to_date
	 AND   app_hist.status_code IN ('lodged', 'requisitioned')
	 AND   app_hist.rowversion = (SELECT MAX(app_hist2.rowversion)
				      FROM  application.application_historic app_hist2
				      WHERE app_hist.id = app_hist2.id
				      AND   app_hist2.change_time <= to_date)),
					  
	app_in_progress_from AS ( -- All applications in progress at the start of the reporting period
	 SELECT app.id, app.status_code, app.expected_completion_date, app.nr
	 FROM application.application app
	 WHERE app.change_time <= from_date
	 AND app.status_code IN ('lodged', 'requisitioned')
	 UNION
	 SELECT app_hist.id, app_hist.status_code, app_hist.expected_completion_date, app_hist.nr
	 FROM  application.application_historic app_hist,
	       application.application app
	 WHERE app_hist.change_time <= from_date
	 AND   app.id = app_hist.id
	-- Filter out any applications that have not been changed since the from_date as these
	-- would have been picked up in the first select if they were still active
	 AND   app.change_time > from_date
	 AND   app_hist.status_code IN ('lodged', 'requisitioned')
	 AND   app_hist.rowversion = (SELECT MAX(app_hist2.rowversion)
				      FROM  application.application_historic app_hist2
				      WHERE app_hist.id = app_hist2.id
				      AND   app_hist2.change_time <= from_date))
   -- MAIN QUERY                         
   SELECT get_translation(req.display_value, null) AS req_type,
	  CASE req.request_category_code 
	     WHEN 'registrationServices' THEN get_translation(cat.display_value, null)
	     WHEN 'cadastralServices' THEN get_translation(cat.display_value, null)
	     ELSE 'Other Services'  END AS req_cat,
	     
	  CASE req.request_category_code 
	     WHEN 'registrationServices' THEN 1
             WHEN 'cadastralServices' THEN 2
	     ELSE 3 END AS group_idx,
		 
	  -- Count of the pending and lodged services associated with
	  -- lodged applications at the start of the reporting period
         (SELECT COUNT(s.id) FROM service_in_progress_from s, app_in_progress_from a
          WHERE s.application_id = a.id
          AND   a.status_code = 'lodged'
	  AND request_type_code = req.code)::INT AS in_progress_from,

	  -- Count of the services associated with requisitioned 
	  -- applications at the end of the reporting period
         (SELECT COUNT(s.id) FROM service_in_progress_from s, app_in_progress_from a
	  WHERE s.application_id = a.id
          AND   a.status_code = 'requisitioned'
	  AND s.request_type_code = req.code)::INT AS on_requisition_from,
	     
	  -- Count the services lodged during the reporting period.
	 (SELECT COUNT(s.id) FROM service_lodged s
	  WHERE s.request_type_code = req.code)::INT AS lodged,
	  
      -- Count the applications that were requisitioned during the
	  -- reporting period. All of the services on the application
 	  -- are requisitioned unless they are cancelled. Use the
	  -- current set of services on the application, but ensure
	  -- the services where lodged before the end of the reporting
	  -- period and that they were not cancelled during the 
	  -- reporting period. 
	 (SELECT COUNT(s.id) FROM app_changed a, application.service s
          WHERE s.application_id = a.id
	  AND   a.status_code = 'requisitioned'
	  AND   s.lodging_datetime < to_date
	  AND   NOT EXISTS (SELECT can.id FROM service_cancelled can
                        WHERE s.id = can.id)	  
          AND   s.request_type_code = req.code)::INT AS requisitioned, 
          
	  -- Count the services on applications approved/completed 
	  -- during the reporting period. Note that services cannot be
	  -- changed after the application is approved, so checking the
	  -- current state of the services is valid. 
         (SELECT COUNT(s.id) FROM app_changed a, application.service s
	  WHERE s.application_id = a.id
	  AND   a.status_code = 'approved'
	  AND   s.status_code = 'completed'
	  AND   s.request_type_code = req.code)::INT AS registered,
	  
	  -- Count of the services associated with applications 
	  -- that have been lapsed or rejected + the count of 
	  -- services cancelled during the reporting period. Note that
      -- once annulled changes to the services are not possible so
      -- checking the current state of the services is valid.
      (SELECT COUNT(tmp.id) FROM  	  
        (SELECT s.id FROM app_changed a, application.service s
		  WHERE s.application_id = a.id
		  AND   a.status_code = 'annulled'
		  AND   a.withdrawn = FALSE
		  AND   s.request_type_code = req.code
          UNION		  
		  SELECT s.id FROM app_changed a, service_cancelled s
		  WHERE s.application_id = a.id
		  AND   a.status_code != 'annulled'
		  AND   s.request_type_code = req.code) AS tmp)::INT AS cancelled, 
	  
	  -- Count of the services associated with applications
	  -- that have been withdrawn during the reporting period
	  -- Note that once annulled changes to the services are
      -- not possible so checking the current state of the services is valid. 
         (SELECT COUNT(s.id) FROM app_changed a, application.service s
	  WHERE s.application_id = a.id
	  AND   a.status_code = 'annulled'
	  AND   a.withdrawn = TRUE
	  AND   s.status_code != 'cancelled'
	  AND   s.request_type_code = req.code)::INT AS withdrawn,

	  -- Count of the pending and lodged services associated with
	  -- lodged applications at the end of the reporting period
         (SELECT COUNT(s.id) FROM service_in_progress s, app_in_progress a
          WHERE s.application_id = a.id
          AND   a.status_code = 'lodged'
	  AND request_type_code = req.code)::INT AS in_progress_to,

	  -- Count of the services associated with requisitioned 
	  -- applications at the end of the reporting period
         (SELECT COUNT(s.id) FROM service_in_progress s, app_in_progress a
	  WHERE s.application_id = a.id
          AND   a.status_code = 'requisitioned'
	  AND s.request_type_code = req.code)::INT AS on_requisition_to,

	  -- Count of the services that have exceeded thier expected
	  -- completion date and are overdue. Only counts the service 
	  -- as overdue if both the application and the service are overdue. 
         (SELECT COUNT(s.id) FROM service_in_progress s, app_in_progress a
          WHERE s.application_id = a.id
          AND   a.status_code = 'lodged'              
	  AND   a.expected_completion_date < to_date
	  AND   s.expected_completion_date < to_date
	  AND   s.request_type_code = req.code)::INT AS overdue,  

	  -- The list of overdue applications 
	 (SELECT string_agg(a.nr, ', ') FROM app_in_progress a
          WHERE a.status_code = 'lodged' 
          AND   a.expected_completion_date < to_date
          AND   EXISTS (SELECT s.application_id FROM service_in_progress s
                        WHERE s.application_id = a.id
                        AND   s.expected_completion_date < to_date
                        AND   s.request_type_code = req.code)) AS overdue_apps,   

	  -- The list of applications on Requisition
	 (SELECT string_agg(a.nr, ', ') FROM app_in_progress a
          WHERE a.status_code = 'requisitioned' 
          AND   EXISTS (SELECT s.application_id FROM service_in_progress s
                        WHERE s.application_id = a.id
                        AND   s.request_type_code = req.code)) AS requisition_apps 						
   FROM  application.request_type req, 
	 application.request_category_type cat
   WHERE req.status = 'c'
   AND   cat.code = req.request_category_code					 
   ORDER BY group_idx, req_type;
	
   END; $BODY$
   LANGUAGE plpgsql VOLATILE;


COMMENT ON FUNCTION application.get_work_summary(DATE,DATE)
IS 'Returns a summary of the services processed for a specified reporting period';


-- Changeset12 - allow \s to be used to specifically indicate a space character
CREATE OR REPLACE FUNCTION compare_strings(string1 character varying, string2 character varying)
  RETURNS boolean AS
$BODY$
  DECLARE
    rec record;
    result boolean;
  BEGIN
      result = false;
      for rec in select regexp_split_to_table(lower(string1),'[^a-z0-9\\s]') as word loop
          if rec.word != '' then 
            if not string2 ~* rec.word then
                return false;
            end if;
            result = true;
          end if;
      end loop;
      return result;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION compare_strings(character varying, character varying)
  OWNER TO postgres;
COMMENT ON FUNCTION compare_strings(character varying, character varying) IS 'Special string compare function.';



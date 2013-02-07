24 Apr 2012
The Samoan Test Data is based on plain format backups from a SOLA database populated
via migration from LRS, DCDB and the image migration. 

To refresh or replace the test data:
1) Prepare a SOLA database with the appropriate test data. You may need to delete
   some data from the database to ensure the backup files are not overly large. 
   e.g. it may be necessary to remove documents that are larger than 300Kb
   - DELETE FROM document.document WHERE (length(body)/1024) > 300   
2) Using pgAdmin, right click the schema to backup and choose the Backup.. option
3) On the File Options tab, set the Filename to the <schema>.sql and the Format to 
   Plain (i.e. SQL Script format)
4) On the Dump Options #1 tab, check the Only data option for the Type of Objects
5) On the same tab, check the Use Column Inserts and Use Insert commands options
6) On the Dump Options #2 tab, check the Trigger and $ quoting options in the Disable 
   section
7) On the Objects tab, Select only the tables noted below for the schema being backed 
   up 
8) Create the backup file 
9) Once all necessary backup files have been created, replace the samoa.7z archive
   by opening a command window and executing the command 
			7z.exe a samoa.7z *.sql -p<password>
   from the folder containing the SQL backup files 
10)Run the ceate_soladb_samoa.bat script to test the database build still works. 

   
Tables to backup for each Schema:
* cadastre - cadastre.spatial_unit, cadastre.cadastre_object, 
			 cadastre.spatial_value_area
* document - document.document (Only require approx 50 - 100 documents for testing 
             purposes)
* source   - source.source, source.power_of_attorney, source.archive, 
			 application.application_uses_source, administrative.source_describes_ba_unit, 
			 administrative.source_describes_rrr
            (All documents should have an appropriate source record 
             created for them)
* application - application.application, application.application_property, application.service
* administration - administrative.ba_unit, administrative.required_relationship_baunit, 
                   administrative.ba_unit_area, administrative.rrr, administrative.rrr_share,
				   administrative.party_for_rrr, administrative.notation, 
				   administrative.ba_unit_contains_spatial_unit, administrative.ba_unit_as_party,
				   
* party - party.party (remove agents and banks as these are populated as Samoa extensions)
* address - address.address
* system - system.appuser, system.appuser_appgroup
				   
	 
Data Fixes required
1) If you refresh the cadastre.sql backup file, you will also need to modify the 
   data-fixes.sql script and update the GUIDs used to match the spatial_unit 
   levels with the level GUID's from the database used as the source of the 
   backup.    
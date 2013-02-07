-- Query to retrieve instrument records from LRS based on lodgements after 1 Oct 2012. 
-- This query should be executed on the LRS database using MS SQL Server Management Studio
SELECT DISTINCT 'INSERT INTO lrs.post_migration_instrument (inst_ref, lodge_ref, lodge_date) VALUES (''' 
+ i.instrumentReference + ''', ''' + l.lodgementReference + ''', '''
 + CONVERT(nvarchar, l.lodgementDate)  + ''');'
from dbo.lodgement l, 
     dbo.dealing  d,
	 dbo.instrument i
WHERE d.lodgement = l.lodgementId 
AND i.dealing = d.dealingID
AND l.lodgementDate > '1 OCT 2012';

SELECT DISTINCT 'INSERT INTO lrs.post_migration_title (title_ref, reg_date) VALUES (''' 
+ t.titleReference + ''', ''' + CONVERT(nvarchar, t.dateofCurrentTitle) + ''');'
FROM dbo.Title t where t.dateofCurrentTitle > '1 OCT 2012';


-- Queries to run on the SOLA database...
-- Create temp table in lrs schema of SOLA
DROP TABLE IF EXISTS lrs.post_migration_instrument;
CREATE TABLE lrs.post_migration_instrument (
 inst_ref VARCHAR(50),
 lodge_ref VARCHAR(50),
 lodge_date timestamp without time zone); 
 
 
-- Check for the instruments in LRS that have not been recorded in SOLA. 
SELECT * from lrs.post_migration_instrument pi
WHERE NOT EXISTS (SELECT nr FROM application.application a WHERE pi.inst_ref = a.nr);

-- Queries to run on the SOLA database...
-- Create temp table in lrs schema of SOLA
DROP TABLE IF EXISTS lrs.post_migration_title;
CREATE TABLE lrs.post_migration_title (
 title_ref VARCHAR(50),
 reg_date timestamp without time zone); 
 
 
-- Check for the instruments in LRS that have not been recorded in SOLA. 
SELECT * from lrs.post_migration_title pt
WHERE NOT EXISTS (SELECT ba.id
FROM administrative.ba_unit ba WHERE ba.name_firstpart || '/' ||  ba.name_lastpart = pt.title_ref);


-- 18 Feb 2012

-- #78 Reset the 3 lots of 10439 from historic to current
UPDATE administrative.ba_unit 
SET status_code = 'current'
WHERE name_lastpart = '10439';


-- #79 Fix the folio references for the Court Grants and some of the
-- old V references. 
UPDATE administrative.ba_unit
SET name_firstpart = 'CTGT',
    name_lastpart = regexp_replace(name_lastpart, '\D*',  ''), 
    name = 'CTGT/' ||  regexp_replace(name_lastpart, '\D*',  '')
WHERE name_lastpart LIKE 'CTGT%'
AND name_lastpart != 'CTGTCTGT320'
AND status_code != 'pending';

UPDATE administrative.ba_unit
SET name_firstpart = 'CTGT',
    name_lastpart = '320(2)', 
    name = 'CTGT/320(2)' 
WHERE name_lastpart = 'CTGTCTGT320';

UPDATE administrative.ba_unit
SET name_firstpart = 'V52',
    name_lastpart = '57', 
    name = 'V52/57' 
WHERE name_lastpart = 'V5257';

UPDATE administrative.ba_unit
SET name_firstpart = 'V52',
    name_lastpart = '142', 
    name = 'V52/142' 
WHERE name_lastpart = 'V52142';

UPDATE administrative.ba_unit
SET name_firstpart = 'V52',
    name_lastpart = '51', 
    name = 'V52/51' 
WHERE name_lastpart = 'V5251';

UPDATE administrative.ba_unit
SET name_firstpart = 'V53',
    name_lastpart = '92', 
    name = 'V53/92' 
WHERE name_lastpart = 'V5392';

-- Fix the application property on application 39032
UPDATE application.application_property 
SET name_firstpart = 'CTGT', 
    name_lastpart = '593',
    verified_exists = true,
    verified_location = true,
    ba_unit_id = (SELECT id FROM administrative.ba_unit WHERE name = 'CTGT/593')
WHERE application_id IN (SELECT id FROM application.application WHERE nr = '39032');

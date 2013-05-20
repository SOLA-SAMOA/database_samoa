-- 20 May 2012
-- Fix naming for lots on plan 11083. Parcels for 11038 were incorrectly migrated into 
-- SOLA as parcels 11083.
update cadastre.cadastre_object SET name_lastpart = '11038-' where name_lastpart = '11083'; 

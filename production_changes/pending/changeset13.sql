-- 4 Mar 2012

-- Update Training, test the deployment, then update Production. 
-- Update Glassfish Keystore certificates by copying cacerts.jks and keystore.jks
-- From Dropbox\Keystores folder to the config directory of the Glassfish SOLA 
-- Domain. Run the asadmin change-master-password subcommand and set the 
-- new Glassfish Master Password to match the storepass in 
-- Dropbox\Keystores\settings.xml file. 
-- <Glassfish Install Dir>\bin\asadmin change-master-password --savemasterpassword=true --domaindir <SOLA Glassfish Domain Dir>



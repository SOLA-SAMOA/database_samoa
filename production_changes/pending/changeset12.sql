-- xx Feb 2012

-- Ticket 81 - add RCL's for road polygons created since SOLA Samoa golive. 
INSERT INTO cadastre.spatial_unit (id, change_user, label, level_id, geom) VALUES ('b99812c8-7a1a-11e2-8b2c-8f2c412d8054', 'ticket81', NULL, '1434363e-3430-11e2-a0e5-3f974f0fbad5', ST_SetSRID(ST_GeomFromText('LINESTRING(404511.610230789 8468387.27360241,404673.365935426 8468360.13522029)'),32702));
INSERT INTO cadastre.spatial_unit (id, change_user, label, level_id, geom) VALUES ('b998af08-7a1a-11e2-a5eb-c33e83e66493', 'ticket81', NULL, '1434363e-3430-11e2-a0e5-3f974f0fbad5', ST_SetSRID(ST_GeomFromText('LINESTRING(407934.228748975 8467277.37490369,408004.551075388 8467296.32354449,408045.71536402 8467271.41261585)'),32702));
INSERT INTO cadastre.spatial_unit (id, change_user, label, level_id, geom) VALUES ('b9992438-7a1a-11e2-bbb9-f3d597e23cd6', 'ticket81', NULL, '1434363e-3430-11e2-a0e5-3f974f0fbad5', ST_SetSRID(ST_GeomFromText('LINESTRING(416157.065868785 8469850.40539965,416232.579093647 8469831.72114357)'),32702));
INSERT INTO cadastre.spatial_unit (id, change_user, label, level_id, geom) VALUES ('b9999968-7a1a-11e2-b6d6-03d578ff2226', 'ticket81', NULL, '1434363e-3430-11e2-a0e5-3f974f0fbad5', ST_SetSRID(ST_GeomFromText('LINESTRING(413924.674358749 8470467.95099478,414055.247360395 8470365.57202003,414060.325807515 8470349.32098925,414102.781625435 8470327.58523558)'),32702));
INSERT INTO cadastre.spatial_unit (id, change_user, label, level_id, geom) VALUES ('b99a0ea2-7a1a-11e2-8b48-d74ed5861c87', 'ticket81', 'VAITELE AVENUE', '1434363e-3430-11e2-a0e5-3f974f0fbad5', ST_SetSRID(ST_GeomFromText('LINESTRING(411989.732699226 8471435.9868856,412120.035419056 8471574.23489323,412132.350615137 8471575.62531859,412161.350915587 8471555.9607313,412188.364894089 8471531.92623572)'),32702));

-- Ticket #82 Remove duplicate plan numbers
DELETE FROM application.service 
WHERE application_id IN (
'730546CF-D08C-49A8-92D6-4B40AA67CE38',
'DFAE93F1-4644-433A-B627-19083DDCB38C',
'40F99B69-6B00-48C5-A7CA-9CED3D164F84',
'FA52B7DB-4FDD-40FD-9CEF-4265584446D9',
'9CD97388-60FD-4979-A961-967489797B6B',
'8449CF30-C916-4BBB-A082-202D7B24B6F9',
'0C5426D7-44AD-44F3-8E7E-9ABC8157D792',
'16267CB6-C752-46C0-9216-2492E3AAB9A2',
'0952D1CE-75AF-43C2-81E8-DD336E211427',
'FD1AB659-84B5-4AEE-A67A-A0BC6BA40F35',
'B2890514-8F70-4795-9A00-E9577E76FE06',
'ED5FE10D-3FB6-49FB-92D1-475C7E919D46',
'26090945-A3AE-485F-9FCB-B6828EAB7C0E',
'A4C2411D-5FFB-452E-A2EA-4CAA6C1CFE5E',
'2BFB0619-08B9-4F4E-8A97-86A68C44E765',
'90FA8C69-3549-4758-B10C-E728C255A3AB',
'CA3C729C-19BF-404F-9EDD-12515A51B4B0',
'2C28B20F-9883-421E-9F75-EF93A3478190',
'B7F7B449-8BBA-46F4-B535-3BDA6F8E8106',
'6318341F-354F-4447-88FE-588EDCD5BD57',
'635EB1E7-A6A4-4785-969C-2BBD972F3FA8',
'B6956114-C454-498A-8640-D426FA56707E',
'2C9E3C47-0A7B-4481-859A-C2454B57F641',
'2BBEF396-3D90-4C93-B08B-4FA49B6CBD74',
'5FDFFD2B-7D82-4E26-A84D-7F76A9563385',
'6C63BA0D-3DC9-4405-9F61-67EBD041E00D',
'56595218-4A22-4D27-9052-D66B259B2B2C',
'9874DED4-231B-4D68-B203-98F042B9869D',
'3FA56677-E771-45C7-9CEF-DA4EE9250486',
'5F449941-6DFA-415F-A6E8-D0A127ED30BB',
'8E3D8CFB-08C4-4CEC-A16A-EC6E4ED80465',
'9F6A160E-80A9-44AC-842E-038EE82E13FF',
'115117DF-3BE0-49C3-A486-F90B9578D4CA',
'F6E279BF-7044-4EB4-BE2D-22C80DCB3689',
'CFC7EE09-62F0-4DBE-8BF4-0D918240C4BC',
'C93982E9-0A99-4A2F-BBA0-A3CF13D828CD',
'8C2B7E2F-F35F-4833-AC83-89622A550780',
'0F64242F-032A-4EE1-8897-60EC8550A8A2',
'79BE7523-F0CE-4494-8DDD-CFFD7D09C112',
'25AA84AB-2516-49A9-AA2F-DC875DABC238',
'781874DD-CE9B-4B6A-9585-F137B912EA50',
'52D0BDDB-2CAF-4379-A9BC-F6EA8447AFC2',
'2DB28BDE-5335-4B0B-932B-C1CE3BC505CA',
'4E851ABC-F0F4-4876-AD59-8881D4BD8480',
'14359637-788D-4483-A2C5-15D8EA4B7E35',
'FF1AC71A-E246-4B2C-ABA9-AD895FF27B97',
'A9BE981A-8A42-4272-83BB-BC9289A4FF45',
'7D8F3594-6313-400B-99B1-8740538B8CA4',
'7EECEDE3-14B9-42B8-BB5C-19F8AE4E32EC',
'C3468C93-AB4A-44CD-93C3-687BD6C20870',
'4B19C187-5BCB-45F0-9B3B-F167A5A3A478',
'8A1E640B-FBBA-4784-9757-57F4E8B0C7B8',
'28C9CB83-C22B-404D-8A01-2E68FD2AC314',
'F34B0382-5095-4412-9964-D282BB9541AC',
'39BAA2D3-7324-4A1A-AD30-CFA551E9A965',
'5E9685D9-844B-45A8-B8B7-2850AB5CECC4',
'51845155-EB92-4D7F-A2EC-8A2FACC1C586',
'27845C52-6F09-4865-8A82-E439D0A62670',
'05A7464C-4D94-48F4-92F2-D32396E9DD15',
'7CDE7D3A-D6BD-483C-B5B4-2DC35F524226',
'C616802A-E2CA-44B9-9083-0D23CEB2D967',
'030B1110-0811-4603-89DE-65CFB137F294',
'46F745F6-6D10-4357-B0CA-AAE8EDDBD91A',
'5C5CC609-4E6B-48D9-BD49-942FDE6520C3',
'25019A4F-3650-425A-A054-8CF6768BB5D2',
'64476B3C-60AC-49E6-A180-787F60A1C18E',
'2B1690A0-CF15-4F7A-A40F-0B3343234E1E',
'4FB4711F-529A-4DB4-8D06-3D8A0853BC49',
'3418B91F-6B2D-4A52-B7C7-8B245AA24C3F',
'7F72EA49-D77C-4898-AA4D-39EFDE8C26ED',
'23561642-C683-4FB4-83C3-6B8581EDBC21',
'2C80418B-678E-4958-A3F9-67247EB0043D',
'78E152A4-4B3F-497B-80CD-6F19CCF40056',
'A1E8B4A1-6631-4690-B486-34FEBE6456D2',
'A2E0370A-96C2-4BB1-B361-3B7CDC9CFD04',
'3C135D01-28DB-4842-A8F7-18147A7A0355',
'204784EE-EEB2-4EF4-ABC2-AE8054C6691F',
'658279AA-8A98-4910-B5CA-17130888BB74',
'43CA053D-7FE5-41AF-B85C-1ABEFFA287C7',
'26062C8B-C87C-4675-B4E6-DD974AA04E82',
'7179E709-BB99-4F78-9743-7F9FE79996E4',
'42AD7D35-5BC9-4962-A01A-A482B4BFA454',
'8897DA32-DA77-4B9B-ACD1-42F3840FDA15',
'E203CF44-38B8-494F-810E-DDE4D6F72EE5',
'E4482E60-1BC3-4324-AF89-CC696F8C4B12',
'CB6ACE94-F2D0-4CEE-97B0-CE191FB1F4AD',
'BAE848EE-CF60-4A16-8405-0703FF757493',
'E8CAF9AC-C57D-4749-8630-84F03457721F',
'42059ADD-DA0B-41A2-9092-8A0FF522A759',
'7AC66252-4AB0-4CF4-ACCA-2E314ACAA6E9',
'E7F123B0-1AA6-44CC-A5F0-4FD9B456805E',
'31EFF760-FE05-405C-A45E-7A641D6F4C39',
'9881D8E2-074F-4376-82D6-E99CE57AC4CD',
'85AAEE4F-8EEE-48FF-BC2A-083110684CDD',
'213E9537-18B7-4510-AD1C-781ABBB12441',
'CCF16F71-B6DE-445F-97FD-0465DE52E27A',
'78346EDC-50E1-4123-9951-A912B17CFB37',
'97B74274-719A-4E8F-89FC-0FFA7956E7A1',
'03CE3C2D-D15F-48C0-8EE6-C366B5238986',
'85B9593B-42DF-4302-A10A-A57ACA098EE8',
'AE146795-5C7F-4BF3-869C-1A157727ECE5',
'9B5DDF8F-4904-4013-A764-855A3C1A9A63',
'4305D83B-ABAA-4B47-824F-F7C1505E62FE',
'422BC3D7-93ED-4523-AA88-B5FA10E42B5F',
'96AB488B-191A-40C3-A966-6F0D21DAC4FE',
'39B36AEC-A592-486A-AC59-825EEAB0FAEE',
'A6F01B16-B87A-4852-AA28-1973F9981F67',
'BFE328D5-9DC3-4166-AB08-8DC2F98A58DB',
'498AA327-132F-47A9-A509-C2AAAD2C99A0',
'B00E982D-D8EB-43E3-A3F4-19F87B641C90',
'E0984E87-239E-40DD-A3B7-6B32D2D84ADF',
'66ACFC5E-6511-478E-8916-4D1111C80FBC',
'90F186AB-A15A-4CA9-B71B-682CB1632B5A',
'A0FDB346-70ED-417F-8EE7-3E5A18B3E5AD',
'508B85EE-EB1C-4A92-B8F5-CE030DCC676E',
'FEB32C2A-1592-4B9B-84A3-EB3A309C3111',
'9F372844-8EB1-47B2-88BF-04AF9655D6BE',
'13CAF4C6-CFCC-4403-9CFE-EC667B2CC18F',
'DC975FD6-EE2B-452E-A05E-6B0D734BE709',
'3CE647CB-9FF8-4331-BA8C-078F4D8627F5',
'523F7FFB-95A1-44F2-9186-468C81A53B23',
'4D359828-7178-4F39-8F12-79B619F7C9FB',
'6B4866B9-0721-48A4-B235-8EA7E3F85A97',
'E7318715-D2A3-4F26-BDB9-FB71B4E49444',
'53CB886D-AE95-4895-8929-C6EAB6A88541',
'2B77855C-40AD-4A2E-96E4-789DBBB7C163',
'CB4A2A77-E4F2-42BA-84BE-1EA5E5B988DE',
'F2D5B130-F2D6-4DB3-8662-1A655C54422B',
'8103D6FA-FABE-44EC-B69C-C15496B697AE',
'3819BA55-87AD-4F72-BD30-FA3DBCBCAC61',
'1D0493E2-0EA0-4A4E-85BC-4AFC4B09C3FB',
'6C7BBF84-C8A0-4E66-88E2-D1B030FD44A2',
'83EAA39A-F136-40CB-B688-A1AB9423032E',
'F405E807-0F5B-4D06-8838-97FFF9347099',
'8D016A93-05DA-4C91-93DA-1A493FB28AE1',
'195FDA81-D6F0-481C-B5B3-CB6DCF21A4DB',
'1207180C-31E2-461D-8122-D33336F7D758',
'D7BFE482-9BC0-42E6-994A-017A664B9E0E',
'749BFF7B-67BD-402D-8754-B9DE321091F3',
'68B6E801-D811-4645-ACDF-7E84D2607C1F',
'CF1239E7-DE1A-4354-98DA-6346ED5BF854',
'1D813A09-9A24-4C1B-8ED7-BA8DC7441DEB',
'46D6605B-7E97-47C9-8C2A-C94E867613C7',
'EDF0565B-FCFB-4323-8379-434FF61C951B',
'F8F8FE09-A208-4DAD-995F-9034FC2DE50E',
'29EFA2B9-1CD6-47A6-8724-82001EEE9F78',
'2F7CA352-7DA4-439D-8567-40728D8D450E',
'2322486F-AF1E-49D7-B278-9441EBA6A5A4',
'182E4F8B-4C6F-47AD-AC80-E6859B184573',
'2F9C939C-0918-45F7-8CE3-4C5927715D69',
'1D795A6A-8777-4A0F-A11E-79CC49FF859C',
'8C6C3448-08D8-4EA5-A884-DAB6D1440E62',
'6C883B71-7BAF-4A51-9AA8-8EC27B5FF3A8',
'7B49AA8A-2286-4F32-9533-9879D79C50C5',
'8D492C42-521E-4743-9C4E-03D7F532278A',
'B02E8F3C-7945-4871-BA4C-86CD4E4023EB',
'D322C6B9-81F7-4D57-88DF-22F6E8DC0CBF',
'782C21DA-5FEC-460B-8D5F-340BC4A3F8EB',
'6394CC06-2F2A-4C0E-A5F3-6293C6B0D957',
'FC950033-CC06-428A-BDC1-47F2111211A4',
'2FCEBDBB-D2AD-4599-9EB6-5A9C87C3F9AC',
'40F09851-F8BE-41E0-A517-6E6AE0CB38DD',
'4998BF52-0CDB-4BB8-8EF0-CEE45FE1F76A',
'43DDD3FC-45BA-4171-85D5-9DF2144425DC',
'8DB1B2B5-C09D-4A1B-BD68-40D84B4168EC',
'081D75DE-56AE-4C74-BCA0-68B00957AE9F',
'D47315A5-C487-40CD-98D0-F4EC1EF2CD5D',
'6C9B53F6-5F9C-401C-8CEC-933C0FF7A127',
'227D809C-7848-4DC0-9DFB-88C5A4EDF5F2',
'BA721162-A935-4849-A3EC-7A127BC8A66A',
'9AE584C9-D188-4E13-A43B-1C5FC9EAC7DD',
'6C0A4715-E955-47A7-AB44-C769B161A47E',
'29050A9E-9769-4A8F-971A-AED9D84D8B69',
'383D7824-AB79-42BD-A107-07C5FDEBB942',
'F4677FB6-CB28-4C1C-969E-AEE10D449C07',
'EE0AEAD6-E18D-41CE-90C6-4B9A6F36E82F',
'78716E0B-55F8-4686-BFB0-6D79B264C6F9',
'D1F136F1-18FD-4639-AD7C-489CE4FD4041',
'31B0B852-3D37-4A46-8FE9-6BA403AC1BFE',
'BC4FCC13-9BB9-4D14-9036-64E981012189',
'C625CC4C-32B3-4A98-830F-7B13895D2044',
'25905514-38B5-44B1-99FA-6AFCE357C4F4',
'79152FC1-FF81-4693-91EC-8924D1E1DEDE',
'06E87E77-AF66-4A3D-A036-0949690B0DB7',
'02AF78FF-7F58-4AC1-88B6-5A97721681BF',
'88C29331-9532-427C-93EB-4EFB52F6346E',
'DE1E5A9F-AA8B-48A9-B2C4-9FC78160208C',
'9C2231CE-50F0-4DAF-9A7D-996F92E5DC69',
'1950A14A-BD0D-4ECE-B742-D76EEED6F4B1',
'D17A7C6C-24A8-4AF1-BCD8-A0617378CABA',
'F0718892-C5F3-4CC5-A1C3-8BFA50736A4F',
'D533ED76-3EB7-4F04-B888-3E7C80AB3FCD',
'97C3F1AE-CD0E-46A1-BCAE-961889C9A80A',
'DF8A0476-22A9-4D5B-9D45-01EB5C482199',
'9F98C53E-EE2D-4345-B9FA-AD56CB3E9C67',
'79EC269B-29F8-4704-BAFE-F66B5670EE81',
'19C525F3-C31C-4B18-A480-852D81A26832',
'A04BFC75-142A-49C0-A7A9-5CB355100174',
'F07DBBE1-1D34-46A6-9B90-88AB9DC86061',
'24A05515-8164-4B47-B671-A45085EC7B59',
'96C0792F-4F2E-4232-9EF1-E63812DA79B5',
'BC197F1C-C9D5-423A-9BA8-8FA2BC75563A',
'E933D169-D49C-4148-834C-2ED2B168FF5A',
'59F2B2B6-F7B7-46E3-8CE6-18A46D6BFF61',
'AEDCBFAB-6FB5-468A-80F2-D1141EFD86AE',
'5C3CA1DB-DFEB-475E-9FE2-D4DE5A36EAE6',
'BE48F11F-359B-48E5-9ABF-3A6C1FA5FC9D',
'2C1BA0E2-AED1-4873-BD37-6402E720B1A2',
'5D12A852-4FCE-4557-958D-81B260AFC35A',
'209D7F24-CDE9-410B-8945-044A794BE72E',
'B2B682F5-2A5A-4C4F-9FDE-AA4DE9918BCD',
'2C2C392C-F6E0-48BD-8208-1A4EFB8F646A',
'56C1F118-9D5D-4694-8A0A-3287ABDCF3AE',
'221AF97E-A8F1-44B0-95B8-5975C720C151',
'72C9F986-7240-4863-BC96-087DA5EAB2E7',
'DDA757E8-926D-4898-97E3-850342443478',
'57810BD5-8258-4DE3-8DD6-EDF11CDFFFEE',
'C49827DC-7857-40DF-8967-532C0E2D8AC0',
'0A11FE59-4EA4-402A-AE4C-5C09BB495DE5',
'1B06DC14-032A-4A9D-A3E5-5322927B962A',
'CCF18BCE-9553-495E-B8A3-DDDD92E65C73',
'A1288D72-6A77-4ADC-B62B-64D9196A6053',
'04631DB4-A940-464E-94AD-D0AF8077C06F',
'BC42E474-A3A0-439E-B5F2-05C72866B47A',
'849E5134-2159-4E6D-87AA-71823093D27C',
'E52CCDF7-22D2-47BE-9418-96FB14D20B6A',
'DFCC2E78-C595-41DF-8CBD-884163732847',
'8B37B3D0-9DA0-4586-86C2-A4FB0B7903B4',
'7B380E4B-E8B4-4AFF-9172-F4C8BCF5F7F8',
'BC419A9D-8212-45BE-91F9-01CF090FB9DB',
'90C59645-0C78-43E5-9DEA-CFE420A80D9A',
'BFA3A638-73C0-40EF-9C06-2C1662897004',
'7E7F9DCB-4A5A-46B9-A6D4-2BAE72BF6C04',
'2F774434-2D2C-4270-BB7E-D7980E640845',
'C31802FB-235B-427E-AF48-7CE0CB5DF4A9',
'75B5563E-8F67-4E02-87C2-4CADB034B2D6' -- 10557
);

DELETE FROM application.application 
WHERE id IN (
'730546CF-D08C-49A8-92D6-4B40AA67CE38',
'DFAE93F1-4644-433A-B627-19083DDCB38C',
'40F99B69-6B00-48C5-A7CA-9CED3D164F84',
'FA52B7DB-4FDD-40FD-9CEF-4265584446D9',
'9CD97388-60FD-4979-A961-967489797B6B',
'8449CF30-C916-4BBB-A082-202D7B24B6F9',
'0C5426D7-44AD-44F3-8E7E-9ABC8157D792',
'16267CB6-C752-46C0-9216-2492E3AAB9A2',
'0952D1CE-75AF-43C2-81E8-DD336E211427',
'FD1AB659-84B5-4AEE-A67A-A0BC6BA40F35',
'B2890514-8F70-4795-9A00-E9577E76FE06',
'ED5FE10D-3FB6-49FB-92D1-475C7E919D46',
'26090945-A3AE-485F-9FCB-B6828EAB7C0E',
'A4C2411D-5FFB-452E-A2EA-4CAA6C1CFE5E',
'2BFB0619-08B9-4F4E-8A97-86A68C44E765',
'90FA8C69-3549-4758-B10C-E728C255A3AB',
'CA3C729C-19BF-404F-9EDD-12515A51B4B0',
'2C28B20F-9883-421E-9F75-EF93A3478190',
'B7F7B449-8BBA-46F4-B535-3BDA6F8E8106',
'6318341F-354F-4447-88FE-588EDCD5BD57',
'635EB1E7-A6A4-4785-969C-2BBD972F3FA8',
'B6956114-C454-498A-8640-D426FA56707E',
'2C9E3C47-0A7B-4481-859A-C2454B57F641',
'2BBEF396-3D90-4C93-B08B-4FA49B6CBD74',
'5FDFFD2B-7D82-4E26-A84D-7F76A9563385',
'6C63BA0D-3DC9-4405-9F61-67EBD041E00D',
'56595218-4A22-4D27-9052-D66B259B2B2C',
'9874DED4-231B-4D68-B203-98F042B9869D',
'3FA56677-E771-45C7-9CEF-DA4EE9250486',
'5F449941-6DFA-415F-A6E8-D0A127ED30BB',
'8E3D8CFB-08C4-4CEC-A16A-EC6E4ED80465',
'9F6A160E-80A9-44AC-842E-038EE82E13FF',
'115117DF-3BE0-49C3-A486-F90B9578D4CA',
'F6E279BF-7044-4EB4-BE2D-22C80DCB3689',
'CFC7EE09-62F0-4DBE-8BF4-0D918240C4BC',
'C93982E9-0A99-4A2F-BBA0-A3CF13D828CD',
'8C2B7E2F-F35F-4833-AC83-89622A550780',
'0F64242F-032A-4EE1-8897-60EC8550A8A2',
'79BE7523-F0CE-4494-8DDD-CFFD7D09C112',
'25AA84AB-2516-49A9-AA2F-DC875DABC238',
'781874DD-CE9B-4B6A-9585-F137B912EA50',
'52D0BDDB-2CAF-4379-A9BC-F6EA8447AFC2',
'2DB28BDE-5335-4B0B-932B-C1CE3BC505CA',
'4E851ABC-F0F4-4876-AD59-8881D4BD8480',
'14359637-788D-4483-A2C5-15D8EA4B7E35',
'FF1AC71A-E246-4B2C-ABA9-AD895FF27B97',
'A9BE981A-8A42-4272-83BB-BC9289A4FF45',
'7D8F3594-6313-400B-99B1-8740538B8CA4',
'7EECEDE3-14B9-42B8-BB5C-19F8AE4E32EC',
'C3468C93-AB4A-44CD-93C3-687BD6C20870',
'4B19C187-5BCB-45F0-9B3B-F167A5A3A478',
'8A1E640B-FBBA-4784-9757-57F4E8B0C7B8',
'28C9CB83-C22B-404D-8A01-2E68FD2AC314',
'F34B0382-5095-4412-9964-D282BB9541AC',
'39BAA2D3-7324-4A1A-AD30-CFA551E9A965',
'5E9685D9-844B-45A8-B8B7-2850AB5CECC4',
'51845155-EB92-4D7F-A2EC-8A2FACC1C586',
'27845C52-6F09-4865-8A82-E439D0A62670',
'05A7464C-4D94-48F4-92F2-D32396E9DD15',
'7CDE7D3A-D6BD-483C-B5B4-2DC35F524226',
'C616802A-E2CA-44B9-9083-0D23CEB2D967',
'030B1110-0811-4603-89DE-65CFB137F294',
'46F745F6-6D10-4357-B0CA-AAE8EDDBD91A',
'5C5CC609-4E6B-48D9-BD49-942FDE6520C3',
'25019A4F-3650-425A-A054-8CF6768BB5D2',
'64476B3C-60AC-49E6-A180-787F60A1C18E',
'2B1690A0-CF15-4F7A-A40F-0B3343234E1E',
'4FB4711F-529A-4DB4-8D06-3D8A0853BC49',
'3418B91F-6B2D-4A52-B7C7-8B245AA24C3F',
'7F72EA49-D77C-4898-AA4D-39EFDE8C26ED',
'23561642-C683-4FB4-83C3-6B8581EDBC21',
'2C80418B-678E-4958-A3F9-67247EB0043D',
'78E152A4-4B3F-497B-80CD-6F19CCF40056',
'A1E8B4A1-6631-4690-B486-34FEBE6456D2',
'A2E0370A-96C2-4BB1-B361-3B7CDC9CFD04',
'3C135D01-28DB-4842-A8F7-18147A7A0355',
'204784EE-EEB2-4EF4-ABC2-AE8054C6691F',
'658279AA-8A98-4910-B5CA-17130888BB74',
'43CA053D-7FE5-41AF-B85C-1ABEFFA287C7',
'26062C8B-C87C-4675-B4E6-DD974AA04E82',
'7179E709-BB99-4F78-9743-7F9FE79996E4',
'42AD7D35-5BC9-4962-A01A-A482B4BFA454',
'8897DA32-DA77-4B9B-ACD1-42F3840FDA15',
'E203CF44-38B8-494F-810E-DDE4D6F72EE5',
'E4482E60-1BC3-4324-AF89-CC696F8C4B12',
'CB6ACE94-F2D0-4CEE-97B0-CE191FB1F4AD',
'BAE848EE-CF60-4A16-8405-0703FF757493',
'E8CAF9AC-C57D-4749-8630-84F03457721F',
'42059ADD-DA0B-41A2-9092-8A0FF522A759',
'7AC66252-4AB0-4CF4-ACCA-2E314ACAA6E9',
'E7F123B0-1AA6-44CC-A5F0-4FD9B456805E',
'31EFF760-FE05-405C-A45E-7A641D6F4C39',
'9881D8E2-074F-4376-82D6-E99CE57AC4CD',
'85AAEE4F-8EEE-48FF-BC2A-083110684CDD',
'213E9537-18B7-4510-AD1C-781ABBB12441',
'CCF16F71-B6DE-445F-97FD-0465DE52E27A',
'78346EDC-50E1-4123-9951-A912B17CFB37',
'97B74274-719A-4E8F-89FC-0FFA7956E7A1',
'03CE3C2D-D15F-48C0-8EE6-C366B5238986',
'85B9593B-42DF-4302-A10A-A57ACA098EE8',
'AE146795-5C7F-4BF3-869C-1A157727ECE5',
'9B5DDF8F-4904-4013-A764-855A3C1A9A63',
'4305D83B-ABAA-4B47-824F-F7C1505E62FE',
'422BC3D7-93ED-4523-AA88-B5FA10E42B5F',
'96AB488B-191A-40C3-A966-6F0D21DAC4FE',
'39B36AEC-A592-486A-AC59-825EEAB0FAEE',
'A6F01B16-B87A-4852-AA28-1973F9981F67',
'BFE328D5-9DC3-4166-AB08-8DC2F98A58DB',
'498AA327-132F-47A9-A509-C2AAAD2C99A0',
'B00E982D-D8EB-43E3-A3F4-19F87B641C90',
'E0984E87-239E-40DD-A3B7-6B32D2D84ADF',
'66ACFC5E-6511-478E-8916-4D1111C80FBC',
'90F186AB-A15A-4CA9-B71B-682CB1632B5A',
'A0FDB346-70ED-417F-8EE7-3E5A18B3E5AD',
'508B85EE-EB1C-4A92-B8F5-CE030DCC676E',
'FEB32C2A-1592-4B9B-84A3-EB3A309C3111',
'9F372844-8EB1-47B2-88BF-04AF9655D6BE',
'13CAF4C6-CFCC-4403-9CFE-EC667B2CC18F',
'DC975FD6-EE2B-452E-A05E-6B0D734BE709',
'3CE647CB-9FF8-4331-BA8C-078F4D8627F5',
'523F7FFB-95A1-44F2-9186-468C81A53B23',
'4D359828-7178-4F39-8F12-79B619F7C9FB',
'6B4866B9-0721-48A4-B235-8EA7E3F85A97',
'E7318715-D2A3-4F26-BDB9-FB71B4E49444',
'53CB886D-AE95-4895-8929-C6EAB6A88541',
'2B77855C-40AD-4A2E-96E4-789DBBB7C163',
'CB4A2A77-E4F2-42BA-84BE-1EA5E5B988DE',
'F2D5B130-F2D6-4DB3-8662-1A655C54422B',
'8103D6FA-FABE-44EC-B69C-C15496B697AE',
'3819BA55-87AD-4F72-BD30-FA3DBCBCAC61',
'1D0493E2-0EA0-4A4E-85BC-4AFC4B09C3FB',
'6C7BBF84-C8A0-4E66-88E2-D1B030FD44A2',
'83EAA39A-F136-40CB-B688-A1AB9423032E',
'F405E807-0F5B-4D06-8838-97FFF9347099',
'8D016A93-05DA-4C91-93DA-1A493FB28AE1',
'195FDA81-D6F0-481C-B5B3-CB6DCF21A4DB',
'1207180C-31E2-461D-8122-D33336F7D758',
'D7BFE482-9BC0-42E6-994A-017A664B9E0E',
'749BFF7B-67BD-402D-8754-B9DE321091F3',
'68B6E801-D811-4645-ACDF-7E84D2607C1F',
'CF1239E7-DE1A-4354-98DA-6346ED5BF854',
'1D813A09-9A24-4C1B-8ED7-BA8DC7441DEB',
'46D6605B-7E97-47C9-8C2A-C94E867613C7',
'EDF0565B-FCFB-4323-8379-434FF61C951B',
'F8F8FE09-A208-4DAD-995F-9034FC2DE50E',
'29EFA2B9-1CD6-47A6-8724-82001EEE9F78',
'2F7CA352-7DA4-439D-8567-40728D8D450E',
'2322486F-AF1E-49D7-B278-9441EBA6A5A4',
'182E4F8B-4C6F-47AD-AC80-E6859B184573',
'2F9C939C-0918-45F7-8CE3-4C5927715D69',
'1D795A6A-8777-4A0F-A11E-79CC49FF859C',
'8C6C3448-08D8-4EA5-A884-DAB6D1440E62',
'6C883B71-7BAF-4A51-9AA8-8EC27B5FF3A8',
'7B49AA8A-2286-4F32-9533-9879D79C50C5',
'8D492C42-521E-4743-9C4E-03D7F532278A',
'B02E8F3C-7945-4871-BA4C-86CD4E4023EB',
'D322C6B9-81F7-4D57-88DF-22F6E8DC0CBF',
'782C21DA-5FEC-460B-8D5F-340BC4A3F8EB',
'6394CC06-2F2A-4C0E-A5F3-6293C6B0D957',
'FC950033-CC06-428A-BDC1-47F2111211A4',
'2FCEBDBB-D2AD-4599-9EB6-5A9C87C3F9AC',
'40F09851-F8BE-41E0-A517-6E6AE0CB38DD',
'4998BF52-0CDB-4BB8-8EF0-CEE45FE1F76A',
'43DDD3FC-45BA-4171-85D5-9DF2144425DC',
'8DB1B2B5-C09D-4A1B-BD68-40D84B4168EC',
'081D75DE-56AE-4C74-BCA0-68B00957AE9F',
'D47315A5-C487-40CD-98D0-F4EC1EF2CD5D',
'6C9B53F6-5F9C-401C-8CEC-933C0FF7A127',
'227D809C-7848-4DC0-9DFB-88C5A4EDF5F2',
'BA721162-A935-4849-A3EC-7A127BC8A66A',
'9AE584C9-D188-4E13-A43B-1C5FC9EAC7DD',
'6C0A4715-E955-47A7-AB44-C769B161A47E',
'29050A9E-9769-4A8F-971A-AED9D84D8B69',
'383D7824-AB79-42BD-A107-07C5FDEBB942',
'F4677FB6-CB28-4C1C-969E-AEE10D449C07',
'EE0AEAD6-E18D-41CE-90C6-4B9A6F36E82F',
'78716E0B-55F8-4686-BFB0-6D79B264C6F9',
'D1F136F1-18FD-4639-AD7C-489CE4FD4041',
'31B0B852-3D37-4A46-8FE9-6BA403AC1BFE',
'BC4FCC13-9BB9-4D14-9036-64E981012189',
'C625CC4C-32B3-4A98-830F-7B13895D2044',
'25905514-38B5-44B1-99FA-6AFCE357C4F4',
'79152FC1-FF81-4693-91EC-8924D1E1DEDE',
'06E87E77-AF66-4A3D-A036-0949690B0DB7',
'02AF78FF-7F58-4AC1-88B6-5A97721681BF',
'88C29331-9532-427C-93EB-4EFB52F6346E',
'DE1E5A9F-AA8B-48A9-B2C4-9FC78160208C',
'9C2231CE-50F0-4DAF-9A7D-996F92E5DC69',
'1950A14A-BD0D-4ECE-B742-D76EEED6F4B1',
'D17A7C6C-24A8-4AF1-BCD8-A0617378CABA',
'F0718892-C5F3-4CC5-A1C3-8BFA50736A4F',
'D533ED76-3EB7-4F04-B888-3E7C80AB3FCD',
'97C3F1AE-CD0E-46A1-BCAE-961889C9A80A',
'DF8A0476-22A9-4D5B-9D45-01EB5C482199',
'9F98C53E-EE2D-4345-B9FA-AD56CB3E9C67',
'79EC269B-29F8-4704-BAFE-F66B5670EE81',
'19C525F3-C31C-4B18-A480-852D81A26832',
'A04BFC75-142A-49C0-A7A9-5CB355100174',
'F07DBBE1-1D34-46A6-9B90-88AB9DC86061',
'24A05515-8164-4B47-B671-A45085EC7B59',
'96C0792F-4F2E-4232-9EF1-E63812DA79B5',
'BC197F1C-C9D5-423A-9BA8-8FA2BC75563A',
'E933D169-D49C-4148-834C-2ED2B168FF5A',
'59F2B2B6-F7B7-46E3-8CE6-18A46D6BFF61',
'AEDCBFAB-6FB5-468A-80F2-D1141EFD86AE',
'5C3CA1DB-DFEB-475E-9FE2-D4DE5A36EAE6',
'BE48F11F-359B-48E5-9ABF-3A6C1FA5FC9D',
'2C1BA0E2-AED1-4873-BD37-6402E720B1A2',
'5D12A852-4FCE-4557-958D-81B260AFC35A',
'209D7F24-CDE9-410B-8945-044A794BE72E',
'B2B682F5-2A5A-4C4F-9FDE-AA4DE9918BCD',
'2C2C392C-F6E0-48BD-8208-1A4EFB8F646A',
'56C1F118-9D5D-4694-8A0A-3287ABDCF3AE',
'221AF97E-A8F1-44B0-95B8-5975C720C151',
'72C9F986-7240-4863-BC96-087DA5EAB2E7',
'DDA757E8-926D-4898-97E3-850342443478',
'57810BD5-8258-4DE3-8DD6-EDF11CDFFFEE',
'C49827DC-7857-40DF-8967-532C0E2D8AC0',
'0A11FE59-4EA4-402A-AE4C-5C09BB495DE5',
'1B06DC14-032A-4A9D-A3E5-5322927B962A',
'CCF18BCE-9553-495E-B8A3-DDDD92E65C73',
'A1288D72-6A77-4ADC-B62B-64D9196A6053',
'04631DB4-A940-464E-94AD-D0AF8077C06F',
'BC42E474-A3A0-439E-B5F2-05C72866B47A',
'849E5134-2159-4E6D-87AA-71823093D27C',
'E52CCDF7-22D2-47BE-9418-96FB14D20B6A',
'DFCC2E78-C595-41DF-8CBD-884163732847',
'8B37B3D0-9DA0-4586-86C2-A4FB0B7903B4',
'7B380E4B-E8B4-4AFF-9172-F4C8BCF5F7F8',
'BC419A9D-8212-45BE-91F9-01CF090FB9DB',
'90C59645-0C78-43E5-9DEA-CFE420A80D9A',
'BFA3A638-73C0-40EF-9C06-2C1662897004',
'7E7F9DCB-4A5A-46B9-A6D4-2BAE72BF6C04',
'2F774434-2D2C-4270-BB7E-D7980E640845',
'C31802FB-235B-427E-AF48-7CE0CB5DF4A9',
'75B5563E-8F67-4E02-87C2-4CADB034B2D6' -- 10557
);


-- Manage duplicate applications created by users
DELETE FROM application.application_property 
WHERE application_id IN (
'B01BA8A8-F839-45A7-A21B-7C897F5BC7DA',
'69597750-6901-4824-A8C8-A679D349DD16',
'3B4E444F-FF71-40DB-B4A5-D718EFBD2D43',
'7BCC223B-7F12-4CB1-A1ED-26D89BEECD3E',
'A0FCC468-644F-43A3-9408-DC1A85CE67FA',
'54DF8352-7D82-403E-A37B-A05923DC02C2',
'2CFE142C-E9BE-4ABE-A6E9-0DDBABE19D7C',
'985017C5-F505-42AC-AF23-94ACF03B38EA',
'27F0334C-1E69-4DBE-BBE9-BBF017329E50',
'E8DDF324-D82C-4FFB-A717-E9B2274C4E72',
'40A22A20-5340-4E30-A80D-0E6B66C872D2',
'B91DD792-4505-4023-B838-24F88070C8E0',
'9CC62B2D-77A3-4613-8DFB-E70B5E872DED',
'26370E1B-82B0-44FE-849C-97B0475097E9',
'4B79E1FB-7420-4243-AC52-BE1769615804',
'2D2CD785-4F29-4DAF-93D6-EF02523447FA',
'C30AA606-4A9B-420E-BFE4-1F50DBBC4F4E',
'C7F4D370-E787-4091-A436-726B594342E3',
'AE894AD6-AC80-4C41-B7BF-6A29919147F4',
'04801FB4-ED0A-4224-A85E-DCF29EC14071',
'F4B63FB2-7EAC-46A9-AB09-B3A9336F625C',
'7B3F4A2F-8FC6-4D94-A5E4-DD52616E84A8',
'48be8c40-f207-4fa7-92ae-e2266151606a',
'6F14CAC9-7A1D-4E20-81EB-C81506D1DE30',
'2e32a493-5bd8-49ad-ad52-f002a8f8d93b',
'b196a97c-89ee-4ede-bebf-9b5fd8acede5',
'AB553DB9-3B1C-4CA4-91C9-6831C5536E3F',
'3782D87C-9038-42D6-B28B-DFC1D04BEA95',
'05d26da6-3935-43d6-af77-8f37fc19197c',
'0AC330F3-A7F2-464B-A5BB-9D7667AA4B7A',
'4A513941-3BE1-441C-B7CE-32A35725C027',
'ec4b9723-d99a-47d9-a3ec-2126f32cd875', -- 10531
'96795c53-e3e8-4f07-bcbf-d6576056c29f', -- 10538
'A5DDF628-7940-4E3D-810C-6D394257406B', -- 10543
'5d821720-1cde-457f-a3ea-9772bbcfb894', -- 10546
'341adfb6-f398-4ac7-827b-7dbe719a9172', -- 10560
'17F81E36-38F0-496A-95FD-CAAF0327FF2B', -- 10562
'5727a46a-2fd0-48ae-93c2-4ed07315a6ff', -- 11001
'0393c0dd-e17d-49bf-b717-e3d552b292ee', -- 11018
'afbcf0f6-d948-4442-be28-b6c85c3059d4', -- 31903
'15DB630E-1904-458E-8EAD-29BE8687F211', -- 34004
'25068ADB-FF44-4C48-9F6B-645D3CB08DC3', -- 34005
'42F3F20C-24BE-450C-9D7E-6B6A14CEEB16', -- 34210
'4b838120-371b-430b-93a0-6e23c1be8ffa', -- 38746
'541e518f-013b-4944-be26-eb8e84bdb604', -- 38894
'DB872F30-DA02-4077-AC5D-6F302F0442BB', -- 38896
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'AFB5F48C-4F73-415E-B986-562E67C060A9', -- 38924
'238908D7-A3C3-4FEF-A108-1E24080DDEBB', -- 38995
'42A5D2A9-59A2-4D13-ACB9-AC041F8765E1', -- 39001
'A2E4CC53-BE34-4D1B-BFCE-C8D379095786', -- 39002
'2d17116a-3520-43f5-bcad-c8d803c481c0', -- 39103
'1498e5de-f80d-4285-aa71-0ff71a3e1e24', -- 39103
'895d57e3-e548-4eae-8379-98b9f6623d33', -- 39103
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'11e5a213-66ba-45ff-98ff-b9c5942d164a', -- 39237
'52666916-3613-43bc-b701-26f342a1813d', -- 39238
'c1d87100-ec8e-4e84-9a40-728885877d5d', -- 39617
'aa1f3c3f-3d4f-40a7-89fb-e551836f8403', -- 39672
'6766498d-0019-4511-9392-ac1c7133a2cd', -- 6252
'5374ab83-02fc-4663-b983-a1ec8e43b972' -- 6252
);
 

DELETE FROM application.application_uses_source
WHERE application_id IN (
'B01BA8A8-F839-45A7-A21B-7C897F5BC7DA',
'69597750-6901-4824-A8C8-A679D349DD16',
'3B4E444F-FF71-40DB-B4A5-D718EFBD2D43',
'7BCC223B-7F12-4CB1-A1ED-26D89BEECD3E',
'A0FCC468-644F-43A3-9408-DC1A85CE67FA',
'54DF8352-7D82-403E-A37B-A05923DC02C2',
'2CFE142C-E9BE-4ABE-A6E9-0DDBABE19D7C',
'985017C5-F505-42AC-AF23-94ACF03B38EA',
'27F0334C-1E69-4DBE-BBE9-BBF017329E50',
'E8DDF324-D82C-4FFB-A717-E9B2274C4E72',
'40A22A20-5340-4E30-A80D-0E6B66C872D2',
'B91DD792-4505-4023-B838-24F88070C8E0',
'9CC62B2D-77A3-4613-8DFB-E70B5E872DED',
'26370E1B-82B0-44FE-849C-97B0475097E9',
'4B79E1FB-7420-4243-AC52-BE1769615804',
'2D2CD785-4F29-4DAF-93D6-EF02523447FA',
'C30AA606-4A9B-420E-BFE4-1F50DBBC4F4E',
'C7F4D370-E787-4091-A436-726B594342E3',
'AE894AD6-AC80-4C41-B7BF-6A29919147F4',
'04801FB4-ED0A-4224-A85E-DCF29EC14071',
'F4B63FB2-7EAC-46A9-AB09-B3A9336F625C',
'7B3F4A2F-8FC6-4D94-A5E4-DD52616E84A8',
'48be8c40-f207-4fa7-92ae-e2266151606a',
'6F14CAC9-7A1D-4E20-81EB-C81506D1DE30',
'2e32a493-5bd8-49ad-ad52-f002a8f8d93b',
'b196a97c-89ee-4ede-bebf-9b5fd8acede5',
'AB553DB9-3B1C-4CA4-91C9-6831C5536E3F',
'3782D87C-9038-42D6-B28B-DFC1D04BEA95',
'05d26da6-3935-43d6-af77-8f37fc19197c',
'0AC330F3-A7F2-464B-A5BB-9D7667AA4B7A',
'4A513941-3BE1-441C-B7CE-32A35725C027',
'ec4b9723-d99a-47d9-a3ec-2126f32cd875', -- 10531
'96795c53-e3e8-4f07-bcbf-d6576056c29f', -- 10538
'A5DDF628-7940-4E3D-810C-6D394257406B', -- 10543
'5d821720-1cde-457f-a3ea-9772bbcfb894', -- 10546
'341adfb6-f398-4ac7-827b-7dbe719a9172', -- 10560
'17F81E36-38F0-496A-95FD-CAAF0327FF2B', -- 10562
'5727a46a-2fd0-48ae-93c2-4ed07315a6ff', -- 11001
'0393c0dd-e17d-49bf-b717-e3d552b292ee', -- 11018
'afbcf0f6-d948-4442-be28-b6c85c3059d4', -- 31903
'15DB630E-1904-458E-8EAD-29BE8687F211', -- 34004
'25068ADB-FF44-4C48-9F6B-645D3CB08DC3', -- 34005
'42F3F20C-24BE-450C-9D7E-6B6A14CEEB16', -- 34210
'4b838120-371b-430b-93a0-6e23c1be8ffa', -- 38746
'541e518f-013b-4944-be26-eb8e84bdb604', -- 38894
'DB872F30-DA02-4077-AC5D-6F302F0442BB', -- 38896
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'AFB5F48C-4F73-415E-B986-562E67C060A9', -- 38924
'238908D7-A3C3-4FEF-A108-1E24080DDEBB', -- 38995
'42A5D2A9-59A2-4D13-ACB9-AC041F8765E1', -- 39001
'A2E4CC53-BE34-4D1B-BFCE-C8D379095786', -- 39002
'2d17116a-3520-43f5-bcad-c8d803c481c0', -- 39103
'1498e5de-f80d-4285-aa71-0ff71a3e1e24', -- 39103
'895d57e3-e548-4eae-8379-98b9f6623d33', -- 39103
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'11e5a213-66ba-45ff-98ff-b9c5942d164a', -- 39237
'52666916-3613-43bc-b701-26f342a1813d', -- 39238
'c1d87100-ec8e-4e84-9a40-728885877d5d', -- 39617
'aa1f3c3f-3d4f-40a7-89fb-e551836f8403', -- 39672
'6766498d-0019-4511-9392-ac1c7133a2cd', -- 6252
'5374ab83-02fc-4663-b983-a1ec8e43b972' -- 6252
); 

DELETE FROM application.service 
WHERE application_id IN (
'B01BA8A8-F839-45A7-A21B-7C897F5BC7DA',
'69597750-6901-4824-A8C8-A679D349DD16',
'3B4E444F-FF71-40DB-B4A5-D718EFBD2D43',
'7BCC223B-7F12-4CB1-A1ED-26D89BEECD3E',
'A0FCC468-644F-43A3-9408-DC1A85CE67FA',
'54DF8352-7D82-403E-A37B-A05923DC02C2',
'2CFE142C-E9BE-4ABE-A6E9-0DDBABE19D7C',
'985017C5-F505-42AC-AF23-94ACF03B38EA',
'27F0334C-1E69-4DBE-BBE9-BBF017329E50',
'E8DDF324-D82C-4FFB-A717-E9B2274C4E72',
'40A22A20-5340-4E30-A80D-0E6B66C872D2',
'B91DD792-4505-4023-B838-24F88070C8E0',
'9CC62B2D-77A3-4613-8DFB-E70B5E872DED',
'26370E1B-82B0-44FE-849C-97B0475097E9',
'4B79E1FB-7420-4243-AC52-BE1769615804',
'2D2CD785-4F29-4DAF-93D6-EF02523447FA',
'C30AA606-4A9B-420E-BFE4-1F50DBBC4F4E',
'C7F4D370-E787-4091-A436-726B594342E3',
'AE894AD6-AC80-4C41-B7BF-6A29919147F4',
'04801FB4-ED0A-4224-A85E-DCF29EC14071',
'F4B63FB2-7EAC-46A9-AB09-B3A9336F625C',
'7B3F4A2F-8FC6-4D94-A5E4-DD52616E84A8',
'48be8c40-f207-4fa7-92ae-e2266151606a',
'6F14CAC9-7A1D-4E20-81EB-C81506D1DE30',
'2e32a493-5bd8-49ad-ad52-f002a8f8d93b',
'b196a97c-89ee-4ede-bebf-9b5fd8acede5',
'AB553DB9-3B1C-4CA4-91C9-6831C5536E3F',
'3782D87C-9038-42D6-B28B-DFC1D04BEA95',
'05d26da6-3935-43d6-af77-8f37fc19197c',
'0AC330F3-A7F2-464B-A5BB-9D7667AA4B7A',
'4A513941-3BE1-441C-B7CE-32A35725C027',
'ec4b9723-d99a-47d9-a3ec-2126f32cd875', -- 10531
'96795c53-e3e8-4f07-bcbf-d6576056c29f', -- 10538
'A5DDF628-7940-4E3D-810C-6D394257406B', -- 10543
'5d821720-1cde-457f-a3ea-9772bbcfb894', -- 10546
'341adfb6-f398-4ac7-827b-7dbe719a9172', -- 10560
'17F81E36-38F0-496A-95FD-CAAF0327FF2B', -- 10562
'5727a46a-2fd0-48ae-93c2-4ed07315a6ff', -- 11001
'0393c0dd-e17d-49bf-b717-e3d552b292ee', -- 11018
'afbcf0f6-d948-4442-be28-b6c85c3059d4', -- 31903
'15DB630E-1904-458E-8EAD-29BE8687F211', -- 34004
'25068ADB-FF44-4C48-9F6B-645D3CB08DC3', -- 34005
'42F3F20C-24BE-450C-9D7E-6B6A14CEEB16', -- 34210
'4b838120-371b-430b-93a0-6e23c1be8ffa', -- 38746
'541e518f-013b-4944-be26-eb8e84bdb604', -- 38894
'DB872F30-DA02-4077-AC5D-6F302F0442BB', -- 38896
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'AFB5F48C-4F73-415E-B986-562E67C060A9', -- 38924
'238908D7-A3C3-4FEF-A108-1E24080DDEBB', -- 38995
'42A5D2A9-59A2-4D13-ACB9-AC041F8765E1', -- 39001
'A2E4CC53-BE34-4D1B-BFCE-C8D379095786', -- 39002
'2d17116a-3520-43f5-bcad-c8d803c481c0', -- 39103
'1498e5de-f80d-4285-aa71-0ff71a3e1e24', -- 39103
'895d57e3-e548-4eae-8379-98b9f6623d33', -- 39103
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'11e5a213-66ba-45ff-98ff-b9c5942d164a', -- 39237
'52666916-3613-43bc-b701-26f342a1813d', -- 39238
'c1d87100-ec8e-4e84-9a40-728885877d5d', -- 39617
'aa1f3c3f-3d4f-40a7-89fb-e551836f8403', -- 39672
'6766498d-0019-4511-9392-ac1c7133a2cd', -- 6252
'5374ab83-02fc-4663-b983-a1ec8e43b972' -- 6252
);

DELETE FROM application.application 
WHERE id IN (
'B01BA8A8-F839-45A7-A21B-7C897F5BC7DA',
'69597750-6901-4824-A8C8-A679D349DD16',
'3B4E444F-FF71-40DB-B4A5-D718EFBD2D43',
'7BCC223B-7F12-4CB1-A1ED-26D89BEECD3E',
'A0FCC468-644F-43A3-9408-DC1A85CE67FA',
'54DF8352-7D82-403E-A37B-A05923DC02C2',
'2CFE142C-E9BE-4ABE-A6E9-0DDBABE19D7C',
'985017C5-F505-42AC-AF23-94ACF03B38EA',
'27F0334C-1E69-4DBE-BBE9-BBF017329E50',
'E8DDF324-D82C-4FFB-A717-E9B2274C4E72',
'40A22A20-5340-4E30-A80D-0E6B66C872D2',
'B91DD792-4505-4023-B838-24F88070C8E0',
'9CC62B2D-77A3-4613-8DFB-E70B5E872DED',
'26370E1B-82B0-44FE-849C-97B0475097E9',
'4B79E1FB-7420-4243-AC52-BE1769615804',
'2D2CD785-4F29-4DAF-93D6-EF02523447FA',
'C30AA606-4A9B-420E-BFE4-1F50DBBC4F4E',
'C7F4D370-E787-4091-A436-726B594342E3',
'AE894AD6-AC80-4C41-B7BF-6A29919147F4',
'04801FB4-ED0A-4224-A85E-DCF29EC14071',
'F4B63FB2-7EAC-46A9-AB09-B3A9336F625C',
'7B3F4A2F-8FC6-4D94-A5E4-DD52616E84A8',
'48be8c40-f207-4fa7-92ae-e2266151606a',
'6F14CAC9-7A1D-4E20-81EB-C81506D1DE30',
'2e32a493-5bd8-49ad-ad52-f002a8f8d93b',
'b196a97c-89ee-4ede-bebf-9b5fd8acede5',
'AB553DB9-3B1C-4CA4-91C9-6831C5536E3F',
'3782D87C-9038-42D6-B28B-DFC1D04BEA95',
'05d26da6-3935-43d6-af77-8f37fc19197c',
'0AC330F3-A7F2-464B-A5BB-9D7667AA4B7A',
'4A513941-3BE1-441C-B7CE-32A35725C027',
'ec4b9723-d99a-47d9-a3ec-2126f32cd875', -- 10531
'96795c53-e3e8-4f07-bcbf-d6576056c29f', -- 10538
'A5DDF628-7940-4E3D-810C-6D394257406B', -- 10543
'5d821720-1cde-457f-a3ea-9772bbcfb894', -- 10546
'341adfb6-f398-4ac7-827b-7dbe719a9172', -- 10560
'17F81E36-38F0-496A-95FD-CAAF0327FF2B', -- 10562
'5727a46a-2fd0-48ae-93c2-4ed07315a6ff', -- 11001
'0393c0dd-e17d-49bf-b717-e3d552b292ee', -- 11018
'afbcf0f6-d948-4442-be28-b6c85c3059d4', -- 31903
'15DB630E-1904-458E-8EAD-29BE8687F211', -- 34004
'25068ADB-FF44-4C48-9F6B-645D3CB08DC3', -- 34005
'42F3F20C-24BE-450C-9D7E-6B6A14CEEB16', -- 34210
'4b838120-371b-430b-93a0-6e23c1be8ffa', -- 38746
'541e518f-013b-4944-be26-eb8e84bdb604', -- 38894
'DB872F30-DA02-4077-AC5D-6F302F0442BB', -- 38896
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'0674BD8E-3BFB-445A-A902-AE793BDA9DA4', -- 38923
'AFB5F48C-4F73-415E-B986-562E67C060A9', -- 38924
'238908D7-A3C3-4FEF-A108-1E24080DDEBB', -- 38995
'42A5D2A9-59A2-4D13-ACB9-AC041F8765E1', -- 39001
'A2E4CC53-BE34-4D1B-BFCE-C8D379095786', -- 39002
'2d17116a-3520-43f5-bcad-c8d803c481c0', -- 39103
'1498e5de-f80d-4285-aa71-0ff71a3e1e24', -- 39103
'895d57e3-e548-4eae-8379-98b9f6623d33', -- 39103
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'c3725b2f-f606-4dd9-81ab-d3097597b83d', -- 39165
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'7446ca7b-f632-4c13-97d8-62d366dca922', -- 39184
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'2a635263-1685-4b29-92d8-da465a3828ca', -- 39235
'11e5a213-66ba-45ff-98ff-b9c5942d164a', -- 39237
'52666916-3613-43bc-b701-26f342a1813d', -- 39238
'c1d87100-ec8e-4e84-9a40-728885877d5d', -- 39617
'aa1f3c3f-3d4f-40a7-89fb-e551836f8403', -- 39672
'6766498d-0019-4511-9392-ac1c7133a2cd', -- 6252
'5374ab83-02fc-4663-b983-a1ec8e43b972' -- 6252
); 

UPDATE application.application 
SET nr = nr || '(2)'
WHERE id IN ('3E8023C5-65AA-4C9A-BFDF-90C3A4EBCFCA',
'520ebb3c-59f0-4869-8080-05daaf939ae3',
'00FBE069-0E49-43E3-92A5-3927EEA3DBA1',
'e7472a92-5cb4-4f0d-b899-e3f434785538',
'a6a61ca6-9159-47e6-9f16-a00b2f52d5e1',
'ea463398-a756-4557-b672-fe3ff0f348ad', -- 10464
'a5d44c79-006f-4816-a683-f7463c946fb0', -- 10477
'6eb81040-34d6-4df1-ae97-ffb4868cf606', -- 10531
'7c783832-ff7c-452c-8ee3-dc4a7a9f1f96', -- 10546
'a467a0ae-f62a-4909-b275-2846abf0cae9', -- 10560
'193180fc-8d6b-4274-b531-ea25004ffcad', -- 34005
'230DF26C-88EA-45E8-9399-C671B869CDB5', -- 38894
'bb4ca3ee-e955-44f4-9ad4-e0bd8c22cf0f', -- 38923
'3c9a691b-889f-47c6-b835-0ec87dbc17d2', -- 39070
'deca1067-57d4-4911-b8ea-eee40781ec22', -- 39100
'55ca3d99-002b-4ce1-82b8-7ac21ebdfc48', -- 39120
'908a9c87-7073-4fe5-a29c-22ec5c181cae', -- 39235
'c2a559dc-6f34-461d-8b18-515c50efa647', -- 8013
'119244a6-91e5-4fc0-957d-db1b44ec5746' -- 8068
)
AND nr NOT LIKE '%(2)';

UPDATE application.application 
SET nr = nr || '(3)'
WHERE id IN ('362f1f1f-43b3-440c-b958-2f2ef125a0cc', -- 10463
'30512eed-6a22-483f-a615-afb72e7af850', -- 10464
'ac3003ee-a5b7-4556-8888-d7bb49cb8e78', -- 10477
'7046ef97-27ad-46c5-b56b-1dbd2ef66e62', -- 10531
'dcb844e0-3e11-48f6-913d-653b79c08a6a', -- 10546
'039ef2df-67c9-4ded-aa35-eb417db8b15e', -- 8013
'95611db3-f361-40dc-a57e-c8bf6d90a449' -- 8068
)
AND nr NOT LIKE '%(3)';

UPDATE application.application 
SET nr = nr || '(4)'
WHERE id IN ('5c629c9d-693f-4f77-961d-f11860b42154', -- 10464
'ddb6733c-16ab-4d1f-8ee3-ac2b898849f9', -- 10477
'2ed5fab8-673b-4f83-881d-3fcd695d2342' -- 10531
)
AND nr NOT LIKE '%(4)';

UPDATE application.application 
SET nr = nr || '(5)'
WHERE id IN ('4e5b359c-8886-4255-9e35-8f8e1243b826' -- 10531
)
AND nr NOT LIKE '%(5)';

UPDATE application.application 
SET nr = nr || '(6)'
WHERE id IN ('28100467-a6f1-4670-8053-bd159fb77cdf' -- 10531
)
AND nr NOT LIKE '%(6)';


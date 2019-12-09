library UseofHighRiskMedicationsintheElderly version '8.3.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers


//include MATGlobalCommonFunctions version '4.0.000' called Global
//include Hospice version '2.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "Acetaminophen / Butalbital": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1317'
valueset "Acetaminophen / Butalbital / Caffeine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1363'
valueset "Acetaminophen / Butalbital / Caffeine / Codeine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1326'
valueset "Acetaminophen / Chlorpheniramine / Dextromethorphan": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1421'
valueset "Acetaminophen / Chlorpheniramine / Dextromethorphan / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1310'
valueset "Acetaminophen / Chlorpheniramine / Dextromethorphan / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1321'
valueset "Acetaminophen / Chlorpheniramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1328'
valueset "Acetaminophen / Chlorpheniramine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1316'
valueset "Acetaminophen / Dexbrompheniramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1405'
valueset "Acetaminophen / Dextromethorphan / Diphenhydramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1399'
valueset "Acetaminophen / Dextromethorphan / Doxylamine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1338'
valueset "Acetaminophen / Dextromethorphan / Doxylamine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1287'
valueset "Acetaminophen / Diphenhydramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1350'
valueset "Acetaminophen / Diphenhydramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1318'
valueset "Amitriptyline  /  Chlordiazepoxide": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1286'
valueset "Amitriptyline / Perphenazine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1428'
valueset "Amitriptyline Hydrochloride": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1373'
valueset "Amoxapine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1273'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Anti Infectives, other": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1481'
valueset "Aspirin / Butalbital / Caffeine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1347'
valueset "Aspirin / Caffeine / Orphenadrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1302'
valueset "Atropine / Diphenoxylate": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1274'
valueset "Atropine / Hyoscyamine / Phenobarbital / Scopolamine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1355'
valueset "Benztropine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1361'
valueset "Brompheniramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1427'
valueset "Brompheniramine / Codeine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1409'
valueset "Brompheniramine / Codeine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1450'
valueset "Brompheniramine / Dextromethorphan / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1325'
valueset "Brompheniramine / Dextromethorphan / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1339'
valueset "Brompheniramine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1332'
valueset "Butabarbital": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1402'
valueset "Carbinoxamine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1306'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Carisoprodol": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1369'
valueset "Chlophedianol / Chlorpheniramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1412'
valueset "Chlophedianol / Dexchlorpheniramine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1447'
valueset "Chlorpheniramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1352'
valueset "Chlorpheniramine / Dextromethorphan / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1312'
valueset "Chlorpheniramine / Dextromethorphan / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1337'
valueset "Chlorpheniramine / Hydrocodone": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1330'
valueset "Chlorpheniramine / Hydrocodone / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1299'
valueset "Chlorpheniramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1343'
valueset "Chlorpheniramine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1315'
valueset "Chlorpropamide": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1303'
valueset "Chlorzoxazone": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1362'
valueset "Clemastine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1308'
valueset "Clomipramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1336'
valueset "Conjugated Estrogens": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1357'
valueset "Conjugated Estrogens / Medroxyprogesterone": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1324'
valueset "Cyclobenzaprine Hydrochloride": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1372'
valueset "Cyproheptadine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1277'
valueset "Desiccated Thyroid": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1354'
valueset "Desipramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1278'
valueset "Dexbrompheniramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1375'
valueset "Dexbrompheniramine / Dextromethorphan / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1426'
valueset "Dexbrompheniramine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1430'
valueset "Dexbrompheniramine Maleate / Pseudoephedrine Hydrochloride": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1429'
valueset "Dexchlorpheniramine / Dextromethorphan / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1300'
valueset "Dexchlorpheniramine / Pseudoephedrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1425'
valueset "Dextromethorphan / Diphenhydramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1397'
valueset "Dextromethorphan / Doxylamine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1452'
valueset "Dicyclomine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1279'
valueset "Dienogest / Estradiol Multiphasic": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1398'
valueset "Dimenhydrinate": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1500'
valueset "Diphenhydramine / Ibuprofen": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1293'
valueset "Diphenhydramine / Phenylephrine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1307'
valueset "Diphenhydramine Hydrochloride": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1371'
valueset "Dipyridamole": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1349'
valueset "Discharge Services - Nursing Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Disopyramide": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1311'
valueset "Drospirenone / Estradiol": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1410'
valueset "Esterified Estrogens": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1419'
valueset "Esterified Estrogens / Methyltestosterone": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1320'
valueset "Estradiol": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1365'
valueset "Estradiol / Norethindrone": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1323'
valueset "Estropipate": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1319'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Glyburide": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1368'
valueset "Glyburide / Metformin": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1360'
valueset "Guanfacine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1341'
valueset "High Risk Medications for the Elderly": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1253'
valueset "High-Risk Medications With Days Supply Criteria": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1254'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hydrochlorothiazide / Methyldopa": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1414'
valueset "Hydroxyzine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1374'
valueset "Hyoscyamine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1501'
valueset "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1503'
valueset "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl / Sodium Biphosphate": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1504'
valueset "Hyoscyamine / Methenamine / Mblue / Sodium Biphosphate": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1505'
valueset "Imipramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1359'
valueset "Indomethacin": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1366'
valueset "Isoxsuprine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1422'
valueset "Ketorolac Tromethamine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1364'
valueset "List of Single RxNorm Code Concepts for High Risk Drugs for the Elderly": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1272'
valueset "Meclizine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1506'
valueset "Megestrol": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1342'
valueset "Meperidine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1351'
valueset "Meprobamate": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1284'
valueset "Metaxalone": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1358'
valueset "Methocarbamol": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1370'
valueset "Methyldopa": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1331'
valueset "Nifedipine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1353'
valueset "Nonbenzodiazepine hypnotics": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1480'
valueset "Nortriptyline": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1507'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmologic Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.11.1206'
valueset "Paroxetine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1508'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Phenobarbital": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1348'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Promethazine Hydrochloride": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1367'
valueset "Protriptyline": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1509'
valueset "Pseudoephedrine / Triprolidine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1345'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Trihexyphenidyl": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1334'
valueset "Trimipramine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1285'
valueset "Triprolidine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1408'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Denominator":
	"Initial Population"

define "Denominator Exclusions":
	"Has Hospice"

define "AntiInfectives During Measurement Period":
	[MedicationRequest: "Anti Infectives, other"] AntiInfectives
		where AntiInfectives.dispenseRequest.validityPeriod during "Measurement Period"

define "Hypnotics During Measurement Period":
	[MedicationRequest: "Nonbenzodiazepine hypnotics"] Hypnotics
		where Hypnotics.dispenseRequest.validityPeriod during "Measurement Period"

define "High Risk Medications With Prolonged Duration":
	( [MedicationRequest: "High-Risk Medications With Days Supply Criteria"] HighRiskMedicationOrder
			where duration in days of HighRiskMedicationOrder.dispenseRequest.expectedSupplyDuration >= 90
				and HighRiskMedicationOrder.dispenseRequest.validityPeriod during "Measurement Period"
	)

define "Numerator2":
	exists ( "Same High Risk Medications Ordered on Different Days" )
		or ( "Two High Risk Medications With Prolonged Duration" )

define "Order for High Risk Medication":
	[MedicationRequest: "High Risk Medications for the Elderly"] HighRiskMedicationOrder
		where FHIRHelpers.HighRiskMedicationOrder.authoredOn during "Measurement Period"

define "Numerator1":
	exists ( "Order for High Risk Medication" )
		or exists ( "High Risk Medications With Prolonged Duration" )

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Ophthalmologic Services"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Discharge Services - Nursing Facility"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Initial Population":
	exists(AgeInYearsAt(start of "Measurement Period") >= 65)
			and exists ( "Qualifying Encounters" )

define "Same High Risk Medications Ordered on Different Days":
	( from
			[MedicationRequest: "List of Single RxNorm Code Concepts for High Risk Drugs for the Elderly"] MedicationOrder1,
			[MedicationRequest: "List of Single RxNorm Code Concepts for High Risk Drugs for the Elderly"] MedicationOrder2
			where MedicationOrder1.authoredOn during "Measurement Period"
				and MedicationOrder2.authoredOn during "Measurement Period"
				and MedicationOrder1.authoredOn 1 day or more after MedicationOrder2.authorDatetime
				and MedicationOrder1.medication ~ MedicationOrder2.medication
			return MedicationOrder1
	)
	
	//Acetaminophen / Butalbital
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Butalbital"])
	
	//Acetaminophen / Butalbital / Caffeine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Butalbital / Caffeine"])
	
	//Acetaminophen / Butalbital / Caffeine / Codeine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Butalbital / Caffeine / Codeine"])
	
	//Acetaminophen / Chlorpheniramine / Dextromethorphan
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Dextromethorphan"])
	
	//Acetaminophen / Chlorpheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Dextromethorphan / Phenylephrine"])
	
	//Acetaminophen / Chlorpheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Dextromethorphan / Pseudoephedrine"])
	
	//Acetaminophen / Chlorpheniramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Phenylephrine"])
	
	//Acetaminophen / Chlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Pseudoephedrine"])
	
	//Acetaminophen / Dexbrompheniramine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dexbrompheniramine"])
	
	//Acetaminophen / Dextromethorphan / Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dextromethorphan / Diphenhydramine / Phenylephrine"])
	
	//Acetaminophen / Dextromethorphan / Doxylamine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dextromethorphan / Doxylamine"])
	
	//Acetaminophen / Dextromethorphan / Doxylamine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dextromethorphan / Doxylamine / Phenylephrine"])	
	
	//Acetaminophen / Diphenhydramine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Diphenhydramine"])
	
	//Acetaminophen / Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Diphenhydramine / Phenylephrine"])
	
	
	//Amitriptyline / Chlordiazepoxide
		union "More than 1 Of"([MedicationRequest: "Amitriptyline  /  Chlordiazepoxide"])	
	
	//Amitriptyline / Perphenazine
		union "More than 1 Of"([MedicationRequest: "Amitriptyline / Perphenazine"])
	
	//Amitriptyline Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Amitriptyline Hydrochloride"])
	
	//Aspirin / Butalbital / Caffeine
		union "More than 1 Of"([MedicationRequest: "Aspirin / Butalbital / Caffeine"])
	
	//Amoxapine
		union "More than 1 Of"([MedicationRequest: "Amoxapine"])	
	
	//Aspirin / Caffeine / Orphenadrine
		union "More than 1 Of"([MedicationRequest: "Aspirin / Caffeine / Orphenadrine"])
	
	//Atropine / Hyoscyamine / Phenobarbital / Scopolamine
		union "More than 1 Of"([MedicationRequest: "Atropine / Hyoscyamine / Phenobarbital / Scopolamine"])
	
	//Atropine / Diphenoxylate 
		union "More than 1 Of"([MedicationRequest: "Atropine / Diphenoxylate"])
	
	//Benztropine
		union "More than 1 Of"([MedicationRequest: "Benztropine"])
	
	//Brompheniramine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine"])
	
	
	//Brompheniramine / Codeine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Codeine / Phenylephrine"])
	
	//Brompheniramine / Codeine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Codeine / Pseudoephedrine"])
	
	//Brompheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Dextromethorphan / Phenylephrine"])
	
	//Brompheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Dextromethorphan / Pseudoephedrine"])
	        
	
	//Brompheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Pseudoephedrine"])
	
	//Butabarbital
		union "More than 1 Of"([MedicationRequest: "Butabarbital"])
	
	//Carbinoxamine
		union "More than 1 Of"([MedicationRequest: "Carbinoxamine"])
	
	//Carisoprodol
		union "More than 1 Of"([MedicationRequest: "Carisoprodol"])
	
	//Chlophedianol / Chlorpheniramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Chlophedianol / Chlorpheniramine / Phenylephrine"])
	
	//Chlophedianol / Dexchlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlophedianol / Dexchlorpheniramine / Pseudoephedrine"])
	
	//Chlorpheniramine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine"])
	
	//Chlorpheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Dextromethorphan / Phenylephrine"])
	
	//Chlorpheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Dextromethorphan / Pseudoephedrine"])
	
	
	//Chlorpheniramine / Hydrocodone
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Hydrocodone"])
	
	//Chlorpheniramine / Hydrocodone / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Hydrocodone / Pseudoephedrine"])
	
	//Chlorpheniramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Phenylephrine"])
	
	//Chlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Pseudoephedrine"])
	
	//Chlorpropamide
		union "More than 1 Of"([MedicationRequest: "Chlorpropamide"])
	
	//Chlorzoxazone
		union "More than 1 Of"([MedicationRequest: "Chlorzoxazone"])
	
	//Clemastine
		union "More than 1 Of"([MedicationRequest: "Clemastine"])
	
	//Clomipramine
		union "More than 1 Of"([MedicationRequest: "Clomipramine"])
	
	//Conjugated Estrogens
		union "More than 1 Of"([MedicationRequest: "Conjugated Estrogens"])
	
	//Conjugated Estrogens / Medroxyprogesterone
		union "More than 1 Of"([MedicationRequest: "Conjugated Estrogens / Medroxyprogesterone"])
	
	//Cyclobenzaprine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Cyclobenzaprine Hydrochloride"])
	
	//Cyproheptadine
		union "More than 1 Of"([MedicationRequest: "Cyproheptadine"])
	
	//Desiccated Thyroid
		union "More than 1 Of"([MedicationRequest: "Desiccated Thyroid"])
	
	//Desipramine
		union "More than 1 Of"([MedicationRequest: "Desipramine"])
	
	//Dexbrompheniramine
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine"])
	
	//Dexbrompheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine / Dextromethorphan / Phenylephrine"])
	
	//Dexbrompheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine / Pseudoephedrine"])
	
	//Dexbrompheniramine Maleate / Pseudoephedrine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine Maleate / Pseudoephedrine Hydrochloride"])
	
	//Dexchlorpheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Dexchlorpheniramine / Dextromethorphan / Pseudoephedrine"])
	
	//Dexchlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Dexchlorpheniramine / Pseudoephedrine"])
	
	//Dextromethorphan / Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Dextromethorphan / Diphenhydramine / Phenylephrine"])
	
	//Dextromethorphan / Doxylamine
		union "More than 1 Of"([MedicationRequest: "Dextromethorphan / Doxylamine"])
	
	//Dicyclomine
		union "More than 1 Of"([MedicationRequest: "Dicyclomine"])
	
	//Dienogest / Estradiol Multiphasic
		union "More than 1 Of"([MedicationRequest: "Dienogest / Estradiol Multiphasic"])
	
	//Dimenhydrinate
		union "More than 1 Of"([MedicationRequest: "Dimenhydrinate"])
	
	//Diphenhydramine / Ibuprofen
		union "More than 1 Of"([MedicationRequest: "Diphenhydramine / Ibuprofen"])
	
	//Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Diphenhydramine / Phenylephrine"])
	
	//Diphenhydramine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Diphenhydramine Hydrochloride"])
	
	//Dipyridamole
		union "More than 1 Of"([MedicationRequest: "Dipyridamole"])
	
	//Disopyramide
		union "More than 1 Of"([MedicationRequest: "Disopyramide"])
	
	//Drospirenone / Estradiol
		union "More than 1 Of"([MedicationRequest: "Drospirenone / Estradiol"])
	
	//Esterified Estrogens
		union "More than 1 Of"([MedicationRequest: "Esterified Estrogens"])
	
	//Esterified Estrogens / Methyltestosterone
		union "More than 1 Of"([MedicationRequest: "Esterified Estrogens / Methyltestosterone"])
	
	//Estradiol
		union "More than 1 Of"([MedicationRequest: "Estradiol"])
	
	//Estradiol / Norethindrone
		union "More than 1 Of"([MedicationRequest: "Estradiol / Norethindrone"])
	
	//Estropipate
		union "More than 1 Of"([MedicationRequest: "Estropipate"])
	
	//Glyburide
		union "More than 1 Of"([MedicationRequest: "Glyburide"])
	
	//Glyburide / Metformin
		union "More than 1 Of"([MedicationRequest: "Glyburide / Metformin"])
	
	//Guanfacine
		union "More than 1 Of"([MedicationRequest: "Guanfacine"])
	
	//Hydrochlorothiazide / Methyldopa
		union "More than 1 Of"([MedicationRequest: "Hydrochlorothiazide / Methyldopa"])
	
	//Hydroxyzine
		union "More than 1 Of"([MedicationRequest: "Hydroxyzine"])
	
	//Hyoscyamine
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine"])
	
	//Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl
		union "More than 1 Of"([MedicationRequest : "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl"])
	
	//Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl / Sodium Biphosphate
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl / Sodium Biphosphate"])
	
	//Hyoscyamine / Methenamine / Mblue / Sodium Biphosphate
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine / Methenamine / Mblue / Sodium Biphosphate"])
	
	//Imipramine
		union "More than 1 Of"([MedicationRequest: "Imipramine"])
	
	//Indomethacin
		union "More than 1 Of"([MedicationRequest: "Indomethacin"])
	
	//Isoxsuprine
		union "More than 1 Of"([MedicationRequest: "Isoxsuprine"])
	
	//Ketorolac Tromethamine
		union "More than 1 Of"([MedicationRequest: "Ketorolac Tromethamine"])
	
	//Meclizine
		union "More than 1 Of"([MedicationRequest: "Meclizine"])
	
	//Megestrol
		union "More than 1 Of"([MedicationRequest: "Megestrol"])
	
	//Meperidine
		union "More than 1 Of"([MedicationRequest: "Meperidine"])
	
	//Meprobamate
		union "More than 1 Of"([MedicationRequest: "Meprobamate"])
	
	//Metaxalone
		union "More than 1 Of"([MedicationRequest: "Metaxalone"])
	
	//Methocarbamol
		union "More than 1 Of"([MedicationRequest: "Methocarbamol"])
	
	//Methyldopa
		union "More than 1 Of"([MedicationRequest: "Methyldopa"])
	
	//Nifedipine
		union "More than 1 Of"([MedicationRequest: "Nifedipine"])
	
	//Nortriptyline
		union "More than 1 Of"([MedicationRequest: "Nortriptyline"])
	
	//Paroxetine
		union "More than 1 Of"([MedicationRequest: "Paroxetine"])
	
	//Phenobarbital
		union "More than 1 Of"([MedicationRequest: "Phenobarbital"])
	
	//Promethazine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Promethazine Hydrochloride"])
	
	//Protriptyline
		union "More than 1 Of"([MedicationRequest: "Protriptyline"])
	
	//Pseudoephedrine / Triprolidine
		union "More than 1 Of"([MedicationRequest: "Pseudoephedrine / Triprolidine"])
	
	//Trihexyphenidyl
		union "More than 1 Of"([MedicationRequest: "Trihexyphenidyl"])
	
	//Trimipramine
		union "More than 1 Of"([MedicationRequest: "Trimipramine"])
	
	//Triprolidine
		union "More than 1 Of"([MedicationRequest: "Triprolidine"])

define "More than One AntiInfective Order":
	//Anti Infectives, other
	exists ( "More than 1 Of"([MedicationRequest: "Anti Infectives, other"]))

define "More than One Nonbenzodiazepine Hypnotics Order":
	//Nonbenzodiazepine hypnotics
	exists ( "More than 1 Of"([MedicationRequest: "Nonbenzodiazepine hypnotics"]))

define "Two High Risk Medications With Prolonged Duration":
	( "Cumulative Medication Duration"("AntiInfectives During Measurement Period")>= 90
			and "More than One AntiInfective Order"
	)
		or ( "Cumulative Medication Duration"("Hypnotics During Measurement Period")>= 90
				and "More than One Nonbenzodiazepine Hypnotics Order"
		)

define function "Cumulative Medication Duration"(Medication List<"MedicationRequest">):
	Sum((collapse(Medication.dispenseRequest.expectedSupplyDuration))CumulativeDosages
			return all duration in days of CumulativeDosages
	)

define function "More than 1 Of"(Medication List<"MedicationRequest">):
	"Medication" OrderMedication1
		with "Medication" OrderMedication2
			such that OrderMedication1.authoredOn 1 day or more after OrderMedication2.authorDatetime
				and OrderMedication1.authoredOn during "Measurement Period"
				and OrderMedication2.authoredOn during "Measurement Period"
		return OrderMedication1
		
define "Has Hospice":

            exists ( [Encounter: "Encounter Inpatient"] DischargeHospice
            		where (DischargeHospice.status='in-progress' or DischargeHospice.status='finished')
            		    and (
			        FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition).codes[0] ~ "Discharge to home for hospice care (procedure)"
					    or FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition).codes[0] ~ "Discharge to healthcare facility for hospice care (procedure)"
			    )
            			and DischargeHospice.period ends during "Measurement Period"
                )
            	or exists ( [ServiceRequest: "Hospice care ambulatory"] HospiceOrder
            			where HospiceOrder.intent= 'order'
				and FHIRHelpers.ToDateTime(HospiceOrder.authoredOn) during "Measurement Period"
            	)
            	or exists ( [Procedure: "Hospice care ambulatory"] HospicePerformed
            			where (HospicePerformed.performed as Period) overlaps "Measurement Period"
            	)
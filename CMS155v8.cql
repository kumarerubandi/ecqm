library WeightAssessmentandCounselingforNutritionandPhysicalActivityforChildrenandAdolescents version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

include MATGlobalCommonFunctions version '4.0.000' called Global
include Hospice version '2.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "BMI percentile": 'urn:oid:2.16.840.1.113883.3.464.1003.121.12.1012'
valueset "Counseling for Nutrition": 'urn:oid:2.16.840.1.113883.3.464.1003.195.12.1003'
valueset "Counseling for Physical Activity": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1035'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Height": 'urn:oid:2.16.840.1.113883.3.464.1003.121.12.1014'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.526.3.378'
valueset "Preventive Care - Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care- Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Weight": 'urn:oid:2.16.840.1.113883.3.464.1003.121.12.1015'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Numerator 1":
	exists ( "BMI Percentile in Measurement Period" )
		and exists ( "Height in Measurement Period" )
		and exists ( "Weight in Measurement Period" )

define "Weight in Measurement Period":
	[Observation: "Weight"] Weight
		where (Weight.effective as Period) during "Measurement Period"
			and Weight.value is not null

define "Qualifying Encounter":
	( [ Encounter: "Office Visit"]
		union [ Encounter: "Preventive Care Services-Individual Counseling"]
		union [ Encounter: "Preventive Care - Established Office Visit, 0 to 17"]
		union [ Encounter: "Preventive Care- Initial Office Visit, 0 to 17"]
		union [ Encounter: "Preventive Care Services - Group Counseling"]
		union [ Encounter: "Home Healthcare Services"] ) ValidEncounter
		where ValidEncounter.period during "Measurement Period"
		
define "Pregnancy Diagnosis Which Overlaps Measurement Period":
	[Condition: "Pregnancy"] Pregnancy
		where (Pregnancy.onset as Period) overlaps "Measurement Period"

define "Height in Measurement Period":
	[Observation: "Height"] Height
		where (Height.effective as Period) during "Measurement Period"
			and Height.value is not null

define "Denominator Exclusions":
	Hospice.Has Hospice
		or exists ( "Pregnancy Diagnosis Which Overlaps Measurement Period" )

define "Numerator 2":
	exists [Procedure: "Counseling for Nutrition"] NutritionCounseling
		where (NutritionCounseling.performed as Period) during "Measurement Period"

define "Numerator 3":
	exists [Procedure: "Counseling for Physical Activity"] ActivityCounseling
		where (ActivityCounseling.performed as Period) during "Measurement Period"

define "BMI Percentile in Measurement Period":
	[Observation: "BMI percentile"] BMIPercentile
		where (BMIPercentile.effective as Period) during "Measurement Period"
			and BMIPercentile.value is not null

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period") >= 3 and AgeInYearsAt(start of "Measurement Period") < 17



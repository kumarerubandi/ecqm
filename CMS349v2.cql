library HIVScreening version '2.9.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Conditions Due To Human Immunodeficiency Virus (HIV)": 'urn:oid:2.16.840.1.113762.1.4.1056.54'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Human Immunodeficiency Virus (HIV) Laboratory Test Codes (Ab and Ag)": 'urn:oid:2.16.840.1.113762.1.4.1056.50'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "HIV 1 and 2 tests - Meaningful Use set": '75622-1' from "LOINC" display 'HIV 1 and 2 tests - Meaningful Use set'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Qualifying Encounters":
	( [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Office Visit"] ) Encounter
		where (Encounter.status='in-progress' or Encounter.status='finished')
		    and Encounter.period during "Measurement Period"

define "Denominator":
	"Initial Population"

define "Denominator Exclusions":
	exists ( [Condition: "Conditions Due To Human Immunodeficiency Virus (HIV)"] HIVConditions
			where HIVConditions.clinicalStatus.coding[0].code='active'
			and Interval[FHIRHelpers.ToDateTime(HIVConditions.onset),FHIRHelpers.ToDateTime(HIVConditions.abatement)] starts before start of "Measurement Period"
	)

define "Numerator":
	exists ( "HIV Test Performed" )

define "HIV Test Performed":
  ( [Observation: "Human Immunodeficiency Virus (HIV) Laboratory Test Codes (Ab and Ag)"]
		union [Observation: "HIV 1 and 2 tests - Meaningful Use set"] ) HIVTest
		where AgeInYearsAt(start of (HIVTest.effective as Period))>= 15
					and AgeInYearsAt(start of (HIVTest.effective as Period))< 66
			    and (HIVTest.effective as Period) starts before end of "Measurement Period"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 15
  and AgeInYearsAt(start of "Measurement Period")< 66
  and exists "Qualifying Encounters"
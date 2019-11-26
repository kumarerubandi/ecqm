library PrimaryCariesPreventionInterventionasOfferedbyPrimaryCareProvidersincludingDentists version '9.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Clinical Oral Evaluation": 'urn:oid:2.16.840.1.113883.3.464.1003.125.12.1003'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fluoride Varnish Application for Children": 'urn:oid:2.16.840.1.113883.3.464.1003.125.12.1002'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care - Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care- Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Birth date":'21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMED-CT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMED-CT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Numerator":
	exists [Procedure: "Fluoride Varnish Application for Children"] FluorideApplication
		where FluorideApplication.status='completed' and (FluorideApplication.performed as Period) during "Measurement Period"

define "Denominator":
	"Initial Population"

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Preventive Care - Established Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care- Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Clinical Oral Evaluation"] ) ValidEncounter
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Denominator Exclusions":
	"Has Hospice"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")< 20
			and exists "Qualifying Encounters"

define "Stratification 1":
	AgeInYearsAt(start of "Measurement Period")<= 4

define "Stratification 2":
	AgeInYearsAt(start of "Measurement Period")>= 5
			and AgeInYearsAt(start of "Measurement Period")<= 11

define "Stratification 3":
	AgeInYearsAt(start of "Measurement Period")>= 12
			and AgeInYearsAt(start of "Measurement Period")< 20

define "Has Hospice":

            exists ( [Encounter: "Encounter Inpatient"] DischargeHospice
            		where (DischargeHospice.status='in-progress' or DischargeHospice.status='finished')
            		    and (( FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition) in "Discharge to home for hospice care (procedure)"
            				or FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition) in "Discharge to healthcare facility for hospice care (procedure)")
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
library AppropriateTreatmentforChildrenwithUpperRespiratoryInfectionURI version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Antibiotic Medications for Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1001'
valueset "Competing Conditions for Respiratory Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1017'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Observation Care - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Upper Respiratory Infection": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1022'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMED-CT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMED-CT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Qualifying Encounter":
	( [Encounter: "Office Visit"]
		union [Encounter: "Emergency Department Visit"]
		union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
		union [Encounter: "Hospital Observation Care - Initial"] ) ValidEncounter
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
					and ValidEncounter.period during "Measurement Period"

define "In Hospice":
	"Initial Population" InitialPopulation
		where "Has Hospice"

define "Encounter with Upper Respiratory Infection":
	from
		"Qualifying Encounter" QualifyingEncounter,
		[Condition: "Upper Respiratory Infection"] URI
		where URI.clinicalStatus.coding[0].code='active'
					and (Interval[FHIRHelpers.ToDateTime(URI.onset),FHIRHelpers.ToDateTime(URI.abatement)] starts during QualifyingEncounter.period
			      or Interval[FHIRHelpers.ToDateTime(URI.onset),FHIRHelpers.ToDateTime(URI.abatement)] overlaps before QualifyingEncounter.period)

define "Encounter with Competing Diagnosis for Upper Respiratory Infection":
	( "Encounter with Upper Respiratory Infection" EncounterWithURI
			with [Condition: "Competing Conditions for Respiratory Conditions"] CompetingCondition
				such that CompetingCondition.clinicalStatus.coding[0].code='active'
					and Interval[FHIRHelpers.ToDateTime(CompetingCondition.onset),FHIRHelpers.ToDateTime(CompetingCondition.abatement)] starts 3 days or less after day of start of EncounterWithURI.QualifyingEncounter.period
			return EncounterWithURI.QualifyingEncounter
	)

define "Numerator":
	"Encounter with Upper Respiratory Infection" EncounterWithURI
		without [MedicationRequest: "Antibiotic Medications for Pharyngitis"] OrderedAntibiotic
			such that OrderedAntibiotic.intent='order'
        and FHIRHelpers.ToDateTime(OrderedAntibiotic.authoredOn) 3 days or less on or after start of EncounterWithURI.QualifyingEncounter.period
		return EncounterWithURI.QualifyingEncounter

define "Denominator Exclusions":
	"In Hospice"
		union "Encounter with Upper Respiratory Infection and Antibiotics Active 30 Days Prior"
		union "Encounter with Competing Diagnosis for Upper Respiratory Infection"

define "Encounter with Upper Respiratory Infection and Antibiotics Active 30 Days Prior":
	"Encounter with Upper Respiratory Infection" EncounterWithURI
		with [MedicationStatement: "Antibiotic Medications for Pharyngitis"] ActiveAntibiotic
			such that ActiveAntibiotic.status='active'
        and (ActiveAntibiotic.effective as Period) overlaps Interval["ToDate"((start of Interval[FHIRHelpers.ToDateTime(EncounterWithURI.URI.onset),FHIRHelpers.ToDateTime(EncounterWithURI.URI.abatement)])- 30 days), start of Interval[FHIRHelpers.ToDateTime(EncounterWithURI.URI.onset),FHIRHelpers.ToDateTime(EncounterWithURI.URI.abatement)]]
		return EncounterWithURI.QualifyingEncounter

define "Initial Population":
	"Encounter with Upper Respiratory Infection" EncounterWithURI
		where AgeInYearsAt(start of "Measurement Period")>= 3
				and AgeInYearsAt(start of "Measurement Period")< 18
		return EncounterWithURI.QualifyingEncounter

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

define function "ToDate"(Value DateTime ):
	DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezone from Value)

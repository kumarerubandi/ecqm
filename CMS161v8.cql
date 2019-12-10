library AdultMajorDepressiveDisorderMDDSuicideRiskAssessment version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Major Depressive Disorder-Active": 'urn:oid:2.16.840.1.113883.3.526.3.1491'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'urn:oid:2.16.840.1.113883.3.526.3.1141'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telehealth Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1031'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Suicide risk assessment (procedure)": '225337009' from "SNOMED-CT" display 'Suicide risk assessment (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "New or Recurrent Major Depressive Disorder Encounter":
	"Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
		without "Major Depressive Disorder Encounter" PriorMDDEpisodeEncounter
			such that PriorMDDEpisodeEncounter !~ NewOrRecurrentMDDEncounter
				and PriorMDDEpisodeEncounter.period ends 104 days or less before day of start of NewOrRecurrentMDDEncounter.period
		where NewOrRecurrentMDDEncounter.period during "Measurement Period"

define "Major Depressive Disorder Encounter":
	( [Encounter: "Psych Visit - Diagnostic Evaluation"]
		union [Encounter: "Emergency Department Visit"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"]
		union [Encounter: "Psych Visit - Psychotherapy"]
		union [Encounter: "Psychoanalysis"]
		union [Encounter: "Telehealth Services"] ) ValidEncounter
		with ([Condition:"Major Depressive Disorder-Active"]C where C.clinicalStatus.coding[0].code='active')Condition
		such that (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		    and exists (
                ValidEncounter.diagnosis.condition Condition
                    where EndsWith(Condition.reference, Condition.id)
            )

define "Numerator":
	"New or Recurrent Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
		with ([Procedure]O where FHIRHelpers.ToConcept(O.code).codes[0] ~ "Suicide risk assessment (procedure)") SuicideRiskAssessment
			such that (SuicideRiskAssessment.performed as Period) during NewOrRecurrentMDDEncounter.period

define "Initial Population":
	"New or Recurrent Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
		where AgeInYearsAt(start of "Measurement Period")>= 17


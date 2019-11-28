library DementiaCognitiveAssessment version '8.0.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Behavioral/Neuropsych Assessment": 'urn:oid:2.16.840.1.113883.3.526.3.1023'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Cognitive Assessment": 'urn:oid:2.16.840.1.113883.3.526.3.1332'
valueset "Dementia & Mental Degenerations": 'urn:oid:2.16.840.1.113883.3.526.3.1005'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Occupational Therapy Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Standardized Tools for Assessment of Cognition": 'urn:oid:2.16.840.1.113883.3.526.3.1006'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Patient Reason for Not Performing Assessment of Cognition Using Standardized Tools":
	[Observation: "Standardized Tools for Assessment of Cognition"] NoCognitiveAssessmentUsingTools
		with "Dementia Encounter" EncounterDementia
			such that start of (NoCognitiveAssessmentUsingTools.effective as Period) during EncounterDementia.period
		where (NoCognitiveAssessmentUsingTools.status = 'cancelled' or NoCognitiveAssessmentUsingTools.status = 'entered-in-error')
					and NoCognitiveAssessmentUsingTools.dataAbsentReason in "Patient Reason"

define "Assessment of Cognition Using Standardized Tools":
	[Observation: "Standardized Tools for Assessment of Cognition"] CognitiveAssessmentUsingTools
		with "Dementia Encounter" EncounterDementia
			such that start of (CognitiveAssessmentUsingTools.effective as Period) 12 months or less on or before day of
			end of EncounterDementia.period
		where CognitiveAssessmentUsingTools.value is not null

define "Cognitive Assessment Using Alternate Methods":
	[Procedure: "Cognitive Assessment"] CognitiveAssessment
		with "Dementia Encounter" EncounterDementia
			such that (CognitiveAssessment.performed as Period) starts 12 months or less on or before day of
			end of EncounterDementia.period

define "Denominator":
	"Initial Population"

define "Denominator Exceptions":
	exists "Patient Reason for Not Performing Assessment of Cognition Using Standardized Tools"
		or exists "Patient Reason for Not Performing Cognitive Assessment Using Alternate Methods"

define "Face to Face Encounter During Measurement Period":
	( [Encounter: "Psych Visit - Diagnostic Evaluation"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Psych Visit - Psychotherapy"]
		union [Encounter: "Behavioral/Neuropsych Assessment"]
		union [Encounter: "Occupational Therapy Evaluation"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"] ) FaceToFaceEncounter
		where (FaceToFaceEncounter.status='in-progress' or FaceToFaceEncounter.status='finished')
		            and FaceToFaceEncounter.period during "Measurement Period"

define "Numerator":
	exists "Assessment of Cognition Using Standardized Tools"
		or exists "Cognitive Assessment Using Alternate Methods"

define "Patient Reason for Not Performing Cognitive Assessment Using Alternate Methods":
	[Procedure: "Cognitive Assessment"] NoCognitiveAssessmentUsingAlternateMethods
		with "Dementia Encounter" EncounterDementia
			such that start of (NoCognitiveAssessmentUsingAlternateMethods.performed as Period) during EncounterDementia.period
		where NoCognitiveAssessmentUsingAlternateMethods.status='not-done'
			    and NoCognitiveAssessmentUsingAlternateMethods.statusReason in "Patient Reason"

define "Qualifying Encounter":
	( [Encounter: "Psych Visit - Diagnostic Evaluation"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Patient Provider Interaction"]
		union [Encounter: "Psych Visit - Psychotherapy"]
		union [Encounter: "Behavioral/Neuropsych Assessment"]
		union [Encounter: "Occupational Therapy Evaluation"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"] ) ValidEncounter
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Initial Population":
	exists "Dementia Encounter"
		and ( Count("Qualifying Encounter")>= 2 )

define "Dementia Encounter":
	"Face to Face Encounter During Measurement Period" ValidFaceToFaceEncounter
		with [Condition: "Dementia & Mental Degenerations"] Dementia
			such that Dementia.clinicalStatus.coding[0].code='active'
			and Interval[FHIRHelpers.ToDateTime(Dementia.onset),FHIRHelpers.ToDateTime(Dementia.abatement)] overlaps ValidFaceToFaceEncounter.period
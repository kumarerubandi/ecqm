library OncologyMedicalandRadiationPainIntensityQuantified version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.1010'
valueset "Chemotherapy Administration": 'urn:oid:2.16.840.1.113883.3.526.3.1027'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Radiation Treatment Management": 'urn:oid:2.16.840.1.113883.3.526.3.1026'
valueset "Standardized Pain Assessment Tool": 'urn:oid:2.16.840.1.113883.3.526.3.1028'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator 1":
	"Initial Population 1"

define "Denominator 2":
	"Initial Population 2"

define "Radiation Treatment During Measurement Period":
	[Procedure: "Radiation Treatment Management"] RadiationTreatmentProcedure
		where RadiationTreatmentProcedure.status='completed'
			    and (RadiationTreatmentProcedure.performed as Period) during "Measurement Period"

define "Radiation Treatment with Cancer Diagnosis":
	"Radiation Treatment During Measurement Period" RadiationTreatment
		with [Condition: "Cancer"] Cancer
			such that Cancer.clinicalStatus.coding[0].code='active'
					and Interval[FHIRHelpers.ToDateTime(Cancer.onset),FHIRHelpers.ToDateTime(Cancer.abatement)] overlaps (RadiationTreatment.performed as Period)

define "Numerator 2":
	"Radiation Treatment with Cancer Diagnosis" RadiationTherapy
		with [Observation: "Standardized Pain Assessment Tool"] PainAssessed
			such that (PainAssessed.status = 'final' or PainAssessed.status = 'amended' or PainAssessed.status = 'corrected')
					and FHIRHelpers.ToDateTime(PainAssessed.issued) during (RadiationTherapy.performed as Period)
				and PainAssessed.value is not null

define "Initial Population 2":
	"Radiation Treatment with Cancer Diagnosis"

define "Numerator 1":
	"Face to Face Encounter with Ongoing Chemotherapy" FaceToFaceEncounterWithChemo
		with [Observation: "Standardized Pain Assessment Tool"] PainAssessed
			such that (PainAssessed.status = 'final' or PainAssessed.status = 'amended' or PainAssessed.status = 'corrected')
					and FHIRHelpers.ToDateTime(PainAssessed.issued) during FaceToFaceEncounterWithChemo.period
				and PainAssessed.value is not null

define "Initial Population 1":
	"Face to Face Encounter with Ongoing Chemotherapy"

define "Face to Face Encounter with Ongoing Chemotherapy":
	from
		[Encounter: "Office Visit"] FaceToFaceEncounter,
		[Procedure: "Chemotherapy Administration"] ChemoBeforeEncounter,
		[Procedure: "Chemotherapy Administration"] ChemoAfterEncounter,
		[Condition: "Cancer"] Cancer
		where (FaceToFaceEncounter.status='in-progress' or FaceToFaceEncounter.status='finished')
      and ChemoBeforeEncounter.status='completed'
      and ChemoAfterEncounter.status='completed'
      and Cancer.clinicalStatus.coding[0].code='active'
      and (ChemoBeforeEncounter.performed as Period) starts 30 days or less on or before day of end of FaceToFaceEncounter.period
			and (ChemoAfterEncounter.performed as Period) starts 30 days or less on or after day of end of FaceToFaceEncounter.period
			and ChemoBeforeEncounter !~ ChemoAfterEncounter
			and Interval[FHIRHelpers.ToDateTime(Cancer.onset),FHIRHelpers.ToDateTime(Cancer.abatement)] overlaps FaceToFaceEncounter.period
			and FaceToFaceEncounter.period during "Measurement Period"
		return FaceToFaceEncounter
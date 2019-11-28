library PrimaryOpenAngleGlaucomaPOAGOpticNerveEvaluation version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Cup to Disc Ratio": 'urn:oid:2.16.840.1.113883.3.526.3.1333'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Optic Disc Exam for Structural Abnormalities": 'urn:oid:2.16.840.1.113883.3.526.3.1334'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Primary Open-Angle Glaucoma": 'urn:oid:2.16.840.1.113883.3.526.3.326'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Face to Face Encounter During Measurement Period":
	( [Encounter: "Office Visit"]
		union [Encounter: "Ophthalmological Services"]
		union [Encounter: "Outpatient Consultation"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"] ) FaceToFaceEncounter
		where (FaceToFaceEncounter.status='in-progress' or FaceToFaceEncounter.status='finished')
		    and FaceToFaceEncounter.period during "Measurement Period"

define "Numerator":
	exists "Cup to Disc Ratio Performed with Result"
		and exists "Optic Disc Exam Performed with Result"

define "Denominator":
	"Initial Population"

define "Medical Reason for Not Performing Cup to Disc Ratio":
	[ServiceRequest: "Cup to Disc Ratio"] CupToDiscExamNotPerformed
		with "Primary Open Angle Glaucoma Encounter" EncounterWithPOAG
			such that FHIRHelpers.ToDateTime(CupToDiscExamNotPerformed.authoredOn) during EncounterWithPOAG.period
		where (CupToDiscExamNotPerformed.status='revoked' or CupToDiscExamNotPerformed.status='entered-in-error')
		    and "NoSR"(CupToDiscExamNotPerformed) in "Medical Reason"

define "Cup to Disc Ratio Performed with Result":
	[DiagnosticReport: "Cup to Disc Ratio"] CupToDiscExamPerformed
		with "Primary Open Angle Glaucoma Encounter" EncounterWithPOAG
			such that (CupToDiscExamPerformed.effective as Period) during EncounterWithPOAG.period
				and (CupToDiscExamPerformed.status='final' or CupToDiscExamPerformed.status='amended' or CupToDiscExamPerformed.status='corrected' or CupToDiscExamPerformed.status='appended')
		    and CupToDiscExamPerformed.result is not null

define "Primary Open Angle Glaucoma Encounter":
	"Face to Face Encounter During Measurement Period" ValidFaceToFaceEncounter
		with [Condition: "Primary Open-Angle Glaucoma"] PrimaryOpenAngleGlaucoma
			such that PrimaryOpenAngleGlaucoma.clinicalStatus.coding[0].code='active'
				and Interval[FHIRHelpers.ToDateTime(PrimaryOpenAngleGlaucoma.onset),FHIRHelpers.ToDateTime(PrimaryOpenAngleGlaucoma.abatement)] overlaps ValidFaceToFaceEncounter.period

define "Optic Disc Exam Performed with Result":
	[DiagnosticReport: "Optic Disc Exam for Structural Abnormalities"] OpticDiscExamPerformed
		with "Primary Open Angle Glaucoma Encounter" EncounterWithPOAG
			such that (OpticDiscExamPerformed.effective as Period) during EncounterWithPOAG.period
				and (OpticDiscExamPerformed.status='final' or OpticDiscExamPerformed.status='amended' or OpticDiscExamPerformed.status='corrected' or OpticDiscExamPerformed.status='appended')
		    and OpticDiscExamPerformed.result is not null

define "Medical Reason for Not Performing Optic Disc Exam":
	[ServiceRequest: "Optic Disc Exam for Structural Abnormalities"] OpticDiscExamNotPerformed
		with "Primary Open Angle Glaucoma Encounter" EncounterWithPOAG
			such that FHIRHelpers.ToDateTime(OpticDiscExamNotPerformed.authoredOn) during EncounterWithPOAG.period
		where (OpticDiscExamNotPerformed.status='revoked' or OpticDiscExamNotPerformed.status='entered-in-error')
		    and "NoSR"(OpticDiscExamNotPerformed) in "Medical Reason"

define "Denominator Exceptions":
	exists "Medical Reason for Not Performing Cup to Disc Ratio"
		or exists "Medical Reason for Not Performing Optic Disc Exam"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 18
		and exists "Primary Open Angle Glaucoma Encounter"

define function "NoSR"(SR ServiceRequest):
	(singleton from (SR.extension e where e.url='http://hl7.org/fhir/StructureDefinition/request-statusReason')).value as Coding


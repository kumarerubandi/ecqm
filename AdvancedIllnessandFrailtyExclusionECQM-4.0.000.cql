library AdvancedIllnessandFrailtyExclusionECQM version '4.0.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Acute Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1083' 
valueset "Advanced Illness": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1082' 
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014' 
valueset "Dementia Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1510' 
valueset "ED": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1085' 
valueset "Frailty Device": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1300' 
valueset "Frailty Diagnosis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1074' 
valueset "Frailty Encounter": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1088' 
valueset "Frailty Symptom": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1075' 
valueset "Nonacute Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1084' 
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012' 
valueset "Observation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1086' 
valueset "Outpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1087' 

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Outpatient Encounters with Advanced Illness":
	( [Encounter: "Outpatient"]
		union [Encounter: "Observation"]
		union [Encounter: "ED"]
		union [Encounter: "Nonacute Inpatient"] ) OutpatientEncounter
		where (OutpatientEncounter.status='in-progress' or OutpatientEncounter.status='finished')
				and "EncounterDiagnosis"(OutpatientEncounter)
				and OutpatientEncounter.period starts 2 years or less before end of "Measurement Period"

define "Long Term Care Periods During Measurement Period":
	( [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Nursing Facility Visit"] ) LongTermFacilityEncounter
			where (LongTermFacilityEncounter.status='in-progress' or LongTermFacilityEncounter.status='finished')
				and LongTermFacilityEncounter.period overlaps "Measurement Period"
		return LongTermFacilityEncounter.period intersect "Measurement Period"

define "Inpatient Encounter with Advanced Illness":
	[Encounter: "Acute Inpatient"] InpatientEncounter
		where (InpatientEncounter.status='in-progress' or InpatientEncounter.status='finished')
				and "EncounterDiagnosis"(InpatientEncounter)
				and InpatientEncounter.period starts 2 years or less before  end of "Measurement Period"

define "Dementia Medications In Year Before or During Measurement Period":
	[MedicationStatement: "Dementia Medications"] DementiaMed
		where DementiaMed.status='active'
		and (DementiaMed.effective as Period) overlaps Interval[( start of "Measurement Period" - 1 year ),end of "Measurement Period"]

define "Has Criteria Indicating Frailty":
	exists ( [ServiceRequest: "Frailty Device"] FrailtyDeviceOrder
			where FrailtyDeviceOrder.intent='order'
			and FHIRHelpers.ToDateTime(FrailtyDeviceOrder.authoredOn) during "Measurement Period"
	)
		or exists ( [Procedure: "Frailty Device"] FrailtyDeviceApplied
				where FrailtyDeviceApplied.status='completed'
					and (FrailtyDeviceApplied.performed as Period) overlaps "Measurement Period"
		)
		or exists ( [Condition: "Frailty Diagnosis"] FrailtyDiagnosis
				where FrailtyDiagnosis.clinicalStatus.coding[0].code='active'
					and Interval[FHIRHelpers.ToDateTime(FrailtyDiagnosis.onset),FHIRHelpers.ToDateTime(FrailtyDiagnosis.abatement)] overlaps "Measurement Period"
		)
		or exists ( [Encounter: "Frailty Encounter"] FrailtyEncounter
				where (FrailtyEncounter.status='in-progress' or FrailtyEncounter.status='finished')
					and FrailtyEncounter.period overlaps "Measurement Period"
		)
		or exists ( [Condition: "Frailty Symptom"] FrailtySymptom
				where FrailtySymptom.clinicalStatus.coding[0].code='active'
					and Interval[FHIRHelpers.ToDateTime(FrailtySymptom.onset),FHIRHelpers.ToDateTime(FrailtySymptom.abatement)] overlaps "Measurement Period"
		)

define "Advanced Illness and Frailty Exclusion Including Over Age 80":
	//If the measure includes populations age 80 and older, then use this logic:
	 ((AgeInYearsAt(start of "Measurement Period")in Interval[66, 80])
				and "Has Criteria Indicating Frailty"
				and ( Count("Outpatient Encounters with Advanced Illness")>= 2
						or exists ( "Inpatient Encounter with Advanced Illness" )
						or exists "Dementia Medications In Year Before or During Measurement Period"
				)
	)
		or (( AgeInYearsAt(start of "Measurement Period")>= 81 )
					and "Has Criteria Indicating Frailty"
		)

define "Advanced Illness and Frailty Exclusion Including Under Age 80":
	//If the measure does NOT include populations age 80 and older, then use this logic:
	 ( AgeInYearsAt(start of "Measurement Period")>= 65
				and "Has Criteria Indicating Frailty"
				and ( Count("Outpatient Encounters with Advanced Illness")>= 2
						or exists ( "Inpatient Encounter with Advanced Illness" )
						or exists "Dementia Medications In Year Before or During Measurement Period"
				)
	)

define "Has Spent More Than 90 Days in Long Term Care":
	"Days Spent in Long Term Care During Measurement Period" > 90

define "Days Spent in Long Term Care During Measurement Period":
	"CumulativeDays"("Long Term Care Periods During Measurement Period")

define function "CumulativeDays"(Intervals List<Interval<DateTime>> ):
	Sum((collapse Intervals)CollapsedInterval
			return all duration in days of CollapsedInterval
	)

define function "EncounterDiagnosis"(ValidEncounter Encounter):
	exists(singleton from (ValidEncounter.diagnosis EncounterDiagnosis
				where exists(singleton from (EncounterDiagnosis.condition c where c.reference.value='Condition/'+("GetCondition").id.value))
			)
	)

define "GetCondition":
	singleton from ([Condition:"Advanced Illness"]C where C.clinicalStatus.coding[0].code='active')

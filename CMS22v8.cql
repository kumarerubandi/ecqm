library PreventiveCareandScreeningforHighBloodPressureandFollowUpDocumented version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Anti-Hypertensive Pharmacologic Therapy": 'urn:oid:2.16.840.1.113883.3.600.1476'
valueset "BP Screening Encounter Codes": 'urn:oid:2.16.840.1.113883.3.600.1920'
valueset "Diagnosis of hypertension": 'urn:oid:2.16.840.1.113883.3.600.263'
valueset "Dietary Recommendations": 'urn:oid:2.16.840.1.113883.3.600.1515'
valueset "ECG 12 lead or study order": 'urn:oid:2.16.840.1.113883.3.600.2448'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Finding of Elevated Blood Pressure or Hypertension": 'urn:oid:2.16.840.1.113762.1.4.1047.514'
valueset "Followup within 4 weeks": 'urn:oid:2.16.840.1.113883.3.600.1537'
valueset "Followup within one year": 'urn:oid:2.16.840.1.113883.3.600.1474'
valueset "Laboratory Tests for Hypertension": 'urn:oid:2.16.840.1.113883.3.600.1482'
valueset "Lifestyle Recommendation": 'urn:oid:2.16.840.1.113883.3.600.1508'
valueset "Medical or Other reason not done": 'urn:oid:2.16.840.1.113883.3.600.1.1502'
valueset "Moderation of ETOH Consumption Recommendation": 'urn:oid:2.16.840.1.113883.3.600.823'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Reason refused": 'urn:oid:2.16.840.1.113883.3.600.791'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Physical Activity Recommendation": 'urn:oid:2.16.840.1.113883.3.600.1518'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Referral to Alternative Provider / Primary Care Provider": 'urn:oid:2.16.840.1.113883.3.600.1475'
valueset "Weight Reduction Recommended": 'urn:oid:2.16.840.1.113883.3.600.1510'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Qualifying Encounters During Measurement Period":
	[Encounter: "BP Screening Encounter Codes"] QualifyingEncounter
		where (QualifyingEncounter.status='in-progress' or QualifyingEncounter.status='finished')
		            and QualifyingEncounter.period during "Measurement Period"

define "Qualifying Encounters with Blood Pressure Screening Results":
	"Qualifying Encounters During Measurement Period" QualifyingEncounter
		with [Observation: "Diastolic blood pressure"] DiastolicBP
			such that (DiastolicBP.effective as Period) starts during QualifyingEncounter.period
				and DiastolicBP.value is not null
		with [Observation: "Systolic blood pressure"] SystolicBP
			such that (SystolicBP.effective as Period) starts during QualifyingEncounter.period
				and SystolicBP.value is not null
		sort by start of period

define "Most Recent Blood Pressure Screening Encounter":
	Last("Qualifying Encounters with Blood Pressure Screening Results")

define "Most Recent Diastolic Reading During Most Recent Blood Pressure Screening Encounter":
	Last([Observation: "Diastolic blood pressure"] DiastolicBP
			with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
				such that (DiastolicBP.effective as Period) during LastBPEncounter.period
					and DiastolicBP.value is not null
			sort by start of (effective as Period)
	)

define "Most Recent Systolic Reading During Most Recent Blood Pressure Screening Encounter":
	Last([Observation: "Systolic blood pressure"] SystolicBP
			with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
				such that (SystolicBP.effective as Period) during LastBPEncounter.period
					and SystolicBP.value is not null
			sort by start of (effective as Period)
	)

define "No Blood Pressure Screen":
	[Observation: "Systolic blood pressure"]SystolicBP where SystolicBP.status = 'cancelled' or SystolicBP.status = 'entered-in-error'
		union [Observation: "Diastolic blood pressure"]DiastolicBP where DiastolicBP.status = 'cancelled' or DiastolicBP.status = 'entered-in-error'

define "No Blood Pressure Screen Due to Medical Reason or Patient Refusal":
	"No Blood Pressure Screen" NoBPScreen
		with "Qualifying Encounters During Measurement Period" QualifyingEncounter
			such that ( NoBPScreen.dataAbsentReason in "Medical or Other reason not done"
					or NoBPScreen.dataAbsentReason in "Patient Reason refused"
			)
				and NoBPScreen.authorDatetime same day as start of QualifyingEncounter.period

define "Patients Age 18 Years and Older at Start of Measurement Period":
	AgeInYearsAt(start of "Measurement Period")>= 18

define "Prehypertensive Blood Pressure at Most Recent Screening Encounter":
	from
		"Most Recent Systolic Reading During Most Recent Blood Pressure Screening Encounter" LastSystolicBP,
		"Most Recent Diastolic Reading During Most Recent Blood Pressure Screening Encounter" LastDiastolicBP
		where ( LastSystolicBP.value >= 120 'mm[Hg]'
				or LastDiastolicBP.value >= 80 'mm[Hg]'
		)
			and LastSystolicBP.value < 140 'mm[Hg]'
			and LastDiastolicBP.value < 90 'mm[Hg]'

define "Antihypertensive Medication Not Ordered Due to Patient Refusal":
	( [MedicationRequest: "Anti-Hypertensive Pharmacologic Therapy"] NoAntihypertensives
			with "Qualifying Encounters During Measurement Period" QualifyingEncounter
				such that NoAntihypertensives.intent!='order'  
					and NoAntihypertensives.doNotPerform =true
					and NoAntihypertensives.reasonNotTaken in "Patient Reason refused"
					and NoAntihypertensives.authorDatetime same day as start of QualifyingEncounter.period
	)

define "Antihypertensive Medications Ordered":
	[MedicationRequest: "Anti-Hypertensive Pharmacologic Therapy"] AntihypertensiveMeds
		with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
			such that AntihypertensiveMeds.intent='order' 
				and AntihypertensiveMeds.authorDatetime same day as start of LastBPEncounter.period

define "Blood Pressure Normal at Most Recent Screening Encounter":
	from
		"Most Recent Systolic Reading During Most Recent Blood Pressure Screening Encounter" LastSystolicBP,
		"Most Recent Diastolic Reading During Most Recent Blood Pressure Screening Encounter" LastDiastolicBP
		where ( LastSystolicBP.value < 120 'mm[Hg]'
				and LastDiastolicBP.value < 80 'mm[Hg]'
		)

define "Denominator Exclusions":
	exists ( [Condition: "Diagnosis of hypertension"] Hypertension
			with "Qualifying Encounters During Measurement Period" QualifyingEncounter
				such that Hypertension.clinicalStatus.coding[0].code='active'
					and Interval[ToDateTime(Hypertension.onset),ToDateTime(Hypertension.abatement)] starts before start of QualifyingEncounter.period
	)

define "Diagnostic Study Not Ordered Due to Patient Refusal":
	( [ServiceRequest: "ECG 12 lead or study order"] NoDiagnosticStudy
			with "Qualifying Encounters During Measurement Period" QualifyingEncounter
				such that NoDiagnosticStudy.intent!='order' 
					and NoDiagnosticStudy.doNotPerform =true
					and NoDiagnosticStudy.reasonCode in "Patient Reason refused"
					and NoDiagnosticStudy.authoredOn same day as start of QualifyingEncounter.period
	)

define "Electrocardiogram Ordered for Hypertension":
	[ServiceRequest: "ECG 12 lead or study order"] ECG
		with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
			such that ECG.intent='order' 
				and ECG.authoredOn same day as start of LastBPEncounter.period

define "Follow Up Within 4 Weeks":
	[ServiceRequest: "Followup within 4 weeks"] Followup4Weeks
		with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
			such that Followup4Weeks.intent='order' 
				and Followup4Weeks.authoredOn same day as start of LastBPEncounter.period

define "Hypertensive Followup Interventions Not Ordered":
	([ServiceRequest: "Referral to Alternative Provider / Primary Care Provider"]SR where SR.intent!='order' 
					and SR.doNotPerform =true)
		union ([ServiceRequest: "Lifestyle Recommendation"]SR where SR.intent!='order' 
					and SR.doNotPerform =true)
		union ([ServiceRequest: "Weight Reduction Recommended"]SR where SR.intent!='order' 
					and SR.doNotPerform =true)
		union ([ServiceRequest: "Dietary Recommendations"]SR where SR.intent!='order' 
					and SR.doNotPerform =true)
		union ([ServiceRequest: "Physical Activity Recommendation"]SR where SR.intent!='order' 
					and SR.doNotPerform =true)
		union ([ServiceRequest: "Moderation of ETOH Consumption Recommendation"]SR where SR.intent!='order' 
					and SR.doNotPerform =true)

define "Hypertensive Followup Interventions Not Ordered Due to Patient Refusal":
	"Hypertensive Followup Interventions Not Ordered" NoInterventions
		with "Qualifying Encounters During Measurement Period" QualifyingEncounter
			such that NoInterventions.reasonCode in "Patient Reason refused"
				and NoInterventions.authoredOn same day as start of QualifyingEncounter.period

define "Hypertensive Interventions":
	([ServiceRequest: "Lifestyle Recommendation"]SR where SR.intent='order')
		union ([ServiceRequest: "Weight Reduction Recommended"]SR where SR.intent='order')
		union ([ServiceRequest: "Dietary Recommendations"]SR where SR.intent='order')
		union ([ServiceRequest: "Physical Activity Recommendation"]SR where SR.intent='order')
		union ([ServiceRequest: "Moderation of ETOH Consumption Recommendation"]SR where SR.intent='order')

define "Initial Population":
	"Patients Age 18 Years and Older at Start of Measurement Period"
		and exists ( "Qualifying Encounters During Measurement Period" )

define "Last Diastolic One Year Prior to Encounter":
	Last([Observation: "Diastolic blood pressure"] DiastolicBP
			with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
				such that (DiastolicBP.effective as Period) starts 1 year or less before start LastBPEncounter.period
			sort by start of (effective as Period)
	)

define "Last Diastolic One Year Prior to Encounter High":
	"Last Diastolic One Year Prior to Encounter" LastDiastolic
		where LastDiastolic.value >= 90 'mm[Hg]'

define "Last Systolic One Year Prior to Encounter":
	Last([Observation: "Systolic blood pressure"] SystolicBP
			with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
				such that (SystolicBP.effective as Period) starts 1 year or less before start LastBPEncounter.period
			sort by start of (effective as Period)
	)

define "Last Systolic One Year Prior to Encounter High":
	"Last Systolic One Year Prior to Encounter" LastSystolic
		where LastSystolic.value >= 140 'mm[Hg]'

define "Denominator":
	"Initial Population"

define "High Blood Pressure at Most Recent Screening Encounter":
	from
		"Most Recent Systolic Reading During Most Recent Blood Pressure Screening Encounter" LastSystolicBP,
		"Most Recent Diastolic Reading During Most Recent Blood Pressure Screening Encounter" LastDiastolicBP
		where ( LastSystolicBP.value >= 140 'mm[Hg]'
				or LastDiastolicBP.value >= 90 'mm[Hg]'
		)

define "Last Blood Pressure Within One Year High":
	"Last Diastolic One Year Prior to Encounter High" is not null
		or "Last Systolic One Year Prior to Encounter High" is not null

define "Labs Ordered for Hypertension":
	[ServiceRequest: "Laboratory Tests for Hypertension"] HypertensionLabs
		with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
			such that HypertensionLabs.intent='order'
				and HypertensionLabs.authoredOn same day as start of LastBPEncounter.period

define "Lab Test for Hypertension Not Ordered Due to Patient Refusal":
	( [ServiceRequest: "Laboratory Tests for Hypertension"] NoLabsOrdered
			with "Qualifying Encounters During Measurement Period" QualifyingEncounter
				such that NoLabsOrdered.intent!='order' 
					and NoLabsOrdered.doNotPerform =true
					and NoLabsOrdered.reasonCode in "Patient Reason refused"
					and NoLabsOrdered.authoredOn same day as start of QualifyingEncounter.period
	)

define "Interventions for Second Hypertensive Reading":
	exists ( "Antihypertensive Medications Ordered" )
		or exists ( "Labs Ordered for Hypertension" )
		or exists ( "Electrocardiogram Ordered for Hypertension" )

define "Has Second Hypertensive Reading":
	"Last Blood Pressure Within One Year High"
		and "High Blood Pressure at Most Recent Screening Encounter" is not null

define "Denominator Exceptions":
	exists ( "No Blood Pressure Screen Due to Medical Reason or Patient Refusal" )
		or exists ( "Hypertensive Followup Interventions Not Ordered Due to Patient Refusal" )
		or exists ( "Antihypertensive Medication Not Ordered Due to Patient Refusal" )
		or exists ( "Lab Test for Hypertension Not Ordered Due to Patient Refusal" )
		or exists ( "Diagnostic Study Not Ordered Due to Patient Refusal" )

define "Numerator":
	( "Blood Pressure Normal at Most Recent Screening Encounter" is not null )
		or ( "Has Prehypertensive Reading With Interventions" )
		or ( "Has First Hypertensive Reading With Interventions" )
		or ( "Has Second Hypertensive Reading With Interventions" )

define "Referral to Alternate Provider":
	( [ServiceRequest: "Referral to Alternative Provider / Primary Care Provider"] Referral
			with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
				such that Referral.intent='order' 
					and Referral.authoredOn same day as start of LastBPEncounter.period
					and Referral.reasonCode in "Finding of Elevated Blood Pressure or Hypertension"
	)

define "Hypertensive Interventions at Most Recent Blood Pressure Encounter":
	exists ( "Hypertensive Interventions" HighBloodPressureInterventions
			with "Most Recent Blood Pressure Screening Encounter" MostRecentBloodPressureEncounter
				such that HighBloodPressureInterventions.authorDatetime same day as start of MostRecentBloodPressureEncounter.period
	)

define "Has Second Hypertensive Reading With Interventions":
	"Has Second Hypertensive Reading"
		and ( "Hypertensive Interventions at Most Recent Blood Pressure Encounter"
				and "Interventions for Second Hypertensive Reading"
		)
		or exists ( "Referral to Alternate Provider" )

define "Has First Hypertensive Reading With Interventions":
	"High Blood Pressure at Most Recent Screening Encounter" is not null
		and not "Last Blood Pressure Within One Year High"
		and ( "Hypertensive Interventions at Most Recent Blood Pressure Encounter"
				and exists ( "Follow Up Within 4 Weeks" )
		)
		or exists ( "Referral to Alternate Provider" )

define "Follow Up One Year":
	exists ( [ServiceRequest: "Followup within one year"] FollowupOneYear
			with "Most Recent Blood Pressure Screening Encounter" LastBPEncounter
				such that FollowupOneYear.intent='order' 
					and FollowupOneYear.authoredOn same day as start of LastBPEncounter.period
	)

define "Has Prehypertensive Reading With Interventions":
	"Prehypertensive Blood Pressure at Most Recent Screening Encounter" is not null
		and ( "Hypertensive Interventions at Most Recent Blood Pressure Encounter"
				and "Follow Up One Year"
		)
		or exists ( "Referral to Alternate Provider" )

library HeartFailureHFBetaBlockerTherapyforLeftVentricularSystolicDysfunctionLVSD version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Allergy to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1177'
valueset "Arrhythmia": 'urn:oid:2.16.840.1.113883.3.526.3.366'
valueset "Asthma": 'urn:oid:2.16.840.1.113883.3.526.3.362'
valueset "Atrioventricular Block": 'urn:oid:2.16.840.1.113883.3.526.3.367'
valueset "Beta Blocker Therapy for LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1184'
valueset "Beta Blocker Therapy Ingredient": 'urn:oid:2.16.840.1.113883.3.526.3.1493'
valueset "Bradycardia": 'urn:oid:2.16.840.1.113883.3.526.3.412'
valueset "Cardiac Pacer": 'urn:oid:2.16.840.1.113883.3.526.3.1193'
valueset "Cardiac Pacer in Situ": 'urn:oid:2.16.840.1.113883.3.526.3.368'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services - Hospital Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1007'
valueset "Ejection Fraction": 'urn:oid:2.16.840.1.113883.3.526.3.1134'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Failure": 'urn:oid:2.16.840.1.113883.3.526.3.376'
valueset "Heart Rate": 'urn:oid:2.16.840.1.113883.3.526.3.1176'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hypotension": 'urn:oid:2.16.840.1.113883.3.526.3.370'
valueset "Intolerance to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1178'
valueset "Left Ventricular Systolic Dysfunction": 'urn:oid:2.16.840.1.113883.3.526.3.1091'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Moderate or Severe": 'urn:oid:2.16.840.1.113883.3.526.3.1092'
valueset "Moderate or Severe LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1090'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "System Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1009'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
	["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
	["Patient Characteristic Payer": "Payer"]

define "SDE Race":
	["Patient Characteristic Race": "Race"]

define "SDE Sex":
	["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Moderate or Severe LVSD Findings":
	( [ DiagnosticReport: "Ejection Fraction"] EjectionFraction
			where EjectionFraction.result < 40 '%'
	)
		union [ Condition: "Moderate or Severe LVSD"]
		union ( [ Condition: "Left Ventricular Systolic Dysfunction"] LVSD
				where LVSD.severity in "Moderate or Severe"
		)

define "Inpatient Discharge During Measurement Period":
	[ Encounter : "Discharge Services - Hospital Inpatient"] InpatientEncounter
		where InpatientEncounter.period during "Measurement Period"

define "Face to Face Encounter During Measurement Period":
	( [ Encounter : "Care Services in Long-Term Residential Facility"]
		union [Encounter : "Home Healthcare Services"]
		union [Encounter : "Nursing Facility Visit"]
		union [Encounter : "Office Visit"]
		union [Encounter : "Outpatient Consultation"] ) FaceToFaceEncounter
		where FaceToFaceEncounter.period during "Measurement Period"

define "Heart Failure Inpatient Encounter":
	"Inpatient Discharge During Measurement Period" InpatientEncounter
		with [Condition: "Heart Failure"] HeartFailure
			such that (HeartFailure.onset as Period) overlaps InpatientEncounter.period

define "Heart Failure Inpatient Encounter with Moderate or Severe LVSD":
	"Heart Failure Inpatient Encounter" HFInpatientEncounter
		with "Moderate or Severe LVSD Findings" InpatientLVSDFindings
			such that (InpatientLVSDFindings.onset as Period) starts before 
			end of HFInpatientEncounter.period
				or (InpatientLVSDFindings.onset as Period) starts before 
				end of HFInpatientEncounter.period

define "Heart Failure Outpatient Encounter with Moderate or Severe LVSD":
	"Heart Failure Outpatient Encounter" HFOutpatientEncounter
		with "Moderate or Severe LVSD Findings" OutpatientLVSDFindings
			such that (OutpatientLVSDFindings.onset as Period) starts before 
			end of HFOutpatientEncounter.period
				or (OutpatientLVSDFindings.onset as Period) starts before 
				end of HFOutpatientEncounter.period

define "Allergy or Intolerance to Beta Blocker Therapy Ingredient Outpatient":
	[AllergyIntolerance: "Beta Blocker Therapy Ingredient"] BetaBlockerAllergyIntolerance
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (BetaBlockerAllergyIntolerance.onset as Period) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Allergy or Intolerance to Beta Blocker Therapy Ingredient Inpatient":
	[AllergyIntolerance: "Beta Blocker Therapy Ingredient"] BetaBlockerAllergyIntolerance
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (BetaBlockerAllergyIntolerance.onset as Period) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period

define "Arrhythmia Diagnosis Outpatient":
	[Condition: "Arrhythmia"] Arrhythmia
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (Arrhythmia.onset as Period) overlaps (ModerateOrSevereLVSDHFOutpatientEncounter.period)

define "Arrhythmia Diagnosis Inpatient":
	[Condition: "Arrhythmia"] Arrhythmia
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (Arrhythmia.onset as Period) overlaps (ModerateOrSevereLVSDHFInpatientEncounter.period)

define "Asthma Diagnosis Outpatient":
	[Condition: "Asthma"] Asthma
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (Asthma.onset as Period) overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Asthma Diagnosis Inpatient":
	[Condition: "Asthma"] Asthma
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (Asthma.onset as Period) overlaps ModerateOrSevereLVSDHFInpatientEncounter.period

define "Atrioventricular Block Diagnosis Outpatient":
	[Condition: "Atrioventricular Block"] AtrioventricularBlock
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (AtrioventricularBlock.onset as Period) overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Atrioventricular Block Diagnosis Inpatient":
	[Condition: "Atrioventricular Block"] AtrioventricularBlock
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (AtrioventricularBlock.onset as Period) overlaps ModerateOrSevereLVSDHFInpatientEncounter.period

define "Beta Blocker Therapy for LVSD Ordered Outpatient":
	[MedicationRequest: "Beta Blocker Therapy for LVSD"] BetaBlockerOrdered
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that BetaBlockerOrdered.authoredOn during ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Bradycardia Diagnosis Outpatient":
	[Condition: "Bradycardia"] Bradycardia
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that Bradycardia.onset as Period overlaps ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod

define "Bradycardia Diagnosis Inpatient":
	[Condition: "Bradycardia"] Bradycardia
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that Bradycardia.onset as Period overlaps ModerateOrSevereLVSDHFInpatientEncounter.period

define "Cardiac Pacer Device Implanted Outpatient":
	[DeviceUseStatement : "Cardiac Pacer"] ImplantedCardiacPacer
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (ImplantedCardiacPacer.timing as Period) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Cardiac Pacer Device Implanted Inpatient":
	[DeviceUseStatement : "Cardiac Pacer"] ImplantedCardiacPacer
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (ImplantedCardiacPacer.timing as Period) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period

define "Currently Taking Beta Blocker Therapy for LVSD Outpatient":
	[MedicationStatement : "Beta Blocker Therapy for LVSD"] ActiveBetaBlocker
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (ActiveBetaBlocker.effective as Period) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Currently Taking Beta Blocker Therapy for LVSD Inpatient":
	[MedicationStatement : "Beta Blocker Therapy for LVSD"] ActiveBetaBlocker
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (ActiveBetaBlocker.effective as Period) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period

define "Denominator 1":
	"Initial Population 1"
		and exists "Heart Failure Outpatient Encounter with Moderate or Severe LVSD"

define "Denominator 2":
	"Initial Population 2"
		and exists "Heart Failure Inpatient Encounter with Moderate or Severe LVSD"

define "Diagnosis of Allergy to Beta Blocker Therapy Outpatient":
	[Condition: "Allergy to Beta Blocker Therapy"] BetaBlockerAllergyDiagnosis
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (BetaBlockerAllergyDiagnosis.onset as Period) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Diagnosis of Allergy to Beta Blocker Therapy Inpatient":
	[Condition: "Allergy to Beta Blocker Therapy"] BetaBlockerAllergyDiagnosis
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (BetaBlockerAllergyDiagnosis.onset as Period) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period

define "Diagnosis of Intolerance to Beta Blocker Therapy Outpatient":
	[Condition: "Intolerance to Beta Blocker Therapy"] BetaBlockerIntoleranceDiagnosis
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (BetaBlockerIntoleranceDiagnosis.onset as Period) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Diagnosis of Intolerance to Beta Blocker Therapy Inpatient":
	[Condition: "Intolerance to Beta Blocker Therapy"] BetaBlockerIntoleranceDiagnosis
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that BetaBlockerIntoleranceDiagnosis.onset as Period) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period

define "Hypotension Diagnosis Outpatient":
	[Condition: "Hypotension"] Hypotension
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (Hypotension.onset as Period) overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Hypotension Diagnosis Inpatient":
	[Condition: "Hypotension"] Hypotension
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (Hypotension.onset as Period) overlaps ModerateOrSevereLVSDHFInpatientEncounter.period

define "Numerator 1":
	exists "Beta Blocker Therapy for LVSD Ordered Outpatient"
		or exists "Currently Taking Beta Blocker Therapy for LVSD Outpatient"

define "Qualifying Encounter":
	( ["Encounter, Performed": "Care Services in Long-Term Residential Facility"]
		union ["Encounter, Performed": "Home Healthcare Services"]
		union ["Encounter, Performed": "Nursing Facility Visit"]
		union ["Encounter, Performed": "Office Visit"]
		union ["Encounter, Performed": "Outpatient Consultation"]
		union ["Encounter, Performed": "Patient Provider Interaction"] ) ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Atrioventricular Block without Cardiac Pacer Inpatient":
	exists "Atrioventricular Block Diagnosis Inpatient"
		and not exists "Diagnosis of Cardiac Pacer in Situ Inpatient"
		and not exists "Cardiac Pacer Device Implanted Inpatient"

define "Atrioventricular Block without Cardiac Pacer Outpatient":
	exists "Atrioventricular Block Diagnosis Outpatient"
		and not exists "Diagnosis of Cardiac Pacer in Situ Outpatient"
		and not exists "Cardiac Pacer Device Implanted Outpatient"

define "Beta Blocker Therapy for LVSD at Inpatient Discharge":
	[MedicationRequest: "Beta Blocker Therapy for LVSD"] BetaBlockerAtDischarge
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that BetaBlockerAtDischarge.intent = 'plan'
				and BetaBlockerAtDischarge.authoredOn during ModerateOrSevereLVSDHFInpatientEncounter.period

define "Diagnosis of Cardiac Pacer in Situ Inpatient":
	[Condition: "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that (CardiacPacerDiagnosis.onset as Period) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period

define "Diagnosis of Cardiac Pacer in Situ Outpatient":
	[Condition: "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that (CardiacPacerDiagnosis.onset as Period) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period

define "Heart Failure Outpatient Encounter":
	"Face to Face Encounter During Measurement Period" ValidFaceToFaceEncounter
		with [Condition: "Heart Failure"] HeartFailure
			such that (HeartFailure.onset as Period) overlaps ValidFaceToFaceEncounter.period

define "Denominator Exceptions 1":
	exists "Consecutive Heart Rates Less than 50 Outpatient"
		or exists "Medical Patient or System Reason for Not Ordering Beta Blocker for LVSD Outpatient"
		or exists "Arrhythmia Diagnosis Outpatient"
		or exists "Hypotension Diagnosis Outpatient"
		or exists "Asthma Diagnosis Outpatient"
		or exists "Diagnosis of Allergy to Beta Blocker Therapy Outpatient"
		or exists "Diagnosis of Intolerance to Beta Blocker Therapy Outpatient"
		or exists "Bradycardia Diagnosis Outpatient"
		or exists "Allergy or Intolerance to Beta Blocker Therapy Ingredient Outpatient"
		or "Atrioventricular Block without Cardiac Pacer Outpatient"

define "Denominator Exceptions 2":
	exists "Consecutive Heart Rates Less than 50 Inpatient"
		or exists "Medical Patient or System Reason for No Beta Blocker for LVSD at Inpatient Discharge"
		or exists "Arrhythmia Diagnosis Inpatient"
		or exists "Hypotension Diagnosis Inpatient"
		or exists "Asthma Diagnosis Inpatient"
		or exists "Diagnosis of Allergy to Beta Blocker Therapy Inpatient"
		or exists "Diagnosis of Intolerance to Beta Blocker Therapy Inpatient"
		or exists "Bradycardia Diagnosis Inpatient"
		or exists "Allergy or Intolerance to Beta Blocker Therapy Ingredient Inpatient"
		or "Atrioventricular Block without Cardiac Pacer Inpatient"

define "Numerator 2":
	exists "Beta Blocker Therapy for LVSD at Inpatient Discharge"
		or exists "Currently Taking Beta Blocker Therapy for LVSD Inpatient"

define "Consecutive Heart Rates Less than 50 Inpatient":
	from
		[Observation: "Heart Rate"] HeartRate,
		"Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
		let PriorHeartRate: Last([Observation: "Heart Rate"] MostRecentPriorHeartRate
				where (MostRecentPriorHeartRate.effective as Period) during ModerateOrSevereLVSDHFInpatientEncounter.period
					and (MostRecentPriorHeartRate.effective as Period) starts before start of HeartRate.period
				sort by start of (effective as Period)
		)
		where (HeartRate.effective as Period) during ModerateOrSevereLVSDHFInpatientEncounter.period
			and (HeartRate.value as Integer) < 50 '{Beats}/min'
			and (PriorHeartRate.value as Integer) < 50 '{Beats}/min'

define "Consecutive Heart Rates Less than 50 Outpatient":
	from
		[Observation: "Heart Rate"] HeartRate,
		"Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
		let PriorHeartRate: Last([Observation: "Heart Rate"] MostRecentPriorHeartRate
				where (MostRecentPriorHeartRate.effective as Period) during ModerateOrSevereLVSDHFOutpatientEncounter.period
					and (MostRecentPriorHeartRate.effective as Period) starts before start of (HeartRate.effective as Period)
				sort by start of (effective as Period)
		)
		where HeartRate.relevantPeriod during ModerateOrSevereLVSDHFOutpatientEncounter.relevantPeriod
			and HeartRate.value as Integer < 50 '{Beats}/min'
			and PriorHeartRate.value as Integer < 50 '{Beats}/min'

define "Medical Patient or System Reason for No Beta Blocker for LVSD at Inpatient Discharge":
	[MedicationStatement: "Beta Blocker Therapy for LVSD"] NoBetaBlockerAtDischarge
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that NoBetaBlockerAtDischarge.doNotPerform = "true"
				and NoBetaBlockerAtDischarge.authoredOn during ModerateOrSevereLVSDHFInpatientEncounter.period
		where ( NoBetaBlockerAtDischarge.status ="not-taken"
			and ( NoBetaBlockerAtDischarge.in "Medical Reason"
				or NoBetaBlockerAtDischarge.negationRationale in "Patient Reason"
				or NoBetaBlockerAtDischarge.negationRationale in "System Reason")
		)

define "Medical Patient or System Reason for Not Ordering Beta Blocker for LVSD Outpatient":
	["Medication, Not Ordered": "Beta Blocker Therapy for LVSD"] NoBetaBlockerOrdered
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that NoBetaBlockerOrdered.authoredOn during ModerateOrSevereLVSDHFOutpatientEncounter.period
		where ( NoBetaBlockerOrdered.negationRationale in "Medical Reason"
				or NoBetaBlockerOrdered.negationRationale in "Patient Reason"
				or NoBetaBlockerOrdered.negationRationale in "System Reason"
		)

define "Initial Population 1":
	exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
			where Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 18
	)
		and Count("Qualifying Encounter")>= 2
		and exists "Heart Failure Outpatient Encounter"

define "Initial Population 2":
	exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
			where Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 18
	)
		and exists "Heart Failure Inpatient Encounter"

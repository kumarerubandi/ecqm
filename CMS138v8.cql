library PreventiveCareandScreeningTobaccoUseScreeningandCessationIntervention version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

//include MATGlobalCommonFunctions version '4.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Health & Behavioral Assessment - Individual": 'urn:oid:2.16.840.1.113883.3.526.3.1020'
valueset "Health and Behavioral Assessment - Initial": 'urn:oid:2.16.840.1.113883.3.526.3.1245'
valueset "Health and Behavioral Assessment, Reassessment": 'urn:oid:2.16.840.1.113883.3.526.3.1529'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Limited Life Expectancy": 'urn:oid:2.16.840.1.113883.3.526.3.1259'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Occupational Therapy Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services - Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services - Other": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1030'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'urn:oid:2.16.840.1.113883.3.526.3.1141'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Speech and Hearing Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1530'
valueset "Tobacco Non-User": 'urn:oid:2.16.840.1.113883.3.526.3.1189'
valueset "Tobacco Use Cessation Counseling": 'urn:oid:2.16.840.1.113883.3.526.3.509'
valueset "Tobacco Use Cessation Pharmacotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1190'
valueset "Tobacco Use Screening": 'urn:oid:2.16.840.1.113883.3.526.3.1278'
valueset "Tobacco User": 'urn:oid:2.16.840.1.113883.3.526.3.1170'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Office Based Visit During Measurement Period":
	( [Encounter: "Health & Behavioral Assessment - Individual"]
		union [Encounter: "Health and Behavioral Assessment - Initial"]
		union [Encounter: "Health and Behavioral Assessment, Reassessment"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Occupational Therapy Evaluation"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Ophthalmological Services"]
		union [Encounter: "Psych Visit - Diagnostic Evaluation"]
		union [Encounter: "Psych Visit - Psychotherapy"]
		union [Encounter: "Psychoanalysis"]
		union [Encounter: "Speech and Hearing Evaluation"] ) OfficeBasedEncounter
		where OfficeBasedEncounter.period during "Measurement Period"

define "Preventive Visit During Measurement Period":
	( [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services - Group Counseling"]
		union [Encounter: "Preventive Care Services - Other"]
		union [Encounter: "Preventive Care Services-Individual Counseling"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"] ) PreventiveEncounter
		where PreventiveEncounter.period during "Measurement Period"

define "Screened and Identified as Tobacco User":
	( Last([Observation: "Tobacco Use Screening"] TobaccoUseScreening
			where FHIRHelpers.ToDateTime(TobaccoUseScreening.issued) 24 months or less on or before 
			end of "Measurement Period"
	)) MostRecentTobaccoUseScreening
		where (MostRecentTobaccoUseScreening.value as string) in "Tobacco User"

define "Screened and Identified as Tobacco Non User":
	( Last([Observation: "Tobacco Use Screening"] TobaccoUseScreening
			where FHIRHelpers.ToDateTime(TobaccoUseScreening.issued) 24 months or less on or before 
			end of "Measurement Period"
	)) MostRecentTobaccoUseScreening
		where (MostRecentTobaccoUseScreening.value as string) in "Tobacco Non-User"

define "Denominator 1":
	"Initial Population"

define "Denominator 2":
	"Initial Population"
		and "Screened and Identified as Tobacco User" is not null

define "Denominator 3":
	"Initial Population"

define "Has Limited Life Expectancy":
	[Condition: "Limited Life Expectancy"] LimitedLifeExpectancy
		where (LimitedLifeExpectancy.onset as Period) overlaps after "Measurement Period"

define "Denominator Exceptions 1":
	exists "Medical Reason for Not Screening for Tobacco Use"
		or exists "Has Limited Life Expectancy"

define "Denominator Exceptions 2":
	exists "Medical Reason for Not Counseling Tobacco User"
		or exists "Medical Reason for Not Ordering Tobacco Cessation Pharmacotherapy"
		or exists "Has Limited Life Expectancy"

define "Denominator Exceptions 3":
	exists "Medical Reason for Not Screening for Tobacco Use"
		or exists "Medical Reason for Not Counseling Tobacco User"
		or exists "Medical Reason for Not Ordering Tobacco Cessation Pharmacotherapy"
		or exists "Has Limited Life Expectancy"

define "Tobacco User Received Cessation Counseling":
	[Procedure: "Tobacco Use Cessation Counseling"] TobaccoCessationCounseling
		with "Screened and Identified as Tobacco User" ScreenedTobaccoUser
			such that (TobaccoCessationCounseling.performed as Period) starts same or after FHIRHelpers.ToDateTime(ScreenedTobaccoUser.issued)
				and (TobaccoCessationCounseling.performed as Period) starts before 
				end of "Measurement Period"

define "Numerator 1":
	"Screened and Identified as Tobacco Non User" is not null
		or "Screened and Identified as Tobacco User" is not null

define "Numerator 2":
	exists "Tobacco User Received Cessation Counseling"
		or exists "Tobacco Cessation Pharmacotherapy Ordered for Tobacco User"
		or exists "Tobacco Cessation Pharmacotherapy Actively Being Taken by Tobacco User"

define "Numerator 3":
	"Screened and Identified as Tobacco Non User" is not null
		or ( "Screened and Identified as Tobacco User" is not null
				and ( exists "Tobacco User Received Cessation Counseling"
						or exists "Tobacco Cessation Pharmacotherapy Ordered for Tobacco User"
						or exists "Tobacco Cessation Pharmacotherapy Actively Being Taken by Tobacco User"
				)
		)

define "Tobacco Cessation Pharmacotherapy Actively Being Taken by Tobacco User":
	[MedicationStatement: "Tobacco Use Cessation Pharmacotherapy"] TakingPharmacotherapy
		with "Screened and Identified as Tobacco User" ScreenedTobaccoUser
			such that FHIRHelpers.ToDateTime(ScreenedTobaccoUser.issued) during TakingPharmacotherapy.effective as Period
				and (TakingPharmacotherapy.effective as Period) starts before 
				end of "Measurement Period"

define "Tobacco Cessation Pharmacotherapy Ordered for Tobacco User":
	[MedicationRequest: "Tobacco Use Cessation Pharmacotherapy"] PharmacotherapyOrdered
		with "Screened and Identified as Tobacco User" ScreenedTobaccoUser
			such that FHIRHelpers.ToDateTime(PharmacotherapyOrdered.authoredOn) same or after FHIRHelpers.ToDateTime(ScreenedTobaccoUser.issued)
				and FHIRHelpers.ToDateTime(PharmacotherapyOrdered.authoredOn) before 
				end of "Measurement Period"

define "Medical Reason for Not Counseling Tobacco User":
	[Procedure: "Tobacco Use Cessation Counseling"] NoTobaccoCessationCounseling
		with "Screened and Identified as Tobacco User" ScreenedTobaccoUser
			such that FHIRHelpers.ToDateTime(NoTobaccoCessationCounseling.performed as dateTime) same or after FHIRHelpers.ToDateTime(ScreenedTobaccoUser.issued)
				and FHIRHelpers.ToDateTime(NoTobaccoCessationCounseling.performed as dateTime) before 
				end of "Measurement Period"
		where NoTobaccoCessationCounseling.statusReason in "Medical Reason"

define "Medical Reason for Not Ordering Tobacco Cessation Pharmacotherapy":
	[MedicationRequest: "Tobacco Use Cessation Pharmacotherapy"] NoPharmacotherapyOrdered
		with "Screened and Identified as Tobacco User" ScreenedTobaccoUser
			such that FHIRHelpers.ToDateTime(NoPharmacotherapyOrdered.authoredOn) same or after FHIRHelpers.ToDateTime(ScreenedTobaccoUser.issued)
				and FHIRHelpers.ToDateTime(NoPharmacotherapyOrdered.authoredOn) before 
				end of "Measurement Period"
		where NoPharmacotherapyOrdered.statusReason in "Medical Reason"

define "Medical Reason for Not Screening for Tobacco Use":
	[Observation: "Tobacco Use Screening"] NoTobaccoUseScreening
		where FHIRHelpers.ToDateTime(NoTobaccoUseScreening.issued) 24 months or less before 
		end of "Measurement Period"
			and NoTobaccoUseScreening.dataAbsentReason in "Medical Reason"

define "Initial Population":
	exists(AgeInYearsAt(start of "Measurement Period") >= 18
		and ( Count("Office Based Visit During Measurement Period")>= 2
				or exists "Preventive Visit During Measurement Period"
		)
		)

library DiabetesEyeExam version '8.4.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers


//include MATGlobalCommonFunctions version '4.0.000' called Global
//include Hospice version '2.0.000' called Hospice
//include AdvancedIllnessandFrailtyExclusionECQM version '4.0.000' called FrailtyLTI

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Diabetic Retinopathy": 'urn:oid:2.16.840.1.113883.3.526.3.327'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Retinal or Dilated Eye Exam": 'urn:oid:2.16.840.1.113883.3.464.1003.115.12.1088'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012' 
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014' 

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'


parameter "Measurement Period" Interval<DateTime>

context Patient


define "Retinal Exam in Measurement Period":
	[Procedure: "Retinal or Dilated Eye Exam"] RetinalExam
		where RetinalExam.performed as Period during "Measurement Period"

define "Denominator":
	"Initial Population"

define "Qualifying Encounters":
	( [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Ophthalmological Services"] ) Encounter
		where Encounter.period during "Measurement Period"

define "Retinal Exam in Measurement Period or Year Prior":
	[Procedure: "Retinal or Dilated Eye Exam"] RetinalExam
		where 
		end of RetinalExam.performed as Period between start of "Measurement Period" - 1 year and 
		end of "Measurement Period"

define "Denominator Exclusions":
	exists (  AgeInYearsAt(start of "Measurement Period") >= 65
				and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
	)
		or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
		or Hospice."Has Hospice"

define "Diabetic Retinopathy Overlapping Measurement Period":
	exists ( [Condition: "Diabetic Retinopathy"] Retinopathy
			where Retinopathy.onset as Period overlaps "Measurement Period"
	)

define "Numerator":
	( "Diabetic Retinopathy Overlapping Measurement Period"
			and exists ( "Retinal Exam in Measurement Period" )
	)
		or ( not ( "Diabetic Retinopathy Overlapping Measurement Period" )
				and exists ( "Retinal Exam in Measurement Period or Year Prior" )
		)

define "Initial Population":
	exists (  AgeInYearsAt(start of "Measurement Period") >= 18 and AgeInYearsAt(start of "Measurement Period") < 75

	)
		and exists ( "Qualifying Encounters" )
		and exists ( [Condition: "Diabetes"] Diabetes
				where Diabetes.onset as Period overlaps "Measurement Period"
		)
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
            	
define "Advanced Illness and Frailty Exclusion Including Under Age 80":
	//If the measure does NOT include populations age 80 and older, then use this logic:
	exists (  AgeInYearsAt(start of "Measurement Period") >= 65

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

define "Long Term Care Periods During Measurement Period":
	( [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Nursing Facility Visit"] ) LongTermFacilityEncounter
		where LongTermFacilityEncounter.period overlaps "Measurement Period"
		return LongTermFacilityEncounter.period
			intersect "Measurement Period"

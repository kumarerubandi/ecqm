library FunctionalStatusAssessmentforTotalHipReplacement version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fracture - Lower Body": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1037'
valueset "Hip Dysfunction and Osteoarthritis Outcome Score for Joint Replacement [HOOSJR]": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1210'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Primary THA Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1006'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Activities of daily living score [HOOS]": '72095-3' from "LOINC" display 'Activities of daily living score [HOOS]'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Pain score [HOOS]": '72097-9' from "LOINC" display 'Pain score [HOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [HOOS]": '72093-8' from "LOINC" display 'Quality of life score [HOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [HOOS]": '72094-6' from "LOINC" display 'Sport-recreation score [HOOS]'
code "Symptoms score [HOOS]": '72096-1' from "LOINC" display 'Symptoms score [HOOS]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Dementia Diagnosis":
	[Condition: "Severe dementia (disorder)"] Dementia
		where Dementia.clinicalStatus.coding[0].code='active'
			and Interval[ToDateTime(Dementia.onset),ToDateTime(Dementia.abatement)] overlaps "Measurement Period"

define "Total Hip Arthroplasty with 2 or More Lower Body Fractures":
	"Total Hip Arthroplasty Procedure" THAProcedure
		where Count([Condition: "Fracture - Lower Body"] LowerBodyFracture
				where LowerBodyFracture.clinicalStatus.coding[0].code='active'
			    and Interval[ToDateTime(LowerBodyFracture.onset),ToDateTime(LowerBodyFracture.abatement)] starts less than 1 day on or before (THAProcedure.performed as Period)
		)>= 2

define "Denominator Exclusions":
	"Has Hospice"
		or exists ( "Total Hip Arthroplasty with 2 or More Lower Body Fractures" )
		or exists ( "Dementia Diagnosis" )

define "Total Hip Arthroplasty Procedure":
	( [Procedure: "Primary THA Procedure"] THAProcedure
			where THAProcedure.status='completed'
			    and (THAProcedure.performed as Period) starts 12 months or less before start of "Measurement Period"
	)

define "HOOS Total Assessment Scores":
	[Observation: "Quality of life score [HOOS]"] HOOSLifeQuality
		with [Observation: "Sport-recreation score [HOOS]"] HOOSSport
			such that (HOOSSport.status = 'final' or HOOSSport.status = 'amended' or HOOSSport.status = 'corrected')
			and HOOSLifeQuality.authorDatetime same day as HOOSSport.authorDatetime
				and HOOSSport.value is not null
		with [Observation: "Activities of daily living score [HOOS]"] HOOSActivityScore
			such that (HOOSActivityScore.status = 'final' or HOOSActivityScore.status = 'amended' or HOOSActivityScore.status = 'corrected')
			    and HOOSLifeQuality.authorDatetime same day as HOOSActivityScore.authorDatetime
				and HOOSActivityScore.value is not null
		with [Observation: "Symptoms score [HOOS]"] HOOSSymptoms
			such that (HOOSSymptoms.status = 'final' or HOOSSymptoms.status = 'amended' or HOOSSymptoms.status = 'corrected')
			    and HOOSLifeQuality.authorDatetime same day as HOOSSymptoms.authorDatetime
				and HOOSSymptoms.value is not null
		with [Observation: "Pain score [HOOS]"] HOOSPain
			such that (HOOSPain.status = 'final' or HOOSPain.status = 'amended' or HOOSPain.status = 'corrected')
			    and HOOSLifeQuality.authorDatetime same day as HOOSPain.authorDatetime
				and HOOSPain.value is not null
		where (HOOSLifeQuality.status = 'final' or HOOSLifeQuality.status = 'amended' or HOOSLifeQuality.status = 'corrected')
		and HOOSLifeQuality.value is not null

define "HOOSJr Total Assessment Scores":
	( [Observation: "Hip Dysfunction and Osteoarthritis Outcome Score for Joint Replacement [HOOSJR]"] HOOSJr
			where (HOOSJr.status = 'final' or HOOSJr.status = 'amended' or HOOSJr.status = 'corrected')
			and HOOSJr.value is not null
	)

define "PROMIS10 Total Assessment Scores":
	[Observation: "PROMIS-10 Global Mental Health (GMH) score T-score"] Promis10MentalScore
		with [Observation: "PROMIS-10 Global Physical Health (GPH) score T-score"] Promis10PhysicalScore
			such that (Promis10PhysicalScore.status = 'final' or Promis10PhysicalScore.status = 'amended' or Promis10PhysicalScore.status = 'corrected')
			    and Promis10MentalScore.authorDatetime same day as Promis10PhysicalScore.authorDatetime
				and Promis10PhysicalScore.value is not null
		where (Promis10MentalScore.status = 'final' or Promis10MentalScore.status = 'amended' or Promis10MentalScore.status = 'corrected')
			    and Promis10MentalScore.value is not null

define "Qualifying Encounter":
	( [Encounter: "Outpatient Consultation"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"] ) ValidEncounters
		where (ValidEncounters.status='in-progress' or ValidEncounters.status='finished')
		    and ValidEncounters.period during "Measurement Period"

define "Assessed Initial and Followup HOOSJr with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "HOOSJr Total Assessment Scores" InitialHipAssessment
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of InitialHipAssessment.authorDatetime
		with "HOOSJr Total Assessment Scores" FollowupHipAssessment
			such that FollowupHipAssessment.authorDatetime 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FollowupHipAssessment.authorDatetime 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup HOOS with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "HOOS Total Assessment Scores" InitialHipAssessmentHOOS
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of InitialHipAssessmentHOOS.authorDatetime
		with "HOOS Total Assessment Scores" FollowupHipAssessmentHOOS
			such that FollowupHipAssessmentHOOS.authorDatetime 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FollowupHipAssessmentHOOS.authorDatetime 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup PROMIS10 with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "PROMIS10 Total Assessment Scores" InitialHipAssessmentPROMIS10
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of InitialHipAssessmentPROMIS10.authorDatetime
		with "PROMIS10 Total Assessment Scores" FollowupHipAssessmentPROMIS10
			such that FollowupHipAssessmentPROMIS10.authorDatetime 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FollowupHipAssessmentPROMIS10.authorDatetime 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup VR12 Oblique with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "VR12 Oblique Total Assessment Scores" InitialHipAssessmentOblique
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of InitialHipAssessmentOblique.authorDatetime
		with "VR12 Oblique Total Assessment Scores" FollowupHipAssessmentOblique
			such that FollowupHipAssessmentOblique.authorDatetime 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FollowupHipAssessmentOblique.authorDatetime 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup VR12 Orthogonal with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "VR12 Orthogonal Total Assessment Scores" InitialHipAssessmentOrthogonal
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of InitialHipAssessmentOrthogonal.authorDatetime
		with "VR12 Orthogonal Total Assessment Scores" FollowupHipAssessmentOrthogonal
			such that FollowupHipAssessmentOrthogonal.authorDatetime 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FollowupHipAssessmentOrthogonal.authorDatetime 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Numerator":
	exists ( "Assessed Initial and Followup HOOS with THA" )
		or exists ( "Assessed Initial and Followup HOOSJr with THA" )
		or exists ( "Assessed Initial and Followup PROMIS10 with THA" )
		or exists ( "Assessed Initial and Followup VR12 Oblique with THA" )
		or exists ( "Assessed Initial and Followup VR12 Orthogonal with THA" )

define "VR12 Orthogonal Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalOrthogonal
		where (VR12MentalOrthogonal.status = 'final' or VR12MentalOrthogonal.status = 'amended' or VR12MentalOrthogonal.status = 'corrected')
			    and VR12MentalOrthogonal.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalOrthogonal
			where (VR12PhysicalOrthogonal.status = 'final' or VR12PhysicalOrthogonal.status = 'amended' or VR12PhysicalOrthogonal.status = 'corrected')
			    and VR12PhysicalOrthogonal.value is not null ) VR12PhysicalScore
			such that VR12MentalScore.authorDatetime same day as VR12PhysicalScore.authorDatetime

define "VR12 Oblique Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status = 'final' or VR12MentalAssessment.status = 'amended' or VR12MentalAssessment.status = 'corrected')
			    and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status = 'final' or VR12PhysicalAssessment.status = 'amended' or VR12PhysicalAssessment.status = 'corrected')
			    and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that VR12MentalScore.authorDatetime same day as VR12PhysicalScore.authorDatetime

define "Initial Population":
	exists ( "Total Hip Arthroplasty Procedure" )
		and exists ( "Qualifying Encounter" )
			and AgeInYearsAt(start of "Measurement Period")>= 19


define "Has Hospice":

            exists ( [Encounter: "Encounter Inpatient"] DischargeHospice
            		where (DischargeHospice.status='in-progress' or DischargeHospice.status='finished')
            		    and (( DischargeHospice.hospitalization.dischargeDisposition as Code ~ "Discharge to home for hospice care (procedure)"
            				or DischargeHospice.hospitalization.dischargeDisposition as Code ~ "Discharge to healthcare facility for hospice care (procedure)")
            		        )
            			and DischargeHospice.period ends during "Measurement Period"
                )
            	or exists ( [ServiceRequest: "Hospice care ambulatory"] HospiceOrder
            			where HospiceOrder.intent= 'order'
				and HospiceOrder.authoredOn during "Measurement Period"
            	)
            	or exists ( [Procedure: "Hospice care ambulatory"] HospicePerformed
            			where (HospicePerformed.performed as Period) overlaps "Measurement Period"
            	)
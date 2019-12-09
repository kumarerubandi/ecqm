library ColorectalCancerScreening version '8.4.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include AdvancedIllnessandFrailtyExclusionECQM version '4.0.000' called FrailtyLTI

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Colonoscopy": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1020'
valueset "CT Colonography": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1038'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fecal Occult Blood Test (FOBT)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1011'
valueset "FIT DNA": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1039'
valueset "Flexible Sigmoidoscopy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1010'
valueset "Malignant Neoplasm of Colon": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Total Colectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1019'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'

code "Birth date":'21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMED-CT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMED-CT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Flexible Sigmoidoscopy Performed":
	[Procedure: "Flexible Sigmoidoscopy"] FlexibleSigmoidoscopy
		where FlexibleSigmoidoscopy.status='completed'
      and (FlexibleSigmoidoscopy.performed as Period) ends 5 years or less on or before end of "Measurement Period"

define "Total Colectomy Performed":
	[Procedure: "Total Colectomy"] Colectomy
		where Colectomy.status='completed'
      and (Colectomy.performed as Period) starts on or before
		end of "Measurement Period"

define "Malignant Neoplasm":
	[Condition: "Malignant Neoplasm of Colon"] ColorectalCancer
		where Interval[FHIRHelpers.ToDateTime(ColorectalCancer.onset),FHIRHelpers.ToDateTime(ColorectalCancer.abatement)] starts on or before
		end of "Measurement Period"

define "Fecal Occult Blood Test Performed":
	[Observation: "Fecal Occult Blood Test (FOBT)"] FecalOccultResult
		where FecalOccultResult.value is not null
			and FHIRHelpers.ToDateTime(FecalOccultResult.issued) during "Measurement Period"

define "Colonoscopy Performed":
	[Procedure: "Colonoscopy"] Colonoscopy
		where Colonoscopy.status='completed'
      and (Colonoscopy.performed as Period) ends 10 years or less on or before
		end of "Measurement Period"

define "Numerator":
	exists "Colonoscopy Performed"
		or exists "Fecal Occult Blood Test Performed"
		or exists "Flexible Sigmoidoscopy Performed"
		or exists "Fecal Immunochemical Test DNA Performed"
		or exists "CT Colonography Performed"

define "Fecal Immunochemical Test DNA Performed":
	[Observation: "FIT DNA"] FitDNA
		where FitDNA.value is not null
			and FHIRHelpers.ToDateTime(FitDNA.issued) occurs 3 years or less on or before
			end of "Measurement Period"

define "CT Colonography Performed":
	[DiagnosticReport: "CT Colonography"] Colonography
		where (Colonography.status='final' or Colonography.status='amended' or Colonography.status='corrected' or Colonography.status='appended')
		    and (Colonography.effective as Period) ends 5 years or less on or before end of "Measurement Period"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")in Interval[50, 75 )
			and exists "Qualifying Encounters"

define "Denominator Exclusions":
	"Has Hospice"
		or exists "Malignant Neoplasm"
		or exists "Total Colectomy Performed"
		or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
		or ( AgeInYearsAt(start of "Measurement Period")>= 65
					and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
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

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
					and ValidEncounter.period during "Measurement Period"
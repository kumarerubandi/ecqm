library FallsScreeningforFutureFallRisk version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Ambulatory Status": 'urn:oid:2.16.840.1.113883.3.464.1003.118.11.1219'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Audiology Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1066'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services - Nursing Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Falls Screening": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1028'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Patient not ambulatory": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1009'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Numerator":
	exists [Observation: "Falls Screening"] FallsScreen
		where (FallsScreen.status = 'final' or FallsScreen.status = 'amended' or FallsScreen.status = 'corrected')
			and FHIRHelpers.ToDateTime(FallsScreen.issued) during "Measurement Period"

define "Qualifying Encounter":
	( [Encounter: "Office Visit"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Ophthalmological Services"]
		union [Encounter: "Preventive Care Services-Individual Counseling"]
		union [Encounter: "Discharge Services - Nursing Facility"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Audiology Visit"] ) ValidEncounter
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		    and ValidEncounter.period during "Measurement Period"

define "Ambulatory Status Assessment During Measurement Period":
	[Observation: "Ambulatory Status"] AmbulatoryStatusAssessment
		where (AmbulatoryStatusAssessment.status = 'final' or AmbulatoryStatusAssessment.status = 'amended' or AmbulatoryStatusAssessment.status = 'corrected')
			and FHIRHelpers.ToDateTime(AmbulatoryStatusAssessment.issued) during "Measurement Period"
			and AmbulatoryStatusAssessment.value is not null

define "Assessed as Not Ambulatory During Measurement Period":
	exists ( "Ambulatory Status Assessment During Measurement Period" AmbulatoryStatusAssessed
			where AmbulatoryStatusAssessed.value in "Patient not ambulatory"
	)

define "Assessed as Not Ambulatory Prior to Measurement Period":
	Last([Observation: "Ambulatory Status"] PriorAmbulatoryStatus
			where (PriorAmbulatoryStatus.status = 'final' or PriorAmbulatoryStatus.status = 'amended' or PriorAmbulatoryStatus.status = 'corrected')
			and FHIRHelpers.ToDateTime(PriorAmbulatoryStatus.issued) before start "Measurement Period"
			sort by FHIRHelpers.ToDateTime(issued)
	).value in "Patient not ambulatory"

define "Denominator Exclusions":
	"Assessed as Not Ambulatory During Measurement Period"
		or ( "Assessed as Not Ambulatory Prior to Measurement Period"
				and not exists ( "Ambulatory Status Assessment During Measurement Period" )
		)
		or "Has Hospice"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 65
		and exists "Qualifying Encounter"

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
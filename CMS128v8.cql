library AntidepressantMedicationManagement version '8.3.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Antidepressant Medication": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1213'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Major Depression": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1007'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Evaluation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1082'
valueset "Telephone Management": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1053'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Birth date":'21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Numerator One":
	"Cumulative Medication Duration Greater Than or Equal to 84 Days"

define "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period":
	First([MedicationDispense: "Antidepressant Medication"] Antidepressant
			where FHIRHelpers.ToDateTime(Antidepressant.whenHandedOver) 245 days or less before start of "Measurement Period"
				or FHIRHelpers.ToDateTime(Antidepressant.whenHandedOver) 120 days or less on or after start of "Measurement Period"
			sort by FHIRHelpers.ToDateTime(whenHandedOver)
	)

define "Denominator":
	"Initial Population"

define "Numerator Two":
	"Cumulative Medication Duration Greater Than or Equal to 180 Days"

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Telephone Management"]
		union [Encounter: "Telephone Evaluation"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Psych Visit - Diagnostic Evaluation"]
		union [Encounter: "Psych Visit - Psychotherapy"] ) ValidEncounter
		let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		    and start of ValidEncounter.period within 60 days of FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver)

define "Has Initial Major Depression Diagnosis":
	exists ( [Condition: "Major Depression"] MajorDepression
			let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
			where start of Interval[FHIRHelpers.ToDateTime(MajorDepression.onset),FHIRHelpers.ToDateTime(MajorDepression.abatement)] within 60 days of FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver)
	)

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 18
		and "Has Initial Major Depression Diagnosis"
		and exists "Qualifying Encounters"

define "Denominator Exclusions":
	"Has Hospice"
		or exists ( [MedicationStatement: "Antidepressant Medication"] OnAntiDepressant
				let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
				where OnAntiDepressant.status='active'
					and (OnAntiDepressant.effective as Period) overlaps Interval[FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver) - 105 days, FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver) )
		)

define "Antidepressant Taken In 231 Days After Initial Dispense":
	[MedicationStatement: "Antidepressant Medication"] ActiveAntidepressant
		let InitialAntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
		where ActiveAntidepressant.status='active'
					and (ActiveAntidepressant.effective as Period) starts 231 days or less on or after day of FHIRHelpers.ToDateTime(InitialAntidepressantDispensed.whenHandedOver)
		return (ActiveAntidepressant.effective as Period)
			intersect Interval[FHIRHelpers.ToDateTime(InitialAntidepressantDispensed.whenHandedOver), FHIRHelpers.ToDateTime(InitialAntidepressantDispensed.whenHandedOver) + 231 days]

define "Cumulative Medication Duration Greater Than or Equal to 180 Days":
	"Cumulative Medication Duration"("Antidepressant Taken In 231 Days After Initial Dispense")>= 180

define "Cumulative Medication Duration Greater Than or Equal to 84 Days":
	"Cumulative Medication Duration"("Antidepressant Taken In 114 Days After Initial Dispense")>= 84

define "Antidepressant Taken In 114 Days After Initial Dispense":
	[MedicationStatement: "Antidepressant Medication"] ActiveAntidepressant
		let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
		where ActiveAntidepressant.status='active'
					and (ActiveAntidepressant.effective as Period) starts 114 days or less on or after day of FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver)
		return (ActiveAntidepressant.effective as Period)
			intersect Interval[FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver), FHIRHelpers.ToDateTime(AntidepressantDispensed.whenHandedOver) + 114 days]

define function "Cumulative Medication Duration"(Medication List<Interval<DateTime>>):
	Sum((collapse(Medication))CumulativeAntidepressant
			return all duration in days of CumulativeAntidepressant
	)

define "Has Hospice":

            exists ( [Encounter: "Encounter Inpatient"] DischargeHospice
            		where (DischargeHospice.status='in-progress' or DischargeHospice.status='finished')
            		    and (( FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition) in "Discharge to home for hospice care (procedure)"
            				or FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition) in "Discharge to healthcare facility for hospice care (procedure)")
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
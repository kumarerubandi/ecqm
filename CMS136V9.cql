library FollowUpCareforChildrenPrescribedADHDMedicationADD version '9.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers


//include MATGlobalCommonFunctions version '4.0.000' called Global
//include Hospice version '2.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://snomed.info/sct'


valueset "ADHD Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1171'
valueset "Ambulatory": 'urn:oid:2.16.840.1.113883.3.464.1003.122.12.1003'
valueset "Behavioral Health Follow-up Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1054'
valueset "Discharge Services- Observation Care": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1039'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hospital Observation Care - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Mental Health Diagnoses": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1004'
valueset "Narcolepsy": 'urn:oid:2.16.840.1.113883.3.464.1003.114.12.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychotherapy and Pharmacologic Management": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1055'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Substance Abuse": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1004'
valueset "Telehealth Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1031'
valueset "Telephone Management": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1053'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'


code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'


parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator 1":
	"Initial Population 1"

define "Denominator 2":
	"Initial Population 2"

define "Qualifying Encounter":
	(  [Encounter: "Office Visit"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"] ) ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Qualifying Numerator Encounter":
	( [Encounter: "Office Visit"]
			union [Encounter: "Hospital Observation Care - Initial"]
			union [Encounter: "Preventive Care Services - Group Counseling"]
			union [Encounter: "Behavioral Health Follow-up Visit"]
			union [Encounter: "Preventive Care Services-Individual Counseling"]
			//union ( [Encounter: "Psychotherapy and Pharmacologic Management"] PsychPharmMgmt
					//where exists ( PsychPharmMgmt.facilityLocations Location
							//where Location.code in "Ambulatory"
					//)
			//)
			union [Encounter: "Discharge Services- Observation Care"]
			union [Encounter: "Outpatient Consultation"]
			union [Encounter: "Home Healthcare Services"]
			union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
			union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
			union [Encounter: "Psych Visit - Diagnostic Evaluation"]
			union [Encounter: "Psych Visit - Psychotherapy"]
	)

define "Narcolepsy Exclusion":
	[Condition: "Narcolepsy"] Narcolepsy
		where Narcolepsy.onset as Period starts before 
		end "Measurement Period"

define "First ADHD Medication Dispensed":
	First([MedicationDispense: "ADHD Medications"] FirstADHDMedication
			where FHIRHelpers.ToDateTime(FirstADHDMedication.whenPrepared) 60 days or less after start "Measurement Period"
				or FHIRHelpers.ToDateTime(FirstADHDMedication.whenPrepared) 90 days or less on or before start "Measurement Period"
	)

define "Inpatient Stay with Qualifying Diagnosis within 30 Days of Initial ADHD Dispense":
	[Encounter: "Encounter Inpatient"] InpatientStay
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that InpatientStay.period starts 30 days or less on or after InitialADHDMedication.whenPrepared
		where ( InpatientStay.diagnosis.rank = '1' in "Mental Health Diagnoses"
				or InpatientStay.diagnosis.rank = '1' in "Substance Abuse"
		)

define "Inpatient Stay with Qualifying Diagnosis within 300 Days of Initial ADHD Dispense":
	[Encounter: "Encounter Inpatient"] InpatientStay
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that InpatientStay.period starts 300 days or less on or after day of InitialADHDMedication.whenPrepared
		where ( InpatientStay.diagnosis.rank = '1' in "Mental Health Diagnoses"
				or InpatientStay.diagnosis.rank = '1' in "Substance Abuse"
		)

define "ADHD Medications Taken within 300 Days after First ADHD Medication Dispensed":
	[MedicationAdministration: "ADHD Medications"] ActiveADHDMedications
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that (ActiveADHDMedications.effective as Period) starts 300 days or less on or after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenPrepared)

define "Encounter 30 Days after Initial ADHD Medication":
	( "Qualifying Numerator Encounter" ValidNumeratorEncounter
			with "First ADHD Medication Dispensed" InitialADHDMedication
				such that ValidNumeratorEncounter.period starts 30 days or less on or after InitialADHDMedication.whenPrepared
	)

define "Encounters 300 Days after Initial ADHD Medication":
	"Qualifying Numerator Encounter" ValidNumeratorEncounter
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that ValidNumeratorEncounter.period starts 31 days or more after day of InitialADHDMedication.whenPrepared
				and ValidNumeratorEncounter.period starts 300 days or less after day of InitialADHDMedication.whenPrepared

define "Previously on ADHD Medication Exclusion":
	[MedicationAdministration: "ADHD Medications"] ActiveADHDMedication
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that ActiveADHDMedication.effective as Period starts 120 days or less before InitialADHDMedication.whenPrepared

define "Telehealth Services or Telephone Management Encounter":
	( [Encounter: "Telehealth Services"]
		union [Encounter: "Telephone Management"] ) TelehealthEncounter
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that TelehealthEncounter.period starts 31 days or more after day of InitialADHDMedication.whenPrepared
				and TelehealthEncounter.period starts 300 days or less after day of InitialADHDMedication.whenPrepared

define "Two or More Followup Encounters":
	Count("Encounters 300 Days after Initial ADHD Medication")>= 2

define "Denominator Exclusions 1":
	"Has Hospice"
		or exists ( "Narcolepsy Exclusion" )
		or exists ( "Inpatient Stay with Qualifying Diagnosis within 30 Days of Initial ADHD Dispense" )
		or exists ( "Previously on ADHD Medication Exclusion" )

define "Denominator Exclusions 2":
	"Has Hospice"
		or exists ( "Narcolepsy Exclusion" )
		or exists ( "Inpatient Stay with Qualifying Diagnosis within 300 Days of Initial ADHD Dispense" )
		or exists ( "Previously on ADHD Medication Exclusion" )

define "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days":
	"Cumulative Medication Duration"("ADHD Medications Taken within 300 Days after First ADHD Medication Dispensed")>= 210

define "Numerator 2":
	exists ( "Encounter 30 Days after Initial ADHD Medication" )
		and ( ( "Two or More Followup Encounters" )
				or ( exists ( "Encounters 300 Days after Initial ADHD Medication" )
						and exists ( "Telehealth Services or Telephone Management Encounter" )
				)
		)

define "Numerator 1":
	exists ( "Encounter 30 Days after Initial ADHD Medication" )

define "Initial Population 1":
	exists ( AgeInYearsAt(start of "Measurement Period") >= 6 and AgeInYearsAt(start of "Measurement Period") < 12)
			and exists ( "Qualifying Encounter" )
			and "First ADHD Medication Dispensed" is not null

define "Initial Population 2":
	exists  ( AgeInYearsAt(start of "Measurement Period") >= 6 and AgeInYearsAt(start of "Measurement Period") < 12)
			and exists ( "Qualifying Encounter" )
			and "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days"
			and "First ADHD Medication Dispensed" is not null

define function "Cumulative Medication Duration"(MedicationAdministration List<"MedicationAdministration">):
	Sum((collapse(MedicationAdministration.effective as Period))MedicationPeriod
			return all duration in days of MedicationPeriod
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
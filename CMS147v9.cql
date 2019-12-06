library PreventiveCareandScreeningInfluenzaImmunization version '9.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Allergy to Eggs": 'urn:oid:2.16.840.1.113883.3.526.3.1253'
valueset "Allergy to Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.526.3.1256'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services - Nursing Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Egg Substance": 'urn:oid:2.16.840.1.113883.3.526.3.1537'
valueset "Encounter-Influenza": 'urn:oid:2.16.840.1.113883.3.526.3.1252'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hemodialysis": 'urn:oid:2.16.840.1.113883.3.526.3.1083'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Influenza Vaccination": 'urn:oid:2.16.840.1.113883.3.526.3.402'
valueset "Influenza Vaccination Declined": 'urn:oid:2.16.840.1.113883.3.526.3.1255'
valueset "Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.526.3.1254'
valueset "Intolerance to Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.526.3.1257'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Peritoneal Dialysis": 'urn:oid:2.16.840.1.113883.3.526.3.1084'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services - Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services - Other": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1030'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Previous Receipt of Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.526.3.1185'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "System Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1009'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Egg Substance Allergy":
	[AllergyIntolerance: "Egg Substance"] AllergyEggSubstance
		where (AllergyEggSubstance.onset as Period) overlaps after "Influenza Season"

define "Initial Qualifying Encounter During Measurement Period":
	( [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Patient Provider Interaction"]
		union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Individual Counseling"]
		union [Encounter: "Preventive Care Services - Group Counseling"]
		union [Encounter: "Preventive Care Services - Other"]
		union [Encounter: "Discharge Services - Nursing Facility"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"] ) QualifyingEncounter
		where (QualifyingEncounter.status='in-progress' or QualifyingEncounter.status='finished')
		            and QualifyingEncounter.period during "Measurement Period"

define "Hemodialysis During Measurement Period":
	[Procedure: "Hemodialysis"] Hemodialysis
		where Hemodialysis.status='completed'
          and (Hemodialysis.performed as Period) during "Measurement Period"

define "Peritoneal Dialysis During Measurement Period":
	[Procedure: "Peritoneal Dialysis"] PeritonealDialysis
		where PeritonealDialysis.status='completed'
          and (PeritonealDialysis.performed as Period) during "Measurement Period"

define "Peritoneal Dialysis During Influenza Season":
	[Procedure: "Peritoneal Dialysis"] FluSeasonPeritonealDialysis
		where FluSeasonPeritonealDialysis.status='completed'
          and (FluSeasonPeritonealDialysis.performed as Period) starts during "Influenza Season"

define "Intolerance of Influenza Vaccination Procedure":
	[AllergyIntolerance: "Influenza Vaccination"] FluVaccinationIntolerance
		where (FluVaccinationIntolerance.onset as Period) overlaps after "Influenza Season"

define "Influenza Vaccination Procedure":
	[Procedure: "Influenza Vaccination"] FluVaccination
		where FluVaccination.status='completed'
          and (FluVaccination.performed as Period) starts during "Influenza Season Including August and September of the Prior Year"

define "Influenza Immunization Administered":
	[Immunization: "Influenza Vaccine"] AdministeredFluVaccine
		where FHIRHelpers.ToDateTime(AdministeredFluVaccine.recorded) during "Influenza Season Including August and September of the Prior Year"

define "Hemodialysis During Influenza Season":
	[Procedure: "Hemodialysis"] FluSeasonHemodialysis
		where FluSeasonHemodialysis.status='completed'
          and (FluSeasonHemodialysis.performed as Period) starts during "Influenza Season"

define "Encounter During Influenza Season":
	[Encounter: "Encounter-Influenza"] FluEncounter
		where (FluEncounter.status='in-progress' or FluEncounter.status='finished')
		            and FluEncounter.period starts during "Influenza Season"

define "Diagnosis of Intolerance to Influenza Vaccine":
	[Condition: "Intolerance to Influenza Vaccine"] FluVaccineIntoleranceDiagnosis
		where Interval[FHIRHelpers.ToDateTime(FluVaccineIntoleranceDiagnosis.onset),FHIRHelpers.ToDateTime(FluVaccineIntoleranceDiagnosis.abatement)] overlaps after "Influenza Season"

define "Allergy or Intolerance to Influenza Vaccine":
	[AllergyIntolerance: "Influenza Vaccine"] FluVaccineAllergyIntolerance
		where (FluVaccineAllergyIntolerance.onset as Period) overlaps after "Influenza Season"

define "Denominator":
	"Initial Population"
		and ( exists "Encounter During Influenza Season"
				or exists "Hemodialysis During Influenza Season"
				or exists "Peritoneal Dialysis During Influenza Season"
		)

define "Diagnosis of Allergy to Egg":
	[Condition: "Allergy to Eggs"] EggAllergy
		where Interval[FHIRHelpers.ToDateTime(EggAllergy.onset),FHIRHelpers.ToDateTime(EggAllergy.abatement)] overlaps after "Influenza Season"

define "Diagnosis of Allergy to Influenza Vaccine":
	[Condition: "Allergy to Influenza Vaccine"] FluVaccineAllergyDiagnosis
		where Interval[FHIRHelpers.ToDateTime(FluVaccineAllergyDiagnosis.onset),FHIRHelpers.ToDateTime(FluVaccineAllergyDiagnosis.abatement)] overlaps after "Influenza Season"

define "Medical Patient or System Reason for Not Performing Influenza Vaccination":
	[Procedure: "Influenza Vaccination"] NoFluVaccination
		where NoFluVaccination.status='not-done'
      and start of (NoFluVaccination.performed as Period) during "Influenza Season Including August and September of the Prior Year"
			and ( NoFluVaccination.statusReason in "Medical Reason"
					or NoFluVaccination.statusReason in "Patient Reason"
					or NoFluVaccination.statusReason in "System Reason"
					or NoFluVaccination.statusReason in "Influenza Vaccination Declined"
			)

define "Denominator Exceptions":
	exists "Medical Patient or System Reason for Not Performing Influenza Vaccination"
		or exists "Medical Patient or System Reason for Not Administering Influenza Vaccine"
		or exists "Diagnosis of Allergy to Egg"
		or exists "Egg Substance Allergy"
		or exists "Diagnosis of Allergy to Influenza Vaccine"
		or exists "Diagnosis of Intolerance to Influenza Vaccine"
		or exists "Intolerance of Influenza Vaccination Procedure"
		or exists "Allergy or Intolerance to Influenza Vaccine"

define "Influenza Season":
	Interval[start of "Measurement Period" - 3 months, start of "Measurement Period" + 3 months )

define "Influenza Season Including August and September of the Prior Year":
	Interval[start of "Measurement Period" - 5 months, start of "Measurement Period" + 3 months )

define "Medical Patient or System Reason for Not Administering Influenza Vaccine":
	[Immunization: "Influenza Vaccine"] NoFluVaccine
		where NoFluVaccine.status='not-done'
      and FHIRHelpers.ToDateTime(NoFluVaccine.recorded) during "Influenza Season Including August and September of the Prior Year"
			and ( NoFluVaccine.statusReason in "Medical Reason"
					or NoFluVaccine.statusReason in "Patient Reason"
					or NoFluVaccine.statusReason in "System Reason"
					or NoFluVaccine.statusReason in "Influenza Vaccination Declined"
			)

define "Influenza Vaccine Previously Received":
	[Observation: "Previous Receipt of Influenza Vaccine"] PreviousReceiptFluVaccine
		where (PreviousReceiptFluVaccine.status = 'final' or PreviousReceiptFluVaccine.status = 'amended' or PreviousReceiptFluVaccine.status = 'corrected')
			and FHIRHelpers.ToDateTime(PreviousReceiptFluVaccine.issued) during "Influenza Season Including August and September of the Prior Year"

define "Numerator":
	exists "Influenza Vaccination Procedure"
		or exists "Influenza Immunization Administered"
		or exists "Influenza Vaccine Previously Received"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 6
		and ( exists "Initial Qualifying Encounter During Measurement Period"
				or exists "Hemodialysis During Measurement Period"
				or exists "Peritoneal Dialysis During Measurement Period"
		)
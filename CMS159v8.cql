library DepressionRemissionatTwelveMonths version '8.6.000'

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

valueset "Bipolar Disorder": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.128'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Contact or Office Visit": 'urn:oid:2.16.840.1.113762.1.4.1080.5'
valueset "Dysthymia": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.254'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Major Depression Including Remission": 'urn:oid:2.16.840.113883.3.67.1.101.3.2444'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Palliative Care": 'urn:oid:2.16.840.1.113883.3.600.1.1579'
valueset "Palliative care encounter": 'urn:oid:2.16.840.1.113883.3.600.1.1575'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Personality Disorder": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.246'
valueset "Pervasive Developmental Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1152'
valueset "PHQ 9 and PHQ 9M Tools": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.263'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Schizophrenia or Psychotic Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1104'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Dead (finding)": '419099009' from "SNOMED-CT" display 'Dead (finding)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Numerator":
	FHIRHelpers.ToInteger(Last([Observation: "PHQ 9 and PHQ 9M Tools"] DepressionAssessment
			where (DepressionAssessment.status = 'final' or DepressionAssessment.status = 'amended' or DepressionAssessment.status = 'corrected')
					and "ToDate"(FHIRHelpers.ToDateTime(DepressionAssessment.issued))in "Follow-Up Assessment Period"
			sort by FHIRHelpers.ToDateTime(issued)
	).value) < 5

define "Denominator Identification Period":
	Interval[start of "Measurement Period" - 14 months, start of "Measurement Period" - 2 months )

define "Depression Diagnoses":
	([Condition: "Major Depression Including Remission"]C where C.clinicalStatus.coding[0].code='active')
		union ([Condition: "Dysthymia"]C where C.clinicalStatus.coding[0].code='active')

define "Denominator":
	"Initial Population"

define "Follow-Up Assessment Period":
	"Index Depression Assessment" FirstIndexAssessment
		return Interval["ToDate"(FHIRHelpers.ToDateTime(FirstIndexAssessment.issued))+ 12 months - 60 days, "ToDate"(FHIRHelpers.ToDateTime(FirstIndexAssessment.issued))+ 12 months + 60 days]

define "Disorder Diagnoses":
	( [Condition: "Bipolar Disorder"]
		union [Condition: "Personality Disorder"]
		union [Condition: "Schizophrenia or Psychotic Disorder"]
		union [Condition: "Pervasive Developmental Disorder"] ) DisorderDiagnoses
		where DisorderDiagnoses.clinicalStatus.coding[0].code='active'
				and Interval[FHIRHelpers.ToDateTime(DisorderDiagnoses.onset),FHIRHelpers.ToDateTime(DisorderDiagnoses.abatement)] starts before end of "Follow-Up Assessment Period"

define "Palliative Care Order":
	[ServiceRequest: "Palliative Care"] PalliativeCare
		where PalliativeCare.intent='order'
			and FHIRHelpers.ToDateTime(PalliativeCare.authoredOn) occurs before end of "Follow-Up Assessment Period"

define "Encounter Palliative Care":
	[Encounter: "Palliative care encounter"] PalliativeCareEncounter
		where (PalliativeCareEncounter.status='in-progress' or PalliativeCareEncounter.status='finished')
		            and PalliativeCareEncounter.period starts before end of "Follow-Up Assessment Period"

define "Patient Expired":
		//FHIRHelpers.ToBoolean(Patient.deceased)=true and
		FHIRHelpers.ToDateTime(Patient.deceased) occurs before end of "Follow-Up Assessment Period"

define "Depression Encounter":
	[Encounter: "Contact or Office Visit"] ValidEncounter
		with "Depression Diagnoses" Depression
			such that (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		            and ValidEncounter.period overlaps Interval[FHIRHelpers.ToDateTime(Depression.onset),FHIRHelpers.ToDateTime(Depression.abatement)]
								and ValidEncounter.period ends during "Denominator Identification Period"

define "Index Depression Assessment":
	First("Depression Assessments Greater than 9" DepressionAssessment
			with "Depression Encounter" DepressionEncounter
				such that FHIRHelpers.ToDateTime(DepressionAssessment.issued) is not null
					and FHIRHelpers.ToDateTime(DepressionAssessment.issued) in Interval["ToDate"((start of DepressionEncounter.period)- 7 days),
					end of DepressionEncounter.period]
			sort by FHIRHelpers.ToDateTime(issued)
	)

define "Depression Assessments Greater than 9":
	[Observation: "PHQ 9 and PHQ 9M Tools"] DepressionAssessment
		where (DepressionAssessment.status = 'final' or DepressionAssessment.status = 'amended' or DepressionAssessment.status = 'corrected')
					and FHIRHelpers.ToInteger(DepressionAssessment.value) > 9

define "Long Term Care Encounter":
	[Encounter: "Care Services in Long-Term Residential Facility"] EncounterLongTermCare
		where (EncounterLongTermCare.status='in-progress' or EncounterLongTermCare.status='finished')
		            and EncounterLongTermCare.period starts before end of "Follow-Up Assessment Period"

define "Denominator Exclusions":
	exists ( "Palliative Care Order" )
		or exists ( "Encounter Palliative Care" )
		or exists ( "Long Term Care Encounter" )
		or "Patient Expired"
		or exists ( "Disorder Diagnoses" )

define "Stratification 1":
	"Index Depression Assessment" IndexAssessment
			where AgeInYearsAt(FHIRHelpers.ToDateTime(IndexAssessment.issued))>= 12
				and AgeInYearsAt(FHIRHelpers.ToDateTime(IndexAssessment.issued))< 18
				and "Index Depression Assessment" is not null

define "Stratification 2":
	"Index Depression Assessment" IndexAssessment
			where AgeInYearsAt(FHIRHelpers.ToDateTime(IndexAssessment.issued))>= 18
				and "Index Depression Assessment" is not null

define "Initial Population":
	exists ( "Index Depression Assessment" IndexAssessment
				where AgeInYearsAt(FHIRHelpers.ToDateTime(IndexAssessment.issued))>= 12
					and "Index Depression Assessment" is not null
	)

define function "ToDate"(Value DateTime ):
	DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezone from Value)
library DocumentationofCurrentMedicationsintheMedicalRecord version '9.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "Medical or Other reason not done":'2.16.840.1.113883.3.600.1.1502'
valueset "Medications Encounter Code Set":'2.16.840.1.113883.3.600.1.1834'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Race":'2.16.840.1.114222.4.11.836'
valueset "Current Medications Documented":'2.16.840.1.113762.1.4.1116.361'

code "Documentation of current medications (procedure)":'428191000124101' from "SNOMEDCT" display 'Documentation of current medications (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Initial Population":

            "Qualifying Encounters During Measurement Period" QualifyingEncounter
            	where "Patient Age 18 or Older at Start of Measurement Period"


define "Numerator":

            "Medications Documented During Qualifying Encounter"


define "Denominator":

            "Initial Population"

         
define "Denominator Exceptions":

            "Qualifying Encounters During Measurement Period" EncounterDuringMeasurementPeriod
            	with  "Medications Not Documented for Medical Reason" MedicationsNotDocumented
            		such that start of (MedicationsNotDocumented.performed as Period) during EncounterDuringMeasurementPeriod.period
 

define "Medications Documented During Qualifying Encounter":

            "Qualifying Encounters During Measurement Period" QualifyingEncounterDuringMeasurementPeriod
            	with [Procedure: "Current Medications Documented"] MedicationsDocumented
            		such that (MedicationsDocumented.status='in-progress' and MedicationsDocumented.status='completed')
            		    and (MedicationsDocumented.performed as Period) during QualifyingEncounterDuringMeasurementPeriod.period

         

define "Medications Not Documented for Medical Reason":

            [Procedure: "Current Medications Documented"] NotPerformed
            	where (NotPerformed.status!='in-progress' and NotPerformed.status!='completed') and NotPerformed.statusReason in "Medical or Other reason not done"
         

define "Patient Age 18 or Older at Start of Measurement Period":
            
         AgeInYearsAt(start of "Measurement Period") >= 18

define "Qualifying Encounters During Measurement Period":

            [Encounter: "Medications Encounter Code Set"] QualifyingEncounter
            	where (QualifyingEncounter.status='in-progress' or QualifyingEncounter.status='finished')
		            and QualifyingEncounter.period during "Measurement Period"

define function "ToDate"(Value DateTime ):
	DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezone from Value)



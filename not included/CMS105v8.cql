library DischargedonStatinMedication version '7.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
//include MATGlobalCommonFunctions version '4.0.000' called Global

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Comfort Measures":'1.3.6.1.4.1.33895.1.3.0.45'
valueset "Discharge To Acute Care Facility":'2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care":'2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care":'2.16.840.1.113883.3.117.1.7.1.209'
valueset "Emergency Department Visit":'2.16.840.1.113883.3.117.1.7.1.292'
valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "Hemorrhagic Stroke":'2.16.840.1.113883.3.117.1.7.1.212'
valueset "Ischemic Stroke":'2.16.840.1.113883.3.117.1.7.1.247'
valueset "LDL-c":'2.16.840.1.113883.3.117.1.7.1.215'
valueset "Left Against Medical Advice":'2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason":'2.16.840.1.113883.3.117.1.7.1.473'
valueset "Non-Elective Inpatient Encounter":'2.16.840.1.113883.3.117.1.7.1.424'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Patient Expired":'2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal":'2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Race":'2.16.840.1.114222.4.11.836'
valueset "Statin Allergen":'2.16.840.1.113883.3.117.1.7.1.423'
valueset "Statin Grouper":'2.16.840.1.113762.1.4.1110.19'

parameter "Measurement Period" Interval<DateTime>

context Population

define "Denominator":

            "Ischemic Stroke Encounter"


define "Denominator Exceptions":

            ( "Ischemic Stroke Encounter" IschemicStrokeEncounter
            		union "Statin Not Given at Discharge" NoDischargeStatin
            			//such that NoDischargeStatin.authorDatetime during IschemicStrokeEncounter.period
            )
            	//union ( "Ischemic Stroke Encounter" IschemicStrokeEncounter
            			//with "Statin Allergy" StatinAllergy
            				//such that StatinAllergy.onsetPeriod starts on or before end of IschemicStrokeEncounter.period
            	//)
            	union "Statin Allergy"
            	union "Encounter with Max LDL less than 70 mg per dL"



define "Denominator Exclusions":

            "Ischemic Stroke Encounters with Discharge Status"
            	union "Comfort Measures during Hospitalization"



define "Encounter with Max LDL less than 70 mg per dL":

            "Ischemic Stroke Encounter" IschemicStrokeEncounter
            	where Max([Observation: "LDL-c"] Ldl
            			where Ldl.issued during Interval[start of "IschemicStrokeEncounter".period - 30 days, end of IschemicStrokeEncounter.period]
            			return Ldl.value as Quantity
            	)< 70 'mg/dL'



define "Initial Population":

            "Encounter with Principal Diagnosis and Age"



define "Numerator":

            "Ischemic Stroke Encounter" IschemicStrokeEncounter
            	union "Statin at Discharge" DischargeStatin
            		//such that DischargeStatin.authoredOn during IschemicStrokeEncounter.period


define "Statin Allergy":

            [AllergyIntolerance: "Statin Allergen"]



define "Statin at Discharge":

            [MedicationRequest: "Statin Grouper"]M where M.intent.value= 'plan'



define "Statin Not Given at Discharge":

            [MedicationRequest: "Statin Grouper"] NoStatinDischarge
            	where NoStatinDischarge.intent.value = 'plan' and NoStatinDischarge.doNotPerform= true 
            	and (NoStatinDischarge.reasonCode in "Medical Reason"
            		or NoStatinDischarge.reasonCode in "Patient Refusal")



define "All Stroke Encounter":

            "Non Elective Inpatient Encounter" NonElectiveEncounter where 
		NonElectiveEncounter.diagnosis.rank =1 and 
		NonElectiveEncounter.diagnosis.use.coding[0].code.value='billing'
            	 and (NonElectiveEncounter.diagnosis.condition in "Hemorrhagic Stroke"
            		or NonElectiveEncounter.diagnosis.condition in "Ischemic Stroke")


define "Comfort Measures during Hospitalization":

            "Ischemic Stroke Encounter" IschemicStrokeEncounter
            	union "Intervention Comfort Measures" ComfortMeasure
            		//such that Coalesce(start of (ComfortMeasure.performed as Period), ComfortMeasure.authoredOn) during "Hospitalization"(IschemicStrokeEncounter)



define "Encounter with Principal Diagnosis and Age":

            "All Stroke Encounter" AllStrokeEncounter
            		//where "CalendarAgeInYearsAt"(Patient.birthDate, start of AllStrokeEncounter.period)>= 18


define "Intervention Comfort Measures":

            [ServiceRequest: "Comfort Measures"]SR
            where SR.intent.value='order' 
            union 
            [Procedure: "Comfort Measures"]



define "Ischemic Stroke Encounter":

            "Encounter with Principal Diagnosis and Age" EncounterWithAge where 
            EncounterWithAge.diagnosis.rank =1 and 
            EncounterWithAge.diagnosis.use.coding[0].code.value='billing'
            	 and EncounterWithAge.diagnosis.condition in "Ischemic Stroke"



define "Ischemic Stroke Encounters with Discharge Status":

            ( ( "Ischemic Stroke Encounter" IschemicStrokeEncounter
            			where IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Discharge To Acute Care Facility"
            				or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Left Against Medical Advice"
            				or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Patient Expired"
            				or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Discharged to Home for Hospice Care"
            				or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Discharged to Health Care Facility for Hospice Care"
            	)
            )



define "Non Elective Inpatient Encounter":

            [Encounter: "Non-Elective Inpatient Encounter"] NonElectiveEncounter
            	where (NonElectiveEncounter.status='in-progress' or NonElectiveEncounter.status='finished')
		            and "LengthInDays"(NonElectiveEncounter.period)<= 120
            		and NonElectiveEncounter.period ends during "Measurement Period"

define function "ToDate"(Value DateTime ):
	DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezone from Value)

define function "LengthInDays"(Value Interval<DateTime> ):
	difference in days between start of Value and end of Value

define function "Hospitalization"(Enc Encounter ):
	( singleton from ( [Encounter: "Emergency Department Visit"] EDVisit
			where (EDVisit.status='in-progress' or EDVisit.status='finished')
		            and EDVisit.period ends 1 hour or less on or before start of Enc.period
	) ) X
		return if X is null then Enc.period else Interval[start of X.period, end of Enc.period]

	
define function "CalendarAgeInYearsAt"(BirthDateTime DateTime, AsOf DateTime ):
	years between ToDate(BirthDateTime)and ToDate(AsOf)

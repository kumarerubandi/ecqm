library HIVAIDS

using FHIR

include FHIRHelpers version '1.8' called FHIRHelpers

codesystem "LOINC" : '2.16.840.1.113883.6.1' version '2.63'
codesystem "RXNORM" : '2.16.840.1.113883.6.88' version '2018-01'
codesystem "SNOMEDCT" : '2.16.840.1.113883.6.96' version '2017-09'

valueset "CD4+ Count":'2.16.840.1.113883.3.464.1003.121.12.1004'
valueset "CD4+ Percentage":'2.16.840.1.113883.3.464.1003.121.12.1005'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "HIV 1":'2.16.840.1.113883.3.464.1003.120.12.1004'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'
valueset "Leucovorin":'2.16.840.1.113883.3.464.1003.196.12.1205'
valueset "Office Visit":'2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation":'2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Pneumocystis Jiroveci Pneumonia (PCP) Prophylaxis":'2.16.840.1.113883.3.464.1003.196.12.1076'
valueset "Preventive Care - Established Office Visit, 0 to 17":'2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Established Office Visit, 18 and Up":'2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up":'2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care- Initial Office Visit, 0 to 17":'2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Race":'2.16.840.1.114222.4.11.836'

code "Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet":'105337' from "RXNORM" display 'Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "CD4 Count Under 200":

            [Observation: "CD4+ Count"] CD4Count
            	where ( CD4Count.value as Quantity ) < 200 '/mm3'
            		and CD4Count.relevantPeriod ends 9 months or less after start of "Measurement Period"



define "CD4 Count Under 200 With Current PCP Treatment":

            from
            	"CD4 Count Under 200" CD4CountUnder200,
            	[MedicationRequest.intent: "Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet"] DapsoneOrder,
            	[MedicationRequest.intent: "Leucovorin"] LeucovorinOrder
            	where DapsoneOrder.authorDatetime occurs 3 months or less after end CD4CountUnder200.relevantPeriod
            		and LeucovorinOrder.authorDatetime occurs 3 months or less after end CD4CountUnder200.relevantPeriod
            		and DapsoneOrder.authorDatetime same day as LeucovorinOrder.authorDatetime
            	return CD4CountUnder200



define "CD4 Count Under 200 with PCP Medication Prophylaxis":

            "CD4 Count Under 200" CD4Under200
            	with [MedicationRequest.intent: "Pneumocystis Jiroveci Pneumonia (PCP) Prophylaxis"] PCPProphylaxis
            		such that PCPProphylaxis.authorDatetime 3 months or less after end of CD4Under200.relevantPeriod



define "CD4 Count Under 500":

            [Observation: "CD4+ Count"] CD4Count
            	where ( CD4Count.value as Quantity ) < 500 '/mm3'
            		and CD4Count.effective ends 9 months or less after start of "Measurement Period"



define "CD4 Count Under 500 or CD4 Percentage Less Than 15":

            "CD4 Count Under 500"
            	union "CD4 Percentage Less Than 15"



define "CD4 Count Under 500 with PCP Medication Prophylaxis":

            "CD4 Count Under 500" CD4Under500
            	with [MedicationRequest.intent: "Pneumocystis Jiroveci Pneumonia (PCP) Prophylaxis"] PCPProphylaxis
            		such that PCPProphylaxis.authorDatetime occurs 3 months or less after end of CD4Under500.relevantPeriod



define "CD4 Percentage Less Than 15":

            [Observation: "CD4+ Percentage"] CD4Percent
            	where ( CD4Percent.value as Quantity ) < 15 '%'
            		and CD4Percent.effective ends 9 months or less after start of "Measurement Period"



define "CD4 Percentage Less Than 15 with PCP Medication Prophylaxis":

            "CD4 Percentage Less Than 15" CD4Percentage
            	with [MedicationRequest.intent: "Pneumocystis Jiroveci Pneumonia (PCP) Prophylaxis"] PCPProphylaxis
            		such that PCPProphylaxis.authorDatetime occurs 3 months or less after end of CD4Percentage.relevantPeriod



define "Denominator 1":

            "Initial Population 1"



define "Denominator 2":

            "Initial Population 2"



define "Denominator 3":

            "Initial Population 3"



define "Denominator Exceptions 1":

            exists ( "CD4 Count Under 200" FirstCD4Count
            		with [Observation: "CD4+ Count"] SecondCD4Count
            			such that SecondCD4Count.effective less than 3 months after day of FirstCD4Count.effective
            				and SecondCD4Count.value >= 200 '/mm3'
            )



define "Denominator Exceptions 2":

            exists ( ( [Observation: "CD4+ Count"] FirstCD4Count
            			with [Observation: "CD4+ Count"] SecondCD4Count
            				such that SecondCD4Count.effective occurs 3 months or less after day of FirstCD4Count.effective
            					and SecondCD4Count.value >= 500 '/mm3'
            	)
            		union ( [Observation: "CD4+ Percentage"] FirstCD4Percent
            				with [Observation: "CD4+ Percentage"] SecondCD4Percent
            					such that SecondCD4Percent.effective occurs 3 months or less after FirstCD4Percent.effective
            						and SecondCD4Percent.value >= 15 '%'
            		)
            )



define "Denominator Exclusions":

            Hospice."Has Hospice"



define "First HIV Diagnosis":

            First("HIV Diagnosis" FirstHIVDiagnosis
            		where Interval[FirstHIVDiagnosis.onset,FirstHIVDiagnosis.abatement] starts before end of "Measurement Period"
            		sort by FirstHIVDiagnosis.onset
            )



define "Followup HIV Visit":

            "Qualifying Encounters" FollowupVisit
            	with "Qualifying Encounters" PriorVisit
            		such that FollowupVisit.authorDatetime 90 days or more on or after day of PriorVisit.authorDatetime



define "HIV Diagnosis":

            [Condition: "HIV 1"] HIV
            	where Interval[HIV.onset, HIV.abatement] starts before end of "Measurement Period"



define "Has Hospice":

            exists ( [Encounter: "Encounter Inpatient"] DischargeHospice
            		where ( DischargeHospice.hospitalization.dischargeDisposition 	 as Code ~ "Discharge to home for hospice care (procedure)"
            				or DischargeHospice.hospitalization.dischargeDisposition  as Code ~ "Discharge to healthcare facility for hospice care (procedure)"
            		)
            			and DischargeHospice.period ends during "Measurement Period"
            )
            	or exists ( [ServiceRequest: "Hospice care ambulatory"] HospiceOrder
            			where HospiceOrder.intent='order' and HospiceOrder.authoredOn during "Measurement Period"
            	)
            	or exists ( [Procedure: "Hospice care ambulatory"] HospicePerformed
            			where HospicePerformed.performed overlaps "Measurement Period"
            	)



define "Initial Population 1":

            exists ["Patient Characteristic Birthdate"] BirthDate
            	where Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 6
            		and exists ( "HIV Diagnosis" )
            		and exists ( "Followup HIV Visit" )
            		and exists ( "CD4 Count Under 200" )



define "Initial Population 2":

            exists ["Patient Characteristic Birthdate"] BirthDate
            	where Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")in Interval[1, 6 )
            		and exists ( "HIV Diagnosis" )
            		and exists ( "Followup HIV Visit" )
            		and exists ( "CD4 Count Under 500 or CD4 Percentage Less Than 15" )



define "Initial Population 3":

            exists ( ["Patient Characteristic Birthdate"] BirthDate
            		where Global."CalendarAgeInDaysAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 42
            			and Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")< 1
            )
            	and "First HIV Diagnosis" is not null
            	and exists ( "Followup HIV Visit" )



define "Numerator 1":

            exists "CD4 Count Under 200 with PCP Medication Prophylaxis"
            	or exists ( "CD4 Count Under 200 With Current PCP Treatment" )



define "Numerator 2":

            exists ( "CD4 Count Under 500 with PCP Medication Prophylaxis" )
            	or exists ( "CD4 Percentage Less Than 15 with PCP Medication Prophylaxis" )



define "Numerator 3":

            exists [MedicationRequest.intent: "Pneumocystis Jiroveci Pneumonia (PCP) Prophylaxis"] PCPProphylaxis
            	with "First HIV Diagnosis" FirstHIVDiagnosis
            		such that PCPProphylaxis.authorDatetime same day as start of FirstHIVDiagnosis.prevalencePeriod

         

define "Qualifying Encounters":

            ( [Encounter: "Office Visit"]
            	union [Encounter: "Preventive Care- Initial Office Visit, 0 to 17"]
            	union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
            	union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
            	union [Encounter: "Preventive Care - Established Office Visit, 0 to 17"]
            	union [Encounter: "Outpatient Consultation"] ) ValidEncounter
            	where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		            and ValidEncounter.period during "Measurement Period"

         

define "SDE Ethnicity":

            ["Patient Characteristic Ethnicity": "Ethnicity"]

         

define "SDE Payer":

            ["Patient Characteristic Payer": "Payer"]

         

define "SDE Race":

            ["Patient Characteristic Race": "Race"]

         
define "SDE Sex":

            ["Patient Characteristic Sex": "ONC Administrative Sex"] 



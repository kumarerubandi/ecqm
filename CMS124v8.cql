library CervicalCancerScreening version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "ONC Administrative Sex": '2.16.840.1.113762.1.4.1'
valueset "Race": '2.16.840.1.114222.4.11.836'
valueset "Ethnicity": '2.16.840.1.114222.4.11.837'
valueset "Payer": '2.16.840.1.114222.4.11.3591'
valueset "Female": '2.16.840.1.113883.3.560.100.2'
valueset "Home Healthcare Services": '2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hysterectomy with No Residual Cervix": '2.16.840.1.113883.3.464.1003.198.12.1014'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Pap Test": '2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "HPV Test": '2.16.840.1.113883.3.464.1003.110.12.1059'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Congenital absence of cervix (disorder)": '37687000' from "SNOMEDCT" display 'Congenital absence of cervix (disorder)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
		where (ValidEncounter.status='in-progress' or ValidEncounter.status='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Congenital Absence of Cervix":
	[Condition: "Congenital absence of cervix (disorder)"] NoCervixBirth
		where NoCervixBirth.clinicalStatus.coding[0].code='active'
			and Interval[(NoCervixBirth.onset as DateTime),(NoCervixBirth.abatement as DateTime)]  starts before end of "Measurement Period"

define "Pap Test with Results":
	[Observation: "Pap Test"] PapTestWithResult
		where PapTestWithResult.value is not null

define "Pap Test Within 3 Years":
	"Pap Test with Results" PapTest
		where (PapTest.effective as Period) starts 3 years or less before
		end of "Measurement Period"

define "Surgical Absence of Cervix":
	[Procedure: "Hysterectomy with No Residual Cervix"] NoCervixHysterectomy
		where NoCervixHysterectomy.status='completed' and (NoCervixHysterectomy.performed as Period) ends before
		end of "Measurement Period"

define "Denominator Exclusions":
	"Has Hospice"
		or exists "Surgical Absence of Cervix"
		or exists "Congenital Absence of Cervix"

define "Numerator":
	exists "Pap Test Within 3 Years"
		or exists "Pap Test With HPV Co Test Within 5 Years"

define "Pap Test With HPV Co Test Within 5 Years":
	"Pap Test Within 5 Years" PapTestOver30YearsOld
		with [Observation: "HPV Test"] HPVTest
			such that HPVTest.value is not null
				and (HPVTest.effective as Period) starts within 1 day of start of (PapTestOver30YearsOld.effective as Period)

define "Pap Test Within 5 Years":
	( "Pap Test with Results" PapTestOver30YearsOld
			where AgeInYearsAt(start of (PapTestOver30YearsOld.effective as Period))>= 30
					and (PapTestOver30YearsOld.effective as Period) starts 5 years or less before
					end of "Measurement Period"
	)

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 23
		and AgeInYearsAt(start of "Measurement Period")<= 64
		and Patient.gender in "Female"
		and exists "Qualifying Encounters"

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
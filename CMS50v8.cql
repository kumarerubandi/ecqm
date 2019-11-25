library ClosingtheReferralLoop version '8.0.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : '2.16.840.1.113883.6.88' version '2018-01'

valueset "Consultant Report":'2.16.840.1.113883.3.464.1003.121.12.1006'
valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "Office Visit":'2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services":'2.16.840.1.113883.3.526.3.1285'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up":'2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17":'2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up":'2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17":'2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race":'2.16.840.1.114222.4.11.836'
valueset "Referral":'2.16.840.1.113883.3.464.1003.101.12.1046'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Initial Population":

        exists "Face to Face Encounter During Measurement Period"
            	and "First Referral During Measurement Period" is not null


define "Numerator":
	exists "Referring Provider Communicated Consultant Report to Close Referral Loop"


define "Denominator":
	"Initial Population"



define "Face to Face Encounter During Measurement Period":

            ( [Encounter: "Office Visit"]
            	union [Encounter: "Ophthalmological Services"]
            	union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
            	union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
            	union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
            	union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"] ) FaceToFaceEncounter
            	where (FaceToFaceEncounter.status.value='in-progress' or FaceToFaceEncounter.status.value='finished') and FaceToFaceEncounter.period during "Measurement Period"



define "First Referral During Measurement Period":

            First([Procedure: "Referral"] ReferralPerformed
            		where (ReferralPerformed.status.value='in-progress' or ReferralPerformed.status.value='completed')
            		 and (ReferralPerformed.performed as Period) starts during "Measurement Period"
            		sort by authorDatetime
            )


define "Referring Provider Communicated Consultant Report to Close Referral Loop":

            [Communication: "Consultant Report"] ConsultantReportCommunicated
            	with "First Referral During Measurement Period" FirstReferralPerformed
            		such that (ConsultantReportCommunicated.status.value='in-progress' or ConsultantReportCommunicated.status.value='completed') 
            		and FirstReferralPerformed.id in ConsultantReportCommunicated.basedOn
            			and ConsultantReportCommunicated.authorDatetime after start of (FirstReferralPerformed.performed as Period)




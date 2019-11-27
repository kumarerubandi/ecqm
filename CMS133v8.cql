library Cataracts2040orBetterVisualAcuitywithin90DaysFollowingCataractSurgery version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Acute and Subacute Iridocyclitis": 'urn:oid:2.16.840.1.113883.3.526.3.1241'
valueset "Amblyopia": 'urn:oid:2.16.840.1.113883.3.526.3.1448'
valueset "Burn Confined to Eye and Adnexa": 'urn:oid:2.16.840.1.113883.3.526.3.1409'
valueset "Cataract Secondary to Ocular Disorders": 'urn:oid:2.16.840.1.113883.3.526.3.1410'
valueset "Cataract Surgery": 'urn:oid:2.16.840.1.113883.3.526.3.1411'
valueset "Cataract, Congenital": 'urn:oid:2.16.840.1.113883.3.526.3.1412'
valueset "Cataract, Mature or Hypermature": 'urn:oid:2.16.840.1.113883.3.526.3.1413'
valueset "Cataract, Posterior Polar": 'urn:oid:2.16.840.1.113883.3.526.3.1414'
valueset "Central Corneal Ulcer": 'urn:oid:2.16.840.1.113883.3.526.3.1428'
valueset "Certain Types of Iridocyclitis": 'urn:oid:2.16.840.1.113883.3.526.3.1415'
valueset "Choroidal Degenerations": 'urn:oid:2.16.840.1.113883.3.526.3.1450'
valueset "Choroidal Detachment": 'urn:oid:2.16.840.1.113883.3.526.3.1451'
valueset "Choroidal Hemorrhage and Rupture": 'urn:oid:2.16.840.1.113883.3.526.3.1452'
valueset "Chronic Iridocyclitis": 'urn:oid:2.16.840.1.113883.3.526.3.1416'
valueset "Cloudy Cornea": 'urn:oid:2.16.840.1.113883.3.526.3.1417'
valueset "Corneal Edema": 'urn:oid:2.16.840.1.113883.3.526.3.1418'
valueset "Corneal Opacity and Other Disorders of Cornea": 'urn:oid:2.16.840.1.113883.3.526.3.1419'
valueset "Degeneration of Macula and Posterior Pole": 'urn:oid:2.16.840.1.113883.3.526.3.1453'
valueset "Degenerative Disorders of Globe": 'urn:oid:2.16.840.1.113883.3.526.3.1454'
valueset "Diabetic Macular Edema": 'urn:oid:2.16.840.1.113883.3.526.3.1455'
valueset "Diabetic Retinopathy": 'urn:oid:2.16.840.1.113883.3.526.3.327'
valueset "Disorders of Optic Chiasm": 'urn:oid:2.16.840.1.113883.3.526.3.1457'
valueset "Disorders of Visual Cortex": 'urn:oid:2.16.840.1.113883.3.526.3.1458'
valueset "Disseminated Chorioretinitis and Disseminated Retinochoroiditis": 'urn:oid:2.16.840.1.113883.3.526.3.1459'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Focal Chorioretinitis and Focal Retinochoroiditis": 'urn:oid:2.16.840.1.113883.3.526.3.1460'
valueset "Glaucoma": 'urn:oid:2.16.840.1.113883.3.526.3.1423'
valueset "Glaucoma Associated with Congenital Anomalies, Dystrophies, and Systemic Syndromes": 'urn:oid:2.16.840.1.113883.3.526.3.1461'
valueset "Hereditary Choroidal Dystrophies": 'urn:oid:2.16.840.1.113883.3.526.3.1462'
valueset "Hereditary Corneal Dystrophies": 'urn:oid:2.16.840.1.113883.3.526.3.1424'
valueset "Hereditary Retinal Dystrophies": 'urn:oid:2.16.840.1.113883.3.526.3.1463'
valueset "Hypotony of Eye": 'urn:oid:2.16.840.1.113883.3.526.3.1426'
valueset "Injury to Optic Nerve and Pathways": 'urn:oid:2.16.840.1.113883.3.526.3.1427'
valueset "Macular Scar of Posterior Polar": 'urn:oid:2.16.840.1.113883.3.526.3.1559'
valueset "Morgagnian Cataract": 'urn:oid:2.16.840.1.113883.3.526.3.1558'
valueset "Nystagmus and Other Irregular Eye Movements": 'urn:oid:2.16.840.1.113883.3.526.3.1465'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Open Wound of Eyeball": 'urn:oid:2.16.840.1.113883.3.526.3.1430'
valueset "Optic Atrophy": 'urn:oid:2.16.840.1.113883.3.526.3.1466'
valueset "Optic Neuritis": 'urn:oid:2.16.840.1.113883.3.526.3.1467'
valueset "Other and Unspecified Forms of Chorioretinitis and Retinochoroiditis": 'urn:oid:2.16.840.1.113883.3.526.3.1468'
valueset "Other Background Retinopathy and Retinal Vascular Changes": 'urn:oid:2.16.840.1.113883.3.526.3.1469'
valueset "Other Disorders of Optic Nerve": 'urn:oid:2.16.840.1.113883.3.526.3.1471'
valueset "Other Endophthalmitis": 'urn:oid:2.16.840.1.113883.3.526.3.1473'
valueset "Other Proliferative Retinopathy": 'urn:oid:2.16.840.1.113883.3.526.3.1480'
valueset "Pathologic Myopia": 'urn:oid:2.16.840.1.113883.3.526.3.1432'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Posterior Lenticonus": 'urn:oid:2.16.840.1.113883.3.526.3.1433'
valueset "Prior Penetrating Keratoplasty": 'urn:oid:2.16.840.1.113883.3.526.3.1475'
valueset "Purulent Endophthalmitis": 'urn:oid:2.16.840.1.113883.3.526.3.1477'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Retinal Detachment with Retinal Defect": 'urn:oid:2.16.840.1.113883.3.526.3.1478'
valueset "Retinal Vascular Occlusion": 'urn:oid:2.16.840.1.113883.3.526.3.1479'
valueset "Retrolental Fibroplasias": 'urn:oid:2.16.840.1.113883.3.526.3.1438'
valueset "Scleritis and Episcleritis": 'urn:oid:2.16.840.1.113883.3.526.3.1481'
valueset "Separation of Retinal Layers": 'urn:oid:2.16.840.1.113883.3.526.3.1482'
valueset "Traumatic Cataract": 'urn:oid:2.16.840.1.113883.3.526.3.1443'
valueset "Uveitis": 'urn:oid:2.16.840.1.113883.3.526.3.1444'
valueset "Vascular Disorders of Iris and Ciliary Body": 'urn:oid:2.16.840.1.113883.3.526.3.1445'
valueset "Visual Acuity 20/40 or Better": 'urn:oid:2.16.840.1.113883.3.526.3.1483'
valueset "Visual Field Defects": 'urn:oid:2.16.840.1.113883.3.526.3.1446'

code "Best corrected visual acuity (observable entity)": '419775003' from "SNOMEDCT" display 'Best corrected visual acuity (observable entity)'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Cataract Surgery Between January and September of Measurement Period":
	[Procedure: "Cataract Surgery"] CataractSurgery
		where CataractSurgery.status='completed'
      and (CataractSurgery.performed as Period) during "Measurement Period"
			and (CataractSurgery.performed as Period) starts 93 days or more before end of "Measurement Period"

define "Numerator":
	"Cataract Surgery Between January and September of Measurement Period" CataractSurgeryPerformed
		with [Observation: "Best corrected visual acuity (observable entity)"] VisualAcuityExamPerformed
			such that (VisualAcuityExamPerformed.effective as Period) starts 90 days or less after day of
			end of (CataractSurgeryPerformed.performed as Period)
				and VisualAcuityExamPerformed.value in "Visual Acuity 20/40 or Better"

define "Denominator Exclusions":
	"Cataract Surgery Between January and September of Measurement Period" CataractSurgeryPerformed
		with ( [Condition: "Acute and Subacute Iridocyclitis"]
			union [Condition: "Amblyopia"]
			union [Condition: "Burn Confined to Eye and Adnexa"]
			union [Condition: "Cataract Secondary to Ocular Disorders"]
			union [Condition: "Cataract, Congenital"]
			union [Condition: "Cataract, Mature or Hypermature"]
			union [Condition: "Cataract, Posterior Polar"]
			union [Condition: "Central Corneal Ulcer"]
			union [Condition: "Certain Types of Iridocyclitis"]
			union [Condition: "Choroidal Degenerations"]
			union [Condition: "Choroidal Detachment"]
			union [Condition: "Choroidal Hemorrhage and Rupture"]
			union [Condition: "Chronic Iridocyclitis"]
			union [Condition: "Cloudy Cornea"]
			union [Condition: "Corneal Edema"]
			union [Condition: "Corneal Opacity and Other Disorders of Cornea"]
			union [Condition: "Degeneration of Macula and Posterior Pole"]
			union [Condition: "Degenerative Disorders of Globe"]
			union [Condition: "Diabetic Macular Edema"]
			union [Condition: "Diabetic Retinopathy"]
			union [Condition: "Disorders of Optic Chiasm"]
			union [Condition: "Disorders of Visual Cortex"]
			union [Condition: "Disseminated Chorioretinitis and Disseminated Retinochoroiditis"]
			union [Condition: "Focal Chorioretinitis and Focal Retinochoroiditis"]
			union [Condition: "Glaucoma"]
			union [Condition: "Glaucoma Associated with Congenital Anomalies, Dystrophies, and Systemic Syndromes"]
			union [Condition: "Hereditary Choroidal Dystrophies"]
			union [Condition: "Hereditary Corneal Dystrophies"]
			union [Condition: "Hereditary Retinal Dystrophies"]
			union [Condition: "Hypotony of Eye"]
			union [Condition: "Injury to Optic Nerve and Pathways"]
			union [Condition: "Macular Scar of Posterior Polar"]
			union [Condition: "Morgagnian Cataract"]
			union [Condition: "Nystagmus and Other Irregular Eye Movements"]
			union [Condition: "Open Wound of Eyeball"]
			union [Condition: "Optic Atrophy"]
			union [Condition: "Optic Neuritis"]
			union [Condition: "Other and Unspecified Forms of Chorioretinitis and Retinochoroiditis"]
			union [Condition: "Other Background Retinopathy and Retinal Vascular Changes"]
			union [Condition: "Other Disorders of Optic Nerve"]
			union [Condition: "Other Endophthalmitis"]
			union [Condition: "Other Proliferative Retinopathy"]
			union [Condition: "Pathologic Myopia"]
			union [Condition: "Posterior Lenticonus"]
			union [Condition: "Prior Penetrating Keratoplasty"]
			union [Condition: "Purulent Endophthalmitis"]
			union [Condition: "Retinal Detachment with Retinal Defect"]
			union [Condition: "Retinal Vascular Occlusion"]
			union [Condition: "Retrolental Fibroplasias"]
			union [Condition: "Scleritis and Episcleritis"]
			union [Condition: "Separation of Retinal Layers"]
			union [Condition: "Traumatic Cataract"]
			union [Condition: "Uveitis"]
			union [Condition: "Vascular Disorders of Iris and Ciliary Body"]
			union [Condition: "Visual Field Defects"] ) ComorbidDiagnosis
			such that Interval[FHIRHelpers.ToDateTime(ComorbidDiagnosis.onset),FHIRHelpers.ToDateTime(ComorbidDiagnosis.abatement)] overlaps before (CataractSurgeryPerformed.performed as Period)

define "Initial Population":
	"Cataract Surgery Between January and September of Measurement Period" CataractSurgeryPerformed
		where AgeInYearsAt(start of "Measurement Period")>= 18
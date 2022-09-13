clear all
set more off, permanently 
set maxvar 30000
cd "C:\Users\User\Desktop\1S-2021\Materia Integradora\CIAT-Harvard Dataverse"
use BaseTotalHogar_GUAYAS-Opcion4, clear


//Para armar rangos de x variable y modificar los value names

recode Edad (min/30=1) (31/40=2) (41/50=3) (51/60=4) (61/max=5), gen(Rango_Edad)
label variable Rango_Edad "Rango de edad"
label define ranged 1 "Menor que 30" 2 "31-40" 3 "41-50" 4 "51-60" 5 "Mayor que 60"
label values Rango_Edad ranged
*table Rango_Edad

recode Total_Hogar (min/3=1) (4/6=2) (6/max=3), gen(Rango_Integrantes)
label variable Rango_Integrantes "Rango de integrantes"
label define rangint 1 "1-3" 2 "4-6" 3 "Mayor que 6"
label values Rango_Integrantes rangint
*table Rango_Integrantes

recode Experiencia_Agricola (min/10=1) (11/20=2) (21/30=3) (31/40=4) (41/max=5), gen(Rango_Experiencia)
label variable Rango_Experiencia "Rango años de experiencia"
label define rangex 1 "Menor que 10" 2 "11-20" 3 "21-30" 4 "31-40" 5 "Mayor que 40"
label values Rango_Experiencia rangex
*table Rango_Experiencia

recode Numero_Cosechas (min/2=1) (2.1/max=2), gen(Rango_Cosechas)
label variable Rango_Cosechas "Rango número de cosechas"
label define rangcos 1 "1-2 cosechas" 2 "2-4 cosechas"
label values Rango_Cosechas rangcos
*table Rango_Cosechas


// Estadística descriptiva

**Tabs de las variables sociodemográficas

tab Rango_Edad
mean Edad
tab Genero
tab Ocupacion
tab Nivel_Educacion
tab Rango_Integrantes
mean Total_Hogar
tab Rango_Experiencia
mean Experiencia_Agricola

**Tabs de las variables de extensión agrícola
tab Org_Participacion
tab Asesoria_Tecnica

**Tabs de las variables de la producción de arroz (características)
tab Tamaño_Finca
summarize Tamaño_Finca, detail 
recode Tamaño_Finca (0.1764/2.1168=1) (2.1168/7.056=2) (7.056/max=3), gen(Tipo_de_Productor)
label variable Tipo_de_Productor "Tipo de productor"
label define rangtam 1 "Pequeños productores de arroz" 2 "Medianos productores de arroz" 3 "Grandes productores de arroz" 
label values Tipo_de_Productor rangtam
tab Tipo_de_Productor

tab Tenencia_Tierra 

tab Forma_Siembra 
tab Tipo_Semillas

tab Analisis_Suelo

** Tabs de las actividades agrícolas
tab Roza 
tab Quema 
tab Arado 
tab Rastra  
tab Romeplow 
tab Nivelacion  
tab Fangueo 
tab Semillero  
tab Trasplante 
tab Siembra_Directa

**Insumos para la producción

//Producción
summarize Rendimiento_Arroz, detail //sacas*ha-1

//Semillas
summarize Total_Semillas
summarize Total_Semillas, detail //kg*ha-1
recode Total_Semillas (min/59=1) (60/100=2) (101/max=3), gen(Rango_Semillas)
label variable Rango_Semillas "Rango cantidad de semillas"
label define rangsem 1 "Menor que 60 kg" 2 "60-100 kg" 3 "Mayor que 100 kg"
label values Rango_Semillas rangsem
tab Rango_Semillas
*table Rango_Semillas

//Fertilizantes
tab Abonamiento_Lote 
summarize Total_Fertilizantes, detail
groups Tipo_Fertilizantes, order(high)

//Herbicidas
tab Control_Maleza
summarize Total_Herbicidas, detail
groups Tipo_Herbicidas, order(high)

//Insecticidas
tab Presencia_Plagas_Arrozal 
tab Control_Plagas 
summarize Total_Insecticidas, detail
groups Tipo_Insecticidas, order(high)

tab Numero_Cosechas
mean Numero_Cosechas
tab Rango_Cosechas

**Limitantes de producción

tab Escasez_Semillas 
tab Precio_Alto_Semillas 
tab Baja_Calidad_Semillas 
tab Escasez_Fertilizantes 
tab Precio_Alto_Fertilizantes 
tab Dificil_Acceso_Credito 
tab Sequias 
tab Inundaciones
tab Pestes_Plagas
tab Enfermedades 
tab Infertilidad_Suelo 
tab Erosion_Suelo 
tab Baja_Luminosidad


// Modelo econométrico

* ln(Yi) = Bo + B1*ln(X1i) + B2*ln(X2i) + B3*ln(X3i) + B4*ln(X4i) + vi - ui

**Generación de logaritmos -variables dependiente e independientes-

gen ln_Rendimiento_Arroz = ln(Rendimiento_Arroz)
label variable ln_Rendimiento_Arroz "Log rendimiento de arroz"
gen ln_Total_Semillas = ln(Total_Semillas)
label variable ln_Total_Semillas "Log total de semillas"
gen ln_Total_Fertilizantes = ln(Total_Fertilizantes)
label variable ln_Total_Fertilizantes "Log total de fertilizantes"
gen ln_Total_Herbicidas = ln(Total_Herbicidas)
label variable ln_Total_Herbicidas "Log total de herbicidas"
gen ln_Total_Insecticidas = ln(Total_Insecticidas)
label variable ln_Total_Insecticidas "Log total de insecticidas"

**Generación de dummies

*Dummy1: Genero (hombre=1, mujer=0)
tab Genero
gen Genero_Dummy=1 if Genero==1
	replace Genero_Dummy=0 if Genero_Dummy==.
tab Genero_Dummy
label variable Genero_Dummy "Binaria de género"

**Dummy2: Nivel de educación (superior a escuela primaria=1, hasta escuela primaria=0)
tab Nivel_Educacion
gen Nivel_Educacion_Dummy=1 if Nivel_Educacion==4 | Nivel_Educacion==5 | Nivel_Educacion==6 | Nivel_Educacion==7
	replace Nivel_Educacion_Dummy=0 if Nivel_Educacion_Dummy==.
tab Nivel_Educacion_Dummy
label variable Nivel_Educacion_Dummy "Binaria de nivel de educación"

**Dummy3: Tenencia de la tierra (alquilada=1, otro=0)
tab Tenencia_Tierra
gen Tenencia_Tierra_Dummy=1 if Tenencia_Tierra==1
	replace Tenencia_Tierra_Dummy=0 if Tenencia_Tierra_Dummy==.
tab Tenencia_Tierra_Dummy
label variable Tenencia_Tierra_Dummy "Binaria de tenencia de tierra"

**Dummy3: Participa en organización agrícola (sí=1, no=0)
tab Org_Participacion
gen Org_Participacion_Dummy=1 if Org_Participacion==1 | Org_Participacion==2 | Org_Participacion==3
	replace Org_Participacion_Dummy=0 if Org_Participacion_Dummy==.
tab Org_Participacion_Dummy
label variable Org_Participacion_Dummy "Binaria de organización agrícola"

**Dummy4: Asesoría técnica (sí=1, no=0)
tab Asesoria_Tecnica
gen Asesoria_Tecnica_Dummy=1 if Asesoria_Tecnica==1
	replace Asesoria_Tecnica_Dummy=0 if Asesoria_Tecnica_Dummy==.
tab Asesoria_Tecnica_Dummy
label variable Asesoria_Tecnica_Dummy "Binaria de asesoría técnica"

**Dummy5: Actividad-Siembra Directa (sí=1, no=0)
tab Siembra_Directa
gen Siembra_Directa_Dummy=1 if Siembra_Directa==1
	replace Siembra_Directa_Dummy=0 if Siembra_Directa_Dummy==.
tab Siembra_Directa_Dummy
label variable Siembra_Directa_Dummy "Binaria de siembra directa"

**Dummy6: Actividad-Quema (sí=1, no=0)
tab Quema
gen Quema_Dummy=1 if Quema==1
	replace Quema_Dummy=0 if Quema_Dummy==.
tab Quema_Dummy
label variable Quema_Dummy "Binaria de quema"


**Generación de variable interactiva
gen Tamaño_Finca2 = Tamaño_Finca*Tamaño_Finca
label variable Tamaño_Finca2 "Tamaño de finca al cuadrado"

gen ln_Tamaño_Finca2 = ln(Tamaño_Finca2)
label variable ln_Tamaño_Finca2 "Log tamaño de finca al cuadrado"


// Análisis econométrico

**Función sfcross: permite estimar la eficiencia técnica y está enfocada en el output

eststo Modelo: 

sfcross ln_Rendimiento_Arroz ln_Total_Semillas ln_Total_Fertilizantes ln_Total_Herbicidas ln_Total_Insecticidas, model(bc) dist(tn) ort(o) emean(Genero_Dummy Nivel_Educacion_Dummy Experiencia_Agricola Total_Hogar Tamaño_Finca Tamaño_Finca2 Tenencia_Tierra_Dummy Org_Participacion_Dummy Asesoria_Tecnica_Dummy Quema_Dummy Siembra_Directa_Dummy Numero_Cosechas) 

outreg using Modelo, se varlabels ctitles(" ", "Coeficientes", "ln(Rendimiento de Arroz)") replace

predict bc, jlms //jmls es para calcular la eficiencia tecnica luego del modelo translog por medio del método Jhon Rate Out 
sum bc, detail

recode bc (min/0.8=1) (0.8/0.9=2) (0.9/max=3), gen(Rango_Eficiencia)
label variable Rango_Eficiencia "Eficiencia técnica (%)"
label define rangefi 1 "Menor que 80" 2 "80-90" 3 "Mayor que 90"
label values Rango_Eficiencia rangefi
tab Rango_Eficiencia

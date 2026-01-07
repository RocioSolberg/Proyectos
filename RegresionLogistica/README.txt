Regresión logística 

Factores de riesgo de diabetes tipo 2 en mujeres de una comunidad aborigen 

Introducción 

En la actualidad la mayoría de las poblaciones aborígenes tienen un estilo de vida occidentalizado, caracterizado por una dieta compuesta total o parcialmente por carbohidratos refinados, alto contenido de grasas saturadas y bajo contenido de fibra dietética, muy diferente de los alimentos tradicionales como los productos agrícolas, con hábitos sedentarios y disminución de la actividad física. En estas circunstancias, algunas de estas poblaciones han desarrollado una alta prevalencia de obesidad y diabetes tipo 2. El objetivo de este estudio fue estimar la prevalencia de diabetes tipo 2 y obesidad en mujeres de la comunidad Pima e identificar variables clínicas asociadas a la presencia de diabetes. 

Metodología 

La población objetivo de este estudio transversal es la población femenina Pima adulta (>20 años). Se registraron distintas variables clínicas.  

La base de datos original en el paquete faraway (pima). 

Sobre esa base en la clase 1 se corrigieron: 

Por error los datos faltantes en las variables glucose , diastolic , triceps, insulin, bmi se registraron como “0” y se recodificaron como “NA” 

Se reemplazó un valor de triceps de 99 (no plausible) como “NA” 

Se generó la variable cat_peso según índice de masa corporal (BMI). Si bmi está entre 25  a <30 se considera  con sobrepeso. Si su IMC es 30.0 o superior, obesidad.  

Se renombró la variable diabetes a diabetes_gen.  

Se generó la variable diabetes a partir de test (sí = 1, no=0) 

Los datos corregidos se encuentran en el archivo pima.csv. 

Diccionario de variables:  

embarazos: Número de embarazos a término 

glucosa: Concentración de glucosa plasmática a las 2 horas en una prueba de tolerancia oral a la glucosa (mg/dL)  

diastólica: Presión arterial diastólica (mm Hg) 

triceps : Grosor del pliegue cutáneo del tríceps (mm) 

insulina: insulina sérica de 2 horas (mu U/ml) 

imc: Índice de masa corporal (IMC) (peso en kg/altura2 en m2) 

pedigree: función de pedigree de diabetes. Es un puntaje que expresa la predisposición a padecer diabetes a partir de la historia familiar. 

edad : Edad (años) 

diabetes: si la paciente posee o no diabetes (codificado 0 si es negativo, 1 si es positivo) 
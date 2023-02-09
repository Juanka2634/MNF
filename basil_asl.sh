#!/bin/bash

for x in `cat t15`
do
	oxford_asl -i /media/quizhpilema.134643/Datos/Resultados_ELA/ASL/${x}/ASL/ASL.nii --iaf tc --ibf rpt --casl \
	--bolus 1.5 --rpts 40 --tis 3 --fslanat /media/quizhpilema.134643/Datos/Resultados_ELA/ASL/${x}/T1/${x}.anat \
	-c /media/quizhpilema.134643/Datos/Resultados_ELA/ASL/${x}/ASL/M0/M0.nii --cmethod voxel --tr 5 --cgain 10 \
	-o /media/quizhpilema.134643/Datos/Resultados_ELA/ASL/${x}/Resultado --bat 1.3 --t1 1.3 --t1b 1.65 --alpha 0.6 \
	--spatial --artoff --fixbolus --mc
done


#iaf = Formato ASL de entrada: especifica si los datos ya han sido sustraídos de la etiqueta-control (diff, por defecto), o están en forma de pares etiqueta(tag)-control (tc o ct dependiendo de si la etiqueta/tag está primero).

#ibf = Formato de bloque de entrada. Específicamente para los datos ASL de múltiples retardos (multi-PLD) para identificar si los retardos individuales/PLDs son grupos juntos o por repeticiones de la misma secuencia de PLDs.

#casl Los datos se adquirieron utilizando el etiquetado cASL o pcASL (el etiquetado pASL se asume por defecto).

#bolus utilice esta opción para especificar la duración del bolo de etiquetado ASL utilizado en la secuencia (en segundos). Para pcASL/cASL este será el valor fijado por la secuencia, para pASL se tomará como el valor inicial para la estimación de la duración del bolo (a menos que se especifique la opción --fixbolus).

#rpts Número de mediciones repetidas para cada TI/PLD en la lista de TIs (--tis=<csv>), para su uso cuando el número de mediciones repetidas varía en cada TI.

#tis La lista de tiempos de entrada (TIs), una lista de valores separada por comas debe ser proporcionada (que coincide con el orden en los datos).Tenga en cuenta que el tiempo de entrada es el PLD más la duración del bolo para pcASL (y cASL), y es igual al tiempo de inversión para pASL. Si los datos contienen múltiples repeticiones del mismo conjunto de TIs, entonces sólo es necesario listar los TIs únicos.Cuando se utiliza --tis= se puede especificar una lista completa de todos los TIs/PLDs en los datos (es decir, tantas entradas como pares de etiqueta-control haya). O bien, si tiene un número de TIs/PLDs repetidos múltiples veces puede simplemente listar los TIs únicos en orden y oxford_asl replicará automáticamente esa lista para matematizar el número de medidas repetidas en los datos. Si tiene un número variable de repeticiones en cada TI/PLD entonces liste todos los TIs o use la opción --rpts=<csv> (ver abajo).

#fsl_anat Un directorio de resultados fsl_anat de la imagen estructural (Tenga en cuenta que idealmente se habrá realizado la extracción y segmentación del cerebro, oxford_asl también utilizará la corrección del campo de sesgo si está presente).

#c especifica la imagen de calibración M0 que se utiliza para obtener los valores de flujo en unidades absolutas. Debe ser una imagen con cualquier medición repetida apilada en la 4ª dimensión (tiempo).

#cmethod Especifica si la calibración se realiza a través de un único valor M0 calculado a partir del LCR en los ventrículos (único) o utilizando un enfoque voxelwise donde M0 se calcula en cada voxel (voxel).El método voxelwise es el más sencillo y sigue el procedimiento del "Libro Blanco", añadiendo una corrección para los efectos de volumen parcial alrededor del borde del cerebro. Se utiliza cuando no se dispone de una imagen estructural. El método único, que utiliza el LCR para la calibración, genera automáticamente una máscara de ventrículo en el espacio ASL a partir de la segmentación de la imagen estructural. Deberá inspeccionar esta máscara para asegurarse de que ha tenido éxito (en el subdirectorio calib de los resultados). Este procedimiento puede fallar a veces, en cuyo caso puede suministrar su propia máscara utilizando la opción --csf. Se puede realizar una calibración más avanzada utilizando asl_calib.

#tr el tiempo de repetición de la imagen de calibración.

#cgain Si la imagen de calibración ha sido adquirida con una ganancia diferente a la de los datos ASL, esto puede ser especificado aquí. Por ejemplo, cuando se utiliza la supresión de fondo, la señal ASL sin procesar será mucho menor que la imagen de calibración (sin supresión de fondo), por lo que podría emplearse una ganancia mayor en la adquisición.

#bat Un valor para el Tiempo de Tránsito Arterial (ATT), aquí llamado Tiempo de Llegada del Bolo (BAT). Para ASL de retardo simple/PLD este es el valor utilizado en el cálculo de la perfusión (y se establece en 0 en el 'Modo de Libro Blanco'). Para ASL de retardo múltiple/PLD este valor se utilizará para inicializar la estimación del ATT a partir de los datos. Típicamente, el ATT es más largo en pcASL comparado con pASL. Los valores por defecto son 0,7 s para pASL y 1,3 s para pcASL basados en la experiencia típica.

#t1 El valor T1 del tejido, 1,3 s por defecto (suponiendo una adquisición a 3T).

#t1b El valor T1 de la sangre arterial, 1,65 s por defecto (suponiendo una adquisición a 3T).

#apha la eficacia de la inversión del proceso de etiquetado, es probable que se apliquen los valores predeterminados para la mayoría de los datos ASL: 0,98 (pASL) o 0,85 (pcASL/cASL)

#spatial utilizar la regularización espacial. Esta opción está activada por defecto y es muy recomendable. Utilice --spatial=off para desactivarla.

#fixbolus Desactive la estimación automática de la duración del bolo, esto podría ser apropiado si la duración del bolo está bien definida por la secuencia de adquisición y está activada por defecto para cASL y pcASL. Podría ser apropiado utilizarlo con pASL cuando la duración del bolo se ha fijado utilizando QUIPSSII o Q2TIPS.

#artoff Desactivar la corrección de la señal que surge de la señal ASL que aún está dentro de la (macro) vasculatura, esto podría ser apropiado si la adquisición empleó la supresión de flujo. Esto está habilitado por defecto para ASL de retardo único/PLD.

#/bin/bash

dir=$(pwd)

for x in `cat ids`
do
	echo ${dir}/${x}
	cd ${dir}/${x}
	ls > images
	for y in `cat images`
	do
		gdcmconv -i ${y} --raw -o ${y}.dcm
		rm ${y}
	done
done

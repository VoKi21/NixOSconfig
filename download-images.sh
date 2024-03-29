#!/usr/bin/env bash
for ((i = ${2}; i <= ${3}; i++)); do
	echo ${1}${i}
	wget ${1}/${i}
	convert ${i} slide${i}.png
	rm ${i}
done

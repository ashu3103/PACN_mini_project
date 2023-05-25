#!/usr/bin/bash

paths=('movement_of_nodes' 'no_of_nodes' 'traffic')
iters=('1' '2' '3')

for i in "${paths[@]}"
do
    for entry in `ls $i`;do
        filepath="${i}/${entry}"
        readarray -d . -t filename <<< "$entry"
        echo > "${i}/${filename}.txt"
        for iter in "${iters[@]}"
        do
            ns $filepath
            gawk -f delay.awk "${filename}.tr" >> "${i}/${filename}.txt"

        done;
    done
done;

#gawk -f delay.awk traffic/15_random_tcp.tr
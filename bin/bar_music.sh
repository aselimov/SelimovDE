#!/bin/bash

#First we get the next appointmen
var=$(mpc current);

if [ "$var" = "" ]; then 
    echo ""
else
    echo " ${var:0:30}"
fi



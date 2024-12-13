#!/bin/bash
#price=$(curl rate.sx/1btc | cut -d '.' -f 1)
price=$(coinmon -f BTC | tail -n2 | head -n1 | cut -d ' ' -f 10 | cut -d '.' -f1)

echo "฿ $price"

# Check to see if it's a number
#re='^[0-9]+$'
#if [[ $price =~ $re ]] ; then
#fi

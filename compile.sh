#!/bin/bash
sed '/^\s*$/d' $1 | awk 1 ORS=',\n' > $1.temp
./parser < $1.temp


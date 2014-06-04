#!/bin/sh

#  fui_script.sh
#  xcfui
#
#  Created by Josip Cavar on 04/06/14.
#  Copyright (c) 2014 Josip Cavar. All rights reserved.

if [ $# -eq 0 ]
    then
        echo No arguments supplied. Please pass the project path
    else
        UNUSED_CLASSES=`fui --path=$1 find`
        if [ -z "$UNUSED_CLASSES" ]
            then
                echo No unused imports
            else
                while read line;
                do
                    echo $line 1:1: warning: Unused import
                done <<< "$UNUSED_CLASSES"
        fi
fi



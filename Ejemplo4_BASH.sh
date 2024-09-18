
#!/bin/bash 
# 
#Cybersecurity Ops with bash 
#getlocal.sh 
# 
#Description:  
#Gathers general system information and dumps it to a file 
# 
#Usage: 
#bash getlocal.sh < cmds.txt 
#cmds.txt is a file with list of commands to run 
# 
#SepCmds - separate the commands from the line of input 
function SepCmds() 
{ 
    LCMD=${ALINE%%|*}  
    REST=${ALINE#*|}  
    WCMD=${REST%%|*}  
    REST=${REST#*|} 
    TAG=${REST%%|*} 
    if[[ $OSTYPE == "MSWin" ]] 
    then 
        CMD="$WCMD" 
    else 
        CMD="$LCMD" 
    fi 
} 

function DumpInfo() 
{                                                              
    printf '<systeminfo host="%s" type="%s"' "$HOSTNAME" "$OSTYPE" 
    printf 'date="%s" time="%s">\n' "$(date '+%F')" "$(date '+%T')" 
    readarray CMDS                           
    for ALINE in "${CMDS[@]}" 
    do 
        if [[ ${ALINE:0:1} == '#' ]] ; then continue ; fi  
        SepCmds 
        if [[ ${CMD:0:3} == N/A ]]              
        then 
            continue 
        else 
            printf "<%s>\n" $TAG 
            $CMD 
            printf "</%s>\n" $TAG 
        fi 
    done 
    printf "</systeminfo>\n" 
} 
OSTYPE=$(./osdetect.sh) 
HOSTNM=$(hostname) 
TMPFILE="${HOSTNM}.info" 
#gather the info into the tmp file; errors, too 
DumpInfo  > $TMPFILE 2>&1 


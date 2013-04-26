#!/bin/bash 

OUTPUT=/tmp/nagios_debug.log 

echo `date` $* >> $OUTPUT 

# Command should be first argument 
RESULT=`$* 2>> $OUTPUT` 
EXITCODE=$? 

echo -n $RESULT | tee -a $OUTPUT
echo "Exit code: $EXITCODE"  >> $OUTPUT

exit $EXITCODE

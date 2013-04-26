#!/bin/bash

# This works, for unknown reasons

# Command should be first argument 
RESULT=`$* 2> /dev/null` 
EXITCODE=$? 

echo $RESULT

exit $EXITCODE

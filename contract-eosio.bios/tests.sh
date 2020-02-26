#!/bin/bash

setVars() {
	NEWACCOUNTDATA='{"creator":'$1',"name":"'$3'","owner":{"threshold":1,"keys":[{"key":"EOS7pu6NTNja3bDiGb3dimM5MBfFxrf6GGGvFYwf84JHeoUjsDpZw","weight":1}],"accounts":[],"waits":[]},"active":{"threshold":1,"keys":[{"key":"EOS7pu6NTNja3bDiGb3dimM5MBfFxrf6GGGvFYwf84JHeoUjsDpZw","weight":1}],"accounts":[],"waits":[]}}'
	NEWPERSONDATA='{"creator":'$1',"name":"'$3'","account_type":22,"owner":{"threshold":1,"keys":[{"key":"EOS7pu6NTNja3bDiGb3dimM5MBfFxrf6GGGvFYwf84JHeoUjsDpZw","weight":1}],"accounts":[],"waits":[]},"active":{"threshold":1,"keys":[{"key":"EOS7pu6NTNja3bDiGb3dimM5MBfFxrf6GGGvFYwf84JHeoUjsDpZw","weight":1}],"accounts":[],"waits":[]}}'
	NEWENTITYDATA='{"creator":'$1',"name":"'$3'","account_type":22,"owner":{"threshold":1,"keys":[],"accounts":[{"permission":{"actor":"success1","permission":"owner"},"weight":1}],"waits":[]},"active":{"threshold":1,"keys":[],"accounts":[{"permission":{"actor":"success1","permission":"active"},"weight":1}],"waits":[]}}'
	ACTION=$2
	PERMISSION=$1"@active"
}

#setVars actor action create
setVars "eosio" "newaccount" "failtest1"
cleos push action eosio $ACTION $NEWACCOUNTDATA -p $PERMISSION

setVars "test1" "newaccount" "failtest2"
cleos push action eosio $ACTION $NEWACCOUNTDATA -p $PERMISSION

setVars "eosio" "newperson" "success1"
cleos push action eosio $ACTION $NEWPERSONDATA -p $PERMISSION
cleos get account success1

setVars "test1" "newperson" "success2"
cleos push action eosio $ACTION $NEWPERSONDATA -p $PERMISSION
cleos get account success2

setVars "test1" "newentity" "failtest3"
cleos push action eosio $ACTION $NEWPERSONDATA -p $PERMISSION

setVars "eosio" "newentity" "success3"
cleos push action eosio $ACTION $NEWENTITYDATA -p $PERMISSION
cleos get account success3

setVars "test1" "newentity" "success4"
cleos push action eosio $ACTION $NEWENTITYDATA -p $PERMISSION
cleos get account success4


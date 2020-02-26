#!/bin/bash

git clone https://github.com/theblockstalk/eosio-boilerplate.git
cd eosio-boilerplate/scripts
cat ec2-ssh.pub >> ~/.ssh/authorized_keys

mkdir $HOME/myproject.git
cd $HOME/myproject.git
git init --bare

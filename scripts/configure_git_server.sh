#!/bin/bash

git clone https://github.com/theblockstalk/eosio-boilerplate.git
cat eosio-boilerplate/scripts/keys/ec2-ssh.pub >> ~/.ssh/authorized_keys

mkdir $HOME/project.git
cd $HOME/project.git
git init --bare

cp post-recieve $HOME/project.git/hooks/

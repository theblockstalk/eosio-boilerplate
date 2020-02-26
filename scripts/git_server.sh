#!/bin/bash

## On server
git clone https://github.com/theblockstalk/eosio-boilerplate.git
cd eosio-boilerplate/scripts
cat ec2-ssh.pub >> ~/.ssh/authorized_keys

mkdir $HOME/myproject.git
cd $HOME/myproject.git
git init --bare

## On local
eval "$(ssh-agent -s)"
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ec2-ssh > ec2-ssh.pub
ssh-add ec2-ssh

git remote add ec2 ubuntu@ec2-3-9-189-125.eu-west-2.compute.amazonaws.com:/home/ubuntu/project.git/
git push -u ec2 master

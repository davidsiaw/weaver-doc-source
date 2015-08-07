#!/bin/bash
git config --global user.email "davidsiaw@gmail.com"
git config --global user.name "David Siaw (via Circle CI)"

git clone git@github.com:davidsiaw/weaver-docs.git build
cp -r build/.git ./gittemp
bundle exec weaver build
cp -r ./gittemp build/.git
pushd build
git add .
git add -u
git commit -m "update `date`"
ssh-agent bash -c 'ssh-add ~/.ssh/id_github.com; git push'
popd

#!/bin/bash
git clone git@github.com:davidsiaw/weaver-docs.git build
bundle exec weaver build
pushd build
git add .
ssh-agent bash -c 'ssh-add ~/.ssh/id_github.com; git push'
popd

#!/bin/bash
git clone git@github.com:davidsiaw/weaver-docs.git build
bundle exec weaver build
pushd build
git add .
git push
popd
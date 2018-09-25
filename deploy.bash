#!/bin/bash

if [ "$TRAVIS" == "true" ]; then
	git config --global user.email "davidsiaw@gmail.com"
	git config --global user.name "David Siaw (via Travis CI)"
elif [ "$CIRCLECI" == "true" ]; then
	git config --global user.email "davidsiaw@gmail.com"
	git config --global user.name "David Siaw (via Circle CI)"
else
	echo Not CI Environment
fi

git clone git@github.com:davidsiaw/weaver-docs.git build
cp -r build/.git ./gittemp
#ruby gettags.rb
bundle exec weaver build -r http://davidsiaw.github.io/weaver-docs/
cp -r ./gittemp build/.git
pushd build
git add .
git add -u
git commit -m "update `date`"
ssh-agent bash -c 'ssh-add ~/.ssh/id_github.com; git push'
popd

rm -rf build
rm -rf gittemp
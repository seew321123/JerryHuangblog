#!/usr/bin/env bash

gitbook install && gitbook build

git checkout master
git push origin master
git push demlution master

gitbook build
git checkout gh-pages
cp -R _book/* .
git add .
git commit -a -m 'chore(build): build'
git push origin gh-pages
git push demlution gh-pages

git checkout master
git status

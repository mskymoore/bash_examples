#!/bin/bash

git init
curl -u $1 https://api.github.com/user/repos -d '{"name":"$2"}'
git remote add origin git@github.com:$1/$2.git
git push origin master

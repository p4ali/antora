#!/usr/bin/env bash

# export GIT_CREDENTIALS="https://$GH_API_TOKEN:@gecgithub.com"
antora --stacktrace site.yml
touch docs/.nojekyll

open docs/index.html

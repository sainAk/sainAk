#!/bin/bash
last_msg=$(git log -1 --pretty=%B)

#update the README.md from remote
if [[ $2 == -p ]]
then
    remote_url=$(git ls-remote --get-url origin)

    if [[ $remote_url == git* ]]
    then
        username=$(echo $remote_url | cut -d: -f2 | cut -d/ -f1)
    else
        username=$(echo $remote_url | cut -d/ -f4)
    fi
    
    curl -s https://raw.githubusercontent.com/$username/$username/master/README.md > README.md
    echo "README.md pulled from remote"
fi

# force push changes
if [[ ! -z "$1" ]]
then
    git add .
    if [[ $last_msg == $1 ]]
    then
        git commit --amend -m "$1"
        git push origin master -f
    else
        git commit -m "$1"
        git push origin master -f
    fi
else
    echo "usage: update \"commit message\" [-p]"
    echo "      -p: pull README.md from remote"
fi

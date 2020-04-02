#!/bin/bash
set -e
if [[ -f ".setupdone" ]]; then
    echo "Setup is done!"
    exit 1
fi
read -p "Domain: " domains
echo "setup domain " $domains
if [[ -z "$domains" ]]; then
    printf '%s\n' "No input entered"
    exit 1
else
    sed -i '' -e 's/(example.org www.example.org)/('"$domains"' www.'"$domains"')/g' init-letsencrypt.sh
    find . -type f \( -iname \*.yml -o -iname \*.conf \) -print0 | xargs -0 sed -i '' -e 's/example.com/'"$domains"'/g'
    git clone https://github.com/laravel/laravel.git
    if [ $? -eq 0 ]; then
        mv README.md README.md.bak
        mv laravel/* .
        rm -rf laravel
        mv README.md.bak README.md
        touch .setupdone
    else
        exit 1
    fi
fi
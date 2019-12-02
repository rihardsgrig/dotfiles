#! /usr/bin/env sh

for file in ~/.{shellpath,shellexports,shellaliases,shellfunctions,zshrc.local}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

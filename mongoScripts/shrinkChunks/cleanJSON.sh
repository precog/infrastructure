#!/bin/bash

sed '1 i\
[
s/^}$/},/; /lastmod/d; s/NumberLong("\(.*\)")/\1/; $a\
{}]' "$@"

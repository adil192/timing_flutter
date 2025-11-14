#!/bin/bash

echo "Converting markdown to html"
pandoc -f markdown privacy-policy.md > temp.html

echo "Inserting content into build/web/privacy-policy.html"
sed -i '/<privacy_policy_goes_here\/>/r temp.html' build/web/privacy-policy.html
rm temp.html

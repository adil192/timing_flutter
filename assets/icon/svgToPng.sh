#!/bin/bash

for file in *.svg
do
  convert -background none "$file" "${file%.svg}.png"
done;

#! /bin/bash

for app in apps/* ; do
  cd $app
  mix hex.outdated
  cd -
done

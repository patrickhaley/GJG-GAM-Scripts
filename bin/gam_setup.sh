#!/bin/bash

# install GAMADC-XTD3 (https://github.com/taers232c/GAMADV-XTD3)
cd ../.. &&
<(curl -s -S -L https://raw.githubusercontent.com/taers232c/GAMADV-XTD3/master/src/gam-install.sh) &&

# setup config files
mkdir GAMWork/au &&
mkdir GAMWork/nz &&
mkdir GAMWork/us
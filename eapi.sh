#!/bin/bash

OVERLAY_PATH="/var/db/repos/kde-sunset"

# Update EAPI in ebuild files
find $OVERLAY_PATH -name "*.ebuild" -exec sed -i 's/EAPI=[0-9]*/EAPI=8/g' {} +


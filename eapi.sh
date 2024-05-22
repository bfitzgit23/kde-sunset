#!/bin/bash

OVERLAY_PATH="/var/db/repos/kde-sunset"

# Update EAPI in ebuild files
find $OVERLAY_PATH -name "*.ebuild" -exec sed -i 's/EAPI=[0-8]/EAPI=6/g' {} +

# Update EAPI in class files
find $OVERLAY_PATH -name "*.eclass" -exec sed -i 's/EAPI=[0-8]/EAPI=6/g' {} +

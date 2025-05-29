#!/bin/bash

OVERLAY_PATH="/home/gentoo/Desktop/kde-sunset"

# Update EAPI in ebuild files
find $OVERLAY_PATH -name "*.ebuild" -exec sed -i 's/EAPI=[0-8]/EAPI=8/g' {} +

# Update EAPI in class files
find $OVERLAY_PATH -name "*.eclass" -exec sed -i 's/EAPI=[0-8]/EAPI=8/g' {} +

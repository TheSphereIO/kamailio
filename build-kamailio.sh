#!/bin/bash

GITREF="master"
VERSION="5.0.0"

mkdir -p rpmbuild/SOURCES
mkdir -p rpmbuild/RPMS
mkdir -p rpmbuild/SPECS

# clone Kamailio repository

git clone https://github.com/kamailio/kamailio.git

cd kamailio
# switch to the requested gitref

git checkout ${GITREF}

echo "Building Kamailio $VERSION packages"

git archive --output ../rpmbuild/SOURCES/kamailio-${VERSION}_src.tar.gz --prefix=kamailio-${VERSION}/  $GITREF
cd ..

cp kamailio.spec rpmbuild/SPECS/

# now build the rpms
cd rpmbuild
rpmbuild  --define "_topdir `pwd`" -bb ./SPECS/kamailio.spec

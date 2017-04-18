#!/bin/bash

mkdir -p rpmbuild/SOURCES
mkdir -p rpmbuild/RPMS
mkdir -p rpmbuild/SPECS

# clone Kamailio repository

#git clone https://github.com/kamailio/kamailio.git
git clone https://github.com/TheSphereIO/kamailio-src.git
mv kamailio-src kamailio

cd kamailio
# switch to the requested gitref
if [ -z "$1" ]
then
    GITREF="master"
else
    GITREF=$1
fi

git checkout ${GITREF}

LASTCOMMIT=$(git rev-parse --short HEAD)                                                                                                                                                     
TAG=`git tag --points-at ${LASTCOMMIT}`                                                                                                                                                      
                                                                                                                                                                                             
if [ ! -z "$TAG" ]                                                                                                                                                                           
then                                                                                                                                                                                         
    VERSION=${TAG}                                                                                                                                                                       
else                                                                                                                                                                                         
    VERSION=`git describe --always`                                                                                                                                                      
    VERSION=${VERSION//-/.}                                                                                                                                                                  
fi

echo "Building Kamailio $VERSION packages"

git archive --output ../rpmbuild/SOURCES/kamailio-${VERSION}_src.tar.gz --prefix=kamailio-${VERSION}/  $GITREF
cd ..

#cp kamailio/pkg/kamailio/centos/7/kamailio.spec rpmbuild/SPECS/
cp kamailio/pkg/kamailio/centos/7/kamailio.spec .
sed -i "s/%define ver.*/%define ver ${VERSION}/g" kamailio.spec
sed -i "s/%define rel.*//g" kamailio.spec

# now build the rpms
rpmbuild  --define "_topdir `pwd`/rpmbuild" -bb kamailio.spec
rm -rf kamailio

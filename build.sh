#!/bin/bash

VERSION="${@}" &&
    RELEASE=0.1.0 &&
    rm --recursive --force build &&
    mkdir build &&
    sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "wbuild/ivoryomega.spec" ivoryomega.spec &&
    wget --output-document build/ivoryomega-${VERSION}.tar.gz https://github.com/wildmountain/ivoryomega/archive/v${VERSION}.tar.gz &&
    mkdir --parents build/init/01 &&
    mock --init --resultdir build/init/01 &&
    mkdir --parents build/buildsrpm/01 &&
    mock --buildsrpm --spec build/ivoryomega.spec --sources build/ivoryomega-${VERSION}.tar.gz --resultdir build/buildsrpm/01 &&
    mkdir --parents build/init/02 &&
    mock --init --resultdir build/init/02 &&
    mkdir --parents build/rebuild/01 &&
    mock --rebuild build/buildsrpm/01/ivoryomega-${VERSION}-${RELEASE}.src.rpm  --resultdir build/rebuild/01 &&
    mkdir --parents build/init/03 &&
    mock --init --resultdir build/init/03 &&
    mkdir --parents build/install/01 &&
    mock --install build/rebuild/01/ivoryomega-${VERSION}-${RELEASE}.x86_64.rpm --resultdir build/install/01 &&
    mkdir --parents build/copyin/01 &&
    mock --copyin dancingleather.repo dancingleather.repo &&
    mkdir --parents build/shell/01 &&
    mock --shell "diff --brief --report-identical-files /etc/yum.repos.d/dancingleather.repo dancingleather.repo" --resultdir build/shell/01 &&
    git clone -b issue-0002-ivoryomega git@github.com:rawflag/dancingleather.git build/repository &&
    cp build/rebuild/01/ivoryomega-${VERSION}-${RELEASE}.x86_64.rpm build/repository &&
    cd build/repository &&
    git add ivoryomega-${VERSION}-${RELEASE}.x86_64.rpm &&
    git commit -am "added ivoryomega-${VERSION}-${RELEASE}.x86_64.rpm" -S &&
    git push origin issue-0002-ivoryomega &&
    true

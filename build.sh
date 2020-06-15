#!/bin/sh

VERSION=0.0.1-1

set -eu

printf "\033[1;32m+ Cleaning previous build...\033[0m\n"
test -d pkgroot && rm -r pkgroot
test -e *.deb && rm *.deb
test -e hello.c && rm hello.c
mkdir -p pkgroot/DEBIAN
mkdir -p pkgroot/usr/bin
mkdir -p pkgroot/opt/dirtyhello/bin

printf "\033[1;32m+ Generating code...\033[0m\n"
printf '#include<stdio.h>\nint main(void){printf("Hello World!\\n");return 0;}'> hello.c

printf "\033[1;32m+ Compiling code...\033[0m\n"
gcc -static -o pkgroot/opt/dirtyhello/bin/hello hello.c

printf "\033[1;32m+ Adding program to distro path...\033[0m\n"
ln -rsv pkgroot/opt/dirtyhello/bin/hello pkgroot/usr/bin/hello

printf "\033[1;32m+ Verifying program...\033[0m\n"
pkgroot/usr/bin/hello

printf "\033[1;32m+ Generating Debian packaging control file...\033[0m\n"
cat > pkgroot/DEBIAN/control <<EOF
Package: dirtyhello
Version: $VERSION
Section: utils
Priority: optional
Maintainer: GuessWho <hello@hello.example>
Architecture: amd64
Description: dirty packaged hello world written in C
EOF

printf "\033[1;32m+ Dirty building Debian package...\033[0m\n"
fakeroot dpkg-deb --build pkgroot dirtyhello_"$VERSION"_amd64.deb

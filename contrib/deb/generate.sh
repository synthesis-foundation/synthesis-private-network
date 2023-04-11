#!/bin/sh

# This is a lazy script to create a .deb for Debian/Ubuntu. It installs
# synthesis and enables it in systemd. You can give it the PKGARCH= argument
# i.e. PKGARCH=i386 sh contrib/deb/generate.sh

if [ `pwd` != `git rev-parse --show-toplevel` ]
then
  echo "You should run this script from the top-level directory of the git repo"
  exit 1
fi

PKGBRANCH=$(basename `git name-rev --name-only HEAD`)
PKGNAME=$(sh contrib/semver/name.sh)
PKGVERSION=$(sh contrib/semver/version.sh --bare)
PKGARCH=${PKGARCH-amd64}
PKGFILE=$PKGNAME-$PKGVERSION-$PKGARCH.deb
PKGREPLACES=synthesis

if [ $PKGBRANCH = "master" ]; then
  PKGREPLACES=synthesis-develop
fi

if [ $PKGARCH = "amd64" ]; then GOARCH=amd64 GOOS=linux ./build
elif [ $PKGARCH = "i386" ]; then GOARCH=386 GOOS=linux ./build
elif [ $PKGARCH = "mipsel" ]; then GOARCH=mipsle GOOS=linux ./build
elif [ $PKGARCH = "mips" ]; then GOARCH=mips64 GOOS=linux ./build
elif [ $PKGARCH = "armhf" ]; then GOARCH=arm GOOS=linux GOARM=6 ./build
elif [ $PKGARCH = "arm64" ]; then GOARCH=arm64 GOOS=linux ./build
elif [ $PKGARCH = "armel" ]; then GOARCH=arm GOOS=linux GOARM=5 ./build
else
  echo "Specify PKGARCH=amd64,i386,mips,mipsel,armhf,arm64,armel"
  exit 1
fi

echo "Building $PKGFILE"

mkdir -p /tmp/$PKGNAME/
mkdir -p /tmp/$PKGNAME/debian/
mkdir -p /tmp/$PKGNAME/usr/bin/
mkdir -p /tmp/$PKGNAME/etc/systemd/system/

cat > /tmp/$PKGNAME/debian/changelog << EOF
Please see https://github.com/synthesis-network/synthesis-go/
EOF
echo 9 > /tmp/$PKGNAME/debian/compat
cat > /tmp/$PKGNAME/debian/control << EOF
Package: $PKGNAME
Version: $PKGVERSION
Section: contrib/net
Priority: extra
Architecture: $PKGARCH
Replaces: $PKGREPLACES
Conflicts: $PKGREPLACES
Maintainer: Neil Alexander <neilalexander@users.noreply.github.com>
Description: Synthesis Network
 Synthesis is an early-stage implementation of a fully end-to-end encrypted IPv6
 network. It is lightweight, self-arranging, supported on multiple platforms and
 allows pretty much any IPv6-capable application to communicate securely with
 other Synthesis nodes.
EOF
cat > /tmp/$PKGNAME/debian/copyright << EOF
Please see https://github.com/synthesis-network/synthesis-go/
EOF
cat > /tmp/$PKGNAME/debian/docs << EOF
Please see https://github.com/synthesis-network/synthesis-go/
EOF
cat > /tmp/$PKGNAME/debian/install << EOF
usr/bin/synthesis usr/bin
usr/bin/synthesisctl usr/bin
etc/systemd/system/*.service etc/systemd/system
EOF
cat > /tmp/$PKGNAME/debian/postinst << EOF
#!/bin/sh

if ! getent group synthesis 2>&1 > /dev/null; then
  groupadd --system --force synthesis || echo "Failed to create group 'synthesis' - please create it manually and reinstall"
fi

if [ -f /etc/synthesis.conf ];
then
  mkdir -p /var/backups
  echo "Backing up configuration file to /var/backups/synthesis.conf.`date +%Y%m%d`"
  cp /etc/synthesis.conf /var/backups/synthesis.conf.`date +%Y%m%d`
  echo "Normalising and updating /etc/synthesis.conf"
  /usr/bin/synthesis -useconf -normaliseconf < /var/backups/synthesis.conf.`date +%Y%m%d` > /etc/synthesis.conf
  chgrp synthesis /etc/synthesis.conf

  if command -v systemctl >/dev/null; then
    systemctl daemon-reload >/dev/null || true
    systemctl enable synthesis || true
    systemctl start synthesis || true
  fi
else
  echo "Generating initial configuration file /etc/synthesis.conf"
  echo "Please familiarise yourself with this file before starting Synthesis"
  sh -c 'umask 0027 && /usr/bin/synthesis -genconf > /etc/synthesis.conf'
  chgrp synthesis /etc/synthesis.conf
fi
EOF
cat > /tmp/$PKGNAME/debian/prerm << EOF
#!/bin/sh
if command -v systemctl >/dev/null; then
  if systemctl is-active --quiet synthesis; then
    systemctl stop synthesis || true
  fi
  systemctl disable synthesis || true
fi
EOF

cp synthesis /tmp/$PKGNAME/usr/bin/
cp synthesisctl /tmp/$PKGNAME/usr/bin/
cp contrib/systemd/*.service /tmp/$PKGNAME/etc/systemd/system/

tar -czvf /tmp/$PKGNAME/data.tar.gz -C /tmp/$PKGNAME/ \
  usr/bin/synthesis usr/bin/synthesisctl \
  etc/systemd/system/synthesis.service \
  etc/systemd/system/synthesis-default-config.service
tar -czvf /tmp/$PKGNAME/control.tar.gz -C /tmp/$PKGNAME/debian .
echo 2.0 > /tmp/$PKGNAME/debian-binary

ar -r $PKGFILE \
  /tmp/$PKGNAME/debian-binary \
  /tmp/$PKGNAME/control.tar.gz \
  /tmp/$PKGNAME/data.tar.gz

rm -rf /tmp/$PKGNAME

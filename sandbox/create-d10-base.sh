#!/bin/bash

NAME=bn-d10

lxc image delete $NAME
lxc delete $NAME
lxc profile device add default root disk path=/ pool=default
lxc launch images:debian/buster $NAME

echo "Waiting for container to boot..."
while [[ ! `lxc exec "$NAME" -- runlevel` =~ ^N ]]; do
    sleep 1
done

echo "Running apt..."
lxc exec $NAME -- bash <<END
echo "" > /etc/apt/apt.conf.d/20auto-upgrades

#dpkg --add-architecture i386
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
#add-apt-repository -y ppa:avsm/ppa

export DEBIAN_FRONTEND=noninteractive

apt install -y wget gnupg2

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb

#curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -

apt-get update
apt-get upgrade -y

apt-get install -y ruby python3 time
apt-get install -y libarchive-zip-perl libautodie-perl libclone-perl
apt-get install -y libipc-system-simple-perl
apt-get install -y clang clang-tools valgrind build-essential
#apt-get install -y openjdk-8-jdk
apt-get install -y fuse libfuse-dev pkg-config
apt-get install -y wamerican libbsd-dev libgmp-dev
apt-get install -y esl-erlang elixir nodejs

#apt-get install -y ocaml ocaml-native-compilers camlp4-extra opam \
#        nasm m4 gcc-multilib g++-multilib libc6-dev-i386 libc6-dev \
#        libc6 libc6-dbg libc6-dbg:i386

#su ubuntu -c "cd ~student ; opam init -y"
#su ubuntu -c "echo \". /home/student/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true\" >> ~student/.profile"
#su ubuntu -c "cd ~student ; opam install -y ounit extlib ocamlfind"

apt-get upgrade -y

adduser --disabled-password --gecos "Debian User,,," debian
adduser --disabled-password --gecos "Student,,," ubuntu

END

echo "Stopping; Publishing..."
lxc stop $NAME
lxc publish $NAME --alias $NAME
lxc delete $NAME

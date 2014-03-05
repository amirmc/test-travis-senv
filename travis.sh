#!/usr/bin/env bash

# env variables
OPAM_DEPENDS="travis-senv"
SSH_DEPLOY_KEY=~/.ssh/id_rsa
 
case "$OCAML_VERSION,$OPAM_VERSION" in
4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

# set up machine
echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam

# set up OPAM
export OPAMYES=1
# export OPAMVERBOSE=1  # uncomment this to get more debug info
opam init
opam install ${OPAM_DEPENDS}
eval `opam config env`

# Print info on system
echo Working directory
pwd
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version
echo Mirage version
mirage --version

# travis-senv test
travis-senv decrypt > $SSH_DEPLOY_KEY
chmod 600 $SSH_DEPLOY_KEY # owner can read and write
echo "Host $DEPLOY_USER github.com"   >> ~/.ssh/config
echo "  Hostname github.com"          >> ~/.ssh/config
echo "  StrictHostKeyChecking no"     >> ~/.ssh/config
echo "  CheckHostIP no"               >> ~/.ssh/config
echo "  UserKnownHostsFile=/dev/null" >> ~/.ssh/config

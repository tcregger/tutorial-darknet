#!/bin/bash

export EASY_RSA="`pwd`"

#
# This variable should point to
# the requested executables
#
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"


# This variable should point to
# the openssl.cnf file included
# with easy-rsa.
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`

# Edit this variable to point to
# your soon-to-be-created key
# directory.
#
# WARNING: clean-all will do
# a rm -rf on this directory
# so make sure you define
# it correctly!
export KEY_DIR="$EASY_RSA/keys"

# Issue rm -rf warning
echo NOTE: If you run ./clean-all, I will be doing a rm -rf on $KEY_DIR

# PKCS11 fixes
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"

# Increase this to 2048 if you
# are paranoid.  This will slow
# down TLS negotiation performance
# as well as the one-time DH parms
# generation process.
export KEY_SIZE=2048

# In how many days should the root CA key expire?
export CA_EXPIRE=3650

# In how many days should certificates expire?
export KEY_EXPIRE=3650

# These are the default values for fields
# which will be placed in the certificate.
# Don't leave any of these fields blank.
export KEY_COUNTRY="US"
export KEY_PROVINCE="MA"
export KEY_CITY="Boston"
export KEY_ORG="BinaryFreedom"
export KEY_EMAIL="rek2@binaryfreedom.info"
export KEY_OU="OperationsLab"

# X509 Subject Field
export KEY_NAME="server"

# PKCS11 Smart Card
# export PKCS11_MODULE_PATH="/usr/lib/changeme.so"
# export PKCS11_PIN=1234

# If you'd like to sign all keys with the same Common Name, uncomment the KEY_CN export below
# You will also need to make sure your OpenVPN server config has the duplicate-cn option set
# export KEY_CN="CommonName"



/etc/openvpn/easy-rsa/build-key $1


[[ -d /etc/openvpn/easy-rsa/users ]] || mkdir /etc/openvpn/easy-rsa/users

mkdir /etc/openvpn/easy-rsa/users/$1
cat /etc/openvpn/easy-rsa/keys/client.ovpn > /etc/openvpn/easy-rsa/users/users/$1/$1.ovpn
echo "<ca>" >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
cat /etc/openvpn/easy-rsa/keys/ca.crt >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
echo "</ca>" >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
echo "<cert>" >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
cat /etc/openvpn/easy-rsa/keys/$1.crt >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
echo "</cert>" >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
echo "<key>" >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
cat /etc/openvpn/easy-rsa/keys/$1.key >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
echo "</key>" >> /etc/openvpn/easy-rsa/users/$1/$1.ovpn
#!/bin/sh

usage() {
    cat <<"EOF"
This script will configure your system to only update Contents files
when "apt-file update" is run.  This is done by installing two config
files for APT.

To do this, please run the following as root:
  $0 --install

NB: Depending on your system and your APT configuration, you may have
to tweak the resulting /etc/apt/apt-file.conf to ensure you do not
fetch some resources twice (it uses a blacklist).

If you want to undo it, then as root run:
  $0 --uninstall

CAVEAT: During --uninstall will simply remove the files/directories
created by this script *WITHOUT ANY BACKUP*.  Manual changes to
e.g. /etc/apt/apt-file.conf *WILL BE LOST*.

EOF
}

run() {
    echo "$@"
    "$@"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
    exit 0
fi


dir="$(dirname "$0")"

if [ "$1" = "--install" ] ; then
    set -e
    if [ -f /etc/apt/apt-file.conf ] ; then
        echo "Cowardly refusing to overwrite an existing /etc/apt/apt-file.conf" 2>&1
        exit 1
    fi
    if [ -f /etc/apt/apt.conf.d/60disable-contents-fetching.conf ] ; then
        echo "Cowardly refusing to overwrite an existing" 2>&1
        echo "/etc/apt/apt.conf.d/60disable-contents-fetching.conf" 2>&1
        exit 1
    fi
    run mkdir -p /var/lib/apt-file/lists/partial
    run chown _apt:root /var/lib/apt-file/lists/partial
    run chmod 0700 /var/lib/apt-file/lists/partial

    run cp -a "${dir}/apt-file.conf" /etc/apt/
    run cp -a "${dir}/60disable-contents-fetching.conf" /etc/apt/apt.conf.d

    echo "apt-file 2 style updating installed"
    echo
    echo "Please review /etc/apt/apt-file.conf.  In particular,"
    echo "please note the caveats listed in that file"
elif [ "$1" = "--uninstall" ] ; then
    run rm -f /etc/apt/apt.conf.d/60disable-contents-fetching.conf
    run rm -f /etc/apt/apt-file.conf
    run rm -fr /var/lib/apt-file
else
    echo "Please run $0 --install (or --uninstall)" 2>&1
    echo
    usage
    exit 1
fi



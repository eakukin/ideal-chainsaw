#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y mc btop openconnect NetworkManager-openconnect plasma-nm-openconnect git-credential-libsecret lm_sensors

# Remove plasma-discover
dnf5 remove -y plasma-discover

# Install latest VS Code
wget -O /tmp/vscode.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
dnf5 install --nogpgcheck -y /tmp/vscode.rpm
rm -f /tmp/vscode.rpm

#Bazaar
dnf5 -y copr enable copr.fedorainfracloud.org/ublue-os/packages
dnf5 -y install krunner-bazaar
dnf5 -y copr disable copr.fedorainfracloud.org/ublue-os/packages

#web app manager
dnf5 -y copr enable ublue-os/webapp-manager
dnf5 -y install webapp-manager
dnf5 -y copr disable ublue-os/webapp-manager

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

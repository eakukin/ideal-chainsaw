#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y mc btop openconnect NetworkManager-openconnect plasma-nm-openconnect git-credential-libsecret lm_sensors merkuro kdepim-addons kdepim-runtime akonadi akonadi-calendar akonadi-calendar-tools kio-gdrive 

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

# Install latest amdgpu_top x86_64 RPM from GitHub releases
AMDGPU_TOP_RPM_URL="$(curl -fsSL https://api.github.com/repos/Umio-Yasuno/amdgpu_top/releases/latest | grep -o 'https://[^"]*amdgpu_top-[^"]*\.x86_64\.rpm' | head -n 1)"
wget -O /tmp/amdgpu_top.rpm "${AMDGPU_TOP_RPM_URL}"
dnf5 install --nogpgcheck -y /tmp/amdgpu_top.rpm
rm -f /tmp/amdgpu_top.rpm

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl enable podman.socket

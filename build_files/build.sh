#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y mc btop openconnect NetworkManager-openconnect plasma-nm-openconnect git-credential-libsecret lm_sensors ffmpeg-free intel-gpu-tools

#install Visual Studio Code from Microsoft's repo
rpm --import https://packages.microsoft.com/keys/microsoft.asc && echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf5 check-update && dnf5 install code

# Install latest Vivaldi browser to /usr/local instead of /opt
VIVALDI_LATEST=$(curl -s https://repo.vivaldi.com/stable/rpm/x86_64/ | grep -oP 'vivaldi-stable-[0-9.]+-[0-9]+\.x86_64\.rpm' | sort -V | tail -n1)
cd /tmp
curl -LO "https://repo.vivaldi.com/stable/rpm/x86_64/${VIVALDI_LATEST}"
rpm2cpio "${VIVALDI_LATEST}" | cpio -idmv
# Move from extracted /opt to /usr/local
mv opt/vivaldi /usr/local/
# Install desktop files and icons to standard locations
if [ -d usr/share ]; then
    cp -r usr/share/* /usr/share/
fi
# Clean up
rm -rf opt usr "${VIVALDI_LATEST}"
cd -

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

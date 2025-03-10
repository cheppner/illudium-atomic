#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

# enable selinux policy to allow kernel modules
setsebool -P domain_kernel_load_modules on

# install cachyos kernel
dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y install kernel-cachyos kernel-cachyos-devel-matched
dnf -y install scx-scheds
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos

# dedupe

# install packages
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y config-manager setopt fedora-cisco-openh264.enabled=1
dnf update -y
dnf -y swap ffmpeg-free ffmpeg --allowerasing
dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
dnf -y swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
dnf -y swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
#dnf install -y rpmfusion-nonfree-release-tainted
# todo - add VSCODE
dnf install -y tmux 
dnf install -y steam
dnf install -y gamescope
dnf install -y mangohud
dnf install -y goverlay
dnf install -y btop
dnf install -y rocm-smi
dnf install -y google-noto-* --allowerasing --skip-broken
dnf -y copr enable ilyaz/LACT
dnf -y copr enable lizardbyte/stable
dnf install -y lact
dnf install -y Sunshine
dnf -y copr disable ilyaz/LACT
dnf -y copr disable lizardbyte/stable

# VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf -y check-update
#dnf -y install code

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

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
# dnf -y copr enable bieszczaders/kernel-cachyos
# dnf -y copr enable bieszczaders/kernel-cachyos-addons
# dnf -y install kernel-cachyos kernel-cachyos-devel-matched
# dnf -y install scx-scheds
# dnf -y copr disable bieszczaders/kernel-cachyos-addons
# dnf -y copr disable bieszczaders/kernel-cachyos

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

sudo dnf5 -y install \
                    firefox \
                    steam \
                    gamescope \
                    mangohud \
                    goverlay \
                    btop \
                    rocm-smi \
                    source-foundry-hack-fonts \
                    kate \
                    vlc \
                    krita \
                    fastfetch \
                    tmux \
                    unifont-fonts

# VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf -y check-update
#dnf -y install code

# install packages from Nobara COPR
sudo dnf5 -y copr enable gloriouseggroll/nobara-41
sudo dnf5 -y install umu-launcher \
                     starship
sudo dnf5 -y copr disable gloriouseggroll/nobara-41

# Install and enable System76 scheduler
sudo dnf5 -y copr enable kylegospo/system76-scheduler
sudo dnf5 -y install system76-scheduler
sudo systemctl enable com.system76.Scheduler.service
sudo dnf5 -y copr disable kylegospo/system76-scheduler

# Install sunshine
sudo dnf5 -y copr enable lizardbyte/stable
sudo dnf5 -y install Sunshine

# Install and enable LACT
sudo dnf5 -y copr enable ilyaz/LACT
sudo dnf5 -y install lact
sudo systemctl enable lactd
sudo dnf5 -y copr disable ilyaz/LACT

# Enable flatpak repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
flatpak install -y --noninteractive flathub net.davidotek.pupgui2

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

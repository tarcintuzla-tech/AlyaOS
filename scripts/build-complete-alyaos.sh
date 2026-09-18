#!/bin/bash
set -e

BUILD_DIR="$HOME/AlyaOS/build/rootfs"

if [ ! -d "$BUILD_DIR" ]; then
    echo "Hata: Önce RootFS klasörünü debootstrap ile oluşturmalısınız."
    exit 1
fi

echo "[AlyaOS Master] Sanal dosya sistemleri bağlanıyor..."
sudo mount --bind /dev "$BUILD_DIR/dev" || true
sudo mount --bind /dev/pts "$BUILD_DIR/dev/pts" || true
sudo mount --bind /proc "$BUILD_DIR/proc" || true
sudo mount --bind /sys "$BUILD_DIR/sys" || true

cleanup() {
    echo "[AlyaOS Master] Bağlantılar temizleniyor..."
    sudo umount -l "$BUILD_DIR/dev/pts" 2>/dev/null || true
    sudo umount -l "$BUILD_DIR/dev" 2>/dev/null || true
    sudo umount -l "$BUILD_DIR/proc" 2>/dev/null || true
    sudo umount -l "$BUILD_DIR/sys" 2>/dev/null || true
}
trap cleanup EXIT

echo "[AlyaOS Master] Kilitler temizleniyor ve veritabanı onarılıyor..."
sudo rm -f "$BUILD_DIR/var/lib/dpkg/lock"*
sudo rm -f "$BUILD_DIR/var/lib/apt/lists/lock"*
sudo rm -f "$BUILD_DIR/var/cache/apt/archives/lock"*

sudo chroot "$BUILD_DIR" dpkg --configure -a
sudo chroot "$BUILD_DIR" apt-get update

echo "[AlyaOS Master] Paketler ve AlyaOS Mağazası yükleniyor..."
sudo chroot "$BUILD_DIR" apt-get install -y \
    linux-image-amd64 live-boot systemd-sysv sudo \
    lightdm xfce4 xfce4-goodies xfce4-terminal \
    network-manager network-manager-gnome blueman bluez \
    firefox-esr thunar mousepad galculator file-roller p7zip-full \
    vlc viewnior xfce4-screenshooter pavucontrol \
    python3 python3-pyqt5 python3-tk python3-psutil python3-pil python3-pil.imagetk \
    firmware-linux firmware-linux-nonfree firmware-realtek firmware-atheros firmware-iwlwifi \
    calamares calamares-settings-debian cryptsetup \
    gnome-software gnome-software-plugin-flatpak flatpak

sudo chroot "$BUILD_DIR" flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true

sudo mkdir -p "$BUILD_DIR/usr/local/bin"
sudo mkdir -p "$BUILD_DIR/etc/skel/.config/autostart"

if [ -f "$HOME/AlyaOS/scripts/app.py" ]; then
    sudo cp "$HOME/AlyaOS/scripts/app.py" "$BUILD_DIR/usr/local/bin/alya-setup-wizard.py"
    sudo chmod +x "$BUILD_DIR/usr/local/bin/alya-setup-wizard.py"
fi

cat << 'AUTODESK' | sudo tee "$BUILD_DIR/etc/skel/.config/autostart/alyaos-wizard.desktop" > /dev/null
[Desktop Entry]
Type=Application
Name=AlyaOS Setup Wizard
Exec=python3 /usr/local/bin/alya-setup-wizard.py
Terminal=false
AUTODESK

echo "[AlyaOS Master] Yapılandırmalar ve AlyaOS Mağazası başarıyla tamamlandı!"

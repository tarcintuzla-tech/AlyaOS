#!/bin/bash
set -e

WORK_DIR="$HOME/AlyaOS/build"
ROOTFS_DIR="$WORK_DIR/rootfs"
ISO_DIR="$WORK_DIR/iso"

echo "=== [1/4] ISO Dizin Yapısı Hazırlanıyor ==="
mkdir -p "$ISO_DIR/live"
mkdir -p "$ISO_DIR/isolinux"
mkdir -p "$ISO_DIR/boot/grub"

echo "=== [2/4] Çekirdek ve Initrd Dosyaları Kopyalanıyor ==="
cp "$ROOTFS_DIR/boot/vmlinuz-"* "$ISO_DIR/live/vmlinuz"
cp "$ROOTFS_DIR/boot/initrd.img-"* "$ISO_DIR/live/initrd.img"

echo "=== [3/4] Rootfs Sıkıştırılıyor (SquashFS) ==="
sudo rm -f "$ISO_DIR/live/filesystem.squashfs"
sudo mksquashfs "$ROOTFS_DIR" "$ISO_DIR/live/filesystem.squashfs" -e proc sys dev ptmx

echo "=== [4/4] Önyüklenebilir AlyaOS ISO İmajı Üretiliyor ==="
cat << 'GRUB' > "$ISO_DIR/boot/grub/grub.cfg"
set default=0
set timeout=5

menuentry "AlyaOS Live (XFCE Masaüstü)" {
    linux /live/vmlinuz boot=live quiet splash
    initrd /live/initrd.img
}

menuentry "AlyaOS Live (Güvenli Mod)" {
    linux /live/vmlinuz boot=live nomodeset
    initrd /live/initrd.img
}
GRUB

grub-mkrescue -o "$HOME/AlyaOS/alyaos.iso" "$ISO_DIR"

echo "=================================================="
echo " [AlyaOS Master] TEBRİKLER! ISO BAŞARIYLA ÜRETİLDİ!"
echo " ISO Konumu: $HOME/AlyaOS/alyaos.iso"
echo "=================================================="

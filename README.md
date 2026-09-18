AlyaOS
AlyaOS, Debian Bookworm tabanlı, hafif XFCE masaüstü, Calamares yükleyicisi, Flatpak destekli AlyaOS Mağazası, Python ilk açılış sihirbazı ve özel duvar kagidi ile logosu bulunan ozel bir Linux dagitimidir.

OZELLIKLER:

Debian Bookworm taban altyapisi

Hafif ve hizli XFCE masaustu ortami

Calamares grafiksel sistem yukleyicisi

GNOME Software ve Flatpak tabanli AlyaOS Uygulama Magazasi

Ilk acilista calisan Python tabanli sihirbaz

Ozel duvar kagidi (wallpaper.png) ve sistem logosu (alyaos-logo.png) entegrasyonu

DERLEME VE KURULUM:

Gerekli paketleri yukleyin:
sudo apt update && sudo apt install -y debootstrap squashfs-tools xorriso mtools grub-pc-bin grub-efi-amd64-bin

ISO imajini uretmek icin betigi calistirin:
sudo -E ~/build-iso.sh

ISO dosyasi tamamlandiginda ~/AlyaOS/alyaos.iso konumunda hazir olacaktir.

TEST ETME:
qemu-system-x86_64 -enable-kvm -m 2048 -cdrom ~/AlyaOS/alyaos.iso

LISANS:
MIT Lisansi altinda acik kaynaklidir.

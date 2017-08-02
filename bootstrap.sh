ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
pacman -Syu --noconfirm \
    base-devel \
    xorg-server xorg-apps xorg-xinit xf86-video-vesa \
    xfce4 xfce4-goodies \
    lightdm lightdm-gtk-greeter

echo -e 'y\n\n' | pacman -S virtualbox-guest-utils #conflict

systemctl enable lightdm


#yaourt
cat <<'EOF' >> /etc/pacman.conf
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOF

pacman -Syu --noconfirm yaourt


#LANG
sed -i -e '/^#\(ja_JP\|en_US\).UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo "LANG=ja_JP.UTF-8" > /etc/locale.conf

su - vagrant -c 'yaourt -S --noconfirm ttf-ricty'
echo -e '\n' | pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-mozc #selection

cat <<'EOF' >> /etc/xprofile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF


#theme
su - vagrant -c 'sh <<SHELL
yaourt -S --noconfirm gtk-theme-arc-git arc-icon-theme-git
export $(dbus-launch)
xfconf-query -c xfwm4 -p /general/theme -n -t string -s "Arc-Dark"
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Arc"
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 0
SHELL'

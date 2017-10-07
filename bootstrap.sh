ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
pacman -Syu --noconfirm \
    base-devel \
    xorg-server xorg-apps xorg-xinit xf86-video-vesa \
    xfce4 xfce4-goodies \
    lightdm lightdm-gtk-greeter \
    vim zsh tmux xsel \
    alsa-utils pulseaudio pavucontrol \
    xmonad xmonad-contrib

echo -e 'y\n\n' | pacman -S virtualbox-guest-utils #conflict

groupadd autologin
gpasswd -a vagrant autologin
sed -ie 's/^#autologin-user=$/autologin-user=vagrant/' /etc/lightdm/lightdm.conf
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
xfconf-query -c xfwm4 -p /general/button_layout -s "O|HMC"
xfconf-query -c xfwm4 -p /general/theme -n -t string -s "Arc-Dark"
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Arc"
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -n -t int -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -n -t bool -s false
SHELL'

#Install nord.theme
su - vagrant -c 'sh <<SHELL
mkdir -p $HOME/.xmonad
curl -s https://gist.githubusercontent.com/i544c/4ca35842aa2f5f5aa89c938b521e6743/raw/8a0b9411e7dfe5a58f698386b7a2d490b68b9581/xmonad.hs \
    -o $HOME/.xmonad/xmonad.hs >/dev/null
mkdir -p $HOME/.config/xfce4/terminal
curl -s https://gist.githubusercontent.com/i544c/87f63b31fd905448e8c3005e577d50a8/raw/da0ac3f86373475485cd898c113edda4dd99f8b6/terminalrc \
    -o $HOME/.config/xfce4/terminal/terminalrc >/dev/null
mkdir -p $HOME/.local/share/xfce4/terminal/colorschemes
curl -s https://raw.githubusercontent.com/arcticicestudio/nord-xfce-terminal/develop/src/nord.theme \
    -o $HOME/.local/share/xfce4/terminal/colorschemes/nord.theme >/dev/null
git clone https://github.com/zplug/zplug $HOME/.zplug
git clone https://github.com/i544c/dotfiles $HOME/dotfiles
cd $HOME/dotfiles && make deploy
SHELL'

chsh -s `which zsh` vagrant

sudo ln -s /usr/share/git/diff-highlight/diff-highlight /usr/local/bin/

echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf

amixer sset Master unmute

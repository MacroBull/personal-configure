DATE=`date -I`

KDE_SRC=~/.kde4/share
KDE_DST=kde/share
CONFIG_SRC=~/.config
CONFIG_DST=app/config
LOCAL_SRC=~/.local/share
LOCAL_DST=app/local_share

ETC_DST=sys/etc

C_SYNC=rsync -r --del
C_CPR=cp -rf
C_CPF=cp -f

MAKE=/usr/bin/make

submit:
	$(MAKE) backup_public
	$(MAKE) backup_private
	git push origin public

pre_private:
	git add -uv *
	-git commit -m 'manual backup'
	git checkout private

pre_public:
	git add -uv *
	-git commit -m 'manual backup'
	git checkout public
	
backup_private: 
	$(MAKE) pre_private
	$(MAKE) sys_private
	$(MAKE) app_private
	git add -uv *
	-git commit -m $(DATE)
	git gc
	tar czf /mnt/data/Backups/Achieved/configure-private-$(DATE).tgz ./*
	
	
backup_public: 
	$(MAKE) pre_public
	$(MAKE) kde sys_public
	$(MAKE) app_public
	$(MAKE) shell
	-find -iname "*hist*" -exec rm -rf {} \;
	-find -iname "*log" -exec rm -rf {} \;
	-find -iname "*thumb*" -exec rm -rf {} \;
	git add -uv *
	privChecker
	-git commit -m $(DATE)
	git gc
	tar czf /mnt/data/Backups/Achieved/configure-public-$(DATE).tgz ./*
	
	
#####################Paths################################

path-kde:
	mkdir -p $(KDE_DST) $(KDE_DST)/apps $(KDE_DST)/config
	
path-etc:
	mkdir -p $(ETC_DST)
	mkdir -p $(ETC_DST)/default
	mkdir -p $(ETC_DST)/xdg
	
path-config:
	mkdir -p $(CONFIG_DST)
	mkdir -p app/
	
path-shell:
	mkdir -p shell/
	
#####################KDE################################
 
kde: path-config\
	dolphin kfileplaces kate yakuake konsole \
	klipper color-scheme kile ksysguard baloo breeze shortcut \
	ksnapshot kwin okular akonadi gwenview \
	desktop-widgets \
# 	kde-icons kxsaver
	$(C_CPF) $(CONFIG_SRC)/Trolltech.conf $(CONFIG_DST)/
	$(C_CPF) $(KDE_SRC)/config/kdeglobals $(KDE_DST)/config/
# 	$(C_CPF) $(KDE_SRC)/config/systemsettingsrc $(KDE_DST)/config/

	-$(C_CPF) $(CONFIG_SRC)/k* $(CONFIG_DST)/
	-$(C_CPF) $(CONFIG_SRC)/*rc $(CONFIG_DST)/
	echo 'KDE DONE'

kde-icons: path-kde
	$(C_CPR) $(KDE_SRC)/icons $(KDE_DST)/

dolphin: path-kde kfileplaces
	mkdir -p $(KDE_DST)/apps/dolphin/
# 	$(C_CPF) $(KDE_SRC)/apps/dolphin/dolphinui.rc $(KDE_DST)/apps/dolphin/
	$(C_CPF) $(KDE_SRC)/config/dolphinrc $(KDE_DST)/config/
	
kfileplaces: path-kde
	$(C_SYNC) $(KDE_SRC)/apps/kfileplaces $(KDE_DST)/apps/

kate: path-kde
	#$(C_CPF) $(KDE_SRC)/apps/kate $(KDE_DST)/apps/
	-$(C_CPF) $(KDE_SRC)/config/kate*rc $(KDE_DST)/config/
	
plasma: path-kde
	$(C_SYNC) $(KDE_SRC)/apps/plasma $(KDE_DST)/apps/
	$(C_CPF) $(KDE_SRC)/config/plasma*rc $(KDE_DST)/config/
	$(C_CPF) $(CONFIG_SRC)/plasma*rc $(CONFIG_DST)/
	
yakuake: konsole path-config
	#$(C_CPF) $(CONFIG_SRC)/yakuakerc $(CONFIG_DST)/
	$(C_SYNC) $(KDE_SRC)/apps/yakuake $(KDE_DST)/apps/
	$(C_CPF) $(KDE_SRC)/config/yakuake*rc $(KDE_DST)/config/
	$(C_SYNC) $(LOCAL_SRC)/konsole $(LOCAL_DST)/

	
konsole: path-kde
	$(C_SYNC) $(KDE_SRC)/apps/konsole $(KDE_DST)/apps/
	$(C_CPF) $(KDE_SRC)/config/konsole*rc $(KDE_DST)/config/
	
klipper: path-kde
	$(C_CPF) $(KDE_SRC)/config/klipperrc $(KDE_DST)/config/
	
color-scheme: path-kde
	$(C_SYNC) $(KDE_SRC)/apps/color-schemes $(KDE_DST)/apps/


kile: kate
	#$(C_SYNC) $(KDE_SRC)/apps/kile $(KDE_DST)/apps/
	$(C_CPF) $(KDE_SRC)/config/kilerc $(KDE_DST)/config/

okular: path-kde
	mkdir -p $(KDE_DST)/apps/okular
	$(C_CPF) $(KDE_SRC)/apps/okular/part.rc $(KDE_DST)/apps/okular
	$(C_CPF) $(KDE_SRC)/apps/okular/bookmarks.xml $(KDE_DST)/apps/okular
	$(C_CPF) $(KDE_SRC)/config/okular*rc $(KDE_DST)/config/

ksysguard: path-kde
	$(C_SYNC) $(KDE_SRC)/apps/ksysguard $(KDE_DST)/apps/
	$(C_CPF) $(KDE_SRC)/config/ksysguardrc $(KDE_DST)/config/
	$(C_SYNC) $(LOCAL_SRC)/ksysguard $(LOCAL_DST)/
	
baloo: path-kde
	$(C_CPF) $(KDE_SRC)/config/baloo*rc $(KDE_DST)/config/
	
	
breeze: path-kde
	$(C_CPF) $(KDE_SRC)/config/breezerc $(KDE_DST)/config/
	
shortcut: path-kde
	$(C_CPF) $(KDE_SRC)/config/kglobalshortcutsrc $(KDE_DST)/config/
	$(C_CPF) $(KDE_SRC)/config/khotkeysrc $(KDE_DST)/config/
	
	
ksnapshot: path-kde
	$(C_CPF) $(KDE_SRC)/config/ksnapshotrc $(KDE_DST)/config/
	
kwin: path-kde
	$(C_CPF) $(KDE_SRC)/config/kwin*rc $(KDE_DST)/config/
	
akonadi: path-kde
	$(C_CPF) $(KDE_SRC)/config/akonadi*rc $(KDE_DST)/config/
	
kdevelop: path-kde
	$(C_CPF) $(KDE_SRC)/config/kdev*rc $(KDE_DST)/config/
	$(C_SYNC) $(KDE_SRC)/apps/kdev* $(KDE_DST)/apps/
	
gwenview: path-kde
	mkdir -p $(KDE_DST)/apps/gwenview
	$(C_SYNC) $(KDE_SRC)/apps/gwenview/gwenviewui.rc $(KDE_DST)/apps/gwenview/
	$(C_CPF) $(KDE_SRC)/config/gwenviewrc $(KDE_DST)/config/
	
kxsaver: path-kde
	$(C_CPF) $(KDE_SRC)/config/kscreensaverrc $(KDE_DST)/config/
	for xss in `grep --directories=skip -lE \
	'^\[speed\]$$|^\[showfps\]$$' /home/macrobull/.kde4/share/config/*` ; \
	do \
		$(C_CPF) "$$xss" $(KDE_DST)/config/ ; \
	done
	
desktop-widgets: path-kde
	$(C_CPF) $(KDE_SRC)/config/kickoffrc $(KDE_DST)/config/
# 	$(C_CPF) $(KDE_SRC)/config/milourc $(KDE_DST)/config/
	
###################sys_public#####################
	
	
	
sys_public: hosts snapper zypper tlp xdg thinkpad udev-rules profiles \
#       pam.d
	echo 'SYS_PUBLIC DONE'
	
hosts: path-etc
	$(C_CPF) /etc/hosts $(ETC_DST)/
	
	
snapper: path-etc
	$(C_SYNC) /etc/snapper $(ETC_DST)/
	
zypper: path-etc
	$(C_SYNC) /etc/zypp $(ETC_DST)/
	
tlp: path-etc
	$(C_SYNC) /etc/default/tlp* $(ETC_DST)/default/
	
grub: path-etc
	$(C_SYNC) /etc/default/grub* $(ETC_DST)/default/
	
xdg: path-etc
	$(C_SYNC) /etc/xdg/autostart $(ETC_DST)/xdg/
	$(C_SYNC) /etc/xdg/systemd $(ETC_DST)/xdg/
	
thinkpad: path-etc
	$(C_SYNC) /etc/modprobe.d $(ETC_DST)/
# 	mkdir -p $(ETC_DST)/default
# 	cp /etc/default/tlp $(ETC_DST)/
	mkdir -p $(ETC_DST)/init.d/
	cp /etc/init.d/after.local $(ETC_DST)/
# 	$(C_SYNC) /etc/thermald $(ETC_DST)/
	
udev-rules: path-etc
	mkdir -p $(ETC_DST)/udev/
	$(C_SYNC) /etc/udev/rules.d $(ETC_DST)/
	
profiles: path-etc
	mkdir -p $(ETC_DST)/profile.d/
	cp /etc/profile.d/alias.bash $(ETC_DST)/profile.d/
	
	
	
#################app_public######################

app_public: gtk htop matplotlib qtcurve mpv spyder \
	git bin desktop_apps conky photoqt autostart \
	flacon vlc
# 	klatexformula wireshark \
#  clementine smplayer
	echo 'APP_PUBLIC DONE'

gtk: path-config
	$(C_SYNC) $(CONFIG_SRC)/gtk-3.0 $(CONFIG_DST)/
	
htop: path-config
	$(C_SYNC) $(CONFIG_SRC)/htop $(CONFIG_DST)/
	
matplotlib: path-config
	$(C_SYNC) $(CONFIG_SRC)/matplotlib $(CONFIG_DST)/
	
qtcurve: path-config
	$(C_SYNC) $(CONFIG_SRC)/qtcurve $(CONFIG_DST)/
	
vlc: path-config
	$(C_SYNC) $(CONFIG_SRC)/vlc $(CONFIG_DST)/
	
zim: path-config
	$(C_SYNC) $(CONFIG_SRC)/zim $(CONFIG_DST)/
	
clementine: path-config
	mkdir -p $(CONFIG_DST)/Clementine
	$(C_SYNC) $(CONFIG_SRC)/Clementine/Clementine.conf $(CONFIG_DST)/Clementine/
	
mpv:
	$(C_SYNC) ~/.mpv app/

smplayer: path-config
	mkdir -p $(CONFIG_DST)/smplayer
	$(C_CPR) $(CONFIG_SRC)/smplayer/* $(CONFIG_DST)/smplayer/
	
spyder:
	$(C_SYNC) ~/.spyder* app/
	
git:
	$(C_CPR) ~/.gitconfig app/
	
autostart:
	$(C_SYNC) ~/Application/Autostart app/
	
bin:
	$(C_SYNC) ~/Application/bin app/
# 	$(C_CPR) ~/Application/bin app/
	
desktop_apps: # MIME apps here!
	$(C_SYNC) ~/Application/applications app/
	
conky:
	$(C_CPR) ~/.conky* app/

photoqt:
	$(C_CPR) ~/.photoqt app/
	
pulseaudio:
	mkdir -p app/pulseaudio
	$(C_CPR) ~/.pulse/presets app/pulseaudio/
	
	
qt: path-config
	$(C_CPR) $(CONFIG_SRC)/Qt $(CONFIG_DST)/
# 	$(C_CPF) $(CONFIG_SRC)/Qt{Creatorrc,Project.conf,QmlViewerrc} $(CONFIG_DST)/
	$(C_SYNC) $(CONFIG_SRC)/QtProject $(CONFIG_DST)/
	
#gradle:

klatexformula:
	$(C_SYNC) ~/.klatexformula app/
	
wireshark:
	$(C_SYNC) ~/.wireshark app/


flacon:
	$(C_SYNC) $(CONFIG_SRC)/flacon $(CONFIG_DST)/
	

#################shell######################

shell: bash zsh
	echo 'SHELL DONE'

envi: path-shell
	$(C_CPF) ~/.paths shell/
	$(C_CPF) ~/.alias shell/
	$(C_CPF) ~/.envs shell/
	$(C_CPF) ~/.ccconfig shell/
	$(C_CPF) ~/workspace/lib-macrobull/python/pythonenv shell/

bash: envi
	$(C_CPF) ~/.bashrc shell/

zsh: envi
	$(C_CPF) ~/.zshrc shell/
	

bash-build: path-shell
	-$(C_CPF) ~build/.bashrc shell/.bashrc-build
	
################sys_private#################

sys_private: fstab bin
	echo 'SYS_PRIVATE DONE'

fstab: path-etc
	$(C_CPR) /etc/fstab $(ETC_DST)/fstab

# bin:
# 	$(C_SYNC) ~/Application/bin app/
# 	$(C_CPR) ~/Application/bin app/
################app_private#################

app_private: myjar matlab \
	android fcitx
# 	eric mendeley xbmc app-man
	echo 'APP_PRIVATE DONE'

android:
	$(C_SYNC) ~/.android app/
	mkdir app/.AndroidStudio
	$(C_SYNC) ~/.AndroidStudio*/config app/.AndroidStudio/

fcitx:
	$(C_SYNC) $(CONFIG_SRC)/fcitx $(CONFIG_DST)/

	
mendeley: path-config
	$(C_SYNC) $(CONFIG_SRC)/Mendeley\ Ltd. $(CONFIG_DST)/
	
myjar:
	$(C_SYNC) ~/.myjar app/

xbmc:
	$(C_SYNC) ~/.xbmc app/
	
matlab:
	$(C_SYNC) ~/.matlab app/
	
eric: path-config
	$(C_CPR) $(CONFIG_SRC)/Eric6 $(CONFIG_DST)/
	$(C_SYNC) ~/.eric6 app/
	
app-man:
	$(C_CPR) ~/Application/AppManagers app/

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Meta ebuild for LXQt, the Lightweight Desktop Environment"
HOMEPAGE="http://lxqt.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="+about +admin +branding compton +filemanager +gtkstyle +icons -sddm +lximage minimal +oxygen +policykit
	+powermanagement +ssh-askpass sudo +lightdm"
REQUIRED_USE="oxygen? ( icons )"
DEPEND="!lxqt-base/lxqt-common"

RDEPEND="${DEPEND}
	>=lxde-base/lxmenu-data-0.1.2
	>=lxde-base/lxappearance-0.5.5
	~lxqt-base/lxqt-themes-${PV}
	~lxqt-base/lxqt-config-${PV}
	~lxqt-base/lxqt-globalkeys-${PV}
	~lxqt-base/lxqt-notificationd-${PV}
	~lxqt-base/lxqt-panel-${PV}
	~lxqt-base/lxqt-runner-${PV}
	~lxqt-base/lxqt-session-${PV}
	~lxqt-base/lxqt-l10n-${PV}
	virtual/ttf-fonts
	about? ( ~lxqt-base/lxqt-about-${PV} )
	admin? ( ~lxqt-base/lxqt-admin-${PV} )
	branding? ( x11-themes/argent-theme-lxqt )
	compton? ( x11-misc/compton x11-misc/compton-conf )
	filemanager? ( >=x11-misc/pcmanfm-qt-${PV} )
	gtkstyle? ( dev-qt/qt5-styleplugins )
	icons? ( oxygen? ( kde-frameworks/oxygen-icons )
		!oxygen? ( virtual/freedesktop-icon-theme ) )
	sddm? ( x11-misc/sddm )
	lightdm? ( x11-misc/lightdm )
	lximage? ( media-gfx/lximage-qt )
	!minimal? ( x11-wm/openbox
		x11-misc/obconf-qt )
	policykit? ( ~lxqt-base/lxqt-policykit-${PV}
		|| ( sys-auth/consolekit[policykit(-)]
			sys-apps/systemd[policykit(-)] ) )
	powermanagement? ( ~lxqt-base/lxqt-powermanagement-${PV} )
	ssh-askpass? ( ~lxqt-base/lxqt-openssh-askpass-${PV} )
	sudo? ( ~lxqt-base/lxqt-sudo-${PV} )"

S="${WORKDIR}"

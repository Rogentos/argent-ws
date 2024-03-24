# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2-utils xdg-utils readme.gentoo-r1

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/pycharm/"
SRC_URI="http://download.jetbrains.com/python/${P}.tar.gz"

LICENSE="PyCharm_Academic PyCharm_Classroom PyCharm PyCharm_OpenSource PyCharm_Preview"
SLOT="0/2018.3"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| ( dev-java/icedtea-bin:8
		dev-java/icedtea:8
		dev-java/oracle-jdk-bin:1.8 )
		dev-python/pip"
DEPEND=""

RESTRICT="mirror strip stripdebug"

QA_PREBUILT="opt/${PN}/bin/fsnotifier
	opt/${PN}/bin/fsnotifier64
	opt/${PN}/bin/fsnotifier-arm
	opt/${PN}/bin/libyjpagent-linux.so
	opt/${PN}/bin/libyjpagent-linux64.so"

MY_PN=${PN/-professional/}
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	rm -rf jre || die
}

src_install() {
	insinto "/opt/${PN}"
	doins -r *

	fperms a+x "/opt/${PN}"/bin/{pycharm.sh,fsnotifier{,64},inspect.sh}

	dosym "../../opt/${PN}/bin/pycharm.sh" /usr/bin/"${PN}"
	newicon "bin/${MY_PN}.png" "${PN}".png
	make_desktop_entry "${PN}" "${PN}" "${PN}"

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

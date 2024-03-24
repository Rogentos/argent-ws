# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit  xdg-utils gnome2-utils

SRC_URI="http://download.jetbrains.com/go/${P}.tar.gz"
DESCRIPTION="Golang IDE by JetBrains"
HOMEPAGE="http://www.jetbrains.com/go"
SLOT=181
KEYWORDS="amd64"
LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

QA_PREBUILT="opt/${P}/*"
RESTRICT="strip mirror"

S=${WORKDIR}/GoLand-${PV}

RDEPEND="dev-lang/go"

src_prepare() {
	default
	if ! use arm; then
		rm -rf bin/fsnotifier-arm || die
	fi
	epatch "${FILESDIR}"/${PN}-173.patch
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{${PN}.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "Goland" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}

pkg_postinst() {
    xdg_desktop_database_update
    gnome2_icon_cache_update
}

pkg_postrm() {
    xdg_desktop_database_update
    gnome2_icon_cache_update
}

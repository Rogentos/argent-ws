# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit  xdg-utils gnome2-utils ver_*

MY_PN="GoLand"
if [[ $(get_version_component_range 3) == "0" ]] ; then
	SRC_URI="https://download-cf.jetbrains.com/go/${PN}-$(get_version_component_range 1-2).tar.gz"
else
	SRC_URI="https://download-cf.jetbrains.com/go/${PN}-$(get_version_component_range 1-3).tar.gz"
fi
DESCRIPTION="Golang IDE by JetBrains"
HOMEPAGE="http://www.jetbrains.com/go"
SLOT="0/2018.3"
KEYWORDS="amd64"
LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

QA_PREBUILT="opt/${P}/*"
RESTRICT="strip mirror"

if [[ $(get_version_component_range 3) == "0" ]] ; then
	S="${WORKDIR}/GoLand-$(get_version_component_range 1-2)/"
else
	S="${WORKDIR}/GoLand-$(get_version_component_range 1-3)/"
fi

RDEPEND="dev-lang/go
		|| ( dev-java/icedtea-bin:8
			dev-java/icedtea:8
			dev-java/oracle-jdk-bin:1.8
			dev-java/zulu-jdk-bin:8 )
		!=dev-util/goland-182.3684.99"

src_prepare() {
	default
	if ! use arm; then
		rm -rf bin/fsnotifier-arm || die
	fi
	epatch "${FILESDIR}"/${PN}-2019.2.patch
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

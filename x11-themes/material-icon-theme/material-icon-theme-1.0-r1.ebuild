# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit  git-r3 xdg-utils gnome2-utils

DESCRIPTION="Icon theme following the Google's material design specifications"
HOMEPAGE="https://gitlab.com/bionel/bionel-icons"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://gitlab.com/bionel/bionel-icons.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_install() {
	rm "${S}"/material-icons/material-design-darkyellow/scalable/places/start-here.svg || exit 1
	dodir usr/share/icons
	insinto usr/share/icons
	doins -r material-icons/*
	insinto usr/share/icons/material-design-darkyellow/scalable/places/
	doins "${FILESDIR}"/start-here.svg
}

pkg_postinst() {
    gnome2_icon_cache_update
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

pkg_postrm() {
    gnome2_icon_cache_update
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

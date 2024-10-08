# Copyright 1999-2012 Sabayon
# Copyright 2012-2015 Argent
# Distributed under the terms of the GNU General Public License v2
# Header: $

EAPI="7"

inherit gnome2-utils

DESCRIPTION="Argent Linux Official GNOME artwork"
HOMEPAGE="http://www.rogentos.ro"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/"${PN}"-${PV}.tar.gz
	mirror://argent/${CATEGORY}/"${PN}"/${P}.tar.gz"


LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
RDEPEND=">=x11-themes/argent-artwork-core-2
	x11-themes/argent-light-theme
	x11-themes/argent-dark-theme
	x11-themes/faenza-kupertino-icons"

S="${WORKDIR}/"

src_install() {
#	dodir /usr/share/themes

	# GNOME & GTK Theme
#	cd "${S}"/gtk
#	dodir /usr/share/themes
#	insinto /usr/share/themes
#	doins -r ./*

	# Metacity
#	cd "${S}"/metacity
#	insinto /usr/share/themes
#	doins -r ./*

	# GNOME 3 config settings
	dodir /usr/share/glib-2.0/schemas
	insinto /usr/share/glib-2.0/schemas
	doins "${FILESDIR}/org.argent.gschema.override"

	# Add GNOME 3 backgrounds
	dodir /usr/share/gnome-background-properties
	insinto /usr/share/gnome-background-properties || die "/usr/share/gnome-background-properties not found"
	doins "${FILESDIR}/gnome-backgrounds.xml"

	# GDM 3.6+ logo stuff
	cd "${S}/gdm"
	dodir /usr/share/argent/gdm
	insinto /usr/share/argent/gdm
	doins logo.svg
	insinto /usr/share/glib-2.0/schemas
	doins org.gnome.login-screen.gschema.override
}

pkg_preinst() {
	# taken from gnome2_schemas_savelist
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &>/dev/null || die
	export GNOME2_ECLASS_GLIB_SCHEMAS="/usr/share/glib-2.0/schemas/org.argent.gschema.override"
	popd &>/dev/null || die
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update --uninstall
}

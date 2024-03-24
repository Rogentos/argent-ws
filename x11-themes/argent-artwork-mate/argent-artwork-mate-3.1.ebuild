# Copyright 1999-2012 Sabayon
# Copyright 2012-2015 Argent
# Distributed under the terms of the GNU General Public License v2
# Header: $

EAPI="7"

inherit gnome2-utils

DESCRIPTION="Argent Linux Official MATE artwork"
HOMEPAGE="http://rogentos.ro/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}/"

src_install() {
	# Doing overrides. Because we can!
	dodir /usr/share/glib-2.0/schemas
	insinto /usr/share/glib-2.0/schemas
	doins "${FILESDIR}/org.mate.argent.gschema.override"
}

pkg_preinst() {
	# taken from gnome2_schemas_savelist
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &>/dev/null
	export GNOME2_ECLASS_GLIB_SCHEMAS="/usr/share/glib-2.0/schemas/org.mate.argent.gschema.override"
	popd &>/dev/null
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update --uninstall
}

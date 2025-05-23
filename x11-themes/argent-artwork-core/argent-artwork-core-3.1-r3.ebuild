# Copyright 2011-2015 Argent Linux
# Distributed under the terms of the GNU General Public License v2
# Maintainer BlackNoxis <stefan.cristian at rogentos.ro>

EAPI="8"
inherit mount-boot argent-artwork

DESCRIPTION="Offical Argent-Linux Core Artwork"
HOMEPAGE="http://www.rogentos.ro"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/"${PN}"-${PV}.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~arm ~x86 ~amd64"
IUSE=""
RDEPEND=""

S="${WORKDIR}"/"${PN}"

src_install() {
	# Cursors
	insinto /usr/share/cursors/xorg-x11/
	doins -r "${S}"/mouse/RezoBlue

	# Wallpapers
	insinto /usr/share/backgrounds/
	doins -r "${S}"/background/nature

	# Logos
	insinto /usr/share/pixmaps/
	doins "${S}"/logo/*.png

	# Plymouth theme
	insinto /usr/share/plymouth
	doins "${S}"/plymouth/bizcom.png # back to our bizcom
	insinto /usr/share/plymouth/themes
	doins -r "${S}"/plymouth/themes/argent
	#insinto /usr/share/plymouth/
	#newins "${S}"/plymouth/themes/argent/argent-logo.png bizcom.png

	# Apply our tricks
	insinto /usr/share/cursors/xorg-x11
	dosym RezoBlue /usr/share/cursors/xorg-x11/default || "RezoBlue not found" #set default xcursor
}

pkg_postinst() {
	# mount boot first
	mount-boot_mount_boot_partition

	einfo "Please report bugs or glitches to"
	einfo "https://github.com/rogentos/argent-ws/issues"
}

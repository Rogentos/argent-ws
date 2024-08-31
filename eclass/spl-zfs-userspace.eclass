# Copyright 2004-2012 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2
# $

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit  flag-o-matic git-2 linux-mod autotools-utils

# export all the available functions here
EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install src_test

# @ECLASS-VARIABLE: ZFS_GIT_REPO
# @DESCRIPTION:
# Identified the ZFS Git repo from where to pull
ZFS_GIT_REPO="${ZFS_GIT_REPO:-}"

# @ECLASS-VARIABLE: ZFS_GIT_BRANCH
# @DESCRIPTION:
# Identified the ZFS Git branch from where to pull
ZFS_GIT_BRANCH="${ZFS_GIT_BRANCH:-}"

# @ECLASS-VARIABLE: ZFS_GIT_COMMIT
# @DESCRIPTION:
# Identified the ZFS Git commit from where to pull
ZFS_GIT_COMMIT="${ZFS_GIT_COMMIT:-}"

# @ECLASS-VARIABLE: SPL_GIT_REPO
# @DESCRIPTION:
# Identified the SPL Git repo from where to pull
SPL_GIT_REPO="${SPL_GIT_REPO:-}"

# @ECLASS-VARIABLE: SPL_GIT_BRANCH
# @DESCRIPTION:
# Identified the SPL Git branch from where to pull
SPL_GIT_BRANCH="${SPL_GIT_BRANCH:-}"

# @ECLASS-VARIABLE: SPL_GIT_COMMIT
# @DESCRIPTION:
# Identified the SPL Git commit from where to pull
SPL_GIT_COMMIT="${SPL_GIT_COMMIT:-}"

SRC_URI=""

DESCRIPTION="The Solaris Porting Layer and ZFS Filesystem userspace utilities"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="|| ( GPL-2 GPL-3 ) CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="custom-cflags debug dracut +rootfs test test-suite static-libs"
DEPEND+=" sys-apps/util-linux[static-libs?]
	sys-libs/zlib[static-libs(+)?]"
RDEPEND+=" ${DEPEND}
	!sys-fs/zfs-fuse
	!prefix? ( sys-fs/udev )
	test-suite? (
		sys-apps/gawk
		sys-apps/util-linux
		sys-devel/bc
		sys-block/parted
		sys-fs/lsscsi
		sys-fs/mdadm
		sys-process/procps
		virtual/modutils
		)
	rootfs? (
		app-arch/cpio
		app-misc/pax-utils
	)"
DEPEND+=" test? ( sys-fs/mdadm )"

SPL_S="${S}/spl-src"
ZFS_S="${S}/zfs-src"

spl-zfs-userspace_pkg_setup() {
	CONFIG_CHECK="
		!DEBUG_LOCK_ALLOC
		BLK_DEV_LOOP
		EFI_PARTITION
		MODULES
		KALLSYMS
		ZLIB_DEFLATE
		ZLIB_INFLATE"
	kernel_is ge 2 6 26 || die "Linux 2.6.26 or newer required"
	check_extra_config
}

spl-zfs-userspace_src_unpack() {
	# unpack spl
	EGIT_REPO_URI="${SPL_GIT_REPO}" \
	EGIT_BRANCH="${SPL_GIT_BRANCH}" \
	EGIT_COMMIT="${SPL_GIT_COMMIT}" \
	EGIT_SOURCEDIR="${SPL_S}" \
		git-2_src_unpack

	# unpack zfs
	EGIT_REPO_URI="${ZFS_GIT_REPO}" \
	EGIT_BRANCH="${ZFS_GIT_BRANCH}" \
	EGIT_COMMIT="${ZFS_GIT_COMMIT}" \
	EGIT_SOURCEDIR="${ZFS_S}" \
		git-2_src_unpack
}

_zfs_src_prepare() {
	# Workaround for hard coded path
	sed -i "s|/sbin/lsmod|/bin/lsmod|" "${ZFS_S}"/scripts/common.sh.in || die
	# Workaround rename
	sed -i "s|/usr/bin/scsi-rescan|/usr/sbin/rescan-scsi-bus|" "${ZFS_S}"/scripts/common.sh.in || die
	cd "${ZFS_S}" && ECONF_SOURCE="${ZFS_S}" autotools-utils_src_prepare
}

_spl_src_prepare() {
	# Workaround for hard coded path
	sed -i "s|/sbin/lsmod|/bin/lsmod|" "${SPL_S}"/scripts/check.sh || die
	cd "${SPL_S}" && ECONF_SOURCE="${SPL_S}" autotools-utils_src_prepare
}

spl-zfs-userspace_src_prepare() {
	_spl_src_prepare
	_zfs_src_prepare
}

_zfs_src_configure() {
	use custom-cflags || strip-flags
	set_arch_to_kernel

	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=user
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-udevdir="${EPREFIX}/lib/udev"
		$(use_enable debug)
		--with-spl="${SPL_S}"
	)
	cd "${ZFS_S}" && ECONF_SOURCE="${ZFS_S}" autotools-utils_src_configure
}

_spl_src_configure() {
	use custom-cflags || strip-flags
	set_arch_to_kernel

	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=all
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)
		--with-config=user
	)
	cd "${SPL_S}" && ECONF_SOURCE="${SPL_S}" autotools-utils_src_configure
}

spl-zfs-userspace_src_configure() {
	_spl_src_configure
	_zfs_src_configure
}

_zfs_src_compile() {
	cd "${ZFS_S}" && ECONF_SOURCE="${ZFS_S}" autotools-utils_src_compile
}

_spl_src_compile() {
	cd "${SPL_S}" && ECONF_SOURCE="${SPL_S}" autotools-utils_src_compile
}

spl-zfs-userspace_src_compile() {
	_spl_src_compile
	_zfs_src_compile
}

_zfs_src_install() {
	cd "${ZFS_S}" && ECONF_SOURCE="${ZFS_S}" autotools-utils_src_install
	gen_usr_ldscript -a uutil nvpair zpool zfs
	use dracut || rm -rf "${ED}usr/share/dracut"
	use test-suite || rm -rf "${ED}usr/libexec"

	if use rootfs
	then
		doinitd "${FILESDIR}/zfs-shutdown"
		exeinto /usr/share/zfs
		doexe "${FILESDIR}/linuxrc"
	fi
}

_spl_src_install() {
	cd "${SPL_S}" && ECONF_SOURCE="${SPL_S}" autotools-utils_src_install
	rm -rf "${ED}"/usr # make sure
}

spl-zfs-userspace_src_install() {
	_spl_src_install
	_zfs_src_install
}

spl-zfs-userspace_src_test() {
	if [[ ! -e /proc/modules ]]
	then
		die  "Missing /proc/modules"
	elif [[ $UID -ne 0 ]]
	then
		ewarn "Cannot run make check tests with FEATURES=userpriv."
		ewarn "Skipping make check tests."
	elif grep -q '^spl ' /proc/modules
	then
		ewarn "Cannot run make check tests with module spl loaded."
		ewarn "Skipping make check tests."
	else
		cd "${SPL_S}" && ECONF_SOURCE="${SPL_S}" autotools-utils_src_test
		cd "${ZFS_S}" && ECONF_SOURCE="${ZFS_S}" autotools-utils_src_test
	fi
}


# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Golang IDE by JetBrains"
HOMEPAGE="https://www.jetbrains.com/go/"
SRC_URI="
	amd64? ( https://download.jetbrains.com/go/${P}.tar.gz )
	arm64? ( https://download.jetbrains.com/go/${P}-aarch64.tar.gz )
"
S="${WORKDIR}/GoLand-${PV}"
LICENSE="|| ( JetBrains-business JetBrains-classroom JetBrains-educational JetBrains-individual )
	Apache-2.0
	BSD
	CC0-1.0
	CDDL
	CDDL-1.1
	EPL-1.0
	GPL-2
	GPL-2-with-classpath-exception
	ISC
	LGPL-2.1
	LGPL-3
	MIT
	MPL-1.1
	OFL-1.1
	ZLIB
"
IUSE="bundled-xvfb"
SLOT="0/2024"
KEYWORDS="~amd64 ~arm64"

RESTRICT="bindist mirror"
QA_PREBUILT="opt/${P}/*"

BDEPEND="
	dev-util/debugedit
	dev-util/patchelf
"
RDEPEND="
	>=virtual/jre-17:*
	dev-lang/go
	dev-libs/wayland
	sys-libs/pam
	sys-process/audit
"

src_prepare() {
	default

	local remove_me=(
		lib/async-profiler/aarch64
		plugins/go-plugin/lib/dlv/linuxarm/dlv
	)

	rm -rv "${remove_me[@]}" || die

	# removing debug symbols and relocating debug files as per #876295
	# we're escaping all the files that contain $() in their name
	# as they should not be executed
	find . -type f ! -regex '.*\$\([^)]+\).*' -exec sh -c '
		if file "{}" | grep -qE "ELF (32|64)-bit"; then
			objcopy --remove-section .note.gnu.build-id "{}"
			debugedit -b "${EPREFIX}/opt/${PN}" -d "/usr/lib/debug" -i "{}"
		fi
	' \;

		if use bundled-xvfb; then
			patchelf --set-rpath '$ORIGIN/../lib' "${S}"/plugins/remote-dev-server/selfcontained/bin/{Xvfb,xkbcomp} || die
			patchelf --set-rpath '$ORIGIN' "${S}"/plugins/remote-dev-server/selfcontained/lib/lib*.so* || die
		else
			rm -vr "${S}"/plugins/remote-dev-server/selfcontained || die
			sed '/export REMOTE_DEV_SERVER_IS_NATIVE_LAUNCHER/a export REMOTE_DEV_SERVER_USE_SELF_CONTAINED_LIBS=1' \
			  -i bin/remote-dev-server.sh || die
		fi

	patchelf --set-rpath '$ORIGIN' "jbr/lib/libjcef.so" || die
	patchelf --set-rpath '$ORIGIN' "jbr/lib/jcef_helper" || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,goland.sh,inspect.sh,ltedit.sh,remote-dev-server.sh,restarter,fsnotifier}
	fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}
	fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
	fperms 755 "${dir}"/plugins/go-plugin/lib/dlv/linux/dlv

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "Goland ${PV}" "${PN}" "Development;IDE;"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
			# This is a new installation, so:
			echo
			elog "It is strongly recommended to increase the inotify watch limit"
			elog "to at least 524288. You can achieve this e.g. by calling"
			elog "echo \"fs.inotify.max_user_watches = 524288\" > /etc/sysctl.d/30-idea-inotify-watches.conf"
			elog "and reloading with \"sysctl --system\" (and restarting the IDE)."
			elog "For details see:"
			elog "    https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit"
	fi

	local replacing_version
	for replacing_version in ${REPLACING_VERSIONS} ; do
		if ver_test "${replacing_version}" -lt "2019.3-r1"; then
			# This revbump requires user interaction.
			echo
			ewarn "Previous versions configured fs.inotify.max_user_watches without user interaction."
			ewarn "Since version 2019.3-r1 you need to do so manually, e.g. by calling"
			ewarn "echo \"fs.inotify.max_user_watches = 524288\" > /etc/sysctl.d/30-idea-inotify-watches.conf"
			ewarn "and reloading with \"sysctl --system\" (and restarting the IDE)."
			ewarn "For details see:"
			ewarn "    https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit"

			# Show this ewarn only once
			break
		fi
	done
}

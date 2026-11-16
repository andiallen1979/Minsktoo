# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} )
inherit desktop distutils-r1

DESCRIPTION="Portage per-package configurator with ncurses TUI and Qt6/GTK3/GTK4 GUIs"
HOMEPAGE="https://codeberg.org"
S="${WORKDIR}/${P}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+gui gtk3 gtk4 qt6"

RDEPEND="
	app-portage/genlop
	sys-apps/portage[${PYTHON_USEDEP}]
	gui? (
		gtk3? ( dev-python/pygobject[${PYTHON_USEDEP}] x11-libs/gtk+:3[introspection] )
		gtk4? ( dev-python/pygobject[${PYTHON_USEDEP}] gui-libs/gtk:4[introspection] )
		qt6? ( dev-python/pyqt6[gui,widgets,${PYTHON_USEDEP}] kde-apps/konsole )
	)
"

src_unpack() {
	mkdir -p "${S}" && tar -xJf "${FILESDIR}/minsktoocfg-core-${PV}.tar.xz" -C "${S}" || die
	tar -xJf "${FILESDIR}/minsktoocfg-gui-${PV}.tar.xz" -C "${S}" || die
	if ! use gui || ! use qt6; then rm -rf "${S}/minsktoocfg_qt6" "${S}/minsktoocfg-qt6.desktop" || die; fi
	if ! use gui || { ! use gtk3 && ! use gtk4; }; then rm -rf "${S}/minsktoocfg_gtk" || die; fi
	if ! use gui || ! use gtk3; then rm -f "${S}/minsktoocfg-gtk3.desktop" || die; fi
	if ! use gui || ! use gtk4; then rm -f "${S}/minsktoocfg-gtk4.desktop" || die; fi
}

python_install_all() {
	distutils-r1_python_install_all
	if use gui; then
		use qt6 && domenu "${S}/minsktoocfg-qt6.desktop"
		use gtk3 && domenu "${S}/minsktoocfg-gtk3.desktop"
		use gtk4 && domenu "${S}/minsktoocfg-gtk4.desktop"
	fi
}

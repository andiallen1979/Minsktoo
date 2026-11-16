# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="minsktoo Helper scripts"
HOMEPAGE="https://codeberg.org/andiallen1979/minsktoo"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	app-shells/bash
	sys-apps/portage
"

src_install() {
	dobin "${FILESDIR}/setpkgkw"
	dobin "${FILESDIR}/setpkgenv"
	dobin "${FILESDIR}/setpkguse"
	dobin "${FILESDIR}/setpkgmask"
	dobin "${FILESDIR}/cleanpkg"
	dobin "${FILESDIR}/mknbdimg"
	dobin "${FILESDIR}/minsktoo-repo-prep"
	dobin "${FILESDIR}/minsktoo-sync-configs"
	dobin "${FILESDIR}/minsktoo-push"
	dobin "${FILESDIR}/minsktoo-bump"
	dobin "${FILESDIR}/minsktoo-emptytree"
	dobin "${FILESDIR}/minsktoo-audit"
}

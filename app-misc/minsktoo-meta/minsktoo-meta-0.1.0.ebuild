EAPI=8
DESCRIPTION="Meta package for the minsktoo Gentoo overlay"
HOMEPAGE="https://codeberg.org{R}"
S="${WORKDIR}"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RDEPEND="
	app-misc/minsktoocfg
	app-portage/minsktoo-scripts
	sys-config/minsktoo-configs
	sys-kernel/minsktoo-kernel-config
"

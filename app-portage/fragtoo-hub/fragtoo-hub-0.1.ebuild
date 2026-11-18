EAPI=8
PYTHON_COMPAT=( python3_{12..15} )
inherit python-single-r1
DESCRIPTION="Community overlay registry and eselect connector for Gentoo"
HOMEPAGE="https://fragtoo.com"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS} app-eselect/eselect-repository"

src_install() {
	python_doscript "${FILESDIR}/fragtoo-hub"
}

EAPI=8
DESCRIPTION="Base arm64 Portage make.conf snippet for Minsktoo mobile builds"
HOMEPAGE="https://fragtoo.com"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"

src_install() {
	insinto /etc/portage/minsktoo
	doins "${FILESDIR}/make.conf.minsktoo"
}

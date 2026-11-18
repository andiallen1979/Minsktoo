EAPI=8
PYTHON_COMPAT=( python3_{12..15} )
inherit python-single-r1 systemd
DESCRIPTION="Boot-time A/B modem/DSP firmware mounter and boot.img packager for minsk"
HOMEPAGE="https://fragtoo.com"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS} sys-apps/util-linux"

src_install() {
	dosbin "${FILESDIR}/minsktoo-firmware-sync"
	python_doscript "${FILESDIR}/minsktoo-mkbootimg"
	systemd_dounit "${FILESDIR}/minsktoo-firmware-sync.service"
}

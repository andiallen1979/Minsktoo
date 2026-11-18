EAPI=8
DESCRIPTION="Kernel config fragments for Motorola Moto G Stylus 2021 (minsk / sm6150)"
HOMEPAGE="https://fragtoo.com"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	insinto /etc/kernel/config.d
	doins "${FILESDIR}/minsk-sm6150.config"
}

EAPI=8
inherit systemd
DESCRIPTION="Qualcomm TFTP over QRTR server for modem NV/firmware files"
HOMEPAGE="https://github.com/linux-msm/tqftpserv"
SRC_URI="https://github.com/linux-msm/tqftpserv/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"
DEPEND="net-libs/qrtr"
RDEPEND="${DEPEND}"
src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" systemdunitdir="$(systemd_get_systemunitdir)" install
}

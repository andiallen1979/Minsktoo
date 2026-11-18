EAPI=8
inherit systemd
DESCRIPTION="Qualcomm Protection Domain mapper service for remoteproc DSPs"
HOMEPAGE="https://github.com/linux-msm/pd-mapper"
SRC_URI="https://github.com/linux-msm/pd-mapper/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"
DEPEND="net-libs/qrtr"
RDEPEND="${DEPEND}"
src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" systemdunitdir="$(systemd_get_systemunitdir)" install
}

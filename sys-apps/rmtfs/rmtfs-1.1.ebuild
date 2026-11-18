EAPI=8
inherit systemd
DESCRIPTION="Qualcomm Remote Filesystem Service (EFS sync for modem DSP)"
HOMEPAGE="https://github.com/linux-msm/rmtfs"
SRC_URI="https://github.com/linux-msm/rmtfs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"
DEPEND="net-libs/qrtr virtual/libudev"
RDEPEND="${DEPEND}"
src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" systemdunitdir="$(systemd_get_systemunitdir)" install
}

EAPI=8
inherit meson systemd
DESCRIPTION="Qualcomm IPC Router (QRTR) userspace daemon and library"
HOMEPAGE="https://github.com/linux-msm/qrtr"
SRC_URI="https://github.com/linux-msm/qrtr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"
src_install() {
	meson_src_install
}

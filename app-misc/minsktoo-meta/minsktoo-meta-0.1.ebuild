EAPI=8
DESCRIPTION="Meta-package for Minsktoo arm64 Plasma Mobile and Qualcomm radio stack"
HOMEPAGE="https://fragtoo.com"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+conf +hub +kconf +mkernel +plasma +radios"
RDEPEND="
	conf? ( sys-config/minsktoo-configs )
	hub? ( app-portage/fragtoo-hub )
	kconf? ( sys-kernel/minsktoo-kernel-config )
	mkernel? ( sys-kernel/minsktoo-kernel )
	plasma? (
		kde-plasma/plasma-meta
		media-video/pipewire
		media-video/wireplumber
	)
	radios? (
		net-libs/libqmi
		net-libs/qrtr
		net-misc/modemmanager
		net-misc/networkmanager
		net-misc/tqftpserv
		sys-apps/pd-mapper
		sys-apps/rmtfs
		sys-kernel/linux-firmware
	)
"

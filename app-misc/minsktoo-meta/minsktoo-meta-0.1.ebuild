EAPI=8
DESCRIPTION="Meta-package for Minsktoo arm64 Gentoo configuration and utilities"
HOMEPAGE="https://fragtoo.com"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+conf +hub +kconf +mkernel"
RDEPEND="
	conf? ( sys-config/minsktoo-configs )
	hub? ( app-portage/fragtoo-hub )
	kconf? ( sys-kernel/minsktoo-kernel-config )
	mkernel? ( sys-kernel/minsktoo-kernel )
"

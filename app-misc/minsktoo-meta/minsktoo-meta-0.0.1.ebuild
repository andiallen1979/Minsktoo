# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
DESCRIPTION="Meta-package for minsktoo Motorola arm64 Plasma Mobile configuration and utilities"
HOMEPAGE="https://fragtoo.com"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+bootcfg +conf +kconf +scripts menu"
RDEPEND="
	bootcfg? ( sys-boot/gentool-bootcfg )
	menu? ( app-misc/gentool-menu )
	conf? ( sys-config/minsktoo-configs )
	kconf? ( sys-kernel/minsktoo-kernel-config )
	scripts? ( app-portage/gentool-scripts )
"

EAPI=8
PYTHON_COMPAT=( python3_{12..15} )
KERNEL_IUSE_GENERIC_UKI=1
inherit kernel-build

DESCRIPTION="Vanilla Linux + Gentoo genpatches + Motorola minsk (sm6150) arm64 dist-kernel"
HOMEPAGE="https://fragtoo.com"
SRC_URI="
	https://kernel.org/pub/linux/kernel/v7.x/linux-$(ver_cut 1-2).tar.xz
	https://kernel.org/pub/linux/kernel/v7.x/patch-${PV}.xz
	https://gentoo.org/pub/proj/dist-kernel/patchsets/$(ver_cut 1-2)/linux-gentoo-patches-${PV}.tar.xz
	https://gentoo.org/proj/dist-kernel/gentoo-kernel-config.git/snapshot/gentoo-kernel-config-g19.tar.bz2
	https://gentoo.org/pub/proj/dist-kernel/config/fedora-kernel-config-${PV}-gentoo.tar.xz
"
S="${WORKDIR}/linux-7.3"
LICENSE="GPL-2"
KEYWORDS="~arm64"
IUSE="debug"

src_unpack() {
	unpack linux-$(ver_cut 1-2).tar.xz patch-${PV}.xz linux-gentoo-patches-${PV}.tar.xz \
		gentoo-kernel-config-g19.tar.bz2 fedora-kernel-config-${PV}-gentoo.tar.xz
}

src_prepare() {
	eapply "${WORKDIR}/patch-${PV}"
	eapply "${WORKDIR}/linux-gentoo-patches-${PV}"
	cp "${FILESDIR}/talos-motorola-minsk.dts" arch/arm64/boot/dts/qcom/ || die
	echo "dtb-\$(CONFIG_ARCH_QCOM) += talos-motorola-minsk.dtb" >> arch/arm64/boot/dts/qcom/Makefile || die
	default
}

src_configure() {
	cp "${WORKDIR}/fedora-kernel-config-${PV}-gentoo/kernel-aarch64-fedora.config" .config || die
	echo "CONFIG_LOCALVERSION=\"-minsktoo-dist\"" > "${T}/version.config" || die
	local d="${WORKDIR}/gentoo-kernel-config-g19"
	local cfgs=(
		"${T}/version.config" "${d}/base.config" "${d}/6.12+.config"
		"${FILESDIR}/minsk-sm6150.config"
	)
	use debug || cfgs+=( "${d}/no-debug.config" )
	kernel-build_merge_configs "${cfgs[@]}"
	kernel-build_src_configure
}

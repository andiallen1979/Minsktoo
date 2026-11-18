EAPI=8
inherit toolchain-funcs
DESCRIPTION="Purple/silver touch recovery UI and Ed25519 signed image flasher for minsk"
HOMEPAGE="https://fragtoo.com"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RDEPEND="dev-libs/openssl sys-apps/coreutils sys-fs/e2fsprogs"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${FILESDIR}/minsktoo-recovery-ui.c" -o minsktoo-recovery-ui || die
}

src_install() {
	dobin "${FILESDIR}/minsktoo-sign"
	dosbin "${FILESDIR}/minsktoo-recover" "${FILESDIR}/minsktoo-build-rootfs" minsktoo-recovery-ui
	keepdir /etc/minsktoo/keys
}

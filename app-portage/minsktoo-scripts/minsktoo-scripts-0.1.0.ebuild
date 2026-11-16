EAPI=8
DESCRIPTION="Repository maintenance and push scripts for minsktoo"
HOMEPAGE="https://codeberg.org{R}"
S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	mkdir -p "${T}/bin" && tar -xJf "${FILESDIR}/minsktoo-scripts-bundle.tar.xz" -C "${T}/bin" || die
	dobin "${T}/bin"/*
}

EAPI=4

inherit base eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/a/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.03"

DESCRIPTION="Export GTK menus over DBus"
HOMEPAGE="https://launchpad.net/appmenu-gtk"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/indicator-appmenu
	x11-libs/gtk+:2
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	./autogen.sh
	make distclean
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static \
		--with-gtk2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static || die
	popd
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
	emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
	emake || die
	popd
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
	emake DESTDIR="${D}" install || die
	popd

	# Install GTK3 support #
	pushd build-gtk3
	emake DESTDIR="${D}" install || die
	popd

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${D}etc/X11/Xsession.d/80appmenu"
	doexe "${D}etc/X11/Xsession.d/80appmenu-gtk3"

	rm -rvf "${D}etc/X11/Xsession.d"
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}

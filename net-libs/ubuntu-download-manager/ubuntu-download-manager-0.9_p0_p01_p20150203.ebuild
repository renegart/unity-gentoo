# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="vivid"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="A daemon that offers a DBus API to perform downloads"
HOMEPAGE="https://launchpad.net/ubuntu-download-manager"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="dev-cpp/glog
	dev-cpp/gmock
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtsystems:5
	sys-apps/dbus
	sys-libs/libnih"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
export QT_SELECT=5

src_prepare() {
	use test || \
		sed -e '/add_subdirectory(tests)/d' \
			-i CMakeLists.txt
	use doc || \
		sed -e '/add_subdirectory(docs)/d' \
			-i CMakeLists.txt
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_LIBEXECDIR=/usr/lib"
	cmake-utils_src_configure
}
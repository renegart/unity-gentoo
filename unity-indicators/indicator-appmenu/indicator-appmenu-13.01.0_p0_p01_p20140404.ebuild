# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="utopic"
inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+14.04.${PVR_MICRO}"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-appmenu"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-base/bamf:="
DEPEND="${RDEPEND}
	dev-libs/libappindicator
	dev-libs/libindicate-qt
	>=x11-libs/gtk+-3.5.12:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error
}

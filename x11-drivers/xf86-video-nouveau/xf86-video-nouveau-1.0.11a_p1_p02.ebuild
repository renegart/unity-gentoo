# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
XORG_DRI="always"

URELEASE="vivid"
inherit base xorg-2 ubuntu-versionator

MY_PV="${PV}"
MY_PN="xserver-xorg-video-nouveau"
UURL="mirror://ubuntu/pool/main/x/${MY_PN}"
UVER_SUFFIX="build1"

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}${UVER_SUFFIX}.diff.gz"

#KEYWORDS="amd64 ppc ~ppc64 ~x86"
IUSE="glamor mir"
RESTRICT="mirror strip"

RDEPEND=">=x11-libs/libdrm-2.4.34[video_cards_nouveau]
	x11-base/xorg-server[glamor?]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-glamor-automagic.patch
)

src_prepare() {
	if use mir; then
		epatch -p1 "${WORKDIR}/${MY_PN}_${MY_PV}-${UVER}.diff"  # This needs to be applied for the debian/ directory to be present #
		for patch in $(cat "${S}/debian/patches/series" | grep -v \# ); do
			PATCHES+=( "${S}/debian/patches/${patch}" )
		done
		base_src_prepare
	fi
}

src_configure() {
	XORG_CONFIGURE_OPTIONS="$(use_enable glamor)"
	xorg-2_src_configure
}

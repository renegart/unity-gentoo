# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python{3_3,3_4} )
VALA_MIN_API_VERSION="0.22"
VALA_MAX_API_VERSION="0.22"

URELEASE="vivid"
inherit autotools eutils flag-o-matic gnome2 python-r1 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Keyboard indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-keyboard"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="gnome-extra/gucharmap
	gnome-base/gnome-desktop:3="
DEPEND="${RDEPEND}
	app-i18n/ibus[vala]
	>=dev-libs/glib-2.37
	dev-libs/libappindicator
	dev-libs/libgee:0
	dev-libs/libdbusmenu
	gnome-base/dconf
	gnome-base/libgnomekbd
	sys-apps/accountsservice
	unity-base/bamf
	x11-libs/gtk+:3
	x11-libs/libxklavier
	x11-libs/pango
	x11-misc/lightdm
	$(vala_depend)
	${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	python_copy_sources
	configuration() {
		gnome2_src_configure
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation

	# Remove upstart jobs as we use XDG autostart desktop files to spawn indicators #
	rm -rf "${ED}usr/share/upstart"

	prune_libtool_files --modules
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

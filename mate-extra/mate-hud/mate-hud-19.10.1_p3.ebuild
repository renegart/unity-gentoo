# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_7,3_8} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="groovy"
inherit distutils-r1 eutils gnome2-utils ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="MATE menubar commands, like the Unity 7 Heads-Up Display (HUD)"
HOMEPAGE="https://github.com/ubuntu-mate/mate-hud"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Let people emerge this by default, bug #472932
IUSE+=" +python_single_target_python3_7 python_single_target_python3_8"
RESTRICT="mirror"

RDEPEND="$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_MULTI_USEDEP}]
		dev-python/setproctitle[${PYTHON_MULTI_USEDEP}]
	')
	dev-python/python-xlib
	unity-base/unity-gtk-module
	x11-libs/gtk+:3
	x11-misc/rofi
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare

	# Install Xsession file into correct Gentoo path #
	sed -e 's:/etc/X11/Xsession.d:/etc/X11/xinit/xinitrc.d:g' \
		-i setup.py
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}

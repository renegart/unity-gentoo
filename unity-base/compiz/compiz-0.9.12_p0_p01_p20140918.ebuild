# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

URELEASE="utopic"
inherit base gnome2 cmake-utils eutils python-r1 ubuntu-versionator xdummy

UURL="mirror://ubuntu/pool/main/c/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Compiz Fusion OpenGL window and compositing manager patched for the Unity desktop"
HOMEPAGE="https://launchpad.net/compiz"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+debug kde test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

COMMONDEPEND="!!x11-wm/compiz
	!!x11-libs/compiz-bcop
	!!x11-libs/libcompizconfig
	!!x11-plugins/compiz-plugins-main
	dev-libs/boost:=[${PYTHON_USEDEP}]
	dev-libs/glib:2[${PYTHON_USEDEP}]
	dev-cpp/glibmm
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-libs/libxslt[${PYTHON_USEDEP}]
	dev-libs/protobuf[${PYTHON_USEDEP}]
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-python/pyrex[${PYTHON_USEDEP}]
	gnome-base/gconf[${PYTHON_USEDEP}]
	>=gnome-base/gsettings-desktop-schemas-3.8
	>=gnome-base/librsvg-2.14.0:2
	media-libs/glew
	media-libs/libpng:0=
	media-libs/mesa[gallium,llvm]
	x11-base/xorg-server[dmx]
	>=x11-libs/cairo-1.0
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/pango
	x11-libs/libwnck:1
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/startup-notification-0.7
	>=x11-wm/metacity-3.12
	kde? ( >=kde-base/kwin-4.11.1 )
	test? ( dev-cpp/gtest
		dev-cpp/gmock
		sys-apps/xorg-gtest )
	${PYTHON_DEPS}"

DEPEND="${COMMONDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	x11-proto/damageproto
	x11-proto/xineramaproto"

RDEPEND="${COMMONDEPEND}
	dev-libs/protobuf:=
	unity-base/unity-language-pack
	x11-apps/mesa-progs
	x11-apps/xvinfo"

src_prepare() {
	# Ubuntu patchset #
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.diff"        # This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "${S}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${S}/debian/patches/${patch}" )
	done
	base_src_prepare

	# Set DESKTOP_SESSION so correct profile and it's plugins get loaded at Xsession start #
	sed -e 's:xubuntu:xunity:g' \
		-i debian/65compiz_profile-on-session || die

	# Don't let compiz install /etc/compizconfig/config, violates sandbox and we install it from "${WORKDIR}/debian/config" anyway #
	sed '/add_subdirectory (config)/d' \
		-i compizconfig/libcompizconfig/CMakeLists.txt || die

	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to 'append-cppflags -DNDEBUG' #
	#	resulting in compiz window placement not working #
	export CMAKE_BUILD_TYPE=none

	# Disable -Werror #
	sed -e 's:-Werror::g' \
		-i cmake/CompizCommon.cmake || die

	# Disable gconftool-2 from being used (need to differentiate here so gsettings schemas will still be installed) #
	sed -e 's:COMPIZ_DISABLE_SCHEMAS_INSTALL:COMPIZ_DISABLE_GCONF_SCHEMAS_INSTALL:g' \
		-i cmake/{CompizGconf,plugin_extensions/CompizGenGconf}.cmake || die

	# Need to do a 'python_foreach_impl' run from python-r1 eclass to workaround corrupt generated python shebang for /usr/bin/ccsm #
	#  Due to the way CMake invokes distutils setup.py, shebang will be inherited from the sandbox leading to runtime failure #
	python_copy_sources
}

src_configure() {
	use kde && \
		mycmakeargs="${mycmakeargs} -DUSE_KDE4=ON" || \
		mycmakeargs="${mycmakeargs} -DUSE_KDE4=OFF"
	use test && \
		mycmakeargs="${mycmakeargs} -DCOMPIZ_BUILD_TESTING=ON" || \
		mycmakeargs="${mycmakeargs} -DCOMPIZ_BUILD_TESTING=OFF"

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR="/etc/gconf/schemas"
		-DCOMPIZ_DISABLE_GCONF_SCHEMAS_INSTALL=TRUE
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DUSE_GCONF=OFF
		-DUSE_GSETTINGS=ON
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=OFF
		-DCOMPIZ_DEFAULT_PLUGINS="ccp"
		"
	configuration() {
		cmake-utils_src_configure
	}
	python_foreach_impl run_in_build_dir configuration
}

src_test() {
	# Current test results: #
	# 99% tests passed, 1 tests failed out of 1362 #
	# The following tests FAILED: #
	#       15 - GWDMockSettingsTest.TestMock (Failed) #

	local XDUMMY_COMMAND="cmake-utils_src_test"
	xdummymake
}

src_compile() {
	# Disable unitymtgrabhandles plugin #
	sed -e "s:unitymtgrabhandles;::g" \
		-i "${CMAKE_USE_DIR}/debian/unity.ini"
	sed -e "s:unitymtgrabhandles,::g" \
		-i "${CMAKE_USE_DIR}/debian/compiz-gnome.gconf-defaults"
	sed -e "s:'unitymtgrabhandles',::g" \
		-i "${CMAKE_USE_DIR}/debian/compiz-gnome.gsettings-override"

	compilation() {
		cmake-utils_src_compile VERBOSE=1
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		pushd ${CMAKE_BUILD_DIR}
			addpredict /root/.gconf/
			addpredict /usr/share/glib-2.0/schemas/
			emake DESTDIR="${ED}" install

			# Window manager desktop file for GNOME #
			insinto /usr/share/gnome/wm-properties/
			doins gtk/gnome/compiz.desktop

			# Keybinding files #
			insinto /usr/share/gnome-control-center/keybindings
			doins gtk/gnome/*.xml
		popd ${CMAKE_BUILD_DIR}
	}
	python_foreach_impl run_in_build_dir installation

	pushd ${CMAKE_USE_DIR}
		CMAKE_DIR=$(cmake --system-information | grep '^CMAKE_ROOT' | awk -F\" '{print $2}')
		insinto "${CMAKE_DIR}/Modules/"
		doins cmake/FindCompiz.cmake
		doins compizconfig/libcompizconfig/cmake/FindCompizConfig.cmake

		# Docs #
		dodoc AUTHORS NEWS README
		doman debian/{ccsm,compiz,gtk-window-decorator}.1

		# X11 startup script #
		exeinto /etc/X11/xinit/xinitrc.d/
		doexe debian/65compiz_profile-on-session

		# Unity Compiz profile configuration file #
		insinto /etc/compizconfig
		doins debian/unity.ini
		doins debian/config

		# Compiz profile upgrade helper files for ensuring smooth upgrades from older configuration files #
		insinto /etc/compizconfig/upgrades/
		doins debian/profile_upgrades/*.upgrade
		insinto /usr/lib/compiz/migration/
		doins postinst/convert-files/*.convert

		# Default GConf settings #
		insinto /usr/share/gconf/defaults
		newins debian/compiz-gnome.gconf-defaults 10_compiz-gnome

		# Default GSettings settings #
		insinto /usr/share/glib-2.0/schemas
		newins debian/compiz-gnome.gsettings-override 10_compiz-ubuntu.gschema.override

		# Script for resetting all of Compiz's settings #
		exeinto /usr/bin
		doexe "${FILESDIR}/compiz.reset"

		# Script for migrating GConf settings to GSettings #
		insinto /usr/lib/compiz/
		doins postinst/migration-scripts/02_migrate_to_gsettings.py
		insinto /etc/xdg/autostart/
		doins "${FILESDIR}/compiz-migrate-to-dconf.desktop"
	popd ${CMAKE_USE_DIR}

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Setup gconf defaults #
	dodir /etc/gconf/2
	if [ -z "`grep gconf.xml.unity /etc/gconf/2/local-defaults.path 2> /dev/null`" ]; then
		echo "/etc/gconf/gconf.xml.unity" >> ${D}etc/gconf/2/local-defaults.path
	fi
	dodir /etc/gconf/gconf.xml.unity 2> /dev/null
	/usr/bin/update-gconf-defaults \
		--source="${ED}usr/share/gconf/defaults" \
			--destination="${ED}etc/gconf/gconf.xml.unity" || die
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
}

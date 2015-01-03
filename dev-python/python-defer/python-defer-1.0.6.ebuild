# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python3_3 )

URELEASE="utopic"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"
#UVER_PREFIX="2build1"

DESCRIPTION="Small framework for asynchrouns programming in Python. It is a stripped down version of Twisted's defer"

HOMEPAGE="https://launchpad.net/python-defer"
SRC_URI="${UURL}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	${PYTHON_DEPS}
        "

S="${WORKDIR}/defer-${PV}"

#src_prepare() {
#	# Ubuntu patchset #
#	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
#		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
#	done
#
#	distutils-r1_python_prepare_all
#
#	epatch -p1 "${FILESDIR}/${PN}-${MY_PV}-remove_install_Packagekit.service_file.patch"
#}

#src_postinst() {
#	# remove PackageKit.service file as it will be installed by 'app-admin/packagekit-base'
#	rm -rf "${ED}usr/share/dbus-1/system-services/org.freedesktop.PackageKit.service"
#}

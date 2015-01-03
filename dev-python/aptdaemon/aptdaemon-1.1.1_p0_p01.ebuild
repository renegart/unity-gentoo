# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python3_3 )

URELEASE="utopic"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/a/${PN}"
UVER_PREFIX="+bzr980"

DESCRIPTION="Aptdaemon allows normal users to perform package management tasks, e.g. refreshing the cache, upgrading the system, 
installing or removing software packages."

HOMEPAGE="https://launchpad.net/aptdaemon"
SRC_URI="${UURL}/${PN}_${PV}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${PN}_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	sys-apps/apt
	dev-python/python-defer
	${PYTHON_DEPS}
        "

MY_PV="${PV}"
S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	distutils-r1_python_prepare_all

	epatch -p1 "${FILESDIR}/${PN}-${MY_PV}-remove_install_Packagekit.service_file.patch"
}

src_postinst() {
	# remove PackageKit.service file as it will be installed by 'app-admin/packagekit-base'
	rm -rf "${ED}usr/share/dbus-1/system-services/org.freedesktop.PackageKit.service"
}

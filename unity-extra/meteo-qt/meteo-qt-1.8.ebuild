# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_7,3_8} )

inherit distutils-r1

DESCRIPTION="System tray application for weather status information"
HOMEPAGE="https://github.com/dglent/meteo-qt"
SRC_URI="https://github.com/dglent/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	sed -e 's:ubuntu:unity:g' \
		-i meteo_qt/meteo_qt.py || die
}

python_install_all() {
	distutils-r1_python_install_all
}

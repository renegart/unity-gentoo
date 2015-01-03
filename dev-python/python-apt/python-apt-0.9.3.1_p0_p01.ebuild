# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python3_3 )

URELEASE="utopic"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"

DESCRIPTION="This is a Python library interface to libapt, which allows you to query and manipulat APT package repository 
information using the Python programming language."
HOMEPAGE="https://launchpad.net/python-apt"
SRC_URI="${UURL}/${PN}_${PV}${UVER}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	sys-apps/apt
	${PYTHON_DEPS}
        "

S="${WORKDIR}/${PN}-${PV}${UVER}"

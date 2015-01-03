# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python3_3 )

URELEASE="utopic"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/l/${PN}"

DESCRIPTION="Language-selector package for Unity Desktop"
HOMEPAGE="https://launchpad.net/language-selector"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-python/aptdaemon
	dev-python/python-apt
	${PYTHON_DEPS}
        "

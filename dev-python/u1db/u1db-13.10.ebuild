# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

URELEASE="vivid"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
UVER="5"

DESCRIPTION="U1DB is a database API for synchronised databases of JSON documents"
HOMEPAGE="https://launchpad.net/u1db"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="${PYTHON_DEPS}"

src_install() {
	# Delete some files that are only useful on Ubuntu
	rm -rf "${ED}"etc/apport "${ED}"usr/share/apport

	distutils-r1_src_install
}

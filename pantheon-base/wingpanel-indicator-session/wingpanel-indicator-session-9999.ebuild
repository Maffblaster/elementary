# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VALA_MIN_VERSION=0.22

inherit gnome2-utils vala cmake-utils bzr

DESCRIPTION="Session indicator for Wingpanel"
HOMEPAGE="https://launchpad.net/wingpanel-indicator-session"
EBZR_REPO_URI="lp:${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/glib:2
	pantheon-base/wingpanel
	sys-apps/accountsservice
	x11-libs/gtk+:3
	x11-libs/granite
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	eapply_user

	vala_src_prepare
	cmake-utils_src_prepare
}


src_configure() {
	mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE=${VALAC}
	)

	cmake-utils_src_configure
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

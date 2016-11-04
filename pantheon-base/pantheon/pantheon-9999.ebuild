# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bzr

if [[ "${PV}" == "9999" ]]; then
	EBZR_REPO_URI="lp:~elementary-os/elementaryos/pantheon-xsession-settings"
else
	# Set based on ${PV}
	case "${PV}" in
		"0.2")
			EBZR_REPO_URI="lp:~elementary-os/elementaryos/pantheon-xsession-settings-luna"
		;;
		"0.3")
			EBZR_REPO_URI="lp:~elementary-os/elementaryos/pantheon-xsession-settings-luna"
		;;
		"0.4")
			EBZR_REPO_URI="lp:~elementary-os/elementaryos/pantheon-xsession-settings"
		;;
	esac
fi	

KEYWORDS="~amd64"

DESCRIPTION="Pantheon DE meta package"
HOMEPAGE="https://www.elementaryos.org/ https://launchpad.net/elementaryos/"
LICENSE="GPL-3"
SLOT="0"

IUSE="+extras +lightdm +screensaver +themes"

CDEPEND="
	lightdm? ( >=pantheon-base/pantheon-greeter-1.0 )"
RDEPEND="${CDEPEND}
	gnome-base/gnome-session:0[ubuntu]
	gnome-base/gnome-settings-daemon:0[ubuntu]
	>=pantheon-base/cerbere-0.2
	pantheon-base/plank
	>=pantheon-base/slingshot-0.7
	>=pantheon-base/wingpanel-0.2
	pantheon-base/pantheon-settings
	x11-wm/gala
	x11-terms/pantheon-terminal
	pantheon-base/switchboard-plug-pantheon-shell
	extras? (
		www-client/epiphany
		pantheon-extra/pantheon-calculator
		pantheon-extra/pantheon-mail
		pantheon-extra/pantheon-print
	)
	screensaver? ( || ( 
		x11-misc/light-locker
		gnome-extra/gnome-screensaver
		x11-misc/xscreensaver 
		) )
	themes? ( 
		>=x11-themes/elementary-theme-3.4
		x11-themes/plank-theme-pantheon:0 
		)"
DEPEND="${CDEPEND}"

src_prepare() {
	eapply_user

	# Use gnome as fallback instead of ubuntu and mutter instead of gala
	#sed -i -e 's/ubuntu/gnome/' debian/pantheon.session || die "Failed to run sed 1"

	# Use gnome-session wrapper that sets XDG_CURRENT_DESKTOP
	#sed -i 's/gnome-session --session=pantheon/pantheon-session/' debian/pantheon.desktop || die "Failed to run sed 2"

	# Correct paths
	sed -i 's#/usr/lib/[^/]*/#/usr/libexec/#' autostart/* || die "Failed to run sed 3"
}

src_install() {
	insinto /usr/share/gnome-session/sessions
	doins gnome-session/*

	insinto /usr/share/xsessions
	doins xsessions/*

	insinto /usr/share/wayland-sessions
	doins wayland-sessions/*

	insinto /etc/xdg/autostart
	doins autostart/*

	insinto /usr/share/pantheon
	doins -r applications

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Pantheon"

	dobin "${FILESDIR}/pantheon-session"
}


#
# vim: fdm=indent fdn=1

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2008
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

proc bMotion_plugin_complex_shock { nick host handle channel text } {
	#if we spoke last, it's probable this is a reaction to us being
	# surprised at yourself is lame
	if {$channel == [bMotion_plugins_settings_get "complex:shock" "last" $channel ""]} {
		return 0
	}

	# set channel to stop use being suprised at ourselves!
	bMotion_plugins_settings_set "complex:shock" "last" $channel "" ""
	
	bMotionDoAction $channel $nick "%VAR{shocked}"
	return 1
}

bMotion_plugin_add_complex "shocked" "^((((=|:|;)-?(o|0))|(!+))|blimey|crumbs|i say)$" 40 bMotion_plugin_complex_shock "en"

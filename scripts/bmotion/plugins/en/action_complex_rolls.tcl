#
#
# vim: fdm=indent fdn=1 sw=4 ts=4:

###############################################################################
# This is a bMotion plugin
# Copyright (C) Mark Sangster 2007
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

bMotion_plugin_add_action_complex "rolls" "rolls %botnicks" 100 bMotion_plugin_complex_action_rolls "en"
bMotion_plugin_add_action_complex "bellyrubs" "rolls over for .*rubs" 80 bMotion_plugin_complex_action_bellyrubs "en"

proc bMotion_plugin_complex_action_rolls { nick host handle channel text } {
	bMotion_putloglev d * "bMotion: Got rolled"
	bMotionDoAction $channel $nick "%VAR{rolls_channel_response}"
	return 1
}


proc bMotion_plugin_complex_action_bellyrubs { nick host handle channel text } {
	if {[bMotion_interbot_me_next $channel]} {
		bMotionDoAction $channel $nick "%VAR{belly_rubs}"
		return 1
	}
}


bMotion_abstract_register "rolls_channel_response" {
	"keep them doggies rolling RAWHIDE"
	"rolls a joint"
	". o O ( ? )"
	"%VAR{fellOffs}"
}

bMotion_abstract_register "belly_rubs" {
	"/tickles %%"
	"/springs that trap"
	"/rubs %%%|%!who's a good boy and/or girl? %SMILEY{bigsmile}"
}

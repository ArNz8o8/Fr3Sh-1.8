# bMotion admin help
#
#
# $Id$
#

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2002
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

#												 name		regexp							 flags	 callback
bMotion_plugin_add_management "help" "^help"		 t			 "bMotion_plugin_management_help" "any"

#################################################################################################################################
# Declare plugin functions

proc bMotion_plugin_management_help { handle { args "" } } {
	global bMotion_plugins_management

	if {$args == ""} {
		bMotion_putadmin "You can run bMotion commands from DCC with .bmotion COMMAND,"
		bMotion_putadmin "	from a channel with .bmotion BOTNICK COMMAND, and from a"
		bMotion_putadmin "	query with the bot with bmotion COMMAND."
		bMotion_putadmin "Loaded bMotion Admin Commands:"
		set line ""
		set s [array startsearch bMotion_plugins_management]
		while {[set key [array nextelement bMotion_plugins_management $s]] != ""} {
			if {$key == "dummy"} {
				continue
			}
			append line "$key "
			if {[string length $line] > 50} {
				bMotion_putadmin "	$line"
				set line ""
			}
		}
		if {$line != ""} {
			bMotion_putadmin "	$line"
		}
		array donesearch bMotion_plugins_management $s

		bMotion_putadmin "Help is available for some plugins; run .bmotion help COMMAND"
		bMotion_putadmin "	for more information."
		return 0
	} else {
		switch $args {
			"flood" {
				bMotion_putadmin "Manage the flood protection system:"
				bMotion_putadmin "	.bmotion flood status"
				bMotion_putadmin "		show all tracked flood scores"
				bMotion_putadmin "	.bmotion flood show <nick>"
				bMotion_putadmin "		show score for <nick> (case sensitive)"
				bMotion_putadmin "	.bmotion flood set <nick> <value>"
				bMotion_putadmin "		set score for <nick> to <value>"
			}
			"status" {
				bMotion_putadmin "Show a summary of bMotion's status."
				bMotion_putadmin "	.bmotion status channels"
				bMotion_putadmin "		include the active channels in the status output"
			}
			"global" {
				bMotion_putadmin "Switch bMotion on and off everywhere:"
				bMotion_putadmin "	.bmotion global off"
				bMotion_putadmin "		disable bMotion"
				bMotion_putadmin "	.bmotion global on"
				bMotion_putadmin "		enable bMotion"
			}
			"lang" {
				bMotion_putadmin "Switch languages:"
				bMotion_putadmin "	.bmotion lang"
				bMotion_putadmin "		show available and current language"
				bMotion_putadmin "	.bmotion lang add <lang>"
				bMotion_putadmin "		add a language"
				bMotion_putadmin "	.bmotion lang remove <lang>"
				bMotion_putadmin "		unload a language"
				bMotion_putadmin "	.bmotion lang use <lang>"
				bMotion_putadmin "		switch active language"
			}
			"plugin" {
				bMotion_putadmin "Manage plugins:"
				bMotion_putadmin "	.bmotion plugin list \[<search terms>\]"
				bMotion_putadmin "		List all plugins. If optional search terms are given,"
				bMotion_putadmin "		list is filtered. Can potentially generate lots of output"
				bMotion_putadmin "	.bmotion plugin remove <type> <name>"
				bMotion_putadmin "		Unload a plugin. (To reload, rehash)."
				bMotion_putadmin "	.bmotion plugin enable <type> <name> \[<channel>\]"
				bMotion_putadmin "		Enable a plugin. Currently only output type supports this."
				bMotion_putadmin "      Optionally only enable on a particular channel."
				bMotion_putadmin "	.bmotion plugin disable <type> <name> \[<channel>\]"
				bMotion_putadmin "		Disable a plugin. Currently only output type supports this."
				bMotion_putadmin "      Optionally only disable on a particular channel. Use 'all' to"
				bMotion_putadmin "      remove all channels from the list."
				bMotion_putadmin "	.bmotion plugin info <type> <name>"
				bMotion_putadmin "		Display internal information for plugin. This won't mean much"
				bMotion_putadmin "		unless you know how bMotion plugins are defined."
			}
			"reload" {
				bMotion_putadmin "Reload bMotion without rehashing bot. Will be quicker than rehashing"
				bMotion_putadmin "but will generate ALERTs which you should ignore."
			}
			"rehash" {
				bMotion_putadmin "Safely rehash the bot. bMotion will check to make sure there are no"
				bMotion_putadmin "problems with loading the script and then rehash."
			}
			"friends" {
				bMotion_putadmin "Lists bMotion's friendships"
				bMotion_putadmin "	.bmotion friends show <nick>"
				bMotion_putadmin "		Shows the rating for the user"
				bMotion_putadmin "	.bmotion friends show -all"
				bMotion_putadmin "		Shows A LOT OF OUTPUT!!1"
				bMotion_putadmin "	.bmotion friends set <nick> <value>"
				bMotion_putadmin "		Sets user's friendship rating"
				bMotion_putadmin "Friendships are rated 0-100% with 50% being neutral. All users start on 50%."
				bMotion_putadmin "Actions against the bot affect friendships; friendships drift back to 40 or 60% (depending"
				bMotion_putadmin "on if they are lower or higher than those limits)."
			}
			"settings" {
				bMotion_putadmin "Handles internal bMotion settings (not configuration)"
				bMotion_putadmin "	.bmotion settings list"
				bMotion_putadmin "		List all settings stored by bMotion. This can be a lot of output."
				bMotion_putadmin "	.bmotion settings clear"
				bMotion_putadmin "		Clears the settings array."
			}
			"queue" {
				bMotion_putadmin "Interact with the bMotion queue"
				bMotion_putadmin "	.bmotion queue"
				bMotion_putadmin "		List the contents of bMotion's output queue"
				bMotion_putadmin "	.bmotion queue flush"
				bMotion_putadmin "		Clear the bMotion output queue"
			}
			"parse" {
				bMotion_putadmin "Make bMotion parse some text as a test"
				bMotion_putadmin "	.bmotion parse \[<channel>\] <text>"
				bMotion_putadmin "		If this command is issued from a query or the partyline,"
				bMotion_putadmin "		you must give the channel to send output to. Requests from"
				bMotion_putadmin "		a query or the partyline have '\[parse\]' prefixed."
			}
			default {
			#no pre-defined help, see if there's a callback for it
				set callback [bMotion_plugin_find_management_help $args]
				if {$callback != ""} {
					set result [$callback]
				} else {
					bMotion_putadmin "I seem to have misplaced my help for that command."
				}
			}
		}
		return 0
	}
}

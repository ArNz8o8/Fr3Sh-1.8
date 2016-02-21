## bMotion plugin: pinch
#
# $Id$
#

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2003
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

bMotion_plugin_add_action_complex "volez" "^(vole|enl�ve|prise) .+ de %botnicks" 100 bMotion_plugin_complex_action_volez "fr"

proc bMotion_plugin_complex_action_volez { nick host handle channel text } {
  global botnicks
  if [regexp -nocase "(vole|enl�v|prise) (.+) de ${botnicks}" $text matches action object] {
    # TODO: check $object and $action (e.g. pinches arse)
    bMotionDoAction $channel [bMotionGetRealName $nick $host] "%VAR{stolens}"
    bMotionGetSad
    # matching english plugin
    bMotion_plugins_settings_set "system" "lastevil" $channel "" $nick
    driftFriendship $nick -1
    return 1
  }
}

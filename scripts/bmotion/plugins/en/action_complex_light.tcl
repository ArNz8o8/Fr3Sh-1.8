#
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

bMotion_plugin_add_action_complex "light" "^(lights?|sets fire to) %botnicks" 100 bMotion_plugin_complex_action_light "en"

bMotion_plugin_add_action_complex "light2" "^sets %botnicks (alight|on fire)" 100 bMotion_plugin_complex_action_light "en"

proc bMotion_plugin_complex_action_light { nick host handle channel text } {
  bMotionDoAction $channel $nick "%VAR{burns}"
  bMotionGetUnLonely
  driftFriendship $nick -1
  return 1
}

bMotion_abstract_register "burns" {
  "/burns%|%bot[50,�VAR{extinguishes}]"
  "*flames*%|%bot[50,�VAR{extinguishes}]"
  "B%REPEAT{2:5:O}M"
  "b%REPEAT{2:5:o}m"
  "BLAM"
  "pop"
  "/goes up in flames%|%bot[50,�VAR{extinguishes}]"
  "*smoulder*%|%bot[50,�VAR{extinguishes}]"
  "/explodes"
  "huk"
  "%colen"
  "/torches%|%bot[50,�VAR{extinguishes}]"
  "/informs the world 'It's time to burn'"
}

bMotion_abstract_register "extinguishes" {
  "/puts %% out"
  "/pours water on %%"
  "/wraps %% in a fire blanket"
  "/laughs%|%BOT[�VAR{unsmiles}]"
  "%VAR{shocked}"
  "kaBLAM"
  "taunt"
}

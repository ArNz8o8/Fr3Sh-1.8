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

bMotion_plugin_add_output "jeffk" bMotion_plugin_output_jeffk 0 "en" 11

proc bMotion_plugin_output_jeffk { channel line } {

  return [bMotion_module_extra_jeffk $line]
}

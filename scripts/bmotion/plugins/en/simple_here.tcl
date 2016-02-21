#
#

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2008
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

bMotion_plugin_add_simple "here" "^any ?(one|body) (here|alive|talking)" 40 "%VAR{here_responses}" "en"

# abstracts

bMotion_abstract_register "here_responses" {
  "%VAR{nos}"
}

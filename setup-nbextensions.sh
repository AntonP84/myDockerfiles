#!/bin/bash

pip install --no-cache-dir -qU jupyter_contrib_nbextensions

jupyter contrib nbextension install --user --InstallContribNbextensionsApp.log_level=WARN
jupyter nbextensions_configurator enable --user
jupyter nbextension enable --py --user widgetsnbextension
jupyter nbextension enable toc2/main
jupyter nbextension enable spellchecker/main
jupyter nbextension enable codefolding/main
jupyter nbextension enable collapsible_headings/main
jupyter nbextension enable hide_input_all/main
jupyter nbextension enable python-markdown/main
jupyter nbextension enable freeze/main
jupyter nbextension enable scratchpad/main
jupyter nbextension disable contrib_nbextensions_help_item/main
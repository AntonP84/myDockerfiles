#!/bin/bash

pip install -qU jupyter_contrib_nbextensions yapf

jupyter contrib nbextension install --system --InstallContribNbextensionsApp.log_level=WARN
jupyter nbextensions_configurator enable --system
jupyter nbextension enable --py --sys-prefix widgetsnbextension
jupyter nbextension enable toc2/main
jupyter nbextension enable spellchecker/main
jupyter nbextension enable codefolding/main
jupyter nbextension enable codefolding/edit
jupyter nbextension enable collapsible_headings/main
jupyter nbextension enable code_prettify/code_prettify
jupyter nbextension enable table_beautifier/main
jupyter nbextension enable hide_input_all/main
jupyter nbextension enable python-markdown/main
jupyter nbextension enable notify/notify
jupyter nbextension enable freeze/main
jupyter nbextension enable scratchpad/main
jupyter nbextension enable snippets/main
jupyter nbextension disable contrib_nbextensions_help_item/main
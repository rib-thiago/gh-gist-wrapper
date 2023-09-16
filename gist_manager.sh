#!/usr/bin/env bash
################################################################################

#
# Script:
# gist_manager.sh

#
# Description:
# Script destina-se a ser um wrapper para o comando `gh gist`

#
# Author: Thiago Ribeiro
# Date: 2023-09-16
# Version: 0.0.1

#
# Usage:
# To run this script, type: ./gist_manager.sh

#
# Dependencies:
# - gh

#
# Change Log:
# - None.

#
# Version   Date          Author          Description
# -------   ----          ------          -----------
# 0.0.1     [2023-09-16]  Thiago Ribeiro  Initial release.


#
# TODO: None.

#
# FIXME: None.

################################################################################


# display de menu de ajuda
## Função que extrai o id de um gist? 
# diretório para salvar gists
# download de gists em pasta oculta
# incluir pasta oculta no .gitignore



# Available commands
CLONE='gh gist clone'
CREATE='gh gist create'
DELETE='gh gist delete'
EDIT='gh gist edit'
LIST='gh gist list'
RENAME='gh gist rename'
VIEW='gh gist view'

count_columns_with_awk() {
    local output="$1"
    local number_of_columns=$(echo "$output" | awk 'NR==1 {print NF}')
    echo "Número de colunas: $number_of_columns"
}


output=$($LIST --secret)
count_columns_with_awk "$output"


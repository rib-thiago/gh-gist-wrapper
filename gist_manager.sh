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
# FIXME: Comando `gh gist rename` não disponível.

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
LIST='gh gist list --secret'
VIEW='gh gist view'


# count_columns_with_awk() {
#     local output="$1"
#     local number_of_columns=$(echo "$output" | awk 'NR==0 {print NF}')
#     echo "Número de colunas: $number_of_columns"
# }

# get_first_field_with_awk() {
#     local output="$1"
#     local first_field=$(echo "$output" | awk 'NR==0 {print $1}')
#     echo "$first_field"
# }



# output=$($LIST --secret)


# count_columns_with_awk "$output"
# get_first_field_with_awk "$output"

create_dictionary() {
    local output="$1"
    local lines=()

    # Ler cada linha da saída e adicionar ao array 'lines'
    while IFS= read -r line; do
        local first_field=$(echo "$line" | awk '{print $1}')
        local second_field=$(echo "$line" | awk '{print $2}')
        # Verificar se ambos os campos têm conteúdo antes de adicionar ao dicionário
        if [ -n "$first_field" ] && [ -n "$second_field" ]; then
            lines+=("$first_field : $second_field")
        fi
    done <<< "$output"

    echo -e ""
    # Loop sobre as linhas e exiba as strings
    for line_str in "${lines[@]}"; do
        echo "$line_str"
    done
}
cmd=$($LIST)
create_dictionary "$cmd"


# Inicio
create_dictionary
echo -e ""
echo "Selecione uma ação: "
echo -e ""
echo "1. Listar Gists"
echo "2. Visualizar Gists"
echo "3. Editar Gists"
echo "4. Clonar Gists"
echo "5. Deletar Gists"
echo -e "\n"
read -p  "Qual a Sua opção: " option

case $option in
    1)
        echo "1. Listar Gists"
    ;;
    2)
        echo "2. Visualizar Gists"
    ;;
    3)
        echo "3. Editar Gists"
    ;;
    4)
        echo "4. Clonar Gists"
    ;;
    5)
        echo "5. Deletar Gists"
    ;;
    *)
        echo "A escolha não é válida."
    ;;
esac
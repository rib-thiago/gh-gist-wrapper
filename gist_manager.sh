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

## Paleta de Cores
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
RESET="\033[0m"

# Available commands
CLONE='gh gist clone'
CREATE='gh gist create'
DELETE='gh gist delete'
LIST='gh gist list --secret'
VIEW='gh gist view'
EDIT='gh gist edit'

# Definir um array associativo para mapear nomes de Gists para IDs
declare -A gist_map

# Função para listar os Gists
list_gists() {
    create_dictionary 
    echo -e "${MAGENTA}Gists Catalogados: ${RESET}"
    echo -e ""
    
    # Loop sobre as linhas e exiba as strings
    for line_str in "${lines[@]}"; do
        echo -e "${CYAN}$line_str${RESET}"
    done
}

# Função para criar um dicionário de Gists a partir da saída do comando
create_dictionary() {
    local output="$($LIST)"
    lines=()

    # Limpar o gist_map para evitar IDs antigos
    gist_map=()

    # Ler cada linha da saída e adicionar ao array 'lines'
    while IFS= read -r line; do
        local first_field=$(echo "$line" | awk '{print $1}')
        local second_field=$(echo "$line" | awk '{print $2}')
        # Verificar se ambos os campos têm conteúdo antes de adicionar ao dicionário
        if [ -n "$first_field" ] && [ -n "$second_field" ]; then
            lines+=("$first_field : $second_field")
            
            # Adicionar o ID do Gist ao gist_map
            gist_map["$second_field"]=$first_field
        fi
    done <<< "$output"
}

# Função para criar um novo Gist
create_gist() {
    echo "Como você deseja criar o Gist?"
    echo "1. A partir de um arquivo existente"
    echo "2. Digitar o conteúdo agora"
    read -p "Escolha uma opção: " create_option

    case $create_option in
        1)
            echo "Digite o caminho completo do arquivo que você deseja criar o Gist:"
            read file_path
            filename=$(basename "$file_path")
            echo "Digite uma descrição para o Gist:"
            read gist_description
            gist_url="$($CREATE -d "$gist_description" -f "$filename" < "$file_path")"
            gist_id=$(basename "$gist_url")
            ;;
        2)
            echo "Digite o nome do arquivo:"
            read filename
            echo "Digite o conteúdo do arquivo (pressione Ctrl+D para encerrar):"
            content=$(cat)
            echo "Digite uma descrição para o Gist:"
            read gist_description
            gist_url="$($CREATE -d "$gist_description" -f "$filename" <<< "$content")"
            gist_id=$(basename "$gist_url")
            ;;
        *)
            echo "Opção inválida."
            return
            ;;
    esac

    echo "Gist criado com sucesso. ID: $gist_id"

}

# Função para clonar um Gist
clone_gist() {
    echo "Escolha um Gist para clonar:"
    
    # Criar uma lista de opções formatadas como uma tabela
    options_list=""
    for name in "${!gist_map[@]}"; do
        options_list+="$(printf "%-30s" "$name") : ${gist_map[$name]}\n"
    done
    
    # Exibir a lista formatada usando 'column'
    echo -e "$options_list" | column -t -s ':'
    read -p "Digite o nome do Gist que deseja clonar: " gist_name
    gist_id="${gist_map[$gist_name]}"
    if [ -n "$gist_id" ]; then
        $CLONE "$gist_id"
        echo "Gist clonado com sucesso."
    else
        echo "Gist não encontrado."
    fi
}

# Função para excluir um Gist
delete_gist() {
    create_dictionary 
    echo "Escolha um Gist para excluir:"
    
    # Criar uma lista de opções formatadas como uma tabela
    options_list=""
    for name in "${!gist_map[@]}"; do
        options_list+="$(printf "%-30s" "$name") : ${gist_map[$name]}\n"
    done
    
    # Exibir a lista formatada usando 'column'
    echo -e "$options_list" | column -t -s ':'
    read -p "Digite o nome do Gist que deseja excluir: " gist_name
    gist_id="${gist_map[$gist_name]}"
    if [ -n "$gist_id" ]; then
        $DELETE "$gist_id"
        echo "Gist excluído com sucesso."
        # Remova o Gist do mapa
        unset "gist_map[$gist_name]"
    else
        echo "Gist não encontrado."
    fi
}

# Função para visualizar um Gist
view_gist() {
    create_dictionary 
    echo "Escolha um Gist para visualizar:"
    
    # Criar uma lista de opções formatadas como uma tabela
    options_list=""
    for name in "${!gist_map[@]}"; do
        options_list+="$(printf "%-30s" "$name") : ${gist_map[$name]}\n"
    done
    
    # Exibir a lista formatada usando 'column'
    echo -e "$options_list" | column -t -s ':'
    read -p "Digite o nome do Gist que deseja visualizar: " gist_name
    gist_id="${gist_map[$gist_name]}"
    if [ -n "$gist_id" ]; then
        $VIEW "$gist_id"  # Usar o comando 'gh gist view' para visualizar o Gist
    else
        echo "Gist não encontrado."
    fi
}

# Função para editar um Gist
edit_gist() {
    create_dictionary 
    echo "Escolha um Gist para editar:"
    
    # Criar uma lista de opções formatadas como uma tabela
    options_list=""
    for name in "${!gist_map[@]}"; do
        options_list+="$(printf "%-30s" "$name") : ${gist_map[$name]}\n"
    done
    
    # Exibir a lista formatada usando 'column'
    echo -e "$options_list" | column -t -s ':'
    read -p "Digite o nome do Gist que deseja editar: " gist_name
    gist_id="${gist_map[$gist_name]}"
    if [ -n "$gist_id" ]; then
        $EDIT "$gist_id"  # Usar o comando 'gh gist edit' para editar o Gist
        echo "Gist editado com sucesso."
    else
        echo "Gist não encontrado."
    fi
}



# Inicio

# Menu principal
while true; do
    echo "Selecione uma ação:"
    echo "1. Listar Gists"
    echo "2. Criar Gist"
    echo "3. Clonar Gist"
    echo "4. Visualizar Gist"
    echo "5. Editar Gist"
    echo "6. Deletar Gist"
    echo "7. Sair"
    read -p "Qual é a sua escolha: " option

    case $option in
        1)
            list_gists
            ;;
        2)
            create_gist
            ;;
        3)
            clone_gist
            ;;
        4)
            view_gist
            ;;
        5)
            edit_gist
            ;;
        6)
            delete_gist
            ;;
        7)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done

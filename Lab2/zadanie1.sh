#!/bin/bash -eu

ERROR_MISSING_PARAMETERS=10
ERROR_DIR_DOES_NOT_EXIST=15

if [[ $# -ne 2 ]]; then
    echo "Nie podano 2 parametrow wywolania"
    exit ${ERROR_MISSING_PARAMETERS}
fi


# Zadanie 1
# 3.0: Napisać skrypt, który przyjmuje 2 parametry – 2 ścieżki do katalogów. Z zadanego katalogu nr 1 wypisać 
# wszystkie pliki po kolei, wraz z informacją:
# - czy jest to katalog
# - czy jest to dowiązanie symboliczne
# - czy plik regularny.
# Następnie (lub równolegle) utworzyć w katalogu nr 2 dowiązania symboliczne do każdego pliku regularnego i 
# katalogu z katalogu nr 1, dodając "_ln" przed rozszerzeniem, np. magic_file.txt -> magic_file_ln.txt

DIR1=${1}
DIR2=${2}

if [[ ! -d "${DIR1}" ]]; then
    echo "Katalog ${DIR1} nie istnieje"
    exit ${ERROR_DIR_DOES_NOT_EXIST}
fi
if [[ ! -d "${DIR2}" ]]; then
    echo "Katalog ${DIR2} nie istnieje"
    exit ${ERROR_DIR_DOES_NOT_EXIST}
fi

# Ustalenie rodzaju ścieżki katalogu nr 1 - wykorzystane przy tworzeniu dowiązania symbolicznego:
if [[ "${DIR1}" = /* ]]; then
    IS_DIR1_PATH_RELATIVE=false
else
    IS_DIR1_PATH_RELATIVE=true
fi

DIR1_FILES=$(ls "${DIR1}")

for FILE in ${DIR1_FILES}; do
    if [[ -d "${DIR1}/${FILE}" ]]; then
        echo "${FILE} jest katalogiem"
        SOFT_LINK_NAME="${FILE}_ln"
        if [[ ${IS_DIR1_PATH_RELATIVE} == true ]]; then
            ABSOLUTE_PATH=$(pwd)    
            ln -s "${ABSOLUTE_PATH}/${DIR1}/${FILE}" "${DIR2}/${SOFT_LINK_NAME}"
        else
            ln -s "${DIR1}/${FILE}" "${DIR2}/${SOFT_LINK_NAME}"
        fi

    elif [[ -f "${DIR1}/${FILE}" ]]; then
        echo "${FILE} jest plikiem regularnym"
        SOFT_LINK_NAME="${FILE%.*}_ln.${FILE##*.}"
        if [[ ${IS_DIR1_PATH_RELATIVE} == true ]]; then
            ABSOLUTE_PATH=$(pwd)    
            ln -s "${ABSOLUTE_PATH}/${DIR1}/${FILE}" "${DIR2}/${SOFT_LINK_NAME}"
        else
            ln -s "${DIR1}/${FILE}" "${DIR2}/${SOFT_LINK_NAME}"
        fi

    elif [[ -L "${DIR1}/${FILE}" ]]; then
        echo "${FILE} jest dowiązaniem symbolicznym"
    fi
done



#!/bin/bash -eu

ERROR_MISSING_PARAMETERS=10
ERROR_DIR_DOES_NOT_EXIST=15
ERROR_FILE_DOES_NOT_EXIST=16

if [[ $# -ne 2 ]]; then
    echo "Nie podano 2 parametrow wywolania"
    exit ${ERROR_MISSING_PARAMETERS}
fi


# Zadanie 2
# +0.5 - Napisać skrypt, który w zadanym katalogu (1. parametr) usunie wszystkie uszkodzone 
# dowiązania symboliczne, a ich nazwy wpisze do pliku (2. parametr), wraz z dzisiejszą datą w formacie ISO 8601.

DIR=${1}
TARGET_FILE=${2}

if [[ ! -d "${DIR}" ]]; then
    echo "Katalog ${DIR} nie istnieje"
    exit ${ERROR_DIR_DOES_NOT_EXIST}
fi
if [[ ! -f "${TARGET_FILE}" ]]; then
    echo "PLik ${TARGET_FILE} nie istnieje"
    exit ${ERROR_FILE_DOES_NOT_EXIST}
fi

DIR_FILES=$(ls "${DIR}")

for FILE in ${DIR_FILES}; do
    if [[ -L "${DIR}/${FILE}" ]]; then
        if [[ ! -e "${DIR}/${FILE}" ]]; then
            echo "${FILE}_$(date --iso-8601)" >> "${TARGET_FILE}"
            rm -R "${DIR}/${FILE}"
        fi
    fi
done
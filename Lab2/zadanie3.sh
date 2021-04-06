#!/bin/bash -eu

ERROR_DIR_DOES_NOT_EXIST=15

if [[ $# -ne 1 ]]; then
    echo "Nie podano 1 parametru wywolania"
    exit ${ERROR_MISSING_PARAMETERS}
fi


# Zadanie 3
# +1.0 - Napisać skrypt, który w zadanym katalogu (jako parametr) każdemu:
# - plikowi regularnemu z rozszerzeniem .bak odbierze uprawnienia do edytowania dla właściciela i innych
# - katalogowi z rozszerzeniem .bak (bo można!) pozwoli wchodzić do środka tylko innym
# - w katalogach z rozszerzeniem .tmp pozwoli każdemu tworzyć i usuwać jego pliki
# - plikowi z rozszerzeniem .txt będą czytać tylko właściciele, edytować grupa właścicieli, wykonywać inni. Brak innych uprawnień
# - pliki regularne z rozszerzeniem .exe wykonywać będą mogli wszyscy, ale zawsze wykonają się z uprawnieniami właściciela

DIR=${1}

if [[ ! -d "${DIR}" ]]; then
    echo "Katalog ${DIR} nie istnieje"
    exit ${ERROR_DIR_DOES_NOT_EXIST}
fi

DIR_FILES=$(ls "${DIR}")

for FILE in ${DIR_FILES}; do
    if [[ -f "${DIR}/${FILE}" && ${FILE##*.} == "bak" ]]; then
        chmod a-w "${DIR}/${FILE}"
    elif [[ -d "${DIR}/${FILE}" && ${FILE##*.} == "bak" ]]; then
        chmod u-x, go+x "${DIR}/${FILE}"
    elif [[ -d "${DIR}/${FILE}" && ${FILE##*.} == "tmp" ]]; then
        chmod u+w, go-w "${DIR}/${FILE}/*"
    elif [[ -f "${DIR}/${FILE}" && ${FILE##*.} == "txt" ]]; then
        chmod 421 "${DIR}/${FILE}"
    elif [[ -f "${DIR}/${FILE}" && ${FILE##*.} == "exe" ]]; then
        chmod u+x, a+xs "${DIR}/${FILE}"
    fi
done
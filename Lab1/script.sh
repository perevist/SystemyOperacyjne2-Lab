#!/bin/bash

# Zadanie 1
# +0.5 – napisać skrypt, który pobiera 3 argumenty: SOURCE_DIR, RM_LIST, TARGET_DIR 
# o wartościach domyślnych: lab_uno, lab_uno /2remove, bakap
SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-lab_uno/2remove}
TARGET_DIR=${3:-bakap}


# Zadanie 2
# +0.5 – jeżeli TARGET_DIR nie istnieje, to go tworzymy
if [[ ! -e "${TARGET_DIR}" ]]; then
    mkdir "${TARGET_DIR}"
fi


# Zadanie 3
# +1.0 – iterujemy się po zawartości pliku RM_LIST i tylko jeżeli plik 
# o takiej nazwie występuje w katalogu SOURCE_DIR, to go usuwamy
FILES_RM_LIST=$(cat "${RM_LIST}")
FILES_SOURCE_DIR=$(ls "${SOURCE_DIR}")

for FILE_RM_LIST in ${FILES_RM_LIST}; do
    for FILE_SOURCE_DIR in ${FILES_SOURCE_DIR}; do
        if [[ ${FILE_SOURCE_DIR} == ${FILE_RM_LIST} ]]; then
            rm -r "${SOURCE_DIR}/${FILE_SOURCE_DIR}"
        fi
    done
done


# Zadanie 4 oraz 5
# +0.5 – jeżeli jakiegoś pliku nie ma na liście, ale jest plikiem, to przenosimy go do TARGET_DIR
# +0.5 – jeżeli jakiegoś  pliku nie ma na liście, ale jest katalogiem, to kopiujemy go do 
# TARGET_DIR z zawartością

# Czyli wykonujemy operacje jeśli plik nie został usunięty

FILES_SOURCE_DIR=$(ls "${SOURCE_DIR}")

for FILE_SOURCE_DIR in ${FILES_SOURCE_DIR}; do
    if [[ -f "${SOURCE_DIR}/${FILE_SOURCE_DIR}" ]]; then
        mv "${SOURCE_DIR}/${FILE_SOURCE_DIR}" "${TARGET_DIR}"
    elif [[ -d  "${SOURCE_DIR}/${FILE_SOURCE_DIR}" ]]; then
        cp -R "${SOURCE_DIR}/${FILE_SOURCE_DIR}" "${TARGET_DIR}"
    fi
done


# Zadanie 6
FILES_SOURCE_DIR=$(ls "${SOURCE_DIR}")
NUMBER_OF_FILES=0

for FILE_SOURCE_DIR in ${FILES_SOURCE_DIR}; do
    NUMBER_OF_FILES=$(( NUMBER_OF_FILES + 1 ))
done

echo "Stan katalogu SOURCE_DIR:"
if [[ ${NUMBER_OF_FILES} -ne 0 ]]; then
    echo "Jeszcze cos zostalo"
    if [[ ${NUMBER_OF_FILES} -ge 2 ]]; then
        echo "Zostaly co najmniej 2 pliki"
        if [[ ${NUMBER_OF_FILES} -gt 4 ]]; then
            echo "Zostaly wiecej niz 4 pliki"
        elif [[ ${NUMBER_OF_FILES} -le 4 ]]; then
            echo "Zostaly co najmniej 2 pliki, ale nie wiecej niz 4"
        fi
    fi
else
    echo "Nic nie zostalo"
fi


# Zadanie 7
# +0.5 – wszystkie pliki w katalogu TARGET_DIR muszą mieć odebrane prawa do edycji
FILES_TARGET_DIR=$(ls "${TARGET_DIR}")

for FILE_TARGET_DIR in ${FILES_TARGET_DIR}; do
    chmod -w -R "${TARGET_DIR}/${FILE_TARGET_DIR}"
done


# Zadanie 8
# +0.5 – po wszystkich spakuj katalog TARGET_DIR i nazwij bakap_DATA.zip, gdzie DATA 
# to dzień uruchomienia skryptu w formacie RRRR-MM-DD

CURRENT_DATE=$(date +'%Y-%m-%d')
zip -rq "bakap_${CURRENT_DATE}.zip" "${TARGET_DIR}"
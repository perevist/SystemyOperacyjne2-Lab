#!/bin/bash -eu

# Odczytanie zawartości katalogu groovies
FILE_LIST=$(ls groovies)
cd groovies

# Zadanie 3 +1.5
# We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/
for FILE in ${FILE_LIST}; do
    sed -ri 's/\$HEADER\$/\/temat\//g' ${FILE}
done

# We wszystkich plikach w katalogu ‘groovies’ po każdej linijce z 'class' dodać '  String marker = '/!@$%/''
for FILE in ${FILE_LIST}; do
    sed -ri "/class/a String marker = '\/!@\$%/'" ${FILE}
done

# We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'"
for FILE in ${FILE_LIST}; do
    sed -ri '/Help docs:/d' ${FILE}
done

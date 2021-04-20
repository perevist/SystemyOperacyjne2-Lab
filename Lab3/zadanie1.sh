#!/bin/bash -eu

# Zadanie 1 +2.0
# Znajdź w pliku access_log zapytania, które mają frazę ""denied"" w linku
cat access_log | cut -d' ' -f6,7,8 | grep "/denied"

# Znajdź w pliku access_log zapytania typu POST
cat access_log | cut -d' ' -f6,7,8 | grep "\"POST "

# Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
cat access_log | cut -d' ' -f1,6,7,8 | grep "^64\.242\.88\.10 "

# Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
cat access_log | cut -d' ' -f1,6,7,8 | grep -Ev "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} " | grep -v "^\["

# Znajdź w pliku access_log unikalne zapytania typu DELETE
cat access_log | cut -d' ' -f6,7,8 | grep "\"DELETE " | sort | uniq

# Znajdź unikalnych 10 adresów IP w access_log"
cat access_log | grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} " | cut -d' ' -f1 | sort | uniq | sed 10q
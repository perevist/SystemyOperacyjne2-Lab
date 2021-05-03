#!/bin/bash -eu
# Wykonane zadania: 1, 2, 3, 4, 5, 6 (wszystkie)

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-y YEAR\n\tSearch movies with a year greater than YEAR"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m*{@}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_year () {
    # Returns list of movies from ${1} with ${2} in year slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        YEAR=$(grep "| Year" "${MOVIE_FILE}" | cut -d' ' -f3)
        if [[ ${YEAR} -gt ${QUERY} ]]; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_plot () {
    # Returns list of movies from ${1} with ${2} in plot slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    local -r IGNORE_CASE=${3}

    if ${IGNORE_CASE:-false}; then
        FLAGS="-qi"
    else
        FLAGS="-q"
    fi

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Plot" "${MOVIE_FILE}" | grep ${FLAGS} "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP
    TEMP=$(cat "${FILENAME}")

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # TODO: change 'Author:' into <Author>
    # Czy nie chodziło o pole 'Director'?
    # TODO: change others too
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+)/\0 <\/\1>/')
    TEMP=$(echo "${TEMP}" | sed -r 's/: //g')
    TEMP=$(echo "${TEMP}" | sed -r 's/\|.* <\//</g')

    # TODO: replace first line of equals signs
    TEMP=$(echo "${TEMP}" | sed '2s/===*/<movie>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

# ANY_ERRORS=false

while getopts ":hd:t:a:f:xy:R:i" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        OPTION_D_USED=true
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    f)
        FILE_4_SAVING_RESULTS=${OPTARG}
        if [[ ! ${FILE_4_SAVING_RESULTS} =~ [*.txt] ]]; then
            FILE_4_SAVING_RESULTS="${FILE_4_SAVING_RESULTS}.txt"
        fi
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=$( cmd "${OPTARG}")
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    y) 
        SEARCHING_YEAR=true
        QUERY_YEAR=${OPTARG}
        ;;
    R)
        SEARCHING_PLOT=true
        IGNORE_CASE=false
        QUERY_PLOT=${OPTARG}
        ;;
    i)
        IGNORE_CASE=true
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        # ANY_ERRORS=true
        exit 1
        ;;
  esac
done

# Zadanie 4
# + 0.5: Dodaj sprawdzenie, czy na pewno wykorzystano opcję '-d' i czy jest to katalog
if ${OPTION_D_USED:-false}; then
    if [[ ! -d "${MOVIES_DIR}" ]]; then
        echo "${MOVIES_DIR} is not a directory"
        exit 1
    fi
else
    echo "Please, pass -d option with a directory name"
    exit 1
fi

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

if ${SEARCHING_YEAR:-false}; then
    MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_YEAR}")
fi

if ${SEARCHING_PLOT:-false}; then
    MOVIES_LIST=$(query_plot "${MOVIES_LIST}" "${QUERY_PLOT}" "${IGNORE_CASE}")
fi

if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo "Found 0 movies :-("
    exit 0
fi


if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    # TODO: add XML option
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" | tee "${FILE_4_SAVING_RESULTS}"
fi

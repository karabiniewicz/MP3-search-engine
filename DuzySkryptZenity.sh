#!/bin/bash
# Author           : Adam Karabiniewicz ( s180009@student.pg.edu.pl )
# Created On       : 23.05.2020 (DD.MM.RRRR)
# Last Modified By : Adam Karabiniewicz ( s180009@student.pg.edu.pl )
# Last Modified On : 24.05.2020 (DD.MM.RRRR)
# Version          : 1.0
#
# Description      : Skrypt stworzony na potrzeby przedmiotu Systemy Operacyjne.
#                    Wyszukiwarka plików mp3 według id tagów.
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

while getopts hvi arg; do
    case $arg in
        h) 
            echo -e "\nSkładnia: ./DuzySkryptZenity.sh [OPCJA...]\n"
            echo "-h, --help(pomoc),        wyswietla pomoc i konczy dzialanie"
            echo "-v, --version(wersja),    wyswietla informacje o aktualnej wersji i konczy dzialanie"
            echo "-i, --info(informacje),   wyswietla informacje dodatkowe na temat skrypu i konczy dzialanie"

            exit 0
            ;;
        v) 
            echo "DuzySkryptZenity wersja 1.0" 
            echo "Pierwsza wersja programu" 
            exit 0
            ;;
        i) 
            echo "Author           : Adam Karabiniewicz ( s180009@student.pg.edu.pl )"
            echo "Last Modified On : 24.05.2020 (DD.MM.RRRR)"
            echo "Version          : 1.0"
            echo "Description      : Skrypt stworzony na potrzeby przedmiotu Systemy Operacyjne."
            echo "                   Wyszukiwarka plików mp3 według id tagów."
            exit 0
            ;;
    esac
done

RED="\e[0;31m"
GREEN="\e[0;32m"
NATURAL="\e[0m"

CHOICE=0
NAME=""
TITLE=""
AUTHOR=""
ALBUM=""
NO_NAME=""
NO_TITLE=""
NO_AUTHOR=""
NO_ALBUM=""
DIR="./muzyka"
MOVE_DIR="./katalog"

FILE=""
FOUND_MP3=""
FOUND_TITLE=""
FOUND_AUTHOR=""
FOUND_ALBUM=""

BOOL=""
TEMP_TITLE=""
TEMP_AUTHOR=""
TEMP_ALBUM=""
TEMP_FILE=""

MOVE=""
MOVE_FROM=""
MOVE_TO=""

RESULT=""
CONTINUE=""

function choice(){
    case $CHOICE in
        "1 "*) NAME=`zenity --entry --text "Podaj nazwe pliku"`;;
        "2 "*) TITLE=`zenity --entry --text "Podaj tytul pliku"`;;
        "3 "*) AUTHOR=`zenity --entry --text "Podaj autora pliku"`;;
        "4 "*) ALBUM=`zenity --entry --text "Podaj album pliku"`;;
        "5 "*) NO_NAME=`zenity --entry --text "Podaj nazwe pliku do pominiecia"`;;
        "6 "*) NO_TITLE=`zenity --entry --text "Podaj tytul pliku do pominiecia"`;;
        "7 "*) NO_AUTHOR=`zenity --entry --text "Podaj autora pliku do pominiecia"`;;
        "8 "*) NO_ALBUM=`zenity --entry --text "Podaj album pliku do pominiecia"`;;
        "9 "*) DIR=`zenity --entry --text "Podaj ścieżke plików"`;;
        "10"*) MOVE_DIR=`zenity --entry --text "Podaj ścieżke  docelowa przeniesienia"`;;
        "12"*) echo -e "${GREEN}DuzySkrypt zakonczony$NATURAL";;
    esac
}

function menu(){
    MENU=(  "Wyszukaj pliki:"
            "1  - Nazwa pliku:  $NAME"
            "2  - Tytuł:    $TITLE" 
            "3  - Autor:    $AUTHOR"      
            "4  - Album:    $ALBUM" 
            "Z pominieciem plików:"     
            "5  - Nazwa pliku:  $NO_NAME"
            "6  - Tytuł:    $NO_TITLE" 
            "7  - Autor:    $NO_AUTHOR"      
            "8  - Album:    $NO_ALBUM" 
            ""
            "9  -  Szukaj w katalogu:   $DIR"
            "10 - Przenies do katalogu: $MOVE_DIR"
            "11 - Szukaj"
            "12 - Koniec")
    CHOICE=$(
        zenity --list --ok-label="Wybierz opcje (1-12)" \
        --cancel-label="Przerwij skrypt" \
        --text="WYSZUKIWARKA PLIKÓW MP3 WEDŁUG ID TAGÓW" \
        --column=Menu "${MENU[@]}" \
        --width 650 --height 500)
    if [ $? -ne 0 ]; then
        echo -e "${RED}DuzySkrypt przerwany$NATURAL"
        clean_up
        exit 1
    fi
    choice
}

function main(){
    until [ "$CHOICE" == "12 - Koniec" ]
    do
        menu
        if [ "$CHOICE" == "11 - Szukaj" ]; then
            echo -n "" > znalezioneMp3.txt

            if [ "$DIR" != "$MOVE_DIR" ];then
                if [ -n "$MOVE_DIR" ];then
                    MOVE="true"
                else
                    MOVE=""
                fi
            else
                MOVE=""
            fi

            FOUND_MP3=znalezioneMp3.txt

            find $DIR -name "*.mp3" -type f | rev | cut -d '/' -f 1 | rev | while read FILE
            do
                FOUND_TITLE=`id3v2 -l $DIR/"$FILE" | grep TIT2 | cut -d ' ' -f 4-`
                FOUND_AUTHOR=`id3v2 -l $DIR/"$FILE" | grep TPE1 | cut -d ' ' -f 4-`
                FOUND_ALBUM=`id3v2 -l $DIR/"$FILE" | grep TALB | cut -d ' ' -f 4-`

                echo "$FILE" > przechowajNazwe.txt
                echo "$FOUND_TITLE"  > przechowajTytul.txt
                echo "$FOUND_AUTHOR" > przechowajAutor.txt
                echo "$FOUND_ALBUM"  > przechowajAlbum.txt

                BOOL=""
                MOVE_FROM=""
                MOVE_TO=""
                TEMP_TITLE=""
                TEMP_AUTHOR=""
                TEMP_ALBUM=""
                TEMP_FILE=""            

                if [ -n "$NAME" ];then
                    TEMP_FILE=`grep "$NAME" przechowajNazwe.txt`
                    if [ -z "$TEMP_FILE" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$NO_NAME" ];then
                    TEMP_FILE=`grep -v "$NO_NAME" przechowajNazwe.txt`
                    if [ -z "$TEMP_FILE" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$TITLE" ];then
                    TEMP_TITLE=`grep "$TITLE" przechowajTytul.txt`
                    if [ -z "$TEMP_TITLE" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$NO_TITLE" ];then
                    TEMP_TITLE=`grep -v "$NO_TITLE" przechowajTytul.txt`
                    if [ -z "$TEMP_TITLE" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$AUTHOR" ];then
                    TEMP_AUTHOR=`grep "$AUTHOR" przechowajAutor.txt`
                    if [ -z "$TEMP_AUTHOR" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$NO_AUTHOR" ];then
                    TEMP_AUTHOR=`grep -v "$NO_AUTHOR" przechowajAutor.txt`
                    if [ -z "$TEMP_AUTHOR" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$ALBUM" ];then
                    TEMP_ALBUM=`grep "$ALBUM" przechowajAlbum.txt`
                    if [ -z "$TEMP_ALBUM" ];then
                        BOOL="true"
                    fi
                fi
                if [ -n "$NO_ALBUM" ];then
                    TEMP_ALBUM=`grep -v "$NO_ALBUM" przechowajAlbum.txt`
                    if [ -z "$TEMP_ALBUM" ];then
                        BOOL="true"
                    fi
                fi

                if [ -z "$BOOL" ];then
                    echo -n "$FILE\n" >> "$FOUND_MP3"

                    if [ -n "$MOVE" ];then
                        MOVE_FROM="$DIR/$FILE"
                        MOVE_TO="$MOVE_DIR/$FILE"

                        mv "$MOVE_FROM" "$MOVE_TO"
                    fi
                fi

                FOUND_MP3=znalezioneMp3.txt
            done
            read -r RESULT < znalezioneMp3.txt

            if [ -n "$RESULT" ]; then
                if [ -n "$MOVE" ];then
                    zenity --info --title "Znaleziono plik/pliki i przeniesiono do podanego katalogu" --text "$RESULT" --width 550
                else
                    zenity --info --title "Znaleziono plik/pliki, lecz nie zostaly przeniesione" --text "$RESULT" --width 550
                fi
            else
                zenity --warning --text "Nie znaleziono pliku/plików" --width 275
    	    fi   
        fi  
    done
}

function clean_up(){
    if [ -e przechowajAlbum.txt ];then
        rm przechowajAlbum.txt
        rm przechowajAutor.txt
        rm przechowajNazwe.txt
        rm przechowajTytul.txt
        rm znalezioneMp3.txt
    fi
}

clear
echo -e "DuzySkrypt ${GREEN}START$NATURAL"

main

clean_up
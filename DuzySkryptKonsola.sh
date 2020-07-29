#!/bin/bash
# Author           : Adam Karabiniewicz ( s180009@student.pg.edu.pl )
# Created On       : 21.05.2020 (DD.MM.RRRR)
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
            echo -e "\nSkładnia: ./DuzySkryptKonsola.sh [OPCJA...]\n"
            echo "-h, --help(pomoc),        wyswietla pomoc i konczy dzialanie"
            echo "-v, --version(wersja),    wyswietla informacje o aktualnej wersji i konczy dzialanie"
            echo "-i, --info(informacje),   wyswietla informacje dodatkowe na temat skrypu i konczy dzialanie"

            exit 0
            ;;
        v) 
            echo "DuzySkryptKonsola wersja 1.0" 
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
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
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
MOVE_DIR=$DIR

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
    read CHOICE
    clear
    case $CHOICE in
        1) echo "Podaj nazwe pliku: "; read NAME;;
        2) echo "Podaj tytul pliku: "; read TITLE;;
        3) echo "Podaj autora pliku: "; read AUTHOR;;
        4) echo "Podaj album pliku: "; read ALBUM;;
        5) echo "Podaj nazwe pliku do pominiecia: "; read NO_NAME;;
        6) echo "Podaj tytul pliku do pominiecia: "; read NO_TITLE;;
        7) echo "Podaj autora pliku do pominiecia: ";read NO_AUTHOR;;
        8) echo "Podaj album pliku do pominiecia: "; read NO_ALBUM;;
        9) echo "Podaj ścieżke plików: "; read DIR;;
        10) echo "Podaj ścieżke docelowa przeniesienia: "; read MOVE_DIR;;
        12) echo -e "${GREEN}DuzySkrypt zakonczony$NATURAL";;
    esac
}

function menu(){
    echo -e "${GREEN}Wyszukaj pliki:"
    echo -e "${BLUE}1)  Nazwa pliku:${GREEN}" $NAME
    echo -e "${BLUE}2)  Tytuł:${GREEN}" $TITLE
    echo -e "${BLUE}3)  Autor:${GREEN}" $AUTHOR      
    echo -e "${BLUE}4)  Album:${GREEN}" $ALBUM
    echo -e "${RED}Z pominieciem plików:"
    echo -e "${BLUE}5)  Nazwa pliku:${GREEN}" $NO_NAME
    echo -e "${BLUE}6)  Tytuł:${GREEN}" $NO_TITLE
    echo -e "${BLUE}7)  Autor:${GREEN}" $NO_AUTHOR      
    echo -e "${BLUE}8)  Album:${GREEN}" $NO_ALBUM
    echo -e ""
    echo -e "${BLUE}9)  Szukaj w katalogu:${GREEN}" $DIR
    echo -e "${BLUE}10) Przenies do katalogu:${GREEN}" $MOVE_DIR
    echo -e "${BLUE}11) Szukaj"
    echo -e "${BLUE}12) Koniec$NATURAL"
    choice
}

function clean_up(){
    rm przechowajAlbum.txt
    rm przechowajAutor.txt
    rm przechowajNazwe.txt
    rm przechowajTytul.txt
    rm znalezioneMp3.txt
}
clear
echo -e "DuzySkrypt ${GREEN}START$NATURAL"

until [ $CHOICE -eq 12 ]
do
    menu
    clear
    if [ $CHOICE -eq 11 ]; then
        echo -n "" > znalezioneMp3.txt

        if [ "$DIR" = "$MOVE_DIR" ];then
            echo -e "${YELLOW}Scieżki katalogów są takie same,"
            echo -e "nie nastepuje przeniesienie"
        
        elif [ -z "$MOVE_DIR" ];then
            echo -e "${YELLOW}Scieżka katalogu do przeniesienia jest pusta,"
            echo -e "nie nastepuje przeniesienie"
        
        else
            echo -e "${YELLOW}Proba przeniesienia plikow"
            MOVE="true"
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
        
        echo -e "${BLUE}\nZnalezione pliki:${GREEN}"
        echo -e $RESULT

        if [ -n "$MOVE" ];then
            echo -e "${BLUE}Dane pliki przeniesione do folderu:"
            echo -e "${GREEN}"$MOVE_DIR
        fi
        echo -e "${BLUE}\nKliknij aby kontynuować"
        read $CONTINUE
        clear       
    fi  
done

clean_up

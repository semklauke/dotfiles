#
# Switching fast between directorys of differen courses at my university
# Also inbetween semester
# 

export CURRENT_SEMESTER=4;
function getCourseFolderName() {
    case $1 in
        progra)             echo "Programmierung" ;;
        ds)                 echo "Diskrete Strukturen" ;;
        afi)                echo "Analysis für Informatiker" ;;
        mentoring)          echo "Mentoring" ;;
        ti)                 echo "Technische Informatik" ;;
        bus)                echo "Betriebssysteme und Systemsoftware" ;;
        dsal)               echo "Datenstrukturen und Algorithmen" ;;
        fosap)              echo "FoSAP" ;;
        la)                 echo "Lineare Algebra" ;;
        lina)               echo "Lineare Algebra" ;;
        stocha)             echo "Stochastik" ;;
        stochastik)         echo "Stochastik" ;;
        buk)                echo "Berechenbarkeit und Komplexität" ;;
        mecha1)             echo "Mechanik 1" ;;
        mechanik1)          echo "Mechanik 1" ;;
        prosem)             echo "ProSem" ;;
        proseminar)         echo "ProSem" ;;
        swt)                echo "Softwaretechnick" ;;
        dbis)               echo "Datenbanken und Informationssysteme" ;;
        et2)                echo "Elektrotechnik 2" ;;
        elektrotechnik2)    echo "Elektrotechnik 2" ;;
        psp)                echo "Praktikum Systemprogrammierung" ;;
        hpc)                echo "Soft.Praktikum" ;;
        softprak)           echo "Soft.Praktikum" ;;
        softpraktikum)      echo "Soft.Praktikum" ;;
        sp)                 echo "Soft.Praktikum" ;;
        *)                  echo "404" ;;
    esac
}

function uni() {
    local UNIPREFIX="/Users/semklauke/Dropbox/UNI"
    local SEM=${2:-$CURRENT_SEMESTER}
    local SEMSTRING="$SEM-Semester"
    local COURSE=$(getCourseFolderName ${1})
    if [[ $COURSE == "404" ]]; then
        echo "${1} not found!"
        return 1;
    fi
    while true; do
        if [[ -d "$UNIPREFIX/$SEMSTRING/$COURSE" ]]; then
            echo "$COURSE, $SEM Sem."
            cd "$UNIPREFIX/$SEMSTRING/$COURSE";
            return 0;
        else
             SEM=$(($SEM-1))
             SEMSTRING="$SEM-Semester"
             if [[ $SEM -eq 0 ]]; then break; fi
        fi
    done
    echo "No semester for ${1} found"
    return 2;
    
}

alias uni-1="cd /Users/semklauke/Dropbox/UNI/1-Semester"
alias uni-2="cd /Users/semklauke/Dropbox/UNI/2-Semester"
alias uni-3="cd /Users/semklauke/Dropbox/UNI/3-Semester"
alias uni-4="cd /Users/semklauke/Dropbox/UNI/4-Semester"

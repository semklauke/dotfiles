#
# Switching fast between directorys of differen courses at my university
# Also inbetween semester
# 

export CURRENT_SEMESTER=18;
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
        hpcsem)             echo "HPC Seminar" ;;
        cg)                 echo "Computer Graphics" ;;
        cg1)                echo "Computer Graphics" ;;
        swt)                echo "Softwaretechnick" ;;
        dbis)               echo "Datenbanken und Informationssysteme" ;;
        et2)                echo "Elektrotechnik 2" ;;
        elektrotechnik2)    echo "Elektrotechnik 2" ;;
        psp)                echo "Praktikum Systemprogrammierung" ;;
        manycore)           echo "Soft.Praktikum" ;;
        openmp)             echo "Soft.Praktikum" ;;
        softprak)           echo "Soft.Praktikum" ;;
        softpraktikum)      echo "Soft.Praktikum" ;;
        sp)                 echo "Soft.Praktikum" ;;
        pdp)                echo "PDP" ;;
        datkom)             echo "Datenkommunikation und Sicherheit" ;;
        lp)                 echo "Logikprogrammierung" ;;
        or)                 echo "Operations Research" ;;
        cc)                 echo "Compilerbau" ;;
        rewe)               echo "Buchführung und internes Rechungswesen" ;;
        elehre)             echo "Entscheidungslehre" ;;
        leo)                echo "Leonardo" ;;
        ntw)                echo "Leonardo" ;;
        pca)                echo "PerformanceCorrectnessAnalysisParallelPrograms" ;;
        emsys)              echo "Embedded Systems" ;;
        malo)               echo "Mathematische Logik" ;;
        hiwi)               echo "../HiWi-OR" ;;
        hiwi-or)            echo "../HiWi-OR" ;;
        hiwi-or1)           echo "../HiWi-OR/WS25-OR1" ;;
        hiwi-qm)            echo "../HiWi-OR/SS26-QM" ;;
        hiwi-qm-26)         echo "../HiWi-OR/SS26-QM" ;;
        qm)                 echo "../HiWi-OR/SS26-QM" ;;
        hiwi-qm-25)         echo "../HiWi-OR/SS25-QM" ;;
        pmi)                echo "../HiWi-PMI" ;;
        hiwi-pmi)           echo "../HiWi-PMI" ;;
        hpc)                echo "HPC" ;;
        iai)                echo "Introduction to Artificial Intelligence" ;;
        ai)                 echo "Introduction to Artificial Intelligence" ;;
        gp)                 echo "Geometry Processing" ;;
        afd)                echo "Algorithmic Foundations of Datascience" ;;
        ba)                 echo "BA" ;;
        bachelor)           echo "BA" ;;
        ct)                 echo "Concurrency Theory";;
        plexi)              echo "Complexity Theory";;
        ad)                 echo "Algorithmic Differentiation";;
        mlds)               echo "Elements of Machine Learning and Data Science";;
        emlds)              echo "Elements of Machine Learning and Data Science";;
        cse)                echo "Communication Systems Engineering";;
        bpi)                echo "Business Process Intelligence";;
        fp)                 echo "Functional Programming";;
        qc)                 echo "Introduction to Quantum Computing";;
        pom)                echo "Practical Optimization with Modeling Languages";;
        spa)                echo "Static Program Analysis";;
        or1)                echo "Operations Research 1" ;;
        or2)                echo "Operations Research 2" ;;
        or3)                echo "Operations Research 3" ;;
        mc)                 echo "Model Checking" ;;
        ml)                 echo "Machine Learning" ;;
        svs)                echo "Semantics and Verification of Software" ;;
        hpmc)               echo "High-Performance Matrix Computations" ;;
        lkp)                echo "Linux Kernel Programming" ;;
        sprachkurs)         echo "Sprachkurs" ;;
        english)            echo "Sprachkurs" ;;
        aml)                echo "Advanced Machine Learning" ;;
        ml2)                echo "Advanced Machine Learning" ;;
        orp)                echo "OR Praktikum" ;;
        aos)                echo "Advanced Operating Systems" ;;
        pqc)                echo "Post-quantum cryptography" ;;
        sat)                echo "Satisfiability Checking" ;;
        ids)                echo "Introduction to Data Science" ;;
        optia)              echo "Nonlinear Optimization" ;;
        nlo)                echo "Nonlinear Optimization" ;;
        glo)                echo "Integer Linear Optimization" ;;
        ilo)                echo "Integer Linear Optimization" ;;
        ma)                 echo "MA" ;;
        cgsem)              echo "CG Seminar" ;;
        optisem)            echo "Discrete and Combinatorial Optimization" ;;
        satsem)             echo "Seminar Satisfiability Checking" ;;
        disco)              echo "Discrete and Combinatorial Optimization" ;;
        ait)                echo "Advanced Internet Technology" ;;
        pet)                echo "Privacy Enhancing Technologies for Data Science" ;;
        sem)                echo "Seminar Satisfiability Checking" ;;
        *)                  echo "404" ;;
    esac
}

function uni() {
    local UNIPREFIX="/Users/semklauke/Dropbox/UNI"
    local SEM=${2:-$CURRENT_SEMESTER}
    local SEMSTRING="$SEM-Semester"
    local SKIPS=0
    local COURSE=$(getCourseFolderName ${1})
    if [[ $COURSE == "404" ]]; then
        echo "${1} not found!"
        return 1;
    fi
    if [[ $SEM =~ ^-?[0-9]+$ && $SEM -lt 0 ]]; then
        # negativ semester, hence set skips
        SKIPS=$(($SEM*(-1)))
        SEM=$CURRENT_SEMESTER
        SEMSTRING="$SEM-Semester"
    fi
    while true; do
        if [[ -d "$UNIPREFIX/$SEMSTRING/$COURSE" ]]; then
            if [[ $SKIPS -eq 0 ]]; then
                echo "$COURSE, $SEM Sem."
                cd "$UNIPREFIX/$SEMSTRING/$COURSE";
                return 0;
            else
                SKIPS=$(($SKIPS-1))
            fi
        fi
        SEM=$(($SEM-1))
        SEMSTRING="$SEM-Semester"
        if [[ $SEM -eq 0 ]]; then break; fi
    done
    echo "No semester for ${1} found"
    return 2;
}

function uni-alfred() {
    local UNIPREFIX="/Users/semklauke/Dropbox/UNI"
    local SEM=${2:-$CURRENT_SEMESTER}
    local SEMSTRING="$SEM-Semester"
    local COURSE=$(getCourseFolderName ${1})
    if [[ $COURSE == "404" ]]; then
        echo "ERROR"
        return 1;
    fi
    while true; do
        if [[ -d "$UNIPREFIX/$SEMSTRING/$COURSE" ]]; then
            echo "$UNIPREFIX/$SEMSTRING/$COURSE";
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
alias uni-5="cd /Users/semklauke/Dropbox/UNI/5-Semester"
alias uni-6="cd /Users/semklauke/Dropbox/UNI/6-Semester"
alias uni-7="cd /Users/semklauke/Dropbox/UNI/7-Semester"
alias uni-8="cd /Users/semklauke/Dropbox/UNI/8-Semester"
alias uni-9="cd /Users/semklauke/Dropbox/UNI/9-Semester"
alias uni-10="cd /Users/semklauke/Dropbox/UNI/10-Semester"
alias uni-11="cd /Users/semklauke/Dropbox/UNI/11-Semester"
alias uni-12="cd /Users/semklauke/Dropbox/UNI/12-Semester"
alias uni-13="cd /Users/semklauke/Dropbox/UNI/13-Semester"
alias uni-14="cd /Users/semklauke/Dropbox/UNI/14-Semester"
alias uni-15="cd /Users/semklauke/Dropbox/UNI/15-Semester"
alias uni-16="cd /Users/semklauke/Dropbox/UNI/16-Semester"
alias uni-17="cd /Users/semklauke/Dropbox/UNI/17-Semester"
alias uni-18="cd /Users/semklauke/Dropbox/UNI/18-Semester"
alias uni-19="cd /Users/semklauke/Dropbox/UNI/19-Semester"
alias uni-20="cd /Users/semklauke/Dropbox/UNI/20-Semester"
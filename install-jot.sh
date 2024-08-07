#!/bin/bash


main() {

    # check if executed with sudo permissions
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run with root permissions"
        exit 1;
    fi


    INSTALL_PATH=/usr/local/bin

    pull_newest_version

    # check if jot is already installed
    if [ -e "$INSTALL_PATH/jot" ]; then
        ask_reset

        if [ $reset -eq 1 ]; then
            # user wants to reset configuration
            
            # individual installation
            reset_file ~/.bashrc
            reset_file ~/.bash_logout

            # global installation
            reset_file /etc/bash.bashrc
            reset_file /etc/bash.bash_logout

            echo "Jot configuration successfully reset"
        fi
    fi


    ask_login
    ask_logoff

    ask_global_install

    individual=0
    if [ $global -eq 0 ]; then
        ask_individual_install
    fi

    # for individual install
    if [ $individual -eq 1 ]; then

        # if requested put into bashrc to run afer login
        if [ $login -eq 1 ]; then

            login_setting=$(file_contains ~/.bashrc "# jot program")
            echo $setting;

            # check if setting is already present
            if [ $login_setting -eq 0 ]; then
                # line not present. adding to file
                echo "jot --login  # jot program" >> ~/.bashrc
            fi



        fi


        # if requested put into bashrc_logoff to run before logoff
        if [ $logoff -eq 1 ]; then

            # create bash_logout file if not exist
            touch ~/.bash_logout

            logoff_setting=$(file_contains ~/.bash_logout "# jot program")

            # check if setting is already present
            if [ $logoff_setting -eq 0 ]; then
                # line not present. adding to file
                echo "jot --logoff  # jot program" >> ~/.bash_logout
            fi



        fi

        exit 0;

    fi

    # for global install
    if [ $global -eq 1 ]; then

        # if requested put into bashrc to run afer login
        if [ $login -eq 1 ]; then

            # create file if not exist
            touch /etc/bash.bashrc

            login_setting=$(file_contains /etc/bash.bashrc "# jot program")

            # check if setting is already present
            if [ $login_setting -eq 0 ]; then
                # line not present. adding to file
                echo "jot --login  # jot program" >> /etc/bash.bashrc
            fi



        fi


        # if requested put into bashrc_logoff to run before logoff
        if [ $logoff -eq 1 ]; then

            # create bash_logout file if not exist
            touch /etc/bash.bash_logout

            logoff_setting=$(file_contains /etc/bash.bash_logout "# jot program")

            # check if setting is already present
            if [ $logoff_setting -eq 0 ]; then
                # line not present. adding to file
                echo "jot --logoff  # jot program" >> /etc/bash.bash_logout
            fi



        fi

        echo "Done! write jot --help for mor information"
        exit 0;

    fi

    

}

pull_newest_version() {
    if [ "$(which wget)" == "" ]; then
        echo "wget not installed. Please install wget to proceed!";
        exit 1;
    fi

    echo "pulling newest version from repo..."; 
    
    # downloading newest version from repo
    wget -q https://raw.githubusercontent.com/vozodo/jot/main/jot.sh -P $INSTALL_PATH
    
    # rename jot.sh to jot
    mv $INSTALL_PATH/jot.sh $INSTALL_PATH/jot

    # change permissions
    chmod +x $INSTALL_PATH/jot
}

ask_login () {
    login=0;
    read -p "Should JOT ask you at login? [Y/N] " login
    case $login in
        [Yy]* ) login=1;;
        [Nn]* ) login=0;;
        * ) echo "Please answer yes or no. " && exit;;
    esac
}

ask_logoff () {
    logoff=0;
    read -p "Should JOT ask you at logout? [Y/N] " logoff
    case $logoff in
        [Yy]* ) logoff=1;;
        [Nn]* ) logoff=0;;
        * ) echo "Please answer yes or no. " && exit;;
    esac
}

ask_global_install () {
    global=0;
    read -p "Install JOT for all Users? [Y/N] " global
    case $global in
        [Yy]* ) global=1;;
        [Nn]* ) global=0;;
        * ) echo "Please answer yes or no. " && exit;;
    esac
}

ask_individual_install () {
    individual=0;
    read -p "Install JOT only for User $USER? [Y/N] " individual
    case $individual in
        [Yy]* ) individual=1;;
        [Nn]* ) individual=0;;
        * ) echo "Please answer yes or no. " && exit;;
    esac
}

ask_reset () {
    reset=0;
    read -p "Reset JOT configuration (jot history remains) [Y/N] " reset
    case $reset in
        [Yy]* ) reset=1;;
        [Nn]* ) reset=0;;
        * ) echo "Please answer yes or no. " && exit;;
    esac
}


file_contains() {
    local file=$1
    local keyword=$2

    if grep -q "$keyword" $file; then
        echo 1;
        return 0;
    fi
    echo 0;
    return 0;

}

reset_file() {
    local file=$1

    sed -i '/# jot program/d' $file
}

main "$@"

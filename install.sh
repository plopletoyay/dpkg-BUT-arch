#!/bin/bash

chmod +x "$0" 2>/dev/null
clear

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN_256='\e[38;5;82m'
NC='\033[0m'

TARGET="/usr/local/bin/apt"
SOURCE_URL="https://raw.githubusercontent.com/plopletoyay/dpkg-BUT-arch/main/apt"

show_banner() {
    echo -e "${BLUE}"
    echo "  ____  ____  _  _______      __                                 "
    echo " |  _ \|  _ \| |/ / ____|     \ \      Format: dpkg-wrapper      "
    echo " | | | | |_) | ' / |  _        \ \     Status: Ready             "
    echo " | |_| |  __/| . \ |_| |        \ \    Target: $TARGET           "
    echo " |____/|_|   |_|\_\____|         \_\                             "
    echo "  ___ _   _ ____ _____  _    _     _                             "
    echo " |_ _| \ | / ___|_   _|/ \  | |   | |                            "
    echo "  | ||  \| \___ \ | | / _ \ | |   | |                            "
    echo "  | || |\  |___) || |/ ___ \| |___| |___                         "
    echo " |___|_| \_|____/ |_/_/   \_\_____|_____|                        "
    echo -e "${NC}"
}

show_disclaimer() {
    echo -e "${RED}==============================================================${NC}"
    echo -e "${RED}  README & DISCLAIMER${NC}"
    echo -e "${RED}==============================================================${NC}"
    echo -e " * This script is only an ${BLUE}alias/wrapper${NC} for pacman and yay."
    echo -e " * We ${RED}DO NOT${NC} recommend using only 'apt'."
    echo -e " * We suggest using ${GREEN_256}'pacman'${NC} and ${GREEN_256}'yay'${NC} to learn Arch Linux."
    echo -e " * If you see 'Installation failed', it is a ${RED}real error${NC}."
    echo -e " * Source: https://github.com/plopletoyay/dpkg-BUT-arch"
    echo -e "${RED}==============================================================${NC}"
}

do_install() {
    sudo rm -f "$TARGET"
    echo -e "\nInstalling..."
    sudo curl -L "$SOURCE_URL" -o "$TARGET"
    if [ -f "$TARGET" ]; then
        sudo chmod +x "$TARGET"
        echo -e "${GREEN_256}Installation Successful.${NC}"
        echo -e "Use 'apt help' to get started."
    else
        echo -e "${RED}Installation failed.${NC}"
        sudo rm -f "$TARGET"
        exit 1
    fi
}

do_remove() {
    if [ -f "$TARGET" ]; then
        echo -e "${RED}WARNING: You are about to remove the 'apt' wrapper from your system.${NC}"
        printf "Are you sure you want to proceed? (y/n): "
        read confirm_rm
        if [[ "$confirm_rm" =~ ^[Yy]$ ]]; then
            sudo rm -f "$TARGET"
            echo -e "${GREEN_256}remove Successful.${NC}"
        else
            echo "Removal aborted."
        fi
    else
        echo -e "${RED}Error: apt is not installed.${NC}"
    fi
}


show_banner
sleep 1

show_disclaimer
echo ""

echo -e "What would you like to do?"
echo " 1) Install"
echo " 2) Remove"
echo " 3) Repair"
echo " 4) Cancel"
printf "Choose a number (1/2/3/4): "
read action

case $action in
    1)
        printf "Do you want to install? (y/n): "
        read c1
        printf "ARE YOU SURE NOW? (y/n): "
        read c2
        if [[ "$c1" =~ ^[Yy]$ && "$c2" =~ ^[Yy]$ ]]; then
            do_install
        else
            echo "Installation aborted."
        fi
        ;;
    2)
        do_remove
        ;;
    3)
        printf "Do you want to repair? (y/n): "
        read c1
        if [[ "$c1" =~ ^[Yy]$ ]]; then
            echo -e "${RED}WARNING: Repairing will reinstall the script. Your configs will be reset.${NC}"
            echo " 1) i know what i'm doing"
            echo " 2) no i want my config"
            printf "Choose (1/2): "
            read r_choice
            if [ "$r_choice" == "1" ]; then
               
                if [ -f "$TARGET" ]; then sudo rm -f "$TARGET"; fi
                do_install
                echo -e "${GREEN_256}Repair Successful.${NC}"
            else
                echo -e "Please backup your config file at: ${BLUE}$TARGET${NC}"
                exit 0
            fi
        else
            echo "Repair aborted."
        fi
        ;;
    4)
        echo "Okay."
        sleep 1
        clear
        exit 0
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

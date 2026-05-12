#!/bin/bash

chmod +x "$0" 2>/dev/null
clear

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN_256='\e[38;5;82m'
NC='\033[0m'

TARGET="/usr/local/bin/apt"
SOURCE_URL="https://raw.githubusercontent.com/plopletoyay/dpkg-BUT-arch/refs/heads/main/apt"

show_banner() {
    echo -e "${BLUE}"
    echo "  ____  ____  _  _______      __                   "
    echo " |  _ \|  _ \| |/ / ____|      \ \      Format: dpkg-wrapper      "
    echo " | | | | |_) | ' / |  _         \ \      Status: Ready             "
    echo " | |_| |  __/| . \ |_| |         \ \      Target: $TARGET            "
    echo " |____/|_|   |_|\_\____|          \_\                              "
    echo "  ___ _   _ ____ _____  _    _     _                               "
    echo " |_ _| \ | / ___|_   _|/ \  | |   | |                              "
    echo "  | ||  \| \___ \ | | / _ \ | |   | |                              "
    echo "  | || |\  |___) || |/ ___ \| |___| |___                            "
    echo " |___|_| \_|____/ |_/_/   \_\_____|_____|                          "
    echo -e "${NC}"
}

show_disclaimer() {
    echo -e "${RED}==============================================================${NC}"
    echo -e "${RED}  README & DISCLAIMER${NC}"
    echo -e "${RED}==============================================================${NC}"
    echo -e " * This script is only an ${BLUE}alias/wrapper${NC} for pacman and yay."
    echo -e " * We ${RED}DO NOT${NC} recommend using only 'apt'."
    echo -e " * We suggest using ${GREEN_256}'pacman'${NC} and ${GREEN_256}'yay'${NC} to learn Arch Linux."
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
    else
        echo -e "${RED}Installation failed.${NC}"
        sudo rm -f "$TARGET"
        exit 1
    fi
}

while true; do
    clear
    show_banner
    
    sleep 0.5

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
            if [[ ! "$c1" =~ ^[Yy]$ ]]; then continue; fi
            
            printf "Are you sure now? (y/n): "
            read c2
            if [[ "$c2" =~ ^[Yy]$ ]]; then
                do_install
                break
            else
                continue
            fi
            ;;
        2)
            printf "Do you want to remove? (y/n): "
            read r1
            if [[ ! "$r1" =~ ^[Yy]$ ]]; then continue; fi

            printf "Are you sure now? (y/n): "
            read r2
            if [[ "$r2" =~ ^[Yy]$ ]]; then
                if [ -f "$TARGET" ]; then
                    sudo rm -f "$TARGET"
                    echo -e "${GREEN_256}Remove Successful.${NC}"
                    break
                else
                    echo -e "${RED}Error: apt is not installed.${NC}"
                    sleep 2
                fi
            else
                continue
            fi
            ;;
        3)
            printf "Do you want to repair? (Apt config will be reset) (y/n): "
            read rep1
            if [[ ! "$rep1" =~ ^[Yy]$ ]]; then continue; fi

            printf "Are you sure now? (All apt configs will be reset. Please save your file: $TARGET) (y/n): "
            read rep2
            if [[ ! "$rep2" =~ ^[Yy]$ ]]; then continue; fi

            printf "Did you backup your apt config file? (Yes/No): "
            read rep3
            if [[ "$rep3" == "Yes" ]]; then
                do_install
                echo -e "${GREEN_256}Repair Successful.${NC}"
                break
            elif [[ "$rep3" == "No" ]]; then
                echo -e "Please backup your file at: ($TARGET)"
                sleep 3
                continue
            else
                echo "Invalid input. Please type 'Yes' or 'No'."
                sleep 2
                continue
            fi
            ;;
        4)
            printf "Do you want to cancel? (y/n): "
            read can1
            if [[ "$can1" =~ ^[Yy]$ ]]; then
                echo "Exiting..."
                sleep 1
                clear
                exit 0
            else
                continue
            fi
            ;;
        *)
            echo "Invalid choice."
            sleep 1
            ;;
    esac
done

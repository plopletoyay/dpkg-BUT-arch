#!/bin/bash

chmod +x "$0" 2>/dev/null
clear

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN_256='\e[38;5;82m'
NC='\033[0m'

TARGET="/usr/local/bin/apt"
CONF_FILE="/etc/apt-wrapper.conf"
SOURCE_URL="https://raw.githubusercontent.com/plopletoyay/dpkg-BUT-arch/refs/heads/main/apt"

show_banner() {
    echo -e "${BLUE}"
    echo "  ____  ____  _  _______      __                   "
    echo " |  _ \|  _ \| |/ / ____|      \ \      Format: dpkg-wrapper      "
    echo " | | | | |_) | ' / |  _          \ \      Status: Ready             "
    echo " | |_| |  __/| . \ |_| |          \ \      Target: $TARGET            "
    echo " |____/|_|   |_|\_\____|           \_\                              "
    echo "  ___ _   _ ____ _____  _    _     _                                "
    echo " |_ _| \ | / ___|_   _|/ \  | |   | |                                "
    echo "  | ||  \| \___ \ | | / _ \ | |   | |                                "
    echo "  | || |\  |___) || |/ ___ \| |___| |___                            "
    echo " |___|_| \_|____/ |_/_/   \_\_____|_____|                            "
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

setup_config() {
    if [ -f "$CONF_FILE" ]; then
        echo -e "\n${BLUE}Existing configuration found.${NC}"
        printf "Do you want to use previous settings? (y/n): "
        read reuse_cfg
        if [[ "$reuse_cfg" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN_256}Using existing config.${NC}"
            return 0
        fi
    fi

    echo -e "\n${BLUE}--- Configuration Setting ---${NC}"
    echo -e "This wrapper contains many redundant warnings for dangerous commands."
    echo -e "Do you want to remove those warnings (Enable Silent Mode)?"
    echo -e "${RED}Notice:${NC} Do you want to removing warnings? removing warnings can be dangerous. We are not responsible for any system damage."
    echo -e "You can modify this configuration anytime by using the command: ${BLUE}apt config${NC}"
    
    while true; do
        printf "Please type (yes/no): "
        read cfg_input
        if [ "$cfg_input" == "yes" ]; then
            echo "SILENT_MODE=true" | sudo tee "$CONF_FILE" > /dev/null
            echo -e "${RED}Silent Mode enabled. Warnings removed.${NC}"
            break
        elif [ "$cfg_input" == "no" ]; then
            echo "SILENT_MODE=false" | sudo tee "$CONF_FILE" > /dev/null
            echo -e "${GREEN_256}Standard Mode enabled. Warnings will be shown.${NC}"
            break
        else
            echo -e "${RED}Invalid input. You must type 'yes' or 'no' exactly.${NC}"
        fi
    done
}

do_install() {
    sudo rm -f "$TARGET"
    echo -e "\nInstalling..."
    sudo curl -L "$SOURCE_URL" -o "$TARGET"
    if [ -f "$TARGET" ]; then
        sudo chmod +x "$TARGET"
        setup_config
        echo -e "${GREEN_256}Process Successful.${NC}"
        echo -e "Use 'apt help' to get started."
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
            printf "Do you want to remove 'apt' wrapper and config? (y/n): "
            read r1
            if [[ ! "$r1" =~ ^[Yy]$ ]]; then continue; fi

            printf "Are you sure now? (y/n): "
            read r2
            if [[ "$r2" =~ ^[Yy]$ ]]; then
                if [ -f "$TARGET" ] || [ -f "$CONF_FILE" ]; then
                    sudo rm -f "$TARGET"
                    sudo rm -f "$CONF_FILE"
                    echo -e "${GREEN_256}Wrapper and Configuration file removed successfully.${NC}"
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

            printf "Are you sure now? (y/n): "
            read rep2
            if [[ ! "$rep2" =~ ^[Yy]$ ]]; then continue; fi

            printf "Did you backup your apt config file? (yes/no): "
            read rep3
            if [[ "$rep3" == "yes" ]]; then
                sudo rm -f "$CONF_FILE"
                do_install
                echo -e "${GREEN_256}Repair Successful.${NC}"
                break
            elif [[ "$rep3" == "no" ]]; then
                echo -e "Please backup your config using 'apt config' or save the file at: ($CONF_FILE)"
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
                sleep 1; clear; exit 0
            else
                continue
            fi
            ;;
        *)
            echo "Invalid choice."; sleep 1 ;;
    esac
done

#!/bin/bash

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
    echo " |_ _| \ | / ___|_   _|/ \  | \   | |                                "
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

check_deps() {
    if ! command -v curl > /dev/null 2>&1; then
        echo -e "${RED}[!] 'curl' is required but not installed.${NC}"
        echo -e "    Install it with: ${BLUE}sudo pacman -S curl${NC}"
        exit 1
    fi
}

check_internet() {
    if ! curl -s --max-time 5 --head "https://github.com" > /dev/null 2>&1; then
        echo -e "${RED}[!] No internet connection detected. Cannot proceed.${NC}"
        exit 1
    fi
}

is_installed() {
    [ -f "$TARGET" ]
}

setup_config() {
    if [ -f "$CONF_FILE" ]; then
        echo -e "\n${BLUE}Existing configuration found.${NC}"
        printf "Do you want to use previous settings? (y/n): "
        read -r reuse_cfg
        if [[ "$reuse_cfg" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN_256}Using existing config.${NC}"
            return 0
        fi
    fi

    echo -e "\n${BLUE}--- Configuration Setting ---${NC}"
    echo -e "This wrapper contains many redundant warnings for dangerous commands."
    echo -e "Do you want to remove those warnings (Enable Silent Mode)?"
    echo -e "${RED}Notice:${NC} Removing warnings can be dangerous. We are not responsible for any system damage."
    echo -e "You can modify this configuration anytime by using the command: ${BLUE}apt config${NC}"

    while true; do
        printf "Please type (yes/no): "
        read -r cfg_input
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
    local tmp_file
    tmp_file=$(mktemp /tmp/apt-wrapper.XXXXXX)

    echo -e "\nChecking internet connection..."
    check_internet

    echo -e "Downloading..."
    if ! curl -fsSL "$SOURCE_URL" -o "$tmp_file"; then
        echo -e "${RED}[!] Download failed. Check your connection or the source URL.${NC}"
        rm -f "$tmp_file"
        exit 1
    fi

    if [ ! -s "$tmp_file" ]; then
        echo -e "${RED}[!] Downloaded file is empty. Aborting.${NC}"
        rm -f "$tmp_file"
        exit 1
    fi

    if ! head -1 "$tmp_file" | grep -q "^#!.*bash"; then
        echo -e "${RED}[!] Downloaded file does not appear to be a valid bash script. Aborting.${NC}"
        rm -f "$tmp_file"
        exit 1
    fi

    sudo mv "$tmp_file" "$TARGET"
    sudo chmod +x "$TARGET"

    setup_config

    echo -e "${GREEN_256}Installation successful.${NC}"
    echo -e "Use 'apt help' to get started."
}

do_remove() {
    if ! is_installed && [ ! -f "$CONF_FILE" ]; then
        echo -e "${RED}[!] apt is not installed.${NC}"
        sleep 2
        return 1
    fi
    sudo rm -f "$TARGET"
    sudo rm -f "$CONF_FILE"
    echo -e "${GREEN_256}Wrapper and configuration file removed successfully.${NC}"
    return 0
}

do_repair() {
    check_deps

    if [ -f "$CONF_FILE" ]; then
        local backup_path="/tmp/apt-wrapper.conf.bak"
        sudo cp "$CONF_FILE" "$backup_path"
        echo -e "${BLUE}[*] Config backed up to: ${backup_path}${NC}"
        sudo rm -f "$CONF_FILE"
    fi

    do_install
    echo -e "${GREEN_256}Repair successful.${NC}"
}

while true; do
    clear
    show_banner
    show_disclaimer

    if is_installed; then
        echo -e " Status: ${GREEN_256}Installed${NC} ($TARGET)"
    else
        echo -e " Status: ${RED}Not installed${NC}"
    fi

    echo ""
    echo -e "What would you like to do?"
    echo " 1) Install"
    echo " 2) Remove"
    echo " 3) Repair"
    echo " 4) Cancel"
    printf "Choose a number (1/2/3/4): "
    read -r action

    case $action in
        1)
            if is_installed; then
                echo -e "\n${BLUE}[*] apt is already installed. This will reinstall it.${NC}"
            fi

            printf "Do you want to install? (y/n): "
            read -r c1
            [[ ! "$c1" =~ ^[Yy]$ ]] && continue

            printf "Are you sure now? (y/n): "
            read -r c2
            [[ ! "$c2" =~ ^[Yy]$ ]] && continue

            check_deps
            do_install
            break
            ;;

        2)
            printf "Do you want to remove the 'apt' wrapper and config? (y/n): "
            read -r r1
            [[ ! "$r1" =~ ^[Yy]$ ]] && continue

            printf "Are you sure now? (y/n): "
            read -r r2
            [[ ! "$r2" =~ ^[Yy]$ ]] && continue

            do_remove && break
            ;;

        3)
            printf "Do you want to repair? (Config will be reset and auto-backed up) (y/n): "
            read -r rep1
            [[ ! "$rep1" =~ ^[Yy]$ ]] && continue

            printf "Are you sure now? (y/n): "
            read -r rep2
            [[ ! "$rep2" =~ ^[Yy]$ ]] && continue

            do_repair
            break
            ;;

        4)
            printf "Do you want to cancel? (y/n): "
            read -r can1
            if [[ "$can1" =~ ^[Yy]$ ]]; then
                echo "Exiting..."
                sleep 1; clear; exit 0
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

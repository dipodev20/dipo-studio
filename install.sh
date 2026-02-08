#!/bin/bash
#═══════════════════════════════════════════════════════════════════════════════
# 🚀 DIPO STUDIO INSTALLER
#═══════════════════════════════════════════════════════════════════════════════

# Цвета
PURPLE='\033[38;5;135m'
BLUE='\033[38;5;75m'
CYAN='\033[38;5;51m'
PINK='\033[38;5;213m'
GREEN='\033[38;5;82m'
YELLOW='\033[38;5;226m'
RED='\033[38;5;196m'
WHITE='\033[38;5;255m'
GRAY='\033[38;5;245m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Очистка экрана
clear

# Анимация загрузки
loading_animation() {
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local message="$1"
    local duration=${2:-2}
    local end=$((SECONDS + duration))
    
    while [ $SECONDS -lt $end ]; do
        for frame in "${frames[@]}"; do
            printf "\r${CYAN}  ${frame}${RESET} ${message}"
            sleep 0.1
        done
    done
    printf "\r${GREEN}  ✓${RESET} ${message}\n"
}

# Прогресс бар
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r  ${GRAY}[${RESET}"
    printf "${PURPLE}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${GRAY}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "${GRAY}]${RESET} ${WHITE}${percent}%%${RESET}"
}

# Главный баннер
echo ""
echo -e "${PURPLE}${BOLD}"
cat << 'EOF'
    ██████╗ ██╗██████╗  ██████╗ 
    ██╔══██╗██║██╔══██╗██╔═══██╗
    ██║  ██║██║██████╔╝██║   ██║
    ██║  ██║██║██╔═══╝ ██║   ██║
    ██████╔╝██║██║     ╚██████╔╝
    ╚═════╝ ╚═╝╚═╝      ╚═════╝ 
EOF
echo -e "${RESET}"

echo -e "${BLUE}${BOLD}    ███████╗████████╗██╗   ██╗██████╗ ██╗ ██████╗ ${RESET}"
echo -e "${CYAN}${BOLD}    ██╔════╝╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗${RESET}"
echo -e "${PURPLE}${BOLD}    ███████╗   ██║   ██║   ██║██║  ██║██║██║   ██║${RESET}"
echo -e "${PINK}${BOLD}    ╚════██║   ██║   ██║   ██║██║  ██║██║██║   ██║${RESET}"
echo -e "${PURPLE}${BOLD}    ███████║   ██║   ╚██████╔╝██████╔╝██║╚██████╔╝${RESET}"
echo -e "${BLUE}${BOLD}    ╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ ${RESET}"
echo ""
echo -e "${GRAY}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${WHITE}${BOLD}       ⚡ REVOLUTIONARY CODE EDITOR v3.0 ⚡${RESET}"
echo -e "${GRAY}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

sleep 1

# Определяем систему
echo -e "${CYAN}${BOLD}  ▸ Определение системы...${RESET}"
sleep 0.5

if [ -d "/data/data/com.termux" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    PROFILE="$HOME/.bashrc"
    SYSTEM="termux"
    echo -e "${GREEN}  ✓${RESET} ${PURPLE}📱 Termux${RESET} обнаружен"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    INSTALL_DIR="/usr/local/bin"
    PROFILE="$HOME/.zshrc"
    SYSTEM="macos"
    echo -e "${GREEN}  ✓${RESET} ${PURPLE}🍎 macOS${RESET} обнаружен"
else
    INSTALL_DIR="$HOME/.local/bin"
    PROFILE="$HOME/.bashrc"
    SYSTEM="linux"
    echo -e "${GREEN}  ✓${RESET} ${PURPLE}🐧 Linux${RESET} обнаружен"
fi

sleep 0.3

# Проверяем Python
echo -e "${CYAN}${BOLD}  ▸ Проверка Python...${RESET}"
sleep 0.5

if command -v python3 &> /dev/null; then
    PY_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo -e "${GREEN}  ✓${RESET} Python ${PURPLE}${PY_VERSION}${RESET} найден"
else
    echo -e "${RED}  ✗${RESET} Python3 не найден!"
    echo ""
    echo -e "${YELLOW}  Установите Python:${RESET}"
    if [ "$SYSTEM" = "termux" ]; then
        echo -e "${WHITE}    pkg install python${RESET}"
    else
        echo -e "${WHITE}    sudo apt install python3${RESET}"
    fi
    echo ""
    exit 1
fi

sleep 0.3

# Проверяем curl
echo -e "${CYAN}${BOLD}  ▸ Проверка curl...${RESET}"
sleep 0.3

if command -v curl &> /dev/null; then
    echo -e "${GREEN}  ✓${RESET} curl найден"
else
    echo -e "${YELLOW}  ⚠${RESET} curl не найден, устанавливаю..."
    if [ "$SYSTEM" = "termux" ]; then
        pkg install curl -y > /dev/null 2>&1
    else
        sudo apt install curl -y > /dev/null 2>&1
    fi
    echo -e "${GREEN}  ✓${RESET} curl установлен"
fi

sleep 0.5

# Создаём директорию
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${PURPLE}${BOLD}  📦 УСТАНОВКА${RESET}"
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}  ✓${RESET} Директория ${CYAN}$INSTALL_DIR${RESET}"

sleep 0.3

# Скачиваем
echo -e "${CYAN}${BOLD}  ▸ Загрузка Dipo Studio...${RESET}"
echo ""

REPO_URL="https://raw.githubusercontent.com/dipodev20/dipo-studio/main/dipo"

# Анимация прогресса
for i in {1..40}; do
    progress_bar $i 40
    sleep 0.03
done
echo ""

# Реальная загрузка
if curl -fsSL "$REPO_URL" -o "$INSTALL_DIR/dipo" 2>/dev/null; then
    echo -e "${GREEN}  ✓${RESET} Файл загружен"
else
    echo -e "${RED}  ✗${RESET} Ошибка загрузки!"
    echo -e "${YELLOW}  Проверьте интернет-соединение${RESET}"
    exit 1
fi

sleep 0.3

# Делаем исполняемым
chmod +x "$INSTALL_DIR/dipo"
echo -e "${GREEN}  ✓${RESET} Права установлены"

sleep 0.3

# Добавляем в PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$PROFILE"
    echo -e "${GREEN}  ✓${RESET} Добавлено в PATH"
else
    echo -e "${GREEN}  ✓${RESET} PATH уже настроен"
fi

sleep 0.5

# Финальный баннер
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${GREEN}${BOLD}  ✨ УСТАНОВКА ЗАВЕРШЕНА! ✨${RESET}"
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${WHITE}${BOLD}  📋 КОМАНДЫ:${RESET}"
echo ""
echo -e "${CYAN}    dipo${RESET}              ${GRAY}— открыть редактор${RESET}"
echo -e "${CYAN}    dipo file.py${RESET}      ${GRAY}— открыть файл${RESET}"
echo -e "${CYAN}    dipo --ai-setup${RESET}   ${GRAY}— настроить AI${RESET}"
echo -e "${CYAN}    dipo --help${RESET}       ${GRAY}— справка${RESET}"
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${WHITE}${BOLD}  ⌨️  ГОРЯЧИЕ КЛАВИШИ:${RESET}"
echo ""
echo -e "${PURPLE}    F1${RESET}   ${GRAY}— Справка${RESET}         ${PURPLE}F5${RESET}   ${GRAY}— Запуск кода${RESET}"
echo -e "${PURPLE}    F10${RESET}  ${GRAY}— AI помощник${RESET}     ${PURPLE}F6${RESET}   ${GRAY}— Проводник${RESET}"
echo -e "${PURPLE}    ^S${RESET}   ${GRAY}— Сохранить${RESET}       ${PURPLE}^Q${RESET}   ${GRAY}— Выйти${RESET}"
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${YELLOW}${BOLD}  ⚡ СЛЕДУЮЩИЙ ШАГ:${RESET}"
echo ""
echo -e "${WHITE}    source $PROFILE${RESET}"
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${PURPLE}  📱 Telegram: ${CYAN}@MARADANIL${RESET}"
echo -e "${BLUE}  🔗 ${CYAN}https://t.me/DIPO_OFFICIAL${RESET}"
echo ""
echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

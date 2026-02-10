#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# 🚀 DIPO STUDIO - INSTALLATION SCRIPT
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Версия
VERSION="2.0.0"
REPO_URL="https://github.com/MARADANIL/dipo-studio"
RAW_URL="https://raw.githubusercontent.com/MARADANIL/dipo-studio/main"

# ASCII Art
show_banner() {
    echo -e "${PURPLE}"
    cat << 'EOF'
    
    ██████╗ ██╗██████╗  ██████╗ 
    ██╔══██╗██║██╔══██╗██╔═══██╗
    ██║  ██║██║██████╔╝██║   ██║
    ██║  ██║██║██╔═══╝ ██║   ██║
    ██████╔╝██║██║     ╚██████╔╝
    ╚═════╝ ╚═╝╚═╝      ╚═════╝ 
                     STUDIO
    
EOF
    echo -e "${CYAN}    🚀 Powerful Code Editor for Mobile Development${NC}"
    echo -e "${WHITE}    Version: ${VERSION}${NC}"
    echo ""
}

# Определение платформы
detect_platform() {
    if [ -d "/data/data/com.termux" ]; then
        PLATFORM="termux"
        INSTALL_DIR="$PREFIX/bin"
        PKG_MANAGER="pkg"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        INSTALL_DIR="$HOME/.local/bin"
        if command -v apt &> /dev/null; then
            PKG_MANAGER="apt"
        elif command -v dnf &> /dev/null; then
            PKG_MANAGER="dnf"
        elif command -v pacman &> /dev/null; then
            PKG_MANAGER="pacman"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        INSTALL_DIR="/usr/local/bin"
        PKG_MANAGER="brew"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        PLATFORM="windows"
        INSTALL_DIR="$HOME/bin"
    else
        PLATFORM="unknown"
        INSTALL_DIR="$HOME/.local/bin"
    fi
}

# Логирование
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Проверка зависимостей
check_dependencies() {
    log_info "Проверка зависимостей..."
    
    # Python
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
        log_success "Python $PYTHON_VERSION найден"
    elif command -v python &> /dev/null; then
        PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2)
        log_success "Python $PYTHON_VERSION найден"
    else
        log_warning "Python не найден, устанавливаем..."
        install_python
    fi
    
    # Git (опционально)
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version | cut -d' ' -f3)
        log_success "Git $GIT_VERSION найден"
    else
        log_warning "Git не найден (опционально для git-интеграции)"
    fi
    
    # curl или wget
    if command -v curl &> /dev/null; then
        DOWNLOADER="curl -sL"
        log_success "curl найден"
    elif command -v wget &> /dev/null; then
        DOWNLOADER="wget -qO-"
        log_success "wget найден"
    else
        log_error "Требуется curl или wget"
        exit 1
    fi
}

# Установка Python
install_python() {
    case $PLATFORM in
        termux)
            pkg install python -y
            ;;
        linux)
            case $PKG_MANAGER in
                apt)
                    sudo apt update && sudo apt install python3 -y
                    ;;
                dnf)
                    sudo dnf install python3 -y
                    ;;
                pacman)
                    sudo pacman -S python --noconfirm
                    ;;
            esac
            ;;
        macos)
            brew install python3
            ;;
    esac
}

# Создание директорий
create_directories() {
    log_info "Создание директорий..."
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$HOME/.dipo"
    mkdir -p "$HOME/.dipo/plugins"
    mkdir -p "$HOME/.dipo/themes"
    mkdir -p "$HOME/.dipo/sessions"
    mkdir -p "$HOME/.dipo/recovery"
    
    log_success "Директории созданы"
}

# Скачивание DIPO
download_dipo() {
    log_info "Скачивание DIPO Studio..."
    
    DIPO_PATH="$INSTALL_DIR/dipo"
    
    # Попытка скачать с GitHub
    if $DOWNLOADER "$RAW_URL/dipo" > "$DIPO_PATH.tmp" 2>/dev/null; then
        mv "$DIPO_PATH.tmp" "$DIPO_PATH"
        chmod +x "$DIPO_PATH"
        log_success "DIPO Studio скачан"
    else
        log_error "Не удалось скачать DIPO Studio"
        log_info "Попробуйте установить вручную:"
        echo "  git clone $REPO_URL ~/.dipo-studio"
        echo "  cp ~/.dipo-studio/dipo $INSTALL_DIR/"
        exit 1
    fi
}

# Добавление в PATH
add_to_path() {
    log_info "Проверка PATH..."
    
    if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        log_success "$INSTALL_DIR уже в PATH"
        return
    fi
    
    # Определить файл конфигурации shell
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    # Добавить в PATH
    echo "" >> "$SHELL_RC"
    echo "# DIPO Studio" >> "$SHELL_RC"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
    
    log_success "Добавлено в $SHELL_RC"
    log_warning "Выполните: source $SHELL_RC"
}

# Проверка установки
verify_installation() {
    log_info "Проверка установки..."
    
    if [ -f "$INSTALL_DIR/dipo" ]; then
        if [ -x "$INSTALL_DIR/dipo" ]; then
            log_success "DIPO Studio установлен успешно!"
            echo ""
            echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║           ✅ УСТАНОВКА ЗАВЕРШЕНА!               ║${NC}"
            echo -e "${GREEN}╠══════════════════════════════════════════════════╣${NC}"
            echo -e "${GREEN}║                                                  ║${NC}"
            echo -e "${GREEN}║  Запуск:     ${WHITE}dipo${GREEN}                              ║${NC}"
            echo -e "${GREEN}║  Справка:    ${WHITE}dipo --help${GREEN}                       ║${NC}"
            echo -e "${GREEN}║  AI:         ${WHITE}dipo ai --setup${GREEN}                   ║${NC}"
            echo -e "${GREEN}║                                                  ║${NC}"
            echo -e "${GREEN}╠══════════════════════════════════════════════════╣${NC}"
            echo -e "${GREEN}║  📱 Telegram: ${CYAN}@MARADANIL${GREEN}                       ║${NC}"
            echo -e "${GREEN}║  📢 Канал: ${CYAN}t.me/DIPO_OFFICIAL${GREEN}                  ║${NC}"
            echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
            return 0
        else
            log_error "Файл не исполняемый"
            return 1
        fi
    else
        log_error "Файл не найден"
        return 1
    fi
}

# Удаление
uninstall() {
    log_info "Удаление DIPO Studio..."
    
    rm -f "$INSTALL_DIR/dipo"
    rm -rf "$HOME/.dipo"
    
    log_success "DIPO Studio удалён"
}

# Обновление
update() {
    log_info "Обновление DIPO Studio..."
    download_dipo
    log_success "DIPO Studio обновлён до версии $VERSION"
}

# Главная функция
main() {
    show_banner
    
    # Обработка аргументов
    case "${1:-}" in
        --uninstall|-u)
            detect_platform
            uninstall
            exit 0
            ;;
        --update)
            detect_platform
            update
            exit 0
            ;;
        --help|-h)
            echo "Использование: $0 [опция]"
            echo ""
            echo "Опции:"
            echo "  (без опций)   Установить DIPO Studio"
            echo "  --update      Обновить до последней версии"
            echo "  --uninstall   Удалить DIPO Studio"
            echo "  --help        Показать эту справку"
            exit 0
            ;;
    esac
    
    # Установка
    detect_platform
    log_info "Платформа: $PLATFORM"
    log_info "Директория: $INSTALL_DIR"
    echo ""
    
    check_dependencies
    create_directories
    download_dipo
    add_to_path
    verify_installation
    
    echo ""
    log_info "Для запуска выполните: dipo"
}

# Запуск
main "$@"

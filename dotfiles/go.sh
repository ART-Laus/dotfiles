#!/bin/bash
#
# go.sh - Универсальный установочный скрипт для Arch, Debian/Ubuntu, и NixOS
#

# Прерываем выполнение скрипт при любой ошибке
set -e

# --- Секция 1: Определение системы и настройка пакетов ---

# Определяем, какой менеджер пакетов использовать и какие пакеты ставить
OS=""
# Arch
PACMAN_PACKAGES="git base-devel fzf exa bat fd zoxide ripgrep jq go-yq htop ncdu httpie dog mtr lazygit zsh entr grim slurp swappy ffmpeg tldr wl-clipboard chafa hyprpaper pywal firefox vlc steam telegram-desktop qbittorrent krita virtualbox virtualbox-host-dkms hyprpicker jpegoptim pngquant rofi"
AUR_PACKAGES="spotify obsidian figma-linux discord"
# Debian/Ubuntu
APT_PACKAGES="git build-essential fzf batcat fd-find zoxide ripgrep jq yq htop ncdu httpie mtr zsh entr ffmpeg tldr wl-clipboard chafa pywal firefox vlc steam telegram-desktop qbittorrent krita virtualbox rofi"
FLATPAK_APPS="com.spotify.Client md.obsidian.Obsidian io.github.Figma_Linux.figma_linux com.discordapp.Discord"


if [ -f /etc/NIXOS ]; then
    OS="NixOS"
elif [ -f /etc/arch-release ]; then
    OS="Arch"
elif [ -f /etc/debian_version ]; then
    OS="Debian"
else
    echo ":: Неподдерживаемая операционная система."
    exit 1
fi

# Проверка на необходимость sudo
SUDO=""
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo"
fi

# --- Секция 2: Выполнение команд в зависимости от системы ---

if [ "$OS" = "NixOS" ]; then
    # Если это NixOS, выводим инструкцию и выходим.
    echo ":: Обнаружена NixOS!"
    echo ":: На NixOS программы устанавливаются декларативно. Вместо запуска установки, вот списки пакетов для вашего configuration.nix или home.nix"
    echo ""
    echo "------------------------------------------------------------------"
    echo "Для вашего home-manager (home.packages):"
    echo "------------------------------------------------------------------"
    echo "
    # Консольные утилиты
    fzf exa bat fd zoxide ripgrep jq yq htop ncdu httpie dog mtr lazygit zsh entr tldr chafa pywal rofi
    # Утилиты для Wayland
    grim slurp swappy hyprpaper hyprpicker wl-clipboard
    # Мультимедиа
    ffmpeg
    # GUI приложения (лучше через systemPackages или Flatpak/Snap в NixOS)
    firefox vlc steam telegram-desktop qbittorrent krita virtualbox
    # Приложения из других источников (нужно настраивать отдельно в Nix)
    # spotify obsidian figma discord
    "
    echo ""
    echo "------------------------------------------------------------------"
    echo ":: Запустите 'home-manager switch' или 'nixos-rebuild switch' после добавления."
    exit 0
fi

# Если это Arch или Debian, продолжаем установку.
echo ":: Обнаружена система: $OS"
echo ":: Обновление системы..."
# Используем 2>/dev/null для подавления ошибки, если одна из команд не найдется, и || для запуска следующей
if [ "$OS" = "Arch" ]; then
    $SUDO pacman -Syu --noconfirm
elif [ "$OS" = "Debian" ]; then
    $SUDO apt update && $SUDO apt upgrade -y
fi


if [ "$OS" = "Arch" ]; then
    echo ":: Установка пакетов из официальных репозиториев (Arch)..."
    $SUDO pacman -S --needed --noconfirm $PACMAN_PACKAGES
    
    if ! command -v yay &> /dev/null; then
        echo ":: Установка AUR-хелпера (yay)..."
        (
            cd /tmp
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si --noconfirm
        )
    else
        echo ":: AUR-хелпера (yay) уже установлен."
    fi
    echo ":: Установка пакетов из AUR..."
    yay -S --needed --noconfirm $AUR_PACKAGES

elif [ "$OS" = "Debian" ]; then
    echo ":: Настройка сторонних репозиториев (Debian/Ubuntu)..."
    $SUDO apt install -y software-properties-common flatpak
    $SUDO add-apt-repository ppa:lazygit-team/release -y
    $SUDO apt update
    
    echo ":: Установка пакетов из apt и PPA..."
    $SUDO apt install -y $APT_PACKAGES lazygit

    echo ":: Настройка Flatpak..."
    $SUDO flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo ":: Установка GUI-приложений через Flatpak..."
    $SUDO flatpak install flathub -y --noninteractive $FLATPAK_APPS
fi


# --- Секция 3: Общие шаги настройки (для Arch и Debian) ---

echo ":: Установка Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo ":: Oh My Zsh уже установлен."
fi

echo ":: Установка менеджера плагинов Tmux (tpm)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo ":: tpm уже установлен."
fi

echo ":: Настройка dotfiles..."
DOTFILES_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

link_dotfile() {
    local source=$1
    local destination=$2
    mkdir -p "$(dirname "$destination")"
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        echo "-----> Найден существующий конфиг. Создание бэкапа: ${destination}.bak"
        mv "$destination" "${destination}.bak"
    fi
    echo "-----> Установка симлинка: ${destination}"
    ln -s "$source" "$destination"
}

# Копируем .zshrc
ZSHRC_DEST="$HOME/.zshrc"
ZSHRC_SRC="$DOTFILES_DIR/zsh/.zshrc"
echo ":: Обработка .zshrc..."
if [ -e "$ZSHRC_DEST" ]; then
    echo "-----> Найден существующий .zshrc. Создание бэкапа: ${ZSHRC_DEST}.bak"
    mv "$ZSHRC_DEST" "${ZSHRC_DEST}.bak"
fi
echo "-----> Копирование: ${ZSHRC_SRC}"
cp "$ZSHRC_SRC" "$ZSHRC_DEST"

# Устанавливаем симлинки для остальных конфигов
link_dotfile "$DOTFILES_DIR/tmux/tmux.conf"          "$HOME/.tmux.conf"
link_dotfile "$DOTFILES_DIR/starship/starship.toml"  "$HOME/.config/starship.toml"
link_dotfile "$DOTFILES_DIR/wezterm/wezterm.lua"     "$HOME/.wezterm.lua"
link_dotfile "$DOTFILES_DIR/alacritty"               "$HOME/.config/alacritty"
link_dotfile "$DOTFILES_DIR/nvim"                    "$HOME/.config/nvim"
link_dotfile "$DOTFILES_DIR/yazi"                    "$HOME/.config/yazi"
link_dotfile "$DOTFILES_DIR/git/.gitconfig"          "$HOME/.gitconfig"
link_dotfile "$DOTFILES_DIR/.gitignore_global"       "$HOME/.gitignore_global"

echo ":: Настройка dotfiles завершена."

# --- Секция 4: Финальная автоматизация ---

echo ":: Установка плагинов Neovim..."
nvim --headless "+Lazy! sync" +qa

echo ":: Установка плагинов Tmux..."
~/.tmux/plugins/tpm/bin/install_plugins

echo ""
echo ":: ВСЕ ГОТОВО!"
echo ":: Не забудьте настроить Zsh как оболочку по умолчанию: chsh -s \$(which zsh)"
echo ":: Для применения всех изменений рекомендуется перезагрузка: sudo reboot"
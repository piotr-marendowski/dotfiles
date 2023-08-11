#!/bin/bash
# Heavily modified version of script made by Derek Taylor (https://gitlab.com/dwt1)
# Author: Piotr Marendowski (https://github.com/piotr-marendowski), License: GPL3
#
# These exports are the only way to specify colors with whiptail.
# See this thread for more info:
# https://askubuntu.com/questions/776831/whiptail-change-background-color-dynamically-from-magenta/781062

currentscript="$0"
# Function that is called when the script exits
function finish {
    shred -u "$currentscript"
}
trap finish EXIT

# colors
export NEWT_COLORS="
root=,black
window=black,black
shadow=black,black
border=white,black
title=white,black
textbox=white,black
radiolist=white,black
label=black,white
checkbox=white,black
listbox=white,black
compactbutton=white,black
button=black,white
actbutton=white,black
entry=black,white
actlistbox=black,white
textbox=white,black 
roottext=white,black
emptyscale=white,black
fullscale=white,white
disentry=white,white
actsellistbox=black,white
sellistbox=white,black"

is_virtualization=false # is virtualization enabled? 
programs=()             # Array of programs to install
exclude=()              # programs to unselect
dir=~/dotfiles          # dotfolders directory
files=(.*)              # files array 

## Configure installed packages in progress bar
# &> /dev/null IS USED TO SEND OUTPUT OF THE COMMANDS INTO THE VOID, SO THEY ARE NOT DISPLAYED ON PROGRESS BAR
configure_installed() {
    # IF USER SELECTS NO THEN GO TO MENU (ELSE IS AT THE BOTTOM OF THE FUNCTION)
	if whiptail --title "Warming" --yesno "Do you want to configure dotfiles?" 7 38; then

        # Make zsh default shell
	    whiptail --title "Shell" --yesno "Do you want to make zsh default shell?" 7 42
        if [ $? -eq 0 ]; then
            sudo chsh -s /bin/zsh
        fi
        
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (1 + 1) / 8))
            echo "$gauge"

            sudo cp -r $dir/assets/TokyoNight /usr/share/themes/ &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (2 + 1) / 8))
            echo "$gauge"

            # make dotfiles
            echo "Searching $dir directory..." &> /dev/null
            cd $dir
            # seach for all files in dir
            files+=($(find . -maxdepth 1 -type d -name '.*')) &> /dev/null
            files+=($(find . -maxdepth 1 -type d \! -name '.*')) &> /dev/null
            files+=($(find . -maxdepth 1 -type f -name '.*')) &> /dev/null
            files+=($(find . -maxdepth 1 -type f \! -name '.*')) &> /dev/null

            echo "Files in $dir: ${files[@]}" &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (3 + 1) / 8))
            echo "$gauge"

            mkdir -p ~/documents &> /dev/null
            mkdir -p ~/games &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (3 + 1) / 8))
            echo "$gauge"

            # Move any dotfile "listed" (present) in dir to olddir and move a file from this
            # repo to program's directory e.g. ~/.config
            echo "Moving dotfiles from $dir to homedir..." &> /dev/null
            echo "DON'T PANIC IF THERE ARE ERRORS!" &> /dev/null
            # hidden files/folders
            for file in ${files[@]}; do
                echo "Moving $file to homedir..." &> /dev/null
                cp -Rf $dir/$file ~/$file &> /dev/null
            done
            echo "done" &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (4 + 1) / 8))
            echo "$gauge"

            # delete unnecessary items
            rm -r ~/assets &> /dev/null
            rm -r ~/install.sh &> /dev/null
            rm -r ~/LICENSE &> /dev/null
            rm -r ~/README.md &> /dev/null
            rm -r ~/.config/.config/ &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (5 + 1) / 8))
            echo "$gauge"

            # Configure Suckless' software
            cd ~/.config/st/ &> /dev/null
            sudo make install &> /dev/null

            cd ~/.config/dmenu/ &> /dev/null
            sudo make install &> /dev/null

            cd ~/.config/dwm/ &> /dev/null
            sudo make install &> /dev/null

            sudo mkdir /usr/share/xsessions/ &> /dev/null
            sudo touch /usr/share/xsessions/dwm.desktop
            sudo printf "[Desktop Entry]\nEncoding=UTF-8\nName=dwm\nComment=DWM\nExec=dwm\nIcon=dwm\nType=XSession\n" > temp.desktop
            sudo cat /usr/share/xsessions/dwm.desktop >> temp.desktop
            sudo mv temp.desktop /usr/share/xsessions/dwm.desktop
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (6 + 1) / 8))
            echo "$gauge"

            # check if pacman -Q name begins with name of ly
            # and enable its service if it is
            echo "Proceeding to check if login manager is installed..." &> /dev/null
            pacman -Q ly | grep -q "^ly" && sudo systemctl enable ly && echo "Ly installed." &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (7 + 1) / 8))
            echo "$gauge"

            # start gamemode
            # systemctl --user enable gamemoded && systemctl --user start gamemoded &> /dev/null
        )
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * (8 + 1) / 8))
            echo "$gauge"

            # virtualization
            if [ "$is_virtualization" = true ]; then

                whiptail --title "VIRTUALIZATION: Warming" --yesno "You need to ensure that these are set to: \
unix_sock_group = \"libvirt\", unix_sock_ro_perms = \"0777\", and unix_sock_rw_perms = \"0770\". \
Do you want to do it now?" 10 80
                if [ $? -eq 0 ]; then
                    sudo nvim /etc/libvirt/libvirtd.conf
                fi

                if systemctl status libvirtd; then
                    sudo groupadd libvirt &> /dev/null
                    local user_name=$(whoami) &> /dev/null
                    sudo usermod -aG libvirt $user_name &> /dev/null
                    sudo systemctl enable libvirtd &> /dev/null
                    sudo systemctl restart libvirtd &> /dev/null
                else
                    echo "libvirt is not installed" &> /dev/null
                fi
                else
                    echo "Virtualization is not configured right now." &> /dev/null
            fi
        )

    else
        menu
    fi
}

# EDIT FOR YOURSELF! won't describe every program because don't care :)
add_programs() {
    # utilities
    # second browser because of some compatibility issues with vieb
	programs+=( "firefox" "vieb-bin" "sioyek" "htim" "polkit" "gnome-polkit" "zip" "unzip" "tar" "ncdu" "libreoffice-fresh" "wget" "curl" "python-pip" "meson" "ninja" "zsh" "zsh-completions" "zsh-syntax-highlighting" "git-delta" )

    # other
	programs+=( "discord-screenaudio" "mellowplayer" "gimp" "ttf-ms-fonts" "flameshot" "neovim" "lazygit" "ripgrep" )

    # sound - pipewire
    # programs+=( "pipewire" "pipewire-audio" "pipewire-alsa" "pipewire-jack" "pipewire-pulse" )
    programs+=( "pipewire" "pipewire-audio" "pipewire-alsa" )

    # gui
    programs+=( "xorg" "xorg-xinit" "ly" "redshift" "picom-jonaburg-git" "ttf-jetbrains-mono-nerd" "lxappearance" )

    # make android phones connect and transfer files
	# programs+=( "mtpfs" "jmtpfs" "gvfs-mtp" "gvfs-gphoto2" )

    # gaming
	whiptail --title "Warming" --yesno "Before installing and configuring system for \
gaming, first you need to enable multilib in pacman.conf in order to install 32-bit drivers. \
Do you want to do it now?" 9 80
	
	if [ $? -eq 0 ]; then
		sudo nvim /etc/pacman.conf
	fi

	# programs+=( "steam" "lutris" "wine-staging" "nvidia-dkms" "nvidia-utils-dkms" "vulkan-icd-loader" "dxvk-bin" "opencl-nvidia" "libvdpau" "libxnvctrl" "lib32-nvidia-utils" "lib32-opencl-nvidia" "lib32-vulkan-icd-loader" "proton-ge-custom-bin" "mangohud-git" "goverlay-bin" "gwe" "protonup-qt-bin" "gamemode" )
    #
    # nvidia-settings

    # virtualization
    # programs+=( "qemu" "libvirt" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils" "openbsd-netcat" "libguestfs" )
    # is_virtualization=true
    
    for CHOICE in $CHOICES; do
        programs+=($CHOICE)
    done
}

install() {
    mkdir -p ~/downloads

	whiptail --title "Warming" --yesno "Do you want to begin installation?" 7 45
	
	if [ $? -eq 0 ]; then
		echo "Installing selected programs..."
		# Check if paru is installed
		if ! command -v paru &> /dev/null; then
            echo "Paru could not be found"
            whiptail --title "Information" --msgbox "This will take a few minutes. If it'll be stuck on Arming ConditionNeedsUpdate \
then reboot system." 9 60
            echo "Proceeding to install Paru AUR helper..."
            clear
            sudo pacman -S --noconfirm --needed base-devel
            cd ~/downloads
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm

            cd ..
            rm -r paru
            echo "done"
		fi

		# Loop through the program names array and install each program using paru
		# --noconfirm to automatically say yes to every installation
        whiptail --title "Program Installation" --gauge "\nDon't panic if its stuck!" 7 50 0 < <(
            for ((i=0; i<${#programs[@]}; i++)); do
                # Install packages and don't print output
                paru -S --noconfirm --quiet "${programs[$i]}" &> /dev/null
                # Update the gauge
                gauge=$((100 * (i + 1) / ${#programs[@]}))
                echo "$gauge"
            done
        )
	fi
}

reboot_now() {
	whiptail --title "Warming" --yesno "Do you want to reboot now?" 7 50

	if [ $? -eq 0 ]; then
		sudo reboot
	fi
}

print_programs() {
    whiptail --title "Programs" --msgbox --scrolltext "$(printf '%s\n' "${programs[@]}")" 20 30
}

add_manually() {
	while true; do
	    program=$(whiptail --ok-button "Add" --inputbox "\nEnter one program at the time:" 9 50 --title "Add a program" 3>&1 1>&2 2>&3)
	    if [ $? = 0 ]; then
            # Add the program name to the programs array
            programs+=("$program")
            else
            # Exit the loop if the user cancels the input
            break
	    fi
	done

	echo "${programs[@]}"
}

unselect_programs() {
	while true; do
	    program=$(whiptail --ok-button "Unselect" --inputbox "\nEnter one program at the time:" 9 50 --title "Unselect a program" 3>&1 1>&2 2>&3)
	    if [ $? = 0 ]; then
            # Add the program name to the programs array
            exclude+=("$program")
            else
            # Exit the loop if the user cancels the input
            break
	    fi
	done

    # unselect programs
    for i in "${exclude[@]}"; do
        programs=("${programs[@]/$i}")
    done

	echo "${programs[@]}"
}

# Menu window
menu() {
	CHOICE=$(
		whiptail --title "Menu" --ok-button "Select" --cancel-button "Exit" --notags --menu "" 12 50 5 \
		"1" "Full installation"  \
		"2" "Configure dotfiles"  \
        "3" "Unselect program(s)" \
        "4" "Add program(s) manually" \
		"5" "Install selected programs" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
            add_programs
            # choose to unselect programs
            whiptail --title "Warming" --yesno "Do you want to unselect programs?" 8 40
            if [ $? -eq 0 ]; then
                unselect_programs
            fi
			install "${programs[@]}"
			configure_installed
            sudo rm /etc/profile.d/firstboot.sh
            sudo rm $dir
			reboot_now
			;;
		"2")   
			configure_installed
			menu
			;;
		"3")   
            unselect_programs
		 	menu
		 	;;
		"4")   
            add_manually
		 	menu
		 	;;
		"5")   
			install "${programs[@]}"
            menu
			;;
	esac
}

### PROGRAM EXECUTION
sudo pacman --noconfirm -Syu

# Navigation
whiptail --title "Navigation" --msgbox "Navigate lists using arrow keys. Select options with space. \
Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

menu

exit

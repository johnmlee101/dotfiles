#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
############################

########## Variables
dir=~/.dotfiles                   # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc aliases env vimrc tmux.conf gitconfig" # list of files/folders to symlink in homedir

NORMAL=$(tput sgr0)  
RED=$(tput setaf 1)  
CYAN=$(tput setaf 6) 
##########

# create dotfiles_old in homedir
echo -e "$CYAN Creating $olddir for backup of any existing dotfiles in ~ $NORMAL"

if [ -d $olddir ]; then
	echo -e "$RED $olddir already exists. Delete it? $NORMAL \c"
	read -p "" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo -e "\n$CYAN Removing $olddir $NORMAL"
		rm -rf $olddir
	fi    
	printf "\n"
fi

mkdir -p $olddir

# move any existing dotfiles in homedir to old dotfiles directory, then create symlinks from the homedir to any files in the dotfiles directory specified in $files
cd $dir
echo -e "$CYAN Moving any existing dotfiles from ~ to $olddir $NORMAL"

for file in $files; do
	mv ~/.$file $olddir 2>/dev/null
	echo -e "$CYAN Creating symlink to $file in home directory $NORMAL"
	ln -s $dir/$file ~/.$file
done

# simlink sublime preferences
read -p "Do you want to update sublime preferences? (Mac only) y/n: " -n 1 -r
echo "\n"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "\n$CYAN Creating symlink for sublime preferences\n"
	mkdir -p "/Users/$USER/Library/Application Support/Sublime Text 3/Packages/User"
	ln -s "$dir/sublime/Preferences.sublime-settings" "/Users/$USER/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
fi


#also move vim folder just in case, no need to link 
mv ~/.vim $olddir 2>/dev/null

# make sure a local rc file exists
touch ~/.local_shellrc

#install vim files
echo -e "$CYAN Installing vim plugins (takes a few seconds) $NORMAL"
vim +VundleInstall +qall
clear

# ask to install oh-my-zsh
echo -e "$RED Install zsh-prezto? (Make sure to install zsh first) $NORMAL \c"
read -p "" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] 
then
	printf "\n"
	bash prezto_install.sh
else 
	printf "\n"
fi

echo -e "\n$CYAN Finished! $NORMAL"

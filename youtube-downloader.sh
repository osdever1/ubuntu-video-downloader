#!/bin/bash

echo "Checking for prerequisites"

if ! command -v yt-dlp &> /dev/null; then
	printf "yt-dlp is not installed, would you like to install it?\ny/n\n\n"
	read yorn

	if [ "$yorn" = "y" ]; then
		sudo add-apt-repository ppa:tomtomtom/yt-dlp && sudo apt update && sudo apt install yt-dlp || brew install yt-dlp && brew upgrade yt-dlp || sudo port install yt-dlp || doas apk -U add yt-dlp || sudo pacman -Syu yt-dlp || scoop install yt-dlp && scoop update yt-dlp || choco install yt-dlp && choco upgrade yt-dlp || winget install yt-dlp && winget upgrade yt-dlp 
		clear
		printf "Checking if yt-dlp is installed\n\n"
		if command -v yt-dlp &> /dev/null; then
			printf "yt-dlp is installed\n\n"
		fi
	else [ "$yorn" = "n" 
		echo "Exiting program"]
		sleep 3
		exit
	fi
else
	printf "You have all the prerequisites required\n\n"
fi

printf "Destination folder, /home/USER/youtube-media\ny/n\n\n"
read yorn

if [ "$yorn" == "y" ]; then
	printf "Enter username of this computer\n\n"
	read username
	two=1
	if ! test -d /home/$username; then
		echo "$username is an invalid username, exiting program"
		sleep 3
		exit
	elif ! test -d /home/$username/youtube-media; then
		mkdir /home/$username/youtube-media
		echo "Folder /home/$username/youtube-media has been created"
	fi
	echo "Folder /home/$username/youtube-media exists, using."

else [ "$yorn" == "n" ]
	printf "Give destination folder location\n\n"
	read destination
	two=2
	if test -d $destination; then
		echo "Using $destination"
	elif ! test -d $destination; then
		mkdir "$destination"
		if ! test -d $destination; then
			echo "$destination is an invalid destination, exiting program"
			sleep 3
			exit
		fi
	fi
	
	echo "Folder $destination has been created"
fi

echo "Insert Youtube URL:"
read url

echo "Insert video format, [mp3,mp4]"
read mp3ormp4

echo "The argument is: $url, video format is: $mp3ormp4"
if [ $two -eq 1 ]; then
	yt-dlp -S res,ext:$mp3ormp4:m4a --recode $mp3ormp4 $url -P /home/$username/youtube-media
elif [ $two -eq 2 ]; then
	yt-dlp -S res,ext:$mp3ormp4:m4a --recode $mp3ormp4 $url -P $destination
fi

#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)
isTrue=0
touch file.json
echo "Checking for prerequisites"

if ! command -v yt-dlp &> /dev/null; then
	printf "yt-dlp is not installed, would you like to install it?\ny/n\n\n"
	read yorn

	if [ "$yorn" = "y" ]; then
		sudo add-apt-repository ppa:tomtomtom/yt-dlp && sudo apt install yt-dlp 
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
	var1=$(jq -r '.username' file.json)
	if [[ -n $var1 ]]; then
		isTrue=1
		printf "Enter username, or select from list\n\n"
		printf "${bold}1. %s\n\n${normal}" "$var1"
	else
	printf "Enter username of this computer\n\n"
	fi
	
	read username
	two=1
	if [ $isTrue = 1 ]; then
	 	if [ $isTrue = 1 ]; then
			username=$var1
			printf "${bold}%s${normal} is selected\n\n" "$username"
		
		fi
	else	
		if ! test -d /home/$username; then
			echo "$username is an invalid username, exiting program"
			sleep 3
			exit
		elif ! test -d /home/$username/youtube-media; then
			mkdir /home/$username/youtube-media
			echo "Folder /home/$username/youtube-media has been created"
			path1="/home/$username/youtube-media"
		fi
	echo "Folder /home/$username/youtube-media exists, using."
	fi
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

#youtube video creation -------------------------------------------------------

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

#CACHING SECTION -----------------------------------------------

JSON=$(jq -n '')

if [[ -n "$username" ]]; then
	test=$(jq -r '.username' file.json)
	echo $test
	if [[ $test = $username ]]; then
		echo "DUPLICATE"
	elif [[ $test != $username ]]; then
		JSON=$(echo $JSON | jq --arg username "${username}" '. += $ARGS.named')
		echo "$JSON" >> file.json
	fi
fi

#if [[ -n "$destination" ]]; then
#  	JSON=$(echo $JSON | jq --arg path "${destination}" '. += $ARGS.named')
#fi


#echo "$JSON" >> file.json

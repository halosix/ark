#!/bin/bash
#
# adrift ark server scripty thingie
# by pleione
# CC-by-SA 2017
#
# v 2.0
# 12062017T0442Z
#
# moved backup to dedicated function
# added $whereflag to name the backup properly
#
#

menuFunction() 
{
	echo -e "\e[7m        = VALID COMMANDS =        \e[0m"
	echo -e "\e[7m:\e[5mstart\e[25m: :\e[5mstop\e[25m: :\e[5mrestart\e[25m: :\e[5mupdate\e[25m: \e[0m"
	echo ""
	echo -e "\e[7m What is thy bidding, my master?  \e[0m"
	echo ""
	read menuInput
	if [ $menuInput = "start" ];
		then 
			whereflag="START"
			startark
		elif [ $menuInput = "stop" ];
		then 
			whereflag="STOP"
			stopark
		elif [ $menuInput = "restart" ];
		then 
			whereflag="RESTART"
			restartark
		elif [ $menuInput = "update" ];
		then 
			whereflag="UPDATE"
			updateark
		else echo -e "invalid input detected. try again.\e[0m" && sleep 2s && menuFunction
	fi
}
	
startark() 
{
	echo -e "\e[7mstarting servers... this will take 5 minutes.\e[0m"
	screen -dmS thecenter ./server_start.sh
	echo -e "\e[7mtheCenter started, sleeping for 1m15s...\e[0m"
	sleep 75s
	screen -dmS theisland ./server_start_island.sh
	echo -e "\e[7mtheIsland started, sleeping for 1m15s...\e[0m"
	sleep 75s
	screen -dmS scorched ./server_start_scorched.sh
	echo -e "\e[7mscorched earth started, sleeping for 1m15s...\e[0m"
	sleep 75s
	screen -dmS oldisland ./server_start_oldisland.sh
	echo -e "\e[7mold island started, sleeping for 1m15s...\e[0m"
	sleep 75s
	echo -e "\e[7mservers started. exiting.\e[0m"
	sleep 10s
}

stopark() 
{
	backupark
	echo -e "\e[7mfinding ark PIDs and sending SIGTERM...\e[0m"
	pgrep -f ShooterGameServ > PIDdump
	sed -i 's/^/kill /' PIDdump
	chmod 777 PIDdump
	./PIDdump
	echo -e "\e[7mPIDs killed. cleaning up screens...\e[0m"
	killall -6 screen
	sleep 5s
	screen -wipe
}

restartark() 
{
	stopark
	startark
}

updateark() 
{
	echo -e "\e[7mupdate selected. NOTE: this will ONLY update ARK, not mods!\e[0m"
	sleep 5s
	backupark
	stopark
	echo -e "\e[7mupdating servers...\e[0m"
	steamcmd +login anonymous +force_install_dir /opt/ark +app_update 376030 +quit /opt/ark
	echo -e "\e[7mupdate complete.\e[0m"
	startark
}

backupark()
{
	echo -e "\e[7mbacking up servers...\e[0m"
}


clear
echo -e "\e[7m           _       _   __  _    _ "
echo -e "\e[7m  __ _  __| | _ _ (_) / _|| |_ | |"
echo -e "\e[7m / _\` |/ _\` || '_|| ||  _||  _||_|"
echo -e "\e[7m \__,_|\__,_||_|  |_||_|   \__|(_)"
echo -e "\e[7m                                  "

echo -e "\e[7m        ark server scripty thingie\e[0m"
echo -e "\e[7m                       version 2.0\e[0m"
echo ""
menuFunction;

#!/bin/sh

####################################################
##              __  __              _  _          ##
##             |  \/  |            | |(_)         ##
##   ___   ___ | \  / |  ___  _ __ | | _  _ __    ##
##  / __| / __|| |\/| | / _ \| '__|| || || '_ \   ##
##  \__ \| (__ | |  | ||  __/| |   | || || | | |  ##
##  |___/ \___||_|  |_| \___||_|   |_||_||_| |_|  ##
##                                                ##
##      https://github.com/jackyaz/scMerlin       ##
##                                                ##
####################################################

### Start of script variables ###
readonly SCM_NAME="scmerlin"
#shellcheck disable=SC2019
#shellcheck disable=SC2018
readonly SCM_NAME_LOWER=$(echo $SCM_NAME | tr 'A-Z' 'a-z')
readonly SCM_VERSION="v1.0.0"
readonly SCM_BRANCH="master"
readonly SCM_REPO="https://raw.githubusercontent.com/jackyaz/""$SCM_NAME""/""$SCM_BRANCH"
[ -z "$(nvram get odmpid)" ] && ROUTER_MODEL=$(nvram get productid) || ROUTER_MODEL=$(nvram get odmpid)
### End of script variables ###

### Start of output format variables ###
readonly CRIT="\\e[41m"
readonly ERR="\\e[31m"
readonly WARN="\\e[33m"
readonly PASS="\\e[32m"
### End of output format variables ###

# $1 = print to syslog, $2 = message to print, $3 = log level
Print_Output(){
	if [ "$1" = "true" ]; then
		logger -t "$SCM_NAME" "$2"
		printf "\\e[1m$3%s: $2\\e[0m\\n\\n" "$SCM_NAME"
	else
		printf "\\e[1m$3%s: $2\\e[0m\\n\\n" "$SCM_NAME"
	fi
}

### Code for this function courtesy of https://github.com/decoderman- credit to @thelonelycoder ###
Firmware_Version_Check(){
	echo "$1" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}
############################################################################

### Code for these functions inspired by https://github.com/Adamm00 - credit to @Adamm ###
Check_Lock(){
	if [ -f "/tmp/$SCM_NAME.lock" ]; then
		ageoflock=$(($(date +%s) - $(date +%s -r /tmp/$SCM_NAME.lock)))
		if [ "$ageoflock" -gt 60 ]; then
			Print_Output "true" "Stale lock file found (>60 seconds old) - purging lock" "$ERR"
			kill "$(sed -n '1p' /tmp/$SCM_NAME.lock)" >/dev/null 2>&1
			Clear_Lock
			echo "$$" > "/tmp/$SCM_NAME.lock"
			return 0
		else
			Print_Output "true" "Lock file found (age: $ageoflock seconds) - ping test likely currently running" "$ERR"
			if [ -z "$1" ]; then
				exit 1
			else
				return 1
			fi
		fi
	else
		echo "$$" > "/tmp/$SCM_NAME.lock"
		return 0
	fi
}

Clear_Lock(){
	rm -f "/tmp/$SCM_NAME.lock" 2>/dev/null
	return 0
}

Update_Version(){
	if [ -z "$1" ]; then
		doupdate="false"
		localver=$(grep "SCM_VERSION=" /jffs/scripts/"$SCM_NAME" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
		/usr/sbin/curl -fsL --retry 3 "$SCM_REPO/$SCM_NAME.sh" | grep -qF "jackyaz" || { Print_Output "true" "404 error detected - stopping update" "$ERR"; return 1; }
		serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCM_REPO/$SCM_NAME.sh" | grep "SCM_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
		if [ "$localver" != "$serverver" ]; then
			doupdate="version"
		else
			localmd5="$(md5sum "/jffs/scripts/$SCM_NAME" | awk '{print $1}')"
			remotemd5="$(curl -fsL --retry 3 "$SCM_REPO/$SCM_NAME.sh" | md5sum | awk '{print $1}')"
			if [ "$localmd5" != "$remotemd5" ]; then
				doupdate="md5"
			fi
		fi
		
		if [ "$doupdate" = "version" ]; then
			Print_Output "true" "New version of $SCM_NAME available - updating to $serverver" "$PASS"
		elif [ "$doupdate" = "md5" ]; then
			Print_Output "true" "MD5 hash of $SCM_NAME does not match - downloading updated $serverver" "$PASS"
		fi
		
		if [ "$doupdate" != "false" ]; then
			/usr/sbin/curl -fsL --retry 3 "$SCM_REPO/$SCM_NAME.sh" -o "/jffs/scripts/$SCM_NAME" && Print_Output "true" "$SCM_NAME successfully updated"
			chmod 0755 /jffs/scripts/"$SCM_NAME"
			Clear_Lock
			exit 0
		else
			Print_Output "true" "No new version - latest is $localver" "$WARN"
			Clear_Lock
		fi
	fi
	
	case "$1" in
		force)
			serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCM_REPO/$SCM_NAME.sh" | grep "SCM_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
			Print_Output "true" "Downloading latest version ($serverver) of $SCM_NAME" "$PASS"
			/usr/sbin/curl -fsL --retry 3 "$SCM_REPO/$SCM_NAME.sh" -o "/jffs/scripts/$SCM_NAME" && Print_Output "true" "$SCM_NAME successfully updated"
			chmod 0755 /jffs/scripts/"$SCM_NAME"
			Clear_Lock
			exit 0
		;;
	esac
}
############################################################################

Validate_Number(){
	if [ "$2" -eq "$2" ] 2>/dev/null; then
		return 0
	else
		formatted="$(echo "$1" | sed -e 's/|/ /g')"
		if [ -z "$3" ]; then
			Print_Output "false" "$formatted - $2 is not a number" "$ERR"
		fi
		return 1
	fi
}

Download_File(){
	/usr/sbin/curl -fsL --retry 3 "$1" -o "$2"
}

Shortcut_SCM(){
	case $1 in
		create)
			if [ -d "/opt/bin" ] && [ ! -f "/opt/bin/$SCM_NAME" ] && [ -f "/jffs/scripts/$SCM_NAME" ]; then
				ln -s /jffs/scripts/"$SCM_NAME" /opt/bin
				chmod 0755 /opt/bin/"$SCM_NAME"
			fi
		;;
		delete)
			if [ -f "/opt/bin/$SCM_NAME" ]; then
				rm -f /opt/bin/"$SCM_NAME"
			fi
		;;
	esac
}

PressEnter(){
	while true; do
		printf "Press enter to continue..."
		read -r "key"
		case "$key" in
			*)
				break
			;;
		esac
	done
	return 0
}

ScriptHeader(){
	clear
	printf "\\n"
	printf "\\e[1m#####################################################\\e[0m\\n"
	printf "\\e[1m##               __  __              _  _          ##\\e[0m\\n"
	printf "\\e[1m##              |  \/  |            | |(_)         ##\\e[0m\\n"
	printf "\\e[1m##    ___   ___ | \  / |  ___  _ __ | | _  _ __    ##\\e[0m\\n"
	printf "\\e[1m##   / __| / __|| |\/| | / _ \| '__|| || || '_ \   ##\\e[0m\\n"
	printf "\\e[1m##   \__ \| (__ | |  | ||  __/| |   | || || | | |  ##\\e[0m\\n"
	printf "\\e[1m##   |___/ \___||_|  |_| \___||_|   |_||_||_| |_|  ##\\e[0m\\n"
	printf "\\e[1m##                                                 ##\\e[0m\\n"
	printf "\\e[1m##               %s on %-9s               ##\\e[0m\\n" "$SCM_VERSION" "$ROUTER_MODEL"
	printf "\\e[1m##                                                 ##\\e[0m\\n"
	printf "\\e[1m##       https://github.com/jackyaz/scMerlin       ##\\e[0m\\n"
	printf "\\e[1m##                                                 ##\\e[0m\\n"
	printf "\\e[1m#####################################################\\e[0m\\n"
	printf "\\n"
}

MainMenu(){
	printf "\\e[1mServices\\e[0m\\n"
	printf "\\e[1m(selecting an option will restart the service)\\e[0m\\n\\n"
	printf "1.    DNS/DHCP Server (dnsmasq)\\n"
	printf "2.    Internet connection\\n"
	printf "3.    Web Interface (httpd)\\n"
	printf "4.    WiFi\\n"
	ENABLED_FTP="$(nvram get enable_ftp)"
	if ! Validate_Number "" "$ENABLED_FTP" "silent"; then ENABLED_FTP=0; fi
	if [ "$ENABLED_FTP" -eq 1 ]; then
		printf "5.    FTP Server (vsftpd)\\n"
	fi
	ENABLED_SAMBA="$(nvram get enable_samba)"
	if ! Validate_Number "" "$ENABLED_SAMBA" "silent"; then ENABLED_SAMBA=0; fi
	if [ "$ENABLED_SAMBA" -eq 1 ]; then
		printf "6.    SAMBA\\n"
	fi
	if [ -f /opt/bin/diversion ] || [ -f /jffs/scripts/firewall ]; then
		printf "\\n\\e[1mScripts\\e[0m\\n\\n"
	fi
	if [ -f /opt/bin/diversion ]; then
		DIVERSION_STATUS="$(grep "adblocking" /opt/share/diversion/.conf/diversion.conf | cut -f2 -d"=")"
		if [ "$DIVERSION_STATUS" = "on" ]; then DIVERSION_STATUS="Disable"; else DIVERSION_STATUS="Enable"; fi
		printf "7.    %s Diversion ad-blocking\\n" "$DIVERSION_STATUS"
	fi
	if [ -f /jffs/scripts/firewall ]; then
		SKYNET_STATUS=""
		if iptables -t raw -S | grep -q Skynet; then SKYNET_STATUS="Disable"; else SKYNET_STATUS="Enable"; fi
		printf "8.    %s Skynet firewall\\n" "$SKYNET_STATUS"
	fi
	if [ -f /opt/bin/opkg ]; then
		printf "\\n\\e[1mEntware\\e[0m\\n\\n"
		printf "t.    Restart all Entware scripts\\n\\n"
	fi
	printf "\\n\\e[1mRouter\\e[0m\\n\\n"
	printf "r.    Reboot router\\n\\n"
	printf "\\e[1mOther\\e[0m\\n\\n"
	printf "u.    Check for updates\\n"
	printf "uf.   Update %s with latest version (force update)\\n\\n" "$SCM_NAME"
	printf "e.    Exit %s\\n\\n" "$SCM_NAME"
	printf "z.    Uninstall %s\\n" "$SCM_NAME"
	printf "\\n"
	printf "\\e[1m#####################################################\\e[0m\\n"
	printf "\\n"
	while true; do
		printf "Choose an option:    "
		read -r "menu"
		case "$menu" in
			1)
				printf "\\n"
				if Check_Lock "menu"; then
					service restart_dnsmasq >/dev/null 2>&1
					Clear_Lock
				fi
				PressEnter
				break
			;;
			2)
				printf "\\n"
				if Check_Lock "menu"; then
					while true; do
						printf "\\n\\e[1mInternet connection will take 30s-60s to reconnect. Continue? (y/n)\\e[0m\\n"
						read -r "confirm"
						case "$confirm" in
							y|Y)
								service restart_wan >/dev/null 2>&1
								Clear_Lock
								break
							;;
							*)
								break
							;;
						esac
					done
				fi
				PressEnter
				break
			;;
			3)
				printf "\\n"
				if Check_Lock "menu"; then
					service restart_httpd >/dev/null 2>&1
					Clear_Lock
				fi
				PressEnter
				break
			;;
			4)
				printf "\\n"
				if Check_Lock "menu"; then
					service restart_wireless >/dev/null 2>&1
					Clear_Lock
				fi
				PressEnter
				break
			;;
			5)
				printf "\\n"
				if [ "$ENABLED_FTP" -eq 1 ]; then
					if Check_Lock "menu"; then
						service restart_ftpd >/dev/null 2>&1
						Clear_Lock
					fi
				else
				printf "\\n\\e[1mInvalid selection (FTP not enabled)\\e[0m\\n"
				fi
				PressEnter
				break
			;;
			6)
				printf "\\n"
				if [ "$ENABLED_SAMBA" -eq 1 ]; then
					if Check_Lock "menu"; then
						service restart_samba >/dev/null 2>&1
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (Samba not enabled)\\e[0m\\n"
				fi
				PressEnter
				break
			;;
			7)
				printf "\\n"
				if [ -f /opt/bin/diversion ]; then
					if Check_Lock "menu"; then
						/opt/bin/diversion a
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (Diversion not installed)\\e[0m\\n"
				fi
				PressEnter
				break
			;;
			8)
				printf "\\n"
				if [ -f /jffs/scripts/firewall ]; then
					if Check_Lock "menu"; then
						if [ "$SKYNET_STATUS" = "Enable" ]; then
							/jffs/scripts/firewall restart
						else
							/jffs/scripts/firewall disable
						fi
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (Skynet not installed)\\e[0m\\n"
				fi
				PressEnter
				break
			;;
			t)
				printf "\\n"
				if [ -f /opt/bin/opkg ]; then
					if Check_Lock "menu"; then
						while true; do
							printf "\\n\\e[1mAre you sure you want to restart all Entware scripts? (y/n)\\e[0m\\n"
							read -r "confirm"
							case "$confirm" in
								y|Y)
									/opt/etc/init.d/rc.unslung restart
									break
								;;
								*)
									break
								;;
							esac
						done
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (Entware not installed)\\e[0m\\n"
				fi
				PressEnter
				break
			;;
			r)
				printf "\\n"
				if Check_Lock "menu"; then
					while true; do
						printf "\\n\\e[1mAre you sure you want to reboot? (y/n)\\e[0m\\n"
						read -r "confirm"
						case "$confirm" in
							y|Y)
								service reboot >/dev/null 2>&1
								break
							;;
							*)
								break
							;;
						esac
					done
					Clear_Lock
				fi
				PressEnter
				break
			;;
			u)
				printf "\\n"
				if Check_Lock "menu"; then
					Menu_Update
				fi
				PressEnter
				break
			;;
			uf)
				printf "\\n"
				if Check_Lock "menu"; then
					Menu_ForceUpdate
				fi
				PressEnter
				break
			;;
			e)
				ScriptHeader
				printf "\\n\\e[1mThanks for using %s!\\e[0m\\n\\n\\n" "$SCM_NAME"
				exit 0
			;;
			z)
				while true; do
					printf "\\n\\e[1mAre you sure you want to uninstall %s? (y/n)\\e[0m\\n" "$SCM_NAME"
					read -r "confirm"
					case "$confirm" in
						y|Y)
							Menu_Uninstall
							exit 0
						;;
						*)
							break
						;;
					esac
				done
			;;
			*)
				printf "\\nPlease choose a valid option\\n\\n"
			;;
		esac
	done
	
	ScriptHeader
	MainMenu
}

Check_Requirements(){
	CHECKSFAILED="false"
	
	if [ "$(nvram get jffs2_scripts)" -ne 1 ]; then
		nvram set jffs2_scripts=1
		nvram commit
		Print_Output "true" "Custom JFFS Scripts enabled" "$WARN"
	fi
	
	if [ "$CHECKSFAILED" = "false" ]; then
		return 0
	else
		return 1
	fi
}

Menu_Install(){
	Print_Output "true" "Welcome to $SCM_NAME $SCM_VERSION, a script by JackYaz"
	sleep 1
	Shortcut_SCM create
	Clear_Lock
	ScriptHeader
	MainMenu
}

Menu_Update(){
	Update_Version
	Clear_Lock
}

Menu_ForceUpdate(){
	Update_Version force
	Clear_Lock
}

Menu_Uninstall(){
	Print_Output "true" "Removing $SCM_NAME..." "$PASS"
	Shortcut_SCM delete
	rm -f "/jffs/scripts/$SCM_NAME" 2>/dev/null
	Clear_Lock
	Print_Output "true" "Uninstall completed" "$PASS"
}

if [ -z "$1" ]; then
	ScriptHeader
	MainMenu
	exit 0
fi

case "$1" in
	install)
		Check_Lock
		Menu_Install
		exit 0
	;;
	update)
		Check_Lock
		Menu_Update
		exit 0
	;;
	forceupdate)
		Check_Lock
		Menu_ForceUpdate
		exit 0
	;;
	uninstall)
		Check_Lock
		Menu_Uninstall
		exit 0
	;;
	*)
		Check_Lock
		echo "Command not recognised, please try again"
		Clear_Lock
		exit 1
	;;
esac

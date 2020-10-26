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
readonly SCRIPT_NAME="scmerlin"
readonly SCM_VERSION="v2.0.0"
readonly SCRIPT_VERSION="v2.0.0"
readonly SCRIPT_BRANCH="develop"
readonly SCRIPT_REPO="https://raw.githubusercontent.com/jackyaz/""$SCRIPT_NAME""/""$SCRIPT_BRANCH"
readonly SCRIPT_DIR="/jffs/addons/$SCRIPT_NAME.d"
readonly SCRIPT_WEBPAGE_DIR="$(readlink /www/user)"
readonly SCRIPT_WEB_DIR="$SCRIPT_WEBPAGE_DIR/$SCRIPT_NAME"
readonly SHARED_DIR="/jffs/addons/shared-jy"
readonly SHARED_REPO="https://raw.githubusercontent.com/jackyaz/shared-jy/master"
readonly SHARED_WEB_DIR="$SCRIPT_WEBPAGE_DIR/shared-jy"
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
		logger -t "$SCRIPT_NAME" "$2"
		printf "\\e[1m$3%s: $2\\e[0m\\n\\n" "$SCRIPT_NAME"
	else
		printf "\\e[1m$3%s: $2\\e[0m\\n\\n" "$SCRIPT_NAME"
	fi
}

### Code for these functions inspired by https://github.com/Adamm00 - credit to @Adamm ###
Check_Lock(){
	if [ -f "/tmp/$SCRIPT_NAME.lock" ]; then
		ageoflock=$(($(date +%s) - $(date +%s -r /tmp/$SCRIPT_NAME.lock)))
		if [ "$ageoflock" -gt 60 ]; then
			Print_Output "true" "Stale lock file found (>60 seconds old) - purging lock" "$ERR"
			kill "$(sed -n '1p' /tmp/$SCRIPT_NAME.lock)" >/dev/null 2>&1
			Clear_Lock
			echo "$$" > "/tmp/$SCRIPT_NAME.lock"
			return 0
		else
			Print_Output "true" "Lock file found (age: $ageoflock seconds)" "$ERR"
			if [ -z "$1" ]; then
				exit 1
			else
				return 1
			fi
		fi
	else
		echo "$$" > "/tmp/$SCRIPT_NAME.lock"
		return 0
	fi
}

Clear_Lock(){
	rm -f "/tmp/$SCRIPT_NAME.lock" 2>/dev/null
	return 0
}

##############################################

Set_Version_Custom_Settings(){
	SETTINGSFILE="/jffs/addons/custom_settings.txt"
	case "$1" in
		local)
			if [ -f "$SETTINGSFILE" ]; then
				if [ "$(grep -c "scmerlin_version_local" $SETTINGSFILE)" -gt 0 ]; then
					if [ "$SCRIPT_VERSION" != "$(grep "scmerlin_version_local" /jffs/addons/custom_settings.txt | cut -f2 -d' ')" ]; then
						sed -i "s/scmerlin_version_local.*/scmerlin_version_local $SCRIPT_VERSION/" "$SETTINGSFILE"
					fi
				else
					echo "scmerlin_version_local $SCRIPT_VERSION" >> "$SETTINGSFILE"
				fi
			else
				echo "scmerlin_version_local $SCRIPT_VERSION" >> "$SETTINGSFILE"
			fi
		;;
		server)
			if [ -f "$SETTINGSFILE" ]; then
				if [ "$(grep -c "scmerlin_version_server" $SETTINGSFILE)" -gt 0 ]; then
					if [ "$2" != "$(grep "scmerlin_version_server" /jffs/addons/custom_settings.txt | cut -f2 -d' ')" ]; then
						sed -i "s/scmerlin_version_server.*/scmerlin_version_server $2/" "$SETTINGSFILE"
					fi
				else
					echo "scmerlin_version_server $2" >> "$SETTINGSFILE"
				fi
			else
				echo "scmerlin_version_server $2" >> "$SETTINGSFILE"
			fi
		;;
	esac
}

Update_Check(){
	echo 'var updatestatus = "InProgress";' > "$SCRIPT_WEB_DIR/detect_update.js"
	doupdate="false"
	localver=$(grep "SCRIPT_VERSION=" /jffs/scripts/"$SCRIPT_NAME" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | grep -qF "jackyaz" || { Print_Output "true" "404 error detected - stopping update" "$ERR"; return 1; }
	serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	if [ "$localver" != "$serverver" ]; then
		doupdate="version"
		Set_Version_Custom_Settings "server" "$serverver"
		echo 'var updatestatus = "'"$serverver"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
	else
		localmd5="$(md5sum "/jffs/scripts/$SCRIPT_NAME" | awk '{print $1}')"
		remotemd5="$(curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | md5sum | awk '{print $1}')"
		if [ "$localmd5" != "$remotemd5" ]; then
			doupdate="md5"
			Set_Version_Custom_Settings "server" "$serverver-hotfix"
			echo 'var updatestatus = "'"$serverver-hotfix"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
		fi
	fi
	if [ "$doupdate" = "false" ]; then
		echo 'var updatestatus = "None";'  > "$SCRIPT_WEB_DIR/detect_update.js"
	fi
	echo "$doupdate,$localver,$serverver"
}

Update_Version(){
	if [ -z "$1" ] || [ "$1" = "unattended" ]; then
		updatecheckresult="$(Update_Check)"
		isupdate="$(echo "$updatecheckresult" | cut -f1 -d',')"
		localver="$(echo "$updatecheckresult" | cut -f2 -d',')"
		serverver="$(echo "$updatecheckresult" | cut -f3 -d',')"
		
		if [ "$isupdate" = "version" ]; then
			Print_Output "true" "New version of $SCRIPT_NAME available - updating to $serverver" "$PASS"
		elif [ "$isupdate" = "md5" ]; then
			Print_Output "true" "MD5 hash of $SCRIPT_NAME does not match - downloading updated $serverver" "$PASS"
		fi
		
		Update_File "shared-jy.tar.gz"
		Update_File "tailtop"
		Update_File "tailtopd"
		Update_File "S99tailtop"
		
		if [ "$isupdate" != "false" ]; then
			/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" -o "/jffs/scripts/$SCRIPT_NAME" && Print_Output "true" "$SCRIPT_NAME successfully updated"
			chmod 0755 /jffs/scripts/"$SCRIPT_NAME"
			Clear_Lock
			if [ -z "$1" ]; then
				exec "$0" "setversion"
			elif [ "$1" = "unattended" ]; then
				exec "$0" "setversion" "unattended"
			fi
			exit 0
		else
			Print_Output "true" "No new version - latest is $localver" "$WARN"
			Clear_Lock
		fi
	fi
	
	if [ "$1" = "force" ]; then
		serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
		Print_Output "true" "Downloading latest version ($serverver) of $SCRIPT_NAME" "$PASS"
		Update_File "shared-jy.tar.gz"
		Update_File "tailtop"
		Update_File "tailtopd"
		Update_File "S99tailtop"
		/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" -o "/jffs/scripts/$SCRIPT_NAME" && Print_Output "true" "$SCRIPT_NAME successfully updated"
		chmod 0755 /jffs/scripts/"$SCRIPT_NAME"
		Clear_Lock
		if [ -z "$2" ]; then
			exec "$0" "setversion"
		elif [ "$2" = "unattended" ]; then
			exec "$0" "setversion" "unattended"
		fi
		exit 0
	fi
}

Update_File(){
	if [ "$1" = "shared-jy.tar.gz" ]; then
		if [ ! -f "$SHARED_DIR/$1.md5" ]; then
			Download_File "$SHARED_REPO/$1" "$SHARED_DIR/$1"
			Download_File "$SHARED_REPO/$1.md5" "$SHARED_DIR/$1.md5"
			tar -xzf "$SHARED_DIR/$1" -C "$SHARED_DIR"
			rm -f "$SHARED_DIR/$1"
			Print_Output "true" "New version of $1 downloaded" "$PASS"
		else
			localmd5="$(cat "$SHARED_DIR/$1.md5")"
			remotemd5="$(curl -fsL --retry 3 "$SHARED_REPO/$1.md5")"
			if [ "$localmd5" != "$remotemd5" ]; then
				Download_File "$SHARED_REPO/$1" "$SHARED_DIR/$1"
				Download_File "$SHARED_REPO/$1.md5" "$SHARED_DIR/$1.md5"
				tar -xzf "$SHARED_DIR/$1" -C "$SHARED_DIR"
				rm -f "$SHARED_DIR/$1"
				Print_Output "true" "New version of $1 downloaded" "$PASS"
			fi
		fi
	elif [ "$1" = "S99tailtop" ] || [ "$1" = "tailtop" ] || [ "$1" = "tailtopd" ]; then
			tmpfile="/tmp/$1"
			Download_File "$SCRIPT_REPO/$1" "$tmpfile"
			if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
				if [ -f /opt/etc/init.d/S99tailtop ]; then
					/opt/etc/init.d/S99tailtop >/dev/null 2>&1
					sleep 2
				fi
				Download_File "$SCRIPT_REPO/$1" "$SCRIPT_DIR/$1"
				chmod 0755 "$SCRIPT_DIR/$1"
				Print_Output "true" "New version of $1 downloaded" "$PASS"
			fi
			if [ "$1" = "S99tailtop" ]; then
				mv "$SCRIPT_DIR/S99tailtop" /opt/etc/init.d/S99tailtop
			fi
			/opt/etc/init.d/S99tailtop start >/dev/null 2>&1
			rm -f "$tmpfile"
	else
		return 1
	fi
}

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

Create_Dirs(){
	if [ ! -d "$SCRIPT_DIR" ]; then
		mkdir -p "$SCRIPT_DIR"
	fi
	
	if [ ! -d "$SHARED_DIR" ]; then
		mkdir -p "$SHARED_DIR"
	fi
	
	if [ ! -d "$SCRIPT_WEBPAGE_DIR" ]; then
		mkdir -p "$SCRIPT_WEBPAGE_DIR"
	fi
	
	if [ ! -d "$SCRIPT_WEB_DIR" ]; then
		mkdir -p "$SCRIPT_WEB_DIR"
	fi
}

Create_Symlinks(){
	rm -rf "${SCRIPT_WEB_DIR:?}/"* 2>/dev/null
	
	ln -s /tmp/scmerlin-top "$SCRIPT_WEB_DIR/top.htm" 2>/dev/null
	
	if [ ! -d "$SHARED_WEB_DIR" ]; then
		ln -s "$SHARED_DIR" "$SHARED_WEB_DIR" 2>/dev/null
	fi
}

Download_File(){
	/usr/sbin/curl -fsL --retry 3 "$1" -o "$2"
}

Shortcut_SCM(){
	case $1 in
		create)
			if [ -d "/opt/bin" ] && [ ! -f "/opt/bin/$SCRIPT_NAME" ] && [ -f "/jffs/scripts/$SCRIPT_NAME" ]; then
				ln -s /jffs/scripts/"$SCRIPT_NAME" /opt/bin
				chmod 0755 /opt/bin/"$SCRIPT_NAME"
			fi
		;;
		delete)
			if [ -f "/opt/bin/$SCRIPT_NAME" ]; then
				rm -f /opt/bin/"$SCRIPT_NAME"
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
	printf "\\e[1m##               %s on %-9s               ##\\e[0m\\n" "$SCRIPT_VERSION" "$ROUTER_MODEL"
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
	ENABLED_DDNS="$(nvram get ddns_enable_x)"
	if ! Validate_Number "" "$ENABLED_DDNS" "silent"; then ENABLED_DDNS=0; fi
	if [ "$ENABLED_DDNS" -eq 1 ]; then
		printf "7.    DDNS client\\n"
	fi
	ENABLED_NTPD="$(nvram get ntpd_enable)"
	if ! Validate_Number "" "$ENABLED_NTPD" "silent"; then ENABLED_NTPD=0; fi
	if [ -f /opt/etc/init.d/S77ntpd ] || [ "$ENABLED_NTPD" -eq 1 ]; then
		printf "8.    ntpd (time service)\\n"
	fi
	vpnclients="$(nvram show 2> /dev/null | grep ^vpn_client._addr)"
	vpnclientenabled="false"
	for vpnclient in $vpnclients; do
		if [ -n "$(nvram get "$(echo "$vpnclient" | cut -f1 -d'=')")" ]; then
			vpnclientenabled="true"
		fi
	done
	if [ "$vpnclientenabled" = "true" ]; then
		printf "\\n\\e[1mVPN Clients\\e[0m\\n"
		printf "\\e[1m(selecting an option will restart the VPN Client)\\e[0m\\n\\n"
		vpnclientnum=1
		while [ "$vpnclientnum" -lt 6 ]; do
			if [ -n "$(nvram get vpn_client"$vpnclientnum"_addr)" ]; then
				printf "vc%s.    VPN Client %s (%s)\\n" "$vpnclientnum" "$vpnclientnum" "$(nvram get vpn_client"$vpnclientnum"_desc)"
			fi
			vpnclientnum=$((vpnclientnum + 1))
		done
	fi
	vpnservercount="$(nvram get vpn_serverx_start | awk '{n=split($0, array, ",")} END{print n-1 }')"
	vpnserverenabled="false"
	if [ "$vpnservercount" -gt 0 ]; then
		vpnserverenabled="true"
	fi
	if [ "$vpnserverenabled" = "true" ]; then
		printf "\\n\\e[1mVPN Servers\\e[0m\\n"
		printf "\\e[1m(selecting an option will restart the VPN Server)\\e[0m\\n\\n"
		vpnservernum=1
		while [ "$vpnservernum" -le "$vpnservercount" ]; do
			vpnservernumactual="$(nvram get vpn_serverx_start | awk -v i="$vpnservernum" -F',' '{ print $i }')"
			printf "vs%s.    VPN Server %s\\n" "$vpnservernumactual" "$vpnservernumactual"
			vpnservernum=$((vpnservernum + 1))
		done
	fi
	if [ -f /opt/bin/diversion ] || [ -f /jffs/scripts/firewall ]; then
		printf "\\n\\e[1mScripts\\e[0m\\n\\n"
	fi
	if [ -f /opt/bin/diversion ]; then
		DIVERSION_STATUS="$(grep "adblocking" /opt/share/diversion/.conf/diversion.conf | cut -f2 -d"=")"
		if [ "$DIVERSION_STATUS" = "on" ]; then DIVERSION_STATUS="Disable"; else DIVERSION_STATUS="Enable"; fi
		printf "d.    %s Diversion ad-blocking\\n" "$DIVERSION_STATUS"
	fi
	if [ -f /jffs/scripts/firewall ]; then
		SKYNET_STATUS=""
		if iptables -t raw -S | grep -q Skynet; then SKYNET_STATUS="Disable"; else SKYNET_STATUS="Enable"; fi
		printf "s.    %s Skynet firewall\\n" "$SKYNET_STATUS"
	fi
	if [ -f /opt/bin/opkg ]; then
		printf "\\n\\e[1mEntware\\e[0m\\n\\n"
		printf "et.    Restart all Entware scripts\\n"
	fi
	printf "\\n\\e[1mRouter\\e[0m\\n\\n"
	printf "c.    View running processes\\n"
	printf "m.    View RAM/memory usage\n"
	printf "t.    View router temperatures\n"
	printf "r.    Reboot router\\n\\n"
	printf "\\e[1mOther\\e[0m\\n\\n"
	printf "u.    Check for updates\\n"
	printf "uf.   Update %s with latest version (force update)\\n\\n" "$SCRIPT_NAME"
	printf "e.    Exit %s\\n\\n" "$SCRIPT_NAME"
	printf "z.    Uninstall %s\\n" "$SCRIPT_NAME"
	printf "\\n"
	printf "\\e[1m#####################################################\\e[0m\\n"
	printf "\\n"
	while true; do
		printf "Choose an option:    "
		read -r "menu"
		case "$menu" in
			1)
				printf "\\n"
				service restart_dnsmasq >/dev/null 2>&1
				PressEnter
				break
			;;
			2)
				printf "\\n"
				while true; do
					printf "\\n\\e[1mInternet connection will take 30s-60s to reconnect. Continue? (y/n)\\e[0m\\n"
					read -r "confirm"
					case "$confirm" in
						y|Y)
							service restart_wan >/dev/null 2>&1
							break
						;;
						*)
							break
						;;
					esac
				done
				PressEnter
				break
			;;
			3)
				printf "\\n"
				service restart_httpd >/dev/null 2>&1
				PressEnter
				break
			;;
			4)
				printf "\\n"
				service restart_wireless >/dev/null 2>&1
				PressEnter
				break
			;;
			5)
				printf "\\n"
				if [ "$ENABLED_FTP" -eq 1 ]; then
					service restart_ftpd >/dev/null 2>&1
				else
				printf "\\n\\e[1mInvalid selection (FTP not enabled)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			6)
				printf "\\n"
				if [ "$ENABLED_SAMBA" -eq 1 ]; then
					service restart_samba >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (Samba not enabled)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			7)
				printf "\\n"
				if [ "$ENABLED_DDNS" -eq 1 ]; then
					service restart_ddns >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (DDNS client not enabled)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			8)
				printf "\\n"
				if [ "$ENABLED_NTPD" -eq 1 ]; then
					service restart_time >/dev/null 2>&1
				elif [ -f "/opt/etc/init.d/S77ntpd" ]; then
					/opt/etc/init.d/S77ntpd restart
				else
					printf "\\n\\e[1mInvalid selection (NTP server not enabled/installed)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc1)
				printf "\\n"
				if [ -n "$(nvram get vpn_client1_addr)" ]; then
					service restart_vpnclient1 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc2)
				printf "\\n"
				if [ -n "$(nvram get vpn_client2_addr)" ]; then
					service restart_vpnclient2 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc3)
				printf "\\n"
				if [ -n "$(nvram get vpn_client3_addr)" ]; then
					service restart_vpnclient3 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc4)
				printf "\\n"
				if [ -n "$(nvram get vpn_client4_addr)" ]; then
					service restart_vpnclient4 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc5)
				printf "\\n"
				if [ -n "$(nvram get vpn_client5_addr)" ]; then
					service restart_vpnclient5 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vs1)
				printf "\\n"
				if nvram get vpn_serverx_start | grep -q 1; then
					service restart_vpnserver1 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Server not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vs2)
				printf "\\n"
				if nvram get vpn_serverx_start | grep -q 2; then
					service restart_vpnserver2 >/dev/null 2>&1
				else
					printf "\\n\\e[1mInvalid selection (VPN Server not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			d)
				printf "\\n"
				if [ -f /opt/bin/diversion ]; then
					if Check_Lock "menu"; then
						/opt/bin/diversion a
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (Diversion not installed)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			s)
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
			et)
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
			c)
				printf "\\n"
				program=""
				if [ -f /opt/bin/opkg ]; then
					if [ -f /opt/bin/htop ]; then
						program="htop"
					else
						program=""
						while true; do
							printf "\\n\\e[1mWould you like to install htop (enhanced version of top)? (y/n)\\e[0m\\n"
							read -r "confirm"
							case "$confirm" in
								y|Y)
									program="htop"
									opkg install htop
									break
								;;
								*)
									program="top"
									break
								;;
							esac
						done
					fi
				else
					program="top"
				fi
				trap trap_ctrl 2
				trap_ctrl(){
					exec "$0"
				}
				"$program"
				trap - 2
				PressEnter
				break
			;;
			m)
				ScriptHeader
				printf "\\n"
				free
				PressEnter
				break
			;;
			t)
				ScriptHeader
				printf "\\n"
				printf "\\n\\e[1mTemperatures\\e[0m\\n\\n"
				if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
					printf "CPU: %s°C\\n" "$(awk '{ print int($1/1000) }' /sys/class/thermal/thermal_zone0/temp)"
				elif [ -f /proc/dmu/temperature ]; then
					printf "CPU:%s\\n" "$(cut -f2 -d':' /proc/dmu/temperature | awk '{$1=$1;print}' | sed 's/..$/°C/')"
				else
					printf "CPU: N/A\\n"
				fi
				
				printf "2.4 GHz: %s°C\\n" "$(wl -i "$(nvram get wl0_ifname)" phy_tempsense | awk '{ print $1/2+20 }')"
				
				if [ "$ROUTER_MODEL" = "RT-AC87U" ] || [ "$ROUTER_MODEL" = "RT-AC87R" ]; then
					printf "5 GHz: %s°C\\n\\n" "$(qcsapi_sockrpc get_temperature | awk 'FNR == 2 {print $3}')"
				else
					printf "5 GHz: %s°C\\n\\n" "$(wl -i "$(nvram get wl1_ifname)" phy_tempsense | awk '{ print $1/2+20 }')"
				fi
				PressEnter
				break
			;;
			r)
				printf "\\n"
				if Check_Lock "menu"; then
					while true; do
						if [ "$ROUTER_MODEL" = "RT-AC86U" ]; then
							printf "\\n\\e[1m\\e[33mRemote reboots are not recommend for %s\\e[0m" "$ROUTER_MODEL"
							printf "\\n\\e[1m\\e[33mSome %s fail to reboot correctly and require a manual power cycle\\e[0m\\n" "$ROUTER_MODEL"
						fi
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
				printf "\\n\\e[1mThanks for using %s!\\e[0m\\n\\n\\n" "$SCRIPT_NAME"
				exit 0
			;;
			z)
				while true; do
					printf "\\n\\e[1mAre you sure you want to uninstall %s? (y/n)\\e[0m\\n" "$SCRIPT_NAME"
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
	Print_Output "true" "Welcome to $SCRIPT_NAME $SCRIPT_VERSION, a script by JackYaz"
	sleep 1
	
	Print_Output "true" "Checking your router meets the requirements for $SCRIPT_NAME"
	
	if ! Check_Requirements; then
		Print_Output "true" "Requirements for $SCRIPT_NAME not met, please see above for the reason(s)" "$CRIT"
		PressEnter
		Clear_Lock
		rm -f "/jffs/scripts/$SCRIPT_NAME" 2>/dev/null
		exit 1
	fi
	
	Create_Dirs
	Shortcut_SCM create
	Set_Version_Custom_Settings "local"
	Create_Symlinks
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
	Print_Output "true" "Removing $SCRIPT_NAME..." "$PASS"
	Shortcut_SCM delete
	rm -f "/jffs/scripts/$SCRIPT_NAME" 2>/dev/null
	Clear_Lock
	Print_Output "true" "Uninstall completed" "$PASS"
}

if [ -z "$1" ]; then
	Create_Dirs
	Shortcut_SCM create
	Set_Version_Custom_Settings "local"
	Create_Symlinks
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
		Update_Version "unattended"
		exit 0
	;;
	forceupdate)
		Update_Version "force" "unattended"
		exit 0
	;;
	setversion)
		Set_Version_Custom_Settings "local"
		Set_Version_Custom_Settings "server" "$SCRIPT_VERSION"
		if [ -z "$2" ]; then
			exec "$0"
		fi
		exit 0
	;;
	checkupdate)
		#shellcheck disable=SC2034
		updatecheckresult="$(Update_Check)"
		exit 0
	;;
	uninstall)
		Check_Lock
		Menu_Uninstall
		exit 0
	;;
	develop)
		sed -i 's/^readonly SCRIPT_BRANCH.*$/readonly SCRIPT_BRANCH="develop"/' "/jffs/scripts/$SCRIPT_NAME"
		exec "$0" "update"
		exit 0
	;;
	stable)
		sed -i 's/^readonly SCRIPT_BRANCH.*$/readonly SCRIPT_BRANCH="master"/' "/jffs/scripts/$SCRIPT_NAME"
		exec "$0" "update"
		exit 0
	;;
	*)
		echo "Command not recognised, please try again"
		exit 1
	;;
esac

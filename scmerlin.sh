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
readonly SCM_VERSION="v1.1.2"
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
			exec "$0"
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
			exec "$0"
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
		while [ "$vpnclientnum" -le 5 ]; do
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
		printf "t.    Restart all Entware scripts\\n"
	fi
	printf "\\n\\e[1mRouter\\e[0m\\n\\n"
	printf "c.    View running processes\\n"
	printf "m.    View RAM/memory usage\n"
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
				printf "\\n\\e[1mInvalid selection (FTP not enabled)\\e[0m\\n\\n"
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
					printf "\\n\\e[1mInvalid selection (Samba not enabled)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			7)
				printf "\\n"
				if [ "$ENABLED_DDNS" -eq 1 ]; then
					if Check_Lock "menu"; then
						service restart_ddns >/dev/null 2>&1
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (DDNS client not enabled)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			8)
				printf "\\n"
				if [ "$ENABLED_NTPD" -eq 1 ]; then
					if Check_Lock "menu"; then
						service restart_time >/dev/null 2>&1
						Clear_Lock
					fi
				elif [ -f "/opt/etc/init.d/S77ntpd" ]; then
					if Check_Lock "menu"; then
						/opt/etc/init.d/S77ntpd restart
						Clear_Lock
					fi
				else
					printf "\\n\\e[1mInvalid selection (DDNS client not enabled)\\e[0m\\n\\n"
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
	develop)
		Check_Lock
		sed -i 's/^readonly SCM_BRANCH.*$/readonly SCM_BRANCH="develop"/' "/jffs/scripts/$SCM_NAME_LOWER"
		Clear_Lock
		exec "$0" "update"
		exit 0
	;;
	stable)
		Check_Lock
		sed -i 's/^readonly SCM_BRANCH.*$/readonly SCM_BRANCH="master"/' "/jffs/scripts/$SCM_NAME_LOWER"
		Clear_Lock
		exec "$0" "update"
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

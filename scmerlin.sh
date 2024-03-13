#!/bin/sh

######################################################
##               __  __              _  _           ##
##              |  \/  |            | |(_)          ##
##    ___   ___ | \  / |  ___  _ __ | | _  _ __     ##
##   / __| / __|| |\/| | / _ \| '__|| || || '_ \    ##
##   \__ \| (__ | |  | ||  __/| |   | || || | | |   ##
##   |___/ \___||_|  |_| \___||_|   |_||_||_| |_|   ##
##                                                  ##
##       https://github.com/jackyaz/scMerlin        ##
##                                                  ##
######################################################
# Last Modified: 2024-Mar-12
#-----------------------------------------------------

##########       Shellcheck directives     ###########
# shellcheck disable=SC2016
# shellcheck disable=SC2018
# shellcheck disable=SC2019
# shellcheck disable=SC2059
# shellcheck disable=SC2034
# shellcheck disable=SC2155
######################################################

### Start of script variables ###
readonly SCRIPT_NAME="scMerlin"
readonly SCRIPT_NAME_LOWER="$(echo "$SCRIPT_NAME" | tr 'A-Z' 'a-z' | sed 's/d//')"
readonly SCM_VERSION="v2.4.1"
readonly SCRIPT_VERSION="v2.4.1"
SCRIPT_BRANCH="master"
SCRIPT_REPO="https://jackyaz.io/$SCRIPT_NAME/$SCRIPT_BRANCH"
readonly SCRIPT_DIR="/jffs/addons/$SCRIPT_NAME_LOWER.d"
readonly SCRIPT_WEBPAGE_DIR="$(readlink /www/user)"
readonly SCRIPT_WEB_DIR="$SCRIPT_WEBPAGE_DIR/$SCRIPT_NAME_LOWER"
readonly SHARED_DIR="/jffs/addons/shared-jy"
readonly SHARED_REPO="https://jackyaz.io/shared-jy/master"
readonly SHARED_WEB_DIR="$SCRIPT_WEBPAGE_DIR/shared-jy"
readonly NTP_WATCHDOG_FILE="$SCRIPT_DIR/.watchdogenabled"
readonly TAIL_TAINTED_FILE="$SCRIPT_DIR/.tailtaintdnsenabled"
[ -z "$(nvram get odmpid)" ] && ROUTER_MODEL=$(nvram get productid) || ROUTER_MODEL=$(nvram get odmpid)
### End of script variables ###

### Start of output format variables ###
readonly CRIT="\\e[41m"
readonly ERR="\\e[31m"
readonly WARN="\\e[33m"
readonly PASS="\\e[32m"
readonly BOLD="\\e[1m"
readonly SETTING="${BOLD}\\e[36m"
readonly CLEARFORMAT="\\e[0m"
### End of output format variables ###

##----------------------------------------------##
## Added/Modified by Martinski W. [2023-Jun-09] ##
##----------------------------------------------##
readonly BEGIN_InsertTag="/\*\*BEGIN:scMerlin\*\*/"
readonly ENDIN_InsertTag="/\*\*END:scMerlin\*\*/"
readonly SUPPORTstr="$(nvram get rc_support)"

if echo "$SUPPORTstr" | grep -qw '2.4G'
then Band_24G_Support=true
else Band_24G_Support=false
fi

if echo "$SUPPORTstr" | grep -qw '5G'
then Band_5G_1_Support=true
else Band_5G_1_Support=false
fi

if echo "$SUPPORTstr" | grep -qw '5G-2'
then Band_5G_2_support=true
else Band_5G_2_support=false
fi

if echo "$SUPPORTstr" | grep -qw 'wifi6e'
then Band_6G_1_Support=true
else Band_6G_1_Support=false
fi

##----------------------------------------------##
## Added/Modified by Martinski W. [2023-Jun-03] ##
##----------------------------------------------##
GetIFaceName()
{
    if [ $# -eq 0 ] || [ -z "$1" ] ; then echo "" ; return 1 ; fi

    theIFnamePrefix=""
    case "$1" in
        "2.4GHz")
            if "$Band_24G_Support"
            then
                if [ "$ROUTER_MODEL" = "GT-AXE16000" ]
                then theIFnamePrefix="wl3"
                else theIFnamePrefix="wl0"
                fi
            fi
            ;;
        "5GHz_1")
            if "$Band_5G_1_Support"
            then
                if [ "$ROUTER_MODEL" = "GT-AXE16000" ]
                then theIFnamePrefix="wl0"
                else theIFnamePrefix="wl1"
                fi
            fi
            ;;
        "5GHz_2")
            if "$Band_5G_2_support"
            then
                if [ "$ROUTER_MODEL" = "GT-AXE16000" ]
                then theIFnamePrefix="wl1"
                else theIFnamePrefix="wl2"
                fi
            fi
            ;;
        "6GHz_1")
            if [ "$ROUTER_MODEL" = "GT-AXE16000" ] || "$Band_6G_1_Support"
            then theIFnamePrefix="wl2" ; fi
            ;;
    esac
    if [ -z "$theIFnamePrefix" ]
    then echo ""
    else echo "$(nvram get "${theIFnamePrefix}_ifname")"
    fi
}

##-------------------------------------##
## Added by Martinski W. [2023-Jun-02] ##
##-------------------------------------##
GetTemperatureValue()
{
    theIFname="$(GetIFaceName "$1")"
    if [ -z "$theIFname" ]
    then echo "[N/A]"
    else echo "$(wl -i "$theIFname" phy_tempsense | awk '{print $1/2+20}')"
    fi
}

# $1 = print to syslog, $2 = message to print, $3 = log level
Print_Output(){
	if [ "$1" = "true" ]; then
		logger -t "$SCRIPT_NAME" "$2"
	fi
	printf "${BOLD}${3}%s${CLEARFORMAT}\\n\\n" "$2"
}

Firmware_Version_Check(){
	if nvram get rc_support | grep -qF "am_addons"; then
		return 0
	else
		return 1
	fi
}

### Code for these functions inspired by https://github.com/Adamm00 - credit to @Adamm ###
Check_Lock(){
	if [ -f "/tmp/$SCRIPT_NAME_LOWER.lock" ]; then
		ageoflock=$(($(date +%s) - $(date +%s -r "/tmp/$SCRIPT_NAME_LOWER.lock")))
		if [ "$ageoflock" -gt 60 ]; then
			Print_Output true "Stale lock file found (>60 seconds old) - purging lock" "$ERR"
			kill "$(sed -n '1p' "/tmp/$SCRIPT_NAME_LOWER.lock")" >/dev/null 2>&1
			Clear_Lock
			echo "$$" > "/tmp/$SCRIPT_NAME_LOWER.lock"
			return 0
		else
			Print_Output true "Lock file found (age: $ageoflock seconds)" "$ERR"
			if [ -z "$1" ]; then
				exit 1
			else
				return 1
			fi
		fi
	else
		echo "$$" > "/tmp/$SCRIPT_NAME_LOWER.lock"
		return 0
	fi
}

Clear_Lock(){
	rm -f "/tmp/$SCRIPT_NAME_LOWER.lock" 2>/dev/null
	return 0
}

##############################################

Set_Version_Custom_Settings(){
	SETTINGSFILE="/jffs/addons/custom_settings.txt"
	case "$1" in
		local)
			if [ -f "$SETTINGSFILE" ]; then
				if [ "$(grep -c "scmerlin_version_local" $SETTINGSFILE)" -gt 0 ]; then
					if [ "$2" != "$(grep "scmerlin_version_local" /jffs/addons/custom_settings.txt | cut -f2 -d' ')" ]; then
						sed -i "s/scmerlin_version_local.*/scmerlin_version_local $2/" "$SETTINGSFILE"
					fi
				else
					echo "scmerlin_version_local $2" >> "$SETTINGSFILE"
				fi
			else
				echo "scmerlin_version_local $2" >> "$SETTINGSFILE"
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
	localver=$(grep "SCRIPT_VERSION=" "/jffs/scripts/$SCRIPT_NAME_LOWER" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/404/$SCRIPT_NAME_LOWER.sh" | grep -qF "jackyaz" || { Print_Output true "404 error detected - stopping update" "$ERR"; return 1; }
	serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/version/$SCRIPT_NAME_LOWER.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	if [ "$localver" != "$serverver" ]; then
		doupdate="version"
		Set_Version_Custom_Settings server "$serverver"
		echo 'var updatestatus = "'"$serverver"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
	else
		localmd5="$(md5sum "/jffs/scripts/$SCRIPT_NAME_LOWER" | awk '{print $1}')"
		remotemd5="$(curl -fsL --retry 3 "$SCRIPT_REPO/md5/$SCRIPT_NAME_LOWER.sh" | md5sum | awk '{print $1}')"
		if [ "$localmd5" != "$remotemd5" ]; then
			doupdate="md5"
			Set_Version_Custom_Settings server "$serverver-hotfix"
			echo 'var updatestatus = "'"$serverver-hotfix"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
		fi
	fi
	if [ "$doupdate" = "false" ]; then
		echo 'var updatestatus = "None";' > "$SCRIPT_WEB_DIR/detect_update.js"
	fi
	echo "$doupdate,$localver,$serverver"
}

Update_Version(){
	if [ -z "$1" ]; then
		updatecheckresult="$(Update_Check)"
		isupdate="$(echo "$updatecheckresult" | cut -f1 -d',')"
		localver="$(echo "$updatecheckresult" | cut -f2 -d',')"
		serverver="$(echo "$updatecheckresult" | cut -f3 -d',')"
		
		if [ "$isupdate" = "version" ]; then
			Print_Output true "New version of $SCRIPT_NAME available - $serverver" "$PASS"
		elif [ "$isupdate" = "md5" ]; then
			Print_Output true "MD5 hash of $SCRIPT_NAME does not match - hotfix available - $serverver" "$PASS"
		fi
		
		if [ "$isupdate" != "false" ]; then
			printf "\\n${BOLD}Do you want to continue with the update? (y/n)${CLEARFORMAT}  "
			read -r confirm
			case "$confirm" in
				y|Y)
					printf "\\n"
					Update_File shared-jy.tar.gz
					Update_File scmerlin_www.asp
					Update_File sitemap.asp
					Update_File tailtop
					Update_File tailtopd
					Update_File tailtaintdns
					Update_File tailtaintdnsd
					Update_File sc.func
					Update_File S99tailtop
					Update_File S95tailtaintdns
					Download_File "$SCRIPT_REPO/update/$SCRIPT_NAME_LOWER.sh" "/jffs/scripts/$SCRIPT_NAME_LOWER" && Print_Output true "$SCRIPT_NAME successfully updated"
					chmod 0755 "/jffs/scripts/$SCRIPT_NAME_LOWER"
					Set_Version_Custom_Settings local "$serverver"
					Set_Version_Custom_Settings server "$serverver"
					Clear_Lock
					PressEnter
					exec "$0"
					exit 0
				;;
				*)
					printf "\\n"
					Clear_Lock
					return 1
				;;
			esac
		else
			Print_Output true "No updates available - latest is $localver" "$WARN"
			Clear_Lock
		fi
	fi
	
	if [ "$1" = "force" ]; then
		serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/version/$SCRIPT_NAME_LOWER.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
		Print_Output true "Downloading latest version ($serverver) of $SCRIPT_NAME" "$PASS"
		Update_File shared-jy.tar.gz
		Update_File scmerlin_www.asp
		Update_File sitemap.asp
		Update_File tailtop
		Update_File tailtopd
		Update_File tailtaintdns
		Update_File tailtaintdnsd
		Update_File sc.func
		Update_File S99tailtop
		Update_File S95tailtaintdns
		Download_File "$SCRIPT_REPO/update/$SCRIPT_NAME_LOWER.sh" "/jffs/scripts/$SCRIPT_NAME_LOWER" && Print_Output true "$SCRIPT_NAME successfully updated"
		chmod 0755 "/jffs/scripts/$SCRIPT_NAME_LOWER"
		Set_Version_Custom_Settings local "$serverver"
		Set_Version_Custom_Settings server "$serverver"
		Clear_Lock
		if [ -z "$2" ]; then
			PressEnter
			exec "$0"
		elif [ "$2" = "unattended" ]; then
			exec "$0" postupdate
		fi
		exit 0
	fi
}

Update_File(){
	if [ "$1" = "scmerlin_www.asp" ] || [ "$1" = "sitemap.asp" ] ; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/files/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f "$SCRIPT_DIR/$1" ]; then
				Get_WebUI_Page "$SCRIPT_DIR/$1"
				sed -i "\\~$MyPage~d" /tmp/menuTree.js
				rm -f "$SCRIPT_WEBPAGE_DIR/$MyPage" 2>/dev/null
			fi
			Download_File "$SCRIPT_REPO/files/$1" "$SCRIPT_DIR/$1"
			Print_Output true "New version of $1 downloaded" "$PASS"
			Mount_WebUI
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "shared-jy.tar.gz" ]; then
		if [ ! -f "$SHARED_DIR/$1.md5" ]; then
			Download_File "$SHARED_REPO/$1" "$SHARED_DIR/$1"
			Download_File "$SHARED_REPO/$1.md5" "$SHARED_DIR/$1.md5"
			tar -xzf "$SHARED_DIR/$1" -C "$SHARED_DIR"
			rm -f "$SHARED_DIR/$1"
			Print_Output true "New version of $1 downloaded" "$PASS"
		else
			localmd5="$(cat "$SHARED_DIR/$1.md5")"
			remotemd5="$(curl -fsL --retry 3 "$SHARED_REPO/$1.md5")"
			if [ "$localmd5" != "$remotemd5" ]; then
				Download_File "$SHARED_REPO/$1" "$SHARED_DIR/$1"
				Download_File "$SHARED_REPO/$1.md5" "$SHARED_DIR/$1.md5"
				tar -xzf "$SHARED_DIR/$1" -C "$SHARED_DIR"
				rm -f "$SHARED_DIR/$1"
				Print_Output true "New version of $1 downloaded" "$PASS"
			fi
		fi
	elif [ "$1" = "S99tailtop" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/files/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f "$SCRIPT_DIR/S99tailtop" ]; then
				"$SCRIPT_DIR/S99tailtop" stop >/dev/null 2>&1
				sleep 2
			fi
			Download_File "$SCRIPT_REPO/files/$1" "$SCRIPT_DIR/$1"
			chmod 0755 "$SCRIPT_DIR/$1"
			"$SCRIPT_DIR/S99tailtop" start >/dev/null 2>&1
			Print_Output true "New version of $1 downloaded" "$PASS"
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "tailtop" ] || [ "$1" = "tailtopd" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/files/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f "$SCRIPT_DIR/S99tailtop" ]; then
				"$SCRIPT_DIR/S99tailtop" stop >/dev/null 2>&1
				sleep 2
			fi
			Download_File "$SCRIPT_REPO/files/$1" "$SCRIPT_DIR/$1"
			chmod 0755 "$SCRIPT_DIR/$1"
			"$SCRIPT_DIR/S99tailtop" start >/dev/null 2>&1
			Print_Output true "New version of $1 downloaded" "$PASS"
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "S95tailtaintdns" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/files/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f "$SCRIPT_DIR/S95tailtaintdns" ]; then
				"$SCRIPT_DIR/S95tailtaintdns" stop >/dev/null 2>&1
				sleep 2
			fi
			Download_File "$SCRIPT_REPO/files/$1" "$SCRIPT_DIR/$1"
			chmod 0755 "$SCRIPT_DIR/$1"
			if [ "$(NTPBootWatchdog check)" = "ENABLED" ]; then
				"$SCRIPT_DIR/S95tailtaintdns" start >/dev/null 2>&1
			fi
			Print_Output true "New version of $1 downloaded" "$PASS"
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "tailtaintdns" ] || [ "$1" = "tailtaintdnsd" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/files/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f "$SCRIPT_DIR/S95tailtaintdns" ]; then
				"$SCRIPT_DIR/S95tailtaintdns" stop >/dev/null 2>&1
				sleep 2
			fi
			Download_File "$SCRIPT_REPO/files/$1" "$SCRIPT_DIR/$1"
			chmod 0755 "$SCRIPT_DIR/$1"
			if [ "$(NTPBootWatchdog check)" = "ENABLED" ]; then
				"$SCRIPT_DIR/S95tailtaintdns" start >/dev/null 2>&1
			fi
			Print_Output true "New version of $1 downloaded" "$PASS"
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "sc.func" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/files/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			Download_File "$SCRIPT_REPO/files/$1" "$SCRIPT_DIR/$1"
			chmod 0755 "$SCRIPT_DIR/$1"
			Print_Output true "New version of $1 downloaded" "$PASS"
		fi
		rm -f "$tmpfile"
	else
		return 1
	fi
}

Validate_Number(){
	if [ "$1" -eq "$1" ] 2>/dev/null; then
		return 0
	else
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
	ln -s /tmp/addonwebpages.tmp "$SCRIPT_WEB_DIR/addonwebpages.htm" 2>/dev/null
	ln -s /tmp/scmcronjobs.tmp "$SCRIPT_WEB_DIR/scmcronjobs.htm" 2>/dev/null
	
	ln -s "$NTP_WATCHDOG_FILE" "$SCRIPT_WEB_DIR/watchdogenabled.htm" 2>/dev/null
	ln -s "$TAIL_TAINTED_FILE" "$SCRIPT_WEB_DIR/tailtaintdnsenabled.htm" 2>/dev/null
	
	if [ ! -d "$SHARED_WEB_DIR" ]; then
		ln -s "$SHARED_DIR" "$SHARED_WEB_DIR" 2>/dev/null
	fi
}

Auto_ServiceEvent(){
	case $1 in
		create)
			if [ -f /jffs/scripts/service-event ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/service-event)
				STARTUPLINECOUNTEX=$(grep -cx 'if echo "$2" | /bin/grep -q "'"$SCRIPT_NAME_LOWER"'"; then { /jffs/scripts/'"$SCRIPT_NAME_LOWER"' service_event "$@" & }; fi # '"$SCRIPT_NAME" /jffs/scripts/service-event)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/service-event
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo 'if echo "$2" | /bin/grep -q "'"$SCRIPT_NAME_LOWER"'"; then { /jffs/scripts/'"$SCRIPT_NAME_LOWER"' service_event "$@" & }; fi # '"$SCRIPT_NAME" >> /jffs/scripts/service-event
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/service-event
				echo "" >> /jffs/scripts/service-event
				echo 'if echo "$2" | /bin/grep -q "'"$SCRIPT_NAME_LOWER"'"; then { /jffs/scripts/'"$SCRIPT_NAME_LOWER"' service_event "$@" & }; fi # '"$SCRIPT_NAME" >> /jffs/scripts/service-event
				chmod 0755 /jffs/scripts/service-event
			fi
		;;
		delete)
			if [ -f /jffs/scripts/service-event ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/service-event)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/service-event
				fi
			fi
		;;
	esac
}

##----------------------------------------##
## Modified by Martinski W. [2024-Mar-12] ##
##----------------------------------------##
Auto_Startup(){
	case $1 in
		create)
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME$" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME$"'/d' /jffs/scripts/post-mount
				fi
			fi
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME$" /jffs/scripts/services-start)
				STARTUPLINECOUNTEX=$(grep -i -cx "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' & # '"$SCRIPT_NAME$" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME$"'/d' /jffs/scripts/services-start
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' & # '"$SCRIPT_NAME" >> /jffs/scripts/services-start
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/services-start
				echo "" >> /jffs/scripts/services-start
				echo "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' & # '"$SCRIPT_NAME" >> /jffs/scripts/services-start
				chmod 0755 /jffs/scripts/services-start
			fi
		;;
		delete)
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME$" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME$"'/d' /jffs/scripts/post-mount
				fi
			fi
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME$" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME$"'/d' /jffs/scripts/services-start
				fi
			fi
		;;
	esac
}

Download_File(){
	/usr/sbin/curl -fsL --retry 3 "$1" -o "$2"
}

Get_WebUI_Page(){
	MyPage="none"
	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
		page="/www/user/user$i.asp"
		if [ -f "$page" ] && [ "$(md5sum < "$1")" = "$(md5sum < "$page")" ]; then
			MyPage="user$i.asp"
			return
		elif [ "$MyPage" = "none" ] && [ ! -f "$page" ]; then
			MyPage="user$i.asp"
		fi
	done
}

### function based on @dave14305's FlexQoS webconfigpage function ###
Get_WebUI_URL(){
	urlpage=""
	urlproto=""
	urldomain=""
	urlport=""
	
	urlpage="$(sed -nE "/$SCRIPT_NAME/ s/.*url\: \"(user[0-9]+\.asp)\".*/\1/p" /tmp/menuTree.js)"
	if [ "$(nvram get http_enable)" -eq 1 ]; then
		urlproto="https"
	else
		urlproto="http"
	fi
	if [ -n "$(nvram get lan_domain)" ]; then
		urldomain="$(nvram get lan_hostname).$(nvram get lan_domain)"
	else
		urldomain="$(nvram get lan_ipaddr)"
	fi
	if [ "$(nvram get ${urlproto}_lanport)" -eq 80 ] || [ "$(nvram get ${urlproto}_lanport)" -eq 443 ]; then
		urlport=""
	else
		urlport=":$(nvram get ${urlproto}_lanport)"
	fi
	
	if echo "$urlpage" | grep -qE "user[0-9]+\.asp"; then
		echo "${urlproto}://${urldomain}${urlport}/${urlpage}" | tr "A-Z" "a-z"
	else
		echo "WebUI page not found"
	fi
}
### ###

##----------------------------------------##
## Modified by Martinski W. [2023-Jun-09] ##
##----------------------------------------##
### locking mechanism code credit to Martineau (@MartineauUK) ###
Mount_WebUI(){
	realpage=""
	Print_Output true "Mounting WebUI tabs for $SCRIPT_NAME" "$PASS"
	LOCKFILE=/tmp/addonwebui.lock
	FD=386
	eval exec "$FD>$LOCKFILE"
	flock -x "$FD"
	Get_WebUI_Page "$SCRIPT_DIR/scmerlin_www.asp"
	if [ "$MyPage" = "none" ]; then
		Print_Output true "Unable to mount $SCRIPT_NAME WebUI page, exiting" "$CRIT"
		flock -u "$FD"
		return 1
	fi
	cp -f "$SCRIPT_DIR/scmerlin_www.asp" "$SCRIPT_WEBPAGE_DIR/$MyPage"
	echo "$SCRIPT_NAME" > "$SCRIPT_WEBPAGE_DIR/$(echo $MyPage | cut -f1 -d'.').title"
	
	if [ "$(uname -o)" = "ASUSWRT-Merlin" ]; then
		if [ ! -f /tmp/index_style.css ]; then
			cp -f /www/index_style.css /tmp/
		fi
		
		if ! grep -q '.menu_Addons' /tmp/index_style.css ; then
			echo ".menu_Addons { background: url(ext/shared-jy/addons.png); background-size: contain; }" >> /tmp/index_style.css
		fi

		if grep -q '.menu_Addons' /tmp/index_style.css && ! grep -q 'url(ext/shared-jy/addons.png); background-size: contain;' /tmp/index_style.css; then
			sed -i 's/addons.png);/addons.png); background-size: contain;/' /tmp/index_style.css
		fi
		
		if grep -q '.dropdown-content {display: block;}' /tmp/index_style.css ; then
			sed -i '/dropdown-content/d' /tmp/index_style.css
		fi
		
		if ! grep -q '.dropdown-content {visibility: visible;}' /tmp/index_style.css ; then
			{
				echo ".dropdown-content {top: 0px; left: 185px; visibility: hidden; position: absolute; background-color: #3a4042; min-width: 165px; box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2); z-index: 1000;}"
				echo ".dropdown-content a {padding: 6px 8px; text-decoration: none; display: block; height: 100%; min-height: 20px; max-height: 40px; font-weight: bold; text-shadow: 1px 1px 0px black; font-family: Verdana, MS UI Gothic, MS P Gothic, Microsoft Yahei UI, sans-serif; font-size: 12px; border: 1px solid #6B7071;}"
				echo ".dropdown-content a:hover {background-color: #77a5c6;}"
				echo ".dropdown:hover .dropdown-content {visibility: visible;}"
			} >> /tmp/index_style.css
		fi
		
		umount /www/index_style.css 2>/dev/null
		mount -o bind /tmp/index_style.css /www/index_style.css
		
		if [ ! -f /tmp/menuTree.js ]; then
			cp -f /www/require/modules/menuTree.js /tmp/
		fi
		
		sed -i "\\~$MyPage~d" /tmp/menuTree.js
		
		## Use the same BEGIN/END insert tags here as those used in the "Menu_Uninstall()" function ##
		if ! grep -qE '^menuName: "Addons"' /tmp/menuTree.js
		then
			lineinsbefore="$(($(grep -n "^exclude:" /tmp/menuTree.js | cut -f1 -d':') - 1))"
			sed -i "$lineinsbefore""i\
${BEGIN_InsertTag}\n\
,\n{\n\
menuName: \"Addons\",\n\
index: \"menu_Addons\",\n\
tab: [\n\
{url: \"javascript:var helpwindow=window.open('\/ext\/shared-jy\/redirect.htm')\", tabName: \"Help & Support\"},\n\
{url: \"NULL\", tabName: \"__INHERIT__\"}\n\
]\n}\n\
${ENDIN_InsertTag}" /tmp/menuTree.js
		fi
		
		sed -i "/url: \"javascript:var helpwindow=window.open('\/ext\/shared-jy\/redirect.htm'/i {url: \"$MyPage\", tabName: \"$SCRIPT_NAME\"}," /tmp/menuTree.js
		realpage="$MyPage"
		
		if [ -f "$SCRIPT_DIR/sitemap.asp" ]; then
			Get_WebUI_Page "$SCRIPT_DIR/sitemap.asp"
			if [ "$MyPage" = "none" ]; then
				Print_Output true "Unable to mount $SCRIPT_NAME sitemap page, exiting" "$CRIT"
				flock -u "$FD"
				return 1
			fi
			cp -f "$SCRIPT_DIR/sitemap.asp" "$SCRIPT_WEBPAGE_DIR/$MyPage"
			sed -i "\\~$MyPage~d" /tmp/menuTree.js
			sed -i "/url: \"javascript:var helpwindow=window.open('\/ext\/shared-jy\/redirect.htm'/a {url: \"$MyPage\", tabName: \"Sitemap\"}," /tmp/menuTree.js
			
			umount /www/state.js 2>/dev/null
			cp -f /www/state.js /tmp/
			sed -i 's~<td width=\\"335\\" id=\\"bottom_help_link\\" align=\\"left\\">~<td width=\\"335\\" id=\\"bottom_help_link\\" align=\\"left\\"><a style=\\"font-weight: bolder;text-decoration:underline;cursor:pointer;\\" href=\\"\/'"$MyPage"'\\" target=\\"_blank\\">Sitemap<\/a>\&nbsp\|\&nbsp~' /tmp/state.js
			
			cat << 'EOF' >> /tmp/state.js
var myMenu = [];
function AddDropdowns(){
	if(myMenu.length == 0){
		setTimeout(AddDropdowns,1000);
		return;
	}
	for(var i = 0; i < myMenu.length; i++){
		var sitemapstring = '<div class="dropdown-content">';
		for(var i2 = 0; i2 < myMenu[i].tabs.length; i2++){
			if(myMenu[i].tabs[i2].tabName == '__HIDE__'){
				continue;
			}
		var tabname = myMenu[i].tabs[i2].tabName;
		var taburl = myMenu[i].tabs[i2].url;
		if(tabname == '__INHERIT__'){
			tabname = taburl.split('.')[0];
		}
		if(taburl.indexOf('redirect.htm') != -1){
			taburl = '/ext/shared-jy/redirect.htm';
		}
		sitemapstring += '<a href="'+taburl+'">'+tabname+'</a>';
		}
		document.getElementsByClassName(myMenu[i].index)[0].parentElement.parentElement.parentElement.parentElement.parentElement.innerHTML += sitemapstring;
		document.getElementsByClassName(myMenu[i].index)[0].parentElement.parentElement.parentElement.parentElement.parentElement.classList.add('dropdown');
	}
}

function GenerateSiteMap(showurls){
	myMenu = [];
	
	if(typeof menuList == 'undefined' || menuList == null){
		setTimeout(GenerateSiteMap,1000,false);
		return;
	}
	
	for(var i = 0; i < menuList.length; i++){
		var myobj = {};
		myobj.menuName = menuList[i].menuName;
		myobj.index = menuList[i].index;
		
		var myTabs = menuList[i].tab.filter(function(item){
			return !menuExclude.tabs.includes(item.url);
		});
		myTabs = myTabs.filter(function(item){
			if(item.tabName == '__INHERIT__' && item.url == 'NULL'){
				return false;
			}
			else{
				return true;
			}
		});
		myTabs = myTabs.filter(function(item){
			if(item.tabName == '__HIDE__' && item.url == 'NULL'){
				return false;
			}
			else{
				return true;
			}
		});
		myTabs = myTabs.filter(function(item){
			return item.url.indexOf('TrafficMonitor_dev') == -1;
		});
		myTabs = myTabs.filter(function(item){
			return item.url != 'AdaptiveQoS_Adaptive.asp';
		});
		myobj.tabs = myTabs;
		
		myMenu.push(myobj);
	}
	
	myMenu = myMenu.filter(function(item) {
		return !menuExclude.menus.includes(item.index);
	});
	myMenu = myMenu.filter(function(item) {
		return item.index != 'menu_Split';
	});
	
	var sitemapstring = '';
	
	for(var i = 0; i < myMenu.length; i++){
		if(myMenu[i].tabs[0].tabName == '__HIDE__' && myMenu[i].tabs[0].url != 'NULL'){
			if(showurls == true){
				sitemapstring += '<span style="font-size:14px;background-color:#4D595D;"><b><a style="color:#FFCC00;background-color:#4D595D;" href="'+myMenu[i].tabs[0].url+'" target="_blank">'+myMenu[i].menuName+'</a> - '+myMenu[i].tabs[0].url+'</b></span><br>';
			}
			else{
				sitemapstring += '<span style="font-size:14px;background-color:#4D595D;"><b><a style="color:#FFCC00;background-color:#4D595D;" href="'+myMenu[i].tabs[0].url+'" target="_blank">'+myMenu[i].menuName+'</a></b></span><br>';
			}
		}
		else{
			sitemapstring += '<span style="font-size:14px;background-color:#4D595D;"><b>'+myMenu[i].menuName+'</b></span><br>';
		}
		for(var i2 = 0; i2 < myMenu[i].tabs.length; i2++){
			if(myMenu[i].tabs[i2].tabName == '__HIDE__'){
				continue;
			}
			var tabname = myMenu[i].tabs[i2].tabName;
			var taburl = myMenu[i].tabs[i2].url;
			if(tabname == '__INHERIT__'){
				tabname = taburl.split('.')[0];
			}
			if(taburl.indexOf('redirect.htm') != -1){
				taburl = '/ext/shared-jy/redirect.htm';
			}
			if(showurls == true){
				sitemapstring += '<a style="text-decoration:underline;background-color:#4D595D;" href="'+taburl+'" target="_blank">'+tabname+'</a> - '+taburl+'<br>';
			}
			else{
				sitemapstring += '<a style="text-decoration:underline;background-color:#4D595D;" href="'+taburl+'" target="_blank">'+tabname+'</a><br>';
			}
		}
		sitemapstring += '<br>';
	}
	return sitemapstring;
}
GenerateSiteMap(false);
AddDropdowns();
EOF
			mount -o bind /tmp/state.js /www/state.js
			
			Print_Output true "Mounted Sitemap page as $MyPage" "$PASS"
		fi
		
		umount /www/require/modules/menuTree.js 2>/dev/null
		mount -o bind /tmp/menuTree.js /www/require/modules/menuTree.js
	fi
	flock -u "$FD"
	Print_Output true "Mounted $SCRIPT_NAME WebUI page as $realpage" "$PASS"
}

Get_Cron_Jobs(){
	printf "%-27s┌────────── minute (0 - 59)\\n" " "
	printf "%-27s│%-6s┌──────── hour (0 - 23)\\n" " " " "
	printf "%-27s│%-6s│%-6s┌────── day of month (1 - 31)\\n" " " " " " "
	printf "%-27s│%-6s│%-6s│%-6s┌──── month (1 - 12)\\n" " " " " " " " "
	printf "%-27s│%-6s│%-6s│%-6s│%-6s┌── day of week (0 - 6 => Sunday - Saturday)\\n" " " " " " " " " " "
	printf "%-27s│%-6s│%-6s│%-6s│%-6s│\\n" " " " " " " " " " "
	printf "%-27s↓%-6s↓%-6s↓%-6s↓%-6s↓\\n" " " " " " " " " " "
	printf "${BOLD}%-25s %-6s %-6s %-6s %-6s %-9s %s${CLEARFORMAT}\\n" "Cron job name" "Min" "Hour" "DayM" "Month" "DayW" "Command"
	cru l | sed 's/,/|/g' | awk 'FS="#" {printf "%s %s\n",$2,$1}' | awk '{printf "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"",$1,$2,$3,$4,$5,$6;for(i=7; i<=NF; ++i) printf "%s ", $i; print "\""}' | sed 's/ "$/"/g' > /tmp/scmcronjobs.tmp
	cronjobs="$(cru l | awk 'FS="#" {printf "%s %s\n",$2,$1}' | awk '{printf "%-25s %-6s %-6s %-6s %-6s %-10s",$1,$2,$3,$4,$5,$6;for(i=7; i<=NF; ++i) printf "%s ", $i; print ""}')"
	echo "$cronjobs"
	}

Get_Addon_Pages(){
	urlpage=""
	urlproto=""
	urldomain=""
	urlport=""
	
	if [ "$(nvram get http_enable)" -eq 1 ]; then
		urlproto="https"
	else
		urlproto="http"
	fi
	if [ -n "$(nvram get lan_domain)" ]; then
		urldomain="$(nvram get lan_hostname).$(nvram get lan_domain)"
	else
		urldomain="$(nvram get lan_ipaddr)"
	fi
	if [ "$(nvram get ${urlproto}_lanport)" -eq 80 ] || [ "$(nvram get ${urlproto}_lanport)" -eq 443 ]; then
		urlport=""
	else
		urlport=":$(nvram get ${urlproto}_lanport)"
	fi
	
	weburl="$(echo "${urlproto}://${urldomain}${urlport}/" | tr "A-Z" "a-z")"
	grep "user.*\.asp" /tmp/menuTree.js | awk -F'"' -v wu="$weburl" '{printf "%-12s "wu"%s\n",$4,$2}' | sort -f
	grep "user.*\.asp" /tmp/menuTree.js | awk -F'"' -v wu="$weburl" '{printf "%s,"wu"%s\n",$4,$2}' > /tmp/addonwebpages.tmp
}

NTPBootWatchdog(){
	case "$1" in
		enable)
			touch "$NTP_WATCHDOG_FILE"
			cat << "EOF" > /jffs/scripts/ntpbootwatchdog.sh
#!/bin/sh
if [ "$(nvram get ntp_ready)" -eq 1 ]; then
	/usr/bin/logger -st ntpbootwatchdog "NTP is synced, exiting"
else
	/usr/bin/logger -st ntpbootwatchdog "NTP boot watchdog started..."
	ntptimer=0
	while [ "$(nvram get ntp_ready)" -eq 0 ] && [ "$ntptimer" -lt 600 ]; do
		if [ "$ntptimer" -ne 0 ]; then
			/usr/bin/logger -st ntpbootwatchdog "Still waiting for NTP to sync..."
		fi
		killall ntp
		killall ntpd
		service restart_ntpd
		ntptimer=$((ntptimer+30))
		sleep 30
	done
	
	if [ "$ntptimer" -ge 600 ]; then
		/usr/bin/logger -st ntpbootwatchdog "NTP failed to sync after 10 minutes - please check immediately!"
		exit 1
	else
		/usr/bin/logger -st ntpbootwatchdog "NTP has synced!"
	fi
fi
EOF
			chmod +x /jffs/scripts/ntpbootwatchdog.sh
			if [ -f /jffs/scripts/init-start ]; then
				STARTUPLINECOUNT=$(grep -i -c 'ntpbootwatchdog' /jffs/scripts/init-start)
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/ntpbootwatchdog/d' /jffs/scripts/init-start
				fi
				
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/init-start)
				STARTUPLINECOUNTEX=$(grep -i -cx "sh /jffs/scripts/ntpbootwatchdog.sh & # $SCRIPT_NAME" /jffs/scripts/init-start)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/init-start
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo "sh /jffs/scripts/ntpbootwatchdog.sh & # $SCRIPT_NAME" >> /jffs/scripts/init-start
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/init-start
				echo "" >> /jffs/scripts/init-start
				echo "sh /jffs/scripts/ntpbootwatchdog.sh & # $SCRIPT_NAME" >> /jffs/scripts/init-start
				chmod 0755 /jffs/scripts/init-start
			fi
		;;
		disable)
			rm -f "$NTP_WATCHDOG_FILE"
			rm -f /jffs/scripts/ntpbootwatchdog.sh
			if [ -f /jffs/scripts/init-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/init-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/init-start
				fi
			fi
		;;
		check)
			if [ -f /jffs/scripts/ntpbootwatchdog.sh ] && [ "$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/init-start)" -gt 0 ]; then
				echo "ENABLED"
			else
				echo "DISABLED"
			fi
		;;
	esac
}

TailTaintDns(){
	case "$1" in
		enable)
			touch "$TAIL_TAINTED_FILE"
			"$SCRIPT_DIR/S95tailtaintdns" start >/dev/null 2>&1
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME - tailtaintdns" /jffs/scripts/services-start)
				STARTUPLINECOUNTEX=$(grep -i -cx "$SCRIPT_DIR/S95tailtaintdns start >/dev/null 2>&1 & # $SCRIPT_NAME - tailtaintdns" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME - tailtaintdns"'/d' /jffs/scripts/services-start
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo "$SCRIPT_DIR/S95tailtaintdns start >/dev/null 2>&1 & # $SCRIPT_NAME - tailtaintdns" >> /jffs/scripts/services-start
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/services-start
				echo "" >> /jffs/scripts/services-start
				echo "$SCRIPT_DIR/S95tailtaintdns start >/dev/null 2>&1 & # $SCRIPT_NAME - tailtaintdns" >> /jffs/scripts/services-start
				chmod 0755 /jffs/scripts/services-start
			fi
		;;
		disable)
			rm -f "$TAIL_TAINTED_FILE"
			"$SCRIPT_DIR/S95tailtaintdns" stop >/dev/null 2>&1
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME - tailtaintdns" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"' - tailtaintdns/d' /jffs/scripts/services-start
				fi
			fi
		;;
		check)
			if [ -f "$TAIL_TAINTED_FILE" ] && [ "$(grep -i -c '# '"$SCRIPT_NAME - tailtaintdns" /jffs/scripts/services-start)" -gt 0 ]; then
				echo "ENABLED"
			else
				echo "DISABLED"
			fi
		;;
	esac
}

Process_Upgrade(){
	if [ -f /opt/etc/init.d/S99tailtop ]; then
		/opt/etc/init.d/S99tailtop stop >/dev/null 2>&1
		sleep 2
		rm -f /opt/etc/init.d/S99tailtop 2>/dev/null
		rm -f /opt/bin/tailtopd
		Update_File sc.func
		Update_File S99tailtop
		rm -f "$SCRIPT_DIR/.usbdisabled"
	fi
	if [ ! -f "$SCRIPT_DIR/S95tailtaintdns" ]; then
		Update_File tailtaintdns
		Update_File tailtaintdnsd
		Update_File S95tailtaintdns
		rm -f "$SCRIPT_DIR/.usbdisabled"
	fi
	if [ ! -f "$SCRIPT_DIR/sitemap.asp" ]; then
		Update_File sitemap.asp
	fi
	
	if [ "$(uname -o)" = "ASUSWRT-Merlin" ]; then
		if grep '.dropdown-content' /tmp/index_style.css | grep -q '{display: block;}'; then
			
			umount /www/index_style.css 2>/dev/null
			cp -f /www/index_style.css /tmp/
			
			echo ".menu_Addons { background: url(ext/shared-jy/addons.png); }" >> /tmp/index_style.css
			
			{
				echo ".dropdown-content {top: 0px; left: 185px; visibility: hidden; position: absolute; background-color: #3a4042; min-width: 165px; box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2); z-index: 1000;}"
				echo ".dropdown-content a {padding: 6px 8px; text-decoration: none; display: block; height: 100%; min-height: 20px; max-height: 40px; font-weight: bold; text-shadow: 1px 1px 0px black; font-family: Verdana, MS UI Gothic, MS P Gothic, Microsoft Yahei UI, sans-serif; font-size: 12px; border: 1px solid #6B7071;}"
				echo ".dropdown-content a:hover {background-color: #77a5c6;}"
				echo ".dropdown:hover .dropdown-content {visibility: visible;}"
			} >> /tmp/index_style.css
			
			mount -o bind /tmp/index_style.css /www/index_style.css
		fi
	fi
}

Shortcut_Script(){
	case $1 in
		create)
			if [ -d /opt/bin ] && [ ! -f "/opt/bin/$SCRIPT_NAME_LOWER" ] && [ -f "/jffs/scripts/$SCRIPT_NAME_LOWER" ]; then
				ln -s "/jffs/scripts/$SCRIPT_NAME_LOWER" /opt/bin
				chmod 0755 "/opt/bin/$SCRIPT_NAME_LOWER"
			fi
		;;
		delete)
			if [ -f "/opt/bin/$SCRIPT_NAME_LOWER" ]; then
				rm -f "/opt/bin/$SCRIPT_NAME_LOWER"
			fi
		;;
	esac
}

PressEnter(){
	while true; do
		printf "Press enter to continue..."
		read -r key
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
	printf "${BOLD}######################################################${CLEARFORMAT}\\n"
	printf "${BOLD}##               __  __              _  _           ##${CLEARFORMAT}\\n"
	printf "${BOLD}##              |  \/  |            | |(_)          ##${CLEARFORMAT}\\n"
	printf "${BOLD}##    ___   ___ | \  / |  ___  _ __ | | _  _ __     ##${CLEARFORMAT}\\n"
	printf "${BOLD}##   / __| / __|| |\/| | / _ \| '__|| || || '_ \    ##${CLEARFORMAT}\\n"
	printf "${BOLD}##   \__ \| (__ | |  | ||  __/| |   | || || | | |   ##${CLEARFORMAT}\\n"
	printf "${BOLD}##   |___/ \___||_|  |_| \___||_|   |_||_||_| |_|   ##${CLEARFORMAT}\\n"
	printf "${BOLD}##                                                  ##${CLEARFORMAT}\\n"
	printf "${BOLD}##               %s on %-11s              ##${CLEARFORMAT}\\n" "$SCRIPT_VERSION" "$ROUTER_MODEL"
	printf "${BOLD}##                                                  ##${CLEARFORMAT}\\n"
	printf "${BOLD}##       https://github.com/jackyaz/scMerlin        ##${CLEARFORMAT}\\n"
	printf "${BOLD}##                                                  ##${CLEARFORMAT}\\n"
	printf "${BOLD}######################################################${CLEARFORMAT}\\n"
	printf "\\n"
}

MainMenu(){
	printf "WebUI for %s is available at:\\n${SETTING}%s${CLEARFORMAT}\\n\\n" "$SCRIPT_NAME" "$(Get_WebUI_URL)"
	printf "${BOLD}\\e[4mServices${CLEARFORMAT}"
	printf "${BOLD}${WARN} (selecting an option will restart the service)${CLEARFORMAT}\\n"
	printf "1.    DNS/DHCP Server (dnsmasq)\\n"
	printf "2.    Internet connection\\n"
	printf "3.    Web Interface (httpd)\\n"
	printf "4.    WiFi\\n"
	printf "5.    FTP Server (vsftpd)\\n"
	printf "6.    Samba\\n"
	printf "7.    DDNS client\\n"
	printf "8.    Timeserver (ntpd/chronyd)\\n"
	vpnclients="$(nvram show 2> /dev/null | grep "^vpn_client._addr")"
	vpnclientenabled="false"
	for vpnclient in $vpnclients; do
		if [ -n "$(nvram get "$(echo "$vpnclient" | cut -f1 -d'=')")" ]; then
			vpnclientenabled="true"
		fi
	done
	if [ "$vpnclientenabled" = "true" ]; then
		printf "\\n${BOLD}\\e[4mVPN Clients${CLEARFORMAT}"
		printf "${BOLD}${WARN} (selecting an option will restart the VPN Client)${CLEARFORMAT}\\n"
		vpnclientnum=1
		while [ "$vpnclientnum" -lt 6 ]; do
			printf "vc%s.  VPN Client %s (%s)\\n" "$vpnclientnum" "$vpnclientnum" "$(nvram get vpn_client"$vpnclientnum"_desc)"
			vpnclientnum=$((vpnclientnum + 1))
		done
	fi
	vpnservercount="$(nvram get vpn_serverx_start | awk '{n=split($0, array, ",")} END{print n-1 }')"
	vpnserverenabled="false"
	if [ "$vpnservercount" -gt 0 ]; then
		vpnserverenabled="true"
	fi
	if [ "$vpnserverenabled" = "true" ]; then
		printf "\\n${BOLD}\\e[4mVPN Servers${CLEARFORMAT}"
		printf "${BOLD}${WARN} (selecting an option will restart the VPN Server)${CLEARFORMAT}\\n"
		vpnservernum=1
		while [ "$vpnservernum" -lt 3 ]; do
			vpnsdesc=""
			if ! nvram get vpn_serverx_start | grep -q "$vpnservernum"; then
				vpnsdesc="(Not configured)"
			fi
			printf "vs%s.  VPN Server %s %s\\n" "$vpnservernum" "$vpnservernum" "$vpnsdesc"
			vpnservernum=$((vpnservernum + 1))
		done
	fi
	if [ -f /opt/bin/opkg ]; then
		printf "\\n${BOLD}\\e[4mEntware${CLEARFORMAT}\\n"
		printf "et.   Restart all Entware applications\\n"
	fi
	printf "\\n${BOLD}\\e[4mRouter${CLEARFORMAT}\\n"
	printf "c.    View running processes\\n"
	printf "m.    View RAM/memory usage\\n"
	printf "cr.   View cron jobs\\n"
	printf "t.    View router temperatures\n"
	printf "w.    List Addon WebUI tab to page mapping\n"
	printf "r.    Reboot router\\n\\n"
	printf "${BOLD}\\e[4mOther${CLEARFORMAT}\\n"
	if [ "$(NTPBootWatchdog check)" = "ENABLED" ]; then
		NTPBW_ENABLED="${SETTING}Enabled"
	else
		NTPBW_ENABLED="Disabled"
	fi
	printf "ntp.  Toggle NTP boot watchdog script\\n      Currently: ${BOLD}$NTPBW_ENABLED${CLEARFORMAT}\\n\\n"
	if [ "$(TailTaintDns check)" = "ENABLED" ]; then
		TAILTAINT_ENABLED="${SETTING}Enabled"
	else
		TAILTAINT_ENABLED="Disabled"
	fi
	printf "dns.  Toggle dnsmasq tainted watchdog script\\n      Currently: ${BOLD}$TAILTAINT_ENABLED${CLEARFORMAT}\\n\\n"
	printf "u.    Check for updates\\n"
	printf "uf.   Update %s with latest version (force update)\\n\\n" "$SCRIPT_NAME"
	printf "e.    Exit %s\\n\\n" "$SCRIPT_NAME"
	printf "z.    Uninstall %s\\n" "$SCRIPT_NAME"
	printf "\\n"
	printf "${BOLD}######################################################${CLEARFORMAT}\\n"
	printf "\\n"
	while true; do
		printf "Choose an option:  "
		read -r menu
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
					printf "\\n${BOLD}Internet connection will take 30s-60s to reconnect. Continue? (y/n)${CLEARFORMAT}  "
					read -r confirm
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
				ENABLED_FTP="$(nvram get enable_ftp)"
				if ! Validate_Number "$ENABLED_FTP"; then ENABLED_FTP=0; fi
				if [ "$ENABLED_FTP" -eq 1 ]; then
					printf "\\n"
					service restart_ftpd >/dev/null 2>&1
				else
				printf "\\n${BOLD}\\e[31mInvalid selection (FTP not enabled)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			6)
				ENABLED_SAMBA="$(nvram get enable_samba)"
				if ! Validate_Number "$ENABLED_SAMBA"; then ENABLED_SAMBA=0; fi
				if [ "$ENABLED_SAMBA" -eq 1 ]; then
					printf "\\n"
					service restart_samba >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (Samba not enabled)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			7)
				ENABLED_DDNS="$(nvram get ddns_enable_x)"
				if ! Validate_Number "$ENABLED_DDNS"; then ENABLED_DDNS=0; fi
				if [ "$ENABLED_DDNS" -eq 1 ]; then
					printf "\\n"
					service restart_ddns >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (DDNS client not enabled)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			8)
				ENABLED_NTPD="$(nvram get ntpd_enable)"
				if ! Validate_Number "$ENABLED_NTPD"; then ENABLED_NTPD=0; fi
				if [ "$ENABLED_NTPD" -eq 1 ]; then
					printf "\\n"
					service restart_time >/dev/null 2>&1
				elif [ -f /opt/etc/init.d/S77ntpd ]; then
					printf "\\n"
					/opt/etc/init.d/S77ntpd restart
				elif [ -f /opt/etc/init.d/S77chronyd ]; then
					printf "\\n"
					/opt/etc/init.d/S77chronyd restart
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (NTP server not enabled/installed)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vc1)
				if [ -n "$(nvram get vpn_client1_addr)" ]; then
					printf "\\n"
					service restart_vpnclient1 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Client not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vc2)
				if [ -n "$(nvram get vpn_client2_addr)" ]; then
					printf "\\n"
					service restart_vpnclient2 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Client not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vc3)
				if [ -n "$(nvram get vpn_client3_addr)" ]; then
					printf "\\n"
					service restart_vpnclient3 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Client not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vc4)
				if [ -n "$(nvram get vpn_client4_addr)" ]; then
					printf "\\n"
					service restart_vpnclient4 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Client not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vc5)
				if [ -n "$(nvram get vpn_client5_addr)" ]; then
					printf "\\n"
					service restart_vpnclient5 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Client not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vs1)
				if nvram get vpn_serverx_start | grep -q 1; then
					printf "\\n"
					service restart_vpnserver1 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Server not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			vs2)
				if nvram get vpn_serverx_start | grep -q 2; then
					printf "\\n"
					service restart_vpnserver2 >/dev/null 2>&1
				else
					printf "\\n${BOLD}\\e[31mInvalid selection (VPN Server not configured)${CLEARFORMAT}\\n\\n"
				fi
				PressEnter
				break
			;;
			et)
				printf "\\n"
				if [ -f /opt/bin/opkg ]; then
					if Check_Lock menu; then
						while true; do
							printf "\\n${BOLD}Are you sure you want to restart all Entware scripts? (y/n)${CLEARFORMAT}  "
							read -r confirm
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
					printf "\\n${BOLD}\\e[31mInvalid selection (Entware not installed)${CLEARFORMAT}\\n"
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
							printf "\\n${BOLD}Would you like to install htop (enhanced version of top)? (y/n)${CLEARFORMAT}  "
							read -r confirm
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
				printf "\\n"
				PressEnter
				break
			;;
			cr)
				ScriptHeader
				Get_Cron_Jobs
				printf "\\n"
				PressEnter
				break
			;;
			t)
				ScriptHeader
				printf "\\n${BOLD}Temperatures${CLEARFORMAT}\\n\\n"
				if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
					printf "CPU:\t %s°C\\n" "$(awk '{ print int($1/1000) }' /sys/class/thermal/thermal_zone0/temp)"
				elif [ -f /proc/dmu/temperature ]; then
					printf "CPU:\t %s\\n" "$(cut -f2 -d':' /proc/dmu/temperature | awk '{$1=$1;print}' | sed 's/..$/°C/')"
				else
					printf "CPU:\t [N/A]\\n"
				fi
				
				##----------------------------------------------##
				## Added/Modified by Martinski W. [2023-Jun-03] ##
				##----------------------------------------------##
				theTemptrVal="$(GetTemperatureValue "2.4GHz")"
				if [ -n "$theTemptrVal" ] ; then printf "2.4 GHz: %s°C\n" "$theTemptrVal" ; fi
				
				if [ "$ROUTER_MODEL" = "RT-AC87U" ] || [ "$ROUTER_MODEL" = "RT-AC87R" ]; then
					printf "5 GHz:   %s°C\n" "$(qcsapi_sockrpc get_temperature | awk 'FNR == 2 {print $3}')"
					echo ; PressEnter
					break
				fi

				if "$Band_5G_2_support"
				then
					theTemptrVal="$(GetTemperatureValue "5GHz_1")"
					if [ -n "$theTemptrVal" ] ; then printf "5 GHz-1: %s°C\n" "$theTemptrVal" ; fi

					theTemptrVal="$(GetTemperatureValue "5GHz_2")"
					if [ -n "$theTemptrVal" ] ; then printf "5 GHz-2: %s°C\n" "$theTemptrVal" ; fi
				elif "$Band_5G_1_Support"
				then
					theTemptrVal="$(GetTemperatureValue "5GHz_1")"
					if [ -n "$theTemptrVal" ] ; then printf "5 GHz:   %s°C\n" "$theTemptrVal" ; fi
				fi
				if "$Band_6G_1_Support"
				then
					theTemptrVal="$(GetTemperatureValue "6GHz_1")"
					if [ -n "$theTemptrVal" ] ; then printf "6 GHz:   %s°C\n" "$theTemptrVal" ; fi
				fi
				echo ; PressEnter
				break
			;;
			w)
				ScriptHeader
				Get_Addon_Pages
				printf "\\n"
				PressEnter
				break
			;;
			r)
				printf "\\n"
				while true; do
					if [ "$ROUTER_MODEL" = "RT-AC86U" ]; then
						printf "\\n${BOLD}${WARN}Remote reboots are not recommend for %s${CLEARFORMAT}" "$ROUTER_MODEL"
						printf "\\n${BOLD}${WARN}Some %s fail to reboot correctly and require a manual power cycle${CLEARFORMAT}\\n" "$ROUTER_MODEL"
					fi
					printf "\\n${BOLD}Are you sure you want to reboot? (y/n)${CLEARFORMAT}  "
					read -r confirm
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
				PressEnter
				break
			;;
			ntp)
				printf "\\n"
				if [ "$(NTPBootWatchdog check)" = "ENABLED" ]; then
					NTPBootWatchdog disable
				elif [ "$(NTPBootWatchdog check)" = "DISABLED" ]; then
					NTPBootWatchdog enable
				fi
				break
			;;
			dns)
				printf "\\n"
				if [ "$(TailTaintDns check)" = "ENABLED" ]; then
					TailTaintDns disable
				elif [ "$(TailTaintDns check)" = "DISABLED" ]; then
					TailTaintDns enable
				fi
				break
			;;
			u)
				printf "\\n"
				if Check_Lock menu; then
					Update_Version
					Clear_Lock
				fi
				PressEnter
				break
			;;
			uf)
				printf "\\n"
				if Check_Lock menu; then
					Update_Version force
					Clear_Lock
				fi
				PressEnter
				break
			;;
			e)
				ScriptHeader
				printf "\\n${BOLD}Thanks for using %s!${CLEARFORMAT}\\n\\n\\n" "$SCRIPT_NAME"
				exit 0
			;;
			z)
				printf "\\n${BOLD}Are you sure you want to uninstall %s? (y/n)${CLEARFORMAT}  " "$SCRIPT_NAME"
				read -r confirm
				case "$confirm" in
					y|Y)
						Menu_Uninstall
						exit 0
					;;
					*)
						:
					;;
				esac
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
		Print_Output true "Custom JFFS Scripts enabled" "$WARN"
	fi
	
	if ! Firmware_Version_Check; then
		Print_Output false "Unsupported firmware version detected" "$ERR"
		Print_Output false "$SCRIPT_NAME requires Merlin 384.15/384.13_4 or Fork 43E5 (or later)" "$ERR"
		CHECKSFAILED="true"
	fi
	
	if [ "$CHECKSFAILED" = "false" ]; then
		return 0
	else
		return 1
	fi
}

Menu_Install(){
	Print_Output true "Welcome to $SCRIPT_NAME $SCRIPT_VERSION, a script by JackYaz"
	sleep 1
	
	Print_Output false "Checking your router meets the requirements for $SCRIPT_NAME"
	
	if ! Check_Requirements; then
		Print_Output false "Requirements for $SCRIPT_NAME not met, please see above for the reason(s)" "$CRIT"
		PressEnter
		Clear_Lock
		rm -f "/jffs/scripts/$SCRIPT_NAME_LOWER" 2>/dev/null
		rm -rf "$SCRIPT_DIR" 2>/dev/null
		exit 1
	fi
	
	Create_Dirs
	Shortcut_Script create
	Set_Version_Custom_Settings local "$SCRIPT_VERSION"
	Set_Version_Custom_Settings server "$SCRIPT_VERSION"
	Create_Symlinks
	Auto_Startup create 2>/dev/null
	Auto_ServiceEvent create 2>/dev/null
	
	Update_File scmerlin_www.asp
	Update_File sitemap.asp
	Update_File shared-jy.tar.gz
	Update_File tailtop
	Update_File tailtopd
	Update_File tailtaintdns
	Update_File tailtaintdnsd
	Update_File sc.func
	Update_File S99tailtop
	Update_File S95tailtaintdns
	
	Clear_Lock
	
	Download_File "$SCRIPT_REPO/install-success/LICENSE" "$SCRIPT_DIR/LICENSE"
	
	ScriptHeader
	MainMenu
}

Menu_Startup(){
	Create_Dirs
	Auto_Startup create 2>/dev/null
	
	NTP_Ready
	
	Check_Lock
	
	if [ "$1" != "force" ]; then
		sleep 14
	fi
	
	Create_Symlinks
	Auto_ServiceEvent create 2>/dev/null
	Shortcut_Script create
	
	"$SCRIPT_DIR/S99tailtop" start >/dev/null 2>&1
	
	Mount_WebUI
	Clear_Lock
}

##----------------------------------------##
## Modified by Martinski W. [2023-Jun-09] ##
##----------------------------------------##
Menu_Uninstall(){
	Print_Output true "Removing $SCRIPT_NAME..." "$PASS"
	Shortcut_Script delete
	Auto_Startup delete 2>/dev/null
	Auto_ServiceEvent delete 2>/dev/null
	NTPBootWatchdog disable
	TailTaintDns disable
	
	LOCKFILE=/tmp/addonwebui.lock
	FD=386
	eval exec "$FD>$LOCKFILE"
	flock -x "$FD"

	resetWebGUI=false
	if [ -f "$SCRIPT_DIR/sitemap.asp" ]
	then
		Get_WebUI_Page "$SCRIPT_DIR/sitemap.asp"
		if [ -n "$MyPage" ] && [ "$MyPage" != "none" ] && [ -f /tmp/menuTree.js ]
		then
			resetWebGUI=true
			sed -i "\\~$MyPage~d" /tmp/menuTree.js
			rm -f "$SCRIPT_WEBPAGE_DIR/$MyPage"
		fi
	fi
	Get_WebUI_Page "$SCRIPT_DIR/scmerlin_www.asp"
	if [ -n "$MyPage" ] && [ "$MyPage" != "none" ] && [ -f /tmp/menuTree.js ]
	then
		resetWebGUI=true
		sed -i "\\~$MyPage~d" /tmp/menuTree.js
		rm -f "$SCRIPT_WEBPAGE_DIR/$MyPage"
		rm -f "$SCRIPT_WEBPAGE_DIR/$(echo $MyPage | cut -f1 -d'.').title"
	fi

	## Use the same BEGIN/END insert tags here as those used in the "Mount_WebUI()" function ##
	if grep -qE "^${BEGIN_InsertTag}$" /tmp/menuTree.js && \
	   grep -qE "^${ENDIN_InsertTag}$" /tmp/menuTree.js
	then
		resetWebGUI=true
		BEGINnum="$(grep -nE "^${BEGIN_InsertTag}$" /tmp/menuTree.js | awk -F ':' '{print $1}')"
		ENDINnum="$(grep -nE "^${ENDIN_InsertTag}$" /tmp/menuTree.js | awk -F ':' '{print $1}')"
		[ -n "$BEGINnum" ] && [ -n "$ENDINnum" ] && [ "$BEGINnum" -lt "$ENDINnum" ] && \
		sed -i "${BEGINnum},${ENDINnum}d" /tmp/menuTree.js
	fi
	## Remove any "old" previous lines left behind ##
	if grep -qE '^menuName: "Addons",$' /tmp/menuTree.js && \
	   grep -qE 'tabName: "Help & Support"},$' /tmp/menuTree.js
	then
		resetWebGUI=true
		BEGINnum="$(grep -nE '^menuName: "Addons",$' /tmp/menuTree.js | awk -F ':' '{print $1}')"
		ENDINnum="$(grep -nE 'tabName: "Help & Support"},$' /tmp/menuTree.js | awk -F ':' '{print $1}')"
		[ -n "$BEGINnum" ] && [ -n "$ENDINnum" ] && [ "$BEGINnum" -lt "$ENDINnum" ] && \
		BEGINnum=$((BEGINnum - 2)) && ENDINnum=$((ENDINnum + 3)) && \
		[ "$(sed -n "${BEGINnum}p" /tmp/menuTree.js)" = "," ] && \
		[ "$(sed -n "${ENDINnum}p" /tmp/menuTree.js)" = "}" ] && \
		sed -i "${BEGINnum},${ENDINnum}d" /tmp/menuTree.js
	fi

	if "$resetWebGUI"
	then
		umount /www/require/modules/menuTree.js 2>/dev/null
		if [ -f /tmp/index_style.css ] && grep -qF '.menu_Addons { background:' /tmp/index_style.css
		then rm -f /tmp/index_style.css ; umount /www/index_style.css 2>/dev/null
		fi
		if [ -f /tmp/state.js ] && grep -qE 'function GenerateSiteMap|function AddDropdowns' /tmp/state.js
		then rm -f /tmp/state.js ; umount /www/state.js 2>/dev/null
		fi
		mount -o bind /tmp/menuTree.js /www/require/modules/menuTree.js
	fi
	flock -u "$FD"
	rm -rf "$SCRIPT_WEB_DIR" 2>/dev/null
	
	"$SCRIPT_DIR/S99tailtop" stop >/dev/null 2>&1
	sleep 5
		
	rm -rf "$SCRIPT_DIR"
	
	SETTINGSFILE="/jffs/addons/custom_settings.txt"
	sed -i '/scmerlin_version_local/d' "$SETTINGSFILE"
	sed -i '/scmerlin_version_server/d' "$SETTINGSFILE"
	
	rm -f "/jffs/scripts/$SCRIPT_NAME_LOWER" 2>/dev/null
	Clear_Lock
	Print_Output true "Uninstall completed" "$PASS"
}

NTP_Ready(){
	if [ "$(nvram get ntp_ready)" -eq 0 ]; then
		Check_Lock
		ntpwaitcount=0
		while [ "$(nvram get ntp_ready)" -eq 0 ] && [ "$ntpwaitcount" -lt 600 ]; do
			ntpwaitcount="$((ntpwaitcount + 30))"
			Print_Output true "Waiting for NTP to sync..." "$WARN"
			sleep 30
		done
		if [ "$ntpwaitcount" -ge 600 ]; then
			Print_Output true "NTP failed to sync after 10 minutes. Please resolve!" "$CRIT"
			Clear_Lock
			exit 1
		else
			Print_Output true "NTP synced, $SCRIPT_NAME will now continue" "$PASS"
			Clear_Lock
		fi
	fi
}

### function based on @Adamm00's Skynet USB wait function ###
Entware_Ready(){
	if [ ! -f /opt/bin/opkg ]; then
		Check_Lock
		sleepcount=1
		while [ ! -f /opt/bin/opkg ] && [ "$sleepcount" -le 10 ]; do
			Print_Output true "Entware not found, sleeping for 10s (attempt $sleepcount of 10)" "$ERR"
			sleepcount="$((sleepcount + 1))"
			sleep 10
		done
		if [ ! -f /opt/bin/opkg ]; then
			Print_Output true "Entware not found and is required for $SCRIPT_NAME to run, please resolve" "$CRIT"
			Clear_Lock
			exit 1
		else
			Print_Output true "Entware found, $SCRIPT_NAME will now continue" "$PASS"
			Clear_Lock
		fi
	fi
}
### ###

Show_About(){
	cat << EOF
About
  $SCRIPT_NAME allows you to easily control the most common
  services/scripts on your router. scMerlin also augments your
  router's WebUI with a Sitemap and dynamic submenus for the
  main left menu of Asuswrt-Merlin.
License
  $SCRIPT_NAME is free to use under the GNU General Public License
  version 3 (GPL-3.0) https://opensource.org/licenses/GPL-3.0
Help & Support
  https://www.snbforums.com/forums/asuswrt-merlin-addons.60/?prefix_id=23
Source code
  https://github.com/jackyaz/$SCRIPT_NAME
EOF
	printf "\\n"
}
### ###

### function based on @dave14305's FlexQoS show_help function ###
Show_Help(){
	cat << EOF
Available commands:
  $SCRIPT_NAME_LOWER about              explains functionality
  $SCRIPT_NAME_LOWER update             checks for updates
  $SCRIPT_NAME_LOWER forceupdate        updates to latest version (force update)
  $SCRIPT_NAME_LOWER startup force      runs startup actions such as mount WebUI tab
  $SCRIPT_NAME_LOWER install            installs script
  $SCRIPT_NAME_LOWER uninstall          uninstalls script
  $SCRIPT_NAME_LOWER develop            switch to development branch
  $SCRIPT_NAME_LOWER stable             switch to stable branch
EOF
	printf "\\n"
}
### ###

if [ -z "$1" ]; then
	NTP_Ready
	Create_Dirs
	Shortcut_Script create
	Create_Symlinks
	Auto_Startup create 2>/dev/null
	Auto_ServiceEvent create 2>/dev/null
	Process_Upgrade
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
	startup)
		Menu_Startup "$2"
		exit 0
	;;
	service_event)
		if [ "$2" = "start" ] && echo "$3" | grep "${SCRIPT_NAME_LOWER}config"; then
			settingstate="$(echo "$3" | sed "s/${SCRIPT_NAME_LOWER}config//")";
			NTPBootWatchdog "$settingstate"
			exit 0
		elif [ "$2" = "start" ] && echo "$3" | grep "${SCRIPT_NAME_LOWER}servicerestart"; then
			rm -f "$SCRIPT_WEB_DIR/detect_service.js"
			echo 'var servicestatus = "InProgress";' > "$SCRIPT_WEB_DIR/detect_service.js"
			srvname="$(echo "$3" | sed "s/${SCRIPT_NAME_LOWER}servicerestart//")";
			if [ "$srvname" = "vsftpd" ]; then
				ENABLED_FTP="$(nvram get enable_ftp)"
				if ! Validate_Number "$ENABLED_FTP"; then ENABLED_FTP=0; fi
				if [ "$ENABLED_FTP" -eq 1 ]; then
					service restart_"$srvname" >/dev/null 2>&1
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				else
					echo 'var servicestatus = "Invalid";' > "$SCRIPT_WEB_DIR/detect_service.js"
				fi
			elif [ "$srvname" = "samba" ]; then
				ENABLED_SAMBA="$(nvram get enable_samba)"
				if ! Validate_Number "$ENABLED_SAMBA"; then ENABLED_SAMBA=0; fi
				if [ "$ENABLED_SAMBA" -eq 1 ]; then
					service restart_"$srvname" >/dev/null 2>&1
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				else
					echo 'var servicestatus = "Invalid";' > "$SCRIPT_WEB_DIR/detect_service.js"
				fi
			elif [ "$srvname" = "ntpdchronyd" ]; then
				ENABLED_NTPD="$(nvram get ntpd_enable)"
				if ! Validate_Number "$ENABLED_NTPD"; then ENABLED_NTPD=0; fi
				if [ "$ENABLED_NTPD" -eq 1 ]; then
					service restart_time >/dev/null 2>&1
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				elif [ -f /opt/etc/init.d/S77ntpd ]; then
					/opt/etc/init.d/S77ntpd restart
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				elif [ -f /opt/etc/init.d/S77chronyd ]; then
					/opt/etc/init.d/S77chronyd restart
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				else
					echo 'var servicestatus = "Invalid";' > "$SCRIPT_WEB_DIR/detect_service.js"
				fi
			elif echo "$srvname" | grep -q "vpnclient"; then
				vpnno="$(echo "$srvname" | sed "s/vpnclient//")";
				if [ -n "$(nvram get "vpn_client${vpnno}_addr")" ]; then
					service restart_"$srvname" >/dev/null 2>&1
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				else
					echo 'var servicestatus = "Invalid";' > "$SCRIPT_WEB_DIR/detect_service.js"
				fi
			elif echo "$srvname" | grep -q "vpnserver"; then
				vpnno="$(echo "$srvname" | sed "s/vpnserver//")";
				if nvram get vpn_serverx_start | grep -q "$vpnno"; then
					service restart_"$srvname" >/dev/null 2>&1
					echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
				else
					echo 'var servicestatus = "Invalid";' > "$SCRIPT_WEB_DIR/detect_service.js"
				fi
			elif [ "$srvname" = "entware" ]; then
				/opt/etc/init.d/rc.unslung restart
				echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
			else
				service restart_"$srvname" >/dev/null 2>&1
				echo 'var servicestatus = "Done";' > "$SCRIPT_WEB_DIR/detect_service.js"
			fi
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME_LOWER}checkupdate" ]; then
			Update_Check
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME_LOWER}doupdate" ]; then
			Update_Version force unattended
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME_LOWER}getaddonpages" ]; then
			rm -f /tmp/addonwebpages.tmp
			sleep 3
			Get_Addon_Pages
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME_LOWER}getcronjobs" ]; then
			rm -f /tmp/scmcronjobs.tmp
			sleep 3
			Get_Cron_Jobs
			exit 0
		fi
		exit 0
	;;
	update)
		Update_Version
		exit 0
	;;
	forceupdate)
		Update_Version force
		exit 0
	;;
	postupdate)
		Create_Dirs
		Shortcut_Script create
		Create_Symlinks
		Auto_Startup create 2>/dev/null
		Auto_ServiceEvent create 2>/dev/null
		Process_Upgrade
		exit 0
	;;
	checkupdate)
		Update_Check
		exit 0
	;;
	uninstall)
		Menu_Uninstall
		exit 0
	;;
	about)
		ScriptHeader
		Show_About
		exit 0
	;;
	help)
		ScriptHeader
		Show_Help
		exit 0
	;;
	develop)
		SCRIPT_BRANCH="develop"
		SCRIPT_REPO="https://jackyaz.io/$SCRIPT_NAME/$SCRIPT_BRANCH"
		Update_Version force
		exit 0
	;;
	stable)
		SCRIPT_BRANCH="master"
		SCRIPT_REPO="https://jackyaz.io/$SCRIPT_NAME/$SCRIPT_BRANCH"
		Update_Version force
		exit 0
	;;
	*)
		ScriptHeader
		Print_Output false "Command not recognised." "$ERR"
		Print_Output false "For a list of available commands run: $SCRIPT_NAME_LOWER help"
		exit 1
	;;
esac

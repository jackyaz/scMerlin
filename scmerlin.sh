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

#############        Shellcheck directives      ##########
# shellcheck disable=SC2018
# shellcheck disable=SC2019
# shellcheck disable=SC2059
# shellcheck disable=SC2034
##########################################################

### Start of script variables ###
readonly SCRIPT_NAME="scMerlin"
readonly SCRIPT_NAME_LOWER=$(echo $SCRIPT_NAME | tr 'A-Z' 'a-z' | sed 's/d//')
readonly SCM_VERSION="v2.2.0"
readonly SCRIPT_VERSION="v2.2.0"
SCRIPT_BRANCH="develop"
SCRIPT_REPO="https://raw.githubusercontent.com/jackyaz/$SCRIPT_NAME/$SCRIPT_BRANCH"
readonly SCRIPT_DIR="/jffs/addons/$SCRIPT_NAME_LOWER.d"
readonly SCRIPT_WEBPAGE_DIR="$(readlink /www/user)"
readonly SCRIPT_WEB_DIR="$SCRIPT_WEBPAGE_DIR/$SCRIPT_NAME_LOWER"
readonly SHARED_DIR="/jffs/addons/shared-jy"
readonly SHARED_REPO="https://raw.githubusercontent.com/jackyaz/shared-jy/master"
readonly SHARED_WEB_DIR="$SCRIPT_WEBPAGE_DIR/shared-jy"
readonly DISABLE_USB_FEATURES_FILE="$SCRIPT_DIR/.usbdisabled"
[ -z "$(nvram get odmpid)" ] && ROUTER_MODEL=$(nvram get productid) || ROUTER_MODEL=$(nvram get odmpid)
### End of script variables ###

### Start of output format variables ###
#shellcheck disable=SC2034
readonly CRIT="\\e[41m"
readonly ERR="\\e[31m"
readonly WARN="\\e[33m"
readonly PASS="\\e[32m"
readonly SETTING="\\e[1m\\e[36m"
### End of output format variables ###

# $1 = print to syslog, $2 = message to print, $3 = log level
Print_Output(){
	if [ "$1" = "true" ]; then
		logger -t "$SCRIPT_NAME" "$2"
	fi
	printf "\\e[1m${3}%s\\e[0m\\n\\n" "$2"
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
	/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME_LOWER.sh" | grep -qF "jackyaz" || { Print_Output true "404 error detected - stopping update" "$ERR"; return 1; }
	serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME_LOWER.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	if [ "$localver" != "$serverver" ]; then
		doupdate="version"
		Set_Version_Custom_Settings server "$serverver"
		echo 'var updatestatus = "'"$serverver"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
	else
		localmd5="$(md5sum "/jffs/scripts/$SCRIPT_NAME_LOWER" | awk '{print $1}')"
		remotemd5="$(curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME_LOWER.sh" | md5sum | awk '{print $1}')"
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
			printf "\\n\\e[1mDo you want to continue with the update? (y/n)\\e[0m  "
			read -r confirm
			case "$confirm" in
				y|Y)
					printf "\\n"
					Update_File shared-jy.tar.gz
					Update_File scmerlin_www.asp
					
					if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
						Update_File tailtop
						Update_File tailtopd
						Update_File S99tailtop
					fi
					/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME_LOWER.sh" -o "/jffs/scripts/$SCRIPT_NAME_LOWER" && Print_Output true "$SCRIPT_NAME successfully updated"
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
		serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME_LOWER.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
		Print_Output true "Downloading latest version ($serverver) of $SCRIPT_NAME" "$PASS"
		Update_File shared-jy.tar.gz
		Update_File scmerlin_www.asp
		if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
			Update_File tailtop
			Update_File tailtopd
			Update_File S99tailtop
		fi
		/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME_LOWER.sh" -o "/jffs/scripts/$SCRIPT_NAME_LOWER" && Print_Output true "$SCRIPT_NAME successfully updated"
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
	if [ "$1" = "scmerlin_www.asp" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f "$SCRIPT_DIR/$1" ]; then
				Get_WebUI_Page "$SCRIPT_DIR/$1"
				sed -i "\\~$MyPage~d" /tmp/menuTree.js
				rm -f "$SCRIPT_WEBPAGE_DIR/$MyPage" 2>/dev/null
			fi
			Download_File "$SCRIPT_REPO/$1" "$SCRIPT_DIR/$1"
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
		Download_File "$SCRIPT_REPO/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "/opt/etc/init.d/$1" >/dev/null 2>&1; then
			if [ -f /opt/etc/init.d/S99tailtop ]; then
				/opt/etc/init.d/S99tailtop stop >/dev/null 2>&1
				sleep 2
			fi
			Download_File "$SCRIPT_REPO/$1" "/opt/etc/init.d/$1"
			chmod 0755 "/opt/etc/init.d/$1"
			/opt/etc/init.d/S99tailtop start >/dev/null 2>&1
			Print_Output true "New version of $1 downloaded" "$PASS"
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "tailtop" ] || [ "$1" = "tailtopd" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/$1" "$tmpfile"
		if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
			if [ -f /opt/etc/init.d/S99tailtop ]; then
				/opt/etc/init.d/S99tailtop stop >/dev/null 2>&1
				sleep 2
			fi
			Download_File "$SCRIPT_REPO/$1" "$SCRIPT_DIR/$1"
			chmod 0755 "$SCRIPT_DIR/$1"
			Print_Output true "New version of $1 downloaded" "$PASS"
			/opt/etc/init.d/S99tailtop start >/dev/null 2>&1
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
	ln -s /tmp/addonwebpages.tmp "$SCRIPT_WEB_DIR/addonwebpages.js" 2>/dev/null
	ln -s "$DISABLE_USB_FEATURES_FILE" "$SCRIPT_WEB_DIR/usbdisabled.htm" 2>/dev/null
	
	if [ ! -d "$SHARED_WEB_DIR" ]; then
		ln -s "$SHARED_DIR" "$SHARED_WEB_DIR" 2>/dev/null
	fi
}

Auto_ServiceEvent(){
	case $1 in
		create)
			if [ -f /jffs/scripts/service-event ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/service-event)
				# shellcheck disable=SC2016
				STARTUPLINECOUNTEX=$(grep -i -cx "/jffs/scripts/$SCRIPT_NAME_LOWER service_event"' "$@" & # '"$SCRIPT_NAME" /jffs/scripts/service-event)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/service-event
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					# shellcheck disable=SC2016
					echo "/jffs/scripts/$SCRIPT_NAME_LOWER service_event"' "$@" & # '"$SCRIPT_NAME" >> /jffs/scripts/service-event
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/service-event
				echo "" >> /jffs/scripts/service-event
				# shellcheck disable=SC2016
				echo "/jffs/scripts/$SCRIPT_NAME_LOWER service_event"' "$@" & # '"$SCRIPT_NAME" >> /jffs/scripts/service-event
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

Auto_Startup(){
	case $1 in
		create)
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/services-start
				fi
			fi
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				STARTUPLINECOUNTEX=$(grep -i -cx "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' "$@" & # '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/post-mount
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' "$@" & # '"$SCRIPT_NAME" >> /jffs/scripts/post-mount
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/post-mount
				echo "" >> /jffs/scripts/post-mount
				echo "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' "$@" & # '"$SCRIPT_NAME" >> /jffs/scripts/post-mount
				chmod 0755 /jffs/scripts/post-mount
			fi
		;;
		delete)
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/services-start
				fi
			fi
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/post-mount
				fi
			fi
		;;
	esac
}

Auto_Startup_NoUSB(){
	case $1 in
		create)
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/post-mount
				fi
			fi
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/services-start)
				STARTUPLINECOUNTEX=$(grep -i -cx "/jffs/scripts/$SCRIPT_NAME_LOWER startup"' & # '"$SCRIPT_NAME" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/services-start
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
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/post-mount
				fi
			fi
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -i -c '# '"$SCRIPT_NAME" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/services-start
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

### locking mechanism code credit to Martineau (@MartineauUK) ###
Mount_WebUI(){
	Print_Output true "Mounting WebUI tab for $SCRIPT_NAME" "$PASS"
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
			echo ".menu_Addons { background: url(ext/shared-jy/addons.png); }" >> /tmp/index_style.css
		fi
		
		umount /www/index_style.css 2>/dev/null
		mount -o bind /tmp/index_style.css /www/index_style.css
		
		if [ ! -f /tmp/menuTree.js ]; then
			cp -f /www/require/modules/menuTree.js /tmp/
		fi
		
		sed -i "\\~$MyPage~d" /tmp/menuTree.js
		
		if ! grep -q 'menuName: "Addons"' /tmp/menuTree.js ; then
			lineinsbefore="$(( $(grep -n "exclude:" /tmp/menuTree.js | cut -f1 -d':') - 1))"
			sed -i "$lineinsbefore"'i,\n{\nmenuName: "Addons",\nindex: "menu_Addons",\ntab: [\n{url: "ext/shared-jy/redirect.htm", tabName: "Help & Support"},\n{url: "NULL", tabName: "__INHERIT__"}\n]\n}' /tmp/menuTree.js
		fi
		
		if grep -q "javascript:window.open('/ext/shared-jy/redirect.htm'" /tmp/menuTree.js ; then
			sed -i "s~javascript:window.open('/ext/shared-jy/redirect.htm','_blank')~javascript:var helpwindow=window.open('/ext/shared-jy/redirect.htm','_blank')~" /tmp/menuTree.js
		fi
		if ! grep -q "javascript:var helpwindow=window.open('/ext/shared-jy/redirect.htm'" /tmp/menuTree.js ; then
			sed -i "s~ext/shared-jy/redirect.htm~javascript:var helpwindow=window.open('/ext/shared-jy/redirect.htm','_blank')~" /tmp/menuTree.js
		fi
		sed -i "/url: \"javascript:var helpwindow=window.open('\/ext\/shared-jy\/redirect.htm'/i {url: \"$MyPage\", tabName: \"$SCRIPT_NAME\"}," /tmp/menuTree.js
		
		umount /www/require/modules/menuTree.js 2>/dev/null
		mount -o bind /tmp/menuTree.js /www/require/modules/menuTree.js
	fi
	flock -u "$FD"
	Print_Output true "Mounted $SCRIPT_NAME WebUI page as $MyPage" "$PASS"
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
	printf "var addonpages=[" > /tmp/addonwebpages.tmp
	grep "user.*\.asp" /tmp/menuTree.js | awk -F'"' -v wu="$weburl" '{printf "\[\"%s\",\""wu"%s\"\],",$4,$2}' >> /tmp/addonwebpages.tmp
	sed -i 's/,$//' /tmp/addonwebpages.tmp
	printf "];\\n" >> /tmp/addonwebpages.tmp
}


ToggleUSBFeatures(){
	case "$1" in
		enable)
			rm -f "$DISABLE_USB_FEATURES_FILE"
			Auto_Startup_NoUSB delete 2>/dev/null
			Auto_Startup create 2>/dev/null
			Update_File tailtop
			Update_File tailtopd
			Update_File S99tailtop
		;;
		disable)
			touch "$DISABLE_USB_FEATURES_FILE"
			Auto_Startup delete 2>/dev/null
			Auto_Startup_NoUSB create 2>/dev/null
			/opt/etc/init.d/S99tailtop stop
			rm -f "$SCRIPT_DIR/tailtop"
			rm -f "$SCRIPT_DIR/tailtopd"
			rm -f /opt/etc/init.d/S99tailtop
		;;
		check)
			if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
				echo "ENABLED"
			else
				echo "DISABLED"
			fi
		;;
	esac
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
	printf "\\e[1m#####################################################\\e[0m\\n"
	printf "\\e[1m##               __  __              _  _          ##\\e[0m\\n"
	printf "\\e[1m##              |  \/  |            | |(_)         ##\\e[0m\\n"
	printf "\\e[1m##    ___   ___ | \  / |  ___  _ __ | | _  _ __    ##\\e[0m\\n"
	printf "\\e[1m##   / __| / __|| |\/| | / _ \| '__|| || || '_ \   ##\\e[0m\\n"
	printf "\\e[1m##   \__ \| (__ | |  | ||  __/| |   | || || | | |  ##\\e[0m\\n"
	printf "\\e[1m##   |___/ \___||_|  |_| \___||_|   |_||_||_| |_|  ##\\e[0m\\n"
	printf "\\e[1m##                                                 ##\\e[0m\\n"
	printf "\\e[1m##               %s on %-11s             ##\\e[0m\\n" "$SCRIPT_VERSION" "$ROUTER_MODEL"
	printf "\\e[1m##                                                 ##\\e[0m\\n"
	printf "\\e[1m##       https://github.com/jackyaz/scMerlin       ##\\e[0m\\n"
	printf "\\e[1m##                                                 ##\\e[0m\\n"
	printf "\\e[1m#####################################################\\e[0m\\n"
	printf "\\n"
}

MainMenu(){
	printf "WebUI for %s is available at:\\n${SETTING}%s\\e[0m\\n\\n" "$SCRIPT_NAME" "$(Get_WebUI_URL)"
	printf "\\e[1m\\e[4mServices\\e[0m"
	printf "\\e[1m${WARN} (selecting an option will restart the service)\\e[0m\\n"
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
		printf "\\n\\e[1m\\e[4mVPN Clients\\e[0m"
		printf "\\e[1m${WARN} (selecting an option will restart the VPN Client)\\e[0m\\n"
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
		printf "\\n\\e[1m\\e[4mVPN Servers\\e[0m"
		printf "\\e[1m${WARN} (selecting an option will restart the VPN Server)\\e[0m\\n"
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
		printf "\\n\\e[1m\\e[4mEntware\\e[0m\\n"
		printf "et.   Restart all Entware applications\\n"
	fi
	printf "\\n\\e[1m\\e[4mRouter\\e[0m\\n"
	printf "c.    View running processes\\n"
	printf "m.    View RAM/memory usage\n"
	printf "t.    View router temperatures\n"
	printf "w.    List Addon WebUI tab to page mapping\n"
	printf "r.    Reboot router\\n\\n"
	printf "\\e[1m\\e[4mOther\\e[0m\\n"
	if [ "$(ToggleUSBFeatures check)" = "ENABLED" ]; then
		USB_ENABLED="${PASS}Enabled"
	else
		USB_ENABLED="${ERR}Disabled"
	fi
	printf "usb.  Toggle USB features (list of running processes in WebUI)\\n      Currently: \\e[1m$USB_ENABLED\\e[0m\\n\\n"
	printf "u.    Check for updates\\n"
	printf "uf.   Update %s with latest version (force update)\\n\\n" "$SCRIPT_NAME"
	printf "e.    Exit %s\\n\\n" "$SCRIPT_NAME"
	printf "z.    Uninstall %s\\n" "$SCRIPT_NAME"
	printf "\\n"
	printf "\\e[1m#####################################################\\e[0m\\n"
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
					printf "\\n\\e[1mInternet connection will take 30s-60s to reconnect. Continue? (y/n)\\e[0m  "
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
				printf "\\n\\e[1m\\e[31mInvalid selection (FTP not enabled)\\e[0m\\n\\n"
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
					printf "\\n\\e[1m\\e[31mInvalid selection (Samba not enabled)\\e[0m\\n\\n"
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
					printf "\\n\\e[1m\\e[31mInvalid selection (DDNS client not enabled)\\e[0m\\n\\n"
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
					printf "\\n\\e[1m\\e[31mInvalid selection (NTP server not enabled/installed)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc1)
				if [ -n "$(nvram get vpn_client1_addr)" ]; then
					printf "\\n"
					service restart_vpnclient1 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc2)
				if [ -n "$(nvram get vpn_client2_addr)" ]; then
					printf "\\n"
					service restart_vpnclient2 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc3)
				if [ -n "$(nvram get vpn_client3_addr)" ]; then
					printf "\\n"
					service restart_vpnclient3 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc4)
				if [ -n "$(nvram get vpn_client4_addr)" ]; then
					printf "\\n"
					service restart_vpnclient4 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vc5)
				if [ -n "$(nvram get vpn_client5_addr)" ]; then
					printf "\\n"
					service restart_vpnclient5 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Client not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vs1)
				if nvram get vpn_serverx_start | grep -q 1; then
					printf "\\n"
					service restart_vpnserver1 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Server not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			vs2)
				if nvram get vpn_serverx_start | grep -q 2; then
					printf "\\n"
					service restart_vpnserver2 >/dev/null 2>&1
				else
					printf "\\n\\e[1m\\e[31mInvalid selection (VPN Server not configured)\\e[0m\\n\\n"
				fi
				PressEnter
				break
			;;
			et)
				printf "\\n"
				if [ -f /opt/bin/opkg ]; then
					if Check_Lock menu; then
						while true; do
							printf "\\n\\e[1mAre you sure you want to restart all Entware scripts? (y/n)\\e[0m  "
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
					printf "\\n\\e[1m\\e[31mInvalid selection (Entware not installed)\\e[0m\\n"
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
							printf "\\n\\e[1mWould you like to install htop (enhanced version of top)? (y/n)\\e[0m  "
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
			t)
				ScriptHeader
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
						printf "\\n\\e[1m${WARN}Remote reboots are not recommend for %s\\e[0m" "$ROUTER_MODEL"
						printf "\\n\\e[1m${WARN}Some %s fail to reboot correctly and require a manual power cycle\\e[0m\\n" "$ROUTER_MODEL"
					fi
					printf "\\n\\e[1mAre you sure you want to reboot? (y/n)\\e[0m  "
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
			usb)
				printf "\\n"
				if [ "$(ToggleUSBFeatures check)" = "ENABLED" ]; then
					ToggleUSBFeatures disable
				elif [ "$(ToggleUSBFeatures check)" = "DISABLED" ]; then
					ToggleUSBFeatures enable
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
				printf "\\n\\e[1mThanks for using %s!\\e[0m\\n\\n\\n" "$SCRIPT_NAME"
				exit 0
			;;
			z)
				printf "\\n\\e[1mAre you sure you want to uninstall %s? (y/n)\\e[0m  " "$SCRIPT_NAME"
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
	
	printf "\\n\\e[1mWould you like to enable USB Features (list of running processes in WebUI) (y/n)?\\nThis requires a USB device plugged into router for Entware\\e[0m  "
	read -r confirm
	case "$confirm" in
		y|Y)
			if [ ! -f /opt/bin/opkg ]; then
				touch "$DISABLE_USB_FEATURES_FILE"
				Print_Output false "Entware not detected, USB features disabled" "$WARN"
			fi
		;;
		*)
			touch "$DISABLE_USB_FEATURES_FILE"
			Print_Output false "USB features can be enabled later via the WebUI or command line" "$WARN"
		;;
	esac
	
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
	if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
		Auto_Startup create 2>/dev/null
	else
		Auto_Startup_NoUSB create 2>/dev/null
	fi
	Auto_ServiceEvent create 2>/dev/null
	
	Update_File scmerlin_www.asp
	Update_File shared-jy.tar.gz
	if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
		Update_File tailtop
		Update_File tailtopd
		Update_File S99tailtop
	fi
	
	Clear_Lock
	ScriptHeader
	MainMenu
}

Menu_Startup(){
	Create_Dirs
	if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
		if [ -z "$1" ]; then
			Print_Output true "Missing argument for startup, not starting $SCRIPT_NAME" "$WARN"
			exit 1
		elif [ "$1" != "force" ]; then
			if [ ! -f "$1/entware/bin/opkg" ]; then
				Print_Output true "$1 does not contain Entware, not starting $SCRIPT_NAME" "$WARN"
				exit 1
			else
				Print_Output true "$1 contains Entware, starting $SCRIPT_NAME" "$WARN"
			fi
		fi
		Auto_Startup create 2>/dev/null
	else
		Auto_Startup_NoUSB create 2>/dev/null
	fi
	
	NTP_Ready
	
	Check_Lock
	
	if [ "$1" != "force" ]; then
		sleep 14
	fi
	
	Create_Symlinks
	Auto_ServiceEvent create 2>/dev/null
	Shortcut_Script create
	
	Mount_WebUI
	Clear_Lock
}

Menu_Uninstall(){
	Print_Output true "Removing $SCRIPT_NAME..." "$PASS"
	Shortcut_Script delete
	if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
		Auto_Startup delete 2>/dev/null
	else
		Auto_Startup_NoUSB delete 2>/dev/null
	fi
	Auto_ServiceEvent delete 2>/dev/null
	
	LOCKFILE=/tmp/addonwebui.lock
	FD=386
	eval exec "$FD>$LOCKFILE"
	flock -x "$FD"
	Get_WebUI_Page "$SCRIPT_DIR/scmerlin_www.asp"
	if [ -n "$MyPage" ] && [ "$MyPage" != "none" ] && [ -f /tmp/menuTree.js ]; then
		sed -i "\\~$MyPage~d" /tmp/menuTree.js
		umount /www/require/modules/menuTree.js
		mount -o bind /tmp/menuTree.js /www/require/modules/menuTree.js
		rm -rf "{$SCRIPT_WEBPAGE_DIR:?}/$MyPage"
	fi
	flock -u "$FD"
	rm -f "$SCRIPT_DIR/scmerlin_www.asp" 2>/dev/null
	rm -rf "$SCRIPT_WEB_DIR" 2>/dev/null
	
	/opt/etc/init.d/S99tailtop stop >/dev/null 2>&1
	sleep 5
	rm -f /opt/etc/init.d/S99tailtop 2>/dev/null
	rm -f "$SCRIPT_DIR/tailtop"* 2>/dev/null
	
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
	cat <<EOF
About
  $SCRIPT_NAME allows you to easily control the most common
  services/scripts on your router.
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
	cat <<EOF
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
	if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
		Entware_Ready
	fi
	Create_Dirs
	Shortcut_Script create
	Create_Symlinks
	if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
		Auto_Startup create 2>/dev/null
	else
		Auto_Startup_NoUSB create 2>/dev/null
	fi
	Auto_ServiceEvent create 2>/dev/null
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
			ToggleUSBFeatures "$settingstate"
			exit 0
		elif [ "$2" = "start" ] && echo "$3" | grep "${SCRIPT_NAME_LOWER}servicerestart"; then
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
	setversion)
		Create_Dirs
		Shortcut_Script create
		Create_Symlinks
		if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
			Auto_Startup create 2>/dev/null
		else
			Auto_Startup_NoUSB create 2>/dev/null
		fi
		Auto_ServiceEvent create 2>/dev/null
		Set_Version_Custom_Settings local "$SCRIPT_VERSION"
		Set_Version_Custom_Settings server "$SCRIPT_VERSION"
		exit 0
	;;
	postupdate)
		Create_Dirs
		Shortcut_Script create
		Create_Symlinks
		if [ ! -f "$DISABLE_USB_FEATURES_FILE" ]; then
			Auto_Startup create 2>/dev/null
		else
			Auto_Startup_NoUSB create 2>/dev/null
		fi
		Auto_ServiceEvent create 2>/dev/null
		exit 0
	;;
	checkupdate)
		Update_Check
		exit 0
	;;
	uninstall)
		Check_Lock
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
		SCRIPT_REPO="https://raw.githubusercontent.com/jackyaz/$SCRIPT_NAME/$SCRIPT_BRANCH"
		Update_Version force
		exit 0
	;;
	stable)
		SCRIPT_BRANCH="master"
		SCRIPT_REPO="https://raw.githubusercontent.com/jackyaz/$SCRIPT_NAME/$SCRIPT_BRANCH"
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

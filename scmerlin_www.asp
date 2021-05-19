<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>scMerlin</title>
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<style>
p {
  font-weight: bolder;
}

thead.collapsible-jquery {
  color: white;
  padding: 0px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  cursor: pointer;
}

.SettingsTable {
  text-align: left;
}

.SettingsTable input {
  text-align: left;
  margin-left: 3px !important;
}

.SettingsTable input.savebutton {
  text-align: center;
  margin-top: 5px;
  margin-bottom: 5px;
  border-right: solid 1px black;
  border-left: solid 1px black;
  border-bottom: solid 1px black;
}

.SettingsTable td.savebutton {
  border-right: solid 1px black;
  border-left: solid 1px black;
  border-bottom: solid 1px black;
  background-color:rgb(77, 89, 93);
}

.SettingsTable .cronbutton {
  text-align: center;
  min-width: 50px;
  width: 50px;
  height: 23px;
  vertical-align: middle;
}

.SettingsTable select {
  margin-left: 3px !important;
}

.SettingsTable label {
  margin-right: 10px !important;
  vertical-align: top !important;
}

.SettingsTable th {
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
  border-bottom: none !important;
  border-top: none !important;
  font-size: 12px !important;
  color: white !important;
  padding: 4px !important;
  font-weight: bolder !important;
  padding: 0px !important;
}

.SettingsTable td {
  word-wrap: break-word !important;
  overflow-wrap: break-word !important;
  border-right: none;
  border-left: none;
}

.SettingsTable span.settingname {
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
}

.SettingsTable td.settingname {
  border-right: solid 1px black;
  border-left: solid 1px black;
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
  width: 35% !important;
}

.SettingsTable td.settingvalue {
  text-align: left !important;
  border-right: solid 1px black;
}

.SettingsTable td.servicename {
  border-right: solid 1px black;
  border-left: solid 1px black;
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
  width: 30% !important;
}

.SettingsTable td.servicevalue {
  text-align: center !important;
  border-right: solid 1px black;
  width: 20% !important;
  padding-left: 4px !important;
}

.SettingsTable span.servicespan {
  font-size: 10px !important;
}

.SettingsTable th:first-child{
  border-left: none !important;
}

.SettingsTable th:last-child {
  border-right: none !important;
}

.SettingsTable .invalid {
  background-color: darkred !important;
}

.SettingsTable .disabled {
  background-color: #CCCCCC !important;
  color: #888888 !important;
}

div.sortTableContainer {
  height: 500px;
  overflow-y: scroll;
  width: 745px;
  border: 1px solid #000;
}

thead.sortTableHeader th {
  background-image: linear-gradient(rgb(146, 160, 165) 0%, rgb(102, 117, 124) 100%);
  border-top: none !important;
  border-left: none !important;
  border-right: none !important;
  border-bottom: 1px solid #000 !important;
  font-weight: bolder;
  padding: 2px;
  text-align: center;
  color: #fff;
  position: sticky;
  top: 0;
}

thead.sortTableHeader th:first-child,
thead.sortTableHeader th:last-child {
  border-right: none !important;
}

thead.sortTableHeader th:last-child {
  text-align: left !important;
  padding-left: 4px !important;
}

thead.sortTableHeader th:first-child,
thead.sortTableHeader td:first-child {
  border-left: none !important;
}

tbody.sortTableContent td:last-child, tbody.sortTableContent tr.sortNormalRow td:last-child, tbody.sortTableContent tr.sortAlternateRow td:last-child {
  text-align: left !important;
  padding-left: 4px !important;
}

tbody.sortTableContent td{
  border-bottom: 1px solid #000 !important;
  border-left: none !important;
  border-right: 1px solid #000 !important;
  border-top: none !important;
  padding: 2px;
  text-align: center;
  overflow: hidden !important;
  white-space: nowrap !important;
  font-size: 12px !important;
}

tbody.sortTableContent tr.sortRow:nth-child(odd) td {
  background-color: #2F3A3E !important;
}

tbody.sortTableContent tr.sortRow:nth-child(even) td {
  background-color: #475A5F !important;
}

th.sortable {
  cursor: pointer;
}

td.metricname {
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
  width:50px !important;
}

.restartbutton {
  text-align: center !important;
  min-width: 75px;
  width: 75px;
  vertical-align: middle;
}

td.addonpageurl:nth-child(even) {
  border: 1px solid #000 !important;
  text-align: center !important;
  background-color: #475A5F !important;
}

td.addonpageurl:nth-child(odd) {
  border: 1px solid #000 !important;
  text-align: center !important;
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
}

td.addonpageurl:nth-child(even) span {
  background-color: #475A5F !important;
}

td.addonpageurl:nth-child(odd) span {
  background-color: #1F2D35 !important;
  background: #2F3A3E !important;
}

td.addonpageurl a {
  font-weight: bolder !important;
  text-decoration: underline !important;
}

span.addonpageurl {
  color: #FFCC00;
  font-size: 10px !important;
}
</style>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/moment.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/chart.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/hammerjs.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/detect.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmhist.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmmenu.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script>
var custom_settings;
function LoadCustomSettings(){
	custom_settings = <% get_custom_settings(); %>;
	for(var prop in custom_settings) {
		if(Object.prototype.hasOwnProperty.call(custom_settings, prop)) {
			if(prop.indexOf("scmerlin") != -1 && prop.indexOf("scmerlin_version") == -1){
				eval("delete custom_settings."+prop)
			}
		}
	}
}

/* Taken from firmware WebUI, Tools_SysInfo.asp */
function update_sysinfo(e){
	$j.ajax({
		url: '/ajax_sysinfo.asp',
		dataType: 'script',
		error: function(xhr) {
		setTimeout(update_sysinfo, 1000);
	},
		success: function(response){
			show_memcpu();
			nvramtotal = <% sysinfo("nvram.total"); %> / 1024;
			Draw_Chart("MemoryUsage");
			if(parseInt(mem_stats_arr[5]) != 0){
				Draw_Chart("SwapUsage");
			}
			else{
				Draw_Chart_NoData("SwapUsage");
			}
			Draw_Chart("nvramUsage");
			Draw_Chart("jffsUsage");
			setTimeout(update_sysinfo, 3000);
		}
	});
}

function show_memcpu(){
	document.getElementById("mem_total_td").innerHTML = mem_stats_arr[0] + " MB";
	document.getElementById("mem_free_td").innerHTML = mem_stats_arr[1] + " MB";
	document.getElementById("mem_buffer_td").innerHTML = mem_stats_arr[2] + " MB";
	document.getElementById("mem_cache_td").innerHTML = mem_stats_arr[3] + " MB";
	document.getElementById("nvram_td").innerHTML = round(mem_stats_arr[6]/1024,2).toFixed(2) + " / " + nvramtotal + " KB";
	document.getElementById("jffs_td").innerHTML = mem_stats_arr[7];
	
	if(parseInt(mem_stats_arr[5]) == 0){
		document.getElementById("mem_swap_td").innerHTML = "<span>No swap configured</span>";
	}
	else{
		document.getElementById("mem_swap_td").innerHTML = mem_stats_arr[4] + " / " + mem_stats_arr[5] + " MB";
	}
}

function update_temperatures(){
	$j.ajax({
		url: '/ajax_coretmp.asp',
		dataType: 'script',
		error: function(xhr){
		update_temperatures();
	},
	success: function(response){
		code = "<b>2.4 GHz:</b><span> " + curr_coreTmp_2_raw + "</span>";
		if(wl_info.band5g_2_support){
			code += "&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz-1:</b> <span>" + curr_coreTmp_5_raw + "</span>";
			if(typeof curr_coreTmp_52_raw == 'undefined' || curr_coreTmp_52_raw == null){
				curr_coreTmp_52_raw = "N/A"
			}
			code += "&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz-2:</b> <span>" + curr_coreTmp_52_raw + "</span>";
		}
		else if(band5g_support){
			code += "&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz:</b> <span>" + curr_coreTmp_5_raw + "</span>";
		}
		
		var CPUTemp = "";
		if(typeof curr_cpuTemp === 'undefined' || curr_cpuTemp === null){
			CPUTemp = curr_coreTmp_cpu;
		}
		else{
			CPUTemp = curr_cpuTemp;
		}
		
		if(CPUTemp != ""){
			code +="&nbsp;&nbsp;-&nbsp;&nbsp;<b>CPU:</b> <span>" + parseInt(CPUTemp) +"&deg;C</span>";
		}
		document.getElementById("temp_td").innerHTML = code;
		setTimeout(update_temperatures, 3000);
		}
	});
}
/* End firmware functions */
var nvramtotal = <% sysinfo("nvram.total"); %> / 1024;
var arrayproclistlines = [];
var sortnameproc = 'CPU%';
var sortdirproc = 'desc';
var arraycronjobs = [];
var sortnamecron = 'Name';
var sortdircron = 'asc';
var tout;

Chart.defaults.global.defaultFontColor = '#CCC';
Chart.Tooltip.positioners.cursor = function(chartElements,coordinates){
	return coordinates;
};

var $j = jQuery.noConflict(); //avoid conflicts on John's fork (state.js)

function SetCurrentPage(){
	document.form.next_page.value = window.location.pathname.substring(1);
	document.form.current_page.value = window.location.pathname.substring(1);
}

var srvnamelist = ['dnsmasq','wan','httpd','wireless','vsftpd','samba','ddns','ntpd/chronyd'];
var srvdesclist = ['DNS/DHCP Server','Internet Connection','Web Interface','WiFi','FTP Server','Samba','DDNS client','Timeserver'];
var srvnamevisiblelist = [true,false,true,false,true,false,false,true];

var sortedAddonPages = [];

function initial(){
	SetCurrentPage();
	LoadCustomSettings();
	show_menu();
	
	var vpnserverstablehtml='';
	for(var i = 1; i < 3; i++){
		vpnserverstablehtml += BuildVPNServerTable(i);
	}
	$j('#table_config').after(vpnserverstablehtml);
	
	var vpnclientstablehtml='';
	for(var i = 1; i < 6; i++){
		vpnclientstablehtml += BuildVPNClientTable(i);
	}
	$j('#table_config').after(vpnclientstablehtml);
	
	var servicectablehtml='';
	for(var i = 0; i < srvnamelist.length; i++){
		servicectablehtml += BuildServiceTable(srvnamelist[i],srvdesclist[i],srvnamevisiblelist[i],i);
	}
	$j('#table_config').after(servicectablehtml);
	
	document.formScriptActions.action_script.value='start_scmerlingetaddonpages;start_scmerlingetcronjobs';
	document.formScriptActions.submit();
	load_addonpages();
	get_proclist_file();
	get_cronlist_file();
	get_ntpwatchdogenabled_file();
	update_temperatures();
	update_sysinfo();
	ScriptUpdateLayout();
}

function ScriptUpdateLayout(){
	var localver = GetVersionNumber('local');
	var serverver = GetVersionNumber('server');
	$j('#scmerlin_version_local').text(localver);
	
	if(localver != serverver && serverver != 'N/A'){
		$j('#scmerlin_version_server').text('Updated version available: '+serverver);
		showhide('btnChkUpdate',false);
		showhide('scmerlin_version_server',true);
		showhide('btnDoUpdate',true);
	}
}

function reload(){
	location.reload(true);
}

function update_status(){
	$j.ajax({
		url: '/ext/scmerlin/detect_update.js',
		dataType: 'script',
		timeout: 3000,
		error: function(xhr){
			setTimeout(update_status,1000);
		},
		success: function(){
			if(updatestatus == 'InProgress'){
				setTimeout(update_status,1000);
			}
			else{
				document.getElementById('imgChkUpdate').style.display = 'none';
				showhide('scmerlin_version_server',true);
				if(updatestatus != 'None'){
					$j('#scmerlin_version_server').text('Updated version available: '+updatestatus);
					showhide('btnChkUpdate',false);
					showhide('btnDoUpdate',true);
				}
				else{
					$j('#scmerlin_version_server').text('No update available');
					showhide('btnChkUpdate',true);
					showhide('btnDoUpdate',false);
				}
			}
		}
	});
}

function CheckUpdate(){
	showhide('btnChkUpdate',false);
	document.formScriptActions.action_script.value='start_scmerlincheckupdate';
	document.formScriptActions.submit();
	document.getElementById('imgChkUpdate').style.display = '';
	setTimeout(update_status,2000);
}

function DoUpdate(){
	document.form.action_script.value = 'start_scmerlindoupdate';
	document.form.action_wait.value = 10;
	showLoading();
	document.form.submit();
}

function RestartService(servicename){
	showhide('btnRestartSrv_'+servicename,false);
	showhide('txtRestartSrv_'+servicename,false);
	document.formScriptActions.action_script.value='start_scmerlinservicerestart'+servicename;
	document.formScriptActions.submit();
	document.getElementById('imgRestartSrv_'+servicename).style.display = '';
	setTimeout(service_status,1000,servicename);
}

function service_status(servicename){
	$j.ajax({
		url: '/ext/scmerlin/detect_service.js',
		dataType: 'script',
		timeout: 3000,
		error:	function(xhr){
			setTimeout(service_status,1000,servicename);
		},
		success: function(){
			if(servicestatus == 'InProgress'){
				setTimeout(service_status,1000,servicename);
			}
			else{
				document.getElementById('imgRestartSrv_'+servicename).style.display = 'none';
				if(servicestatus == 'Done'){
					showhide('txtRestartSrv_'+servicename,true);
					setTimeout(showhide,3000,'txtRestartSrv_'+servicename,false);
					setTimeout(showhide,3250,'btnRestartSrv_'+servicename,true);
				}
				else{
					showhide('txtRestartSrvError_'+servicename,true);
				}
			}
		}
	});
}

function GetVersionNumber(versiontype){
	var versionprop;
	if(versiontype == 'local'){
		versionprop = custom_settings.scmerlin_version_local;
	}
	else if(versiontype == 'server'){
		versionprop = custom_settings.scmerlin_version_server;
	}
	
	if(typeof versionprop == 'undefined' || versionprop == null){
		return 'N/A';
	}
	else{
		return versionprop;
	}
}

function BuildSortTableHtml(type) {
	var tablehtml = '<table border="0" cellpadding="0" cellspacing="0" width="100%" class="procTable" style="table-layout:fixed;">';
	if(type == 'sortTableProcesses'){
		tablehtml += '<col style="width:50px;">';
		tablehtml += '<col style="width:50px;">';
		tablehtml += '<col style="width:75px;">';
		tablehtml += '<col style="width:50px;">';
		tablehtml += '<col style="width:50px;">';
		tablehtml += '<col style="width:55px;">';
		tablehtml += '<col style="width:50px;">';
		tablehtml += '<col style="width:55px;">';
		tablehtml += '<col style="width:740px;">';
		tablehtml += '<thead class="sortTableHeader">';
		tablehtml += '<tr>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">PID</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">PPID</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">USER</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">STAT</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">VSZ</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">VSZ%</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">CPU</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">CPU%</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableProcesses\',\'arrayproclistlines\',this.innerHTML,\'sortnameproc\',\'sortdirproc\')">COMMAND</th>';
		tablehtml += '</tr>';
		tablehtml += '</thead>';
		tablehtml += '<tbody class="sortTableContent">';
		
		for(var i = 0; i < arrayproclistlines.length; i++){
			tablehtml += '<tr class="sortRow">';
			tablehtml += '<td>'+arrayproclistlines[i].PID+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].PPID+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].USER+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].STAT+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].VSZ+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].VSZP+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].CPU+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].CPUP+'</td>';
			tablehtml += '<td>'+arrayproclistlines[i].COMMAND+'</td>';
			tablehtml += '</tr>';
		}
	}
	else if(type == 'sortTableCron'){
		tablehtml += '<col style="width:175px;">';
		tablehtml += '<col style="width:45px;">';
		tablehtml += '<col style="width:45px;">';
		tablehtml += '<col style="width:45px;">';
		tablehtml += '<col style="width:45px;">';
		tablehtml += '<col style="width:45px;">';
		tablehtml += '<col style="width:740px;">';
		tablehtml += '<thead class="sortTableHeader">';
		tablehtml += '<tr>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">Name</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">Min</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">Hour</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">DayM</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">Month</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">DayW</th>';
		tablehtml += '<th class="sortable" onclick="SortTable(\'sortTableCron\',\'arraycronjobs\',this.innerHTML,\'sortnamecron\',\'sortdircron\')">Command</th>';
		tablehtml += '</tr>';
		tablehtml += '</thead>';
		tablehtml += '<tbody class="sortTableContent">';
		
		for(var i = 0; i < arraycronjobs.length; i++){
			tablehtml += '<tr class="sortRow">';
			tablehtml += '<td>'+arraycronjobs[i].Name+'</td>';
			tablehtml += '<td>'+arraycronjobs[i].Min+'</td>';
			tablehtml += '<td>'+arraycronjobs[i].Hour+'</td>';
			tablehtml += '<td>'+arraycronjobs[i].DayM+'</td>';
			tablehtml += '<td>'+arraycronjobs[i].Month+'</td>';
			tablehtml += '<td>'+arraycronjobs[i].DayW+'</td>';
			tablehtml += '<td>'+arraycronjobs[i].Command+'</td>';
			tablehtml += '</tr>';
		}
	}
	tablehtml += '</tbody>';
	tablehtml += '</table>';
	return tablehtml;
}

function get_ntpwatchdogenabled_file(){
	$j.ajax({
		url: '/ext/scmerlin/watchdogenabled.htm',
		dataType: 'text',
		timeout: 10000,
		error: function(xhr){
			document.form.scmerlin_ntpwatchdog.value = 'disable';
		},
		success: function(data){
			document.form.scmerlin_ntpwatchdog.value = 'enable';
		}
	});
}

function load_addonpages(){
	$j.ajax({
		url: '/ext/scmerlin/addonwebpages.htm',
		dataType: 'text',
		error: function(xhr){
			setTimeout(load_addonpages,1000);
		},
		success: function(data){
			var addonpages = data.split('\n');
			addonpages = addonpages.filter(Boolean);
			for(var i = 0; i < addonpages.length; i++){
				try{
					var addonfields = addonpages[i].split(',');
					var parsedaddonline = new Object();
					parsedaddonline.NAME =  addonfields[0].trim();
					parsedaddonline.URL = addonfields[1].trim();
					sortedAddonPages.push(parsedaddonline);
				}
				catch{
					//do nothing,continue
				}
			}
			
			sortedAddonPages = sortedAddonPages.sort(function(a,b) {
				return a.NAME.toLowerCase().localeCompare(b.NAME.toLowerCase());
			});
			
			var addonpageshtml='';
			for(var i = 0; i < sortedAddonPages.length; i++){
				addonpageshtml += BuildAddonPageTable(sortedAddonPages[i].NAME,sortedAddonPages[i].URL,i);
			}
			
			$j('#table_config').after(addonpageshtml);
			
			AddEventHandlers();
		}
	});
}

function get_cronlist_file(){
	$j.ajax({
		url: '/ext/scmerlin/scmcronjobs.htm',
		dataType: 'text',
		error: function(xhr){
			tout = setTimeout(get_cronlist_file,1000);
		},
		success: function(data){
			ParseCronJobs(data);
		}
	});
}

function ParseCronJobs(data){
	var cronjobs = data.split('\n');
	cronjobs = cronjobs.filter(Boolean);
	arraycronjobs = [];
	
	for(var i = 0; i < cronjobs.length; i++){
		try{
			var cronfields = cronjobs[i].split(',');
			var parsedcronline = new Object();
			parsedcronline.Name = cronfields[0].trim().replace(/^\"/,'').replace(/\"$/,'');
			parsedcronline.Min = cronfields[1].trim().replace(/^\"/,'').replace(/\"$/,'').replace(/\|/,',');
			parsedcronline.Hour = cronfields[2].trim().replace(/^\"/,'').replace(/\"$/,'').replace(/\|/,',');
			parsedcronline.DayM = cronfields[3].trim().replace(/^\"/,'').replace(/\"$/,'').replace(/\|/,',');
			parsedcronline.Month = cronfields[4].trim().replace(/^\"/,'').replace(/\"$/,'').replace(/\|/,',');
			parsedcronline.DayW = cronfields[5].trim().replace(/^\"/,'').replace(/\"$/,'').replace(/\|/,',');
			parsedcronline.Command = cronfields[6].trim().replace(/^\"/,'').replace(/\"$/,'');
			arraycronjobs.push(parsedcronline);
		}
		catch{
			//do nothing,continue
		}
	}
	
	SortTable('sortTableCron','arraycronjobs',sortnamecron+' '+sortdircron.replace('desc','↑').replace('asc','↓').trim(),'sortnamecron','sortdircron');
}

function get_proclist_file(){
	$j.ajax({
		url: '/ext/scmerlin/top.htm',
		dataType: 'text',
		error: function(xhr){
			tout = setTimeout(get_proclist_file,1000);
		},
		success: function(data){
			ParseProcList(data);
			if(document.getElementById('auto_refresh').checked){
				tout = setTimeout(get_proclist_file,5000);
			}
		}
	});
}

function ParseProcList(data){
	var arrayproclines = data.split('\n');
	arrayproclines = arrayproclines.filter(Boolean);
	arrayproclistlines = [];
	for(var i = 0; i < arrayproclines.length; i++){
		try{
			var procfields = arrayproclines[i].split(',');
			var parsedprocline = new Object();
			parsedprocline.PID =  procfields[0].trim();
			parsedprocline.PPID = procfields[1].trim();
			parsedprocline.USER = procfields[2].trim();
			parsedprocline.STAT = procfields[3].trim();
			parsedprocline.VSZ = procfields[4].trim();
			parsedprocline.VSZP = procfields[5].trim();
			parsedprocline.CPU = procfields[6].trim();
			parsedprocline.CPUP = procfields[7].trim();
			parsedprocline.COMMAND = procfields[8].trim();
			arrayproclistlines.push(parsedprocline);
		}
		catch{
			//do nothing,continue
		}
	}
	SortTable('sortTableProcesses','arrayproclistlines',sortnameproc+' '+sortdirproc.replace('desc','↑').replace('asc','↓').trim(),'sortnameproc','sortdirproc');
}

function GetCookie(cookiename,returntype){
	if(cookie.get('scm_'+cookiename) != null){
		return cookie.get('scm_'+cookiename);
	}
	else{
		if(returntype == 'string'){
			return '';
		}
		else if(returntype == 'number'){
			return 0;
		}
	}
}

function SetCookie(cookiename,cookievalue){
	cookie.set('scm_'+cookiename,cookievalue,10 * 365);
}

function AddEventHandlers(){
	$j('.collapsible-jquery').off('click').on('click',function(){
		$j(this).siblings().toggle('fast',function(){
			if($j(this).css('display') == 'none'){
				SetCookie($j(this).siblings()[0].id,'collapsed');
			}
			else{
				SetCookie($j(this).siblings()[0].id,'expanded');
				if($j(this).siblings()[0].id == 'routermemory'){
					Draw_Chart('MemoryUsage');
					if(parseInt(mem_stats_arr[5]) != 0){
						Draw_Chart('SwapUsage');
					}
					else{
						Draw_Chart_NoData('SwapUsage');
					}
				}
				else if($j(this).siblings()[0].id == 'routerstorage'){
					Draw_Chart('nvramUsage');
					Draw_Chart('jffsUsage');
				}
			}
		})
	});
	
	$j('.collapsible-jquery').each(function(index,element){
		if(GetCookie($j(this)[0].id,'string') == 'collapsed'){
			$j(this).siblings().toggle(false);
		}
		else{
			$j(this).siblings().toggle(true);
		}
	});
	
	$j('#auto_refresh')[0].addEventListener('click',function(){ToggleRefresh();});
}

function SortTable(tableid,arrayid,sorttext,sortname,sortdir){
	window[sortname] = sorttext.replace('↑','').replace('↓','').trim();
	var sorttype = 'number';
	var sortfield = window[sortname];
	switch(window[sortname]){
		case 'VSZ%':
			sortfield = 'VSZP';
		break;
		case 'CPU%':
			sortfield = 'CPUP';
		break;
		case 'USER':
		case 'STAT':
		case 'COMMAND':
		case 'Name':
		case 'Command':
			sorttype = 'string';
		break;
	}
	
	if(sorttype == 'string'){
		if(sorttext.indexOf('↓') == -1 && sorttext.indexOf('↑') == -1){
			eval(arrayid+' = '+arrayid+'.sort((a,b) => (a.'+sortfield+'.toLowerCase() > b.'+sortfield+'.toLowerCase()) ? 1 : ((b.'+sortfield+'.toLowerCase() > a.'+sortfield+'.toLowerCase()) ? -1 : 0));');
			window[sortdir] = 'asc';
		}
		else if(sorttext.indexOf('↓') != -1){
			eval(arrayid+' = '+arrayid+'.sort((a,b) => (a.'+sortfield+'.toLowerCase() > b.'+sortfield+'.toLowerCase()) ? 1 : ((b.'+sortfield+'.toLowerCase() > a.'+sortfield+'.toLowerCase()) ? -1 : 0));');
			window[sortdir] = 'asc';
		}
		else{
			eval(arrayid+' = '+arrayid+'.sort((a,b) => (a.'+sortfield+'.toLowerCase() < b.'+sortfield+'.toLowerCase()) ? 1 : ((b.'+sortfield+'.toLowerCase() < a.'+sortfield+'.toLowerCase()) ? -1 : 0));');
			window[sortdir] = 'desc';
		}
	}
	else if(sorttype == 'number'){
		if(sorttext.indexOf('↓') == -1 && sorttext.indexOf('↑') == -1){
			eval(arrayid+' = '+arrayid+'.sort((a,b) => parseFloat(getNum(a.'+sortfield+'.replace("m","000"))) - parseFloat(getNum(b.'+sortfield+'.replace("m","000"))));');
			window[sortdir] = 'asc';
		}
		else if(sorttext.indexOf('↓') != -1){
			eval(arrayid+' = '+arrayid+'.sort((a,b) => parseFloat(getNum(a.'+sortfield+'.replace("m","000"))) - parseFloat(getNum(b.'+sortfield+'.replace("m","000"))));');
			window[sortdir] = 'asc';
		}
		else{
			eval(arrayid+' = '+arrayid+'.sort((a,b) => parseFloat(getNum(b.'+sortfield+'.replace("m","000"))) - parseFloat(getNum(a.'+sortfield+'.replace("m","000"))));');
			window[sortdir] = 'desc';
		}
	}
	
	$j('#'+tableid).empty();
	$j('#'+tableid).append(BuildSortTableHtml(tableid));
	
	$j('#'+tableid).find('.sortable').each(function(index,element){
		if(element.innerHTML == window[sortname]){
			if(window[sortdir] == 'asc'){
				element.innerHTML = window[sortname]+' ↑';
			}
			else{
				element.innerHTML = window[sortname]+' ↓';
			}
		}
	});
}

function getNum(val){
	if(isNaN(val)){
		if(val == "*"){
			return -10;
		}
		else if(val.indexOf("*/") != -1){
			return -5;
		}
		else if(val.indexOf("/") != -1){
			return val.split("/")[0];
		}
		else if(val == "Sun"){
			return 0;
		}
		else if(val == "Mon"){
			return 1;
		}
		else if(val == "Tue"){
			return 2;
		}
		else if(val == "Wed"){
			return 3;
		}
		else if(val == "Thu"){
			return 4;
		}
		else if(val == "Fri"){
			return 5;
		}
		else if(val == "Sat"){
			return 6;
		}
	}
	return val;
}

function ToggleRefresh(){
	$j('#auto_refresh').prop('checked',function(i,v) { if(v){get_proclist_file();} else{clearTimeout(tout);} });
}

function BuildAddonPageTable(addonname,addonurl,loopindex){
	var addonpageshtml = '';
	
	if(loopindex == 0){
		addonpageshtml += '<div style="line-height:10px;">&nbsp;</div>';
		addonpageshtml += '<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_services">';
		addonpageshtml += '<thead class="collapsible-jquery" id="addonpages">';
		addonpageshtml += '<tr><td colspan="4">WebUI Addons (click to expand/collapse)</td></tr>';
		addonpageshtml += '</thead>';
	}
	
	if(loopindex == 0 || loopindex % 4 == 0){
		addonpageshtml += '<tr>';
	}
	
	addonpageshtml += '<td class="addonpageurl"><a href="'+addonurl.substring(addonurl.lastIndexOf("/")+1)+'">'+addonname+'</a><br /><span class="addonpageurl">'+addonurl.substring(addonurl.lastIndexOf("/")+1)+'</span></td>';
	if(loopindex > 0 && (loopindex+1) % 4 == 0){
		addonpageshtml += '</tr>';
	}
	
	if(loopindex == sortedAddonPages.length-1){
		if(sortedAddonPages.length % 4 != 0){
			var missingtds = 4 - sortedAddonPages.length % 4;
			for(var i = 0; i < missingtds; i++){
				addonpageshtml += '<td class="addonpageurl"></td>';
			}
			addonpageshtml += '</tr>';
		}
		addonpageshtml += '</table>';
	}
	
	return addonpageshtml;
}

function BuildServiceTable(srvname,srvdesc,srvnamevisible,loopindex){
	var serviceshtml = '';
	
	if(loopindex == 0){
		serviceshtml += '<div style="line-height:10px;">&nbsp;</div>';
		serviceshtml += '<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_services">';
		serviceshtml += '<thead class="collapsible-jquery" id="servicescontrol">';
		serviceshtml += '<tr><td colspan="4">Services (click to expand/collapse)</td></tr>';
		serviceshtml += '</thead>';
	}
	
	if(loopindex == 0 || loopindex % 2 == 0){
		serviceshtml += '<tr>';
	}
	if(srvnamevisible){
		serviceshtml += '<td class="servicename">'+srvdesc+' <span class="settingname">('+srvname+')</span></td>';
	}
	else{
		serviceshtml += '<td class="servicename">'+srvdesc+'</td>';
	}
	srvname = srvname.replace('/','');
	serviceshtml += '<td class="servicevalue">';
	serviceshtml += '<input type="button" class="button_gen restartbutton" onclick="RestartService(\''+srvname+'\');" value="Restart" id="btnRestartSrv_'+srvname+'">';
	serviceshtml += '<span id="txtRestartSrv_'+srvname+'" style="display:none;" class="servicespan">Done</span>';
	serviceshtml += '<span id="txtRestartSrvError_'+srvname+'" style="display:none;" class="servicespan">Invalid - service disabled</span>';
	serviceshtml += '<img id="imgRestartSrv_'+srvname+'" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>';
	serviceshtml += '</td>';
	if(loopindex > 0 && (loopindex+1) % 2 == 0){
		serviceshtml += '</tr>';
	}
	
	if(loopindex == srvnamelist.length-1){
		serviceshtml += '</table>';
	}
	
	return serviceshtml;
}

function BuildVPNClientTable(loopindex){
	var vpnclientshtml = '';
	var vpnclientname = 'vpnclient'+loopindex;
	var vpnclientdesc = eval('document.form.vpnc'+loopindex+'_desc').value;
	
	if(loopindex == 1){
		vpnclientshtml += '<div style="line-height:10px;">&nbsp;</div>';
		vpnclientshtml += '<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_vpnclients">';
		vpnclientshtml += '<thead class="collapsible-jquery" id="vpnclientscontrol">';
		vpnclientshtml += '<tr><td colspan="4">VPN Clients (click to expand/collapse)</td></tr>';
		vpnclientshtml += '</thead>';
	}
	
	if(loopindex == 1 || (loopindex+1) % 2 == 0){
		vpnclientshtml += '<tr>';
	}
	vpnclientshtml += '<td class="servicename">VPN Client '+loopindex;
	vpnclientshtml += '<br /><span class="settingname">('+vpnclientdesc+')</span></td>';
	vpnclientshtml += '<td class="servicevalue">';
	vpnclientshtml += '<input type="button" class="button_gen restartbutton" onclick="RestartService(\''+vpnclientname+'\');" value="Restart" id="btnRestartSrv_'+vpnclientname+'">';
	vpnclientshtml += '<span id="txtRestartSrv_'+vpnclientname+'" style="display:none;" class="servicespan">Done</span>';
	vpnclientshtml += '<span id="txtRestartSrvError_'+vpnclientname+'" style="display:none;" class="servicespan">Invalid - VPN Client disabled</span>';
	vpnclientshtml += '<img id="imgRestartSrv_'+vpnclientname+'" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>';
	vpnclientshtml += '</td>';
	
	if(loopindex == 5){
		vpnclientshtml += '<td class="servicename"></td><td class="servicevalue"></td>';
	}
	
	if(loopindex > 1 && loopindex % 2 == 0){
		vpnclientshtml += '</tr>';
	}
	
	if(loopindex == 5){
		vpnclientshtml += '</table>';
	}
	
	return vpnclientshtml;
}

function BuildVPNServerTable(loopindex){
	var vpnservershtml = '';
	var vpnservername = 'vpnserver'+loopindex;
	
	if(loopindex == 1){
		vpnservershtml += '<div style="line-height:10px;">&nbsp;</div>';
		vpnservershtml += '<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_vpnservers">';
		vpnservershtml += '<thead class="collapsible-jquery" id="vpnserverscontrol">';
		vpnservershtml += '<tr><td colspan="4">VPN Servers (click to expand/collapse)</td></tr>';
		vpnservershtml += '</thead>';
		vpnservershtml += '<tr>';
	}
	
	vpnservershtml += '<td class="servicename">VPN Server '+loopindex+'</td>';
	vpnservershtml += '<td class="servicevalue">';
	vpnservershtml += '<input type="button" class="button_gen restartbutton" onclick="RestartService(\''+vpnservername+'\');" value="Restart" id="btnRestartSrv_'+vpnservername+'">';
	vpnservershtml += '<span id="txtRestartSrv_'+vpnservername+'" style="display:none;" class="servicespan">Done</span>';
	vpnservershtml += '<span id="txtRestartSrvError_'+vpnservername+'" style="display:none;" class="servicespan">Invalid - VPN Server disabled</span>';
	vpnservershtml += '<img id="imgRestartSrv_'+vpnservername+'" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>';
	vpnservershtml += '</td>';
	
	if(loopindex == 2){
		vpnservershtml += '</tr>';
		vpnservershtml += '</table>';
	}
	
	return vpnservershtml;
}

function round(value,decimals){
	return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}

function Draw_Chart_NoData(txtchartname){
	document.getElementById('canvasChart'+txtchartname).width = '265';
	document.getElementById('canvasChart'+txtchartname).height = '250';
	document.getElementById('canvasChart'+txtchartname).style.width = '265px';
	document.getElementById('canvasChart'+txtchartname).style.height = '250px';
	var ctx = document.getElementById('canvasChart'+txtchartname).getContext('2d');
	ctx.save();
	ctx.textAlign = 'center';
	ctx.textBaseline = 'middle';
	ctx.font = 'normal normal bolder 22px Arial';
	ctx.fillStyle = 'white';
	ctx.fillText('No swap file configured',135,125);
	ctx.restore();
}

function Draw_Chart(txtchartname){
	var chartData = [];
	var chartLabels = [];
	var chartColours = [];
	var chartTitle = '';
	var chartUnit = '';
	
	if(txtchartname == 'MemoryUsage'){
		chartData = [mem_stats_arr[0]*1-mem_stats_arr[1]*1-mem_stats_arr[2]*1-mem_stats_arr[3]*1,mem_stats_arr[1],mem_stats_arr[2],mem_stats_arr[3]];
		chartLabels = ['Used','Free','Buffers','Cache'];
		chartColours = ['#5eaec0','#12cf80','#ceca09','#9d12c4'];
		chartTitle = 'Memory Usage';
		chartUnit = 'MB';
	}
	else if(txtchartname == 'SwapUsage'){
		chartData = [mem_stats_arr[4],mem_stats_arr[5]*1-mem_stats_arr[4]*1];
		chartLabels = ['Used','Free'];
		chartColours = ['#135fee','#1aa658'];
		chartTitle = 'Swap Usage';
		chartUnit = 'MB';
	}
	else if(txtchartname == 'nvramUsage'){
		chartData = [round(mem_stats_arr[6]/1024,2).toFixed(2),round(nvramtotal*1-mem_stats_arr[6]*1/1024,2).toFixed(2)];
		chartLabels = ['Used','Free'];
		chartColours = ['#5eaec0','#12cf80'];
		chartTitle = 'NVRAM Usage';
		chartUnit = 'KB';
	}
	else if(txtchartname == 'jffsUsage'){
		var jffs_usage = mem_stats_arr[7].split(' ');
		chartData = [jffs_usage[0]*1,jffs_usage[2]*1-jffs_usage[0]*1];
		chartLabels = ['Used','Free'];
		chartColours = ['#135fee','#1aa658'];
		chartTitle = 'JFFS Usage';
		chartUnit = 'MB';
	}
	
	var objchartname = window['Chart'+txtchartname];
	
	if(objchartname != undefined) objchartname.destroy();
	var ctx = document.getElementById('canvasChart'+txtchartname).getContext('2d');
	var chartOptions = {
		segmentShowStroke: false,
		segmentStrokeColor: '#000',
		maintainAspectRatio: false,
		animation: {
			duration: 0 // general animation time
		},
		hover: {
			animationDuration: 0 // duration of animations when hovering an item
		},
		responsiveAnimationDuration: 0,
		legend: {
			onClick: null,
			display: true,
			position: 'left',
			labels: {
				fontColor: '#ffffff'
			}
		},
		title: {
			display: true,
			text: chartTitle,
			position: 'top'
		},
		tooltips: {
			callbacks: {
				title: function(tooltipItem,data){
					return data.labels[tooltipItem[0].index];
				},
				label: function(tooltipItem,data){
					return round(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index],2).toFixed(2)+' '+chartUnit;
				}
			},
			mode: 'point',
			position: 'cursor',
			intersect: true
		},
		scales: {
			xAxes: [{
				display: false,
				gridLines: {
					display: false
				},
				scaleLabel: {
					display: false
				},
				ticks: {
					display: false
				}
			}],
			yAxes: [{
				display: false,
				gridLines: {
					display: false
				},
				scaleLabel: {
					display: false
				},
				ticks: {
					display: false
				}
			}]
		},
	};
	var chartDataset = {
		labels: chartLabels,
		datasets: [{
			data: chartData,
			borderWidth: 1,
			backgroundColor: chartColours,
			borderColor: '#000000'
		}]
	};
	objchartname = new Chart(ctx,{
		type: 'pie',
		options: chartOptions,
		data: chartDataset
	});
	window['Chart'+txtchartname] = objchartname;
}

function SaveConfig(){
	document.form.action_script.value = 'start_scmerlinconfig'+document.form.scmerlin_ntpwatchdog.value;
	document.form.action_wait.value = 10;
	showLoading();
	document.form.submit();
}

</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="about:blank" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="action_script" value="start_scmerlin">
<input type="hidden" name="current_page" value="">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="60">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="SystemCmd" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="vpnc1_desc" value="<% nvram_get("vpn_client1_desc"); %>">
<input type="hidden" name="vpnc2_desc" value="<% nvram_get("vpn_client2_desc"); %>">
<input type="hidden" name="vpnc3_desc" value="<% nvram_get("vpn_client3_desc"); %>">
<input type="hidden" name="vpnc4_desc" value="<% nvram_get("vpn_client4_desc"); %>">
<input type="hidden" name="vpnc5_desc" value="<% nvram_get("vpn_client5_desc"); %>">
<input type="hidden" name="amng_custom" id="amng_custom" value="">
<table class="content" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="17">&nbsp;</td>
<td valign="top" width="202">
<div id="mainMenu"></div>
<div id="subMenu"></div></td>
<td valign="top">
<div id="tabMenu" class="submenuBlock"></div>
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
<table width="760px" border="0" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
<tbody>
<tr bgcolor="#4D595D">
<td valign="top">
<div>&nbsp;</div>
<div class="formfonttitle" id="scripttitle" style="text-align:center;">scMerlin</div>
<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
<div class="formfontdesc">scMerlin allows you to use easily control the most common services/scripts on your router.</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_buttons">
<thead class="collapsible-jquery" id="scripttools">
<tr><td colspan="2">Utilities (click to expand/collapse)</td></tr>
</thead>
<tr>
<th width="20%">Version information</th>
<td>
<span id="scmerlin_version_local" style="color:#FFFFFF;"></span>
&nbsp;&nbsp;&nbsp;
<span id="scmerlin_version_server" style="display:none;">Update version</span>
&nbsp;&nbsp;&nbsp;
<input type="button" class="button_gen" onclick="CheckUpdate();" value="Check" id="btnChkUpdate">
<img id="imgChkUpdate" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>
<input type="button" class="button_gen" onclick="DoUpdate();" value="Update" id="btnDoUpdate" style="display:none;">
&nbsp;&nbsp;&nbsp;
</td>
</tr>
</table>

<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_config">
<thead class="collapsible-jquery" id="scriptconfig">
<tr><td colspan="2">Configuration (click to expand/collapse)</td></tr>
</thead>
<tr class="even" id="rowenablentpwatchdog">
<td class="settingname">Enable NTP boot watchdog script<br/></td>
<td class="settingvalue">
<input type="radio" name="scmerlin_ntpwatchdog" id="scmerlin_ntpwatchdog_enabled" class="input" value="enable">
<label for="scmerlin_ntpwatchdog_enabled">Yes</label>
<input type="radio" name="scmerlin_ntpwatchdog" id="scmerlin_ntpwatchdog_disabled" class="input" value="disable" checked>
<label for="scmerlin_ntpwatchdog_disabled">No</label>
</td>
</tr>
<tr class="apply_gen" valign="top" height="35px">
<td colspan="2" class="savebutton">
<input type="button" onclick="SaveConfig();" value="Save" class="button_gen savebutton" name="button">
</td>
</tr>
</table>

<!-- Insert service control tables here -->

<!-- Start Entware table -->
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_entware">
<thead class="collapsible-jquery" id="entwarecontrol">
<tr><td colspan="2">Entware (click to expand/collapse)</td></tr>
</thead>
<tr>
<td class="settingname">Entware applications</td>
<td class="settingvalue">
<input type="button" class="button_gen restartbutton" onclick="RestartService('entware');" value="Restart" id="btnRestartSrv_entware">
<span id="txtRestartSrv_entware" style="display:none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>
<span id="txtRestartSrvError_entware" style="display:none;">Invalid - Entware not running</span>
<img id="imgRestartSrv_entware" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>
&nbsp;&nbsp;&nbsp;
</td>
</tr>
</table>
<!-- End Entware table -->
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead class="collapsible-jquery" id="router">
<tr>
<td>Router (click to expand/collapse)</td>
</tr>
</thead>
<tr><td align="center" style="padding: 0px;">
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable">
<thead class="collapsible-jquery" id="routertemps">
<tr>
<td colspan="2">Temperatures (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<td class="settingname">Temperatures</td>
<td id="temp_td" class="settingvalue"></td>
</tr>
</table>
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead class="collapsible-jquery" id="routermemory">
<tr>
<td colspan="4">Memory (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<td class="metricname">Total</td>
<td id="mem_total_td" width="125px" style="width:125px;"></td>
<td id="ram_chart" rowspan="5" style="padding-left:4px;width:265px;" width="265px">
<div style="background-color:#2f3e44;border-radius:10px;width:265px;" id="divChartMemoryUsage">
<canvas id="canvasChartMemoryUsage" height="250" />
</div>
</td>
<td id="swap_chart" rowspan="5" style="padding-left:4px;width:265px;" width="265px">
<div style="background-color:#2f3e44;border-radius:10px;width:265px;" id="divChartSwapUsage">
<canvas id="canvasChartSwapUsage" height="250" />
</div>
</td>
</tr>
<tr>
<td class="metricname">Free</td>
<td id="mem_free_td" style="width:125px;"></td>
</tr>
<tr>
<td class="metricname">Buffers</td>
<td id="mem_buffer_td" style="width:125px;"></td>
</tr>
<tr>
<td class="metricname">Cache</td>
<td id="mem_cache_td" style="width:125px;"></td>
</tr>
<tr>
<td class="metricname">Swap</td>
<td id="mem_swap_td" style="width:125px;"></td>
</tr>
</table>
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead class="collapsible-jquery" id="routerstorage">
<tr>
<td colspan="4">Internal Storage (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<td class="metricname">NVRAM</td>
<td id="nvram_td" style="width:125px;"></td>
<td id="nvram_chart" rowspan="2" style="padding-left:4px;width:265px;" width="265px">
<div style="background-color:#2f3e44;border-radius:10px;width:265px;" id="divChartnvramUsage">
<canvas id="canvasChartnvramUsage" height="250" />
</div>
</td>
<td id="jffs_chart" rowspan="2" style="padding-left:4px;width:265px;" width="265px">
<div style="background-color:#2f3e44;border-radius:10px;width:265px;" id="divChartjffsUsage">
<canvas id="canvasChartjffsUsage" height="250" />
</div>
</td>
</tr>
<tr>
<td class="metricname">JFFS</td>
<td id="jffs_td" style="width:125px;"></td>
</tr>
</table>

<!-- Start Cron table -->
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="scm_table_cron">
<thead class="collapsible-jquery" id="thead_cron">
<tr><td>Cron Jobs (click to expand/collapse)</td></tr>
</thead>
<tr>
<td align="center" style="padding: 0px;">
<div id="sortTableCron" class="sortTableContainer" style="height:300px;"></div>
</td>
</tr>
</table>
<!-- End Cron table -->

<!-- Start Process List -->
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="scm_table_proclist">
<col style="width:35%;">
<col style="width:65%;">
<thead class="collapsible-jquery" id="proclist">
<tr><td colspan="2">Process List (click to expand/collapse)</td></tr>
</thead>
<tr class="even">
<th>Update automatically?</th>
<td>
<label style="color:#FFCC00;display:block;">
<input type="checkbox" checked="" id="auto_refresh" style="padding:0;margin:0;vertical-align:middle;position:relative;top:-1px;" />&nbsp;&nbsp;Table will refresh every 5s</label>
</td>
</tr>
<tr style="line-height:5px;"><td colspan="2">&nbsp;</td></tr>
<tr>
<td colspan="2" align="center" style="padding: 0px;">
<div id="sortTableProcesses" class="sortTableContainer"></div>
</td>
</tr>
</table>
<!-- End Process List -->
</td>
</tr>
</table>
</td>
</tr>
</tbody>
</table></td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<form method="post" name="formScriptActions" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="current_page" value="">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="action_wait" value="">
</form>
<div id="footer">
</div>
</body>
</html>

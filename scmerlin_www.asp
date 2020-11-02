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

div.procTableContainer {
  height: 500px;
  overflow-y: scroll;
  width: 755px;
  border: 1px solid #000;
}

thead.procTableHeader th {
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

thead.procTableHeader th:first-child,
thead.procTableHeader th:last-child {
  border-right: none !important;
}

thead.procTableHeader th:last-child {
  text-align: left !important;
  padding-left: 4px !important;
}

thead.procTableHeader th:first-child,
thead.procTableHeader td:first-child {
  border-left: none !important;
}

tbody.procTableContent td:last-child, tbody.procTableContent tr.procNormalRow td:last-child, tbody.procTableContent tr.procAlternateRow td:last-child {
  text-align: left !important;
  padding-left: 4px !important;
}

tbody.procTableContent td, tbody.procTableContent tr.procNormalRow td {
  background-color: #2F3A3E !important;
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

tbody.procTableContent tr.procAlternateRow td {
  background-color: #475A5F !important;
  border-bottom: 1px solid #000 !important;
  border-left: none !important;
  border-right: 1px solid #000 !important;
  border-top: none !important;
  padding: 2px;
  overflow: hidden !important;
  white-space: nowrap !important;
}

th.sortable {
  cursor: pointer;
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
	for (var prop in custom_settings) {
		if(Object.prototype.hasOwnProperty.call(custom_settings, prop)) {
			if(prop.indexOf("scmerlin") != -1 && prop.indexOf("scmerlin_version") == -1){
				eval("delete custom_settings."+prop)
			}
		}
	}
}
var arrayproclistlines = [];
var originalarrayproclistlines = [];
var sortfield = "CPU%";
var sortname = "CPU%";
var sortdir = "desc";
var tout;

var $j = jQuery.noConflict(); //avoid conflicts on John's fork (state.js)

function SetCurrentPage(){
	document.form.next_page.value = window.location.pathname.substring(1);
	document.form.current_page.value = window.location.pathname.substring(1);
}

var srvnamelist = ["dnsmasq","wan","httpd","wireless","vsftpd","samba","ddns","ntpd/chronyd"];
var srvdesclist = ["DNS/DHCP Server","Internet Connection","Web Interface","WiFi","FTP Server","Samba","DDNS client","Timeserver"];
var srvnamevisiblelist = [true,false,true,false,true,false,false,true];

function initial(){
	SetCurrentPage();
	LoadCustomSettings();
	show_menu();
	
	var vpnserverstablehtml="";
	for (i = 1; i < 3; i++){
		vpnserverstablehtml += BuildVPNServerTable(i);
	}
	$j("#table_buttons").after(vpnserverstablehtml);
	
	var vpnclientstablehtml="";
	for (i = 1; i < 6; i++){
		vpnclientstablehtml += BuildVPNClientTable(i);
	}
	$j("#table_buttons").after(vpnclientstablehtml);
	
	var servicectablehtml="";
	for (i = 0; i < srvnamelist.length; i++){
		servicectablehtml += BuildServiceTable(srvnamelist[i],srvdesclist[i],srvnamevisiblelist[i],i);
	}
	$j("#table_buttons").after(servicectablehtml);
	
	get_proclist_file();
	update_temperatures();
	update_sysinfo();
	ScriptUpdateLayout();
	AddEventHandlers();
}

function ScriptUpdateLayout(){
	var localver = GetVersionNumber("local");
	var serverver = GetVersionNumber("server");
	$j("#scripttitle").text($j("#scripttitle").text()+" - "+localver);
	$j("#scmerlin_version_local").text(localver);
	
	if(localver != serverver && serverver != "N/A"){
		$j("#scmerlin_version_server").text("Updated version available: "+serverver);
		showhide("btnChkUpdate", false);
		showhide("scmerlin_version_server", true);
		showhide("btnDoUpdate", true);
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
		error:	function(xhr){
			setTimeout('update_status();', 1000);
		},
		success: function(){
			if(updatestatus == "InProgress"){
				setTimeout('update_status();', 1000);
			}
			else{
				document.getElementById("imgChkUpdate").style.display = "none";
				showhide("scmerlin_version_server", true);
				if(updatestatus != "None"){
					$j("#scmerlin_version_server").text("Updated version available: "+updatestatus);
					showhide("btnChkUpdate", false);
					showhide("btnDoUpdate", true);
				}
				else{
					$j("#scmerlin_version_server").text("No update available");
					showhide("btnChkUpdate", true);
					showhide("btnDoUpdate", false);
				}
			}
		}
	});
}

function CheckUpdate(){
	showhide("btnChkUpdate", false);
	document.formScriptActions.action_script.value="start_scmerlincheckupdate";
	document.formScriptActions.submit();
	document.getElementById("imgChkUpdate").style.display = "";
	setTimeout("update_status();", 2000);
}

function DoUpdate(){
	var action_script_tmp = "start_scmerlindoupdate";
	document.form.action_script.value = action_script_tmp;
	var restart_time = 20;
	document.form.action_wait.value = restart_time;
	showLoading();
	document.form.submit();
}

function RestartService(servicename){
	showhide("btnRestartSrv_"+servicename, false);
	showhide("txtRestartSrv_"+servicename, false);
	document.formScriptActions.action_script.value="start_scmerlinservicerestart"+servicename;
	document.formScriptActions.submit();
	document.getElementById("imgRestartSrv_"+servicename).style.display = "";
	setTimeout("service_status('"+servicename+"');", 1000);
}

function service_status(servicename){
	$j.ajax({
		url: '/ext/scmerlin/detect_service.js',
		dataType: 'script',
		timeout: 3000,
		error:	function(xhr){
			setTimeout("service_status('"+servicename+"');", 1000);
		},
		success: function(){
			if(servicestatus == "InProgress"){
				setTimeout("service_status('"+servicename+"');", 1000);
			}
			else{
				document.getElementById("imgRestartSrv_"+servicename).style.display = "none";
				if(servicestatus == "Done"){
					showhide("btnRestartSrv_"+servicename, true);
					showhide("txtRestartSrv_"+servicename, true);
					setTimeout("showhide('txtRestartSrv_"+servicename+"',false);", 3000);
				}
				else{
					showhide("txtRestartSrvError_"+servicename, true);
				}
			}
		}
	});
}

function GetVersionNumber(versiontype){
	var versionprop;
	if(versiontype == "local"){
		versionprop = custom_settings.scmerlin_version_local;
	}
	else if(versiontype == "server"){
		versionprop = custom_settings.scmerlin_version_server;
	}
	
	if(typeof versionprop == 'undefined' || versionprop == null){
		return "N/A";
	}
	else{
		return versionprop;
	}
}

function BuildProcListTableHtml() {
	var tablehtml = '<table border="0" cellpadding="0" cellspacing="0" width="100%" class="procTable" style="table-layout:fixed;">';
	tablehtml += '<col style="width:50px;">';
	tablehtml += '<col style="width:50px;">';
	tablehtml += '<col style="width:75px;">';
	tablehtml += '<col style="width:50px;">';
	tablehtml += '<col style="width:50px;">';
	tablehtml += '<col style="width:55px;">';
	tablehtml += '<col style="width:50px;">';
	tablehtml += '<col style="width:55px;">';
	tablehtml += '<col style="width:740px;">';
	tablehtml += '<thead class="procTableHeader">';
	tablehtml += '<tr>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">PID</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">PPID</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">USER</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">STAT</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">VSZ</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">VSZ%</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">CPU</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">CPU%</th>';
	tablehtml += '<th class="sortable" onclick="SortTable(this.innerHTML)">COMMAND</th>';
	tablehtml += '</tr>';
	tablehtml += '</thead>';
	tablehtml += '<tbody class="procTableContent">';
	
	for(var i = 0; i < arrayproclistlines.length; i++){
		tablehtml += '<tr>';
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
	
	tablehtml += '</tbody>';
	tablehtml += '</table>';
	
	return tablehtml;
}

function get_proclist_file(){
	$j.ajax({
		url: '/ext/scmerlin/top.htm',
		dataType: 'text',
		error: function(xhr){
			tout = setTimeout(get_proclist_file, 1000);
		},
		success: function(data){
			ParseProcList(data);
			if(document.getElementById("auto_refresh").checked){
				tout = setTimeout("get_proclist_file();",3000);
			}
		}
	});
}

function ParseProcList(data){
	var arrayproclines = data.split("\n");
	arrayproclines = arrayproclines.filter(Boolean);
	arrayproclistlines = [];
	for(var i = 0; i < arrayproclines.length; i++){
		try{
			var procfields = arrayproclines[i].split(",");
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
			//do nothing, continue
		}
	}
	originalarrayproclistlines = arrayproclistlines;
	SortTable(sortname+" "+sortdir.replace("desc","↑").replace("asc","↓").trim());
}

function GetCookie(cookiename,returntype){
	var s;
	if((s = cookie.get("scm_"+cookiename)) != null){
		return cookie.get("scm_"+cookiename);
	}
	else{
		if(returntype == "string"){
			return "";
		}
		else if(returntype == "number"){
			return 0;
		}
	}
}

function SetCookie(cookiename,cookievalue){
	cookie.set("scm_"+cookiename, cookievalue, 31);
}

function AddEventHandlers(){
	$j(".collapsible-jquery").click(function(){
		$j(this).siblings().toggle("fast",function(){
			if($j(this).css("display") == "none"){
				SetCookie($j(this).siblings()[0].id,"collapsed");
			}
			else{
				SetCookie($j(this).siblings()[0].id,"expanded");
			}
		})
	});

	$j(".collapsible-jquery").each(function(index,element){
		if(GetCookie($j(this)[0].id,"string") == "collapsed"){
			$j(this).siblings().toggle(false);
		}
		else{
			$j(this).siblings().toggle(true);
		}
	});
	
	$j("#auto_refresh")[0].addEventListener("click", function(){ToggleRefresh();});
}

/* http://www.alistapart.com/articles/zebratables/ */
function stripedTable() {
	if(document.getElementById && document.getElementsByTagName) {
		var allTables = document.getElementsByClassName('procTable');
		if(!allTables) { return; }
		
		for (var i = 0; i < allTables.length; i++) {
			var trs = allTables[i].getElementsByTagName("tr");
			for (var j = 0; j < trs.length; j++) {
				$j(trs[j]).removeClass('procAlternateRow');
				$j(trs[j]).addClass('procNormalRow');
			}
			for (var k = 0; k < trs.length; k += 2) {
				$j(trs[k]).removeClass('procNormalRow');
				$j(trs[k]).addClass('procAlternateRow');
			}
		}
	}
}

function SortTable(sorttext){
	sortname = sorttext.replace("↑","").replace("↓","").trim();
	var sorttype = "number";
	sortfield=sortname;
	switch(sortname){
		case "VSZ%":
			sortfield="VSZP";
		break;
		case "CPU%":
			sortfield="CPUP";
		break;
		case "USER":
			sorttype = "string";
		break;
		case "STAT":
			sorttype = "string";
		break;
		case "COMMAND":
			sorttype = "string";
		break;
	}
	
	if(sorttype == "string"){
		if(sorttext.indexOf("↓") == -1 && sorttext.indexOf("↑") == -1){
			eval("arrayproclistlines = arrayproclistlines.sort((a,b) => (a."+sortfield+" > b."+sortfield+") ? 1 : ((b."+sortfield+" > a."+sortfield+") ? -1 : 0)); ");
			sortdir = "asc";
		}
		else if(sorttext.indexOf("↓") != -1){
			eval("arrayproclistlines = arrayproclistlines.sort((a,b) => (a."+sortfield+" > b."+sortfield+") ? 1 : ((b."+sortfield+" > a."+sortfield+") ? -1 : 0)); ");
			sortdir = "asc";
		}
		else{
			eval("arrayproclistlines = arrayproclistlines.sort((a,b) => (a."+sortfield+" < b."+sortfield+") ? 1 : ((b."+sortfield+" < a."+sortfield+") ? -1 : 0)); ");
			sortdir = "desc";
		}
	}
	else if(sorttype == "number"){
		if(sorttext.indexOf("↓") == -1 && sorttext.indexOf("↑") == -1){
			eval("arrayproclistlines = arrayproclistlines.sort((a, b) => parseFloat(a."+sortfield+".replace('m','000')) - parseFloat(b."+sortfield+".replace('m','000'))); ");
			sortdir = "asc";
		}
		else if(sorttext.indexOf("↓") != -1){
			eval("arrayproclistlines = arrayproclistlines.sort((a, b) => parseFloat(a."+sortfield+".replace('m','000')) - parseFloat(b."+sortfield+".replace('m','000'))); ");
			sortdir = "asc";
		}
		else{
			eval("arrayproclistlines = arrayproclistlines.sort((a, b) => parseFloat(b."+sortfield+".replace('m','000')) - parseFloat(a."+sortfield+".replace('m','000'))); ");
			sortdir = "desc";
		}
	}
	
	$j("#procTableContainer").empty();
	$j("#procTableContainer").append(BuildProcListTableHtml());
	stripedTable();
	
	$j(".sortable").each(function(index,element){
		if(element.innerHTML == sortname){
			if(sortdir == "asc"){
				element.innerHTML = sortname + " ↑";
			}
			else{
				element.innerHTML = sortname + " ↓";
			}
		}
	});
}

function ToggleRefresh(){
	$j("#auto_refresh").prop('checked', function(i, v) { if(v){get_proclist_file();} else{clearTimeout(tout);} });
}

function BuildServiceTable(srvname,srvdesc,srvnamevisible,loopindex){
	var serviceshtml = '';
	
	if(loopindex == 0){
		serviceshtml+='<div style="line-height:10px;">&nbsp;</div>';
		serviceshtml+='<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_services">';
		serviceshtml+='<thead class="collapsible-jquery" id="servicescontrol">';
		serviceshtml+='<tr><td colspan="2">Services (click to expand/collapse)</td></tr>';
		serviceshtml+='</thead>';
	}
	
	serviceshtml+='<tr>';
	if(srvnamevisible){
		serviceshtml+='<th width="20%">'+srvdesc+' <span style="color:#FFCC00;">('+srvname+')</span></th>';
	}
	else{
		serviceshtml+='<th width="20%">'+srvdesc+'</th>';
	}
	srvname = srvname.replace('/','');
	serviceshtml+='<td>';
	serviceshtml+='<input type="button" class="button_gen" onclick="RestartService(\''+srvname+'\');" value="Restart" id="btnRestartSrv_'+srvname+'">';
	serviceshtml+='<span id="txtRestartSrv_'+srvname+'" style="display:none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>';
	serviceshtml+='<span id="txtRestartSrvError_'+srvname+'" style="display:none;">Invalid - service not enabled</span>';
	serviceshtml+='<img id="imgRestartSrv_'+srvname+'" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>';
	serviceshtml+='&nbsp;&nbsp;&nbsp;';
	serviceshtml+='</td>';
	serviceshtml+='</tr>';
	
	if(loopindex == srvnamelist.length-1){
		serviceshtml+='</table>';
	}
	
	return serviceshtml;
}

function BuildVPNClientTable(loopindex){
	var vpnclientshtml = '';
	var vpnclientname = "vpnclient"+loopindex;
	var vpnclientdesc = eval("document.form.vpnc"+loopindex+"_desc").value;
	
	if(loopindex == 1){
		vpnclientshtml+='<div style="line-height:10px;">&nbsp;</div>';
		vpnclientshtml+='<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_vpnclients">';
		vpnclientshtml+='<thead class="collapsible-jquery" id="vpnclientscontrol">';
		vpnclientshtml+='<tr><td colspan="2">VPN Clients (click to expand/collapse)</td></tr>';
		vpnclientshtml+='</thead>';
	}
	
	vpnclientshtml+='<tr>';
	vpnclientshtml+='<th width="40%">VPN Client '+loopindex;
	vpnclientshtml+='<br /><span style="color:#FFCC00;">('+vpnclientdesc+')</span></th>';
	vpnclientshtml+='<td>';
	vpnclientshtml+='<input type="button" class="button_gen" onclick="RestartService(\''+vpnclientname+'\');" value="Restart" id="btnRestartSrv_'+vpnclientname+'">';
	vpnclientshtml+='<span id="txtRestartSrv_'+vpnclientname+'" style="display:none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>';
	vpnclientshtml+='<span id="txtRestartSrvError_'+vpnclientname+'" style="display:none;">Invalid - VPN Client not enabled</span>';
	vpnclientshtml+='<img id="imgRestartSrv_'+vpnclientname+'" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>';
	vpnclientshtml+='&nbsp;&nbsp;&nbsp;';
	vpnclientshtml+='</td>';
	vpnclientshtml+='</tr>';
	
	if(loopindex == 5){
		vpnclientshtml+='</table>';
	}
	
	return vpnclientshtml;
}

function BuildVPNServerTable(loopindex){
	var vpnservershtml = '';
	var vpnservername = "vpnserver"+loopindex;
	
	if(loopindex == 1){
		vpnservershtml+='<div style="line-height:10px;">&nbsp;</div>';
		vpnservershtml+='<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_vpnservers">';
		vpnservershtml+='<thead class="collapsible-jquery" id="vpnserverscontrol">';
		vpnservershtml+='<tr><td colspan="2">VPN Servers (click to expand/collapse)</td></tr>';
		vpnservershtml+='</thead>';
	}
	
	vpnservershtml+='<tr>';
	vpnservershtml+='<th width="40%">VPN Server '+loopindex+'</th>';
	vpnservershtml+='<td>';
	vpnservershtml+='<input type="button" class="button_gen" onclick="RestartService(\''+vpnservername+'\');" value="Restart" id="btnRestartSrv_'+vpnservername+'">';
	vpnservershtml+='<span id="txtRestartSrv_'+vpnservername+'" style="display:none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>';
	vpnservershtml+='<span id="txtRestartSrvError_'+vpnservername+'" style="display:none;">Invalid - VPN Server not enabled</span>';
	vpnservershtml+='<img id="imgRestartSrv_'+vpnservername+'" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>';
	vpnservershtml+='&nbsp;&nbsp;&nbsp;';
	vpnservershtml+='</td>';
	vpnservershtml+='</tr>';
	
	if(loopindex == 2){
		vpnservershtml+='</table>';
	}
	
	return vpnservershtml;
}

/* Taken from firmware WebUI, Tools_SysInfo.asp */
function update_sysinfo(e){
	$j.ajax({
		url: '/ajax_sysinfo.asp',
		dataType: 'script',
		error: function(xhr) {
		setTimeout("update_sysinfo();", 1000);
	},
		success: function(response){
			show_memcpu();
			Draw_Chart("MemoryUsage");
			Draw_Chart("SwapUsage");
			setTimeout("update_sysinfo();", 3000);
		}
	});
}

function show_memcpu(){
	document.getElementById("mem_total_td").innerHTML = mem_stats_arr[0] + " MB";
	document.getElementById("mem_free_td").innerHTML = mem_stats_arr[1] + " MB";
	document.getElementById("mem_buffer_td").innerHTML = mem_stats_arr[2] + " MB";
	document.getElementById("mem_cache_td").innerHTML = mem_stats_arr[3] + " MB";
	
	if(parseInt(mem_stats_arr[5]) == 0){
		document.getElementById("mem_swap_td").innerHTML = "<span>No swap configured</span>";
	}
	else{
		document.getElementById("mem_swap_td").innerHTML = mem_stats_arr[4] + " / " + mem_stats_arr[5] + " MB";
		document.getElementById("nvram_td").innerHTML = mem_stats_arr[6] + " / " + <% sysinfo("nvram.total"); %> + " bytes";
		document.getElementById("jffs_td").innerHTML = mem_stats_arr[7];
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
			code += "&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz-2:</b> <span>" + curr_coreTmp_52_raw + "</span>";
		}
		else if (band5g_support){
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
		setTimeout("update_temperatures();", 3000);
		}
	});
}
/* End firmware functions */

function round(value, decimals){
	return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}

Chart.defaults.global.defaultFontColor = "#CCC";
Chart.Tooltip.positioners.cursor = function(chartElements, coordinates){
	return coordinates;
};

function Draw_Chart(txtchartname){
	var chartData = [];
	var chartLabels = [];
	var chartColours = [];
	var chartTitle = "";
	
	if(txtchartname == "MemoryUsage"){
		chartData = [mem_stats_arr[0]*1-mem_stats_arr[1]*1-mem_stats_arr[2]*1-mem_stats_arr[3]*1,mem_stats_arr[1],mem_stats_arr[2],mem_stats_arr[3]];
		chartLabels = ["Used","Free","Buffers","Cache"];
		chartColours = ["#5eaec0","#12cf80","#ceca09","#9d12c4"];
		chartTitle = "Memory Usage";
	}
	else if(txtchartname == "SwapUsage"){
		chartData = [mem_stats_arr[4],mem_stats_arr[5]*1-mem_stats_arr[4]*1];
		chartLabels = ["Used","Free"];
		chartColours = ["#135fee","#1aa658"];
		chartTitle = "Swap Usage";
	}
	
	var objchartname = window["Chart" + txtchartname];
	
	if (objchartname != undefined) objchartname.destroy();
	var ctx = document.getElementById("canvasChart" + txtchartname).getContext("2d");
	var chartOptions = {
		segmentShowStroke: false,
		segmentStrokeColor: "#000",
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
			position: "left",
			labels: {
				fontColor: "#ffffff"
			}
		},
		title: {
			display: true,
			text: chartTitle,
			position: "top"
		},
		tooltips: {
			callbacks: {
				title: function(tooltipItem, data){
					return data.labels[tooltipItem[0].index];
				},
				label: function(tooltipItem, data){
					return round(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index],2).toFixed(2) + " MB";
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
			borderColor: "#000000"
		}]
	};
	objchartname = new Chart(ctx, {
		type: "pie",
		options: chartOptions,
		data: chartDataset
	});
	window["Chart" + txtchartname] = objchartname;
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
<table width="775px" border="0" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
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


<!-- Insert service control tables here -->


<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_entware">
<thead class="collapsible-jquery" id="entwarecontrol">
<tr><td colspan="2">Entware (click to expand/collapse)</td></tr>
</thead>
<tr>
<th width="40%">Entware applications</th>
<td>
<input type="button" class="button_gen" onclick="RestartService('entware');" value="Restart" id="btnRestartSrv_entware">
<span id="txtRestartSrv_entware" style="display:none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>
<span id="txtRestartSrvError_entware" style="display:none;">Invalid - Entware not running</span>
<img id="imgRestartSrv_entware" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>
&nbsp;&nbsp;&nbsp;
</td>
</tr>
</table>

<!-- Start Process List -->
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="scm_table_proclist">
<col style="width:40%;">
<col style="width:60%;">
<thead class="collapsible-jquery" id="proclist">
<tr><td colspan="2">Process List (click to expand/collapse)</td></tr>
</thead>
<tr class="even">
<th>Update automatically?</th>
<td>
<label style="color:#FFCC00;display:block;">
<input type="checkbox" checked="" id="auto_refresh" style="padding:0;margin:0;vertical-align:middle;position:relative;top:-1px;" />&nbsp;&nbsp;Table will refresh every 3s</label>
</td>
</tr>
<tr style="line-height:5px;"><td colspan="2">&nbsp;</td></tr>
<tr>
<td colspan="2" align="center" style="padding: 0px;">
<div id="procTableContainer" class="procTableContainer"></div>
</td>
</tr>
</table>
<!-- End Process List -->
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead class="collapsible-jquery" id="routermemory">
<tr>
<td colspan="4">Memory (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<th width="65px" style="width:65px;">Total</th>
<td id="mem_total_td" width="125px" style="width:125px;"></td>
<td id="ram_chart" rowspan="5" style="padding-left:4px;width:270px;" width="270px">
<div style="background-color:#2f3e44;border-radius:10px;width:270px;" id="divChartMemoryUsage">
<canvas id="canvasChartMemoryUsage" height="250" />
</div>
</td>
<td id="swap_chart" rowspan="5" style="padding-left:4px;width:270px;" width="270px">
<div style="background-color:#2f3e44;border-radius:10px;width:270px;" id="divChartSwapUsage">
<canvas id="canvasChartSwapUsage" height="250" />
</div>
</td>
</tr>
<tr>
<th width="65px" style="width:65px;">Free</th>
<td id="mem_free_td" width="125px" style="width:125px;"></td>
</tr>
<tr>
<th width="65px" style="width:65px;">Buffers</th>
<td id="mem_buffer_td" width="125px" style="width:125px;"></td>
</tr>
<tr>
<th width="65px" style="width:65px;">Cache</th>
<td id="mem_cache_td" width="125px" style="width:125px;"></td>
</tr>
<tr>
<th width="65px" style="width:65px;">Swap</th>
<td id="mem_swap_td" width="125px" style="width:125px;"></td>
</tr>
</table>
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead class="collapsible-jquery" id="routerstorage">
<tr>
<td colspan="2">Internal Storage (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<th>NVRAM usage</th>
<td id="nvram_td"></td>
</tr>
<tr>
<th>JFFS</th>
<td id="jffs_td"></td>
</tr>
</table>
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead class="collapsible-jquery" id="routertemps">
<tr>
<td colspan="2">Router (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<th>Temperatures</th>
<td id="temp_td"></td>
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

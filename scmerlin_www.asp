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

div.procTableContainer {
  height: 500px;
  overflow-y: scroll;
  width: 745px;
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

tbody.procTableContent td{
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

tbody.procTableContent tr.procRow:nth-child(odd) td {
  background-color: #2F3A3E !important;
}

tbody.procTableContent tr.procRow:nth-child(even) td {
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
	for (var prop in custom_settings) {
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
	
	if(parseInt(mem_stats_arr[5]) == 0){
		document.getElementById("mem_swap_td").innerHTML = "<span>No swap configured</span>";
	}
	else{
		document.getElementById("mem_swap_td").innerHTML = mem_stats_arr[4] + " / " + mem_stats_arr[5] + " MB";
		document.getElementById("nvram_td").innerHTML = round(mem_stats_arr[6]/1024,2).toFixed(2) + " / " + nvramtotal + " KB";
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
			if(typeof curr_coreTmp_52_raw == 'undefined' || curr_coreTmp_52_raw == null){
				curr_coreTmp_52_raw = "N/A"
			}
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
		setTimeout(update_temperatures, 3000);
		}
	});
}
/* End firmware functions */

var nvramtotal = <% sysinfo("nvram.total"); %> / 1024;
var tout,arrayproclistlines=[],originalarrayproclistlines=[],sortfield="CPU%",sortname="CPU%",sortdir="desc";Chart.defaults.global.defaultFontColor="#CCC",Chart.Tooltip.positioners.cursor=function(a,b){return b};var $j=jQuery.noConflict();function SetCurrentPage(){document.form.next_page.value=window.location.pathname.substring(1),document.form.current_page.value=window.location.pathname.substring(1)}var srvnamelist=["dnsmasq","wan","httpd","wireless","vsftpd","samba","ddns","ntpd/chronyd"],srvdesclist=["DNS/DHCP Server","Internet Connection","Web Interface","WiFi","FTP Server","Samba","DDNS client","Timeserver"],srvnamevisiblelist=[!0,!1,!0,!1,!0,!1,!1,!0];function initial(){SetCurrentPage(),LoadCustomSettings(),show_menu();var a="";for(i=1;3>i;i++)a+=BuildVPNServerTable(i);$j("#table_config").after(a);var b="";for(i=1;6>i;i++)b+=BuildVPNClientTable(i);$j("#table_config").after(b);var c="";for(i=0;i<srvnamelist.length;i++)c+=BuildServiceTable(srvnamelist[i],srvdesclist[i],srvnamevisiblelist[i],i);$j("#table_config").after(c),get_usbdisabled_file(),update_temperatures(),update_sysinfo(),ScriptUpdateLayout(),AddEventHandlers()}function ScriptUpdateLayout(){var a=GetVersionNumber("local"),b=GetVersionNumber("server");$j("#scripttitle").text($j("#scripttitle").text()+" - "+a),$j("#scmerlin_version_local").text(a),a!=b&&"N/A"!=b&&($j("#scmerlin_version_server").text("Updated version available: "+b),showhide("btnChkUpdate",!1),showhide("scmerlin_version_server",!0),showhide("btnDoUpdate",!0))}function reload(){location.reload(!0)}function update_status(){$j.ajax({url:"/ext/scmerlin/detect_update.js",dataType:"script",timeout:3e3,error:function(){setTimeout(update_status,1e3)},success:function(){"InProgress"==updatestatus?setTimeout(update_status,1e3):(document.getElementById("imgChkUpdate").style.display="none",showhide("scmerlin_version_server",!0),"None"==updatestatus?($j("#scmerlin_version_server").text("No update available"),showhide("btnChkUpdate",!0),showhide("btnDoUpdate",!1)):($j("#scmerlin_version_server").text("Updated version available: "+updatestatus),showhide("btnChkUpdate",!1),showhide("btnDoUpdate",!0)))}})}function CheckUpdate(){showhide("btnChkUpdate",!1),document.formScriptActions.action_script.value="start_scmerlincheckupdate",document.formScriptActions.submit(),document.getElementById("imgChkUpdate").style.display="",setTimeout(update_status,2e3)}function DoUpdate(){document.form.action_script.value="start_scmerlindoupdate";document.form.action_wait.value=10,showLoading(),document.form.submit()}function RestartService(a){showhide("btnRestartSrv_"+a,!1),showhide("txtRestartSrv_"+a,!1),document.formScriptActions.action_script.value="start_scmerlinservicerestart"+a,document.formScriptActions.submit(),document.getElementById("imgRestartSrv_"+a).style.display="",setTimeout(service_status,1e3,a)}function service_status(a){$j.ajax({url:"/ext/scmerlin/detect_service.js",dataType:"script",timeout:3e3,error:function(){setTimeout(service_status,1e3,a)},success:function(){"InProgress"==servicestatus?setTimeout(service_status,1e3,a):(document.getElementById("imgRestartSrv_"+a).style.display="none","Done"==servicestatus?(showhide("btnRestartSrv_"+a,!0),showhide("txtRestartSrv_"+a,!0),setTimeout(showhide,3e3,"txtRestartSrv_"+a,!1)):showhide("txtRestartSrvError_"+a,!0))}})}function GetVersionNumber(a){var b;return"local"==a?b=custom_settings.scmerlin_version_local:"server"==a&&(b=custom_settings.scmerlin_version_server),"undefined"==typeof b||null==b?"N/A":b}function BuildProcListTableHtml(){var a="<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" class=\"procTable\" style=\"table-layout:fixed;\">";a+="<col style=\"width:50px;\">",a+="<col style=\"width:50px;\">",a+="<col style=\"width:75px;\">",a+="<col style=\"width:50px;\">",a+="<col style=\"width:50px;\">",a+="<col style=\"width:55px;\">",a+="<col style=\"width:50px;\">",a+="<col style=\"width:55px;\">",a+="<col style=\"width:740px;\">",a+="<thead class=\"procTableHeader\">",a+="<tr>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">PID</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">PPID</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">USER</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">STAT</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">VSZ</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">VSZ%</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">CPU</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">CPU%</th>",a+="<th class=\"sortable\" onclick=\"SortTable(this.innerHTML)\">COMMAND</th>",a+="</tr>",a+="</thead>",a+="<tbody class=\"procTableContent\">";for(var b=0;b<arrayproclistlines.length;b++)a+="<tr>",a+="<td>"+arrayproclistlines[b].PID+"</td>",a+="<td>"+arrayproclistlines[b].PPID+"</td>",a+="<td>"+arrayproclistlines[b].USER+"</td>",a+="<td>"+arrayproclistlines[b].STAT+"</td>",a+="<td>"+arrayproclistlines[b].VSZ+"</td>",a+="<td>"+arrayproclistlines[b].VSZP+"</td>",a+="<td>"+arrayproclistlines[b].CPU+"</td>",a+="<td>"+arrayproclistlines[b].CPUP+"</td>",a+="<td>"+arrayproclistlines[b].COMMAND+"</td>",a+="</tr>";return a+="</tbody>",a+="</table>",a}function get_usbdisabled_file(){$j.ajax({url:"/ext/scmerlin/usbdisabled.htm",dataType:"text",timeout:1e4,error:function(){document.form.scmerlin_usbenabled.value="enable",get_proclist_file()},success:function(){document.form.scmerlin_usbenabled.value="disable",document.getElementById("procTableContainer").innerHTML="Process list disabled, this feature requires the \"USB features\" option to be enabled and a USB device plugged into router for Entware"}})}function get_proclist_file(){$j.ajax({url:"/ext/scmerlin/top.htm",dataType:"text",error:function(){tout=setTimeout(get_proclist_file,1e3)},success:function(a){ParseProcList(a),document.getElementById("auto_refresh").checked&&(tout=setTimeout(get_proclist_file,3e3))}})}function ParseProcList(a){var b=a.split("\n");b=b.filter(Boolean),arrayproclistlines=[];for(var c=0;c<b.length;c++)try{var d=b[c].split(","),e={};e.PID=d[0].trim(),e.PPID=d[1].trim(),e.USER=d[2].trim(),e.STAT=d[3].trim(),e.VSZ=d[4].trim(),e.VSZP=d[5].trim(),e.CPU=d[6].trim(),e.CPUP=d[7].trim(),e.COMMAND=d[8].trim(),arrayproclistlines.push(e)}catch{}originalarrayproclistlines=arrayproclistlines,SortTable(sortname+" "+sortdir.replace("desc","\u2191").replace("asc","\u2193").trim())}function GetCookie(a,b){var c;if(null!=(c=cookie.get("scm_"+a)))return cookie.get("scm_"+a);return"string"==b?"":"number"==b?0:void 0}function SetCookie(a,b){cookie.set("scm_"+a,b,31)}function AddEventHandlers(){$j(".collapsible-jquery").click(function(){$j(this).siblings().toggle("fast",function(){"none"==$j(this).css("display")?SetCookie($j(this).siblings()[0].id,"collapsed"):(SetCookie($j(this).siblings()[0].id,"expanded"),"routermemory"==$j(this).siblings()[0].id?(Draw_Chart("MemoryUsage"),0==parseInt(mem_stats_arr[5])?Draw_Chart_NoData("SwapUsage"):Draw_Chart("SwapUsage")):"routerstorage"==$j(this).siblings()[0].id&&(Draw_Chart("nvramUsage"),Draw_Chart("jffsUsage")))})}),$j(".collapsible-jquery").each(function(){"collapsed"==GetCookie($j(this)[0].id,"string")?$j(this).siblings().toggle(!1):$j(this).siblings().toggle(!0)}),$j("#auto_refresh")[0].addEventListener("click",function(){ToggleRefresh()})}function stripedTable(){if(document.getElementById&&document.getElementsByTagName){var a=document.getElementsByClassName("procTable");if(!a)return;for(var b,c=0;c<a.length;c++){b=a[c].getElementsByTagName("tr");for(var d=0;d<b.length;d++)$j(b[d]).removeClass("procAlternateRow"),$j(b[d]).addClass("procNormalRow");for(var e=0;e<b.length;e+=2)$j(b[e]).removeClass("procNormalRow"),$j(b[e]).addClass("procAlternateRow")}}}function SortTable(sorttext){sortname=sorttext.replace("\u2191","").replace("\u2193","").trim();var sorttype="number";sortfield=sortname;"VSZ%"===sortname?sortfield="VSZP":"CPU%"===sortname?sortfield="CPUP":"USER"===sortname?sorttype="string":"STAT"===sortname?sorttype="string":"COMMAND"===sortname?sorttype="string":void 0;"string"==sorttype?-1==sorttext.indexOf("\u2193")&&-1==sorttext.indexOf("\u2191")?(eval("arrayproclistlines = arrayproclistlines.sort((a,b) => (a."+sortfield+" > b."+sortfield+") ? 1 : ((b."+sortfield+" > a."+sortfield+") ? -1 : 0)); "),sortdir="asc"):-1==sorttext.indexOf("\u2193")?(eval("arrayproclistlines = arrayproclistlines.sort((a,b) => (a."+sortfield+" < b."+sortfield+") ? 1 : ((b."+sortfield+" < a."+sortfield+") ? -1 : 0)); "),sortdir="desc"):(eval("arrayproclistlines = arrayproclistlines.sort((a,b) => (a."+sortfield+" > b."+sortfield+") ? 1 : ((b."+sortfield+" > a."+sortfield+") ? -1 : 0)); "),sortdir="asc"):"number"==sorttype&&(-1==sorttext.indexOf("\u2193")&&-1==sorttext.indexOf("\u2191")?(eval("arrayproclistlines = arrayproclistlines.sort((a, b) => parseFloat(a."+sortfield+".replace('m','000')) - parseFloat(b."+sortfield+".replace('m','000'))); "),sortdir="asc"):-1==sorttext.indexOf("\u2193")?(eval("arrayproclistlines = arrayproclistlines.sort((a, b) => parseFloat(b."+sortfield+".replace('m','000')) - parseFloat(a."+sortfield+".replace('m','000'))); "),sortdir="desc"):(eval("arrayproclistlines = arrayproclistlines.sort((a, b) => parseFloat(a."+sortfield+".replace('m','000')) - parseFloat(b."+sortfield+".replace('m','000'))); "),sortdir="asc")),$j("#procTableContainer").empty(),$j("#procTableContainer").append(BuildProcListTableHtml()),stripedTable(),$j(".sortable").each(function(a,b){b.innerHTML==sortname&&("asc"==sortdir?b.innerHTML=sortname+" \u2191":b.innerHTML=sortname+" \u2193")})}function ToggleRefresh(){$j("#auto_refresh").prop("checked",function(a,b){b?get_proclist_file():clearTimeout(tout)})}function BuildServiceTable(a,b,c,d){var e="";return 0==d&&(e+="<div style=\"line-height:10px;\">&nbsp;</div>",e+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable\" style=\"border:0px;\" id=\"table_services\">",e+="<thead class=\"collapsible-jquery\" id=\"servicescontrol\">",e+="<tr><td colspan=\"2\">Services (click to expand/collapse)</td></tr>",e+="</thead>"),e+="<tr>",e+=c?"<th width=\"20%\">"+b+" <span style=\"color:#FFCC00;\">("+a+")</span></th>":"<th width=\"20%\">"+b+"</th>",a=a.replace("/",""),e+="<td>",e+="<input type=\"button\" class=\"button_gen\" onclick=\"RestartService('"+a+"');\" value=\"Restart\" id=\"btnRestartSrv_"+a+"\">",e+="<span id=\"txtRestartSrv_"+a+"\" style=\"display:none;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>",e+="<span id=\"txtRestartSrvError_"+a+"\" style=\"display:none;\">Invalid - service not enabled</span>",e+="<img id=\"imgRestartSrv_"+a+"\" style=\"display:none;vertical-align:middle;\" src=\"images/InternetScan.gif\"/>",e+="&nbsp;&nbsp;&nbsp;",e+="</td>",e+="</tr>",d==srvnamelist.length-1&&(e+="</table>"),e}function BuildVPNClientTable(loopindex){var vpnclientshtml="",vpnclientname="vpnclient"+loopindex,vpnclientdesc=eval("document.form.vpnc"+loopindex+"_desc").value;return 1==loopindex&&(vpnclientshtml+="<div style=\"line-height:10px;\">&nbsp;</div>",vpnclientshtml+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable\" style=\"border:0px;\" id=\"table_vpnclients\">",vpnclientshtml+="<thead class=\"collapsible-jquery\" id=\"vpnclientscontrol\">",vpnclientshtml+="<tr><td colspan=\"2\">VPN Clients (click to expand/collapse)</td></tr>",vpnclientshtml+="</thead>"),vpnclientshtml+="<tr>",vpnclientshtml+="<th width=\"40%\">VPN Client "+loopindex,vpnclientshtml+="<br /><span style=\"color:#FFCC00;\">("+vpnclientdesc+")</span></th>",vpnclientshtml+="<td>",vpnclientshtml+="<input type=\"button\" class=\"button_gen\" onclick=\"RestartService('"+vpnclientname+"');\" value=\"Restart\" id=\"btnRestartSrv_"+vpnclientname+"\">",vpnclientshtml+="<span id=\"txtRestartSrv_"+vpnclientname+"\" style=\"display:none;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>",vpnclientshtml+="<span id=\"txtRestartSrvError_"+vpnclientname+"\" style=\"display:none;\">Invalid - VPN Client not enabled</span>",vpnclientshtml+="<img id=\"imgRestartSrv_"+vpnclientname+"\" style=\"display:none;vertical-align:middle;\" src=\"images/InternetScan.gif\"/>",vpnclientshtml+="&nbsp;&nbsp;&nbsp;",vpnclientshtml+="</td>",vpnclientshtml+="</tr>",5==loopindex&&(vpnclientshtml+="</table>"),vpnclientshtml}function BuildVPNServerTable(a){var b="",c="vpnserver"+a;return 1==a&&(b+="<div style=\"line-height:10px;\">&nbsp;</div>",b+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable\" style=\"border:0px;\" id=\"table_vpnservers\">",b+="<thead class=\"collapsible-jquery\" id=\"vpnserverscontrol\">",b+="<tr><td colspan=\"2\">VPN Servers (click to expand/collapse)</td></tr>",b+="</thead>"),b+="<tr>",b+="<th width=\"40%\">VPN Server "+a+"</th>",b+="<td>",b+="<input type=\"button\" class=\"button_gen\" onclick=\"RestartService('"+c+"');\" value=\"Restart\" id=\"btnRestartSrv_"+c+"\">",b+="<span id=\"txtRestartSrv_"+c+"\" style=\"display:none;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Done</span>",b+="<span id=\"txtRestartSrvError_"+c+"\" style=\"display:none;\">Invalid - VPN Server not enabled</span>",b+="<img id=\"imgRestartSrv_"+c+"\" style=\"display:none;vertical-align:middle;\" src=\"images/InternetScan.gif\"/>",b+="&nbsp;&nbsp;&nbsp;",b+="</td>",b+="</tr>",2==a&&(b+="</table>"),b}function round(a,b){return+(Math.round(a+"e"+b)+"e-"+b)}function Draw_Chart_NoData(a){document.getElementById("canvasChart"+a).width="270",document.getElementById("canvasChart"+a).height="250",document.getElementById("canvasChart"+a).style.width="270px",document.getElementById("canvasChart"+a).style.height="250px";var b=document.getElementById("canvasChart"+a).getContext("2d");b.save(),b.textAlign="center",b.textBaseline="middle",b.font="normal normal bolder 22px Arial",b.fillStyle="white",b.fillText("No swap file configured",135,125),b.restore()}function Draw_Chart(a){var b=[],c=[],d=[],e="",f="";if("MemoryUsage"==a)b=[1*mem_stats_arr[0]-1*mem_stats_arr[1]-1*mem_stats_arr[2]-1*mem_stats_arr[3],mem_stats_arr[1],mem_stats_arr[2],mem_stats_arr[3]],c=["Used","Free","Buffers","Cache"],d=["#5eaec0","#12cf80","#ceca09","#9d12c4"],e="Memory Usage",f="MB";else if("SwapUsage"==a)b=[mem_stats_arr[4],1*mem_stats_arr[5]-1*mem_stats_arr[4]],c=["Used","Free"],d=["#135fee","#1aa658"],e="Swap Usage",f="MB";else if("nvramUsage"==a)b=[round(mem_stats_arr[6]/1024,2).toFixed(2),round(1*nvramtotal-1*mem_stats_arr[6]/1024,2).toFixed(2)],c=["Used","Free"],d=["#5eaec0","#12cf80"],e="NVRAM Usage",f="KB";else if("jffsUsage"==a){var g=mem_stats_arr[7].split(" ");b=[1*g[0],1*g[2]-1*g[0]],c=["Used","Free"],d=["#135fee","#1aa658"],e="JFFS Usage",f="MB"}var h=window["Chart"+a];h!=null&&h.destroy();var j=document.getElementById("canvasChart"+a).getContext("2d"),k={segmentShowStroke:!1,segmentStrokeColor:"#000",maintainAspectRatio:!1,animation:{duration:0},hover:{animationDuration:0},responsiveAnimationDuration:0,legend:{onClick:null,display:!0,position:"left",labels:{fontColor:"#ffffff"}},title:{display:!0,text:e,position:"top"},tooltips:{callbacks:{title:function(a,b){return b.labels[a[0].index]},label:function(a,b){return round(b.datasets[a.datasetIndex].data[a.index],2).toFixed(2)+" "+f}},mode:"point",position:"cursor",intersect:!0},scales:{xAxes:[{display:!1,gridLines:{display:!1},scaleLabel:{display:!1},ticks:{display:!1}}],yAxes:[{display:!1,gridLines:{display:!1},scaleLabel:{display:!1},ticks:{display:!1}}]}},l={labels:c,datasets:[{data:b,borderWidth:1,backgroundColor:d,borderColor:"#000000"}]};h=new Chart(j,{type:"pie",options:k,data:l}),window["Chart"+a]=h}function SaveConfig(){var a="start_scmerlinconfig"+document.form.scmerlin_usbenabled.value;document.form.action_script.value=a;document.form.action_wait.value=10,showLoading(),document.form.submit()}
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

<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_config">
<thead class="collapsible-jquery" id="scriptconfig">
<tr><td colspan="2">Configuration (click to expand/collapse)</td></tr>
</thead>
<tr class="even" id="rowenableusb">
<th width="40%">Enable USB Features<br/><span style="color:#FFCC00;">(running processes in WebUI)</span></th>
<td class="settingvalue">
<input type="radio" name="scmerlin_usbenabled" id="scmerlin_usbenabled_enabled" class="input" value="enable" checked>
<label for="scmerlin_usbenabled_enabled" class="settingvalue">Yes</label>
<input type="radio" name="scmerlin_usbenabled" id="scmerlin_usbenabled_disabled" class="input" value="disable">
<label for="scmerlin_usbenabled_disabled" class="settingvalue">No</label>
</td>
</tr>
<tr class="apply_gen" valign="top" height="35px">
<td colspan="2" style="background-color:rgb(77, 89, 93);">
<input type="button" onclick="SaveConfig();" value="Save" class="button_gen" name="button">
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
<td colspan="4">Internal Storage (click to expand/collapse)</td>
</tr>
</thead>
<tr>
<th width="65px" style="width:65px;">NVRAM</th>
<td id="nvram_td"></td>
<td id="nvram_chart" rowspan="2" style="padding-left:4px;width:270px;" width="270px">
<div style="background-color:#2f3e44;border-radius:10px;width:270px;" id="divChartnvramUsage">
<canvas id="canvasChartnvramUsage" height="250" />
</div>
</td>
<td id="jffs_chart" rowspan="2" style="padding-left:4px;width:270px;" width="270px">
<div style="background-color:#2f3e44;border-radius:10px;width:270px;" id="divChartjffsUsage">
<canvas id="canvasChartjffsUsage" height="250" />
</div>
</td>
</tr>
<tr>
<th width="65px" style="width:65px;">JFFS</th>
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

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
p{font-weight:bolder}thead.collapsible-jquery{color:#fff;padding:0;width:100%;border:none;text-align:left;outline:none;cursor:pointer}.SettingsTable{text-align:left}.SettingsTable input{text-align:left;margin-left:3px!important}.SettingsTable input.savebutton{text-align:center;margin-top:5px;margin-bottom:5px;border-right:solid 1px #000;border-left:solid 1px #000;border-bottom:solid 1px #000}.SettingsTable td.savebutton{border-right:solid 1px #000;border-left:solid 1px #000;border-bottom:solid 1px #000;background-color:#4d595d}.SettingsTable .cronbutton{text-align:center;min-width:50px;width:50px;height:23px;vertical-align:middle}.SettingsTable select{margin-left:3px!important}.SettingsTable label{margin-right:10px!important;vertical-align:top!important}.SettingsTable th{background-color:#1F2D35!important;background:#2F3A3E!important;border-bottom:none!important;border-top:none!important;font-size:12px!important;color:#fff!important;padding:4px!important;font-weight:bolder!important;padding:0!important}.SettingsTable td{word-wrap:break-word!important;overflow-wrap:break-word!important;border-right:none;border-left:none}.SettingsTable span.settingname{background-color:#1F2D35!important;background:#2F3A3E!important}.SettingsTable td.settingname{border-right:solid 1px #000;border-left:solid 1px #000;background-color:#1F2D35!important;background:#2F3A3E!important;width:35%!important}.SettingsTable td.settingvalue{text-align:left!important;border-right:solid 1px #000}.SettingsTable td.servicename{border-right:solid 1px #000;border-left:solid 1px #000;background-color:#1F2D35!important;background:#2F3A3E!important;width:30%!important}.SettingsTable td.servicevalue{text-align:center!important;border-right:solid 1px #000;width:20%!important;padding-left:4px!important}.SettingsTable span.servicespan{font-size:10px!important}.SettingsTable th:first-child{border-left:none!important}.SettingsTable th:last-child{border-right:none!important}.SettingsTable .invalid{background-color:#8b0000!important}.SettingsTable .disabled{background-color:#CCC!important;color:#888!important}div.sortTableContainer{height:500px;overflow-y:scroll;width:745px;border:1px solid #000}.sortTable{table-layout:fixed!important;border:none}thead.sortTableHeader th{background-image:linear-gradient(#92a0a5 0%,#66757c 100%);border-top:none!important;border-left:none!important;border-right:none!important;border-bottom:1px solid #000!important;font-weight:bolder;padding:2px;text-align:center;color:#fff;position:sticky;top:0}thead.sortTableHeader th:first-child,thead.sortTableHeader th:last-child{border-right:none!important}thead.sortTableHeader th:last-child{text-align:left!important;padding-left:4px!important}thead.sortTableHeader th:first-child,thead.sortTableHeader td:first-child{border-left:none!important}tbody.sortTableContent td:last-child,tbody.sortTableContent tr.sortNormalRow td:last-child,tbody.sortTableContent tr.sortAlternateRow td:last-child{text-align:left!important;padding-left:4px!important}tbody.sortTableContent td{border-bottom:1px solid #000!important;border-left:none!important;border-right:1px solid #000!important;border-top:none!important;padding:2px;text-align:center;overflow:hidden!important;white-space:nowrap!important;font-size:12px!important}tbody.sortTableContent tr.sortRow:nth-child(odd) td{background-color:#2F3A3E!important}tbody.sortTableContent tr.sortRow:nth-child(even) td{background-color:#475A5F!important}th.sortable{cursor:pointer}td.metricname{background-color:#1F2D35!important;background:#2F3A3E!important;width:50px!important}.restartbutton{text-align:center!important;min-width:75px;width:75px;vertical-align:middle}td.addonpageurl:nth-child(even){border:1px solid #000!important;text-align:center!important;background-color:#475A5F!important}td.addonpageurl:nth-child(odd){border:1px solid #000!important;text-align:center!important;background-color:#1F2D35!important;background:#2F3A3E!important}td.addonpageurl:nth-child(even) span{background-color:#475A5F!important}td.addonpageurl:nth-child(odd) span{background-color:#1F2D35!important;background:#2F3A3E!important}td.addonpageurl a{font-weight:bolder!important;text-decoration:underline!important}span.addonpageurl{color:#FC0;font-size:10px!important}.nodata{height:65px!important;border:none!important;text-align:center!important;font:bolder 48px Arial!important}
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
			if(prop.indexOf('scmerlin') != -1 && prop.indexOf('scmerlin_version') == -1){
				eval('delete custom_settings.'+prop)
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
			Draw_Chart('MemoryUsage');
			if(parseInt(mem_stats_arr[5]) != 0){
				Draw_Chart('SwapUsage');
			}
			else{
				Draw_Chart_NoData('SwapUsage','No swap file configured');
			}
			Draw_Chart('nvramUsage');
			Draw_Chart('jffsUsage');
			setTimeout(update_sysinfo, 3000);
		}
	});
}

function show_memcpu(){
	document.getElementById('mem_total_td').innerHTML = mem_stats_arr[0] + ' MB';
	document.getElementById('mem_free_td').innerHTML = mem_stats_arr[1] + ' MB';
	document.getElementById('mem_buffer_td').innerHTML = mem_stats_arr[2] + ' MB';
	document.getElementById('mem_cache_td').innerHTML = mem_stats_arr[3] + ' MB';
	document.getElementById('nvram_td').innerHTML = round(mem_stats_arr[6]/1024,2).toFixed(2) + ' / ' + nvramtotal + ' KB';
	document.getElementById('jffs_td').innerHTML = mem_stats_arr[7];
	
	if(parseInt(mem_stats_arr[5]) == 0){
		document.getElementById('mem_swap_td').innerHTML = '<span>No swap configured</span>';
	}
	else{
		document.getElementById('mem_swap_td').innerHTML = mem_stats_arr[4] + ' / ' + mem_stats_arr[5] + ' MB';
	}
}

/**-------------------------------------**/
/** Added by Martinski W. [2023-Jun-02] **/
/**-------------------------------------**/
let band_5GHz_1_supported=false,
    band_5GHz_2_supported=false,
    band_6GHz_1_supported=false;

if (typeof wl_info == 'undefined' || wl_info == null)
{
    band_5GHz_1_supported = band5g_support;
    band_5GHz_2_supported = band5g2_support;
    band_6GHz_1_supported = band6g_support;
}
else
{
    band_5GHz_1_supported = wl_info.band5g_support;
    band_5GHz_2_supported = wl_info.band5g_2_support;
    band_6GHz_1_supported = wl_info.band6g_support;
}

/**----------------------------------------------**/
/** Added/Modified by Martinski W. [2023-Jul-05] **/
/**----------------------------------------------**/
function GetTemperatureValue (bandIDstr)
{
    let temperatureVal="[N/A]";

    switch (bandIDstr)
    {
        case '2.4GHz':
            if (productid == 'GT-AXE16000')
            {
                if (typeof curr_coreTmp_wl3_raw != 'undefined' && curr_coreTmp_wl3_raw != null)
                { temperatureVal = curr_coreTmp_wl3_raw; }
                else if (typeof curr_coreTmp_3_raw != 'undefined' && curr_coreTmp_3_raw != null)
                { temperatureVal = curr_coreTmp_3_raw; }
            }
            else if (typeof curr_coreTmp_wl0_raw != 'undefined' && curr_coreTmp_wl0_raw != null)
            { temperatureVal = curr_coreTmp_wl0_raw; }
            else if (typeof curr_coreTmp_0_raw != 'undefined' && curr_coreTmp_0_raw != null)
            { temperatureVal = curr_coreTmp_0_raw; }
            else if (typeof curr_coreTmp_2_raw != 'undefined' && curr_coreTmp_2_raw != null)
            { temperatureVal = curr_coreTmp_2_raw; }
            break;

        case '5GHz_1':
            if (productid == 'GT-AXE16000')
            {
                if (typeof curr_coreTmp_wl0_raw != 'undefined' && curr_coreTmp_wl0_raw != null)
                { temperatureVal = curr_coreTmp_wl0_raw; }
                else if (typeof curr_coreTmp_0_raw != 'undefined' && curr_coreTmp_0_raw != null)
                { temperatureVal = curr_coreTmp_0_raw; }
            }
            else if (typeof curr_coreTmp_wl1_raw != 'undefined' && curr_coreTmp_wl1_raw != null)
            { temperatureVal = curr_coreTmp_wl1_raw; }
            else if (typeof curr_coreTmp_1_raw != 'undefined' && curr_coreTmp_1_raw != null)
            { temperatureVal = curr_coreTmp_1_raw; }
            else if (typeof curr_coreTmp_5_raw != 'undefined' && curr_coreTmp_5_raw != null)
            { temperatureVal = curr_coreTmp_5_raw; }
            break;

        case '5GHz_2':
            if (productid == 'GT-AXE16000')
            {
                if (typeof curr_coreTmp_wl1_raw != 'undefined' && curr_coreTmp_wl1_raw != null)
                { temperatureVal = curr_coreTmp_wl1_raw; }
                else if (typeof curr_coreTmp_1_raw != 'undefined' && curr_coreTmp_1_raw != null)
                { temperatureVal = curr_coreTmp_1_raw; }
            }
            else if (typeof curr_coreTmp_wl2_raw != 'undefined' && curr_coreTmp_wl2_raw != null)
            { temperatureVal = curr_coreTmp_wl2_raw; }
            else if (typeof curr_coreTmp_0_raw != 'undefined' && curr_coreTmp_0_raw != null &&
                     typeof curr_coreTmp_2_raw != 'undefined' && curr_coreTmp_2_raw != null)
            { temperatureVal = curr_coreTmp_2_raw; }
            else if (typeof curr_coreTmp_52_raw != 'undefined' && curr_coreTmp_52_raw != null)
            { temperatureVal = curr_coreTmp_52_raw; }
            break;

        case '6GHz_1':
            if (typeof curr_coreTmp_wl2_raw != 'undefined' && curr_coreTmp_wl2_raw != null)
            { temperatureVal = curr_coreTmp_wl2_raw; }
            else if (typeof curr_coreTmp_0_raw != 'undefined' && curr_coreTmp_0_raw != null &&
                     typeof curr_coreTmp_2_raw != 'undefined' && curr_coreTmp_2_raw != null)
            { temperatureVal = curr_coreTmp_2_raw; }
            else if (typeof curr_coreTmp_52_raw != 'undefined' && curr_coreTmp_52_raw != null)
            { temperatureVal = curr_coreTmp_52_raw; }
            break;
    }
    return (temperatureVal);
}

/**----------------------------------------**/
/** Modified by Martinski W. [2023-Jun-05] **/
/**----------------------------------------**/
function update_temperatures(){
	$j.ajax({
		url: '/ajax_coretmp.asp',
		dataType: 'script',
		error: function(xhr){
		update_temperatures();
	},
	success: function(response)
	{
		code = '<b>2.4 GHz: </b><span>' + GetTemperatureValue ('2.4GHz') + '</span>';

		if (band_5GHz_2_supported)
		{
			code += '&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz-1: </b><span>' + GetTemperatureValue ('5GHz_1') + '</span>';
			code += '&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz-2: </b><span>' + GetTemperatureValue ('5GHz_2') + '</span>';
		}
		else if (band_5GHz_1_supported)
		{
			code += '&nbsp;&nbsp;-&nbsp;&nbsp;<b>5 GHz: </b><span>' + GetTemperatureValue ('5GHz_1') + '</span>';
		}
		if (band_6GHz_1_supported)
		{
			code += '&nbsp;&nbsp;-&nbsp;&nbsp;<b>6 GHz: </b><span>' + GetTemperatureValue ('6GHz_1') + '</span>';
		}

		var CPUTemp = '';
		if (typeof curr_cpuTemp == 'undefined' || curr_cpuTemp == null)
		{ CPUTemp = curr_coreTmp_cpu; }
		else
		{ CPUTemp = curr_cpuTemp; }
		
		if(CPUTemp != ''){
			code +='&nbsp;&nbsp;-&nbsp;&nbsp;<b>CPU: </b><span>' + parseInt(CPUTemp) +'&deg;C</span>';
		}
		document.getElementById('temp_td').innerHTML = code;
		setTimeout(update_temperatures, 3000);
		}
	});
}
var nvramtotal = <% sysinfo("nvram.total"); %> / 1024;
/* End firmware functions */
var tout,arrayproclistlines=[],sortnameproc="CPU%",sortdirproc="desc",arraycronjobs=[],sortnamecron="Name",sortdircron="asc";Chart.defaults.global.defaultFontColor="#CCC",Chart.Tooltip.positioners.cursor=function(a,b){return b};var $j=jQuery.noConflict();function SetCurrentPage(){document.form.next_page.value=window.location.pathname.substring(1),document.form.current_page.value=window.location.pathname.substring(1)}var srvnamelist=["dnsmasq","wan","httpd","wireless","vsftpd","samba","ddns","ntpd/chronyd"],srvdesclist=["DNS/DHCP Server","Internet Connection","Web Interface","WiFi","FTP Server","Samba","DDNS client","Timeserver"],srvnamevisiblelist=[!0,!1,!0,!1,!0,!1,!1,!0],sortedAddonPages=[];function initial(){SetCurrentPage(),LoadCustomSettings(),show_menu(),Draw_Chart_NoData("nvramUsage","Data loading..."),Draw_Chart_NoData("jffsUsage","Data loading..."),Draw_Chart_NoData("MemoryUsage","Data loading..."),Draw_Chart_NoData("SwapUsage","No swap file configured"),$j("#sortTableCron").empty(),$j("#sortTableCron").append(BuildSortTableHtmlNoData()),$j("#sortTableProcesses").empty(),$j("#sortTableProcesses").append(BuildSortTableHtmlNoData());for(var a="",b=1;3>b;b++)a+=BuildVPNServerTable(b);$j("#table_config").after(a);for(var c="",b=1;6>b;b++)c+=BuildVPNClientTable(b);$j("#table_config").after(c);for(var d="",b=0;b<srvnamelist.length;b++)d+=BuildServiceTable(srvnamelist[b],srvdesclist[b],srvnamevisiblelist[b],b);$j("#table_config").after(d),document.formScriptActions.action_script.value="start_scmerlingetaddonpages;start_scmerlingetcronjobs",document.formScriptActions.submit(),setTimeout(load_addonpages,5e3),setTimeout(get_cronlist_file,5e3),get_proclist_file(),get_ntpwatchdogenabled_file(),update_temperatures(),update_sysinfo(),ScriptUpdateLayout(),AddEventHandlers()}function ScriptUpdateLayout(){var a=GetVersionNumber("local"),b=GetVersionNumber("server");$j("#scmerlin_version_local").text(a),a!=b&&"N/A"!=b&&($j("#scmerlin_version_server").text("Updated version available: "+b),showhide("btnChkUpdate",!1),showhide("scmerlin_version_server",!0),showhide("btnDoUpdate",!0))}function reload(){location.reload(!0)}function update_status(){$j.ajax({url:"/ext/scmerlin/detect_update.js",dataType:"script",error:function(){setTimeout(update_status,1e3)},success:function(){"InProgress"==updatestatus?setTimeout(update_status,1e3):(document.getElementById("imgChkUpdate").style.display="none",showhide("scmerlin_version_server",!0),"None"==updatestatus?($j("#scmerlin_version_server").text("No update available"),showhide("btnChkUpdate",!0),showhide("btnDoUpdate",!1)):($j("#scmerlin_version_server").text("Updated version available: "+updatestatus),showhide("btnChkUpdate",!1),showhide("btnDoUpdate",!0)))}})}function CheckUpdate(){showhide("btnChkUpdate",!1),document.formScriptActions.action_script.value="start_scmerlincheckupdate",document.formScriptActions.submit(),document.getElementById("imgChkUpdate").style.display="",setTimeout(update_status,2e3)}function DoUpdate(){document.form.action_script.value="start_scmerlindoupdate",document.form.action_wait.value=15,$j("#auto_refresh").prop("checked",!1),clearTimeout(tout),showLoading(),document.form.submit()}function RestartService(a){showhide("btnRestartSrv_"+a,!1),showhide("txtRestartSrv_"+a,!1),document.formScriptActions.action_script.value="start_scmerlinservicerestart"+a,document.formScriptActions.submit(),document.getElementById("imgRestartSrv_"+a).style.display="",setTimeout(service_status,1e3,a)}function service_status(a){$j.ajax({url:"/ext/scmerlin/detect_service.js",dataType:"script",error:function(){setTimeout(service_status,1e3,a)},success:function(){"InProgress"==servicestatus?setTimeout(service_status,1e3,a):(document.getElementById("imgRestartSrv_"+a).style.display="none","Done"==servicestatus?(showhide("txtRestartSrv_"+a,!0),setTimeout(showhide,3e3,"txtRestartSrv_"+a,!1),setTimeout(showhide,3250,"btnRestartSrv_"+a,!0)):showhide("txtRestartSrvError_"+a,!0))}})}function GetVersionNumber(a){var b;return"local"==a?b=custom_settings.scmerlin_version_local:"server"==a&&(b=custom_settings.scmerlin_version_server),"undefined"==typeof b||null==b?"N/A":b}function BuildSortTableHtmlNoData(){var a="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"sortTable\">";return a+="<tr>",a+="<td colspan=\"3\" class=\"nodata\">",a+="Data loading...",a+="</td>",a+="</tr>",a+="</table>",a}function BuildSortTableHtml(a){var b="<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" class=\"sortTable\">";if("sortTableProcesses"==a){b+="<col style=\"width:50px;\">",b+="<col style=\"width:50px;\">",b+="<col style=\"width:75px;\">",b+="<col style=\"width:50px;\">",b+="<col style=\"width:50px;\">",b+="<col style=\"width:55px;\">",b+="<col style=\"width:50px;\">",b+="<col style=\"width:55px;\">",b+="<col style=\"width:740px;\">",b+="<thead class=\"sortTableHeader\">",b+="<tr>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">PID</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">PPID</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">USER</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">STAT</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">VSZ</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">VSZ%</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">CPU</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">CPU%</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableProcesses','arrayproclistlines',this.innerHTML,'sortnameproc','sortdirproc')\">COMMAND</th>",b+="</tr>",b+="</thead>",b+="<tbody class=\"sortTableContent\">";for(var c=0;c<arrayproclistlines.length;c++)b+="<tr class=\"sortRow\">",b+="<td>"+arrayproclistlines[c].PID+"</td>",b+="<td>"+arrayproclistlines[c].PPID+"</td>",b+="<td>"+arrayproclistlines[c].USER+"</td>",b+="<td>"+arrayproclistlines[c].STAT+"</td>",b+="<td>"+arrayproclistlines[c].VSZ+"</td>",b+="<td>"+arrayproclistlines[c].VSZP+"</td>",b+="<td>"+arrayproclistlines[c].CPU+"</td>",b+="<td>"+arrayproclistlines[c].CPUP+"</td>",b+="<td>"+arrayproclistlines[c].COMMAND+"</td>",b+="</tr>"}else if("sortTableCron"==a){b+="<col style=\"width:175px;\">",b+="<col style=\"width:45px;\">",b+="<col style=\"width:45px;\">",b+="<col style=\"width:45px;\">",b+="<col style=\"width:45px;\">",b+="<col style=\"width:45px;\">",b+="<col style=\"width:740px;\">",b+="<thead class=\"sortTableHeader\">",b+="<tr>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">Name</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">Min</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">Hour</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">DayM</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">Month</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">DayW</th>",b+="<th class=\"sortable\" onclick=\"SortTable('sortTableCron','arraycronjobs',this.innerHTML,'sortnamecron','sortdircron')\">Command</th>",b+="</tr>",b+="</thead>",b+="<tbody class=\"sortTableContent\">";for(var c=0;c<arraycronjobs.length;c++)b+="<tr class=\"sortRow\">",b+="<td>"+arraycronjobs[c].Name+"</td>",b+="<td>"+arraycronjobs[c].Min+"</td>",b+="<td>"+arraycronjobs[c].Hour+"</td>",b+="<td>"+arraycronjobs[c].DayM+"</td>",b+="<td>"+arraycronjobs[c].Month+"</td>",b+="<td>"+arraycronjobs[c].DayW+"</td>",b+="<td>"+arraycronjobs[c].Command+"</td>",b+="</tr>"}return b+="</tbody>",b+="</table>",b}function get_ntpwatchdogenabled_file(){$j.ajax({url:"/ext/scmerlin/watchdogenabled.htm",dataType:"text",error:function(){document.form.scmerlin_ntpwatchdog.value="disable"},success:function(){document.form.scmerlin_ntpwatchdog.value="enable"}})}function load_addonpages(){$j.ajax({url:"/ext/scmerlin/addonwebpages.htm",dataType:"text",error:function(){setTimeout(load_addonpages,1e3)},success:function(a){var b=a.split("\n");b=b.filter(Boolean);for(var c=0;c<b.length;c++)try{var d=b[c].split(","),e={};e.NAME=d[0].trim(),e.URL=d[1].trim(),sortedAddonPages.push(e)}catch{}sortedAddonPages=sortedAddonPages.sort(function(c,a){return c.NAME.toLowerCase().localeCompare(a.NAME.toLowerCase())});for(var f="",c=0;c<sortedAddonPages.length;c++)f+=BuildAddonPageTable(sortedAddonPages[c].NAME,sortedAddonPages[c].URL,c);$j("#table_config").after(f),AddEventHandlers()}})}function get_cronlist_file(){$j.ajax({url:"/ext/scmerlin/scmcronjobs.htm",dataType:"text",error:function(){tout=setTimeout(get_cronlist_file,1e3)},success:function(a){ParseCronJobs(a)}})}function ParseCronJobs(a){var b=a.split("\n");b=b.filter(Boolean),arraycronjobs=[];for(var c=0;c<b.length;c++)try{var d=b[c].split(","),e={};e.Name=d[0].trim().replace(/^\"/,"").replace(/\"$/,""),e.Min=d[1].trim().replace(/^\"/,"").replace(/\"$/,"").replace(/\|/,","),e.Hour=d[2].trim().replace(/^\"/,"").replace(/\"$/,"").replace(/\|/,","),e.DayM=d[3].trim().replace(/^\"/,"").replace(/\"$/,"").replace(/\|/,","),e.Month=d[4].trim().replace(/^\"/,"").replace(/\"$/,"").replace(/\|/,","),e.DayW=d[5].trim().replace(/^\"/,"").replace(/\"$/,"").replace(/\|/,","),e.Command=d[6].trim().replace(/^\"/,"").replace(/\"$/,""),arraycronjobs.push(e)}catch{}SortTable("sortTableCron","arraycronjobs",sortnamecron+" "+sortdircron.replace("desc","\u2191").replace("asc","\u2193").trim(),"sortnamecron","sortdircron")}function get_proclist_file(){$j.ajax({url:"/ext/scmerlin/top.htm",dataType:"text",error:function(){tout=setTimeout(get_proclist_file,1e3)},success:function(a){ParseProcList(a),document.getElementById("auto_refresh").checked&&(tout=setTimeout(get_proclist_file,5e3))}})}function ParseProcList(a){var b=a.split("\n");b=b.filter(Boolean),arrayproclistlines=[];for(var c=0;c<b.length;c++)try{var d=b[c].split(","),e={};e.PID=d[0].trim(),e.PPID=d[1].trim(),e.USER=d[2].trim(),e.STAT=d[3].trim(),e.VSZ=d[4].trim(),e.VSZP=d[5].trim(),e.CPU=d[6].trim(),e.CPUP=d[7].trim(),e.COMMAND=d[8].trim(),arrayproclistlines.push(e)}catch{}SortTable("sortTableProcesses","arrayproclistlines",sortnameproc+" "+sortdirproc.replace("desc","\u2191").replace("asc","\u2193").trim(),"sortnameproc","sortdirproc")}function GetCookie(a,b){if(null!=cookie.get("scm_"+a))return cookie.get("scm_"+a);return"string"==b?"":"number"==b?0:void 0}function SetCookie(a,b){cookie.set("scm_"+a,b,3650)}function AddEventHandlers(){$j(".collapsible-jquery").off("click").on("click",function(){$j(this).siblings().toggle("fast",function(){"none"==$j(this).css("display")?SetCookie($j(this).siblings()[0].id,"collapsed"):(SetCookie($j(this).siblings()[0].id,"expanded"),"routermemory"==$j(this).siblings()[0].id?(Draw_Chart("MemoryUsage"),0==parseInt(mem_stats_arr[5])?Draw_Chart_NoData("SwapUsage","No swap file configured"):Draw_Chart("SwapUsage")):"routerstorage"==$j(this).siblings()[0].id&&(Draw_Chart("nvramUsage"),Draw_Chart("jffsUsage")))})}),$j(".collapsible-jquery").each(function(){"collapsed"==GetCookie($j(this)[0].id,"string")?$j(this).siblings().toggle(!1):$j(this).siblings().toggle(!0)}),$j("#auto_refresh").off("click").on("click",function(){ToggleRefresh()})}function SortTable(tableid,arrayid,sorttext,sortname,sortdir){window[sortname]=sorttext.replace("\u2191","").replace("\u2193","").trim();var sorttype="number",sortfield=window[sortname];switch(window[sortname]){case"VSZ%":sortfield="VSZP";break;case"CPU%":sortfield="CPUP";break;case"USER":case"STAT":case"COMMAND":case"Name":case"Command":sorttype="string";}"string"==sorttype?-1==sorttext.indexOf("\u2193")&&-1==sorttext.indexOf("\u2191")?(eval(arrayid+" = "+arrayid+".sort((a,b) => (a."+sortfield+".toLowerCase() > b."+sortfield+".toLowerCase()) ? 1 : ((b."+sortfield+".toLowerCase() > a."+sortfield+".toLowerCase()) ? -1 : 0));"),window[sortdir]="asc"):-1==sorttext.indexOf("\u2193")?(eval(arrayid+" = "+arrayid+".sort((a,b) => (a."+sortfield+".toLowerCase() < b."+sortfield+".toLowerCase()) ? 1 : ((b."+sortfield+".toLowerCase() < a."+sortfield+".toLowerCase()) ? -1 : 0));"),window[sortdir]="desc"):(eval(arrayid+" = "+arrayid+".sort((a,b) => (a."+sortfield+".toLowerCase() > b."+sortfield+".toLowerCase()) ? 1 : ((b."+sortfield+".toLowerCase() > a."+sortfield+".toLowerCase()) ? -1 : 0));"),window[sortdir]="asc"):"number"==sorttype&&(-1==sorttext.indexOf("\u2193")&&-1==sorttext.indexOf("\u2191")?(eval(arrayid+" = "+arrayid+".sort((a,b) => parseFloat(getNum(a."+sortfield+".replace(\"m\",\"000\"))) - parseFloat(getNum(b."+sortfield+".replace(\"m\",\"000\"))));"),window[sortdir]="asc"):-1==sorttext.indexOf("\u2193")?(eval(arrayid+" = "+arrayid+".sort((a,b) => parseFloat(getNum(b."+sortfield+".replace(\"m\",\"000\"))) - parseFloat(getNum(a."+sortfield+".replace(\"m\",\"000\"))));"),window[sortdir]="desc"):(eval(arrayid+" = "+arrayid+".sort((a,b) => parseFloat(getNum(a."+sortfield+".replace(\"m\",\"000\"))) - parseFloat(getNum(b."+sortfield+".replace(\"m\",\"000\"))));"),window[sortdir]="asc")),$j("#"+tableid).empty(),$j("#"+tableid).append(BuildSortTableHtml(tableid)),$j("#"+tableid).find(".sortable").each(function(a,b){b.innerHTML==window[sortname]&&("asc"==window[sortdir]?b.innerHTML=window[sortname]+" \u2191":b.innerHTML=window[sortname]+" \u2193")})}function getNum(a){if(isNaN(a)){if("*"==a)return-10;if(-1!=a.indexOf("*/"))return-5;if(-1!=a.indexOf("/"))return a.split("/")[0];if("Sun"==a)return 0;if("Mon"==a)return 1;if("Tue"==a)return 2;if("Wed"==a)return 3;if("Thu"==a)return 4;if("Fri"==a)return 5;if("Sat"==a)return 6}return a}function ToggleRefresh(){!0==$j("#auto_refresh").prop("checked")?get_proclist_file():clearTimeout(tout)}function BuildAddonPageTable(a,b,c){var d="";if(0==c&&(d+="<div style=\"line-height:10px;\">&nbsp;</div>",d+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable SettingsTable\" style=\"border:0px;\" id=\"table_services\">",d+="<thead class=\"collapsible-jquery\" id=\"addonpages\">",d+="<tr><td colspan=\"4\">WebUI Addons (click to expand/collapse)</td></tr>",d+="</thead>"),(0==c||0==c%4)&&(d+="<tr>"),d+="<td class=\"addonpageurl\"><a href=\""+b.substring(b.lastIndexOf("/")+1)+"\">"+a+"</a><br /><span class=\"addonpageurl\">"+b.substring(b.lastIndexOf("/")+1)+"</span></td>",0<c&&0==(c+1)%4&&(d+="</tr>"),c==sortedAddonPages.length-1){if(0!=sortedAddonPages.length%4){for(var e=4-sortedAddonPages.length%4,f=0;f<e;f++)d+="<td class=\"addonpageurl\"></td>";d+="</tr>"}d+="</table>"}return d}function BuildServiceTable(a,b,c,d){var e="";return 0==d&&(e+="<div style=\"line-height:10px;\">&nbsp;</div>",e+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable SettingsTable\" style=\"border:0px;\" id=\"table_services\">",e+="<thead class=\"collapsible-jquery\" id=\"servicescontrol\">",e+="<tr><td colspan=\"4\">Services (click to expand/collapse)</td></tr>",e+="</thead>"),(0==d||0==d%2)&&(e+="<tr>"),e+=c?"<td class=\"servicename\">"+b+" <span class=\"settingname\">("+a+")</span></td>":"<td class=\"servicename\">"+b+"</td>",a=a.replace("/",""),e+="<td class=\"servicevalue\">",e+="<input type=\"button\" class=\"button_gen restartbutton\" onclick=\"RestartService('"+a+"');\" value=\"Restart\" id=\"btnRestartSrv_"+a+"\">",e+="<span id=\"txtRestartSrv_"+a+"\" style=\"display:none;\" class=\"servicespan\">Done</span>",e+="<span id=\"txtRestartSrvError_"+a+"\" style=\"display:none;\" class=\"servicespan\">Invalid - service disabled</span>",e+="<img id=\"imgRestartSrv_"+a+"\" style=\"display:none;vertical-align:middle;\" src=\"images/InternetScan.gif\"/>",e+="</td>",0<d&&0==(d+1)%2&&(e+="</tr>"),d==srvnamelist.length-1&&(e+="</table>"),e}function BuildVPNClientTable(loopindex){var vpnclientshtml="",vpnclientname="vpnclient"+loopindex,vpnclientdesc=eval("document.form.vpnc"+loopindex+"_desc").value;return 1==loopindex&&(vpnclientshtml+="<div style=\"line-height:10px;\">&nbsp;</div>",vpnclientshtml+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable SettingsTable\" style=\"border:0px;\" id=\"table_vpnclients\">",vpnclientshtml+="<thead class=\"collapsible-jquery\" id=\"vpnclientscontrol\">",vpnclientshtml+="<tr><td colspan=\"4\">VPN Clients (click to expand/collapse)</td></tr>",vpnclientshtml+="</thead>"),(1==loopindex||0==(loopindex+1)%2)&&(vpnclientshtml+="<tr>"),vpnclientshtml+="<td class=\"servicename\">VPN Client "+loopindex,vpnclientshtml+="<br /><span class=\"settingname\">("+vpnclientdesc+")</span></td>",vpnclientshtml+="<td class=\"servicevalue\">",vpnclientshtml+="<input type=\"button\" class=\"button_gen restartbutton\" onclick=\"RestartService('"+vpnclientname+"');\" value=\"Restart\" id=\"btnRestartSrv_"+vpnclientname+"\">",vpnclientshtml+="<span id=\"txtRestartSrv_"+vpnclientname+"\" style=\"display:none;\" class=\"servicespan\">Done</span>",vpnclientshtml+="<span id=\"txtRestartSrvError_"+vpnclientname+"\" style=\"display:none;\" class=\"servicespan\">Invalid - VPN Client disabled</span>",vpnclientshtml+="<img id=\"imgRestartSrv_"+vpnclientname+"\" style=\"display:none;vertical-align:middle;\" src=\"images/InternetScan.gif\"/>",vpnclientshtml+="</td>",5==loopindex&&(vpnclientshtml+="<td class=\"servicename\"></td><td class=\"servicevalue\"></td>"),1<loopindex&&0==loopindex%2&&(vpnclientshtml+="</tr>"),5==loopindex&&(vpnclientshtml+="</table>"),vpnclientshtml}function BuildVPNServerTable(a){var b="",c="vpnserver"+a;return 1==a&&(b+="<div style=\"line-height:10px;\">&nbsp;</div>",b+="<table width=\"100%\" border=\"1\" align=\"center\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#6b8fa3\" class=\"FormTable SettingsTable\" style=\"border:0px;\" id=\"table_vpnservers\">",b+="<thead class=\"collapsible-jquery\" id=\"vpnserverscontrol\">",b+="<tr><td colspan=\"4\">VPN Servers (click to expand/collapse)</td></tr>",b+="</thead>",b+="<tr>"),b+="<td class=\"servicename\">VPN Server "+a+"</td>",b+="<td class=\"servicevalue\">",b+="<input type=\"button\" class=\"button_gen restartbutton\" onclick=\"RestartService('"+c+"');\" value=\"Restart\" id=\"btnRestartSrv_"+c+"\">",b+="<span id=\"txtRestartSrv_"+c+"\" style=\"display:none;\" class=\"servicespan\">Done</span>",b+="<span id=\"txtRestartSrvError_"+c+"\" style=\"display:none;\" class=\"servicespan\">Invalid - VPN Server disabled</span>",b+="<img id=\"imgRestartSrv_"+c+"\" style=\"display:none;vertical-align:middle;\" src=\"images/InternetScan.gif\"/>",b+="</td>",2==a&&(b+="</tr>",b+="</table>"),b}function round(a,b){return+(Math.round(a+"e"+b)+"e-"+b)}function Draw_Chart_NoData(a,b){document.getElementById("canvasChart"+a).width="265",document.getElementById("canvasChart"+a).height="250",document.getElementById("canvasChart"+a).style.width="265px",document.getElementById("canvasChart"+a).style.height="250px";var c=document.getElementById("canvasChart"+a).getContext("2d");c.save(),c.textAlign="center",c.textBaseline="middle",c.font="normal normal bolder 22px Arial",c.fillStyle="white",c.fillText(b,135,125),c.restore()}function Draw_Chart(a){var b=[],c=[],d=[],e="",f="";if("MemoryUsage"==a)b=[1*mem_stats_arr[0]-1*mem_stats_arr[1]-1*mem_stats_arr[2]-1*mem_stats_arr[3],mem_stats_arr[1],mem_stats_arr[2],mem_stats_arr[3]],c=["Used","Free","Buffers","Cache"],d=["#5eaec0","#12cf80","#ceca09","#9d12c4"],e="Memory Usage",f="MB";else if("SwapUsage"==a)b=[mem_stats_arr[4],1*mem_stats_arr[5]-1*mem_stats_arr[4]],c=["Used","Free"],d=["#135fee","#1aa658"],e="Swap Usage",f="MB";else if("nvramUsage"==a)b=[round(mem_stats_arr[6]/1024,2).toFixed(2),round(1*nvramtotal-1*mem_stats_arr[6]/1024,2).toFixed(2)],c=["Used","Free"],d=["#5eaec0","#12cf80"],e="NVRAM Usage",f="KB";else if("jffsUsage"==a){var g=mem_stats_arr[7].split(" ");b=[1*g[0],1*g[2]-1*g[0]],c=["Used","Free"],d=["#135fee","#1aa658"],e="JFFS Usage",f="MB"}var h=window["Chart"+a];h!=null&&h.destroy();var i=document.getElementById("canvasChart"+a).getContext("2d"),j={segmentShowStroke:!1,segmentStrokeColor:"#000",maintainAspectRatio:!1,animation:{duration:0},hover:{animationDuration:0},responsiveAnimationDuration:0,legend:{onClick:null,display:!0,position:"left",labels:{fontColor:"#ffffff"}},title:{display:!0,text:e,position:"top"},tooltips:{callbacks:{title:function(a,b){return b.labels[a[0].index]},label:function(a,b){return round(b.datasets[a.datasetIndex].data[a.index],2).toFixed(2)+" "+f}},mode:"point",position:"cursor",intersect:!0},scales:{xAxes:[{display:!1,gridLines:{display:!1},scaleLabel:{display:!1},ticks:{display:!1}}],yAxes:[{display:!1,gridLines:{display:!1},scaleLabel:{display:!1},ticks:{display:!1}}]}},k={labels:c,datasets:[{data:b,borderWidth:1,backgroundColor:d,borderColor:"#000000"}]};h=new Chart(i,{type:"pie",options:j,data:k}),window["Chart"+a]=h}function SaveConfig(){document.form.action_script.value="start_scmerlinconfig"+document.form.scmerlin_ntpwatchdog.value,document.form.action_wait.value=10,$j("#auto_refresh").prop("checked",!1),clearTimeout(tout),showLoading(),document.form.submit()}
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
<div class="formfontdesc">scMerlin allows you to use easily control the most common services/scripts on your router. scMerlin also augments your router's WebUI with a Sitemap and dynamic submenus for the main left menu of Asuswrt-Merlin.</div>
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
<td class="servicename">Temperatures</td>
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

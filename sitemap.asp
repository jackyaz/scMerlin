<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>SiteMap</title>
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<style>
p{font-weight:bolder}thead.collapsible-jquery{color:#fff;padding:0;width:100%;border:none;text-align:left;outline:none;cursor:pointer}.SettingsTable{text-align:left}.SettingsTable input{text-align:left;margin-left:3px!important}.SettingsTable input.savebutton{text-align:center;margin-top:5px;margin-bottom:5px;border-right:solid 1px #000;border-left:solid 1px #000;border-bottom:solid 1px #000}.SettingsTable td.savebutton{border-right:solid 1px #000;border-left:solid 1px #000;border-bottom:solid 1px #000;background-color:#4d595d}.SettingsTable .cronbutton{text-align:center;min-width:50px;width:50px;height:23px;vertical-align:middle}.SettingsTable select{margin-left:3px!important}.SettingsTable label{margin-right:10px!important;vertical-align:top!important}.SettingsTable th{background-color:#1F2D35!important;background:#2F3A3E!important;border-bottom:none!important;border-top:none!important;font-size:12px!important;color:#fff!important;padding:4px!important;font-weight:bolder!important;padding:0!important}.SettingsTable td{word-wrap:break-word!important;overflow-wrap:break-word!important;border-right:none;border-left:none}.SettingsTable span.settingname{background-color:#1F2D35!important;background:#2F3A3E!important}.SettingsTable td.settingname{border-right:solid 1px #000;border-left:solid 1px #000;background-color:#1F2D35!important;background:#2F3A3E!important;width:35%!important}.SettingsTable td.settingvalue{text-align:left!important;border-right:solid 1px #000}.SettingsTable td.servicename{border-right:solid 1px #000;border-left:solid 1px #000;background-color:#1F2D35!important;background:#2F3A3E!important;width:30%!important}.SettingsTable td.servicevalue{text-align:center!important;border-right:solid 1px #000;width:20%!important;padding-left:4px!important}.SettingsTable span.servicespan{font-size:10px!important}.SettingsTable th:first-child{border-left:none!important}.SettingsTable th:last-child{border-right:none!important}.SettingsTable .invalid{background-color:#8b0000!important}.SettingsTable .disabled{background-color:#CCC!important;color:#888!important}div.sortTableContainer{height:500px;overflow-y:scroll;width:745px;border:1px solid #000}.sortTable{table-layout:fixed!important;border:none}thead.sortTableHeader th{background-image:linear-gradient(#92a0a5 0%,#66757c 100%);border-top:none!important;border-left:none!important;border-right:none!important;border-bottom:1px solid #000!important;font-weight:bolder;padding:2px;text-align:center;color:#fff;position:sticky;top:0}thead.sortTableHeader th:first-child,thead.sortTableHeader th:last-child{border-right:none!important}thead.sortTableHeader th:last-child{text-align:left!important;padding-left:4px!important}thead.sortTableHeader th:first-child,thead.sortTableHeader td:first-child{border-left:none!important}tbody.sortTableContent td:last-child,tbody.sortTableContent tr.sortNormalRow td:last-child,tbody.sortTableContent tr.sortAlternateRow td:last-child{text-align:left!important;padding-left:4px!important}tbody.sortTableContent td{border-bottom:1px solid #000!important;border-left:none!important;border-right:1px solid #000!important;border-top:none!important;padding:2px;text-align:center;overflow:hidden!important;white-space:nowrap!important;font-size:12px!important}tbody.sortTableContent tr.sortRow:nth-child(odd) td{background-color:#2F3A3E!important}tbody.sortTableContent tr.sortRow:nth-child(even) td{background-color:#475A5F!important}th.sortable{cursor:pointer}td.metricname{background-color:#1F2D35!important;background:#2F3A3E!important;width:50px!important}.restartbutton{text-align:center!important;min-width:75px;width:75px;vertical-align:middle}td.addonpageurl:nth-child(even){border:1px solid #000!important;text-align:center!important;background-color:#475A5F!important}td.addonpageurl:nth-child(odd){border:1px solid #000!important;text-align:center!important;background-color:#1F2D35!important;background:#2F3A3E!important}td.addonpageurl:nth-child(even) span{background-color:#475A5F!important}td.addonpageurl:nth-child(odd) span{background-color:#1F2D35!important;background:#2F3A3E!important}td.addonpageurl a{font-weight:bolder!important;text-decoration:underline!important}span.addonpageurl{color:#FC0;font-size:10px!important}.nodata{height:65px!important;border:none!important;text-align:center!important;font:bolder 48px Arial!important}
</style>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/jquery.js"></script>
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
var $j = jQuery.noConflict(); //avoid conflicts on John's fork (state.js)

function SetCurrentPage(){
	document.form.next_page.value = window.location.pathname.substring(1);
	document.form.current_page.value = window.location.pathname.substring(1);
}

function initial(){
	SetCurrentPage();
	show_menu();
	GenerateSiteMap();
}

function reload(){
	location.reload(true);
}

function GenerateSiteMap(){
	var myMenu = [];
	
	if(typeof menuList == 'undefined' || menuList == null){
		setTimeout(GenerateSiteMap,1000);
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
			sitemapstring += '<span style="font-size:14px;"><b><a style="color:#FFCC00;" href="'+myMenu[i].tabs[0].url+'" target="_blank">'+myMenu[i].menuName+'</a></b></span><br>';
		}
		else{
			sitemapstring += '<span style="font-size:14px;"><b>'+myMenu[i].menuName+'</b></span><br>';
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
				sitemapstring += '<a style="text-decoration:underline;" href="'+taburl+'" target="_blank">'+tabname+'</a><br>';
			}
		sitemapstring += '<br>';
	}
	$j('#sitemapcontent').html(sitemapstring);
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
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_sitemap">
<thead class="collapsible-jquery" id="sitemap">
<tr><td colspan="2">Site Map (click to expand/collapse)</td></tr>
</thead>
<tr class="even" id="rowsitemap">
<td colspan="2">
<div id="sitemapcontent" style="overflow-y:scroll;height:250px;"></div>
</td>
<!-- End Sitemap -->
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
<div id="footer">
</div>
</body>
</html>

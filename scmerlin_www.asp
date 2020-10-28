<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>scmerlin</title>
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
var arrayproclistlines = [];
var originalarrayproclistlines = [];
var sortfield = "CPU%";
var sortname = "CPU%";
var sortdir = "desc";

var $j = jQuery.noConflict(); //avoid conflicts on John's fork (state.js)

function initial(){
	show_menu();
	AddEventHandlers();
	get_proclist_file();
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
			setTimeout(get_proclist_file, 1000);
		},
		success: function(data){
			ParseProcList(data);
			if(document.getElementById("auto_refresh").checked){
				setTimeout("get_proclist_file();",3000);
			}
		}
	});
}

function ParseProcList(data){
	var arrayproclines = data.split("\n");
	arrayproclines = arrayproclines.filter(Boolean);
	arrayproclistlines = [];
	for(var i = 0; i < arrayproclines.length; i++){
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
	originalarrayproclistlines = arrayproclistlines;
	SortTable(sortname+" "+sortdir.replace("desc","↑").replace("asc","↓").trim());
}

function GetCookie(cookiename,returntype){
	var s;
	if ((s = cookie.get("scm_"+cookiename)) != null){
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
}

/* http://www.alistapart.com/articles/zebratables/ */
function stripedTable() {
	if (document.getElementById && document.getElementsByTagName) {
		var allTables = document.getElementsByClassName('procTable');
		if (!allTables) { return; }
		
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
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="about:blank" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="action_script" value="start_uiDivStats">
<input type="hidden" name="current_page" value="">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="60">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="SystemCmd" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
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
<div class="formfonttitle" id="scripttitle" style="text-align:center;">scmerlin</div>
<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
<div id="formfontdesc" class="formfontdesc">WebUI of running processes</div>

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

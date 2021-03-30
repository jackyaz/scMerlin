var arrayproclistlines = [];
var originalarrayproclistlines = [];
var sortfield = "CPU%";
var sortname = "CPU%";
var sortdir = "desc";
var tout;

Chart.defaults.global.defaultFontColor = "#CCC";
Chart.Tooltip.positioners.cursor = function(chartElements, coordinates){
	return coordinates;
};

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
	for(var i = 1; i < 3; i++){
		vpnserverstablehtml += BuildVPNServerTable(i);
	}
	$j("#table_config").after(vpnserverstablehtml);
	
	var vpnclientstablehtml="";
	for(var i = 1; i < 6; i++){
		vpnclientstablehtml += BuildVPNClientTable(i);
	}
	$j("#table_config").after(vpnclientstablehtml);
	
	var servicectablehtml="";
	for(var i = 0; i < srvnamelist.length; i++){
		servicectablehtml += BuildServiceTable(srvnamelist[i],srvdesclist[i],srvnamevisiblelist[i],i);
	}
	$j("#table_config").after(servicectablehtml);
	
	get_usbdisabled_file();
	update_temperatures();
	update_sysinfo();
	ScriptUpdateLayout();
	AddEventHandlers();
}

function ScriptUpdateLayout(){
	var localver = GetVersionNumber("local");
	var serverver = GetVersionNumber("server");
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
			setTimeout(update_status, 1000);
		},
		success: function(){
			if(updatestatus == "InProgress"){
				setTimeout(update_status, 1000);
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
	setTimeout(update_status, 2000);
}

function DoUpdate(){
	document.form.action_script.value = "start_scmerlindoupdate";
	document.form.action_wait.value = 10;
	showLoading();
	document.form.submit();
}

function RestartService(servicename){
	showhide("btnRestartSrv_"+servicename, false);
	showhide("txtRestartSrv_"+servicename, false);
	document.formScriptActions.action_script.value="start_scmerlinservicerestart"+servicename;
	document.formScriptActions.submit();
	document.getElementById("imgRestartSrv_"+servicename).style.display = "";
	setTimeout(service_status, 1000, servicename);
}

function service_status(servicename){
	$j.ajax({
		url: '/ext/scmerlin/detect_service.js',
		dataType: 'script',
		timeout: 3000,
		error:	function(xhr){
			setTimeout(service_status, 1000, servicename);
		},
		success: function(){
			if(servicestatus == "InProgress"){
				setTimeout(service_status, 1000, servicename);
			}
			else{
				document.getElementById("imgRestartSrv_"+servicename).style.display = "none";
				if(servicestatus == "Done"){
					showhide("btnRestartSrv_"+servicename, true);
					showhide("txtRestartSrv_"+servicename, true);
					setTimeout(showhide, 3000,'txtRestartSrv_'+servicename,false);
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

function get_usbdisabled_file(){
	$j.ajax({
		url: '/ext/scmerlin/usbdisabled.htm',
		dataType: 'text',
		timeout: 10000,
		error: function(xhr){
			document.form.scmerlin_usbenabled.value = "enable";
			get_proclist_file();
		},
		success: function(data){
			document.form.scmerlin_usbenabled.value = "disable";
			document.getElementById("procTableContainer").innerHTML = "Process list disabled, this feature requires the \"USB features\" option to be enabled and a USB device plugged into router for Entware";
		}
	});
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
				tout = setTimeout(get_proclist_file,3000);
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
	cookie.set("scm_"+cookiename, cookievalue, 10 * 365);
}

function AddEventHandlers(){
	$j(".collapsible-jquery").off('click').on('click', function(){
		$j(this).siblings().toggle("fast",function(){
			if($j(this).css("display") == "none"){
				SetCookie($j(this).siblings()[0].id,"collapsed");
			}
			else{
				SetCookie($j(this).siblings()[0].id,"expanded");
				if($j(this).siblings()[0].id == "routermemory"){
					Draw_Chart("MemoryUsage");
					if(parseInt(mem_stats_arr[5]) != 0){
						Draw_Chart("SwapUsage");
					}
					else{
						Draw_Chart_NoData("SwapUsage");
					}
				}
				else if($j(this).siblings()[0].id == "routerstorage"){
					Draw_Chart("nvramUsage");
					Draw_Chart("jffsUsage");
				}
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

function round(value, decimals){
	return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}

function Draw_Chart_NoData(txtchartname){
	document.getElementById("canvasChart" + txtchartname).width = "270";
	document.getElementById("canvasChart" + txtchartname).height = "250";
	document.getElementById("canvasChart" + txtchartname).style.width = "270px";
	document.getElementById("canvasChart" + txtchartname).style.height = "250px";
	var ctx = document.getElementById("canvasChart" + txtchartname).getContext("2d");
	ctx.save();
	ctx.textAlign = 'center';
	ctx.textBaseline = 'middle';
	ctx.font = "normal normal bolder 22px Arial";
	ctx.fillStyle = 'white';
	ctx.fillText('No swap file configured', 135, 125);
	ctx.restore();
}

function Draw_Chart(txtchartname){
	var chartData = [];
	var chartLabels = [];
	var chartColours = [];
	var chartTitle = "";
	var chartUnit = "";
	
	if(txtchartname == "MemoryUsage"){
		chartData = [mem_stats_arr[0]*1-mem_stats_arr[1]*1-mem_stats_arr[2]*1-mem_stats_arr[3]*1,mem_stats_arr[1],mem_stats_arr[2],mem_stats_arr[3]];
		chartLabels = ["Used","Free","Buffers","Cache"];
		chartColours = ["#5eaec0","#12cf80","#ceca09","#9d12c4"];
		chartTitle = "Memory Usage";
		chartUnit = "MB";
	}
	else if(txtchartname == "SwapUsage"){
		chartData = [mem_stats_arr[4],mem_stats_arr[5]*1-mem_stats_arr[4]*1];
		chartLabels = ["Used","Free"];
		chartColours = ["#135fee","#1aa658"];
		chartTitle = "Swap Usage";
		chartUnit = "MB";
	}
	else if(txtchartname == "nvramUsage"){
		chartData = [round(mem_stats_arr[6]/1024,2).toFixed(2),round(nvramtotal*1-mem_stats_arr[6]*1/1024,2).toFixed(2)];
		chartLabels = ["Used","Free"];
		chartColours = ["#5eaec0","#12cf80"];
		chartTitle = "NVRAM Usage";
		chartUnit = "KB";
	}
	else if(txtchartname == "jffsUsage"){
		var jffs_usage = mem_stats_arr[7].split(" ");
		chartData = [jffs_usage[0]*1,jffs_usage[2]*1-jffs_usage[0]*1];
		chartLabels = ["Used","Free"];
		chartColours = ["#135fee","#1aa658"];
		chartTitle = "JFFS Usage";
		chartUnit = "MB";
	}
	
	var objchartname = window["Chart" + txtchartname];
	
	if(objchartname != undefined) objchartname.destroy();
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
					return round(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index],2).toFixed(2) + " " + chartUnit;
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

function SaveConfig(){
	document.form.action_script.value = "start_scmerlinconfig" + document.form.scmerlin_usbenabled.value;
	document.form.action_wait.value = 10;
	showLoading();
	document.form.submit();
}

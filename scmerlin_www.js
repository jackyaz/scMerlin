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
	
	Draw_Chart_NoData('nvramUsage','Data loading...');
	Draw_Chart_NoData('jffsUsage','Data loading...');
	Draw_Chart_NoData('MemoryUsage','Data loading...')
	Draw_Chart_NoData('SwapUsage','No swap file configured');
	
	$j('#sortTableCron').empty();
	$j('#sortTableCron').append(BuildSortTableHtmlNoData());
	$j('#sortTableProcesses').empty();
	$j('#sortTableProcesses').append(BuildSortTableHtmlNoData());
	
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
	setTimeout(load_addonpages,5000);
	setTimeout(get_cronlist_file,5000);
	get_proclist_file();
	get_ntpwatchdogenabled_file();
	update_temperatures();
	update_sysinfo();
	ScriptUpdateLayout();
	AddEventHandlers();
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
	document.form.action_wait.value = 15;
	$j('#auto_refresh').prop('checked',false);
	clearTimeout(tout);
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
		error: function(xhr){
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

function BuildSortTableHtmlNoData(){
	var tablehtml='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="sortTable">';
	tablehtml += '<tr>';
	tablehtml += '<td colspan="3" class="nodata">';
	tablehtml += 'Data loading...';
	tablehtml += '</td>';
	tablehtml += '</tr>';
	tablehtml += '</table>';
	return tablehtml;
}

function BuildSortTableHtml(type) {
	var tablehtml = '<table border="0" cellpadding="0" cellspacing="0" width="100%" class="sortTable">';
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
						Draw_Chart_NoData('SwapUsage','No swap file configured');
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
	
	$j('#auto_refresh').off('click').on('click',function(){ToggleRefresh();});
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
	if($j('#auto_refresh').prop('checked') == true){
		get_proclist_file();
	}
	else{
		clearTimeout(tout);
	}
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

function Draw_Chart_NoData(txtchartname,txtmessage){
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
	ctx.fillText(txtmessage,135,125);
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
	$j('#auto_refresh').prop('checked',false);
	clearTimeout(tout);
	showLoading();
	document.form.submit();
}

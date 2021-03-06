var GetSaveStatusList =[];
var GetStatusList = [];
var GetEContentStatusList = [];
var GetOverDriveStatusList = [];
var GetSeriesList = [];

function createRequestObject() {	
	// find the correct xmlHTTP, works with IE, FF and Opera
	var xmlhttp;
	try {
		xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
	} catch(e) {
		try {
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		} catch(e) {
			xmlhttp = null;
		}
	}

	if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
		xmlhttp = new XMLHttpRequest();
	}

	return xmlhttp;
}

function getElem(id) {
	if (document.getElementById) {
		return document.getElementById(id);
	} else if (document.all) {
		return document.all[id];
	}
}

function addIdToStatusList(id, type, useUnscopedHoldingsSummary) {
	if (type == undefined){
		type = 'VuFind';
	}
	var idVal = [];
	idVal['id'] = id;
	idVal['useUnscopedHoldingsSummary'] = useUnscopedHoldingsSummary;
	if (type.toUpperCase() === 'VUFIND'){
		GetStatusList[GetStatusList.length] = idVal;
	}else if (type.toUpperCase() == 'OVERDRIVE'){
		GetOverDriveStatusList[GetOverDriveStatusList.length] = idVal;
	}else{
		GetEContentStatusList[GetEContentStatusList.length] = idVal;
	}
}

function doGetStatusSummaries()
{
	var now = new Date();
	var ts = Date.UTC(now.getFullYear(),now.getMonth(),now.getDay(),now.getHours(),now.getMinutes(),now.getSeconds(),now.getMilliseconds());

	var callGetEContentStatusSummaries = false;
	var eContentUrl = path + "/Search/AJAX?method=GetEContentStatusSummaries";
	for (var j=0; j<GetEContentStatusList.length; j++) {
		eContentUrl += "&id[]=" + encodeURIComponent(GetEContentStatusList[j]['id']);
		if (GetEContentStatusList[j]['useUnscopedHoldingsSummary']){
			eContentUrl += "&useUnscopedHoldingsSummary=true";
		}
		callGetEContentStatusSummaries = true;
	}

	eContentUrl += "&time=" +ts;

	//Since the ILS can be slow, make individual calls to print titles
	// Modify this to return status summaries one at a time to improve
	// the perceived performance
	var callGetStatusSummaries = false;
	for (var j=0; j<GetStatusList.length; j++) {
		var url = path + "/Search/AJAX?method=GetStatusSummaries";
		url += "&id[]=" + encodeURIComponent(GetStatusList[j]['id']);
		if (GetStatusList[j]['useUnscopedHoldingsSummary']){
			url += "&useUnscopedHoldingsSummary=true";
		}
		url += "&time="+ts;
		$.getJSON(url, function(data){
			var items = data.items;
			
			var elemId;
			var statusDiv;
			var status;
			var reserves;
			var showPlaceHold;
			var placeHoldLink;
			var numHoldable = 0;

			for (var i=0; i<items.length; i++) {
				try{
					elemId = items[i].shortId;

					// Place hold link
					if (items[i].showPlaceHold == null){
						showPlaceHold = 0;
					}else{	
						showPlaceHold = items[i].showPlaceHold;
					}

					// Multi select place hold options
					if (showPlaceHold == '1' || showPlaceHold == true){
						numHoldable++;
						// show the place hold button
						var placeHoldButton = $('#placeHold' + elemId );
						if (placeHoldButton.length > 0){
							placeHoldButton.show();
						}
					}

					// Change outside border class.
					var holdingSum= $('#holdingsSummary' + elemId);
					if (holdingSum.length > 0){
						divClass = items[i]['class'];
						holdingSum.addClass(divClass);
						var formattedHoldingsSummary = items[i].formattedHoldingsSummary;
						holdingSum.replaceWith(formattedHoldingsSummary);
					}
					
					//Load eAudio link
					if (items[i].eAudioLink != null){
						var eAudioLink = items[i].eAudioLink;
						if (eAudioLink) {
							if (eAudioLink.length > 0 && $("#eAudioLink" + elemId).length > 0) {
								$("#eAudioLink" + elemId).html("<a href='" + eAudioLink + "'><img src='" + path + "/interface/themes/wcpl/images/access_eaudio.png' alt='Access eAudio'/></a>").show();
							}
						}
					}
					
					//Load eBook link
					if (items[i].eBookLink != null){
						var eBookLink = items[i].eBookLink;
						if (eBookLink) {
							if (eBookLink.length > 0 && $("#eBookLink" + elemId).length > 0) {
								$("#eBookLink" + elemId).html("<a href='" + eBookLink + "'><img src='" + path + "/interface/themes/wcpl/images/access_ebook.png' alt='Access eBook'/></a>").show();
							}
						}
					}
					
					// Load call number
					var callNumberSpan= $('#callNumberValue' + elemId);
					if (callNumberSpan.length > 0){
						var callNumber = items[i].callnumber;
						if (callNumber){
							callNumberSpan.html(callNumber);
						}else{
							callNumberSpan.html("N/A");
						}
					}
					
					// Load location
					var locationSpan= $('#locationValue' + elemId);
					if (locationSpan.length > 0){
						var availableAt = items[i].availableAt;
						if (availableAt){
							locationSpan.html(availableAt);
						}else{
							var location = items[i].location;
							if (location){
								locationSpan.html(location);
							}else{
								locationSpan.html("N/A");
							}
						}
					}
					
					// Load status
					var statusSpan= $('#statusValue' + elemId);
					if (statusSpan.length > 0){
						var status = items[i].status;
						if (status){
							if (status == "Available At"){
								status = "Available";
							}
							statusSpan.html(status);
						}else{
							statusSpan.html("Unknown");
						}
						
						var statusClass = items[i]['class'];
						if (statusClass){
							statusSpan.addClass(statusClass);
						}
					}
					
					// Load Download Link
					var downloadLinkSpan= $('#downloadLinkValue' + elemId);
					if (downloadLinkSpan.length > 0){
						var isDownloadable = items[i].isDownloadable;
						if (isDownloadable == 1){
							var downloadLink = items[i].downloadLink;
							var downloadText = items[i].downloadText;
							$("#downloadLinkValue" + elemId).html("<a href='" + decodeURIComponent(downloadLink) + "'>" + downloadText + "</a>");
							$("#downloadLink" + elemId).show();
						}
					}
					$('#holdingsSummary' + elemId).addClass('loaded');
				}catch (err){
					//alert("Unexpected error " + err);
				}
			}
			// Check to see if the Request selected button should show
			if (numHoldable > 0){
				$('.requestSelectedItems').show();
			}
		}).error(function(jqXHR, textStatus, errorThrown){
			//alert("Unexpected error trying to get status " + textStatus);
		});
	}
		
	if (callGetEContentStatusSummaries)
	{
		$.ajax({
			url: eContentUrl, 
			success: function(data){
				var items = $(data).find('item');
				$(items).each(function(index, item){
					var elemId = $(item).attr("id") ;
					$('#holdingsEContentSummary' + elemId).replaceWith($(item).find('formattedHoldingsSummary').text());
					if ($(item).find('showplacehold').text() == 1){
						$("#placeEcontentHold" + elemId).show();
					}else if ($(item).find('showcheckout').text() == 1){
						$("#checkout" + elemId).show();
					}else if ($(item).find('showaccessonline').text() == 1){
						if ($(item).find('accessonlineurl').length > 0){
							var url = $(item).find('accessonlineurl').text();
							var text = $(item).find('accessonlinetext').text();
							$("#accessOnline" + elemId + " a").attr("href", url).text($("<div/>").html(text).text());
						}
						$("#accessOnline" + elemId).show();
						
					}else if ($(item).find('showaddtowishlist').text() == 1){
						$("#addToWishList" + elemId).show();
					}
					
					if ($("#statusValue" + elemId).length > 0){
						var status = $(item).find('status').text();
						$("#statusValue" + elemId).text(status);
						var statusClass = $(item).find('class').text();
						if (statusClass){
							$("#statusValue" + elemId).addClass(statusClass);
						}
					}
					$('#holdingsEContentSummary' + elemId).addClass('loaded');
				});
			}
		});
	}
	
	// Get OverDrive status summaries one at a time since they take several
	// seconds to load
	for (var j=0; j<GetOverDriveStatusList.length; j++) {
		var overDriveUrl = path + "/Search/AJAX?method=GetEContentStatusSummaries";
		overDriveUrl += "&id[]=" + encodeURIComponent(GetOverDriveStatusList[j]['id']);
		$.ajax({
			url: overDriveUrl, 
			success: function(data){
				var items = $(data).find('item');
				$(items).each(function(index, item){
					var elemId = $(item).attr("id") ;
					$('#holdingsEContentSummary' + elemId).replaceWith($(item).find('formattedHoldingsSummary').text());
					if ($(item).find('showplacehold').text() == 1){
						$("#placeEcontentHold" + elemId).show();
					}else if ($(item).find('showcheckout').text() == 1){
						$("#checkout" + elemId).show();
					}else if ($(item).find('showaccessonline').text() == 1){
						$("#accessOnline" + elemId).show();
					}else if ($(item).find('showaddtowishlist').text() == 1){
						$("#addToWishList" + elemId).show();
					}
					if ($("#statusValue" + elemId).length > 0){
						var status = $(item).find('status').text();
						$("#statusValue" + elemId).text(status);
						var statusClass = $(item).find('class').text();
						if (statusClass){
							$("#statusValue" + elemId).addClass(statusClass);
						}
					}
					$('#holdingsEContentSummary' + elemId).addClass('loaded');
				});
			}
		});
	}
	
	//Clear the status lists so we don't reprocess later if we need more status summaries.. 
	GetStatusList = new Array();
	GetEContentStatusList = new Array();
	GetOverDriveStatusList = new Array();
}

function getSeriesInfo(isbn){
	GetSeriesList[GetSeriesList.length] = isbn;
}

function doGetSeriesInfo(){
	var now = new Date();
	var ts = Date.UTC(now.getFullYear(),now.getMonth(),now.getDay(),now.getHours(),now.getMinutes(),now.getSeconds(),now.getMilliseconds());

	var url = path + "/Search/AJAX?method=GetSeriesInfo";
	for (var i=0; i<GetSeriesList.length; i++) {
		url += "&isbn[]=" + encodeURIComponent(GetSeriesList[i]);
	}
	url += "&time="+ts;
	$.getJSON(url,function(data){
		if (data.success){
			$.each(data.series, function(key, val){
				$(".series" + key).html(val);
			});
		}
	});

}

function getSaveStatuses(id)
{
		GetSaveStatusList[GetSaveStatusList.length] = id;
}

function doGetSaveStatuses()
{
		if (GetSaveStatusList.length < 1) return;

		var http = createRequestObject();
		var now = new Date();
		var ts = Date.UTC(now.getFullYear(),now.getMonth(),now.getDay(),now.getHours(),now.getMinutes(),now.getSeconds(),now.getMilliseconds());

		var url = path + "/Search/AJAX?method=GetSaveStatuses";
		for (var i=0; i<GetSaveStatusList.length; i++) {
				url += "&id" + i + "=" + encodeURIComponent(GetSaveStatusList[i]);
		}
		url += "&time="+ts;

		http.open("GET", url, true);
		http.onreadystatechange = function()
		{
				if ((http.readyState == 4) && (http.status == 200)) {

						var response = http.responseXML.documentElement;
						var items = response.getElementsByTagName('item');

						for (var i=0; i<items.length; i++) {
								var elemId = items[i].getAttribute('id');

								var result = items[i].getElementsByTagName('result').item(0).firstChild.data;
								if (result != 'False') {
										var lists = eval('(' + result + ')');
										var listNames = 'Part of these lists:';
										for (var j=0; j<lists.length;j++) {
												listNames += '<br/>';
												if (lists[j].link.length > 0){
													listNames += "<a href='" + lists[j].link + "'>" + jsEntityEncode(lists[j].title) + "</a>";
												}else{
													listNames += jsEntityEncode(lists[j].title);
												}
										}
										$('#lists' + elemId).innerHTML = '<li>' + listNames + '</li>';
								}
						}
				}
		};
		http.send(null);
}

function getSubjects(phrase)
{
		var liList = '';
		var http = createRequestObject();
		http.open("GET", path + "/Search/AJAX?method=GetSubjects&lookfor=" + phrase, true);
		http.onreadystatechange = function(){
				if ((http.readyState == 4) && (http.status == 200)) {
						var response = http.responseXML.documentElement;
						if (subjects = response.getElementsByTagName('Subject')) {
								for (i = 0; i < subjects.length; i++) {
										if (subjects.item(i).firstChild) {
												liList = liList + '<li><a href="">' + subjects.item(i).firstChild.data + '</a></li>';
										}
								}
								document.getElementById('subjectList').innerHTML = liList;
						}
				}
		};
		http.send(null);
}

function setCookie(c_name,value,expiredays)
{
		var exdate = new Date();
		exdate.setDate(exdate.getDate()+ expiredays);
		document.cookie = c_name + "=" + escape(value) +
				((expiredays==null) ? "" : ";expires=" + exdate.toGMTString());
}

function getCookie(c_name)
{
		if (document.cookie.length > 0)
		{
				c_start = document.cookie.indexOf(c_name + "=");
				if (c_start != -1){ 
						c_start = c_start + c_name.length + 1;
						c_end = document.cookie.indexOf(";",c_start);
						if (c_end == -1) 
								c_end = document.cookie.length;
						return unescape(document.cookie.substring(c_start,c_end));
				} 
		}
		return "";
}

function parseQueryString(qs, term)
{
		qs = qs + "";
		var list = new Array();
		var elems = qs.split("&");
		for (var i=0; i<elems.length; i++) {
				var pair = elems[i].split("=");
				if (pair[0].substring(0, term.length) != term) {
						list.push(elems[i]);
				}
		}
		return list.join('&');
}

function moreFacets(name)
{
	$("#more" + name).hide();
	$("#narrowGroupHidden_" + name).show();
}

function lessFacets(name)
{
	$("#more" + name).show();
	$("#narrowGroupHidden_" + name).hide();
}

function getProspectorResults(prospectorNumTitlesToLoad, prospectorSavedSearchId){
	var url = path + "/Search/AJAX";
	var params = "method=getProspectorResults&prospectorNumTitlesToLoad=" + encodeURIComponent(prospectorNumTitlesToLoad) + "&prospectorSavedSearchId=" + encodeURIComponent(prospectorSavedSearchId);
	var fullUrl = url + "?" + params;
		$.ajax({
		url: fullUrl,
		success: function(data) {
			var prospectorSearchResults = $(data).find("ProspectorSearchResults").text();
			if (prospectorSearchResults) {
					if (prospectorSearchResults.length > 0){
						$("#prospectorSearchResultsPlaceholder").html(prospectorSearchResults);
					}
				}
	}
	});
}

function getStatuses(id)
{
		GetStatusList[GetStatusList.length] = id;
}

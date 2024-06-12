<%@ page contentType="text/html"%>
<%@ page language="java" import="java.util.*,com.cht.pnm.access.get.*" pageEncoding="UTF-8"%>
<%
	int _pid = 303;
	ARProject _arProject = new ARProject(_pid);
	_arProject.loadInfo();
	session.setAttribute("AR_PROJECT"+_pid,_arProject);
	String _title = _arProject.getpName();
	
	int _channelCount = 0;
	String[] _theChannelName= new String[0];
	  Channel[][] _theChannel = new Channel[0][0];		
	try{
		_channelCount = _arProject.GetChannelCount();
		_theChannel = _arProject.GetThreePlatformChannelList();
		_theChannelName= _arProject.Get3PlatformChannelName();
	}catch(Exception e){
			
	}	
	

%>
<html>
<head>
<title>巴黎奧運網路監視</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="/js/jquery.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>	
<link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet">  
	<script src="/js/jquery-ui.min.js"></script>	
	<link rel="stylesheet" type="text/css" href="/css/filker/jquery-ui.min.css">	
	<link rel="stylesheet" type="text/css" href="/js/jqGrid/css/ui.jqgrid.css" />		
	<script src="/js/jqGrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
	<script src="/js/jqGrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/js/jqGrid/changeLine.css" />		
	<script src="/js/jquery-ui-timepicker-addon.js"></script>
	<link rel="stylesheet" href="/css/jquery-ui-timepicker-addon.css">		
	
	<style type="text/css">
		.panel{
			    margin-bottom: 5px;
		}
	</style>
	<script src="/xss-filters.min.js"></script>
	<script type="text/javascript">
	
	var AuCount = 0;
	
	var refreshMin = 1;
	var refreshTime = refreshMin*10;			// 1 分鐘
	var _historyTime = "";						// 歷史查詢時間
	var _isHistory = false;
	
	var isReLoad = false;

	var _urlcdnTotalInfo ="/modDashBoard/AudienceAna/json/cdnTotalInfo.jsp";			//  cdn Total Info
	var _urlMetric = "/modDashBoard/AudienceAna/games/getMetricJSON.jsp"; 												// MOD指標
	var _urlEram = "/modDashBoard/AudienceAna/games/getEram.jsp";

	var _urlcurPlatformAR ="/modDashBoard/AudienceAna/json/currentPlatformAR.jsp";		//	目前各平台收視數
	var _urltodayMaxAR ="/modDashBoard/AudienceAna/json/todayMaxAR.jsp";				//  本日最大值
	var _url24MaxAR ="/modDashBoard/AudienceAna/json/last24AR.jsp";						//  24小時內最大值
	var _urlmaxAR ="/modDashBoard/AudienceAna/json/maxAR.jsp";							//  期間最大值

	var _urlChannelStatus ="/modDashBoard/ajaxL3Info.jsp";				//  頻道狀態
	var _MODCur = 0;		// MOD加總紀錄，會有時間差 個頻道會不一樣
	var _isEst = false;		// 是否推估
	var _todayMax = 0;		// 本日最高，推估模式小於本日最高時啟用
	var _estValue = 0;
	//=============================
	//頻道資訊
	//=============================
	var _ChannelCount=<%=_channelCount%> ;
    var _channelNames = new Array(_ChannelCount);
    <%	for(int i= 0 ; i < _channelCount; i ++){ %>
	_channelNames[<%=i%>] = 'ch<%=_theChannel[i][0].getId()%>';
	<% 	}%>



	var _PictureQualityCount = 0;
	//==============================
	// 更新時間
	//==============================
	function pageRefresh(){
		refreshTime -= 1;	
		if (refreshTime==0){
			if(_isHistory){		
			
			}else{
				_historyTime="";					// 歷史查詢時間歸0
				$('#data_measure').val("");
				refreshContent();
				_PictureQualityCount++;
				if(_PictureQualityCount%2==0)
					loadPictureQuality();
				if(_PictureQualityCount>10000)
					_PictureQualityCount =0;
			}
		}else{			
		}
		cleartime = setTimeout("pageRefresh()",1000);
	}
	
	//==============================
	// 數字格式化
	//==============================
	function commafy(num){ 
		if(num < 1){ 
			if(num ==0 )
				return 0;
			else{
				var _num = num.toFixed(1);
				return _num;
			}
		}
		else{		
				num = num+""; 
				var re=/(-?\d+)(\d{3})/ ;
				while(re.test(num)){ 
					num=num.replace(re,"$1,$2") ;
				} 
				return num; 
		}
	}
	
	function commafyFloat(num){ 
		if(num < 1){ 
			if(num ==0 )
				return 0;
			else{
				var _num = num.toFixed(1);
				return _num;
			}
		}
		else{		
			var _num = new Number(num);
			_num = _num.toFixed(2);
			num = _num+""; 
			var re=/(-?\d+)(\d{3})/ ;
			while(re.test(num)){ 
				num=num.replace(re,"$1,$2") ;
			} 
			return num; 
		}
	}
	
	function commafyBiterate(num){ 
		if(num < 1){ 
			if(num ==0 )
				return 0;
			else{
				var _num = num.toFixed(3);
				return _num;
			}
		}
		else{		
				 var _num = num.toFixed(3);
				 return num; 
		}
	}
		
		

	//==============================
	// CDN 比例, 總容量4 T 後續用程式調	 
	//==============================
	 	var _bwRate= 0;  
		var _bwRate24= 0; 
	function commafyCDN(num, theT){ 
		if(num < 1){ 
			if(num ==0 )
				return 0;
			else{
				var _num = num.toFixed(1);
				return _num;
			}
		}
		else{		
			// 換算 CDN 規則 轉換   / 1000 /1000 /1000  =>  /1000
		
			// 換算G
			var unit ="Gbps";
			num = num/1000  ;
			
			if(num>1000){
				num = num/1000  ;
				unit="Tbps";
			}
			var _num = new Number(num);
			_num = _num.toFixed(2);
			num = _num+""; 
			var re=/(-?\d+)(\d{3})/ ;
			while(re.test(num)){ 
				num=num.replace(re,"$1,$2") ;
			} 

			if(theT=="max"){				
				if(unit=="Tbps"){
					_bwRate =  (num/3.5)*100;
				}else if(unit=="Gbps"){
					_bwRate =  (num/3500)*100;
				}
			}else if(theT=="max24"){
				if(unit=="Tbps"){
					_bwRate24 =  (num/3.5)*100;
				}else if(unit=="Gbps"){
					_bwRate24 =  (num/3500)*100;
				}				
			}


			return num+unit; 
		}
	}


		
	
	//==============================
	// 更新CDN 資訊
	//==============================
	function getCDN_Info(){			
		// 防止因catch 無更新
		var gInfo = {timeStamp:"" };			
		gInfo.timeStamp = new Date().getTime();
		$.ajax({
			  url: _urlcdnTotalInfo,  
				method: 'POST',
				data: gInfo,		  
				success: function( data ) {      

					var _bandwidth= xssFilters.inHTMLData(data.bandwidth);  
					var _bandwidth24Max = data.bandwidth24max;	
					var _status = xssFilters.inHTMLData(data.status);		
					
					var _bandwidthStr =commafyCDN(_bandwidth,'max');
					var _bandwidth24Str =commafyCDN(xssFilters.inHTMLData(_bandwidth24Max[0]),'max24');

					$("#cdn_bandwidth").html( "<div class=\"broadmessage\">"+_bandwidthStr+"("+_bwRate.toFixed(2)+"%)"+"</div>");
					
					$('#cdn_status').attr("src", "/img/light2/0"+_status+".png"); 
					if(_isEst==true){												
						var _estValue = data.connect[0];
						if(_estValue<_todayMax)
							_estValue = _todayMax;
						$("#onlineChtVideo").html("<span class=\"broadmessage\" style=\"color:red;\">"+commafy(xssFilters.inHTMLData(data.connect[0]))+ "(推估)</span>"); 
					}
				/*
					if(_status==1){
						$('#cdn_status').attr("src", "/img/light2/01.png"); 
					}else if(_status==2){
						$('#cdn_status').attr("src", "/img/light2/02.png"); 			//YELLOW			
					}else if(_status==3){
						$('#cdn_status').attr("src", "/img/light2/03.png"); 			//YELLOW			
					}else if(_status==4){
						$('#cdn_status').attr("src", "/img/light2/04.png"); 						
					}else if(_status==5){
						$('#cdn_status').attr("src", "/img/light2/05.png"); 
					}
			*/				
					
					
					
					$("#cdn_bandwidth_24max").html( "<div class=\"broadmessage\">"+_bandwidth24Str+"("+_bwRate24.toFixed(2)+"%)"+"</div><div class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_bandwidth24Max[1].replace("2024-", ""))  + ")</div>");
					},    // END success    	 
				  error:function (xhr, ajaxOptions, thrownError){
					 // alert(xhr.status);
					 // alert(thrownError);
				  }    		
			});      // END ajax
		
	}
	
	
	//==============================
	// 更新申告數
	//==============================
	function getComplaintInfo(){			
		// 防止因catch 無更新
		var gInfo = {timeStamp:"" };			
		gInfo.timeStamp = new Date().getTime();
		$.ajax({
			  url: _urlMetric,  
				method: 'POST',
				data: gInfo,		  
				success: function( data ) {      
						
					$("#MOD4").html(xssFilters.inHTMLData(data.MOD4));
					$("#HAMI4").html(xssFilters.inHTMLData(data.HAMI4));
					$("#MOD5").html(xssFilters.inHTMLData(data.MOD5));
					$("#HAMI5").html(xssFilters.inHTMLData(data.HAMI5));
					
				  },    // END success    	 
				  error:function (xhr, ajaxOptions, thrownError){
					 // alert(xhr.status);
					 // alert(thrownError);
				  }    		
			});      // END ajax
		
	}
	
	
	//==============================
	// 更新ERAM
	//==============================
	function getERAM_Info(){	
		var gInfo = {timeStamp:"" };			
		gInfo.timeStamp = new Date().getTime();
		$.ajax({
			  url: _urlEram,  
				method: 'POST',
				data: gInfo,		  
				success: function( data ) {    
					var eramDiv="";			

					var _theDatas = data;
					
					if(_theDatas.length>0){
						for(var i=0; i < _theDatas.length; i++){
							var _tempObj = _theDatas[i];
							var alarmDescription = _tempObj.alarmDescription.replace("MOD局端設備維運障礙","");	
							alarmDescription =xssFilters.inHTMLData(alarmDescription);
							var alarmDescriptions = alarmDescription.split("應變措施");		
							
							var sn = xssFilters.inHTMLData(_tempObj.sn);
							sn = sn.replace("F", "");
							if(sn==""){
								eramDiv = eramDiv + "●" + alarmDescription + "<br>";	
							}else{
								var indexALL = alarmDescription.indexOf("全區障礙");
								var indexRegion = alarmDescription.indexOf("區域障礙");					
								if(indexALL<0 && indexRegion<0){	
									eramDiv = eramDiv + "<a href='#' onClick='openurlERAM(\"http://eram.cht.com.tw/eram/FaultMgrServlet?cmd=query_one&seq="+sn+"\")'>●" + alarmDescriptions[0]  + "</a><br>";	
								}else{
									var _rMessage  = alarmDescriptions[0].replace("全區障礙推論,原因:","");
									_rMessage  = _rMessage.replace("區域障礙推論,原因:","");
									var _realTimeMessage = _realTimeMessage + "<span onClick='openurlERAM(\"http://eram.cht.com.tw/eram/FaultMgrServlet?cmd=query_one&seq="+sn+"\")'>●" + _rMessage+ "</span>";		
								}					
							}
						}
					}else{
						 eramDiv="無障礙改接公告";
					}
					 $('#eRAMList').html(eramDiv);
				
				  },    // END success    	 
				  error:function (xhr, ajaxOptions, thrownError){
					 // alert(xhr.status);
					 // alert(thrownError);
					  $('#eRAMList').html("");
				  }    		
			});      // END ajax
	
	}
				

	
	

	
	
	//==========================
	// 頻道狀態更新
	//==========================
	function getChannelInfo() {   	    	 
    	
		var gInfo = { timeStamp:"",measureDate:""};
			gInfo.measureDate = $('#refreshTime').html();
			$.ajax({
				  url: "/modDashBoard/AudienceAna/games/getChannelInfo.jsp",  			  
				  type: "POST",				  
				  data: gInfo,	  
				  dataType: 'json',
					success: function( rData ){
						_JSONObjList = rData;
						if(rData.length>0){
							drawjqTable();
						}
					  }  // END success		
					  ,error: function(){
						  alert("讀取失敗!");
					  }, complete: function(){	
							
					  }		
				});      // END ajax    	
	};		
	
		function cus_status( cellvalue, options, rowObject ){	
		if(cellvalue=="normal")		
			return "<img src=\"/img/light/01.png\" class=\"statusIcon\"  >"	;
		else
			return cellvalue;
	}
	
	 function drawjqTable(){
			//https://argus.cht.com.tw/backbone/MBH/motis/motisMain.jsp?leased=2011144N106
			
				
				var theColNames = ["頻道號","頻道名稱","收視數","服務狀態"];
				var theColModel = [
						{name:'channelID',index:'channelID',width : 30,align:'center'},
						{name:'cname',index:'cname',width : 50,sorttype:'string', align:'center'},
						{name:'audioNum',index:'audioNum',width : 30,sorttype:'string', align:'center' },
						{name:'status',index:'status',width : 30,sorttype:'string', align:'center',formatter:cus_status}
					];
					
		
				var myRowFormatter = function(elTr, oRecord) {    
				    return true;
				}; 
			  
	        	$("#dmLoading").hide();	
				if(isReLoad){
						//alert(isReLoad+" reload");
	    				drawjqTableReload($("#TList"),_JSONObjList);					
	    		}else{
		    		$("#TList").jqGrid({
						data: _JSONObjList, 
						datatype: "local",
						height: "auto",	
						autowidth: true, // 自動欄寬           
						colNames: theColNames,
						colModel:theColModel,
						rowNum:8,
						rowList:[8,50,100],
						caption: ""					
					});		
					isReLoad = true;
	    		}	
		  }  
		    
	function drawjqTableReload(tableDiv, theData){
		tableDiv.jqGrid('clearGridData');
		tableDiv.jqGrid('setGridParam', {data: theData});
		tableDiv.trigger('reloadGrid');
	}
	
	
		
	function resizeTable(){
		$("#TList").jqGrid('setGridWidth', parseInt($('.containerPlace').width()) - 5);    
	}	
	  
	window.onresize = function(event) {
		resizeTable();
	};
	
	
	
	function openurl(urlpage,id){	
		if( urlpage.indexOf("?") !=-1 ){
			urlpage+="&measureDate="+xssFilters.inHTMLData(_historyTime);
		}else{
			urlpage+="?measureDate="+xssFilters.inHTMLData(_historyTime);
		}
		//window.open(urlpage,'modDlink'+id,'width=1024,height=768, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');		
		window.open(urlpage,'MOBILE'+id,'width=1024,height=768, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');	
	}
	
	function openurlERAM(urlpage){
		window.open(urlpage,'modERAM','width=1024,height=768, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');	
	}
	
	
	
	
	//=====================================
	// 更新線上收視資料
	//=====================================	
	function updateCurPlatformTable(){
		// 防止因catch 無更新
		var gInfo = {timeStamp:"",pid:"<%=_pid%>" };			
		gInfo.timeStamp = new Date().getTime();
		
		$.ajax({
				url: _urlcurPlatformAR,  		  
				method: 'POST',
				data: gInfo,
				success: function( data ) {
					//alert("ok");
					_curAR = data;	  
					var _MOD = data.MOD;
					var _CHT_VIDEO= data.chtVideo;  
					var _ELTA= data.ELTA;  				
					var _LITV= data.LITV;  				

					
					_MODCur = _MOD[0];
					
					$("#onlineMOD").html( "<span class=\"broadmessage\">"+ commafy(xssFilters.inHTMLData(_MOD[0]))  + "</span>");
					
					if(_isEst==false){
						$("#onlineChtVideo").html("<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_CHT_VIDEO[0]))+ "</span>"); 
					}
					//$("#onlineELTA").html("<div class=\"broadmessage\">"+commafy(_ELTA[0])+ "</div>"); 
					//$("#onlineLITV").html("<div class=\"broadmessage\">"+commafy(_LITV[0])+ "</div>"); 

					$("#channeLoading").hide();
					
				  },    // END success    		 				  
				  error:function (xhr, ajaxOptions, thrownError){
				 
				  }    
			});      // END ajax	
	}
	
	
	function getTodayMAXAR(){		
	
		// 防止因catch 無更新
		var gInfo = {timeStamp:"",pid:"<%=_pid%>" };			
		gInfo.timeStamp = new Date().getTime();

		$.ajax({
			url: _urltodayMaxAR,  		  
			method: 'POST',
			data: gInfo,
			success: function( theData ) {   
				theData	= xssFilters.inHTMLData(theData);
				var _maxRecord = eval('(' + theData + ')');
				_todayMax = _maxRecord[3][0];
				$("#todayMaxMOD").html( "<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_maxRecord[0][0]))+"</span><br><span class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_maxRecord[0][1]).replace("2024-", "")  + ")</span>");
				$("#todayMaxChtVideo").html("<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_maxRecord[3][0]))+"</span><br><span class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_maxRecord[3][1]).replace("2024-", "")  + ")</span>");
				
							
				
			  },    // END success    	 
			  error:function (xhr, ajaxOptions, thrownError){
				 // alert(xhr.status);
				 // alert(thrownError);
			  }    		
		});      // END ajax
		
	}
	
	
	//=====================================
	// 取得24小時線上收視資料
	//=====================================	
	function get24MAXAR(){			
		// 防止因catch 無更新
		var gInfo = {timeStamp:"",pid:"<%=_pid%>" };			
		gInfo.timeStamp = new Date().getTime();
		
		$.ajax({
				url: _url24MaxAR,  		  
				method: 'POST',
				data: gInfo,
				success: function( data ) {      					
					
					var _MOD = data.MOD;
					var _CHT_VIDEO= data.chtVideo;  	

									
					$("#max24MOD").html( "<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_MOD[0]))+"</span><br><span class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_MOD[1]).replace("2024-", "")  + ")</span>");
					$("#max24ChtVideo").html( "<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_CHT_VIDEO[0]))+"</span><br><span class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_CHT_VIDEO[1]).replace("2024-", "")  + ")</span>");
					
					
				  },    // END success    	 
				  error:function (xhr, ajaxOptions, thrownError){
					 // alert(xhr.status);
					 // alert(thrownError);
				  }    		
			});      // END ajax
		
	}
	
	
	//=====================================
	// 取得期間最大線上收視資料
	//=====================================		
	function getMAXAR(){
		
		// 防止因catch 無更新
		var gInfo = {timeStamp:"",pid:"<%=_pid%>" };			
		gInfo.timeStamp = new Date().getTime();
		$.ajax({
			url: _urlmaxAR,  		  
			method: 'POST',
			data: gInfo,
			success: function( theData ) {      	
				theData = xssFilters.inHTMLData(theData);
				// [[0,'2016-07-23 16:05'],[96,'2016-07-22 18:35'],[274,'2016-07-22 20:50'],[274,'2016-07-22 20:50'],[1151,'2016-07-21 00:00'],[2,'2016-07-22 00:00']]
				var _maxRecord = eval('(' + theData + ')');
				
				$("#maxMOD").html(   "<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_maxRecord[0][0]))+"</span><br> <span class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_maxRecord[0][1]).replace("2024-", "")  + ")</span>");
				$("#maxChtVideo").html("<span class=\"broadmessage\">"+commafy(xssFilters.inHTMLData(_maxRecord[3][0]))+"</span><br><span class=\"broadsubmessage\">("+ xssFilters.inHTMLData(_maxRecord[3][1]).replace("2024-", "")  + ")</span>");	

				
			  },    // END success    	 
			  error:function (xhr, ajaxOptions, thrownError){
				 // alert(xhr.status);
				 // alert(thrownError);
			  }    		
		});      // END ajax
		
	}
		
		
		
	//==============================
	// 頻道狀態
	//==============================
	function getChannelStatus(){		
		<%
			for(int i= 0 ; i < _channelCount; i ++){
				String displayCh = "ch"+_theChannel[i][0].getId();
		%>
			$('#status<%=displayCh%>').attr("src", "/img/light/01.png"); 
		<%
			}
		%>			
		ajaxLoadInfo(true,"1001");
		ajaxLoadInfo(true,"1002");
	}
	
	function ajaxLoadInfo(isCur,area){
			var gInfo = { platform:'channel',area:'',measureDate:'',timeStamp:"",ip:'',stype:''};
			gInfo.timeStamp=new Date();
			gInfo.area = area;

			if(isCur==false){
				gInfo.measureDate = $('#data_measure').val();
			}				
			//gInfo.measureDate ='2018/12/17 14:19';  // CASE 單一 ch265
			//gInfo.measureDate ='2019/12/25 04:52';  // CASE 雙斷  ch615 

			
			$.ajax({
				url: _urlChannelStatus,  
				method: 'POST',
				data: gInfo,
				dataType: 'json',		
			   	success: function( data ) {	
								var _theMetric = data.Metrics;
								var _LossValue = _theMetric[2].atts[0].value;
								var _encoderValue  = _theMetric[3].atts[0].value;	
								
								//_LossValue =_LossValue.replace('615', '201');
								//_encoderValue =_encoderValue.replace('615', '201');
								
								//alert(_LossValue + "," + _encoderValue);
								checkChannelStatus(_LossValue,area);
								checkChannelStatus(_encoderValue,area);
								
			    		  }    // END success				
			    		  ,error: function(){
			    			  alert("讀取失敗!");
			    		  },
						  complete:function(){
								
						 }
					
					});      // END ajax    
		}
		
		function checkChannelStatus(errorMessage,area){
			//alert( errorMessage.indexOf(_channelNames[i]));
			for(var i = 0 ; i < _ChannelCount; i++){
				//alert(_channelNames[0]);				
				if(errorMessage.indexOf(_channelNames[i])>-1){
					var statusItem= xssFilters.inHTMLData("status"+_channelNames[i].trim());
					$('#'+statusItem).attr("src", "/img/light/05.png"); 
					// 1 green,2 red,3 gray, 4 orange, 5 yellow, 6 blue
					
					if(area=='1002'){
						var _curstatus = $('#'+statusItem).attr("src"); 
						if(_curstatus.indexOf(05)>-1)
							$('#'+statusItem).attr("src", "/img/light/04.png"); 
						else
							$('#'+statusItem).attr("src", "/img/light/05.png"); 
						//alert(_curstatus);
					}
					
				}
			}
		}
		
		
	//=====================================
	// 更新線上收視資料
	//=====================================	
	function updateCurMOD_AR(){
		// 防止因catch 無更新
		var gInfo = {timeStamp:"",pid:"<%=_pid%>" };			
		gInfo.timeStamp = new Date().getTime();
		
		$.ajax({
				url: '/modDashBoard/AudienceAna/json/jsonChannelMOD.jsp?pid=<%=_pid%>',  		  
				method: 'POST',
				data: gInfo,
				success: function( data ) {
										
					  <%
						for(int i= 0 ; i < 3; i ++){
							int _theIXD = i+1;
									String displayCh = "ch"+_theChannel[i][0].getId();
					%>
							$("#<%=displayCh%>num").html(xssFilters.inHTMLData(data.channel<%=_theIXD%>.data[2][1]));
					<%
						}
					%>	
					//var _200 = data.channel1.data[2][1];
					//var _201 = _MODCur-_200;
					

					//$("#ch201num").html(_201);

					
				  },    // END success    		 				  
				  error:function (xhr, ajaxOptions, thrownError){
				 
				  }    
			});      // END ajax	

	}
	
		
	
	//==============================
	// 初始呼叫
	//==============================
	$(document).ready(function() {
		
		$("#ruleInfo").hide();
		loadDisplayMode();
		updateCurPlatformTable();
		refreshTime = 1;	// 設1預設才會run
		changeRefreshTime();
		setTimeout("getCDN_Info()",400);	
		setTimeout("getComplaintInfo()",1500);	
		setTimeout("getERAM_Info()",600);	

		setTimeout("updateCurMOD_AR()",1200);	
		setTimeout("getTodayMAXAR()",1100);	
		setTimeout("get24MAXAR()",1100);	
		setTimeout("getMAXAR()",1800);	
		
		getChannelStatus();
		
		ajaxItemLoadServiceStatus();
		ajaxItemLoadISPStatus();

		//window.setInterval(getCDN_Info,60000);    // 1000 = 1 second,	  1 分鐘

	//	refreshContent(true);		
		pageRefresh();	

		//getChannelInfo();
		loadPictureQuality();
	}); 
	
	
		function refreshContent(){
			changeRefreshTime();
			
			// $('#iframeTK').attr("src", $('#iframeTK').attr("src"));

			if(AuCount>1){
				loadDisplayMode();
				updateCurPlatformTable();
				setTimeout("getCDN_Info()",400);	
				setTimeout("getComplaintInfo()",1500);	
				setTimeout("getERAM_Info()",600);	

				setTimeout("updateCurMOD_AR()",1200);	
				setTimeout("getTodayMAXAR()",1100);	
				setTimeout("get24MAXAR()",1100);	
				setTimeout("getMAXAR()",1800);					
				getChannelStatus();			
				
				ajaxItemLoadServiceStatus();
				ajaxItemLoadISPStatus();

				AuCount = 0;
			}else{
				AuCount++;
			}
		}
		
	
	function changeRefreshTime(){
		refreshTime = refreshMin*10;
		var nowTime = new Date();
		var refreshTimeText = nowTime.getFullYear()+'-'+(nowTime.getMonth()+1)+'-'+nowTime.getDate()+' '+ nowTime.getHours()+':';
		refreshTimeText += ((nowTime.getMinutes()<10)?"0":"")+nowTime.getMinutes();
		$('#refreshTime').html(refreshTimeText);
		$('#data_measure').html("");
	}	
	
	
	
	// ==================================
	// QOE 等服務
	// ==================================
	function ajaxItemLoadServiceStatus(){
				var gInfo = { timeStamp:""};
				gInfo.timeStamp = new Date().getTime();
				$.ajax({
						url: "/GNOC/OTT/jsonService_Status.jsp",		 			  
						type: "POST",				  
						data: gInfo,
			    		success: function( data ) {	
							changeImgColor(data);
			    		  }    // END success				
			    		  ,error: function(){
			    			  alert("讀取失敗!");
			    		  }
					});      // END ajax    
	 }	
	 
	// ==================================
	// ISP服務
	// ==================================
	function ajaxItemLoadISPStatus(){
				var gInfo = { timeStamp:""};
				gInfo.timeStamp = new Date().getTime();
				$.ajax({
						url: "/GNOC/ISP/jsonISP_Status.jsp",		 			  
						type: "POST",				  
						data: gInfo,
			    		success: function( data ) {	
							changeImgColor(data);
			    		  }    // END success				
			    		  ,error: function(){
			    			  alert("讀取失敗!");
			    		  }
					});      // END ajax    
	 }		
		
		
		
		
	function changeImgColor(data){
		if(data.length>0){									
			for(var i = 0 ; i < data.length; i ++){							
				var ajaxName = xssFilters.inHTMLData(data[i].name);			
				var ajaxStatus = xssFilters.inHTMLData(data[i].status);		
				var _imgName = "00.png";	  // gray 
				if(ajaxStatus=="1"){
					_imgName = "01.png";
				}else if(ajaxStatus=="2"){
					_imgName = "02.png";
				}else if(ajaxStatus=="3"){
					_imgName = "03.png";
				}else if(ajaxStatus=="4"){
					_imgName = "04.png";
				}else if(ajaxStatus=="5"){
					_imgName = "05.png";
				}
			$("#img"+ajaxName ).attr("src","/img/light2/"+_imgName);	
			}									
		}						
	}		
	
	
	
	//========================
	// 子頁面 QOE
	//========================
	function searchHisortyOTT(thetype){	
		window.open("/GNOC/OTT/QOE/eventSearch.jsp?_type="+thetype,'eventSearch','width=1024,height=768, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');	
	}
	
	//========================
	// 子頁面 DDOS
	//========================
	function searchHisortyDDOS(thetype){	
		window.open("/GNOC/OTT/eventSearch.jsp?_type="+thetype,'eventSearch','width=1024,height=768, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');	
	}
	
	//========================
	// 子頁面 ISP
	//========================
	function searchHisortyISP(){	
		window.open("/GNOC/ISP/",'eventSearchISP',' toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');	
	}	
	
	//========================
	// 目前畫質
	//========================
	function loadPictureQuality(){
		 $.ajax({
				  url: "/GNOC/MCMpages/CDN_FLOW/querySCCOTT_Token.jsp?commandType=status",  			  
				  type: "POST",				  
				  //data: gInfo,
					success: function( rData ) {
							// {"returnCode":"1","returnMessage":"成功","data":"q3"}
							var returnMessage = xssFilters.inHTMLData(rData.returnMessage);
							if(returnMessage="成功"){
								var _theDate = xssFilters.inHTMLData(rData.data);
								//  預設 : q0,q2,q7,q10,q14
								//  l2(43黃)：q3,q8
								//  l3(60橘)：q4,q9,q11,q15
								//  l4(70橘)：q5,q12
								//  l5(80紅)：q6,q13
								if(_theDate=="q5"  ){
									$("#curResolution").html(_theDate+"(預設值-進階低延遲)");	
								}else if(_theDate=="q6" ){
									$("#curResolution").html(_theDate+"(此設定建議用於CDN流量:>70%-進階低延遲)");									
								}else if(_theDate=="q7" ){
									$("#curResolution").html(_theDate+"(此設定建議用於CDN流量:>80%-進階低延遲)");										
								}else if(_theDate=="q8"  ){
									$("#curResolution").html(_theDate+"(預設值-低延遲)");	
								}else if(_theDate=="q9" ){
									$("#curResolution").html(_theDate+"(此設定建議用於CDN流量:>70%-低延遲)");									
								}else if(_theDate=="q10" ){
									$("#curResolution").html(_theDate+"(此設定建議用於CDN流量:>80%-低延遲)");										
								}else if(_theDate=="q11"  ){
									$("#curResolution").html(_theDate+"(預設值- 一般)");	
								}else if(_theDate=="q12" ){
									$("#curResolution").html(_theDate+"(此設定建議用於CDN流量:>70%- 一般)");									
								}else if(_theDate=="q13" ){
									$("#curResolution").html(_theDate+"(此設定建議用於CDN流量:>80%- 一般)");										
								}else if(_theDate=="q0" ){
									$("#curResolution").html(_theDate+"(預設值- 一般)");										
								}else{
									$("#curResolution").html(_theDate);										
								}
								
							}
								
							
					  }  // END success		
					  ,error: function(){
						  alert("讀取失敗!");
					  }, complete: function(){	
						
					  }		
				});      // END ajax    	
		 
	 }
	 
	 
	 //==============================================
	 // 推估模式判斷
	 //==============================================
	 // LOAD current Status
		function loadDisplayMode(){
			var _theurl = "/modDashBoard/AudienceAna/games/Estimate/getDisplayMode.jsp";
			$.ajax({
				  url: _theurl,  		  
				  cache: false,	
					success: function( data ) {	   					
							var _mode = data.mode;
						//	alert(_mode);
							if(_mode==1){
								_isEst=true;
							}else{
								_isEst=false;
							}
					  }    // END success
			
					  ,error: function(){
						//  alert(serviceType+" " + instanceName +" 讀取失敗!");
					  }
				
				});      // END ajax  
		}
		
		
		var _showRule = false;
		function showRule(){
			if(_showRule){				
				$("#ruleInfo").hide();
				_showRule = false;
			}else{
				$("#ruleInfo").show();
				_showRule = true;
			}
			
		}
	
	
	</script>
	
	<style type="text/css">		
		.InnderBody{
			margin-top :5px;
			margin-left :10px;
			margin-right :10px;
		}
		
		.panel-heading {
			padding: 4px 6px;	
		}
		.panel-body {
			padding: 5px;
		}
		
		.col-lg-1, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-md-1, .col-md-10, .col-md-11, .col-md-12, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-sm-1, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-xs-1, .col-xs-10, .col-xs-11, .col-xs-12, .col-xs-2, .col-xs-3, .col-xs-4, .col-xs-5, .col-xs-6, .col-xs-7, .col-xs-8, .col-xs-9 {
			position: relative;
			min-height: 1px;
			padding-right: 1px;
			padding-left: 1px;
		}
		
		.panel-right-btn {		
			float: right;
			margin-left: 0.5em;
		}
		
		.statusIcon{				
			width: 20px;
		}
		
		.circleLabelG {
		  width:80px;
		  height:80px; 
		  border-radius:80px;
		  border:solid 10px #5CB85C;		  
		  padding-top: 12px;
		  font-size: 24px;
		  font-weight:bold;
		}
		
		
	
		
		.ui-jqgrid .ui-jqgrid-htable .ui-th-div {
			height: 22px;
			font-size: 12px;
		}	
		
		.critiaclFont{
			color: red;
		}
		
				
		.majorFont{
			color: orange;
		}
		
		.titleicon{
			font-size: 20px;
		    cursor: pointer;
		}
		
		.titleicon:hover{
		    cursor: pointer;
		}
			
	</style>    
</head>
<body style="margin-left:5px;margin-right:15px;">
 	<div id="colMain" class ="InnderBody">		
		<div class="row" style="padding-right: 10px;padding-left: 10px;" >
			<div class="col-sm-8">
				<div><b style="font-size: 32px;">巴黎奧運網路監視</b>&nbsp;<a href="#" onclick="showRule()"><span class="glyphicon glyphicon-info-sign titleicon" style="font-size: 20px;"  ></span></a></div>
			</div>
			<div class="col-sm-4">
				<table class="panel-right-btn">
							<tr><td>
							<div id="qrytime" style = "padding-top:5px"><b>呈現時間:</b>&nbsp;<span id="refreshTime">讀取中...</span></div>		
							</td></tr>						
							<tr>
							<!--<td>								
							<span id="qrytimeCustom" ><b>查詢時段:</b>	
											<input  id="data_measure" size="14" type="text" value="" readonly >
								</span>	
								<button type="button" class="btn btn-primary btn-xs " onclick="refreshContent(false)">查詢</button>								
							</td>  -->							
							</tr>						
					</table>	
			</div>	
		</div>

	<div class="row">	
		<div class="col-md-8 col-lg-9">			
			<div class="col-md-12">	
				<div class="panel panel-primary" style="height: 505px; margin: 1px auto; ">				
					<div class="panel-body" style="padding:0px" >					
						<iframe id="iframeTK" src="/modDashBoard/TopoN/Topology/topo.jsp" frameborder="0" height="503px" width="100%" scrolling="no"></iframe> 						
					</div>
				</div>					
			</div>
			
			
			<div class="col-md-2 ">	
				<div class="panel panel-primary">
						<div class="panel-heading"><b >ISP互聯</b> </div>					
						<!-- <div class="panel-body containerPlace" style="height: 234px; margin: 0 auto" >	 	-->
						<div class="panel-body containerPlace" style=" margin: 0 auto" >	 
							<table class="table-striped" style="margin-bottom:1px; width:100% "><tbody>														
							<tr align="center" style="height: 40px;">
								<td ><a href="#" onclick="searchHisortyISP()"><img id="imgISP_ALL" src="/img/light/01.png" class="statusIcon" ></a></td>
							</tr>
							</tbody></table>
						</div>
				</div>
			</div>
			
			<div class="col-md-4 ">	
				<div class="panel panel-primary">
						<div class="panel-heading"><b >QOE監測</b> </div>					
						<!-- <div class="panel-body containerPlace" style="height: 234px; margin: 0 auto" >	 	-->
						<div class="panel-body containerPlace" style=" margin: 0 auto" >	 
							<table class="table-striped" style="margin-bottom:1px; width:100% "><tbody>		
							<tr align="center">								
								<td >Hami網站</td>
								<td >ELTA網站</td>
								<td >Hami域名解析</td>
							</tr>						
							<tr align="center">
								<td ><a href="#" onclick="searchHisortyOTT('QOE_HamiVideo')"><img id="imgHami_WEB" src="/img/light/01.png" class="statusIcon" ></a></td>
								<td ><a href="#" onclick="searchHisortyOTT('QOE_ELTA')"><img id="imgELTA_WEB" src="/img/light/01.png" class="statusIcon" ></a></td>
								<td ><a href="#" onclick="searchHisortyOTT('QOE_HamiDNS')"><img id="imgHami_DNS" src="/img/light/01.png" class="statusIcon" ></a></td>
							</tr>
							</tbody></table>
						
						</div>
				</div>
			</div>	
			
			<div class="col-md-6  ">	
				<div class="panel panel-primary">
						<div class="panel-heading"><b >DDOS監測</b> </div>					
						<!-- <div class="panel-body containerPlace" style="height: 234px; margin: 0 auto" >	 	-->
						<div class="panel-body containerPlace" style=" margin: 0 auto" >	 
							<table class="table-striped" style="margin-bottom:1px; width:100% "><tbody>		
							<tr align="center">								
								<td >Hami網站</td>
								<td >ELTA網站</td>
								<td >Hami域名解析</td>
								<td >外雲(南二)</td>
							</tr>						
							<tr align="center">
								<td ><a href="#" onclick="searchHisortyDDOS('DDOS_HAMI')"><img id="imgDDOS_HAMI" src="/img/light/01.png" class="statusIcon" ></a></td>
								<td ><a href="#" onclick="searchHisortyDDOS('DDOS_ELTA')"><img id="imgDDOS_ELTA" src="/img/light/01.png" class="statusIcon" ></a></td>
								<td ><a href="#" onclick="searchHisortyDDOS('DDOS_HAMI_DNS')"><img id="imgDDOS_HAMI_DNS" src="/img/light/01.png" class="statusIcon" ></a></td>
								<td ><a href="#" onclick="searchHisortyDDOS('DDOS_CLOUD_TPS2')"><img id="imgDDOS_CLOUD_TPS2" src="/img/light/01.png" class="statusIcon" ></a></td>

							</tr>
							</tbody></table>
						
						</div>
				</div>		
			</div>
			
		
			<div class=" col-lg-4  col-md-6 ">			
				<div class="panel panel-primary ">
					<div class="panel-heading">
						<div><b>客 服 申 告 狀 況 (MOD/Hami Video)</b></div>
					</div>
					<div class="panel-body" style="height: 138px; margin: 0 auto">	 	
						<table width="100%" >
						<tr>	
							<td class="tableRightLine" width="50%" align="center" valign="center" style="padding-bottom: 10px;" ><b>累計30分鐘用戶申告數</b></td>
							<td width="50%" align="center" valign="center" style="padding-bottom: 10px;"><b>用戶大量申告事件</b></td>
						</tr>
						<tr>	
							<td class="tableRightLine" width="50%" align="center" valign="center"><div class="circleLabelG"> <span id="MOD4" class="declared" onClick="openurl('../LargeAlarmShow/show10minMODDeclaration.jsp','mod4')" >N</span>/<span id="HAMI4" class="declared" onClick="openurl('../LargeAlarmShow/show10minHamiVideoDeclaration.jsp','hami4')" >N</span> </div>
							</td>
							<td width="50%" align="center" valign="center" ><div class="circleLabelG" id="MOD5C">			
							<span id="MOD5" class="declared" onClick="openurl('../LargeAlarmShow/showLargeAlarm.jsp?type=MOD_Declaration','mod5')">0</span>/<span id="HAMI5" class="declared" onClick="openurl('../LargeAlarmShow/showLargeAlarm.jsp?type=HAMI_VIDEO_Declaration','hami5') ">0</span>		</div></td>
						</tr>				
						</table>										
					</div>
				</div>
			</div> 		
			
			<div class=" col-lg-8 col-md-6">						
				<div class="panel panel-primary">
					<div class="panel-heading">
						<h1 class="panel-title"><b>障&nbsp;礙&nbsp;/&nbsp;改&nbsp;接&nbsp;公&nbsp;告</b></h1>
					</div>
				<div class="panel-body" style="height: 140px; margin: 0 auto; overflow:auto;">
						<div id="eRAMList" ></div>
				</div>
				</div>						
			</div> 	
		
	
		</div>
		<div class="col-md-4 col-lg-3 ">	
			<div class="col-sm-12">	
				<div class="panel panel-primary" style="margin-bottom: 5px;">
					<div class="panel-heading" >
						<b>MOD&nbsp;收視數資訊</b>
					</div>
					<div id="" class="panel-body">	
						<table class="table-striped" style="margin-bottom:1px; width:100% "><tbody>
							<tr>
								<td></td>
								<td align="right">LIVE</td>
							</tr>	
							<tr>
								<td><div>線上:</div></td>
								<td align="right"><span id="onlineMOD">--</span> </td>
							</tr>
							<tr>
								<td><div class="conTitle" >本日線上最高:</div></td>
								<td align="right"><span id="todayMaxMOD">--</span></td>
							</tr>
							<tr>
								<td><div class="conTitle" >24小時內線上最高:</div></td>
								<td align="right"><span id="max24MOD">--</span></td>
							</tr>
							<tr>
								<td><div class="conTitle" >監視期間最高:</div></td>
								<td align="right"><span id="maxMOD">--</span></td>
							</tr>
						</tbody></table>		
					</div>
				</div>
			</div>	<!-- col-sm-12 -->	

			<div class="col-sm-12">	
				<div class="panel panel-primary" style="margin-bottom: 5px;">
					<div class="panel-heading">
						<b>HamiVideo&nbsp;收視數資訊</b>
					</div>
					<div id="" class="panel-body">									
						<table class="table-striped" style="margin-bottom:1px; width:100% "><tbody>		
						<tr>
							<td></td>
							<td align="right">LIVE</td>
						</tr>						
						<tr>
							<td><div class="conTitle" >線上:</div></td>
							<td align="right"><span id="onlineChtVideo">--</span></td>
						</tr>
						<tr>
							<td><div class="conTitle" >本日線上最高:</div></td>
							<td align="right"><span id="todayMaxChtVideo">--</span></td>
						</tr>
						<tr>
							<td><div class="conTitle" >24小時內線上最高:</div></td>
							<td align="right"><span id="max24ChtVideo">--</span></td>
						</tr>
						<tr>
							<td><div class="conTitle" >監視期間最高:</div></td>
							<td align="right"><span id="maxChtVideo">--</span></td>
						</tr>
						</tbody></table>	 
					</div>
				</div>	
			</div>	<!-- col-sm-12 -->	

			
						
			<div class="col-sm-12">	
				<div class="panel panel-primary">
						<div class="panel-heading"><b >MOD頻道資訊</b> </div>					
						<!-- <div class="panel-body containerPlace" style="height: 234px; margin: 0 auto" >	 	-->
						<div class="panel-body containerPlace" style=" margin: 0 auto" >	 
						<!-- <span id="dmLoading"><img src="/img/light/s_ajax_loader.gif"/><br/>loading...</span>-->
						<table id="TList" ></table> 
								<span class="panel-right-btn"><b></b></span>

						<table id = "curTable"  class="table table-striped" style="margin-bottom: 2px;" >
							 <thead>
								<tr>
									<td><b>頻道</b>  </td>
									 <td><b>名稱</b> </td>
									 <td><b>收視數</b></td>
									 <td><b>狀態</b></td>
								 </tr>
							 </thead>
							  <tbody>
							  <%
								for(int i= 0 ; i < _channelCount; i ++){
									String displayCh = "ch"+_theChannel[i][0].getId();									
									boolean display= false;
									if(displayCh.equals("ch200") ||displayCh.equals("ch201")  ||displayCh.equals("ch202")  ){
										display = true;
									}								
									
									if(display){
							%>
								<tr>
									<td><b><%=displayCh%></b>  </td>
									<td><b><%=_theChannelName[i]%></b>  </td>
									 <td align="right"><b id="<%=displayCh%>num">0</b></td>
									 <td align="center"><b><img id="status<%=displayCh%>"src="/img/light/03.png" class="statusIcon" onClick="openurl(' /modDashBoard/AudienceAna/games/channelInfo.jsp','channel')" ></b></td>
								</tr>
							<%
									}
									}
							%>	
							  </tbody>
							</table>	
						</div>
					
				</div>	
			</div>	<!-- col-sm-12 -->	
			
					<div class="col-sm-12">				
				<div class="panel panel-primary">
					<div class="panel-heading">
						<b>中華電信CDN流量-LIVE</b>
					</div>
					<div class="panel-body">									
						<table class="table-striped" style=" height:128px; margin: 0 auto; width:100%  ">
							<thead><tr>
								<td><div ></div></td>
								<td align="right"><b >狀態</b></td>
								<td align="right" ><b >頻寬資訊</b></td>
							</tr></thead>	
							<tbody>
							<tr>
								<td><div class="conTitle" >線上</div></td>
								<td align="center" >
								
								<img id="cdn_status" src="/img/light/01.png" class="statusIcon" onclick="openurl('/GNOC/MCMpages/CDN_FLOW/cdnServiceO2024.jsp?_type=cdn_bw&measureDate=','CDN_GLOW')">

								</td>
								<td align="right"><div id="cdn_bandwidth">--</div> </td>
								
							</tr>
							<tr>
								<td><div class="conTitle" >24小時內線上最高</div></td>
								<td></td>
								<td align="right"><div id="cdn_bandwidth_24max">--</div></td>
							</tr>
									<tr>
								<td><div class="conTitle" >目前畫質</div></td>
								<td colspan=2><span id="curResolution"></span></td>
							</tr>							
							</tbody>
						</table>	 
					</div>
				</div>				
			</div>	<!-- col-sm-12 -->			
						
						
				
		</div>
		<div class="col-md-12" id="ruleInfo">	
				<div class="panel panel-primary" style="margin: 1px auto; ">			
					<div class="panel-heading">
						<b>Dashboard 更新規則</b>
					</div>				
					<div class="panel-body" style="padding:0px" >					
						<table class="table" style="width:95% ;margin: 10px; ">
								<tbody>							
									<tr>
										<td>
											監視面板更新週期:1分鐘<br>
											事件推論規則更新週期:1分鐘<br>
											CDN流量更新週期:5分鐘<br>
											MOD收視數更新週期:15分鐘<br>
											HAMI收視數更新週期:5分鐘<br>
										</td>
									</tr>							
								</tbody>
							</table>
					</div>
				</div>					
			</div>
	</div>
	</div>
</body>
</html>
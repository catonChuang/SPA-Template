	function getNowTime(){
		var nowTime = new Date();
		var refreshTimeText = nowTime.getFullYear()+'-'+(nowTime.getMonth()+1)+'-'+nowTime.getDate()+' '+ nowTime.getHours()+':';
		refreshTimeText += ((nowTime.getMinutes()<10)?"0":"")+nowTime.getMinutes();
		return refreshTimeText;
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
	
	
	
		//=======================================
		// 燈號改變-1 網路
		//=======================================
		function changeNetworkStatus(_status){
			
			$("#btn1").removeClass();
			
			if(_status == 5){			
				$("#btn1").addClass("badge badge-danger");
			}else{
				$("#btn1").addClass("badge badge-secondary btnNormal");
			}
		}
		
		
		
		
		//=======================================
		// 燈號改變-1 網路狀態
		//=======================================
		function changeNetworkStatus(_status){
			
			$("#btn1").removeClass();
			
			if(_status == 5){			
				$("#btn1").addClass("badge badge-danger");
			}else{
				$("#btn1").addClass("badge badge-secondary btnNormal");
			}
		}
		
		//=======================================
		// 燈號改變-2 服務狀態
		//=======================================
		function changeServiceStatus(_status){
			
			$("#btn2").removeClass();
			
			if(_status == 5){			
				$("#btn2").addClass("badge badge-danger");
			}else{
				$("#btn2").addClass("badge badge-secondary btnNormal");
			}
		}
		
		//=======================================
		// 燈號改變-4 ISP
		//=======================================
		function checkISPStatus(events){
			var _statusIsp = 1;
			if(events.length >0){			
				for(var i=0; i<events.length; i++){
					var _as= events[i].Alarmseverity;
					if(_as=="Critical"){
						_statusIsp =5;
					}
				}
			}
			$("#btn4").removeClass();
			
			if(_statusIsp == 5){			
				$("#btn4").addClass("badge badge-danger");
			}else{
				$("#btn4").addClass("badge badge-secondary btnNormal");
			}
		}
		
		
		
	
	
		//=======================================
		// 取得CDN燈號
		//=======================================
		function checkCDNStatus(_objCdn){			
			var _status = xssFilters.inHTMLData(_objCdn.status);	
			return _status;
		}
		
		
		
		//=======================================
		// 取得Qoe燈號
		//=======================================
		function checkQOEStatus(data){			
			var _status = "1";	
			if(data.length>0){									
				for(var i = 0 ; i < data.length; i ++){							
					var ajaxStatus = xssFilters.inHTMLData(data[i].value);		
					if(ajaxStatus=="5"){
						_status = "5";
						break;
					}
				}									
			}	
			return _status;
		}
		
		
		
		//=======================================
		// 取得MOD 大批告警燈號
		//=======================================
		function checkMODDeclarmStatus(data){			
			var _status = "1";	
			if(data.length>0){									
				for(var i = 0 ; i < data.length; i ++){							
					var _TicketId = xssFilters.inHTMLData(data[i].TicketId);	
					var _EndTime = xssFilters.inHTMLData(data[i].EndTime);
					if(_EndTime==""){
						if(_TicketId.indexOf("MOD_Declaration_ALL")>-1){
							_status = "5";
							break;
						}
					}
				}									
			}	
			return _status;
		}
		
		
		//=======================================
		// 取得MOD Hami 平台燈號
		//=======================================
		function checkMODHamiPStatus(data){			
			var _status = "1";	
			if(data.length>0){									
				for(var i = 0 ; i < data.length; i ++){							
					var _status = xssFilters.inHTMLData(data[i].status);	
					if(_status==5){
							_status = "5";
							break;
					}
				}									
			}	
			return _status;
		}
		
		
		
		//=======================================
		// 取得DDOS燈號
		//=======================================
		function checkDDOSStatus(data){			
			var _status = "1";	
			if(data.length>0){									
				for(var i = 0 ; i < data.length; i ++){							
					var ajaxStatus = xssFilters.inHTMLData(data[i].value);		
					if(ajaxStatus=="5"){
						_status = "5";
						break;
					}
				}									
			}	
			return _status;
		}
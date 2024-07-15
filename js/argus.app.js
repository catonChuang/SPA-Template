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
	
	
	
		
﻿	function getNowTime(){
		var nowTime = new Date();
		var refreshTimeText = nowTime.getFullYear()+'-'+(nowTime.getMonth()+1)+'-'+nowTime.getDate()+' '+ nowTime.getHours()+':';
		refreshTimeText += ((nowTime.getMinutes()<10)?"0":"")+nowTime.getMinutes();
		return refreshTimeText;
	}	
	
	
	//==============================
	// 
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
		// 
		//=======================================
		function checkSYS_Status(dataSource){			
			var _status = "1";	
			var data = dataSource.ProjData.project.targets;
			if(data.length>0){									
				for(var i = 0 ; i < data.length; i ++){							
					var _alarmLevel = xssFilters.inHTMLData(data[i].alarmLevel);		
					if(_alarmLevel=="Critical"  ||  _alarmLevel=="critical"){
						_status = "5";
						break;
					}
				}									
			}	
			return _status;
		}
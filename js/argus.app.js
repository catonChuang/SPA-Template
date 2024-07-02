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
	
	
	function changeImgColor(data){
			alert("data.length: " + data.length);

			if(data.length>0){									
				for(var i = 0 ; i < data.length; i ++){							
					var ajaxName = xssFilters.inHTMLData(data[i].name);			
					var ajaxStatus = xssFilters.inHTMLData(data[i].value);		
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
				$("#img"+ajaxName ).attr("src","img/light2/"+_imgName);	
				}									
			}						
	}		
		
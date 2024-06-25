<%@ page contentType="text/html;charset=UTF-8" pageEncoding="BIG5" %><%@ page import="java.util.*" %> <%

        response.setHeader("Pragma","no-cache");
        response.setHeader("Cache-Control","no-cache");
        response.setDateHeader("Expires", 0);
%><%
String pid="174";
%><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body bgcolor=#ffffff>
<svg width="1200" height="500"></svg>

<script src="/Util/Topology/d3.v4.min.js"></script>
<script src="/js/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jqGrid/css/ui.jqgrid.css" />	
<script src="/js/jqGrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<link href="/bootstrapV4/css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="/bootstrapV4/js/bootstrap.min.js"></script>
<script src="paris_topo_data.jsp"></script>

   <style type="text/css">
 

mytt.tooltipAlarm {
color:red;	
    position: absolute;			
    text-align: left;			
    width: 600px;					
    height: 150px;					
    padding: 2px;				
    font: 15px 微軟正黑體;		
    background: #eee;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}
mytt.tooltipNormal {
color:Green;	
    position: absolute;			
    text-align: left;			
    width: 500px;					
    height: 150px;					
    padding: 2px;				
    font: 18px 微軟正黑體;		
    background: #eee;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}
mytt.tooltipWarning {
color:Navy;	
    position: absolute;			
    text-align: left;			
    width: 500px;					
    height: 150px;					
    padding: 2px;				
    font: 18px 微軟正黑體;		
    background: lightblue;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}
mytt.tooltipMinor {
color:Navy;	
    position: absolute;			
    text-align: left;			
    width: 500px;					
    height: 300px;					
    padding: 2px;				
    font: 18px 微軟正黑體;		
    background: yellow;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}
mytt.tooltipMajor {
color:Navy;	
    position: absolute;			
    text-align: left;			
    width: 600px;					
    height: 300px;					
    padding: 2px;				
    font: 15px 微軟正黑體;		
    background: orange;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}


mytt.tooltipOther {
color:Navy;	
    position: absolute;			
    text-align: left;			
    width: 500px;					
    height: 150px;					
    padding: 2px;				
    font: 18px 微軟正黑體;		
    background: #eee;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}

mytt.tooltipLong {
color:Navy;	
    position: absolute;			
    text-align: left;			
    width: 500px;					
    height: 500px;					
    padding: 2px;				
    font: 16px 微軟正黑體;		
    background: #eee;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}
mytt.tooltip {	
    position: absolute;			
    text-align: center;			
    width: 200px;					
    height: 120px;					
    padding: 2px;				
    font: 20px 微軟正黑體;		
    background: #aaa;	
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;			
}


 body {
            background-image: url(paris2024seine.png);
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
            background-size: cover;
        }

    </style>
<script type="text/javascript">

   var svg = d3.select("svg");
       //width = +svg.attr("width"),
        //height = +svg.attr("height"),
var        width =  860,
        height = 450,
        node,
        link,
        path;
</script>
<script>
var link_status_map = {};
var cir_status_map = {};
var link_as_map={};
var link_contact_map={};
var link_remark_map={};
var myIV=0;
var myIV2;
var link_conn_id_map={};

    var mytt = d3.select("body").append("mytt")	
    .attr("class", "tooltip2")
    				
    .style("opacity", 0);



svg.append('image')        
.attr('x', 210)
.attr('y',0)

.attr('width', 40)
.attr('height', 40)
.attr('xlink:href', 'sat_up.png')
;

/*
svg.append('image')        
.attr('x', 425)
.attr('y', 132)
.attr('width',25)
.attr('height',25)
.attr('xlink:href', 'sat.png')
; //SAT
*/
/*
svg.append('image')        
.attr('x', 700)
.attr('y', 140)

.attr('width', 270)
.attr('height', 164)
.attr('xlink:href', 'CloudW2.png')
; //hami cloud
*/
svg.append('image')        
.attr('x', 690)
.attr('y', 90)
.attr('width', 270)
.attr('height',260)
.attr('xlink:href', 'CloudW2C2.png')
;




svg.append('image')        
.attr('x', 770)
.attr('y', 200)
.attr('width', 122)
.attr('height', 53)
.attr('xlink:href', 'HamiVideo2W.png')
; 

 
               
/*
svg.append('image')        
.attr('x', 20)
.attr('y', 85)
.attr('width', 245)
.attr('height', 245)
.attr('xlink:href', 'CloudW2.png')
; //ali cloud

*/
svg.append('image')        
.attr('x', 20)
.attr('y', 85)
.attr('width', 245)
.attr('height', 245)
.attr('xlink:href', 'CloudW2C2.png')
; //ali cloud





svg.append('image')        
.attr('x', 73)
.attr('y', 55)
.attr('width', 120)
.attr('height',120)
.attr('xlink:href', 'paris2024logo.png')
; //HZ

svg.append('image')        
.attr('x', 255)
.attr('y', 440)
.attr('width', 68)
.attr('height', 27)
.attr('xlink:href', 'elta_tv_logo.png')
; 



svg.append('image')        
.attr('x', 447)
.attr('y', -45)
.attr('width', 270)
.attr('height',225)
.attr('xlink:href', 'CloudW2C2.png')
;


$(window).load(function () {
conn_id_Mapping(topo.links);
//myIV=setTimeout(circular, 500);
circular();
linkGREEN("id_AliIntLink");
linkGREEN("id_ParisAliLink");
});


function conn_id_Mapping(links){

for(j=0;j<links.length;j++){
if(links[j].conn_id){

   link_conn_id_map[links[j].id]=links[j].conn_id;
}
}
}





 var line = d3.line();


 path = svg.selectAll(".path")
.data(topo.links)
.enter().append("path")
.attr("d", function(d) { return line(d.linedata);})
   .attr("stroke", "#ddd")
    .attr("stroke-width",function(d) { return (d.width);} )
    .attr("id",function(d) { return ("id_"+d.id);} )   
    .attr("class","links allobj") 
    .attr("fill", "none")
                .on("mouseover", function(d) {		
      var myContact="";
              if(d.contact)
            myContact=d.contact;          
 if(link_contact_map["id_"+d.id])
myContact =link_contact_map["id_"+d.id];   
 
myContact=myContact.replaceAll("\\","<BR/>");         
var myRemark="NA";
if(d.remark) myRemark=d.remark; 

 if(link_remark_map["id_"+d.id])
myRemark =link_remark_map["id_"+d.id];                     
            mytt.transition()		
                .duration(200)		
                .style("opacity", .9)
                .attr("class",link_as_map["id_"+d.id]);
                
            mytt.html(
            '<DIV class="ROW"> <div class="card CardT"><div class="card-header CardT">'+
'<h2 class="card-title bg-white">監視設備</h2>'+
            "●監視設備名稱："+d.sysname+"<BR/>"+
            "●專線編號："+d.circuit+"<BR/>"+
            link_status_map["id_"+d.id] +"●"+myRemark+"<BR/>●"+(myContact).replace(/\\n/g,)+"</div></div></div>")
                .style("left",function(d){
                //console.log(d3.event.pageX+":"+d3.event.pageY);
                if(d3.event.pageX<510) return "520px"; else return "20px";
                } )	
                .style("top", function(d){
               if(d3.event.pageX>520 && d3.event.pageX <620 && d3.event.pageY>150 && d3.event.pageY <190 ) //for 4條MOD
               return "200px";
		else               
               return "20px";
                });	
            })					
        .on("mouseout", function(d) {		
            mytt.transition()		
                .duration(500)		
                .style("opacity", 0);	
        })
;

 path = svg.selectAll(".path")
.data(topo.links_dash)
.enter().append("path")
.attr("d", function(d) { return line(d.linedata);})
   .attr("stroke", "#3198FF")
    .attr("stroke-width",function(d) { return (d.width);} )
    .attr("id",function(d) { return ("id_"+d.id);} )   
    .attr("class","links allobj") 
    .attr("fill", "none")
.style("stroke-dasharray",("3,5"))
;


///蓋住線
svg.append('image')        
.attr('x', 300)
.attr('y', 250)
.attr('width',105)
.attr('height',105)
.attr('xlink:href', 'b_bld3.png')
; //台北愛國
    svg.append('svg:image')
        .attr('x', 480)
.attr('y', 180)
.attr('width', 190)
    .attr('height', 135)
    .attr('xlink:href', 'center.png')
    .attr("id", "XX")
    ; //仁愛
svg.append('image')        
.attr('x', 350)
.attr('y', 370)
.attr('width', 75)
.attr('height',68)
.attr('xlink:href', 'b_bld2.png')
; //漢口

 svg.append('image')        
.attr('x', 700)
.attr('y', 370)
.attr('width',75 )
.attr('height',75)
.attr('xlink:href', 'b_bld3.png')
; //重南

svg.append('image')        
.attr('x', 370)
.attr('y', 65)
.attr('width',75 )
.attr('height',75)
.attr('xlink:href', 'b_bld3.png')
; //服務大樓
svg.append('image')        
.attr('x', 278)
.attr('y', 75)
.attr('width',55 )
.attr('height',55)
.attr('xlink:href', 'sat.png')
; //陽明山
svg.append('image')        
.attr('x', 211)
.attr('y', 235)
.attr('xO', 11)
.attr('yO', 300)
.attr('width', 40)
.attr('height',50)
.attr('xlink:href', 'b_bld4.png')
; //TYO

svg.append('image')        
.attr('x', 171)
.attr('y', 235)
.attr('xO', 58)
.attr('yO', 300)
.attr('width', 40)
.attr('height',50)
.attr('xlink:href', 'b_bld4.png')
; //SIN


svg.append('image')        
.attr('x', 75)
.attr('y', 200)
.attr('width', 110)
.attr('height',40)
.attr('xlink:href', 'alicloud2.png')
; //阿里雲

svg.append('image')        
.attr('x', 77)
.attr('y', 320)
.attr('width', 90)
.attr('height', 80)
.attr('xlink:href', 'skyCloud.png')
; //Hinet cloud

svg.append('image')        
.attr('x', 77)
.attr('y', 245)
.attr('width', 90)
.attr('height', 80)
.attr('xlink:href', 'skyCloud.png')
; //internet cloud
/*
svg.append('image')        
.attr('x', 460)
.attr('y', -10)
.attr('width', 270)
.attr('height', 164)
.attr('xlink:href', 'CloudW2.png')
;
*/


 svg.append('image')        
.attr('x', 505)
.attr('y', 55)
.attr('width', 153)
.attr('height', 52)
.attr('xlink:href', 'ModW.png')
; 
  for(i=0;i<topo.CapText.length;i++){
  var mytext=topo.CapText[i];
  svg.append("text")
            .attr("x", mytext.x)
            .attr("y", mytext.y)            
            .style("font-family", "微軟正黑體")
            .style("font-size", mytext.size)
            .style('font-weight', 'bold')
            .style("fill",function(d) { if(mytext.color) return mytext.color; else return "#065a7f";})
            .text(mytext.name);
}
	// 在 svg 中插入 circle

var circleName={};
for(i=0;i<topo.circles.length;i++){
var myCircle=topo.circles[i];
circleName[myCircle.id]=myCircle.name;
}

var mycircle;
mycircle=svg.selectAll(".circle")
.data(topo.circles)
.enter().append("circle")
        .attr('cx',function(d) { return (d.cx);}  )
        .attr('cy', function(d) { return (d.cy);}  )
        .attr('r',function(d) { return (d.r+'px');} )
        .attr('id',function(d) { return (d.id);} )
        .attr('c_type',function(d) { return (d.c_type);} )
        .on("click",function(d) {window.open(d.url,"_NEWWIN");})
        .style('fill', '#ddd')
                       .on("mouseover", function(d) {		
            
            mytt.transition()		
                .duration(200)		
                .style("opacity", .9)
               .attr("class",link_as_map[d.id]);
            mytt.html(cir_status_map[d.id])
            .style("left", 0)		
                .style("top", 0);	
            })					
        .on("mouseout", function(d) {		
            mytt.transition()		
                .duration(500)		
                .style("opacity", 0);	
        })
        
        
;



///img over circle
mycircleimg=svg.selectAll(".circleimg")
.data(topo.circles_image)
.enter().append("image")
.attr('x', function(d){return d.x;})
.attr('y',  function(d){return d.y;})
.attr('id',  function(d){return d.id;})
.attr('width',  function(d){return d.width;})
.attr('height',  function(d){return d.height;})
.attr('NormalURL',  function(d){return d.url;})
.attr('AlarmURL',  function(d){return d.Alarm_url;})
.attr('xlink:href',  function(d){return d.url;})
.on("mouseover", function(d) {		
            
            mytt.transition()		
                .duration(200)		
                .style("opacity", .9)
               .attr("class",link_as_map[d.xid]);
            mytt.html(cir_status_map[d.xid])
            .style("left", 0)		
                .style("top", 0);	
            })					
        .on("mouseout", function(d) {		
            mytt.transition()		
                .duration(500)		
                .style("opacity", 0);	
        })
;

</script>    
<script>
	  function stop_pulsate(selection) {
	  selection.attr("r", 12);
			recursive_transitions3();
			
			function recursive_transitions3() {		  
				selection
				.interrupt()
				.transition();
			}
	  }

	  function pulsate(selection,mycolor) {
	  //selection=d3.select(myid);
		recursive_transitions();

		function recursive_transitions() {
		  if (true) {
			selection.transition()
				.duration(800)
				.attr("stroke-width", 2)
				.attr("r", 12)
				.style('fill',  '#ddd')
				.ease(d3.easeSin)
				.transition()
				.duration(1600)
				.attr('stroke-width', 3)
				.attr("r", 18)
				.style('fill',  mycolor)
				.ease(d3.easeSin)
				.on("end", recursive_transitions);
		  } else {
			// transition back to normal
			selection.transition()
				.duration(200)
				.attr("r", 8)
				.attr("stroke-width", 2)
				.attr("stroke-dasharray", "1, 0");
		  }
		}
	  }
	  
function linkGREEN(myid){

var color = d3.scaleOrdinal(d3.schemeCategory20);
var uuu=svg.selectAll("#"+myid);
uuu.style("stroke","green")
.attr("stroke-opacity", 1);
}
function linkColor(myid,myColor){

var color = d3.scaleOrdinal(d3.schemeCategory20);
var uuu=svg.selectAll("#"+myid);

uuu.style("stroke",myColor)
.attr("stroke-opacity", 1)

}

function linkRED(myid){

var color = d3.scaleOrdinal(d3.schemeCategory20);
var uuu=svg.selectAll("#"+myid);
uuu.style("stroke","red")
.attr("stroke-opacity", 1)

}
function cirred(mycir,num){
var uuu=svg.selectAll("#"+mycir);
uuu.style("fill","red")
;
	}
function cirorange(mycir,num){
var uuu=svg.selectAll("#"+mycir);
uuu.style("fill","orange")
;
	}
	
function cirgreen(mycir){
var uuu=svg.select("#"+mycir);
uuu.style("fill","green")
;
	}
function circolor(mycir,num){
var mycolor;
if(num==1) mycolor="green";
else if(num==2) mycolor="blue";
else if(num==3) mycolor="yellow"; 
else if(num==4) mycolor="orange";
else if(num==5) mycolor="red";
var uuu=svg.selectAll("#"+mycir);
uuu.style("fill",mycolor)
;
	}		
function getData(){

 var url = "";
 var data = {type:1};
$.ajax({
           type: "POST",
            contentType: "application/json; charset=utf-8",
            url: 'proj_alarms_data.jsp',
            dataType: 'json',
            async: true,
            data: "{'pid':'376'}",
            timeout:20000,
           
  success:function(JData){
  //allgreen();
  ParsingData(JData);
 
 
  },
  error: function(xhr, status, error) {
         console.log(error);
         $( "#errorMsg" ).html(error);
      }
 });
 };
 
function MODHamiGetData(){

 var url = "";
 var data = {type:1};
$.ajax({
           type: "POST",
            contentType: "application/json; charset=utf-8",
           // url: 'mod_hami_alarms_data.jsp',
           url: '/modDashBoard/AudienceAna/games/globalStatus.jsp',
            dataType: 'json',
            async: true,
            data: "{}",
            timeout:20000,
  success:function(JData){
 
 MODHamiParsingData(JData);
 
 
  },
  error: function(xhr, status, error) {
         console.log(error);
         $( "#errorMsg" ).html(error);
      }
 });
 }; 
 
function allgreen(){
//alert(mylink);
svg.selectAll("#UPDATEMSG").text("更新中");
svg.selectAll(".links")
.style("stroke", "green")
.attr("stroke-opacity", .9)
;
svg.selectAll(".cir")
.style("fill", "green")
.attr("stroke-opacity", .9)
;
svg.selectAll("#id_MOD_PLATFORM")
.style("fill", "green")
.attr("stroke-opacity", .9)
;
svg.selectAll("#id_HAMI_PLATFORM")
.style("fill", "green")
.attr("stroke-opacity", .9)
;
}
function MODHamiParsingData(JData2){
 var JData=JData2.data;
 var alen=JData.length;
 var s_txt;
 cir_status_map={};
 for(i=0;i<alen;i++){

 if(JData[i].status==5){
 s_txt="Critical";
 //cirred("id_"+JData[i].name);
 var aaa=d3.select("#id_"+JData[i].name);
 pulsate(aaa,"red");
 link_as_map["id_"+JData[i].name]="tooltipAlarm";
 }
 else if(JData[i].status==1){
 s_txt="Normal";
//alert("id_"+JData[i].name);
var aaa=d3.select("#id_"+JData[i].name);
 stop_pulsate(aaa);
 cirgreen("id_"+JData[i].name);
 link_as_map["id_"+JData[i].name]="tooltipNormal";
 
 }
   else if(JData[i].status==2){
 s_txt="Warning"; 
circolor("id_"+JData[i].name,2);
 var aaa=d3.select("#id_"+JData[i].name);
 pulsate(aaa,"blue");
 link_as_map["id_"+JData[i].name]="tooltipWarning";
 }
   else if(JData[i].status==3){
  s_txt="Minor";
circolor("id_"+JData[i].name,3);
 var aaa=d3.select("#id_"+JData[i].name);
 pulsate(aaa,"yellow");
 link_as_map["id_"+JData[i].name]="tooltipMinor";
 }
  else if(JData[i].status==4){
  s_txt="Major";
 //circolor("id_"+JData[i].name,4);
 var aaa=d3.select("#id_"+JData[i].name);
 pulsate(aaa,"orange");
 link_as_map["id_"+JData[i].name]="tooltipMajor";
 }
 
  if((JData[i].msg).length>120){
   link_as_map["id_"+JData[i].name]="tooltipLong";
   }         



 cir_status_map["id_"+JData[i].name]="●監視名稱："+circleName["id_"+JData[i].name]+"<BR/>"+
 "●告警等級:"+s_txt+"<BR/>"+
 "●告警描述：<BR/>"+JData[i].msg+"<BR/>";
  var bbb=d3.select("#id_"+JData[i].name);
try{
 if(bbb.attr('c_type')=='power'){
var ccc=d3.select("#id_"+JData[i].name+"_img");

if(JData[i].status>1) {
ccc.attr('xlink:href',ccc.attr('AlarmURL'));
}else ccc.attr('xlink:href',ccc.attr('NormalURL'));
 }
}catch{}

 }
}
function ParsingData(JData2){

 var JData=JData2.ProjData;
 //	$( "#errorMsg" ).html("<font face=微軟正黑體>更新時間:"+JData.Datetime+"</font>");
   svg.selectAll("#UPDATEMSG").text("更新時間:"+JData2.Datetime+"");
   
  var tagetsArr=JData.project.targets;
   var alen=tagetsArr.length;
   link_status_map={};
   for(i=0;i<alen;i++){
   var myContact=tagetsArr[i].contact;
   var myAlarmMsg=tagetsArr[i].alarmMsg; 

   link_contact_map["id_"+tagetsArr[i].targetId]=myContact;
   var myRemark=tagetsArr[i].remark;
   myRemark.replaceAll("\\\\\\","\\");
   link_remark_map["id_"+tagetsArr[i].targetId]=myRemark;
   
      if(link_conn_id_map[tagetsArr[i].targetId]){
   for(i3=0;i3<link_conn_id_map[tagetsArr[i].targetId].length;i3++){ 
   var tmpTID=link_conn_id_map[tagetsArr[i].targetId][i3];
  link_remark_map["id_"+tmpTID]=myRemark;
  link_contact_map["id_"+tmpTID]=myContact;
   }}
   
   if(tagetsArr[i].alarmLevel=="Critical"){
   link_status_map["id_"+tagetsArr[i].targetId]="●告警等級：Critical <BR/>告警描述：<BR/>"+tagetsArr[i].alarmMsg+"<BR/>";
   link_as_map["id_"+tagetsArr[i].targetId]="tooltipAlarm";
   linkRED("id_"+tagetsArr[i].targetId);
   
   ////
    if(link_conn_id_map[tagetsArr[i].targetId]) 
       linkRED("id_"+tagetsArr[i].targetId);
   
    if(link_conn_id_map[tagetsArr[i].targetId]){
   for(i3=0;i3<link_conn_id_map[tagetsArr[i].targetId].length;i3++){
   var tmpTID=link_conn_id_map[tagetsArr[i].targetId][i3];
   if(link_status_map["id_"+tmpTID])
   link_status_map["id_"+tmpTID]=link_status_map["id_"+tmpTID]+"<BR/><font color=red>●告警等級：Critical <BR/>告警描述：<BR/>-"+myAlarmMsg+"</font><BR/>";
   else
   link_status_map["id_"+tmpTID]="<BR/><font color=red>●告警等級：Critical <BR/>告警描述：<BR/>-"+myAlarmMsg+"</font><BR/>";
   
   link_as_map["id_"+tmpTID]="tooltipAlarm";
   linkRED("id_"+tmpTID);
   
   }
   }
   
   ////
   
   
   
   }else if(tagetsArr[i].alarmLevel=="Major"){
    link_status_map["id_"+tagetsArr[i].targetId]="●告警等級：Major <BR/>告警描述：<BR/>"+tagetsArr[i].alarmMsg+"<BR/>";
   link_as_map["id_"+tagetsArr[i].targetId]="tooltipMajor";
   linkColor("id_"+tagetsArr[i].targetId,"orange");
   
   ///
      if(link_conn_id_map[tagetsArr[i].targetId]){
   for(i3=0;i3<link_conn_id_map[tagetsArr[i].targetId].length;i3++){
   var tmpTID=link_conn_id_map[tagetsArr[i].targetId][i3];
   if(link_status_map["id_"+tmpTID])
   link_status_map["id_"+tmpTID]=link_status_map["id_"+tmpTID]+"<BR/><font color=orange>●告警等級： Major </font><BR/><font color=navy>告警描述：<BR/>-"+myAlarmMsg+"</font><BR/>";
   else
   link_status_map["id_"+tmpTID]="<BR/><font color=orange style='backgroud-color=white;'>●告警等級： Major </font><BR/><font color=navy>告警描述：<BR/>-"+myAlarmMsg+"</font><BR/>";
   
   link_as_map["id_"+tmpTID]="tooltipMajor";
   //linkMajor("id_"+tmpTID);
   linkColor("id_"+tmpTID,"orange");
                                                                    }
                                                 }
   ///
   
   
   }else if(tagetsArr[i].alarmLevel=="Minor"){
      link_status_map["id_"+tagetsArr[i].targetId]="●告警等級：Minor <BR/>告警描述：<BR/>"+tagetsArr[i].alarmMsg+"<BR/>";
   link_as_map["id_"+tagetsArr[i].targetId]="tooltipMinor";
   linkColor("id_"+tagetsArr[i].targetId,"#D9D000");
   }else if(tagetsArr[i].alarmLevel=="Warning"){
      link_status_map["id_"+tagetsArr[i].targetId]="●告警等級：Warning <BR/>告警描述：<BR/>"+tagetsArr[i].alarmMsg+"<BR/>";
   link_as_map["id_"+tagetsArr[i].targetId]="tooltipWarning";
   linkColor("id_"+tagetsArr[i].targetId,"blue");
   ///
    if(link_conn_id_map[tagetsArr[i].targetId]){
   for(i3=0;i3<link_conn_id_map[tagetsArr[i].targetId].length;i3++){
   var tmpTID=link_conn_id_map[tagetsArr[i].targetId][i3];
   if(link_status_map["id_"+tmpTID])
   link_status_map["id_"+tmpTID]=link_status_map["id_"+tmpTID]+"<BR/><font color=#555>●告警等級： Minor <BR/>告警描述：<BR/>-"+myAlarmMsg+"</font>";
   else
   link_status_map["id_"+tmpTID]="<BR/><font color=#555>●告警等級： Minor <BR/>告警描述：<BR/>-"+myAlarmMsg+"</font>";
   
   link_as_map["id_"+tmpTID]="tooltipMinor";
   
    linkColor("id_"+tmpTID,"#D9D000");
                                                                    }
                                              } 
    ////                                         
   
   
   }else{
  
    link_status_map["id_"+tagetsArr[i].targetId]="●告警等級：Normal <BR/>";
    link_as_map["id_"+tagetsArr[i].targetId]="tooltipNormal";
    linkGREEN("id_"+tagetsArr[i].targetId);
   ///
      if(link_conn_id_map[tagetsArr[i].targetId]){
   for(i3=0;i3<link_conn_id_map[tagetsArr[i].targetId].length;i3++){
   var tmpTID=link_conn_id_map[tagetsArr[i].targetId][i3];
   if(link_status_map["id_"+tmpTID])
   link_status_map["id_"+tmpTID]=link_status_map["id_"+tmpTID]+"<BR/>●告警等級：Normal <BR/>";
   else
   link_status_map["id_"+tmpTID]="<BR/>●告警等級：Normal <BR/>";
   
  link_as_map["id_"+tmpTID]="tooltipNormal";

  linkGREEN("id_"+tmpTID);
   
                                                                    }
                                              }  
   
   ///
   }
   
   
   
   }
 }

function circular(){
clearInterval(myIV);
//allgreen();
getData();
MODHamiGetData();
myIV=setTimeout(circular, 15000);
}
  let circle = d3.select(node).select('circle');
  
 aa=d3.select('#id_MOD_PLATFORM');
	</script>


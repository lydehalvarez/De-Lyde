<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
<!--
var HM_IsMenu = true;
var HM_BrowserString = "";
if(window.event + "" == "undefined") event = null;
function HM_f_PopUp(){return false};
function HM_f_PopDown(){return false};
	 var popUp = HM_f_PopUp;
	 var popDown = HM_f_PopDown;
//-->
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript1.2" SRC="/Plugins/MenuDinamico/js/CargadorMenu.js" TYPE='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

if(HM_IsMenu) {
	//alert("NAVEGADOR " + HM_BrowserString);
<% EscribeMenuPrincipal() %>
   document.write("<SCR" + "IPT LANGUAGE='JavaScript1.2' SRC='/Plugins/MenuDinamico/js/HM_Script"+ HM_BrowserString +".js' TYPE='text/javascript'><\/SCR" + "IPT>");
}

</SCRIPT>
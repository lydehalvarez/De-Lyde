<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%



function TraeRamas(iPadre,SisAct) {
	var sTabsArmados = ""
	
	var sSQL  = "Select * "
		sSQL += " from Menu "
		sSQL += " WHERE Mnu_Padre = " + iPadre
		sSQL += " AND Mnu_EsMenu = 1 " 
		sSQL += " AND Sys_ID = " + SisAct
		sSQL += " AND Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_Tag1 = 1 "
		sSQL += " Order by Mnu_Orden " 
	
	var rsTab = AbreTabla(sSQL,1,2)
		
		while (!rsTab.EOF){
			sTabsArmados += "<li><a href=\"" //"
			if (EsVacio( rsTab.Fields.Item("Mnu_IDLigaDelTab").Value )) {
				sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_ID").Value + ")"
			} else {
				sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_IDLigaDelTab").Value + ")"
			}		
			sTabsArmados += "\">"   //"
			sTabsArmados += rsTab.Fields.Item("Mnu_Titulo").Value + "</a>"
			sTabsArmados += TraeRamas( rsTab.Fields.Item("Mnu_ID").Value,SisAct)
			sTabsArmados += "</li>"
			rsTab.MoveNext()
			
		}
		rsTab.Close()
		
		if (sTabsArmados != ""){
			if (iPadre == 0 ) { 
				//sTabsArmados = "<ul class=\"nav\" id=\"mainNav\" >" + sTabsArmados + "</ul>"
				sTabsArmados = "<ul class=\"ui-tabs\" id=\"tabs\" >" + sTabsArmados + "</ul>"
			} else {
				sTabsArmados = "<ul>"  + sTabsArmados + "</ul>"
			}
		}
		
		return sTabsArmados
} 

function ArmaMenu() {
	var sMenu = ""
    
    sMenu = TraeRamas(0,100) 

	return sMenu
    
}


sTmpComodin03 = ArmaMenu()

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="/css/Escuelas/jquery-ui-1.8.11.custom.css" type="text/css" />
<script type="text/javascript" src="/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.8.11.custom.min.js"></script>
<title>Prueba de tabs tipo Tag1</title>
</head>
<%Response.Write(sTmpComodin03)%>
<body>
</body>
</html>
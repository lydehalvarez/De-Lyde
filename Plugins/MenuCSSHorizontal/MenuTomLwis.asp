<!--#include file="../../Includes/iqon.asp" -->
<%
if (!bHayParametros) { LeerParametrosdeBD() }

var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var Tab3Selec     = Parametro("Tab3Selec",1)


function TraeRamas(iPadre,SisAct,selecionado) {
	var sTabsArmados = ""
	
	var sSQL  = "Select * "
		sSQL += " from Menu "
		sSQL += " WHERE Mnu_Padre = " + iPadre
		sSQL += " AND Mnu_EsMenu = 0 " 
		sSQL += " AND Sys_ID = " + SisAct
		sSQL += " AND Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_Tag1 = 3 " 
		sSQL += " Order by Mnu_Orden "  

	var rsTab = AbreTabla(sSQL,1,2) 
		
		while (!rsTab.EOF){
			sTabsArmados += "<li "
//            if (rsTab.Fields.Item("Mnu_Orden").Value == selecionado ) {
//            	sTabsArmados += " class=\"current\" "
//            }
            sTabsArmados += "><a href=\""
            if (!EsVacio( rsTab.Fields.Item("Mnu_Liga").Value )) {
            	sTabsArmados += "javascript:" + rsTab.Fields.Item("Mnu_Liga").Value 
            } else {
                if (EsVacio( rsTab.Fields.Item("Mnu_IDLigaDelTab").Value )) {
                    sTabsArmados += "javascript:CargaContenido(" + rsTab.Fields.Item("Mnu_Orden").Value + ")"
                } else {
                    sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_IDLigaDelTab").Value + ")"
                }
            }		
			sTabsArmados += "\">"  
			sTabsArmados += rsTab.Fields.Item("Mnu_Titulo").Value + "</a>"
			
			// var Ivz =rsTab.Fields.Item("Mnu_Tag3").Value
            //if ( Ivz > 0 ) {       
            	//for(var i=1;i<=Ivz;i++) {
               // 	sTabsArmados += "*" 
               // }
                sTabsArmados += "-"  + rsTab.Fields.Item("Mnu_ID").Value
           // }
			
			sTabsArmados += TraeRamas( rsTab.Fields.Item("Mnu_ID").Value,SisAct)
			sTabsArmados += "xx</li>"
			rsTab.MoveNext()
			
		}
		rsTab.Close()
		
		if (sTabsArmados != ""){
			if (iPadre == 0 ) {                
                sTabsArmados = "<ul class=\"nav\">" + sTabsArmados + "</ul>"
			} else {
				sTabsArmados = "<ul>"  + sTabsArmados + "</ul>"
			}
		}
		
		return sTabsArmados
} 

Response.Write( TraeRamas(VentanaIndex,SistemaActual,Tab3Selec) )

%>
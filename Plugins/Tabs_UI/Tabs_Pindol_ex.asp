

<%
var sTabsArmados = ""
var sCodigoDeLosTabs = ""
var ConSeguridad = false
var iTabSeleccionado = 0
var iPos = 0
 

    var sSQL  = "Select Mnu_ID, Mnu_Padre, Mnu_IDLigaDelTab,Mnu_Titulo "
        sSQL += " from Menu "
        sSQL += " WHERE Mnu_Padre = 100 " //+ VentanaIndex
        sSQL += " AND Sys_ID = 30" //+  SistemaActual
        sSQL += " AND Mnu_EsTab = 1 " 
        sSQL += " AND Mnu_Habilitado = 1 "
        sSQL += " Order by Mnu_Orden " 

var rsTab = AbreTabla(sSQL,1,2) 
if (!rsTab.EOF) {
	//ui-tabs id='tabs' 
    sTabsArmados = "<div class='jq-tabs'>"
    sTabsArmados += "<ul>"
    
	while (!rsTab.EOF){
        LigaDefault = rsTab.Fields.Item("Mnu_ID").Value
		TabTitulo = rsTab.Fields.Item("Mnu_Titulo").Value

        sTabsArmados += "<li>"
        sTabsArmados += "<" + " href='#tab-" + LigaDefault + "' onclick='javascript:CambiaTab(" + LigaDefault + ");' >"
        sTabsArmados += "<i class='icon-bar-chart'></i>" + TabTitulo + "<" + "/" + "a><" + "/" + "li>"
        sCodigoDeLosTabs += "<div id='tab-" + LigaDefault + "'></div>"
		rsTab.MoveNext()
		iPos++
	}
 
	//sCodigoDeLosTabs = "$('#tabs').tabs(); "

	sTabsArmados += "</ul>"
    sTabsArmados += sCodigoDeLosTabs   
    sTabsArmados += "</div>"

	rsTab.Close()
    
} 

sTmpComodin03 = sTabsArmados
//sJQDeTabs = sCodigoDeLosTabs
%>

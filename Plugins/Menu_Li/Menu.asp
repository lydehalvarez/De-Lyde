
var MnuULPadre = 0
var IDMenuRegreso = ""

var sSQLp  = "Select top 1 Mnu_ID, MW_Param "
	sSQLp += " from Menu_Widget "
	sSQLp += " where Sys_ID =  " + SistemaActual
	sSQLp += " AND Mnu_ID <= " + VentanaIndex
	sSQLp += " AND Wgt_ID = 36 "
	sSQLp += " AND MW_Habilitado = 1 "
	sSQLp += " Order by Mnu_ID desc "

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF) {
		MnuULPadre = rsTab.Fields.Item("Mnu_ID").Value
		IDMenuRegreso = rsTab.Fields.Item("MW_Param").Value
	}
rsTab.Close()

if (EsVacio(IDMenuRegreso)) IDMenuRegreso = 90
   
var TituloMenu = ""  
var sSQLp  = "Exec PA_Charisma_Menu_Encabezado " + SistemaActual + ", " + VentanaIndex + ", " + IDMenuRegreso

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF) {
		TituloMenu = rsTab.Fields.Item("TituloMenu").Value
		IDMenuRegreso = rsTab.Fields.Item("IDMenuRegreso").Value
		MnuULPadre = rsTab.Fields.Item("Mnu_Padre").Value        
	}
rsTab.Close()

 
sMenuPrincipal = "<div class='well nav-collapse sidebar-nav'>"
sMenuPrincipal += "<ul class='nav nav-tabs nav-stacked main-menu'>"
sMenuPrincipal += "<li class='nav-header hidden-tablet' >"
sMenuPrincipal += "<a href='javascript:CambiaVentana(" + SistemaActual + "," + IDMenuRegreso + ")' >" + TituloMenu 
sMenuPrincipal += "</a></li>"
    
var sSQLp  = "exec dbo.PA_Charisma_Menu_Cuerpo " + SistemaActual + ", " + MnuULPadre  

var rsTab = AbreTabla(sSQLp,1,2) 
	while (!rsTab.EOF){
		sMenuPrincipal += "<li><a class='ajax-link"
		if (VentanaIndex == rsTab.Fields.Item("Mnu_ID").Value ) { 
        	sMenuPrincipal += " seleccionado' href='#' >"
        } else {
			sMenuPrincipal += "' href='javascript:CambiaVentana(" + SistemaActual + "," + rsTab.Fields.Item("Mnu_ID").Value + ")' >"
		}
		sMenuPrincipal += "<i class='" + rsTab.Fields.Item("Mnu_RutaImagen").Value + "'></i>"
        sMenuPrincipal += "<span class='hidden-tablet'>&nbsp;&nbsp;&nbsp;" + rsTab.Fields.Item("Mnu_TituloVentana1").Value + "</span></a></li>"
		rsTab.MoveNext()
	} 
rsTab.Close()
sMenuPrincipal += "</ul></div>"
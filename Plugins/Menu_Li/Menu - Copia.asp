// DECLARE @Mnu_ID INT = 115
// DECLARE @Sys_ID INT = 2000
// DECLARE @IDMenuRegreso INT = 1 
//
// SELECT @IDMenuRegreso = Mnu_Padre
//   FROM Menu
//  WHERE Sys_ID = @Sys_ID
//    AND Mnu_ID = @Mnu_ID
//
// IF @IDMenuRegreso < @Mnu_ID
//	SET @IDMenuRegreso = @Mnu_ID


var MnuULPadre = 0
var MnuULParam = ""
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
		MnuULParam = rsTab.Fields.Item("MW_Param").Value
	}
rsTab.Close()
 
sMenuPrincipal = "<div class='well nav-collapse sidebar-nav'>"
sMenuPrincipal += "<ul class='nav nav-tabs nav-stacked main-menu'>"
sMenuPrincipal += "<li class='nav-header hidden-tablet' ><a href='#' onclick='javascript:CambiaVentana(" + SistemaActual + "," + MnuULPadre + ")' >Inicio</a></li>"

var sSQLp  = "Select Mnu_Padre, Mnu_ID, Mnu_SiguienteVentana, Mnu_Descripcion, Mnu_TituloVentana1, Mnu_RutaImagen "
	sSQLp += " from Menu "  
	sSQLp += " where Sys_ID = " + SistemaActual
	sSQLp += " and Mnu_Padre = " + MnuULPadre 
	sSQLp += " AND Mnu_EsMenu = 1 "
	sSQLp += " Order by Mnu_Orden " 

var rsTab = AbreTabla(sSQLp,1,2) 
	while (!rsTab.EOF){
		sMenuPrincipal += "<li><a class='ajax-link"
		if (VentanaIndex == rsTab.Fields.Item("Mnu_ID").Value ) { 
        	sMenuPrincipal += " seleccionado' href='#' >"
        } else {
			sMenuPrincipal += "' href='#' onclick='javascript:CambiaVentana(" + SistemaActual + "," + rsTab.Fields.Item("Mnu_ID").Value + ")' >"
		}
		sMenuPrincipal += "<i class='" + rsTab.Fields.Item("Mnu_RutaImagen").Value + "'></i>"
        sMenuPrincipal += "<span class='hidden-tablet'>&nbsp;&nbsp;&nbsp;" + rsTab.Fields.Item("Mnu_TituloVentana1").Value + "</span></a></li>"
		rsTab.MoveNext()
	} 
rsTab.Close()
sMenuPrincipal += "</ul></div>"

sMenuPan = "<ul class=\"breadcrumbs\" id=\"breadcrumbs\">"
sMenuPan += "<li ><a href='javascript:CambiaVentana(" + SistemaActual + ",30 )'>Inicio</a></li>"

var sSQLp  = "Select BC_HTML "
	sSQLp += " from Widget_BreadCrumbs "
    sSQLp += " WHERE Sys_ID = " + SistemaActual
    sSQLp += " AND Mnu_ID = " + VentanaIndex

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF){
		sMenuPan += rsTab.Fields.Item("BC_HTML").Value
	}  else {
        var sSQLp  = "Select Mnu_Padre ,Mnu_ID ,Mnu_SiguienteVentana ,Mnu_Descripcion, Mnu_TituloVentana1 "
            sSQLp += " from ufn_BreadCrumbs( 30," + VentanaIndex + "," + SistemaActual + " ) "
            sSQLp += " Order by Mnu_ID " 
        
        var rsTab = AbreTabla(sSQLp,1,2) 
            while (!rsTab.EOF){
                sMenuPan += "<li " 
                if (VentanaIndex == rsTab.Fields.Item("Mnu_ID").Value ) { 
                    sMenuPan += " class='current' ><a href='#'>"
                } else {
                    sMenuPan += " ><a href='javascript:CambiaVentana(" + SistemaActual + "," + rsTab.Fields.Item("Mnu_ID").Value + ")' >"
                }
                sMenuPan += rsTab.Fields.Item("Mnu_TituloVentana1").Value + "</a></li>"
                rsTab.MoveNext()
            } 
      }

sMenuPan += "</ul>"
  
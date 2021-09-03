
sBreadCrumb = ""
var sSQLp  = "Select BC_HTML "
	sSQLp += " from Widget_BreadCrumbs "
    sSQLp += " WHERE Sys_ID = " + SistemaActual
    sSQLp += " AND Mnu_ID = " + VentanaIndex

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF){
		sBreadCrumb += rsTab.Fields.Item("BC_HTML").Value
	}  else {
        var sSQLp  = "Select Mnu_Padre, Mnu_ID, Mnu_Descripcion, Mnu_TituloVentana1 "
            sSQLp += " from dbo.ufn_BreadCrumbs_Bootstrap(" + VentanaIndex + "," + SistemaActual + ") "
            sSQLp += " Order by ID desc "
        
        var rsBC = AbreTabla(sSQLp,1,2) 
            while (!rsBC.EOF) {
        
                if (sBreadCrumb == "") {
                    sBreadCrumb = "<li>"
                } else { 
                    sBreadCrumb += "<li><span class='divider'></span>"
                }
                sBreadCrumb += "<a href='#' onclick='javascript:CambiaVentana(" + SistemaActual 
                sBreadCrumb += "," + rsBC.Fields.Item("Mnu_ID").Value + ")' >"
                sBreadCrumb += rsBC.Fields.Item("Mnu_TituloVentana1").Value
                sBreadCrumb += "</a></li>"
                rsBC.MoveNext()
            }
        rsBC.Close()
      }

sBreadCrumb = "<ul class='breadcrumb'>" + sBreadCrumb + "</ul>"
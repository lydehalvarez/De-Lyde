
var IDMenuRegreso = 0
var MenuWgCfg_ID = 0
var HayMenu = false
var MnuSeleccionado = ""
var MnuULPadre = 0           
var MnuInspinaConSeguridad = ParametroDeVentana(SistemaActual, -1, "Menu con seguridad", 1)
var MnuInspinaConParamDesarrollo = ParametroDeVentanaConUsuario(SistemaActual, -1, IDUsuario, "Menu muestra parametros", 0)
	sMenuPrincipal = ""
    
var sSQLp  = "Select top 1 Mnu_ID, WgCfg_ID, MW_Param "
	sSQLp += " from Menu_Widget "
	sSQLp += " where Sys_ID = " + SistemaActual
	sSQLp += " AND Mnu_ID <= " + VentanaIndex
	sSQLp += " AND Wgt_ID = 57 "
	sSQLp += " AND MW_Habilitado = 1 "
	sSQLp += " Order by Mnu_ID desc "

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF) {
		MnuULPadre = rsTab.Fields.Item("Mnu_ID").Value   //es para que tome el menu a partir de aqui
		IDMenuRegreso = rsTab.Fields.Item("MW_Param").Value 
		MenuWgCfg_ID = rsTab.Fields.Item("WgCfg_ID").Value   
        HayMenu = true       
	}
rsTab.Close()

MnuSeleccionado = MnuULPadre

function DameRama(Padre, Nivel) {
    var MenuNivel = Nivel + 1
    var sRama = ""
    var sArbol = ""	
	var MNTitulo = ""
    var MNTitulo2 = ""
	var ActiveOpen = false    
	var Mnu_RutaImagen = ""	
    var MNmnuid = 0
    var TieneHijos = false
    var MNmnupadre

    var sSQLp  = "Select distinct * "
        sSQLp += "from dbo.ufn_Menu_Inspina(" + Padre
        sSQLp += ", " + SistemaActual
        sSQLp += ", " + VentanaIndex
        sSQLp += ", " + IDUsuario 
        sSQLp += ", " + SegGrupo
        sSQLp += ", " + MnuInspinaConSeguridad 
        sSQLp += ")"
        sSQLp += " Order by Mnu_Orden "
        if(MnuInspinaConParamDesarrollo == 1) {
            //Response.Write("<br>" + sSQLp)
        }
        
    var rsTab = AbreTabla(sSQLp,1,2) 
        while (!rsTab.EOF){

		        MNmnuid = rsTab.Fields.Item("Mnu_ID").Value
                MNmnupadre = rsTab.Fields.Item("Mnu_Padre").Value                
				MNTitulo = FiltraVacios(rsTab.Fields.Item("Mnu_Titulo").Value)
				Mnu_RutaImagen = FiltraVacios(rsTab.Fields.Item("Mnu_RutaImagen").Value)

				//Cargo lo referente a la rama para preparar su padre
                sRama = DameRama(MNmnuid, MenuNivel)
                TieneHijos = sRama != ""
                
                sArbol += "<li data-mnuid='" + MNmnuid + "' "
                if (MNmnupadre != MnuULPadre ) {
                	sArbol += " data-padre='" + MNmnupadre + "' "
                } else {
                	sArbol += " data-padre='0' "                
                }

                if(MNmnuid == VentanaIndex ) { sArbol += " class='active' "}
                if(VentanaIndex == rsTab.Fields.Item("Mnu_ID_Activo").Value ) { sArbol += " class='active' "}
                sArbol += ">"
               		if (TieneHijos) {
                    	sArbol += "<a href='#'>"                    
                    } else {
                    	sArbol += "<a href='javascript:CambiaVentana(" + SistemaActual + "," + MNmnuid + ")'>"
                    }
                    //if(MenuNivel == 1) { sArbol += "<i class='" + Mnu_RutaImagen + "'></i>" }
                    if(MenuNivel == 1 || MenuNivel == 2 || MenuNivel == 3) { sArbol += "<i class='" + Mnu_RutaImagen + "'></i>" }
                    sArbol += "<span class='nav-label'> " + MNTitulo +" </span>"
                    if (TieneHijos) {
                        sArbol += "<span class='fa arrow'></span>"
                    }
                    sArbol += "</a>"
                    
                if (TieneHijos) {   
                    sArbol += "<ul class='nav nav-second-level collapse'>"
					sArbol += sRama
					sArbol += "</ul>"
                    sRama = ""
                } 
                sArbol += "</li>"                 
                    

            rsTab.MoveNext()
        } 
    rsTab.Close()
    
    
	return sArbol
}

if(HayMenu) {
	sMenuPrincipal = "<li><a href='javascript:IrAlInicio()'><i class='fa fa-home'></i>"
	sMenuPrincipal += "<span class='nav-label'>Inicio</span></a></li>"
	sMenuPrincipal += DameRama(MnuULPadre, 0)
} 
if(MnuInspinaConParamDesarrollo == 1) {
    sMenuPrincipal += "<br />s/m/sv " + SistemaActual + "/" + VentanaIndex + "/"
    if(sSiguienteVentana>0) {
        sMenuPrincipal += "<a href='javascript:CambiaSiguienteVentana(" + sSiguienteVentana + ")'>"
        sMenuPrincipal += sSiguienteVentana + "</a>"
    }    
    var spdrCondicion = "Sys_ID = " + SistemaActual + " and Mnu_ID = " + VentanaIndex
    var PadreID = BuscaSoloUnDato("Mnu_Padre","Menu",spdrCondicion,0,2)
    sMenuPrincipal += "<br />pp " + iUsarPP
    sMenuPrincipal += "<br />padre " + PadreID  + "<br />"    
	sMenuPrincipal += "<div id='dvDsInfoVentana'></div><br /><br />"
}



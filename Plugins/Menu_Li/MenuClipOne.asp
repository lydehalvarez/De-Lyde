
var IDMenuRegreso = 0
var MenuWgCfg_ID = 0
var HayMenu = false
var MnuSeleccionado = ""
var MnuULPadre = 0
var MnuClipOneConSeguridad = 0
var MnuClipOneConParamDesarrollo = ParametroDeVentanaConUsuario(SistemaActual, -1, IDUsuario, "Menu muestra parametros", 0)
	sMenuPrincipal = ""
    
var sSQLp  = "Select top 1 Mnu_ID, WgCfg_ID, MW_Param "
	sSQLp += " from Menu_Widget "
	sSQLp += " where Sys_ID = " + SistemaActual
	sSQLp += " AND Mnu_ID <= " + VentanaIndex
	sSQLp += " AND Wgt_ID = 50 "
	sSQLp += " AND MW_Habilitado = 1 "
	sSQLp += " Order by Mnu_ID desc "

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF) {
		MnuULPadre = rsTab.Fields.Item("Mnu_ID").Value   //es para que tome el menu a partir de aqui
		IDMenuRegreso = rsTab.Fields.Item("MW_Param").Value 
		MenuWgCfg_ID = rsTab.Fields.Item("WgCfg_ID").Value   
        HayMenu = true 
        MnuClipOneConSeguridad = ParametroDeVentana(SistemaActual, MnuULPadre, "Con Seguridad", 1)         
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

	// ufn_Menu_ClipOne ( @Mnu_Padre, @Sys_ID, @Usu_ID, @bConSeguridad )
    var sSQLp  = "Select distinct * "
        sSQLp += "from dbo.ufn_Menu_ClipOne(" + Padre
        sSQLp += ", " + SistemaActual
        sSQLp += ", " + IDUsuario 
        sSQLp += ", " + SegGrupo
        sSQLp += ", " + MnuClipOneConSeguridad 
        sSQLp += ")"
        sSQLp += " Order by Mnu_Orden "
        if(MnuClipOneConParamDesarrollo == 1) {
            //Response.Write("<br>" + sSQLp)
        }
    var rsTab = AbreTabla(sSQLp,1,2) 
        while (!rsTab.EOF){
        		ActiveOpen = false
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

                if(MNmnuid == VentanaIndex ) { sArbol += " class='active open' "}
                sArbol += ">"
               		if (TieneHijos) {
                    	sArbol += "<a href='#'>"                    
                    } else {
                    	sArbol += "<a href='javascript:CambiaVentana(" + SistemaActual + "," + MNmnuid + ")'>"
                    }
                    if(MenuNivel == 1 ) { sArbol += "<i class='" + Mnu_RutaImagen + "'></i>" }
                        sArbol += "<span class='title'> " + MNTitulo +" </span>"
                        if (TieneHijos) {
                        	sArbol += "<i class='icon-arrow'></i>"
                        }
                        sArbol += "<span class='selected'></span>"
                    sArbol += "</a>"
                    
                if (TieneHijos) {   
                    sArbol += "<ul class='sub-menu'>"
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
	sMenuPrincipal = "<ul class='main-navigation-menu' id='MenuPrincipal'>"
	sMenuPrincipal += "<li data-mnuid='-1'>"
	sMenuPrincipal += "<a href='javascript:CambiaVentana(" + SistemaActual + "," + MnuULPadre + ")'>"
	sMenuPrincipal += "<i class='clip-home-3'></i><span class='title'> Inicio </span><span class='selected'></span></a></li>"
	sMenuPrincipal += DameRama(MnuULPadre, 0)
	sMenuPrincipal += "</ul>"

    var sCondicion = " Sys_ID = " + SistemaActual + " AND Mnu_ID = " + VentanaIndex
    MnuSeleccionado = BuscaSoloUnDato("Mnu_Padre","Menu",sCondicion,MnuULPadre,2)
    sMenuPrincipal += "<input type='hidden' id='MNUSL' value='"+ MnuSeleccionado +"'>"  
} 
if(MnuClipOneConParamDesarrollo == 1) {
    sMenuPrincipal += "<br />s/m " + SistemaActual + "/" + VentanaIndex
    sMenuPrincipal += "<br />pp " + iUsarPP  + "<br />"
	sMenuPrincipal += "<div id='dvDsInfoVentana'></div>"
}

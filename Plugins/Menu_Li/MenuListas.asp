
var IDMenuRegreso = 0
var MenuWgCfg_ID = 0

var sSQLp  = "Select top 1 Mnu_ID, WgCfg_ID, MW_Param "
	sSQLp += " from Menu_Widget "
	sSQLp += " where Sys_ID =  " + SistemaActual
	sSQLp += " AND Mnu_ID <= " + VentanaIndex
	sSQLp += " AND Wgt_ID = 44 "
	sSQLp += " AND MW_Habilitado = 1 "
	sSQLp += " Order by Mnu_ID desc "

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF) {
		MnuULPadre = rsTab.Fields.Item("Mnu_ID").Value   //es para que tome el menu a partir de aqui
		IDMenuRegreso = rsTab.Fields.Item("MW_Param").Value 
		MenuWgCfg_ID = rsTab.Fields.Item("WgCfg_ID").Value                
	}
rsTab.Close()


function DameRama(Padre, Nivel) {
    var MenuNivel = Nivel + 1
    var sRama = ""
    var bTieneHijos = false
	var Hijos = 0
    var iCntM = 1
    var MNmnuid = 0

    var sSQLp  = "Select * "
        sSQLp += "from dbo.ufn_Menu_EnFormaDeLista(" + Padre
        sSQLp += ", " + SistemaActual
        sSQLp += ", " + IDUsuario // Usu_ID
        sSQLp += ", " + iqCli_ID  // iqCliID   
        sSQLp += ", 44 " 
        sSQLp += ", " + MenuWgCfg_ID       
        sSQLp += ", 0" // bConSeguridad
        sSQLp += ") order by Orden"
       
    var rsTab = AbreTabla(sSQLp,1,2) 
        while (!rsTab.EOF){
		        MNmnuid = rsTab.Fields.Item("Mnu_ID").Value
				Hijos = rsTab.Fields.Item("Hijos").Value
        		if (MenuNivel > 1 && iCntM == 1) {
                    sRama += "<ul class='sub-menu' style='display: none;'>"
                }
                iCntM = iCntM + 1
                bTieneHijos = true
                sRama += "<li class='menu-item menu-item-type-post_type menu-item-object-page"
                if (VentanaIndex == MNmnuid) {
                    sRama += " current-menu-item "
                }
                sRama += "' >"
				if(Hijos == 0) {
					sRama += "<" + "a href='"
					sRama += "javascript:CambiaVentana(" + SistemaActual 
					sRama += "," + MNmnuid + ")'"
					sRama += " >" + rsTab.Fields.Item("Mnu_Titulo").Value + "<" + "/" + "a>"
				} else {
					sRama += "<" + "a href='"
					sRama += "javascript:void(0)'"
					sRama += " >" + rsTab.Fields.Item("Mnu_Titulo").Value + "<" + "/" + "a>"
                	sRama += DameRama( MNmnuid , MenuNivel)
				}
                sRama += " </li>" 
            rsTab.MoveNext()
        } 
    rsTab.Close()
    
    if (MenuNivel > 1 && bTieneHijos ) {
    	sRama += "</ul>"
    } 
    
	return sRama
}

sMenuPrincipal = "<nav id='menu' class='menu-main-menu-container'>"
sMenuPrincipal += "<ul id='menu-main-menu' class='menu'>"
sMenuPrincipal += "<li class='menu-item menu-item-type-post_type menu-item-object-page"
if (VentanaIndex == MnuULPadre) {
	sMenuPrincipal += " current-menu-item "
}
sMenuPrincipal += "' >"
sMenuPrincipal += "<" + "a href='javascript:CambiaVentana(" + SistemaActual + "," + MnuULPadre + ")' >Inicio<"
sMenuPrincipal += "/a></li>" 
sMenuPrincipal += DameRama(MnuULPadre, 0)
sMenuPrincipal += "<li class='menu-item menu-item-type-post_type menu-item-object-page last' >"
sMenuPrincipal += "<" + "a href='javascript:CambiaVentana(" + SistemaActual + "," + IDMenuRegreso + ")' >Salir<"
sMenuPrincipal += "/a></li>" 
sMenuPrincipal += "</ul></nav>"
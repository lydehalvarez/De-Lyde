
var sTabsArmados = ""
var sCodigoDeLosTabs = ""
var ConSeguridad = false
var iTabSeleccionado = 0
var iPos = 0


    var sSQL  = " SELECT * FROM UsuarioAcceso "
        sSQL += " WHERE UsuA_Sesion = '" + String(Session.SessionID) + "' "
        sSQL += " AND UsuA_SesionVigente = 1 "
        sSQL += " AND Usu_ID = " + IDUsuario
        sSQL += " AND Sys_ID = " + SistemaActual
        
    var rsCont = AbreTabla(sSQL,1,3)
        if (!rsCont.EOF){
            SegGrupo =  rsCont.Fields.Item("UsuA_Grupo").Value 
        }
        rsCont.Close()
        
        
if (ConSeguridad) {
         var sSQL = " Select * " 
            sSQL += " from Menu ,systobjects "
            //sSQL += " where Mnu_Padre = " + iPadre
            sSQL += " WHERE Mnu_Padre = (select Mnu_Padre from Menu where Mnu_ID = " + VentanaIndex
            sSQL +=                   " AND Sys_ID = " +  SistemaActual
            sSQL +=                   " AND Mnu_EsTab = 1 AND Mnu_Habilitado = 1 ) "            
            sSQL += " AND Sys_ID = " + SistemaActual
            sSQL += " AND sys1 = 1 "   //solo valido por los permisos de acceso
            sSQL += " AND sys6 = " + SistemaActual
            sSQL += " AND sys3 = Mnu_IDSeguridad "
             if (SegGrupo == -1 ) {
                sSQL += " AND sys2 = " + IDUsuario
                sSQL += " AND sys7 = -1 "
             } else {
                sSQL += " AND sys2 = -1 " 
                sSQL += " AND sys7 = " + SegGrupo
             }
            sSQL += " AND Menu.Mnu_Habilitado = 1 "
            sSQL += " AND Menu.Mnu_EsTab = 1 " 
            sSQL += " AND Menu.Sys_ID = " + SistemaActual 
            sSQL += " Order by Mnu_Orden "     

} else {
    var sSQL  = "Select Mnu_ID, Mnu_Padre, Mnu_IDLigaDelTab,Mnu_Titulo "
        sSQL += " from Menu "
        sSQL += " WHERE Mnu_Padre = (select Mnu_Padre from Menu where Mnu_ID = " + VentanaIndex
        sSQL +=                   " AND Sys_ID = " +  SistemaActual
        sSQL +=                   " AND Mnu_EsTab = 1 AND Mnu_Habilitado = 1 ) "
    //    sSQL +=       " OR Mnu_ID = (select Mnu_Padre from Menu where Mnu_ID = " + VentanaIndex + " AND Sys_ID = " + SistemaActual
    //    sSQL +=                   "  AND Mnu_EsTab = 1 AND Mnu_Habilitado = 1 ) "
    //    sSQL +=     "  ) "
        sSQL += " AND Sys_ID = " +  SistemaActual
        sSQL += " AND Mnu_EsTab = 1 " 
        sSQL += " AND Mnu_Habilitado = 1 "
        sSQL += " Order by Mnu_Orden " 
}

var rsTab = AbreTabla(sSQL,1,2) 
if (rsTab.EOF) {
	// se trata de una ventana sin tabs
	TabIndex = -1
	ParametroCambiaValor("TabIndex",-1)
} else  {
    TabIndex = VentanaIndex
    ParametroCambiaValor("TabIndex",TabIndex)
	sFuncionCase = ""
    sTabsArmados = "<div id=\"tabs\" class=\"ui-tabs\"><ul>"

    //estoy buscando de donde viene si es un reenvio incluyo como tab para regresar basado en el campo de siguiente ventana
    var sCondicionTabSeguimiento = " Sys_ID = " +  SistemaActual
    	sCondicionTabSeguimiento += " AND Mnu_SiguienteVentana = " + rsTab.Fields.Item("Mnu_Padre").Value
       // sCondicionTabSeguimiento += " AND Mnu_SiguienteVentana = (select Mnu_Padre "
       // sCondicionTabSeguimiento += " from Menu where Mnu_ID = " + VentanaIndex + " AND Sys_ID = " +  SistemaActual + " ) "
        sCondicionTabSeguimiento += " AND Mnu_SiguienteVentana > 0 " 
    var TabRegreso = BuscaSoloUnDato("Mnu_ID","Menu",sCondicionTabSeguimiento,"",2)   
	if (TabRegreso != "") {
        var TabTitCondicion = "Mnu_ID = " + TabRegreso + " AND Sys_ID = " +  SistemaActual
        var TabTitulo = BuscaSoloUnDato("Mnu_Titulo","Menu",TabTitCondicion,"",2)
		sFuncionCase += " case " + iPos + ": "
		sFuncionCase += "  CambiaTab(" + TabRegreso + ");  "
		sFuncionCase += "  break; "
		sTabsArmados += "<li><a href=\"#tabs-" + iPos + "\">" + TabTitulo  + "</a></li>"
		sDivsTabs += "<div id=\"tabs-" + iPos + "\" class=\"ui-tabs-hide\"></div>"
		iPos++       
	}
    //estoy buscando de donde viene si es un reenvio incluyo como tab para regresar basado en el concepto de que un tab tenga como hijos otros tabs
    var sCondicionTabSeguimiento = " Sys_ID = " +  SistemaActual
    	sCondicionTabSeguimiento += " AND Mnu_ID = (select Mnu_Padre "
        sCondicionTabSeguimiento +=                 " from Menu where Mnu_ID = " +  rsTab.Fields.Item("Mnu_Padre").Value 
        sCondicionTabSeguimiento +=                 " AND Sys_ID = " +  SistemaActual 
        sCondicionTabSeguimiento +=                 " AND Mnu_EsMenu = 0 ) "
    var TabRegreso = BuscaSoloUnDato("Mnu_ID","Menu",sCondicionTabSeguimiento,"",2)  
    
     
	if (TabRegreso != "") {
        var TabTitCondicion = "Mnu_ID = " + TabRegreso + " AND Sys_ID = " +  SistemaActual
        var TabTitulo = BuscaSoloUnDato("Mnu_Titulo","Menu",TabTitCondicion,"",2)
		sFuncionCase += " case " + iPos + ": "
		sFuncionCase += "  CambiaTab(" + TabRegreso + ");  "
		sFuncionCase += "  break; "
		sTabsArmados += "<li><a href=\"#tabs-" + iPos + "\">" + TabTitulo  + "</a></li>"
		sDivsTabs += "<div id=\"tabs-" + iPos + "\" class=\"ui-tabs-hide\"></div>"
		iPos++       
	}
    
    
//    var sCondicionTabSeguimiento = " Sys_ID = " +  SistemaActual
//    	sCondicionTabSeguimiento += " and  Mnu_Padre = " + rsTab.Fields.Item("Mnu_Padre").Value
//		sCondicionTabSeguimiento += " and Mnu_Orden = (select min(Mnu_Orden) from Menu "
//    	sCondicionTabSeguimiento += " where Mnu_Padre = " + rsTab.Fields.Item("Mnu_Padre").Value
//    	sCondicionTabSeguimiento += " and Sys_ID = 1) "
//    var TabMenor = BuscaSoloUnDato("top 1 Mnu_ID","Menu",sCondicionTabSeguimiento,"",2)  
//	if (TabMenor == VentanaIndex ) {
//		TabIndex = VentanaIndex
//		ParametroCambiaValor("TabIndex",TabIndex) 
//	}

	while (!rsTab.EOF){
        LigaDefault = rsTab.Fields.Item("Mnu_ID").Value
//        //if (TabIndex == -1 ) {
//            TabIndex = rsTab.Fields.Item("Mnu_ID").Value
//            ParametroCambiaValor("TabIndex",TabIndex) 
//        //}

		if (TabIndex == rsTab.Fields.Item("Mnu_ID").Value ) { iTabSeleccionado = iPos }
		sFuncionCase += " case " + iPos + ": "
		if (EsVacio( rsTab.Fields.Item("Mnu_IDLigaDelTab").Value )) {
			sFuncionCase += "  CambiaTab(" + rsTab.Fields.Item("Mnu_ID").Value + ");  "
		} else {
			sFuncionCase += "  CambiaTab(" + rsTab.Fields.Item("Mnu_IDLigaDelTab").Value + ");  "
		}
		sFuncionCase += "  break; "
		sTabsArmados += "<li><a href=\"#tabs-" + iPos + "\">" + rsTab.Fields.Item("Mnu_Titulo").Value + "</a></li>"
		sDivsTabs += "<div id=\"tabs-" + iPos + "\" class=\"ui-tabs-hide\"></div>"
		rsTab.MoveNext()
		iPos++
	}
	//Response.Write("$('#tabs').tabs();")
	sCodigoDeLosTabs = "$('#tabs').tabs({ selected: " + iTabSeleccionado + " }); "
	sCodigoDeLosTabs += "$('#tabs').bind('tabsselect', function(event, ui) { "
	sCodigoDeLosTabs += " var Ruta = ''; "
	sCodigoDeLosTabs += " switch (ui.index) {  "	 		
	sCodigoDeLosTabs += sFuncionCase
	sCodigoDeLosTabs += "  default: "
	sCodigoDeLosTabs += " CambiaTab(" + LigaDefault + "); "  
	sCodigoDeLosTabs += "  break; "
	sCodigoDeLosTabs += " }  "
	sCodigoDeLosTabs += "  document.frmDatos.submit(); "
	sCodigoDeLosTabs += "  });"
	//sTabsArmados += "</ul>" + sDivsTabs + "</div>"
	sTabsArmados += "</ul></div>"

	rsTab.Close()
    
} 

sTmpComodin03 = sTabsArmados
sJQDeTabs = sCodigoDeLosTabs

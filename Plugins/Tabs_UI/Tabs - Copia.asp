
var sTabsArmados = ""
var sCodigoDeLosTabs = ""
var iPos = 0
iTabSeleccionado = 0
var sFuncionCase = ""
var TabInicial = 0

 
var sSQL  = "Select * "
	sSQL += " from Menu "
	sSQL += " WHERE Mnu_Padre = (select Mnu_Padre from Menu where Mnu_ID = " + VentanaIndex + " AND Sys_ID = " +  SistemaActual 
    sSQL +=                   " AND Mnu_EsTab = 1 AND Mnu_Habilitado = 1 ) "
	sSQL += " AND Mnu_EsTab = 1 " 
    sSQL += " AND Sys_ID = " +  SistemaActual   
	sSQL += " AND Mnu_Habilitado = 1 "
	sSQL += " Order by Mnu_Orden " 

var rsTab = AbreTabla(sSQL,1,0)
if (rsTab.EOF) {
	// se trata de una ventana sin tabs
	TabIndex = -1
	ParametroCambiaValor("TabIndex",TabIndex)
    
} else  {


//estoy buscando de donde viene si es un reenvio incluyo como tab para regresar
var sCondicionTabSeguimiento = " Sys_ID = " +  SistemaActual
	sCondicionTabSeguimiento += " AND Mnu_SiguienteVentana = (select Mnu_Padre "
	sCondicionTabSeguimiento += "  from Menu where Mnu_ID = " + VentanaIndex + " AND Sys_ID = " +  SistemaActual + ")"
var TabRegreso = BuscaSoloUnDato("Mnu_ID","Menu",sCondicionTabSeguimiento,"",0)   
 
//if (TabRegreso != "") {
//    var TabTitCondicion = "Mnu_ID = " + TabRegreso
//    var TabTitulo = BuscaSoloUnDato("Mnu_Titulo","Menu",TabTitCondicion,"",0)
//    sTabsArmados = "<div id=\"tabs\" class=\"ui-tabs\"><ul>"
//    sTabsArmados += "<li><a href=\"#tabs-" + iPos + "\">" + TabTitulo + "</a></li>"
//    sDivsTabs += "<div id=\"tabs-" + iPos + "\" class=\"ui-tabs-hide\"></div>"
//    TabIndex = TabRegreso
//    ParametroCambiaValor("TabIndex",TabIndex)
//    sFuncionCase += " case " + iPos + ": "
//    sFuncionCase += "  CambiaTab(" + TabRegreso + ");  "
//    sFuncionCase += "  break; "
//    iPos = 1
//    TabInicial = 1
//}

	while (!rsTab.EOF){
		if (iPos == TabInicial) {
			LigaDefault = rsTab.Fields.Item("Mnu_ID").Value
			if (TabIndex == -1 ) {
				TabIndex = rsTab.Fields.Item("Mnu_ID").Value
				ParametroCambiaValor("TabIndex",TabIndex) 
			}
		}

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
	sCodigoDeLosTabs += " var Ruta = '';   "
	sCodigoDeLosTabs += " switch (ui.index) {  "	 		
	sCodigoDeLosTabs += sFuncionCase
	sCodigoDeLosTabs += "  default: "
	sCodigoDeLosTabs += " CambiaTab(" + LigaDefault + ");  "
	sCodigoDeLosTabs += "  break; "
	sCodigoDeLosTabs += " }  "
	sCodigoDeLosTabs += "  document.frmDatos.submit(); "
	sCodigoDeLosTabs += "  });"
	//sTabsArmados += "</ul>" + sDivsTabs + "</div>"
	sTabsArmados += "</ul></div>"

	rsTab.Close()

sTmpComodin03 = sTabsArmados
sTmpComodin04 = sCodigoDeLosTabs

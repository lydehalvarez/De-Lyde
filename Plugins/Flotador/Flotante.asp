
var sFlPlantilla = ""  

function SustituyeComodin(Plantilla, sNombreVar, ValorVar) {
	var iInicioCampo = 0
	var sVariable = "{" + sNombreVar + "}"
	iInicioCampo = Plantilla.indexOf(sVariable)   
	if (iInicioCampo > 0) {
		Plantilla = Plantilla.replace( sVariable , ValorVar)        
		Plantilla = SustituyeComodin(Plantilla, sNombreVar, ValorVar)
	}
    
    return Plantilla
}

var flWgCfg_ID = 0
var flMW_Param = ""
var sSQLp  = "Select top 1 Mnu_ID, MW_Param, WgCfg_ID "
	sSQLp += " from Menu_Widget "
	sSQLp += " where Sys_ID =  " + SistemaActual
	sSQLp += " AND Mnu_ID <= " + VentanaIndex
	sSQLp += " AND Wgt_ID = 39 "
	sSQLp += " AND MW_Habilitado = 1 "
	sSQLp += " Order by Mnu_ID desc "

var rsTab = AbreTabla(sSQLp,1,2) 
	if (!rsTab.EOF) {
		flWgCfg_ID = rsTab.Fields.Item("WgCfg_ID").Value
		flMW_Param = rsTab.Fields.Item("MW_Param").Value
	}
rsTab.Close()
var smfCondicion = " Sys_ID = " + SistemaActual + " AND Mnu_ID = " + VentanaIndex
var HayConf = BuscaSoloUnDato("count(*)","MenuFlotante",smfCondicion,0,2)

var sSQLp  = "select Fl_ID, Fl_Tipo, Fl_Renglon "
	sSQLp += ", Fl_NombreDiv, Fl_Span, Fl_Identificador "
	sSQLp += ", Fl_Icono, Fl_Titulo, Fl_TieneConfiguracion "
	sSQLp += ", Fl_TieneMinimizar, Fl_TieneCerrar "
	sSQLp += " from MenuFlotante "
	sSQLp += " where Sys_ID = " + SistemaActual
    if (HayConf ==0 ) {
		sSQLp += " AND Mnu_ID = -1 "     
    } else {
		sSQLp += " AND Mnu_ID = " + VentanaIndex
    }
	sSQLp += " AND Fl_Habilitado = 1 "
	sSQLp += " Order by Fl_Renglon, Fl_Orden "

var iRenAnterior = -1
var iRenActual = -1
var iRenIniciado = false
var iTipoAnterior = -1
var iTipoActual = -1
var Fl_BotonConfiguracion = ""
var Fl_BotonMinimizar = ""
var Fl_BotonCerrar = ""
var Fl_Encabezado = ""
var Fl_Caja = ""

          
var rsRenglon = AbreTabla(sSQLp,1,2) 
    while (!rsRenglon.EOF){
    	iTipoActual = rsRenglon.Fields.Item("Fl_Tipo").Value
    	if (iTipoAnterior != iTipoActual ) {       
            var sSQLwf  = "select Fl_Box1Encabezado, Fl_Box1 "
                sSQLwf += ", Fl_Box2Encabezado, Fl_Box2 "
                sSQLwf += ", Fl_BotonConfiguracion, Fl_BotonMinimizar, Fl_BotonCerrar "
                sSQLwf += " from Widget_Flotador "
                sSQLwf += " where Sys_ID = " + SistemaActual
                sSQLwf += " AND WgCfg_ID = " + flWgCfg_ID
                
            var rswf = AbreTabla(sSQLwf,1,2) 
                if (!rswf.EOF) {
					if (iTipoActual == 1) {
                    	Fl_Encabezado = rswf.Fields.Item("Fl_Box1Encabezado").Value
						Fl_Caja = rswf.Fields.Item("Fl_Box1").Value
                    }
					if (iTipoActual == 2) {
                    	Fl_Encabezado = rswf.Fields.Item("Fl_Box2Encabezado").Value
						Fl_Caja = rswf.Fields.Item("Fl_Box2").Value
                    }
                    Fl_BotonConfiguracion = rswf.Fields.Item("Fl_BotonConfiguracion").Value
                    Fl_BotonMinimizar = rswf.Fields.Item("Fl_BotonMinimizar").Value
                    Fl_BotonCerrar = rswf.Fields.Item("Fl_BotonCerrar").Value 
                }
            rswf.Close()  
            iTipoAnterior = iTipoActual 
        }

    	iRenActual = rsRenglon.Fields.Item("Fl_Renglon").Value
		if (iRenAnterior != iRenActual) {
        	iRenAnterior = iRenActual
        	if (iRenIniciado) {
            	iRenIniciado = false
                sFlPlantilla += "</div>"
            }
            iRenIniciado = true 
        	sFlPlantilla += Fl_Encabezado
        }
		sFlPlantilla += Fl_Caja
		
		sFlPlantilla = SustituyeComodin(sFlPlantilla, "Span", rsRenglon.Fields.Item("Fl_Span").Value)
		sFlPlantilla = SustituyeComodin(sFlPlantilla, "NombreDiv", rsRenglon.Fields.Item("Fl_NombreDiv").Value)
		sFlPlantilla = SustituyeComodin(sFlPlantilla, "Icono", rsRenglon.Fields.Item("Fl_Icono").Value)
		sFlPlantilla = SustituyeComodin(sFlPlantilla, "Titulo", rsRenglon.Fields.Item("Fl_Titulo").Value)
        
		if (rsRenglon.Fields.Item("Fl_TieneConfiguracion").Value == 1 ) {
			sFlPlantilla = SustituyeComodin(sFlPlantilla, "BotonConfiguracion", Fl_BotonConfiguracion)
		} else {
			sFlPlantilla = SustituyeComodin(sFlPlantilla, "BotonConfiguracion", "")
		}
        sFlPlantilla = SustituyeComodin(sFlPlantilla, "Identificador", rsRenglon.Fields.Item("Fl_Identificador").Value)
        
		if (rsRenglon.Fields.Item("Fl_TieneMinimizar").Value == 1 ) {
			sFlPlantilla = SustituyeComodin(sFlPlantilla, "BotonMinimizar", Fl_BotonMinimizar)
		} else {
			sFlPlantilla = SustituyeComodin(sFlPlantilla, "BotonMinimizar", "")
		}	
		if (rsRenglon.Fields.Item("Fl_TieneCerrar").Value == 1 ) {
			sFlPlantilla = SustituyeComodin(sFlPlantilla, "BotonCerrar", Fl_BotonCerrar)
		} else {
			sFlPlantilla = SustituyeComodin(sFlPlantilla, "BotonCerrar", "")
		}
		
        
		rsRenglon.MoveNext()
	} 
rsRenglon.Close() 
    
if (iRenIniciado) {
    sFlPlantilla += "</div>"
 } 
    
sFlotantes = sFlPlantilla

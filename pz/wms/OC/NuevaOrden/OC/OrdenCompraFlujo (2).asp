<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
    var bDebIQ4 = ParametroDeVentanaConUsuario(SistemaActual, VentanaIndex, IDUsuario, "Debug", 0)
	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)
	var ProT_ID = Parametro("ProT_ID",-1)
	var Pro_ID = Parametro("Pro_ID",0)
	var OC_Serie = Parametro("OC_Serie",-1)

	var For_Archivo = ""
	var For_ArchivoJS = ""
	var For_Parametros = ""
	var For_Nombre = ""
	var For_Descripcion = ""
	var For_ArchivoCSS = ""
	var For_ID = -1
	var OC_BPM_Pro_ID = -1
	var OC_BPM_Flujo = -1
	var OC_BPM_Estatus = -1
	var Estatuspalyiorch = ""
	
	//if(Prov_ID == 0) {
		var sSQL = "SELECT Prov_ID, OC_ID, OC_BPM_Pro_ID, OC_BPM_Flujo, OC_BPM_Estatus  "
		    sSQL += " ,dbo.tuf_BPM_OrdenCompra_DondeEstoy(OC_ID) as EstatusYRCH "
			sSQL += " FROM OrdenCompra "
			sSQL += " WHERE OC_ID = " + OC_ID
			
		var rsOC = AbreTabla(sSQL,1,0)
		if (!rsOC.EOF){
			//Prov_ID = rsOC.Fields.Item("Prov_ID").Value
			//OC_ID = rsOC.Fields.Item("OC_ID").Value
			Estatuspalyiorch = rsOC.Fields.Item("EstatusYRCH").Value	
			OC_BPM_Pro_ID = rsOC.Fields.Item("OC_BPM_Pro_ID").Value	
			OC_BPM_Flujo = rsOC.Fields.Item("OC_BPM_Flujo").Value	
			OC_BPM_Estatus = rsOC.Fields.Item("OC_BPM_Estatus").Value	
			if(	Prov_ID > 0 ) {
				ParametroCambiaValor("Prov_ID",Prov_ID)
				ParametroCambiaValor("OC_ID",OC_ID)
			}
		}
		
Pro_ID = OC_BPM_Pro_ID
	//}
var sCondEstts = " Pro_ID = " + OC_BPM_Pro_ID
var Pro_ModoEdicion = BuscaSoloUnDato("Pro_ModoEdicion","BPM_Proceso",sCondEstts,0,0) 

if(bDebIQ4){
	 Response.Write("<br>47) Modo Edicion: " + Pro_ModoEdicion + " Pro_ID: " + Pro_ID)
     Response.Write("<br>47) OC_BPM_Pro_ID: " + OC_BPM_Pro_ID + " OC_BPM_Flujo:" + OC_BPM_Flujo + " OC_BPM_Estatus:" + OC_BPM_Estatus)
	 Response.Write("<br>48) Donde estoy: " + Estatuspalyiorch)
}
	 
    function ProcesaBuscadorDeParametros(sValor) {

        var sRespuesta = sValor
        var arrPrm    = new Array(0)
        var iPos = sRespuesta.indexOf("{");
        if (iPos > -1) {
            var Antes = sRespuesta.substr(0, iPos);
            var Despues = sRespuesta.substr(iPos  + 1, sRespuesta.length - iPos)
            var iPos2 = Despues.indexOf("}");
            var sParm = Despues.substr(0, iPos2);
            var Despues = Despues.substr(iPos2 + 1, Despues.length - iPos2)
            // resuelve el parametro
            var arrPrm = sParm.split(",")
            var sTmpPP = Parametro(arrPrm[0],arrPrm[1])
            sRespuesta = Antes + sTmpPP + Despues
            sRespuesta = ProcesaBuscadorDeParametros(sRespuesta)
        } 
        return sRespuesta

    }	

	var sSQL = "SELECT For_ID "
	    sSQL += " FROM OrdenCompra o, BPM_Proceso_Formulario f "
		sSQL += " WHERE OC_ID = " + OC_ID
		sSQL += " AND o.OC_BPM_Pro_ID = f.Pro_ID "
		sSQL += " AND o.OC_BPM_Flujo = f.ProF_ID "
		sSQL += " AND o.OC_BPM_Estatus = f.ProE_ID "		
		
	var rsOC = AbreTabla(sSQL,1,0)
    if (!rsOC.EOF){
		For_ID = rsOC.Fields.Item("For_ID").Value								
	}
	rsOC.Close()
    
    if(bDebIQ4){
        Response.Write("<br>67) BPM_Proceso_Formulario For_ID = " + For_ID + " query:" + sSQL)
	}
    
	if(For_ID == -1) {  
		var sSQL = "SELECT For_ID "
			sSQL += " FROM BPM_Proceso_Flujo p , OrdenCompra o "
			sSQL += " WHERE o.OC_ID = " + OC_ID
			sSQL += " AND o.OC_BPM_Pro_ID = p.Pro_ID "
			sSQL += " AND o.OC_BPM_Flujo = p.ProF_ID "
		var rsOC = AbreTabla(sSQL,1,0)
		if (!rsOC.EOF){
			For_ID = rsOC.Fields.Item("For_ID").Value								
		}
		rsOC.Close()
	}
    
    if(bDebIQ4){
        Response.Write("<br>81) BPM_Proceso_Flujo For_ID = " + For_ID + " query:" + sSQL)
    }
    
    if(For_ID == -1) {  
		var sSQL = "SELECT For_ID "
			sSQL += " FROM BPM_Proceso p , OrdenCompra o "
			sSQL += " WHERE o.OC_ID = " + OC_ID
			sSQL += " AND o.OC_BPM_Pro_ID = p.Pro_ID "
		var rsOC = AbreTabla(sSQL,1,0)
		if (!rsOC.EOF){
			For_ID = rsOC.Fields.Item("For_ID").Value								
		}
		rsOC.Close()
	}	
    
    if(bDebIQ4){
        Response.Write("<br>93) BPM_Proceso For_ID = " + For_ID + " query:" + sSQL)
    }
    
	if(For_ID > -1) {	
		var sSQL = "SELECT * "
			sSQL += " FROM Formato "
			sSQL += " WHERE For_ID = " + For_ID
    if(bDebIQ4){
        Response.Write("<br>98) query:" + sSQL)			
	}
    
        var rsFormato = AbreTabla(sSQL,1,0)
		if (!rsFormato.EOF){
			For_Archivo = FiltraVacios( rsFormato.Fields.Item("For_Archivo").Value )
			For_ArchivoJS = FiltraVacios( rsFormato.Fields.Item("For_ArchivoJS").Value )
			For_Parametros = FiltraVacios( rsFormato.Fields.Item("For_Parametros").Value )
			For_Nombre = FiltraVacios( rsFormato.Fields.Item("For_Nombre").Value )
			For_Descripcion = FiltraVacios( rsFormato.Fields.Item("For_Descripcion").Value )	
			For_ArchivoCSS = FiltraVacios( rsFormato.Fields.Item("For_ArchivoCSS").Value )			
		} else {
			Response.Write("<h1>No se ha configurado un archivo para este proceso</h1>")		
		} 
	} else {
		Response.Write("<h1>No se ha configurado un archivo para este proceso</h1>")	
	}
	
	if(For_Parametros != "") {
		For_Parametros = "?" + ProcesaBuscadorDeParametros(For_Parametros)
	}
	if(bDebIQ4){
        Response.Write("<br>89) Archivo a manejar:" + For_Archivo)
	    Response.Write("<br>89) parametros a lanzar:" + For_Parametros)
    }
if(For_Archivo != ""){	
%>
<!--div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox-content">    
        <div class="ibox">          
              <div class="btn-group pull-right" id="BPMBotones"></div>
              <div class="btn-group pull-right" id="BPMEstatus"></div>
        </div> 
    </div> 
    <div class="row">
        <div class="ibox">         
            <div class="ibox-content" id="dvFor_Archivo">
            </div>
        </div>    
    </div>
</div-->
<div class="ibox">
    <div class="ibox-content">
        <div class="row">
            <div class="col-md-12 btnBPM">
                <div id="areabotones" style="text-align: right;">
                      <div class="btn-group pull-right" id="BPMBotones"></div>
                      <div class="btn-group pull-right" id="BPMEstatus"></div>
                </div>
            </div>
        </div>
<% if(Pro_ModoEdicion == 1) { %>
        <div class="row" id="dvModoEdicion"></div> 
<% } %>     
        
    </div>
</div>
<div class="ibox-content  forum-container" id="dvFor_Archivo"></div>    
    
<!--div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal" style="overflow-x: auto;">    
        <div class="ibox">
          <div class="ibox-content">
            <div class="row">
              <div class="col-md-12 btnBPM">
                <div class="col-md-offset-6 col-md-5" id="areabotones" style="text-align: right;">
                      <div class="btn-group pull-right" id="BPMBotones"></div>
                      <div class="btn-group pull-right" id="BPMEstatus"></div>
                </div>
              </div>
            </div>
            <div class="row">
                <div class="ibox">         
                    <div class="ibox-content" id="dvFor_Archivo">
                    </div>
                </div>    
            </div>      
          </div>
        </div>
    </div>    
</div-->
<%  }
 	if(For_ArchivoCSS != ""){  
		Response.Write("<link href='" + For_ArchivoCSS + "' rel='stylesheet'>")
 	} 
%>
<script type="text/javascript">

	$(document).ready(function() {
		
	$("#Prov_ID").val(<%=Prov_ID%>);
	$("#OC_ID").val(<%=OC_ID%>);
	$("#Pro_ID").val(<%=Pro_ID%>);		
		
<%	if(For_Archivo != ""){ %>
		$("#dvFor_Archivo").load('<%=For_Archivo + For_Parametros%>');

		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>" 
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()
		
		$("#BPMBotones").load("/pz/fnd/BPM/BPM_Botones.asp" + sDatos);
		$("#BPMEstatus").load("/pz/fnd/BPM/BPM_Estatus.asp" + sDatos);	
<%	}  		

  if(Pro_ModoEdicion == 1) { %>
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>"   
        $("#dvModoEdicion").load("/widgets/BPM/BPM_ModoEdicion.asp" + sDatos); 
<% } %>  
		
	});

</script>
<%	if(For_ArchivoJS != ""){  
		Response.Write("<script src='" + For_ArchivoJS + "'></script>")
 	}
%>
	
    
    
    
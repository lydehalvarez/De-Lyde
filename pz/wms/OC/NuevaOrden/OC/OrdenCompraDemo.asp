<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

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
	
	if(Prov_ID == 0) {
		var sSQL = "SELECT Prov_ID, OC_ID  "
			sSQL += " FROM OrdenCompra "
			sSQL += " WHERE OC_Serie = " + OC_Serie
//Response.Write("<br>" + sSQL)	
		var rsOC = AbreTabla(sSQL,1,0)
		if (!rsOC.EOF){
			Prov_ID = rsOC.Fields.Item("Prov_ID").Value		
			OC_ID = rsOC.Fields.Item("OC_ID").Value	
			if(	Prov_ID >0 ) {
				ParametroCambiaValor("Prov_ID",Prov_ID)
				ParametroCambiaValor("OC_ID",OC_ID)
			}
		}
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

	var sSQL = "SELECT OC_TipoOCCG47 "
	    sSQL += " FROM OrdenCompra "
		sSQL += " WHERE Prov_ID = " + Prov_ID
		sSQL += " AND OC_ID = " + OC_ID
 	//Response.Write(sSQL)	
	var rsOC = AbreTabla(sSQL,1,0)
    if (!rsOC.EOF){
		Pro_ID = rsOC.Fields.Item("OC_TipoOCCG47").Value							
	}
	//if(Pro_ID < 1) { Pro_ID = 1 }
	var sSQL = "SELECT * "
	    sSQL += " FROM BPM_Proceso p , Formato f "
		sSQL += " WHERE p.For_ID = f.For_ID "
		sSQL += " AND f.For_Habilitado = 1 "
		sSQL += " AND p.Pro_ID = " + Pro_ID 
 	//Response.Write("<br>" + sSQL)	
	//Response.End()
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
		//Response.Write(sSQL)		
	}
	
	if(For_Parametros != "") {
		For_Parametros = "?" + ProcesaBuscadorDeParametros(For_Parametros)
	}
	
	if(For_Archivo != ""){	
	   For_Archivo = For_Archivo.replace("/pz/mms/OC/", "/pz/mms/OC/Demo_");
%>
<div class="ibox">         
    <div class="ibox-content" id="dvFor_Archivo">
    </div>
</div>
      
<%  }
 	if(For_ArchivoCSS != ""){  
		Response.Write("<link href='" + For_ArchivoCSS + "' rel='stylesheet'>")
 	} 
%>
<script type="text/javascript">

	$(document).ready(function() {
		
	$("#Prov_ID").val(<%=Prov_ID%>);
	$("#OC_ID").val(<%=OC_ID%>);
		
		
<%	if(For_Archivo != ""){ %>
		
		$("#dvFor_Archivo").load('<%=For_Archivo + For_Parametros%>');
<%	} %>
		
	});

</script>
<%	if(For_ArchivoJS != ""){  
		Response.Write("<script src='" + For_ArchivoJS + "'></script>")
 	}
%>
	
    
    
    
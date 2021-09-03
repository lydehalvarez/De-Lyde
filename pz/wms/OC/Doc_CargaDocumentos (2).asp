<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var CoP = ParametroDeVentana(SistemaActual, VentanaIndex, "Clinete/Proveedor", "C")
var Doc_ID = ParametroDeVentana(SistemaActual, VentanaIndex, "Tipo Documento", 0)   
//  TipoDoc   7 = factura, 16 Prueba de recepcion de mercancia, 18 pago   
var Usu_ID = Parametro("IDUsuario",-1)   
  
   
var Cli_ID = Parametro("Cli_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var CliOC_Folio = Parametro("CliOC_Folio",0)
var Prov_ID = Parametro("Prov_ID",-1)
var OC_ID = Parametro("OC_ID",-1)

%>
<style type="text/css">
	.cArchivo {
		border-style: solid;
		border-width: 1px;
		padding: 5px;
	}

</style>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">

<div class="row">
<div class="col-md-2">
        
		<div class="ibox"  style="width:180px !important;">
			<div class="ibox-content" style="min-height: 482px;">
				<p class="font-bold">Documentos</p>
				<hr>                
   <a href="#" class="btn btn-primary" id="btnNuevo" style="margin-bottom:10px;">
                <i class="fa fa-plus-square-o">
                 &nbsp;</i>&nbsp;<strong>&nbsp;Nuevo</strong>&nbsp;</a>
				<hr> 
<div id="dvListaArchivos">                
<%
 var Llaves = ""
 var Docs_Titulo = "" 
 var Docs_Folio = ""
 var Docs_Nombre = ""
 var Docs_Nombre2 = ""
 var Primero = "-1" 
 var PCap = ""
 var PInt = ""
 var Cob_EsUnCFDI = 0 
   
if(CoP == "C"){	 
     var sSQL  = " SELECT * "
         sSQL += " FROM Cliente_OrdenCompra_Documento " 
         sSQL += " WHERE Cli_ID = " + Cli_ID
         sSQL += " AND CliOC_ID = " + CliOC_ID 
         if(Doc_ID==7 || Doc_ID==16 || Doc_ID==18){
            sSQL += " AND Doc_ID = " + Doc_ID 
         }   
} 
if(CoP == "P"){	
     var sSQL  = " SELECT * "
         sSQL += " FROM Proveedor_OrdenCompra_Documento " 
         sSQL += " WHERE Prov_ID = " + Prov_ID
         sSQL += " AND OC_ID = " + OC_ID 
         if(Doc_ID==7 || Doc_ID==16 || Doc_ID==18){
            sSQL += " AND Doc_ID = " + Doc_ID
         }   
} 

 var rsArchivos = AbreTabla(sSQL,1,0)
 while (!rsArchivos.EOF){
   Llaves = rsArchivos.Fields.Item("Doc_ID").Value  
   Llaves += "," + rsArchivos.Fields.Item("Docs_ID").Value  
   Docs_Folio = rsArchivos.Fields.Item("Docs_Folio").Value
   if (Primero == "-1") {
   		Primero = Llaves		   
   }
   Cob_EsUnCFDI = rsArchivos.Fields.Item("Docs_EsUnCFDI").Value
   Docs_Titulo = "" + rsArchivos.Fields.Item("Docs_Titulo").Value
   Docs_Nombre = rsArchivos.Fields.Item("Docs_Nombre").Value 

	   		Docs_Titulo = "" + Docs_Folio %>
                <div class="cArchivo" 
                      data-docid="<%=rsArchivos.Fields.Item("Doc_ID").Value%>"
                      data-doctipo="pdf"
                      data-docsid="<%=rsArchivos.Fields.Item("Docs_ID").Value%>">
					<a class="product-name" href="#"><%=Docs_Titulo%></a>
					<div class="m-t-xs">
						<%=rsArchivos.Fields.Item("Docs_Observaciones").Value%>
					</div>  
					<div class="m-t-xs">
						<%=rsArchivos.Fields.Item("Docs_Comentario").Value%>
					</div>                   
					<div class="small m-t text-righ">
                    	<ul style="list-style-type: none;list-style-type: none;padding: 5px;margin: 0px;">
                            <li>Fecha:<%=rsArchivos.Fields.Item("Docs_FechaRegistro").Value%></li>
                        </ul>
					</div>
				</div>
				       <hr>   			
<%	

	rsArchivos.MoveNext() 
   }
rsArchivos.Close()   
%>  
		</div>	</div>
		</div>

  </div>
	<div class="col-md-10">
		<div class="ibox">
			<div class="ibox-content">
				<div class="table-responsive" id="dvArchivo"  style="overflow-x:visible !Important;">
                </div>
			</div>
		</div>
	</div>
	
</div>

<input type="hidden" name="Doc_ID" id="Doc_ID" value="<%=Doc_ID%>">  
<!-- Jasny -->
<script src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>

<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".cArchivo").click(function(e) {
			CargaDocumento($(this).data("docid"),$(this).data("docsid"),$(this).data("doctipo"));
        });
		
		$("#btnNuevo").click(function(e) {
            e.preventDefault()
			CargaDocumento(<%=Doc_ID%>,-1);
        });
	
<%
   		Response.Write("CargaDocumento(" + Primero + ");")   
%>	
	});
	
	
function CargaDocumento(dc,dcs,tipo){
	
	var sData = "/pz/wms/OC/Doc_Archivo.asp?"
<% if(CoP == "C"){	 %>
	    sData += "Cli_ID=" + $("#Cli_ID").val()
		sData += "&CliOC_ID=" + $("#CliOC_ID").val()	
<% } else { %>
	    sData += "Prov_ID=" + $("#Prov_ID").val()
		sData += "&OC_ID=" + $("#OC_ID").val()	
<% } %>                  
		sData += "&Doc_ID=" + dc
		sData += "&Docs_ID=" + dcs
		sData += "&tp=" + tipo
        sData += "&VI=" + $("#VentanaIndex").val()	

	$("#dvArchivo").load(sData)
	
}
 
function CargaResumenDeArchivos(){
	
	var sData = "/pz/wms/OC/Doc_Resumen.asp?"
<% if(CoP == "C"){	 %>
	    sData += "Cli_ID=" + $("#Cli_ID").val()
		sData += "&CliOC_ID=" + $("#CliOC_ID").val()	
<% } else { %>
	    sData += "Prov_ID=" + $("#Prov_ID").val()
		sData += "&OC_ID=" + $("#OC_ID").val()	
<% } %>   
		sData += "&Doc_ID=" + $("#Doc_ID").val()	
        sData += "&VI=" + $("#VentanaIndex").val()
		
	$("#dvListaArchivos").load(sData)
	
	$("#dvArchivo").empty()
		
}

//-->
</script>
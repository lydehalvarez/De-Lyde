<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var Emp_ID = Parametro("Emp_ID",-1)
var EVtc_ID = Parametro("EVtc_ID",-1)
var EVtcD_ID = Parametro("EVtcD_ID",-1)
var Usu_ID = Parametro("IDUsuario",-1)
var Doc_ID = ParametroDeVentana(SistemaActual, VentanaIndex, "Tipo Documento", 1)
//  TipoDoc   7 = factura, 16 Prueba de recepcion de mercancia, 18 pago
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
				<p class="font-bold">Facturas cargadas</p>
				<hr>                
   <a href="#" class="btn btn-primary" id="btnNuevo" style="margin-bottom:10px;">
                <i class="fa fa-plus-square-o">
                 &nbsp;</i>&nbsp;<strong>&nbsp;Nuevo</strong>&nbsp;</a>
				<hr> 
<div id="dvListaArchivos">                
<%
 var Llaves = ""
 var Primero = "-1" 
 var PCap = ""
 var PInt = ""
 var Cob_EsUnCFDI = 0  

 var sSQL  = " SELECT * "
	 sSQL += " FROM Empleado_Viaticos_Documentos " 
	 sSQL += " WHERE Emp_ID = " + Emp_ID
	 sSQL += " AND EVtc_ID = " + EVtc_ID	
	 sSQL += " AND EVtcD_ID = " + EVtcD_ID		  
	 if(Doc_ID==7 || Doc_ID==16 || Doc_ID==18){
	 	sSQL += " AND Doc_ID = " + Doc_ID
	 } else {
		sSQL += " AND Doc_ID = -1 " 
	 }
  
 var rsArchivos = AbreTabla(sSQL,1,0)
 while (!rsArchivos.EOF){
   Llaves = rsArchivos.Fields.Item("Doc_ID").Value  
   Llaves += "," + rsArchivos.Fields.Item("Docs_ID").Value  
   
   if (Primero == "-1") {
   		Primero = Llaves		   
   }
   Cob_EsUnCFDI = rsArchivos.Fields.Item("Docs_EsUnCFDI").Value
 
%>
                 <div class="cArchivo" 
                      data-docid="<%=rsArchivos.Fields.Item("Doc_ID").Value%>"
                      data-docsid="<%=rsArchivos.Fields.Item("Docs_ID").Value%>">
					<a class="product-name" href="#"><%=rsArchivos.Fields.Item("Docs_Titulo").Value%></a>
					<div class="m-t-xs">
						<%=rsArchivos.Fields.Item("Docs_Observaciones").Value%>
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
			CargaDocumento($(this).data("docid"),$(this).data("docsid"));
        });
		
		$("#btnNuevo").click(function(e) {
            e.preventDefault()
			CargaDocumento(<%=Doc_ID%>,-1);
        });
	
<%
   		Response.Write("CargaDocumento(" + Primero + ");")   
%>	
	});
	
	
function CargaDocumento(dc,dcs){
	
	var sData = "/pz/agt/Usuarios/Viaticos_Archivo.asp"
	    sData += "?Emp_ID=" + $("#Emp_ID").val()
		sData += "&EVtc_ID=" + $("#EVtc_ID").val()	
		sData += "&EVtcD_ID=" + $("#EVtcD_ID").val()				
		sData += "&Doc_ID=" + dc
		sData += "&Docs_ID=" + dcs

	$("#dvArchivo").load(sData)
	
}
 
function CargaResumenDeArchivos(dc,dcs){
	
	var sData = "/pz/agt/Usuarios/Viaticos_Resumen.asp"
	    sData += "?Emp_ID=" + $("#Emp_ID").val()
		sData += "&EVtc_ID=" + $("#EVtc_ID").val()	
		sData += "&EVtcD_ID=" + $("#EVtcD_ID").val()				
		sData += "&Doc_ID=" + dc
		sData += "&Docs_ID=" + dcs		
		
	$("#dvListaArchivos").load(sData)
	
	$("#dvArchivo").empty()
		
}

//-->
</script>
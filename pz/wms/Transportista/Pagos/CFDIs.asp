<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
    var Prov_ID = Parametro("Prov_ID",-1)
    var Pag_ID = Parametro("Pag_ID",-1)
    var CFDI_ID = Parametro("CFDI_ID",-1)   

   
   
   
%>   
<style type="text/css">

.cArchivo {
    border-style: solid;
    border-width: 1px;
    padding: 5px;
}

.archivo-name{
    font-size: 10px;
}

</style>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">

<div class="row">
<div class="col-md-3">
		<div class="ibox">
			<div class="ibox-content" style="min-height: 482px;">
				<p class="font-bold">CFDI Cargados</p>
				<hr><p class="font-bold">
                <a href="javascript:EnviaDeNuevo();" class="btn btn-danger" id="btnEnviar" style="margin-bottom: 20px;">
                <i class="fa fa-envelope-open-o">
                 &nbsp;</i>&nbsp;<strong>&nbsp;Enviar por correo</strong>&nbsp;&nbsp;&nbsp;&nbsp;</a></p>
				<hr>
<div id="dvListaArchivos">                
<%
 var Llaves = ""
 var NumArch = 4
 var Fecha = ""
 var Primero = ""
 var CFDI_Cancelado = 0
 var arArchivo = new Array(0)
 var arObs = new Array(0)
 var arTipo = new Array(0) 
 var sSQL  = " SELECT *, ISNULL(CFDI_NombreArchivoPDFCancelado,'') as NombreArchivoPDFCancelado " 
	 sSQL += " FROM Proveedor_Pago_CFDI " 
	 sSQL += " WHERE Prov_ID = " + Prov_ID
	 sSQL += " AND Pag_ID = " + Pag_ID
	 sSQL += " AND CFDI_ID = " + CFDI_ID	

 var rsArchivos = AbreTabla(sSQL,1,0)
 if (!rsArchivos.EOF){
	CFDI_Cancelado = rsArchivos.Fields.Item("CFDI_Cancelado").Value 
	arArchivo[0] = "" + rsArchivos.Fields.Item("CFDI_NombreArchivoPDF").Value
	arObs[0] = "Archivo PDF"
	arTipo[0] = "PDF"	
	Primero = arArchivo[0]
	arArchivo[1] = "" + rsArchivos.Fields.Item("CFDI_NombreArchivoXML").Value
	arObs[1] = "Archivo XML"
	arTipo[1] = "XML"		
	arArchivo[2] = "" + rsArchivos.Fields.Item("NombreArchivoPDFCancelado").Value
	arObs[2] = "Archivo PDF de la cancelaci&oacute;n"
	arTipo[2] = "PDF"		
	arArchivo[3] = "" + rsArchivos.Fields.Item("CFDI_NombreArchivoXMLCancelado").Value
	arTipo[3] = "XML"
			
	if (arArchivo[2] == "") {
		NumArch = 2
	}
	Fecha = "" + rsArchivos.Fields.Item("CFDI_FechaFactura").Value
 }
 rsArchivos.Close() 
 
 
 index = 0
 while (index < NumArch ) {
%>
                 <div class="cArchivo" data-cobnme="<%=arArchivo[index]%>">
					<a class="archivo-name" href="#"><%=arArchivo[index]%></a>
					<div class="m-t-xs">
						<%=arObs[index]%>
					</div>                      
					<div class="small m-t text-righ">
                    	<ul style="list-style-type: none;list-style-type: none;padding: 5px;margin: 0px;">
                        	<li>Tipo:<%=arTipo[index]%></li>
                            <li>Fecha:<%=Fecha%></li>
                          <% if(CFDI_Cancelado == 1) {  %>
                             <li>Estatus: Cancelado</li>
                          <% }  %>
                        </ul>
					</div>
                  
				</div>
				<hr>                   
<%
   index = index + 1
 } 
%> 
		</div>	</div>
		</div>

  </div>
	<div class="col-md-9">
		<div class="ibox">
			<div class="ibox-content">
				<div class="table-responsive" id="dvArchivo" style="overflow-x:visible !Important;">
                </div>
			</div>
		</div>
	</div>
	
</div>

<input name="Pag_ID" id="Pag_ID" type="hidden" value="<%=Pag_ID%>" />
<input name="CFDI_ID" id="CFDI_ID" type="hidden" value="<%=CFDI_ID%>" />
<!-- Jasny -->
<script src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>

<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".cArchivo").click(function(e) {
			CargaDocumento($(this).data("cobnme"));
        });
			
		
<%
   		Response.Write("CargaDocumento('" + Primero + "');")   
%>	
	});
	
	
function CargaDocumento(archivo){
	
	var sData = "/pz/wms/Transportista/Pagos/CFDI_MuestraArchivo.asp"
	    sData += "?Prov_ID=" + $("#Prov_ID").val()
		sData += "&Pag_ID=" + $("#Pag_ID").val()
		sData += "&CFDI_ID=" + $("#CFDI_ID").val()
        sData += "&fl=" + archivo
		sData += "&cld=<%=CFDI_Cancelado%>"

	
	$("#dvArchivo").load(sData)
	
}

 

//-->
</script>

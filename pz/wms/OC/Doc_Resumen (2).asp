<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var Cli_ID = Parametro("Cli_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
 
var Usu_ID = Parametro("IDUsuario",-1)
var VI = Parametro("VentanaIndex",-1)
var Doc_ID = Parametro("Doc_ID",-1)
//  Doc_ID   7 = factura, 16 Prueba de recepcion de mercancia, 18 pago

 var Llaves = ""
 var Docs_Titulo = "" 
 var sSQL  = " SELECT * "
	 sSQL += " FROM Cliente_OrdenCompra_Documento " 
	 sSQL += " WHERE Cli_ID = " + Cli_ID
	 sSQL += " AND CliOC_ID = " + CliOC_ID 
	 if(Doc_ID==7 || Doc_ID==16 || Doc_ID==18){
	 	sSQL += " AND Doc_ID = " + Doc_ID
	 }  
	 sSQL += " Order by Docs_ID desc " 
	  
 var rsArchivos = AbreTabla(sSQL,1,0)
 while (!rsArchivos.EOF){
   Llaves = rsArchivos.Fields.Item("Doc_ID").Value  
   Llaves += "," + rsArchivos.Fields.Item("Docs_ID").Value 
   Docs_Titulo = "" + rsArchivos.Fields.Item("Docs_Titulo").Value
   if(EsVacio(rsArchivos.Fields.Item("Docs_Titulo").Value) ){
	   Docs_Titulo = "Archivo"
   } 
%>
                 <div class="cArchivo" 
                      data-docid="<%=rsArchivos.Fields.Item("Doc_ID").Value%>"
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
                        	<li>Usuario coloco:<%=rsArchivos.Fields.Item("Docs_UsuarioCargo").Value%></li>
                            <li>Fecha carga:<%=rsArchivos.Fields.Item("Docs_FechaRegistro").Value%></li>
                            <li>Validado:<%=rsArchivos.Fields.Item("Docs_Validado").Value%></li>
                        	<li>Usuario valido:<%=rsArchivos.Fields.Item("Docs_UsuarioCargo").Value%></li>
                            <li>Fecha validacion:<%=rsArchivos.Fields.Item("Docs_UsuarioValido").Value%></li>                            
                        </ul>
					</div>
                  
				</div>
				<hr>                   
<%
	rsArchivos.MoveNext() 
	}
rsArchivos.Close()   
%> 

<script type="text/javascript">

	$(document).ready(function() {
		
		$(".cArchivo").click(function(e) {
			e.preventDefault()
			var dc = $(this).data("docid")
			var dcs = $(this).data("docsid")		
			
			CargaDocumento(dc,dcs)
		});
		
		$("#Prov_ID").val(<%=Prov_ID%>);
		$("#OC_ID").val(<%=OC_ID%>);	
	
	});

</script>
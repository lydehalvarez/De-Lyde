<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var Emp_ID = Parametro("Emp_ID",-1)
var EVtc_ID = Parametro("EVtc_ID",-1)
var EVtcD_ID = Parametro("EVtcD_ID",-1)
var Usu_ID = Parametro("IDUsuario",-1)
var Docs_ID = Parametro("Docs_ID",-1)
var Usu_ID = Parametro("IDUsuario",-1)
var VI = Parametro("VentanaIndex",-1)
var Doc_ID = Parametro("Doc_ID",7)
//  Doc_ID   7 = factura, 16 Prueba de recepcion de mercancia, 18 pago

var sRuta = ""
var Docs_Nombre = ""
var Cargado = 0
var sObs = ""
var sTitulo = ""
var Cob_EsUnCFDI = 0
var Docs_FechaRegistro = ""
var Llaves = ""
 
  var sSQL  = " SELECT * "
	 sSQL += " FROM Empleado_Viaticos_Documentos " 
	 sSQL += " WHERE Emp_ID = " + Emp_ID
	 sSQL += " AND EVtc_ID = " + EVtc_ID
	 sSQL += " AND EVtcD_ID = " + EVtcD_ID	 
	 sSQL += " AND Doc_ID = " + Doc_ID	
//	 sSQL += " AND Docs_ID = " + Docs_ID		  
  
 var rsArchivos = AbreTabla(sSQL,1,0)
 while (!rsArchivos.EOF){
   Llaves = rsArchivos.Fields.Item("Doc_ID").Value  
   Llaves += "," + rsArchivos.Fields.Item("Docs_ID").Value    
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
					
			$("#Doc_ID").val(dc);
			$("#Docs_ID").val(dcs);			
			
			CargaDocumento(dc,dcs)
		});
		
<% if(Docs_ID >-1){
	Response.Write("CargaDocumento(" + Doc_ID + "," + Docs_ID + ")")
}
%>
	
	});

</script>
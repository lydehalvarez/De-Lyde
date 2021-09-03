<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   var bDebIQ4Web = false
   var iOC_ID = Parametro("OC_ID",-1)
   var iProv_ID = Parametro("Prov_ID",-1)
   
   var sSQLPrinc = "SELECT OC_ID,OCCot_ID,Doc_ID,Docs_ID,Prov_ID,Docs_Nombre,Docs_RutaArchivo "
       sSQLPrinc += " FROM OrdenCompra_CotizacionDocumento "
       sSQLPrinc += " WHERE OC_ID = " + iOC_ID
       sSQLPrinc += " AND Prov_ID = " + iProv_ID
       
   
       if(bDebIQ4Web){ Response.Write("Sentencia de OrdenCompra_CotizacionDocumento <br>"+ sSQLPrinc + "<br>") } 
   
       
   
 	bHayParametros = false
	ParametroCargaDeSQL(sSQLPrinc,0)   
   
   var extension = ""
   var sArchivo = Parametro("Docs_Nombre","")
       if(bDebIQ4Web){ Response.Write("antes - archivo " + sArchivo + "<br>") }
       extension = (sArchivo.substring(sArchivo.lastIndexOf(".")+1)).toLowerCase()
       if(bDebIQ4Web){ Response.Write("despues - extension " + extension + "<br>") }
   var sRuta = Parametro("Docs_RutaArchivo","")
   
   
%>   
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
	<h3 class="modal-title text-center">Cotizaci&oacute;n</h3><small class="font-bold"></small>
</div>
<div class="modal-body">
    <div class="row">    
        <div class="col-sm-12" style="text-align:center">	
            <div align="center" id="ReadBaseDatos">
            <% if (extension == "pdf"){
               %>   
               <iframe id="PreviewPDF" frameborder="0" scrolling="no" height="800" width="750" src="<%=sRuta%><%=sArchivo%>"></iframe> 
               <% } else { %>
                <img id="Preview" alt="vista previa" height="800" width="750" src="<%=sRuta%><%=sArchivo%>"/>   
               <% } %>
            </div>
        </div>    
    </div>
</div>
<div class="modal-footer">
	<button type="button" data-dismiss="modal" class="btn btn-info btn-sm btnCerrar">Cerrar</button> 
</div>            



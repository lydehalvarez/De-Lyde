<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)	
 
%>

    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
            <tr>

                <th>#</th>
                <th>UUID </th>
                <th>Tipo</th>
                <th>Folio </th>
                <th>Fecha </th>
                <th>Monto </th>
                <th>Acci&oacute;n</th>
            </tr>
            </thead>
            <tbody>
<%
 var Llaves = ""
 var iRenglon = 0  
 var Suma = 0
 var Folio = ""
 var TieneXML = false
 var TienePDF = false
 
 var sSQL  = " SELECT CFDI_PAC_UUID, CFDI_TipoDeComprobante, CFDI_Fecha, CFDI_Total "
	 sSQL += " ,d.OC_ID, d.Doc_ID, d.Docs_ID, CFDI_FolioInterno "
	 sSQL += " ,ISNULL(Docs_Nombre,'') as archXML, ISNULL(Docs_Nombre2,'') as archPDF "
	 sSQL += " FROM OrdenCompra_Documento d, CFDI c " 
	 sSQL += " WHERE d.OC_ID = " + OC_ID
	 sSQL += " AND d.OC_ID = c.OC_ID "
	 sSQL += " AND d.Doc_ID = c.Doc_ID "
	 sSQL += " AND d.Docs_ID = c.Docs_ID "
//Response.Write(sSQL)
	 var rsFactura = AbreTabla(sSQL,1,0)

 while (!rsFactura.EOF){
   iRenglon++
   Suma += rsFactura.Fields.Item("CFDI_Total").Value
   
   TieneXML = false
   if(rsFactura.Fields.Item("archXML").Value != "") {
   		TieneXML = true
   }
   TienePDF = false  
   if(rsFactura.Fields.Item("archPDF").Value != "") {
   		TienePDF = true
   }
   
   Llaves = OC_ID
   Llaves += "," + rsFactura.Fields.Item("Doc_ID").Value
   Llaves += "," + rsFactura.Fields.Item("Docs_ID").Value
   Folio = FiltraVacios(rsFactura.Fields.Item("CFDI_FolioInterno").Value)
%>                   
            <tr>
                <td><%=iRenglon%></td>
                <td><small><%=rsFactura.Fields.Item("CFDI_PAC_UUID").Value%></small></td>
                <td><%=rsFactura.Fields.Item("CFDI_TipoDeComprobante").Value%></td>
                <td><%=Folio%></td>
                <td><%=rsFactura.Fields.Item("CFDI_Fecha").Value%></td>
                <td><%=formato(rsFactura.Fields.Item("CFDI_Total").Value,2)%></td>
                <td><%
if(!TieneXML) {%>
   		    <button class="btn btn-primary" id="btnxml">
				<i class="fa fa-file-code-o"></i> XML</button>
<% }
if(!TienePDF) {%>
   		    <button class="btn btn-primary" id="btnxml">
				<i class="fa fa-file-pdf-o"></i> PDF</button>
<%   }  %></td>
            </tr>
<%
	rsFactura.MoveNext() 
	}
rsFactura.Close()   
%> 
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>total</td>
              <td><%=formato(Suma,2)%></td>
              <td>&nbsp;</td>
            </tr>
            </tbody>
        </table>
    </div>
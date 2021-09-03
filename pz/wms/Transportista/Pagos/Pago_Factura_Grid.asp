<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%	
	
	var bIQon4Web = true
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var Pag_ID = Parametro("Pag_ID",-1)	
 
%>

    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>#</th>
				<th>Folio </th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
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
				 sSQL += " ,CFDI_ID, CFDI_FolioInterno, CFDI_Emisor_rfc "
				 sSQL += " ,ISNULL(CFDI_NombreArchivoXML,'') as archXML "
				 sSQL += " ,ISNULL(CFDI_NombreArchivoPDF,'') as archPDF "
				 sSQL += " ,(SELECT Prov_Nombre FROM Proveedor p where p.Prov_ID = CFDI.Prov_ID) as Proveedor "
				 sSQL += " FROM Proveedor_Pago_CFDI CFDI " 
				 sSQL += " WHERE CFDI.Prov_ID = " + Prov_ID
			     sSQL += " AND CFDI.Pag_ID = " + Pag_ID
			   
				//sSQL += " AND d.OC_ID = c.OC_ID "
				// sSQL += " AND d.Doc_ID = c.Doc_ID "
				// sSQL += " AND d.Docs_ID = c.Docs_ID "
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
			   Llaves += "," + rsFactura.Fields.Item("CFDI_ID").Value
			   //Llaves += "," + rsFactura.Fields.Item("Docs_ID").Value
			   Folio = FiltraVacios(rsFactura.Fields.Item("CFDI_FolioInterno").Value)
			%>                   
            <tr>
                <td><%=iRenglon%></td>
				<td><%=Folio%></td>	
                <td colspan="3">
					<div class="gfac">
						<div class="gfacR"><%=rsFactura.Fields.Item("CFDI_Emisor_rfc").Value %> - 
							<%=rsFactura.Fields.Item("Proveedor").Value %>
						</div>	 
						<div class="gfacF"><small><%=rsFactura.Fields.Item("CFDI_PAC_UUID").Value %></small> - 
							<%=rsFactura.Fields.Item("CFDI_Fecha").Value %>
						</div>
						<div class="gfacR" style="text-align: right;">	
							<small><a href="javascript:CargaPopUp(1,<%=Llaves%>)"><i class="fa fa-file-pdf-o"> </i>&nbsp;<strong>Archivo PDF</strong></a>
								    &nbsp;&nbsp;
								   <a href="javascript:CargaPopUp(2,<%=Llaves%>)"><i class="fa fa-file-code-o"> </i>&nbsp;<strong>Archivo XML</strong></a>
							</small>
					    </div>
					 
					</td>
                <td><%Response.Write(formato(rsFactura.Fields.Item("CFDI_Total").Value,2))%></td>
                <td>
			<%
			if(!TieneXML) {%>
						<button class="btn btn-primary btn-xs" id="btnxml">
							<i class="fa fa-file-code-o"></i> XML</button>
			<% }
			if(!TienePDF) {%>
						<button class="btn btn-primary btn-xs" id="btnxml">
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
              <td>Total</td>
              <td><%=formato(Suma,2)%></td>
              <td>&nbsp;</td>
            </tr>
            </tbody>
        </table>
    </div>

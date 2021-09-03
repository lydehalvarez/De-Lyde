<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)
	var Pro_ID = Parametro("Pro_ID",0)	
	
	var Parametros = OC_ID + "," + Prov_ID + "," + Pro_ID
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
                <th>Estatus</th>
                <th>Acci&oacute;n</th>
            </tr>
            </thead>
            <tbody>
<%
 var Llaves = ""
 var iRenglon = 0  
 var Suma = 0
 var Folio = ""
 
 var sSQL  = " SELECT Prov_Fac_TipoComprobante, Prov_Fac_Serie, Prov_Fac_Folio, Prov_Fac_FolioFiscal, Prov_Fac_FechaFactura "
     sSQL += " , Prov_Fac_Moneda, Prov_Fac_GranTotal, Prov_Fac_NombreArchivoXML, Prov_Fac_NombreArchivoPDF, Prov_Fac_ID "
     sSQL += " , Prov_Fac_MetodoPago, CONVERT(NVARCHAR(20), Prov_Fac_FechaFactura,103) as Fecha "
	 sSQL += " FROM Proveedor_Recepcion_Factura " 
	 sSQL += " WHERE Prov_ID = " + Prov_ID
	 sSQL += " AND OC_ID = " + OC_ID
	 sSQL += " AND Prov_Fac_EstaLibre = 0 "  	 
	 sSQL += " ORDER BY Prov_Fac_FechaFactura "

	 var rsFactura = AbreTabla(sSQL,1,0)

 while (!rsFactura.EOF){
   iRenglon++
   Suma += rsFactura.Fields.Item("Prov_Fac_GranTotal").Value
   Llaves = Prov_ID
   Llaves += "," + OC_ID
   Llaves += "," + rsFactura.Fields.Item("Prov_Fac_ID").Value
   Folio = FiltraVacios(rsFactura.Fields.Item("Prov_Fac_Serie").Value) +"-"+ FiltraVacios(rsFactura.Fields.Item("Prov_Fac_Folio").Value)
%>                   
            <tr>
                <td><%=iRenglon%></td>
                <td><small><%=rsFactura.Fields.Item("Prov_Fac_FolioFiscal").Value%></small></td>
                <td><%=rsFactura.Fields.Item("Prov_Fac_TipoComprobante").Value%></td>
                <td><%=Folio%></td>
                <td><%=rsFactura.Fields.Item("Fecha").Value%></td>
                <td><%=formato(rsFactura.Fields.Item("Prov_Fac_GranTotal").Value,2)%></td>
                <td><a href="#"><i class="fa fa-check text-navy"></i>&nbsp;</a></td>
                <td>&nbsp;</td>
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
              <td>&nbsp;</td>
            </tr>
            </tbody>
        </table>
    </div>
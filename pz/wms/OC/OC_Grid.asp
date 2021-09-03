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
                <th>Cantidad </th>
                <th>SKU</th>
                <th>Descripcion</th>
                <th>Precio unitario </th>
                <th>Acci&oacute;n</th>
            </tr>
            </thead>
            <tbody>
<%

 var Llaves = ""
 var iRenglon = 0  
 var Suma = 0
 var Folio = ""
 
 var sSQL  = " SELECT OCD_ID, OCD_SKU, OCD_Descripcion, OCD_Cantidad, OCD_PrecioUnitario "
     sSQL += " , OCD_TotalImpPartida  "
	 sSQL += " FROM OrdenCompra_Detalle " 
	 sSQL += " WHERE OC_ID = " + OC_ID

	 var rsArticulos = AbreTabla(sSQL,1,0)

 while (!rsArticulos.EOF){
   iRenglon++
   Suma += rsArticulos.Fields.Item("OCD_TotalImpPartida").Value
   Llaves = OC_ID
   Llaves += "," + rsArticulos.Fields.Item("OCD_ID").Value

%>                   
            <tr>
                <td><%=iRenglon%></td>
                <td><%=rsArticulos.Fields.Item("OCD_Cantidad").Value%></td>
                <td><%=rsArticulos.Fields.Item("OCD_SKU").Value%></td>
                <td><%=rsArticulos.Fields.Item("OCD_Descripcion").Value%></td>
                <td><%=rsArticulos.Fields.Item("OCD_PrecioUnitario").Value%></td>
                <td><%=formato(rsArticulos.Fields.Item("OCD_TotalImpPartida").Value,2)%></td>
                <td><a href="#"><i class="fa fa-check text-navy"></i>&nbsp;</a> ver </td>
                <td>&nbsp;</td>
            </tr>
<%
	rsArticulos.MoveNext() 
	}
rsArticulos.Close()   

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
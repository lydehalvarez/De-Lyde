<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%
   	var Inv_ID = Parametro("Inv_ID",-1)
   	var Cli_ID = Parametro("Cli_ID",-1)
   
	var sSQLASN  = "SELECT Inv_ID,ASN_FolioCliente " 
			   + " ,ISNULL((SELECT CliPrv_Nombre FROM Cliente_Proveedor WHERE Cli_ID = c.Cli_ID AND CliPrv_ID = c.CProv_ID),'N/A') Proveedor "
			   + " FROM Inventario a, Producto b, ASN c " 
               + " WHERE a.Pro_ID = b.Pro_ID " 
               + " AND Inv_ID = "+ Inv_ID 
			   + " AND Inv_LoteIngreso = c.Lot_ID " 
   

	var rsSerie = AbreTabla(sSQLASN, 1,0)
   	
	//Response.Write(sSQLASN)
	if(!rsSerie.EOF){
%>

<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-title"><h5>Informaci&oacute;n ASN</h5></div>
            <div class="ibox-content">
                <table class="table">
                    <tbody>
                        <tr>
                            <td><strong>ASN</strong></td>
                            <td class="texCopy"><%=rsSerie.Fields.Item("ASN_FolioCliente").Value%></td>
                        </tr>
                        <tr>
                            <td><strong>Proveedor</strong></td>
                            <td class="texCopy"><%=rsSerie.Fields.Item("Proveedor").Value%></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<%
  }
%>

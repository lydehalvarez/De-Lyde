<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	
   	var sSQL = "SELECT CONVERT(VARCHAR(20), GETDATE(), 103) AS  Fecha ,CONVERT(VARCHAR(5), GETDATE(), 108) AS  Hora "

	var rsFecha = AbreTabla(sSQL,1,0)
     if(!rsFecha.EOF){
    	var fechaEla = rsFecha.Fields.Item("Fecha").Value + " - " + rsFecha.Fields.Item("Hora").Value
	 }
   
%>
<style>
.Encabezado{
	text-align:right;	
	font-size:20px;
}

</style>
<div class="form-horizontal" id="frmDatos">
        <div class="ibox-content">
            <table width="100%">
              <tbody>
                <tr>
                  <td width="135" rowspan="5"><img src="/Img/wms/Logo005.png" width="132" height="150" alt=""/></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="5" class="Encabezado">Log&iacute;stica y Distribuci&oacute;n Empresarial, S.A. de C.V. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" class="Encabezado">Orden de compra</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" class="Encabezado">Fecha:&nbsp;&nbsp;<%=fechaEla%></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td class="Encabezado">Folio: OC-0000005</td>
                </tr>
              </tbody>
            </table>
            <table width="100%">
              <tbody>
                <tr>
                  <td>Tem&iacute;stocles 23, int PH</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Colonia Polanco V Secci&oacute;n</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Miguel Hidalgo, Ciudad de M&eacute;xico</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>M&eacute;xico, 11560</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Para:</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </tbody>
            </table>
            <table>
                <tr>
                  <td>Nombre: </td>
                  <td>{Proveedor}</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>Compa&ntilde;ia: </td>
                  <td>{Proveedor}</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
            </table>
            <table width="100%" class="table">
            	<thead>
                	<th>Partida</th>
                	<th>SKU</th>
                	<th>Unidad de medida</th>
                	<th>DESCRIPCION</th>
                	<th>Cantidad</th>
                	<th>Precio unitario</th>
                	<th>Precio total</th>
                </thead>
                <tbody>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                </tbody>
            </table>
            
    </div>
</div>
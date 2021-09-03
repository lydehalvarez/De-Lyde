<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
 	var Pt_ID = Parametro("Pt_ID",-1)
	
	var sSQLRecep = "SELECT a.Pt_LPN,Cli_Nombre,a.Pt_SKU,PT_Cantidad_Actual "
		sSQLRecep += " ,CONVERT(NVARCHAR(10),Pt_FechaRegistro,103)+' - '+CONVERT(NVARCHAR(10),Pt_FechaRegistro,108)+' hrs' Fecha"
		sSQLRecep += " ,IR_Folio,Pro_Nombre, e.Ubi_Nombre "
		sSQLRecep += " , a.Lot_ID "
		sSQLRecep += " FROM Pallet a, Cliente b,Producto c, Inventario_Recepcion d, Ubicacion e "
		sSQLRecep += " WHERE a.Pt_ID = " +Pt_ID
		sSQLRecep += " AND a.Cli_ID = b.Cli_ID " 
		sSQLRecep += " AND a.Pro_ID = c.Pro_ID " 
		sSQLRecep += " AND a.IR_ID = d.IR_ID " 
		sSQLRecep += " AND a.Ubi_ID = e.Ubi_ID " 
		
	
	
	var Pro_Nombre = ""
	var Cli_Nombre = ""
	var Pt_LPN = ""
	var PT_Cantidad_Actual = ""
	var Pt_SKU = ""
	var Pt_FechaRegistro = ""
	var IR_Folio = ""
	var Ubi_Nombre = ""
	var Lot_ID = ""
    var rsPt = AbreTabla(sSQLRecep,1,0)
    if (!rsPt.EOF){
		Lot_ID = rsPt.Fields.Item("Lot_ID").Value
		Ubi_Nombre = rsPt.Fields.Item("Ubi_Nombre").Value 
        Pt_SKU = rsPt.Fields.Item("Pt_SKU").Value 
		IR_Folio = rsPt.Fields.Item("IR_Folio").Value
        Pt_LPN = rsPt.Fields.Item("Pt_LPN").Value 
		Cli_Nombre = rsPt.Fields.Item("Cli_Nombre").Value
		Pro_Nombre = rsPt.Fields.Item("Pro_Nombre").Value
        PT_Cantidad_Actual = rsPt.Fields.Item("PT_Cantidad_Actual").Value 
        Pt_FechaRegistro =  rsPt.Fields.Item("Fecha").Value
	}
	
%>
<style media="print">
    @page {
        size: auto;   /* auto is the initial value */
    }
</style>
<link href="/Template/inspina/css/style.css" rel="stylesheet">
<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">

<title>&nbsp;</title>
<center>
<table border="1" cellpadding="1" cellspacing="1" style="text-align:center;" width="900px">
    <tbody>
        <tr>
            <td rowspan="2" width="143"><img src="/Img/wms/Logo005.png" style="width:100;height:100" title="Lyde"></td>
            <td bgcolor="silver" colspan="3"><strong>Cliente</strong></td>
            <td bgcolor="silver" width="90"><strong>Fecha</strong></td>
        </tr>
        <tr>
            <td colspan="3" height="49">
                <h1><strong><%=Cli_Nombre%></strong></h1>
            </td>
            <td>
                <h3><strong><%=Pt_FechaRegistro%></strong></h3>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="3" width="150"><strong>SKU</strong></td>
            <td bgcolor="silver" colspan="2"><strong>Cita</strong></td>
        </tr>
        <tr>
            <td colspan="3" height="49"><font size="10"><strong><%=Pt_SKU%></strong></font></td>
            <td colspan="2"><h2><strong><%=IR_Folio%></strong></h2>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="5" align="center"><strong>Producto</strong></td>
        </tr>
        <tr>
            <td colspan="5" align="center"><h2><strong><%=Pro_Nombre%></strong></h2></td>
        </tr>
        <tr>
            <td bgcolor="silver"><strong>Cantidad</strong></td>
            <td bgcolor="silver" colspan="4"><strong>LPN</strong></td>
        </tr>
        <tr>
            <td height="40"><font size="10"><strong><%=PT_Cantidad_Actual%></strong></font></td>
            <td colspan="4">
                <svg id="barcode"></svg>
                <h1><strong><%=Pt_LPN%></strong></h1>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="5"><strong>Ubicacion</strong></td>
        </tr>
        <tr>
            <td colspan="5" height="30">
                <svg id="cbUbicacion"></svg>
                <h2><strong><%=Ubi_Nombre%></strong></h2>
            </td>
        </tr>
        <tr>
            <td bgcolor="silver" colspan="2"><strong>Lote de ingreso</strong></td>
            <td bgcolor="silver" colspan="3"><strong>Ingresado por:</strong></td>
        </tr>
        <tr>
            <td colspan="2" height="33"><font size="4"><strong><%=Lot_ID%></strong></font></td>
            <td colspan="3"><%
            var Usuario = "SELECT (SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](Pt_Usuario)) as Nombre "+
				   " FROM Pallet "+
				   " WHERE Pt_ID = "+Pt_ID

            var rsUsu = AbreTabla(Usuario,1,0)

            while(!rsUsu.EOF){
             %><font size="4"><strong>- <%=rsUsu.Fields.Item("Nombre").Value%></strong></font> &nbsp; <%
			  rsUsu.MoveNext() 
            }
            rsUsu.Close()   
            %></td>
        </tr>
    </tbody>
</table>
</center>
    
</body>
<footer>&nbsp;</footer>

    
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	
	$(document).ready(function(e) {
		window.print();
	setTimeout(function(){ 
				 window.close();
	  }, 800)
	});	

	JsBarcode("#barcode", "<%=Pt_LPN%>", {
	  width: 3,
	  align:"center",
	  height: 100,
	  displayValue: false,
	});
	
	JsBarcode("#cbUbicacion", "<%=Ubi_Nombre%>", {
	  width: 3,
	  align:"center",
	  height: 100,
	  displayValue: false,
	});
	

</script>



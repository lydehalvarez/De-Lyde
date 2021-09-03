 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var Mov_ID = Parametro("Mov_ID",-1)
	var MovP_ID = Parametro("MovP_ID",-1)
	var MovM_ID = Parametro("MovM_ID",-1)
	
	var sSQLO = "  SELECT "
		sSQLO += "(SELECT MovP_LPN FROM Movimiento_Pallet WHERE Mov_ID = a.Mov_ID AND MovP_ID = a.MovP_ID) Pallet "
		sSQLO += " ,(SELECT MovM_FolioCaja FROM Movimiento_Pallet_Master WHERE Mov_ID = a.Mov_ID  AND MovP_ID = a.MovP_ID AND MovM_ID = a.MovM_ID) CajaMaster"
		sSQLO += " ,MovS_Serie "
		sSQLO += " ,(SELECT CONVERT(NVARCHAR(20),GETDATE(),103)) as FECHA  "
		sSQLO += " FROM Movimineto_Pallet_Master_Serie a"
		sSQLO += " WHERE Mov_ID = "+Mov_ID
		sSQLO += " AND MovP_ID = "+MovP_ID
		sSQLO += " AND MovM_ID = "+MovM_ID
		
	var rsJson = AbreTabla(sSQLO,1,0)
	if(!rsJson.EOF){
		var Pallet = rsJson.Fields.Item("Pallet").Value 
		var CajaMaster = rsJson.Fields.Item("CajaMaster").Value
		var FECHA = rsJson.Fields.Item("FECHA").Value
	}
	var sSQLC = "  SELECT COUNT(*)  Cantidad "
		sSQLC += " FROM Movimineto_Pallet_Master_Serie a"
		sSQLC += " WHERE Mov_ID = "+Mov_ID
		sSQLC += " AND MovP_ID = "+MovP_ID
		sSQLC += " AND MovM_ID = "+MovM_ID
		
	var rsCantidad = AbreTabla(sSQLC,1,0)
	if(!rsCantidad.EOF){
		var Cantidad = rsCantidad.Fields.Item("Cantidad").Value 
	}
		
		
	var rsJson = AbreTabla(sSQLO,1,0)
	if(!rsJson.EOF){
		var Pallet = rsJson.Fields.Item("Pallet").Value 
		var CajaMaster = rsJson.Fields.Item("CajaMaster").Value
		var FECHA = rsJson.Fields.Item("FECHA").Value
	}
%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
</head>

<table>
    <tbody>
        <tr>
            <td>
                <p>&nbsp;MFORTEL M&Eacute;XICO S.A de C.V</p>
                <p>Av. Ejercito Nacional 436 Piso 3<br>
                Col. Polanco V secci&oacute;n<br>
                C.P 11560, Ciudad de M&eacute;xico<br>
                Tel: +52(55) 26243406<br>
                &nbsp; &nbsp; &nbsp; +52(55)&nbsp;52030892<br>
                Destino: M&eacute;xico<br>
                Numero de Pallet : <%=Pallet%></p>
            </td>
            <td>
                <p>RUTEADOR LTE (Consumer Premises Equipment)<br>
                M4 WiLink 3<br>
                Marca: M4 CONECTIVITY<br>
                Color: Blanco<br>
                Pzas.Caja:&nbsp;<%=Cantidad%><br>
                Ensamblado en China<br>
                Fecha de Pallet:&nbsp; <%=FECHA%></p>
            </td>
        </tr>
        <tr>
            <td>&nbsp;Carton No.:&nbsp;<%=CajaMaster%></td>
            <td>&nbsp;</td>
        </tr>
        <tr style="border-bottom: 3px solid black;">
            <td><div><canvas id="barcode"></canvas></div></td>
            <td align="center"><img src="/pz/wms/Transferencia/Formatos/M4/Candadito.png" width="50" height="50" alt=""/></td>
        </tr>

<%
	var sSQLO2 = "  SELECT MovS_Serie "
		sSQLO2 += " FROM Movimineto_Pallet_Master_Serie a"
		sSQLO2 += " WHERE Mov_ID = "+Mov_ID
		sSQLO2 += " AND MovP_ID = "+MovP_ID
		sSQLO2 += " AND MovM_ID = "+MovM_ID
	
	var par = 0
	var contendo = ""
	var rsSeries = AbreTabla(sSQLO2,1,0)
	while(!rsSeries.EOF){
		var Serie = rsSeries.Fields.Item("MovS_Serie").Value
				
		if (par == 0) {
		    contendo += "<tr>"	
        }	
				
		    contendo += "<td>"
			contendo += "<svg class='barcode'"
			contendo += "jsbarcode-textmargin='0'"
			contendo += "jsbarcode-value='"+Serie+"'"
			contendo += "jsbarcode-displayvalue='true'"
			contendo += "jsbarcode-fontsize='16'"
			contendo += "jsbarcode-height='40'"
			contendo += "jsbarcode-width='2'>"
			contendo += "</svg>"
			contendo += "</td>"
			
		if (par == 0) {
		    par = 1	
        }else {
			contendo += "</tr>"
		    par = 0	
        }	
		

   rsSeries.MoveNext()
 }
 rsSeries.Close() 
 Response.Write(contendo)		

 
 %> 	
         
    </tbody>
</table>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >

JsBarcode(".barcode").init();

JsBarcode("#barcode", "<%=CajaMaster%>", {
  width: 2,
  height: 30,
  displayValue: false,
});
		

</script>    



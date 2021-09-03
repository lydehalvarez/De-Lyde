<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Pt_ID = Parametro("Pt_ID",-1)
	var ordenCompra = Parametro("ordenCompra",-1)
	var idContenido = Parametro("idContenido",-1)
	var codigoEKT = Parametro("codigoEKT",-1)
	
	
	var sSQLO = " SELECT * "
		sSQLO += " FROM Recepcion_Series i "
		sSQLO += " WHERE Pt_ID = " + Pt_ID
		sSQLO += " AND Pro_ID = (SELECT Pro_ID FROM Producto WHERE Pro_SKU = '"+codigoEKT+"')" 
		
		
	var Elementos = 0
	var rsJson = AbreTabla(sSQLO,1,6)
	
	while (!rsJson.EOF){ 
	    var SERIE =  rsJson.Fields.Item("Ser_Serie").Value
	    //SKU =  rsJson.Fields.Item("sku").Value
	
 
%>{
 "idContenido": <%=idContenido%>,
 "codigoEKT":<%=codigoEKT%>,
 "cantidad":1,
 "imei":"<%=SERIE%>",
 "ordenCompra":"<%=ordenCompra%>"
},
<%
 
   rsJson.MoveNext()
   Elementos++
 }
 rsJson.Close() 
 Response.Write(Elementos)
%>

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TOP = Parametro("TOP",-1)
	var LOTE = Parametro("LOTE",-1)
	var Pro_SKU = Parametro("Pro_SKU","")
	var Tipo = Parametro("Tipo","")
	var Inv_ID = Parametro("Inv_ID",-1)  
	var SOLOSERIES = Parametro("SOLOSERIES",-1)
	

	var sSQLO = "  SELECT TOP("+TOP+") Inv_Serie "
		sSQLO += " FROM Inventario "
		sSQLO += " WHERE Inv_LoteIngreso = " +LOTE
		sSQLO += " AND Pro_ID = (SELECT Pro_ID FROM Producto WHERE Pro_SKU = '"+Pro_SKU+"') "
		if(Inv_ID > -1){
		sSQLO += " AND Inv_ID > "+Inv_ID  
		}
	var rsJson = AbreTabla(sSQLO,1,0)
	var TipoSol = ""
	if(Tipo == 1){
		TipoSol = "imei"
	}else
	{
		TipoSol = "iccid"
	}
	var Elementos = 0
	while (!rsJson.EOF){ 
	var Inv_Serie =  rsJson.Fields.Item("Inv_Serie").Value
if(SOLOSERIES == -1){
%>{
    "<%=TipoSol%>":"<%=Inv_Serie%>",
    "sku":"<%=Pro_SKU%>"
},
<%
 
}else{
%>{
    "<%=Inv_Serie%>"
},
<%
	
}

   rsJson.MoveNext()
   Elementos++
 }
 rsJson.Close() 
 Response.Write(Elementos)
%>
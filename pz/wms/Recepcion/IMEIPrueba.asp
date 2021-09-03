<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TOP = Parametro("TOP",-1)
	var LOTE = Parametro("LOTE",-1)
	var Pro_SKU = Parametro("Pro_SKU","")
	var Tipo = Parametro("Tipo",1)
	var Inv_ID = Parametro("Inv_ID",-1)  
	var SOLOSERIES = Parametro("SOLOSERIES",-1)
	var Test = Parametro("Test",0)
	
	var sSQLO = " SELECT "
   
   if( TOP > -1 ){
	   sSQLO += "  TOP " + TOP 
   }
       sSQLO += " Inv_Serie  "
//	   if(Test == 1){
//		sSQLO += "(SELECT Pro_SKU FROM Producto p WHERE p.Pro_ID = i.Pro_ID) as sku "
//	   } else {
//	    sSQLO += "(SELECT Pro_ClaveAlterna FROM Producto p WHERE  p.Pro_ID = i.Pro_ID) as sku "
//	   }
		sSQLO += " FROM Inventario i "
		sSQLO += " WHERE Inv_LoteIngreso = " + LOTE
//    if(Tipo == 1){
//		sSQLO += " AND i.Pro_ID in (select Pro_ID from Producto where Pro_Modelo <> 'SIM' )"
//	} else {
//		sSQLO += " AND i.Pro_ID in (select Pro_ID from Producto where Pro_Modelo = 'SIM' )"
//	}
//
//
//   if( Pro_SKU != "" ){
//	   if(Test == 1){
//		sSQLO += " AND Pro_ID = (SELECT Pro_ID FROM Producto WHERE Pro_SKU = '"+Pro_SKU+"') "
//	   } else {
//	    sSQLO += " AND Pro_ID = (SELECT Pro_ID FROM Producto WHERE Pro_ClaveAlterna = '"+Pro_SKU+"') "
//	   }
//   }
	   
   if(Inv_ID > -1){
		sSQLO += " AND Inv_ID >= "+Inv_ID  
   }

	var TipoSol = ""
	if(Tipo == 1){
		TipoSol = "imei"
	}else {
		TipoSol = "iccid"
	}

	var Elementos = 0
	var rsJson = AbreTabla(sSQLO,1,6)
	while (!rsJson.EOF){ 
	var SERIE =  rsJson.Fields.Item("Inv_Serie").Value
	//var SKU =  rsJson.Fields.Item("sku").Value
	
if(SOLOSERIES == -1 && SERIE != ""){
%>{
    "<%=TipoSol%>":"<%=SERIE%>",
    "sku":"<%=Pro_SKU%>",
    "pedimento":"00 00 0000 0000000",
    "fechaPedimento":"11/06/2020"
},
<%
}
//if(SOLOSERIES == 1){
// 
//    Response.Write(SERIE + "<br>")
//
//}
//if(SOLOSERIES == 2 && SERIE != ""){
/*%>%>{
<!--    "<%=TipoSol%>":"<%=SERIE%>",
    "sku":"<%=Pro_SKU%>",
    "pedimento":"",
    "fechaPedimento":""
-->},
<%
<%*/


   rsJson.MoveNext()
   Elementos++
 }
 rsJson.Close() 
 Response.Write(Elementos)
%>
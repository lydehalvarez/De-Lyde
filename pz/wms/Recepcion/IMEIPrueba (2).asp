<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TOP = Parametro("TOP",-1)
	var LOTE = Parametro("LOTE",-1)
	var Pro_SKU = Parametro("Pro_SKU","")
	var Tipo = Parametro("Tipo",1)
	var Inv_ID = Parametro("Inv_ID",-1)  
	var SOLOSERIES = Parametro("SOLOSERIES",-1)
	var Test = 0 // Parametro("Test",0)
	
//	var sSQLO = " SELECT "
//   
//   if( TOP > -1 ){
//	   sSQLO += "  TOP " + TOP 
//   }
//       sSQLO += " Inv_Serie  "
//	   if(Test == 1){
//		sSQLO += ",(SELECT Pro_SKU FROM Producto p WHERE p.Pro_ID = i.Pro_ID) as SKU "
//	   } else {
//	    sSQLO += ",(SELECT Pro_ClaveAlterna FROM Producto p WHERE  p.Pro_ID = i.Pro_ID) as SKU "
//	   }
//		sSQLO += " FROM Inventario i "
//		sSQLO += " WHERE Inv_LoteIngreso = " + LOTE
//    if(Tipo == 1){
//		sSQLO += " AND i.Pro_ID in (select Pro_ID from Producto where Pro_Modelo <> 'SIM' )"
//	} else {
//		sSQLO += " AND i.Pro_ID in (select Pro_ID from Producto where Pro_Modelo = 'SIM' )"
//	}
//	sSQLO += " Order by SKU "
	
	var sSQLO = " SELECT "
		sSQLO += " Inv_Serie  "
		sSQLO += " FROM Inventario  "
		sSQLO += " WHERE Inv_LoteIngreso = "+LOTE
		
	

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
	var SERIE = ""
	var SKU = ""
	
	if(Tipo == 1){
		TipoSol = "imei"
	}else {
		TipoSol = "iccid"
	}

	var Elementos = 0
	var rsJson = AbreTabla(sSQLO,1,6)
	while (!rsJson.EOF){ 
	    SERIE =  rsJson.Fields.Item("Inv_Serie").Value
	    //SKU =  rsJson.Fields.Item("sku").Value
	
 
%>{
    "<%=TipoSol%>":"<%=SERIE%>",
    "sku":"<%=Pro_SKU%>",
    "fechaPedimento":"07/07/2020",
    "pedimento":"4578983"
},
<%
 
   rsJson.MoveNext()
   Elementos++
 }
 rsJson.Close() 
 Response.Write(Elementos)
%>
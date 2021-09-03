<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TOP = Parametro("TOP",-1)
	var LOTE = Parametro("LOTE",-1)   
	var SKU = Parametro("SKU","")
	var Tipo = Parametro("Tipo",1)
	var Inv_ID = Parametro("Inv_ID",-1)  
	var SOLOSERIES = Parametro("SOLOSERIES",-1)
	var BD = Parametro("BD",0)
	var PO = Parametro("PO",-1)
	var Test = 0 // Parametro("Test",0)
	
	var d = new Date(); 
	var dia = d.getDate()
	var mes = d.getMonth() +1 
	var anio = d.getYear()
	
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
	
	var sSQLO = " SELECT TOP "+TOP+" (SELECT Lot_Folio FROM Inventario_Lote WHERE Lot_ID = i.Inv_LoteActual) Lote "
		sSQLO += " ,Inv_Serie  "
		sSQLO += " FROM Inventario i " 
		sSQLO += " WHERE Inv_LoteActual = "+LOTE
		sSQLO += " AND Pro_ID = (SELECT Pro_ID FROM Producto WHERE Pro_ClaveAlterna = '"+SKU+"' OR Pro_SKU = '"+SKU+"')"
		
	var sSQLPO = "SELECT CliOC_NumeroOrdenCompra,(SELECT CliOCP_CORID FROM Cliente_OrdenCompra_Articulos WHERE Cli_ID = 2 AND CliOC_ID = a.CliOC_ID AND CliOCP_SKU = '"+SKU+"' ) as Posicion "
		sSQLPO += " FROM Cliente_OrdenCompra a  "
		sSQLPO += " WHERE CliOC_NumeroOrdenCompra = '"+PO+"'  "

	var Test = ""
	var CliOC_NumeroOrdenCompra = ""
	var Posicion = ""
	//bd wms = 0
	//bd wms_test = 6

	var PoDATA = AbreTabla(sSQLPO,1,BD)
	if(!PoDATA.EOF){ 
		CliOC_NumeroOrdenCompra =PoDATA.Fields.Item("CliOC_NumeroOrdenCompra").Value
		Posicion =PoDATA.Fields.Item("Posicion").Value
	}
	var Lote = ""
	var InvDATA = AbreTabla(sSQLO,1,BD)
	if(!InvDATA.EOF){ 
	    var Lote =  InvDATA.Fields.Item("Lote").Value
	}
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
	var TipoSolData = ""
	
	if(Tipo == 1){
		TipoSol = "imei"
		TipoSolData = "phones"
	}else {
		TipoSol = "iccid"
		TipoSolData = "sims"
	}
 
%>{
	"purchaseOrder":"<%=PO%>0000<%=Posicion%>",
	"idLote":"<%=Lote%>",
	"partes":1,
	"numParte":1,
	"<%=TipoSolData%>":[
<%
	var Elementos = 0
	var rsJson = AbreTabla(sSQLO,1,BD)
	while (!rsJson.EOF){ 
	    SERIE =  rsJson.Fields.Item("Inv_Serie").Value
	    //SKU =  rsJson.Fields.Item("sku").Value
	
 
%>{
    "<%=TipoSol%>":"<%=SERIE%>",
    "sku":"<%=SKU%>",
    "fechaPedimento":"<%=dia%>/<%=mes%>/<%=anio%>",
    "pedimento":"00 00 0000 0000000"
},
<%
 
   rsJson.MoveNext()
   Elementos++
 }
 rsJson.Close() 
 Response.Write(Elementos)
%>
]
}
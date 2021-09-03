<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
[
<%
			  var Pt_LPN =	 Parametro("Pt_LPN","")
			   var Ubi_ID = Parametro("Ubi_ID",-1)
			   var Cli_ID = Parametro("Cli_ID",-1)
			   var Pro_SKU = Parametro("Pro_SKU","")
				var Pro_ID = -1
		//		if (Pro_SKU != ""){
//						
//					var sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU='"+Pro_SKU+"'"
//					 var rsProducto = AbreTabla(sSQL,1,0);
//
//					var Pro_ID = rsProducto.Fields.Item("Pro_ID").Value
//				}
//				
//					if (Pt_LPN != ""){
//						
//					var sSQL = "SELECT Pt_ID FROM Pallet WHERE Pt_LPN='" + Pt_LPN + "'"
//					 var rsPallet = AbreTabla(sSQL,1,0);
//
//					var Pt_ID = rsPallet.Fields.Item("Pt_ID").Value
//				}

var sSQL  = "	SELECT  PT.PT_LPN, Pro.Pro_SKU as SKU, Pro.Pro_Nombre as Producto"
				+	", Ubi.Ubi_Nombre AS Ubicacion, PT.PT_Cantidad_Actual as Cantidad"
				+	",ISNULL([Ubi_Etiqueta],'') as etiqueta"
				+	" FROM Pallet PT "
				+	" LEFT JOIN Producto Pro ON PT.Pro_ID = Pro.Pro_ID"
				+	" LEFT JOIN Ubicacion Ubi ON PT.Ubi_ID = Ubi.Ubi_ID"
				+ " LEFT JOIN Ubicacion_Area Are "
				+ " ON Ubi.Are_ID = Are.Are_ID "
				+ " LEFT JOIN Inventario_Lote Lot "
				+ " ON PT.Lot_ID = Lot.Lot_ID "
				+	" WHERE  PT.PT_Cantidad_Actual > 0 " 
         		+ " AND Are.Are_AmbientePallet in (0,1,5, 7) "
				//	 if(Pro_ID > -1){
//						sSQL +=  " and PT.Pro_ID = "  + Pro_ID
//					  }
//					  if(Cli_ID > -1){
//						sSQL +=  " AND PT.Cli_ID =" + Cli_ID  
//					  }
//					 if(Pt_ID > -1){
//						sSQL +=  " and PT.Pt_ID = "  + Pt_ID
//					 }
//					  if(Cli_ID > -1){
//						sSQL +=  " AND PT.Cli_ID =" + Cli_ID  
//					  }	  
	


		//Response.Write(sSQL)
//    var sSQL  = "select Ubi_Nombre as Ubicacion"
//					+	",ISNULL([Ubi_Etiqueta],'') as etiqueta"
//					+	",[Pt_LPN]"
//					+	",Pro_SKU as SKU"
//					+ ", Pro_Nombre as Producto"
//					+ ",[PT_Cantidad_Actual] as Cantidad"
//					+ ", [PT_ConteoFisico] as CantidadAuditadaAnoche"
//					+ " from Ubicacion u, Pallet pt, Producto p"
//					+ " where pt.Ubi_ID = u.Ubi_ID and p.Pro_ID = pt.Pro_ID"
//					+ " and pt.Ubi_ID > -1"
//					+ " and pt.[PT_Cantidad_Actual] > 0"
//					+ " and u.Ubi_Viva = 1"
//					+ " and pt.[Pt_FechaVacio] is null"
//					+ " AND pt.Ubi_ID in ( SELECT u.Ubi_ID FROM Ubicacion u, Ubicacion_Area a, Ubicacion_Configuracion uc "
//					+ " WHERE u.Are_ID = a.Are_ID and uc.Ubi_ID = u.Ubi_ID "
//					+ " AND uc.Ubi_EsCuarentena = 0 "
//					+ " AND a.Are_AmbientePallet in ( 1, 5))"
		var i = 0
		var rsRe = AbreTabla(sSQL,1,0)

	while (!rsRe.EOF){
  	     var Ubicacion = rsRe.Fields.Item("Ubicacion").Value   
   	     var Etiqueta  = rsRe.Fields.Item("etiqueta").Value 
		 var LPN = rsRe.Fields.Item("Pt_LPN").Value   
	     var SKU  = rsRe.Fields.Item("SKU").Value 
		 var Producto  = rsRe.Fields.Item("Producto").Value
		 var Cantidad  = rsRe.Fields.Item("Cantidad").Value   
	
	%>{
    "Ubicacion":"<%=Ubicacion%>",
    "Etiqueta":"<%=Etiqueta%>",
    "LPN":"<%=LPN%>",
    "SKU":"<%=SKU%>",
    "Producto":"<%=Producto%>",
    "Cantidad":"<%=Cantidad%>"
    
}<%=(i < rsRe.RecordCount -1) ? "," : ""  %>
<%
i++;
            rsRe.MoveNext() 
        }
         rsRe.Close()   
       
%>]


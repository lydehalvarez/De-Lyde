<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1) 
	var CodigoIdentificador = Parametro("CodigoIdentificador","") 
	var AlmacenOrigen = Parametro("AlmacenOrigen","") 
	var AlmacenDestino = Parametro("AlmacenDestino","") 
	var UbicacionTienda = Parametro("UbicacionTienda","") 
	var HorarioAtencion = Parametro("HorarioAtencion","") 
	var TipoAcceso = Parametro("TipoAcceso","") 
	var Responsable = Parametro("Responsable","") 
	var Celular = Parametro("Celular","")   
	var Email = Parametro("Email","") 
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1) 
	var IDUsuario = Parametro("IDUsuario",-1) 
 

 	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		case 1:	
		var TA_ID = Parametro("TA_ID",-1) 
			if(TA_ID == -1){
					TA_ID = BuscaSoloUnDato("ISNULL((MAX(TA_ID)),0)+1","TransferenciaAlmacen","",-1,0)
			try {
	
					var sSQL = " INSERT INTO TransferenciaAlmacen (TA_ID,TA_ArchivoID) "
						sSQL += " VALUES ("+TA_ID+","+TA_ArchivoID+")"
	
						Ejecuta(sSQL,0)
						
					var sSQLArchi = " INSERT INTO TransferenciaAlmacen_Archivo (TA_ArchivoID,TA_NombreArchivo) "
						sSQLArchi += " VALUES ("+TA_ArchivoID+",'Transferencia "+TA_ArchivoID+"')"
	
						Ejecuta(sSQLArchi, 0)
						
					var USQL = " UPDATE TransferenciaAlmacen "
						USQL += " SET TA_CodigoIdentificador = '"+CodigoIdentificador+"'"
						USQL += " , TA_Start_Warehouse = '"+AlmacenOrigen+"'"
						USQL += " , TA_End_Warehouse = '"+AlmacenDestino+"'"
						USQL += " , TA_UbicacionTienda = '"+UbicacionTienda+"'"
						USQL += " , TA_HorarioAtencion = '"+HorarioAtencion+"'"
						USQL += " , TA_TipoAcceso = '"+TipoAcceso+"'"
						USQL += " , TA_Responsable = '"+Responsable+"'"
						USQL += " , TA_Celular = '"+Celular+"'"
						USQL += " , TA_Email = '"+Email+"'"
						USQL += " WHERE TA_ID = "+TA_ID
	
						Ejecuta(USQL, 0)
						
						sResultado = 1
						
				} catch (err) {
					sResultado = -1
							
					var ArchSQL = " DELETE FROM TransferenciaAlmacen_Archivo WHERE  TA_ArchivoID =  "+TA_ArchivoID
						Ejecuta(ArchSQL, 0)
		
					var TRASQL = " DELETE FROM TransferenciaAlmacen WHERE TA_ID =  "+TA_ID
						Ejecuta(TRASQL, 0)
		
				}
			}
		break;  
		case 2:	
			var CodigoIdentificador = Parametro("CodigoIdentificador","") 
			var SKU = Parametro("SKU","") 
			var Cantidad = Parametro("Cantidad",-1) 
			try{
				var sSQL = "SELECT TA_ID "
					sSQL += " FROM TransferenciaAlmacen"
					sSQL += " WHERE TA_CodigoIdentificador = '"+CodigoIdentificador+"'"
					sSQL += " AND TA_ArchivoID = "+TA_ArchivoID
					
				var rsExt = AbreTabla(sSQL,1,0)
				
				if(!rsExt.EOF){
					var TA_ID = rsExt.Fields.Item("TA_ID").Value
						TAA_ID = BuscaSoloUnDato("ISNULL((MAX(TAA_ID)),0)+1","TransferenciaAlmacen_Articulos","TA_ID = "+ TA_ID,-1,0)
						
					var ISQL = " INSERT INTO TransferenciaAlmacen_Articulos (TA_ID,TAA_ID,TAA_SKU,TAA_Cantidad,Pro_ID) "
						ISQL += " VALUES ("+TA_ID+","+TAA_ID+",'"+SKU+"',"+Cantidad+",(SELECT Pro_ID FROM Producto p WHERE p.Pro_SKU = '"+SKU+"' OR p.Pro_ClaveAlterna = '"+SKU+"'))"
	
						Ejecuta(ISQL, 0)
						sResultado = 1
				}
			}catch(err){
					sResultado = -1
			}
		break;  
		case 3:	
			var TAS_Serie = Parametro("TAS_Serie","") 
			var TA_ID = Parametro("TA_ID",-1) 
			var TAS_Usuario = Parametro("IDUsuario",-1) 
	
			try{
				var Existe = BuscaSoloUnDato("TAS_ID","TransferenciaAlmacen_Articulo_Picking","TAS_Serie = '"+TAS_Serie+"' AND TA_ID = "+TA_ID,-1,0)
				
				if(Existe > 0){
					sResultado = '{"result":-3,"message":"Esta serie ya ha sido pickeada"}'
				}else{
				
					var sSQL = "SELECT Pro_ID, Inv_ID "
						sSQL += " FROM Inventario"
						sSQL += " WHERE Inv_Serie = '"+TAS_Serie+"'"
						
					var rsExt = AbreTabla(sSQL,1,0)
					
					if(!rsExt.EOF){
						var Pro_ID = rsExt.Fields.Item("Pro_ID").Value
						var Inv_ID = rsExt.Fields.Item("Inv_ID").Value
						var FindPRo = "SELECT TAA_ID, TAA_Cantidad "
							FindPRo += " FROM TransferenciaAlmacen_Articulos "
							FindPRo += " WHERE TA_ID = "+TA_ID
							FindPRo += " AND Pro_ID = "+Pro_ID
							
						var rsPro = AbreTabla(FindPRo,1,0)
						if(!rsPro.EOF){
							var TAA_Cantidad = rsPro.Fields.Item("TAA_Cantidad").Value
							var TAA_ID = rsPro.Fields.Item("TAA_ID").Value
							var TAS_ID = BuscaSoloUnDato("ISNULL((MAX(TAS_ID)),0)+1","TransferenciaAlmacen_Articulo_Picking","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
							
							if(TAS_ID <= TAA_Cantidad){
							
							var ISQL = " INSERT INTO TransferenciaAlmacen_Articulo_Picking (TA_ID,TAA_ID,TAS_ID,TAS_Serie,TAS_Usuario,Pro_ID,Inv_ID) "
								ISQL += " VALUES ("+TA_ID+","+TAA_ID+","+TAS_ID+",'"+TAS_Serie+"',"+TAS_Usuario+","+Pro_ID+","+Inv_ID+")"
			
								Ejecuta(ISQL, 0)
								sResultado = '{"result":1,"message":"Colocado exitosamente","con":"'+TAS_ID+'","TAA_ID":"'+TAA_ID+'"}'
							}else{
								sResultado = '{"result":-2,"message":"Maximo de productos cargados"}'
							}
								
						}else{
							sResultado = '{"result":-1,"message":"Producto no requerido"}'
						}
					}else{
						sResultado = '{"result":0,"message":"Producto no encontrado, comunicarse a sistemas"}'
					}
				}
			}catch(err){
					sResultado = err
			}
		break; 
		case 4:
		var IDs = Parametro("IDs","")
		var Cli_ID = Parametro("Cli_ID",-1)
		var NumElementos = Parametro("NumElementos",-1)
		
		try{
			var Lot_ID = BuscaSoloUnDato("ISNULL(MAX(Lot_ID),0)+1","Inventario_Lote","",-1,0)
			
			var sSQLLote = " INSERT INTO Inventario_Lote(Lot_ID,Lot_Numero,Cli_ID,Lot_CantidadTotal,Lot_TipoMovimientoCG83) "
				sSQLLote += " VALUES ("+Lot_ID+",'"+Lot_ID+"',"+Cli_ID+","+NumElementos+",2)"

				Ejecuta(sSQLLote, 0)
				
			var TA_ArchivoID = BuscaSoloUnDato("ISNULL(MAX(TA_ArchivoID),0)+1","TransferenciaAlmacen_Archivo","",-1,0)
						
			var sSQLArchi = " INSERT INTO TransferenciaAlmacen_Archivo (TA_ArchivoID,TA_NombreArchivo,Cli_ID,Lot_ID,TA_Usuario) "
				sSQLArchi += " VALUES ("+TA_ArchivoID+",'Transferencia "+TA_ArchivoID+"',"+Cli_ID+","+Lot_ID+","+IDUsuario+")"

				Ejecuta(sSQLArchi, 0)
				
			var CorteUp = "Update TransferenciaAlmacen "
				CorteUp += " SET TA_ArchivoID = "+TA_ArchivoID
				CorteUp += " WHERE TA_ID in ("+IDs+")"
			
				Ejecuta(CorteUp,0)
				
				sResultado = TA_ArchivoID
	
		}catch(err){
			sResultado = -1
		}
		
		break;
	}
Response.Write(sResultado)
%>

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
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
				var Disponible = BuscaSoloUnDato("Inv_EstatusCG20","Inventario","Inv_Serie = '"+TAS_Serie+"'",-1,0)
				if(Disponible == 1){
				var Existe = BuscaSoloUnDato("TAS_ID","TransferenciaAlmacen_Articulo_Picking","TAS_Serie = '"+TAS_Serie+"' AND TA_ID = "+TA_ID,-1,0)
					if(Existe > 0){
						sResultado = '{"result":-3,"message":"Esta serie ya ha sido pickeada"}'
					}else{
					
						var sSQL = "SELECT Pro_ID,Inv_ID "
							sSQL += " FROM Inventario"
							sSQL += " WHERE Inv_Serie = '"+TAS_Serie+"'"
							
						var rsExt = AbreTabla(sSQL,1,0)
						
						if(!rsExt.EOF){ 
							var Pro_ID = rsExt.Fields.Item("Pro_ID").Value
							var Inv_ID = rsExt.Fields.Item("Inv_ID").Value
							
							var FindPRo = "SELECT TAA_ID, TAA_Cantidad, TAA_CantidadPickiada "
								FindPRo += " FROM TransferenciaAlmacen_Articulos "
								FindPRo += " WHERE TA_ID = "+TA_ID
								FindPRo += " AND Pro_ID = "+Pro_ID
								FindPRo += " AND TAA_CantidadPickiada < TAA_Cantidad"
								
							var rsPro = AbreTabla(FindPRo,1,0)
							if(!rsPro.EOF){
								var TAA_Cantidad = rsPro.Fields.Item("TAA_Cantidad").Value
								var TAA_ID = rsPro.Fields.Item("TAA_ID").Value
								var TAA_CantidadPickiada = rsPro.Fields.Item("TAA_CantidadPickiada").Value
								var TAS_ID = BuscaSoloUnDato("ISNULL((MAX(TAS_ID)),0)+1","TransferenciaAlmacen_Articulo_Picking","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
								
								if(TAS_ID <= TAA_Cantidad){
								
								var ISQL = " INSERT INTO TransferenciaAlmacen_Articulo_Picking (TA_ID,TAA_ID,TAS_ID,TAS_Serie,TAS_Usuario,Pro_ID,Inv_ID) "
									ISQL += " VALUES ("+TA_ID+","+TAA_ID+","+TAS_ID+",'"+TAS_Serie+"',"+TAS_Usuario+","+Pro_ID+","+Inv_ID+")"
				
									Ejecuta(ISQL, 0)
									
								var ISQL1 = " UPDATE TransferenciaAlmacen_Articulos "
									ISQL1 += " SET TAA_CantidadPickiada =  " + parseInt(TAA_CantidadPickiada + 1)
									ISQL1 += " WHERE TA_ID = "+TA_ID
									ISQL1 += " AND TAA_ID = "+TAA_ID
					
									Ejecuta(ISQL1, 0)
									
								var TA_End_Warehouse_ID = BuscaSoloUnDato("TA_End_Warehouse_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)
									
								var USQL = " UPDATE Inventario "
									USQL += " SET Alm_ID = " +TA_End_Warehouse_ID
									USQL += " WHERE Inv_Serie = '"+TAS_Serie+"'"
				
									Ejecuta(USQL, 0)
									
									sResultado = '{"result":1,"message":"Colocado exitosamente","con":"'+TAS_ID+'","TAA_ID":"'+TAA_ID+'","SQL":"'+ISQL+'"}'
								}else{
									
									
									sResultado = '{"result":-2,"message":"Maximo de productos cargados"}'
								}
									
							}else{
								sResultado = '{"result":-1,"message":"Producto no requerido", "Query":"'+sSQL+'"}'
							}
						}else{
							sResultado = '{"result":0,"message":"Producto no encontrado, comunicarse a sistemas"}'
						}
					}
				}else{
							sResultado = '{"result":-1,"message":"Producto no disponible para venta"}'
				}
			}catch(err){
					sResultado = err
			}
		break; 
		case 5:
			var TA_ID = Parametro("TA_ID","")
			var sSQL = "SELECT TA_Folio,TA_FolioCliente,idTienda,d.* "
				sSQL +=	"FROM TransferenciaAlmacen t, [dbo].[EKT_envioOrdenesEKT] e,[dbo].[EKT_Tienda] d "
				sSQL +=	" WHERE t.EKT_ID = e.SK_num_envio "
				sSQL +=	" AND  e.idTienda = d.Tda_ID "
				sSQL +=	" AND t.TA_ID =  " + TA_ID
		
		
			var rsData = AbreTabla(sSQL,1,0)
			if(!rsData.EOF){
				var TA_Folio = rsData.Fields.Item("TA_Folio").Value
				var TA_FolioCliente = rsData.Fields.Item("TA_FolioCliente").Value
				var idTienda = rsData.Fields.Item("idTienda").Value
				var Tda_ID = rsData.Fields.Item("Tda_ID").Value
				var Tda_Nombre = rsData.Fields.Item("Tda_Nombre").Value
				var Tda_Calle = rsData.Fields.Item("Tda_Calle").Value
				var Tda_NumeroExterior = rsData.Fields.Item("Tda_NumeroExterior").Value
				var Tda_NumeroInterior = rsData.Fields.Item("Tda_NumeroInterior").Value
				var Tda_Ciudad = rsData.Fields.Item("Tda_Ciudad").Value
				var Tda_Estado = rsData.Fields.Item("Tda_Estado").Value
				var Tda_Colonia = rsData.Fields.Item("Tda_Colonia").Value
				var Tda_CodigoPostal = rsData.Fields.Item("Tda_CodigoPostal").Value
				
				var ContactoTienda = "SELECT TOP 1 * FROM EKT_Tienda_Contacto WHERE Tda_ID = "+Tda_ID
					var rsData2 = AbreTabla(ContactoTienda,1,0)
					if(!rsData2.EOF){
						var TdaC_Nombre = rsData2.Fields.Item("TdaC_Nombre").Value
						var TdaC_Telefono = rsData2.Fields.Item("TdaC_Telefono").Value
					}
				
				sResultado = '{'
				sResultado += '"Folio":"'+TA_Folio+'"'
				sResultado += ',"Nombre":"'+TdaC_Nombre+'"'
				sResultado += ',"Telefono":"'+TdaC_Telefono+'"'
				sResultado += ',"Calle":"'+Tda_Calle+'"'
				sResultado += ',"NumeroExt":"'+Tda_NumeroExterior+'"'
				sResultado += ',"NumeroInt":"'+Tda_NumeroInterior+'"'
				sResultado += ',"Colonia":"'+Tda_Colonia+'"'
				sResultado += ',"Municipio":"'+Tda_Ciudad+'"'
				sResultado += ',"CP":"'+Tda_CodigoPostal+'"'
				sResultado += ',"Estado":"'+Tda_Estado+'"'
				sResultado += ',"Pais":"Mexico"'
				sResultado += ',"Referencia1":"'+TA_FolioCliente+'"'
				sResultado += ',"Referencia2":"'+idTienda+' '+Tda_Nombre+'"'
				sResultado += '}'
			}
			
		break;
		case 6:	
			var TAS_Serie = Parametro("TAS_Serie","") 
			var TA_ID = Parametro("TA_ID",-1) 
			var TAS_Usuario = Parametro("IDUsuario",-1) 
	
			try{
				var Disponible = BuscaSoloUnDato("Pt_ID","Recepcion_Series","Ser_Serie = '"+TAS_Serie+"'",-1,0)
				if(Disponible > 1){
				var Existe = BuscaSoloUnDato("TAS_ID","TransferenciaAlmacen_Articulo_Picking","TAS_Serie = '"+TAS_Serie+"' AND TA_ID = "+TA_ID,-1,0)
					if(Existe > 0){
						sResultado = '{"result":-3,"message":"Esta serie ya ha sido pickeada"}'
					}else{
					
						var sSQL = "SELECT Pro_ID "
							sSQL += " FROM Recepcion_Series"
							sSQL += " WHERE Ser_Serie = '"+TAS_Serie+"'"
							
						var rsExt = AbreTabla(sSQL,1,0)
						
						if(!rsExt.EOF){
							var Pro_ID = rsExt.Fields.Item("Pro_ID").Value
							var Inv_ID = 4
							var FindPRo = "SELECT TAA_ID, TAA_Cantidad, TAA_CantidadPickiada "
								FindPRo += " FROM TransferenciaAlmacen_Articulos "
								FindPRo += " WHERE TA_ID = "+TA_ID
								FindPRo += " AND Pro_ID = "+Pro_ID
								FindPRo += " AND TAA_CantidadPickiada < TAA_Cantidad"
								
							var rsPro = AbreTabla(FindPRo,1,0)
							if(!rsPro.EOF){
								var TAA_Cantidad = rsPro.Fields.Item("TAA_Cantidad").Value
								var TAA_ID = rsPro.Fields.Item("TAA_ID").Value
								var TAA_CantidadPickiada = rsPro.Fields.Item("TAA_CantidadPickiada").Value
								var TAS_ID = BuscaSoloUnDato("ISNULL((MAX(TAS_ID)),0)+1","TransferenciaAlmacen_Articulo_Picking","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
								
								if(TAS_ID <= TAA_Cantidad){
								
									var ISQL = " INSERT INTO TransferenciaAlmacen_Articulo_Picking (TA_ID,TAA_ID,TAS_ID,TAS_Serie,TAS_Usuario,Pro_ID,Inv_ID) "
										ISQL += " VALUES ("+TA_ID+","+TAA_ID+","+TAS_ID+",'"+TAS_Serie+"',"+TAS_Usuario+","+Pro_ID+","+Inv_ID+")"
					
									Ejecuta(ISQL, 0)
									
									var ISQL1 = " UPDATE TransferenciaAlmacen_Articulos "
										ISQL1 += " SET TAA_CantidadPickiada =  " + TAA_CantidadPickiada + 1
										ISQL1 += " WHERE TA_ID = "+TA_ID
										ISQL1 += " AND TAA_ID = "+TAA_ID
					
									Ejecuta(ISQL1, 0)
										
									var TA_End_Warehouse_ID = BuscaSoloUnDato("TA_End_Warehouse_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)
										
									var USQL = " UPDATE Inventario "
										USQL += " SET Alm_ID = " +TA_End_Warehouse_ID
										USQL += " WHERE Inv_Serie = '"+TAS_Serie+"'"
					
									Ejecuta(USQL, 0)
									
									sResultado = '{"result":1,"message":"Colocado exitosamente","con":"'+TAS_ID+'","TAA_ID":"'+TAA_ID+'","Update":"'+ISQL+'"}'
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
				}else{
							sResultado = '{"result":-1,"message":"Producto no disponible para venta"}'
				}
			}catch(err){
					sResultado = err
			}
		break; 
		case 7:
			var sSQLTotal = "SELECT * "
				sSQLTotal += " FROM ( "
				sSQLTotal += " SELECT COUNT(TA_ID) Faltantes "
				sSQLTotal += " FROM TransferenciaAlmacen "
				sSQLTotal += " WHERE TA_EstatusCG51 < 4 "
				sSQLTotal += " AND TA_ArchivoID = "+TA_ArchivoID+") as tb1, "
				sSQLTotal += " ( "
				sSQLTotal += " SELECT COUNT(TA_ID) Total "
				sSQLTotal += " FROM TransferenciaAlmacen "
				sSQLTotal += " WHERE TA_ArchivoID = "+TA_ArchivoID+") as tb2 "
				
				bHayParametros = false
				ParametroCargaDeSQL(sSQLTotal,0)  

			%>
            <h2>Transferencias<br/>
          	<strong>Corte <%=TA_ArchivoID%></strong> <br />
			<strong><%=Parametro("Faltantes","")%> de <%=Parametro("Total","")%></strong></h2>
            <%
		
		break;
		
	}
Response.Write(sResultado)
%>

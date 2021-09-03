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
			var Cli_ID = BuscaSoloUnDato("Cli_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)
			
			try{
				var TRA_Disponible = BuscaSoloUnDato("TA_EstatusCG51","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)
				if(TRA_Disponible != 11){ 
					var ExisteSerie = BuscaSoloUnDato("Inv_ID","Inventario","Inv_Serie = '"+TAS_Serie+"'",-1,0)
					if(ExisteSerie > -1){
						var Disponible = BuscaSoloUnDato("Inv_EstatusCG20","Inventario","Inv_Serie = '"+TAS_Serie+"'",-1,0)
						if(Disponible == 1){
							var Existe  = BuscaSoloUnDato("TAS_ID","TransferenciaAlmacen_Articulo_Picking","TAS_Serie = '"+TAS_Serie+"' AND TA_ID = "+TA_ID,-1,0)
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
						
											if(Ejecuta(ISQL, 0))
											{
												var ISQL1 = " UPDATE TransferenciaAlmacen_Articulos "
													ISQL1 += " SET TAA_CantidadPickiada = TAA_CantidadPickiada + 1 "
													ISQL1 += " WHERE TA_ID = "+TA_ID
													ISQL1 += " AND TAA_ID = "+TAA_ID
													ISQL1 += " AND Pro_ID = "+Pro_ID 
									
													Ejecuta(ISQL1, 0)
												if(Cli_ID != 2){
													var USQL = " UPDATE Inventario "
														USQL += " SET Inv_EstatusCG20 = 14 " 
														USQL += " WHERE Inv_Serie = '"+TAS_Serie+"'"
									
													Ejecuta(USQL, 0)
												}
											}
											
											
											
											var PickeoTotal = BuscaSoloUnDato("SUM(TAA_Cantidad)","TransferenciaAlmacen_Articulos","TA_ID = "+ TA_ID,-1,0)
											var pickeados = BuscaSoloUnDato("SUM(TAA_CantidadPickiada)","TransferenciaAlmacen_Articulos","TA_ID = "+ TA_ID,-1,0)
											var result = 1
											if(PickeoTotal >= pickeados){ 
												result = 1
											}else{
												result = 2
											}
												sResultado = '{"result":'+result+',"message":"Picking terminado","con":"'+TAS_ID+'","TAA_ID":"'+TAA_ID+'","Escaneados":'+pickeados+'}'
										}else{
											sResultado = '{"result":-1,"message":"Maximo de productos cargados"}'
										}
									}else{
										sResultado = '{"result":-1,"message":"Producto no requerido o limite alcanzado"}'
									}
								}else{
									sResultado = '{"result":-1,"message":"Producto no encontrado, comunicarse a sistemas"}'
								}
							}
						}else{
							sResultado = '{"result":-1,"message":"Producto no disponible para venta"}'
							var ISQL = " INSERT INTO Inventario_Reingreso(InvR_Serie,InvR_Usuario,Inv_ID) "
								ISQL += " VALUES ('"+TAS_Serie+"',"+TAS_Usuario+","+Inv_ID+")"
			
								Ejecuta(ISQL, 0)
						}
					}else{
							sResultado = '{"result":-1,"message":"Entregar porducto a supervisor"}'
						var ISQL = " INSERT INTO Inventario_Reingreso(InvR_Serie,InvR_Usuario) "
							ISQL += " VALUES ('"+TAS_Serie+"',"+TAS_Usuario+")"
		
							Ejecuta(ISQL, 0)
					}
				}else{
					sResultado = '{"result":-1,"message":"La transferencia no esta disponible para hacer picking"}'
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
            
            var sSQLArchi = "update TransferenciaAlmacen_Archivo "
                          + " set TA_Cantidad = (select count(*) "
                                               + " from TransferenciaAlmacen t "
                                               + " where t.TA_ArchivoID = "+ TA_ArchivoID + " ) "
                          + " where TA_ArchivoID = " + TA_ArchivoID
            
            Ejecuta(sSQLArchi,0)
	
		}catch(err){
			sResultado = -1
		}
		
		break;
		case 5:
			var TA_ID = Parametro("TA_ID","")
			var sSQL = "SELECT TA_Folio,TA_FolioCliente,b.*,ISNULL(Alm_NumExt,'') Ext "
				sSQL +=	" ,ISNULL(Alm_Calle,'') Calle "
				sSQL +=	" ,ISNULL(Alm_NumInt,'') Int "
				sSQL +=	" ,ISNULL(Alm_Ciudad,'') Ciudad "
				sSQL +=	" ,ISNULL(Alm_Estado,'') Estado "
				sSQL +=	" ,ISNULL(Alm_Colonia,'') Colonia "
				sSQL +=	" ,ISNULL(Alm_CP,'') CP "
				sSQL +=	"FROM TransferenciaAlmacen a,[dbo].[Almacen] b "
				sSQL +=	" WHERE a.TA_End_Warehouse_ID = b.Alm_ID "
				sSQL +=	" AND a.TA_ID =  " + TA_ID
		
			var rsData = AbreTabla(sSQL,1,0)
			if(!rsData.EOF){
				
				var TA_Folio = rsData.Fields.Item("TA_Folio").Value
				var TA_FolioCliente = rsData.Fields.Item("TA_FolioCliente").Value
				var idTienda = rsData.Fields.Item("Tda_ID").Value
				var Tda_ID = rsData.Fields.Item("Tda_ID").Value
				var Tda_Nombre = rsData.Fields.Item("Alm_Nombre").Value
				var Tda_Calle = rsData.Fields.Item("Calle").Value
				var Tda_NumeroExterior = rsData.Fields.Item("Ext").Value
				var Tda_NumeroInterior = rsData.Fields.Item("Int").Value
				var Tda_Ciudad = rsData.Fields.Item("Ciudad").Value
				var Tda_Estado = rsData.Fields.Item("Estado").Value
				var Tda_Colonia = rsData.Fields.Item("Colonia").Value
				var Tda_CodigoPostal = rsData.Fields.Item("CP").Value
				
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
					
									if(Ejecuta(ISQL, 0)){
										var ISQL1 = " UPDATE TransferenciaAlmacen_Articulos "
											ISQL1 += " SET TAA_CantidadPickiada =  " + TAA_CantidadPickiada + 1
											ISQL1 += " WHERE TA_ID = "+TA_ID
											ISQL1 += " AND TAA_ID = "+TAA_ID
						
										Ejecuta(ISQL1, 0)
									}
									
										
//									var TA_End_Warehouse_ID = BuscaSoloUnDato("TA_End_Warehouse_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)
//										
//									var USQL = " UPDATE Inventario "
//										USQL += " SET Alm_ID = " +TA_End_Warehouse_ID
//										USQL += " WHERE Inv_Serie = '"+TAS_Serie+"'"
//					
//									Ejecuta(USQL, 0)
									
									sResultado = '{"result":1,"message":"Colocado exitosamente","con":"'+TAS_ID+'","TAA_ID":"'+TAA_ID+'","Cantidad":"'+TAA_CantidadPickiada+'"}'
								}else{
									
									
									sResultado = '{"result":-2,"message":"Maximo de productos cargados"}'
								}
									
							}else{
								sResultado = '{"result":-1,"message":"Producto no requerido o limite alcanzado"}'
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
			var TA_FolioRemision = Parametro("TA_FolioRemision","")
			var TA_FolioRuta = Parametro("TA_FolioRuta","")
			var TA_ID = Parametro("TA_ID",-1)
			//var TAF_ID = SiguienteID("TAF_ID","TransferenciaAlmacen_FoliosEKT","TA_ID ="+TA_ID,0)
		
//			var insert = "INSERT INTO TransferenciaAlmacen_FoliosEKT(TA_ID,TAF_ID,TA_FolioRemision,TA_FolioRuta) "
//				insert += " VALUES("+TA_ID+","+TAF_ID+",'"+TA_FolioRemision+"','"+TA_FolioRuta+"')"
//				
//				if(Ejecuta(insert, 0)){
//					sResultado = '{"result":'+TAF_ID+',"message":"Folio colocado"}'
//				}

		sResultado = '{"result":1,"message":"Folio colocado"}'


		break;
		case 8:
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
            <h2><strong>ELEKTRA</strong><br/>
          	<strong>Corte <%=TA_ArchivoID%></strong> <br />
			<strong><%=Parametro("Faltantes","")%> de <%=Parametro("Total","")%></strong></h2>
            <%
		
		break;
		case 9:
			var TA_ID = Parametro("TA_ID",-1) 
			var TAA_ID = Parametro("TAA_ID",-1)
			var Pro_ID = Parametro("Pro_ID",-1)
			var Cantidad = Parametro("Cantidad",-1)
			var Cli_ID = BuscaSoloUnDato("Cli_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)

			var result = -1
			var message = ""
			var Escaneado = 0
			
			
			var Cantidades = "SELECT CAST(SUM(TAA_Cantidad) as int) Solicitados,SUM(TAA_CantidadPickiada) Total "
				Cantidades +=  " FROM TransferenciaAlmacen_Articulos "
				Cantidades +=  " WHERE TAA_ID = "+TAA_ID
				Cantidades += " AND TA_ID = "+ TA_ID
				
			var rsArti = AbreTabla(Cantidades,1,0)
			var Solicitados = 0
			var Procesados = 0
			if(!rsArti.EOF){
				Solicitados = rsArti.Fields.Item("Solicitados").Value
				Procesados = rsArti.Fields.Item("Total").Value
			}
			var confirmado = 0
			var TAS_ID = 0
			if(Solicitados > Procesados){
				message = "La cantidad es igual a = "+Cantidad
				if(Cantidad != 0){
					for(var i = 1;i<=Cantidad;i++){
						
						if(Cli_ID != 2){
						var Serie = "SELECT Top 1 Inv_ID,Inv_Serie"
							Serie += " FROM inventario "
							Serie += " WHERE Pro_ID = "+Pro_ID
							Serie += " AND Inv_EstatusCG20 = 1 "
						}else{
						var Serie = "SELECT Top 1 Inv_ID,Inv_Serie"
							Serie += " FROM inventario "
							Serie += " WHERE Pro_ID = "+Pro_ID
							Serie += " AND Inv_EnTransferencia = 0 "
						}
							
						var rsSerie = AbreTabla(Serie,1,0)
						var TAS_Serie = ""
						var Inv_ID = -1
						
						if(!rsSerie.EOF){
							TAS_Serie = rsSerie.Fields.Item("Inv_Serie").Value
							Inv_ID = rsSerie.Fields.Item("Inv_ID").Value 

							var CantidadArt = "SELECT CAST(SUM(TAA_Cantidad) as int) Solicitados,SUM(TAA_CantidadPickiada) Total "
								CantidadArt += "FROM TransferenciaAlmacen_Articulos "
								CantidadArt += " WHERE TAA_ID = "+TAA_ID
								CantidadArt += " AND TA_ID = "+ TA_ID
								
							var Solicitados = 0
							var Total = 0
							
							var rsCanti = AbreTabla(CantidadArt,1,0)
							if(!rsCanti.EOF){
								Solicitados = rsCanti.Fields.Item("Solicitados").Value
								Total = rsCanti.Fields.Item("Total").Value							
							}   
													
							if(Solicitados > Total){
								var TAS_ID = BuscaSoloUnDato("ISNULL((MAX(TAS_ID)),0)+1","TransferenciaAlmacen_Articulo_Picking","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
								var ISQL = " INSERT INTO TransferenciaAlmacen_Articulo_Picking(TA_ID,TAA_ID,TAS_ID,TAS_Serie,TAS_Usuario,Pro_ID,Inv_ID) "
									ISQL += " VALUES ("+TA_ID+","+TAA_ID+","+TAS_ID+",'"+TAS_Serie+"',"+IDUsuario+","+Pro_ID+","+Inv_ID+")"
								
								if(Ejecuta(ISQL, 0))
								{					
									
//									var ISQL1 = " UPDATE TransferenciaAlmacen_Articulos "
//										ISQL1 += " SET TAA_CantidadPickiada = TAA_CantidadPickiada + 1 "
//										ISQL1 += " WHERE TA_ID = "+TA_ID
//										ISQL1 += " AND TAA_ID = "+TAA_ID
//										
//									Ejecuta(ISQL1, 0)
									result = 1;
									message = "Dato colocado  "+i+" de "+Cantidad
									Escaneado = i;
									confirmado++
//									if(Cli_ID != 2){
//										var USQL = " UPDATE Inventario "
//											USQL += " SET Inv_EstatusCG20 = 14 " 
//											USQL += " WHERE Inv_ID = "+Inv_ID
//											
//										Ejecuta(USQL, 0)
//									}else{
//										var USQL = " UPDATE Inventario "
//											USQL += " SET Inv_EnTransferencia = 1 " 
//											USQL += " WHERE Inv_ID = "+Inv_ID
//											
//										Ejecuta(USQL, 0)
//									}
								}else{
									result = -1	
									message = "Error en el insert "+ISQL
								}
							}
						}else{
							result = -1	
							message = "No hay art&iacute;culos disponibles"
						}
					}
				}else{
					result = -1;
					message = "No se permite la cantidad igual a 0"	
				}
			}else{
				result = -1;
				message = "Limite alcanzado"	
			}
			
			
			
//			
//			
//			var Cantidades = "SELECT CAST(SUM(TAA_Cantidad) as int) Solicitados,SUM(TAA_CantidadPickiada) Total "
//				Cantidades +=  " FROM TransferenciaAlmacen_Articulos "
//				Cantidades +=  " WHERE TAA_ID = "+TAA_ID
//				Cantidades += " AND TA_ID = "+ TA_ID
//				
//				
////			var Solicitados =  BuscaSoloUnDato("SUM(TAA_Cantidad)","TransferenciaAlmacen_Articulos","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
////			var Total =  BuscaSoloUnDato("SUM(TAA_CantidadPickiada)","TransferenciaAlmacen_Articulos","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
//
//			var rsArti = AbreTabla(Cantidades,1,0)
//			if(!rsArti.EOF){
//				var Solicitados = rsArti.Fields.Item("Solicitados").Value
//				var Procesados = rsArti.Fields.Item("Total").Value
//			}
//			var confirmado = 0
//			var TAS_ID = 0 
//			
//			if(Solicitados > Procesados){
//				var FindPRo = "SELECT TAA_ID, TAA_Cantidad, TAA_CantidadPickiada "
//					FindPRo += " FROM TransferenciaAlmacen_Articulos "
//					FindPRo += " WHERE TA_ID = "+TA_ID
//					FindPRo += " AND Pro_ID = "+Pro_ID
//					FindPRo += " AND TAA_CantidadPickiada < TAA_Cantidad"
//					
//				var rsPro = AbreTabla(FindPRo,1,0)
//				if(!rsPro.EOF){
//					var TAA_Cantidad = rsPro.Fields.Item("TAA_Cantidad").Value
//					var TAA_ID = rsPro.Fields.Item("TAA_ID").Value
//
//					var Cantidad = "SELECT CAST(SUM(TAA_Cantidad) as int) Solicitados,SUM(TAA_CantidadPickiada) Total "
//						Cantidad += "FROM TransferenciaAlmacen_Articulos "
//						Cantidad += " WHERE TAA_ID = "+TAA_ID
//						Cantidad += " AND TA_ID = "+ TA_ID
//						
//					var Solicitados = 0
//					
//					var rsCanti = AbreTabla(Cantidad,1,0)
//					if(!rsCanti.EOF){
//						Solicitados = rsCanti.Fields.Item("Solicitados").Value
//					}   
//					
//					for(var i = 1;i<=Cantidad;i++){
//						
//						var Serie = "SELECT Top 1 Inv_ID,Inv_Serie"
//							Serie += " FROM inventario "
//							Serie += " WHERE Pro_ID = "+Pro_ID
//							Serie += " AND Inv_EstatusCG20 = 1 "
//							
//						var rsSerie = AbreTabla(Serie,1,0)
//						var TAS_Serie = ""
//						var Inv_ID = -1
//						
//						if(!rsSerie.EOF){
//							TAS_Serie = rsSerie.Fields.Item("Inv_Serie").Value
//							Inv_ID = rsSerie.Fields.Item("Inv_ID").Value 
//						}
//						 
////						var TAS_Serie = BuscaSoloUnDato("Top 1 Inv_Serie","Inventario","Pro_ID = "+Pro_ID+" AND Inv_EstatusCG20 = 1",-1,0)
////						var Inv_ID = BuscaSoloUnDato("Inv_ID","Inventario","Inv_Serie = '"+TAS_Serie+"'",-1,0)
//						
////						var Solicitados =  BuscaSoloUnDato("SUM(TAA_Cantidad)","TransferenciaAlmacen_Articulos","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
////						var Total =  BuscaSoloUnDato("SUM(TAA_CantidadPickiada)","TransferenciaAlmacen_Articulos","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
//						message = "Solicitado = "+Solicitados+ " Total = "+Total+ " i = "+i
//						if(Solicitados > i){
//							
//							var TAS_ID = BuscaSoloUnDato("ISNULL((MAX(TAS_ID)),0)+1","TransferenciaAlmacen_Articulo_Picking","TAA_ID = "+TAA_ID+" AND TA_ID = "+ TA_ID,-1,0)
//							var ISQL = " INSERT INTO TransferenciaAlmacen_Articulo_Picking(TA_ID,TAA_ID,TAS_ID,TAS_Serie,TAS_Usuario,Pro_ID,Inv_ID) "
//								ISQL += " VALUES ("+TA_ID+","+TAA_ID+","+TAS_ID+",'"+TAS_Serie+"',"+IDUsuario+","+Pro_ID+","+Inv_ID+")"
//							
//							if(Ejecuta(ISQL, 0))
//							{
//								var ISQL1 = " UPDATE TransferenciaAlmacen_Articulos "
//									ISQL1 += " SET TAA_CantidadPickiada = TAA_CantidadPickiada + 1 "
//									ISQL1 += " WHERE TA_ID = "+TA_ID
//									ISQL1 += " AND TAA_ID = "+TAA_ID
//									
//								Ejecuta(ISQL1, 0)
//								confirmado++
//								if(Cli_ID != 2){
//									var USQL = " UPDATE Inventario "
//										USQL += " SET Inv_EstatusCG20 = 14 " 
//										USQL += " WHERE Inv_ID = "+Inv_ID
//										
//										Ejecuta(USQL, 0)
//										result = 1
//								}
//							}else{
//								result = -1	
//								message = "Error en el insert "+ISQL
//							}
//						}else{
//								result = 1	
//								message = "Limite alcanzado, ya no es necesario"
//								break;
//						}
//					}
//				}
//			}else{
//				result = -1	
//				message = "Cantidad maxima de producto"
//			}
			sResultado = '{"result":'+result+',"message":"'+message+'","con":"'+TAS_ID+'","TAA_ID":"'+TAA_ID+'","Escaneados":'+Escaneado+'}'
		break;
		case 10:
			 var TA_ID = Parametro("TA_ID",-1)
			 
			 
			 var Password = Parametro("Batman",-1)
			 
			var IDUsuario =  BuscaSoloUnDato("[dbo].[fn_Usuario_EmpIDUnico](Emp_ID) IDUsuario","Empleado","Emp_ClaveSupervisor = '"+Password+"'",-1,0)
			 
			 if(IDUsuario  > -1){
			 
			 var DocImpresoSQL = "UPDATE TransferenciaAlmacen "
			 	 DocImpresoSQL += " SET TA_DocImpreso = 0 "
			 	 DocImpresoSQL += " , TA_DocImpAutUsuario = " + IDUsuario
			 	 DocImpresoSQL += " WHERE TA_ID = "+TA_ID
				 
				if(Ejecuta(DocImpresoSQL, 0)){
					result = 1	
					message = "Impresión autorizada"
				}else{
					result = -1	
					message = "Error al actualizar la impresion"
				}
			 }else{
				result = -1	
				message = "La contrase&ntilde;a no coincide"
			 }
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
		break;
		case 11:
			 var TA_ID = Parametro("TA_ID",-1)
			 var CantidadCaja = Parametro("CantidadCaja",-1)

			 var CajasSQL = "UPDATE TransferenciaAlmacen "
			 	 CajasSQL += " SET TA_CantidadCaja = "+CantidadCaja
			 	 CajasSQL += " WHERE TA_ID = "+TA_ID
				 
				if(Ejecuta(CajasSQL, 0)){
					result = 1	
					message = "Cajas asignadas"
				}else{
					result = -1	
					message = "Ocurrio un error al colocar las cajas"
				}
			
			
			sResultado = '{"result":'+result+',"message":"'+message+'"}'

		break;
		case 12: //Autorización para sacar parcialidad
			var TA_ID = Parametro("TA_ID",-1)
			var Password = Parametro("Batman",-1)
			
			var IDUsuario =  BuscaSoloUnDato("[dbo].[fn_Usuario_EmpIDUnico](Emp_ID) IDUsuario","Empleado","Emp_ClaveSupervisor = '"+Password+"'",-1,0)
			 
			 if(IDUsuario  > -1){
			 
				 var AutorizaParcial = "UPDATE TransferenciaAlmacen "
					 AutorizaParcial += " SET TA_EnvioParcial = 1 "
					 AutorizaParcial += " ,TA_EnvioParcialFecha = getdate() "
					 AutorizaParcial += " ,TA_EnvioParcialUsuario =  "+IDUsuario
					 AutorizaParcial += " WHERE TA_ID = "+TA_ID
					 
					if(Ejecuta(AutorizaParcial, 0)){
						result = 1	
						message = "Parcialidad autorizada"
					}else{
						result = -1	
						message = "Hubo un error al colocar la parcialidad"
					}
			 }else{
				result = -1	
				message = "La contrase&ntilde;a no autorizada"
			 }
			 
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
		break;
		
		
	}
Response.Write(sResultado)

%>

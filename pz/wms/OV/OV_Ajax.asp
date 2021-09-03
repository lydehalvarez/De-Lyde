<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea = Parametro("Tarea",0)
var Codigo = Parametro("Codigo",0)
var OV_ID = Parametro("OV_ID",0)
var IDUsuario = Parametro("IDUsuario",-1)


var sResultado = ""

switch (parseInt(Tarea)) {
		case 1:	
			try {  
				var sSQLACT = "SELECT  * "
					sSQLACT += " FROM Inventario " 
					sSQLACT += " WHERE Inv_Serie = '" + Codigo+"'"
					
			    var rsACT = AbreTabla(sSQLACT,1,0)
				if (!rsACT.EOF){
					var Estatus  = rsACT.Fields.Item("Inv_EstatusCG20").Value
					var Pro_ID   = rsACT.Fields.Item("Pro_ID").Value
					var Inv_ID = rsACT.Fields.Item("Inv_ID").Value
			    }

				if(Estatus == 1){	
					var sSQLTipoPro = "SELECT TPro_ID "
						sSQLTipoPro += " FROM Producto " 
						sSQLTipoPro += " WHERE Pro_ID =  "+Pro_ID 
						
					var rsTPro = AbreTabla(sSQLTipoPro,1,0)
					if (!rsTPro.EOF){
						var TPro_ID  = rsTPro.Fields.Item("TPro_ID").Value
					}
					
					var sSQLChe = "SELECT  * "
						sSQLChe += " FROM [dbo].[tuf_Picking_ValidacionInventario] ("+OV_ID+","+Pro_ID+","+Inv_ID+") " 
						
					var rsChe = AbreTabla(sSQLChe,1,0)
					if (!rsChe.EOF){
						var Validado  = rsChe.Fields.Item("Validado").Value
						var Mensaje   = rsChe.Fields.Item("Mensaje").Value
						var TotalArticulos = rsChe.Fields.Item("TotalArticulos").Value
						var Faltan = rsChe.Fields.Item("Faltan").Value
						var Completo = rsChe.Fields.Item("Completo").Value
						var OVA_ID = rsChe.Fields.Item("OVA_ID").Value
					}
					if(Validado == 1){
						var sUPD = "UPDATE Orden_Venta_Articulo "
							sUPD += "SET Inv_ID = "+Inv_ID
							sUPD += " WHERE OV_ID = "+OV_ID
							sUPD += " AND Pro_ID = "+Pro_ID
							sUPD += " AND OVA_ID = "+OVA_ID
							sUPD += " AND Inv_ID = -1 "
						
							Ejecuta(sUPD,0)

					}
					
                   sResultado = Validado+"|"+Pro_ID+"|"+Mensaje+"|"+TotalArticulos+"|"+Faltan+"|"+Completo+"|"+TPro_ID
						
				}else{
				   sResultado = "-1|-1|No esta diponible"
				}

				
			} catch(err) {
				sResultado = -1
			}	
		break;
		case 2:
		var SerialNumber = Parametro("SerialNumber","")
		var Esperado = Parametro("Esperado",-1)
		var LimiteArticulos = Parametro("LimiteArticulos",-1)	
		var OVP_Dupla = Parametro("OVP_Dupla",-1)	
		
		if(OVP_Dupla !=-10){
		var Producto = "SELECT (SELECT TPro_ID FROM Producto p WHERE p.Pro_ID = i.Pro_ID) as TPro FROM Inventario i WHERE Inv_Serie = '"+SerialNumber+"'"
		var rsPro = AbreTabla(Producto,1,0)
				if (!rsPro.EOF){
					var TPro_ID  = rsPro.Fields.Item("TPro").Value
					if(Esperado != TPro_ID){
						Esperado = TPro_ID
						

						var OVP_ID = BuscaSoloUnDato("ISNULL(MAX(OVP_ID),0)+1","Orden_Venta_Picking","OV_ID = "+OV_ID,-1,0)
						if(LimiteArticulos > 1){
							if(OVP_Dupla > 0){
								OVP_Dupla = OVP_Dupla
							}else{
								OVP_Dupla = BuscaSoloUnDato("ISNULL(MAX(OVP_Dupla),0)+1","Orden_Venta_Picking","",-1,0)
							}
						}else{
							OVP_Dupla = -1
						}
						var Picked = "INSERT INTO Orden_Venta_Picking(OV_ID, OVP_ID, OVP_Serie, OVP_Dupla, OVP_Usuario)"
							Picked += "VALUES("+OV_ID+","+OVP_ID+",'"+SerialNumber+"',"+OVP_Dupla+","+IDUsuario+")"
						
							Ejecuta(Picked,0)
							
						var LimiteDuplas = BuscaSoloUnDato("COUNT(OVP_ID)","Orden_Venta_Picking","OV_ID = "+OV_ID,-1,0)
						
						
						if(LimiteDuplas == LimiteArticulos){
							OVP_Dupla = -10
						}

						sResultado = '{"result":1,"Esperado":'+Esperado+',"OVP_Dupla":'+OVP_Dupla+'}'
						
						
					}else{
						sResultado = '{"result":-1,"Esperado":'+Esperado+',"LimiteArticulos":'+LimiteArticulos+'}'
					}
				}
		}else{
			sResultado = '{"result":-2,"message":"Limite alcanzado"}'
			
		}
		break;
		case 3:
		
		var sSQLProduc = "SELECT * "
			sSQLProduc += " , (SELECT (SELECT TPro_ID FROM Producto p WHERE p.Pro_ID = i.Pro_ID) as TPro FROM Inventario i WHERE Inv_Serie = OVP_Serie) AS Tipo "
			sSQLProduc += " , (SELECT OV_CORID FROM Orden_Venta_Articulo h WHERE h.OV_ID = "+OV_ID+" AND h.OVA_PART_NUMBER = (SELECT (SELECT Pro_ClaveAlterna FROM Producto p WHERE p.Pro_ID = i.Pro_ID) as TPro FROM Inventario i WHERE Inv_Serie = OVP_Serie)) AS CORID "
			sSQLProduc += " FROM Orden_Venta_Picking k "
			sSQLProduc += " WHERE k.OV_ID = "+OV_ID
		var AñadeComa = 1	
		var rsPro = AbreTabla(sSQLProduc,1,0)
				while(!rsPro.EOF){
					var OVP_Serie  = rsPro.Fields.Item("OVP_Serie").Value
					var CORID  = rsPro.Fields.Item("CORID").Value
					var Tipo  = rsPro.Fields.Item("Tipo").Value
					if(Tipo == 1){
						Tipo = 1	
					}else{
						Tipo = 0	
					}
					
%><%if(AñadeComa>1){Response.Write(",")}%>{
        "serial":"<%=OVP_Serie%>",
        "corId":"<%=CORID%>",
        "type":<%=Tipo%>
    }
                    <%
					
					AñadeComa++
					rsPro.MoveNext()
				}
				rsPro.Close()

		break;
		case 4:
		var IDs = Parametro("IDs","")
		
		try{
			var Cort_ID = BuscaSoloUnDato("ISNULL(MAX(Cort_ID),0)+1","Orden_Venta_Corte","",-1,0)
			
			var CorteInse = "INSERT INTO Orden_Venta_Corte(Cort_ID, Cort_Usuario)"
				CorteInse += "VALUES("+Cort_ID+","+IDUsuario+")"
			
				Ejecuta(CorteInse,0)

			var Lot_ID = BuscaSoloUnDato("ISNULL(MAX(Lot_ID),0)+1","Inventario_Lote","",-1,0)


//			var LoteInsert = "INSERT INTO Inventario_Lote(Lot_ID, Lot_Fecha,Lot_TipoMovimientoCG83)"
//				LoteInsert += "VALUES("+Lot_ID+",getdate(),14)"
			
//			1 Crear nuevo lote Lot_ID
//			2 A cada elemento del inventario colocar el lote creado previamente "Inv_LoteActual"
//			3 y ya se acabó
				
			var CorteUp = "Update Orden_Venta"
				CorteUp += " SET Cort_ID = "+Cort_ID
				CorteUp += " ,OV_BPM_Pro_ID = 4"
				CorteUp += " WHERE OV_ID in ("+IDs+")"
			
				Ejecuta(CorteUp,0)
				
				sResultado = Cort_ID
	
		}catch(err){
			sResultado = -1
		}
		
		break;
		case 5:
		
		try{
		var OVA_ID = Parametro("OVA_ID",-1)
		var OVP_Serie = Parametro("OVP_Serie","")
		var Limite = Parametro("Limite",0)
		var Cli_ID = Parametro("Cli_ID",0)
		var OVP_ID = 0
			var Disponibilidad = BuscaSoloUnDato("Inv_EstatusCG20","Inventario","Inv_Serie = '"+OVP_Serie+"'",-1,0)
			if(Disponibilidad == 1){ 
				var Existencia = BuscaSoloUnDato("OVP_Serie","Orden_Venta_Picking","OVP_Serie = '"+OVP_Serie+"' AND OV_ID = "+OV_ID,-1,0)
				if(Existencia != "" ){
					var ProductoDelCliente = BuscaSoloUnDato("Cli_ID","Inventario","Inv_Serie = '"+OVP_Serie+"' AND Cli_ID = "+Cli_ID,-1,0)
						if(2 == Cli_ID){				
							var OVA_PART_NUMBER = BuscaSoloUnDato("Pro_ClaveAlterna","Producto p, Inventario i","i.Inv_Serie = '"+OVP_Serie+"' AND i.Pro_ID = p.Pro_ID",-1,0)
							var OVA_ID = BuscaSoloUnDato("OVA_ID","Orden_Venta_Articulo","OV_ID="+OV_ID+" AND OVA_PART_NUMBER = '"+OVA_PART_NUMBER+"'",-1,0)
							
							if(OVA_ID != -1){
								OVP_ID = BuscaSoloUnDato("ISNULL(MAX(OVP_ID),0)+1","Orden_Venta_Picking","OV_ID ="+OV_ID+" AND OVA_ID = "+OVA_ID,-1,0)
				
								if(OVP_ID <= Limite){	
									var CorteInse = "INSERT INTO Orden_Venta_Picking(OV_ID, OVA_ID,OVP_ID,OVP_Serie,OVP_Usuario)"
										CorteInse += "VALUES("+OV_ID+","+OVA_ID+","+OVP_ID+",'"+OVP_Serie+"',"+IDUsuario+")"
										
										Ejecuta(CorteInse,0)

//									var InventarioUpdate = "UPDATE Inventario" 
//										InventarioUpdate += " SET Inv_EstatusCG20 = 5"
//										InventarioUpdate += " WHERE Inv_Serie = '"+OVP_Serie+"'"
//										
//										Ejecuta(InventarioUpdate,0)
										
										if(OVA_ID == Limite){
											
	//										var Acc_ID = dbo.fn_Accion_DameSiguienteID(2,1)
	//										INSERT INTO Accion(Acc_Familia, Acc_Tipo, Acc_ID, OV_ID )
	//										Values ( 2, 1, Acc_ID, OV_ID ) 
											
//											var Picking = "UPDATE Orden_Venta"
//												Picking += " SET OV_EstatusCG51 = 2"
//												Picking += " , OV_UsuarioCambioEstatus = "+IDUsuario
//												Picking += " WHERE OV_ID= "+OV_ID
//												
//												Ejecuta(Picking,0)
//												
//												
//											var Packing = "UPDATE Orden_Venta"
//												Packing += " SET OV_EstatusCG51 = 3"
//												Picking += " , OV_UsuarioCambioEstatus = "+IDUsuario
//												Packing += " WHERE OV_ID= "+OV_ID
//												
//												Ejecuta(Packing,0)
		
													
												sResultado =  '{"result":10,"OV_ID":'+OV_ID+',"OVA_ID":'+OVA_ID+',"OVP_ID":'+OVP_ID+',"Background":"bg-success"}'
										}else{
										sResultado =  '{"result":1,"OV_ID":'+OV_ID+',"OVA_ID":'+OVA_ID+',"OVP_ID":'+OVP_ID+'}'
										}
								}else{
									sResultado =  '{"result":-2,"OV_ID":'+OV_ID+',"OVA_ID":'+OVA_ID+',"message":"Limite alcanzado"}'
								}
							}else{
								sResultado =  '{"result":-4,"OV_ID":'+OV_ID+',"OVA_ID":'+OVA_ID+',"message":"El producto no requerido"}'
							}
						}else{
							sResultado =  '{"result":-5,"OV_ID":'+OV_ID+',"OVA_ID":'+OVA_ID+',"message":"Producto aún no disponible para venta"}'
						}
				}else{
					sResultado =  '{"result":-5,"OVA_ID":'+OVA_ID+',"message":"El producto ya escaneado"}'
				}
			}else{
				sResultado =  '{"result":-6,"OVA_ID":'+OVA_ID+',"message":"El producto no esta disponible"}'
			}
		}catch(err){
			sResultado =  '{"result":-1}'
		}
		
		break;
		case 6:
		var OV_Folio = Parametro("OV_Folio","")
		
		
		var InfoFolio = "SELECT * FROM Orden_Venta WHERE OV_Folio = '"+OV_Folio+"'"
		var rsInfo = AbreTabla(InfoFolio,1,0)
		if(!rsInfo.EOF){
			var OV_ID = rsInfo.Fields.Item("OV_ID").Value
			var OV_Folio = rsInfo.Fields.Item("OV_Folio").Value
			var OV_CUSTOMER_NAME = rsInfo.Fields.Item("OV_CUSTOMER_NAME").Value
			var OV_Telefono = rsInfo.Fields.Item("OV_Telefono").Value
			var OV_Email = rsInfo.Fields.Item("OV_Email").Value
			var OV_Calle = rsInfo.Fields.Item("OV_Calle").Value
			var OV_NumeroExterior = rsInfo.Fields.Item("OV_NumeroExterior").Value
			var OV_NumeroInterior = rsInfo.Fields.Item("OV_NumeroInterior").Value
			var OV_Colonia = rsInfo.Fields.Item("OV_Colonia").Value
			var OV_Delegacion = rsInfo.Fields.Item("OV_Delegacion").Value
			var OV_CP = rsInfo.Fields.Item("OV_CP").Value
			var OV_Ciudad = rsInfo.Fields.Item("OV_Ciudad").Value
			var OV_Pais = rsInfo.Fields.Item("OV_Pais").Value
			
			
			var Tacos = "UPDATE Orden_Venta"
				Tacos += " SET OV_EstatusCG51 = 4"
				Tacos += " WHERE OV_ID= "+OV_ID
				
				Ejecuta(Tacos,0)
				
				
				
                    sResultado = '{ "OV_ID":'+OV_ID+',"Folio":"'+OV_Folio+'","Nombre":"'+OV_CUSTOMER_NAME+'","Telefono":"'+OV_Telefono+'","Email":"'+OV_Email+'","Calle":"'+OV_Calle+'","NumeroExt":"'+OV_NumeroExterior+'","NumeroInt":"'+OV_NumeroInterior+'","Colonia":"'+OV_Colonia+'","Municipio":"'+OV_Delegacion+'","CP":"'+OV_CP+'","Estado":"'+OV_Ciudad+'","Pais":"'+OV_Pais+'"}'
		}
		
		break;
		case 7:
		var OV_Folio = Parametro("OV_Folio","")
		var Estatus  = Parametro("Estatus",-1)
		
		
		var InfoFolio = "SELECT * FROM Orden_Venta WHERE OV_Folio = '"+OV_Folio+"'"
		var rsInfo = AbreTabla(InfoFolio,1,0)
		if(!rsInfo.EOF){
			var OV_ID = rsInfo.Fields.Item("OV_ID").Value
			
			var LastStatus =  rsInfo.Fields.Item("OV_EstatusCG51").Value
			
			
			if(Estatus != LastStatus){
				if(Estatus > LastStatus){
				
					var Tacos = "UPDATE Orden_Venta"
						Tacos += " SET OV_EstatusCG51 = "+Estatus
						Tacos += " , OV_UsuarioCambioEstatus = "+IDUsuario
						Tacos += " WHERE OV_ID= "+OV_ID
						
						Ejecuta(Tacos,0)
						
						
					sResultado = OV_ID
					
				}
			}else{
				sResultado = -1
			}
		}
		break;
		case 8:
		var OV_Folio = Parametro("OV_Folio","")
		var GuiaTransportista  = Parametro("GuiaTransportista",-1)
		var Transportista  = Parametro("Transportista",-1)
		
		
		var InfoFolio = "SELECT * FROM Orden_Venta WHERE OV_Folio = '"+OV_Folio+"'"
		var rsInfo = AbreTabla(InfoFolio,1,0)
		if(!rsInfo.EOF){
			var OV_ID = rsInfo.Fields.Item("OV_ID").Value
			
			var Tacos = "UPDATE Orden_Venta"
				Tacos += " SET OV_EstatusCG51 = 5"
				Tacos += " , OV_UsuarioCambioEstatus = "+IDUsuario
				Tacos += ",OV_TRACKING_COM = '"+Transportista+"'"
				Tacos += " , OV_TRACKING_NUMBER = '"+GuiaTransportista+"'"
				Tacos += " WHERE OV_ID = "+OV_ID
				
				Ejecuta(Tacos,0)
			
		}
		break;
		
		case 9:
		var OV_Folio = Parametro("OV_Folio","")
		var GuiaTransportista  = Parametro("GuiaTransportista",-1)
		var Transportista  = Parametro("Transportista",-1)

		var InfoFolio = "SELECT * FROM Orden_Venta WHERE OV_Folio = '"+OV_Folio+"'"
		var rsInfo = AbreTabla(InfoFolio,1,0)
		if(!rsInfo.EOF){
			var OV_ID = rsInfo.Fields.Item("OV_ID").Value
			
			var Tacos = "UPDATE Orden_Venta"
				Tacos += " SET OV_TRACKING_COM = '"+Transportista+"'"
				Tacos += " , OV_TRACKING_NUMBER = '"+GuiaTransportista+"'"
				Tacos += " , OV_UsuarioCambioEstatus = "+IDUsuario
				Tacos += " WHERE OV_ID = "+OV_ID
				
				Ejecuta(Tacos,0)

			sResultado = OV_ID

		}
		break;
		case 10:
		var TA_Folio = Parametro("TA_Folio","")
		
		
		var InfoFolio = "SELECT * FROM TransferenciaAlmacen WHERE TA_Folio = '"+TA_Folio+"'"
		var rsInfo = AbreTabla(InfoFolio,1,0)
		if(!rsInfo.EOF){
			var TA_ID = rsInfo.Fields.Item("TA_ID").Value
			var TA_Folio = rsInfo.Fields.Item("TA_Folio").Value			
			
			sResultado =  '{"TA_ID":'+TA_ID+',"TA_Folio":"'+TA_Folio+'"}'
		
		}
		break;
		case 11:
		var OV_ID = Parametro("OV_ID",-1)
		
		try{
		var DisponibleDeNuevo = "SELECT OVP_Serie FROM Orden_Venta_Picking WHERE OV_ID = "+OV_ID	
		var rsDispo = AbreTabla(DisponibleDeNuevo,1,0)
		
		while(!rsDispo.EOF){
			var OVP_Serie = rsDispo.Fields.Item("OVP_Serie").Value

			var ItemDisponible = "UPDATE Inventario SET Inv_EstatusCG20 = 1 WHERE Inv_Serie = '"+OVP_Serie+"'"
				Ejecuta(ItemDisponible,0)
				
		  rsDispo.MoveNext() 
		}
		rsDispo.Close()	
			
		var BorraPick = "DELETE FROM Orden_Venta_Picking WHERE OV_ID = "+OV_ID
			Ejecuta(BorraPick,0)
			
		var RegresaEstatus = "UPDATE Orden_Venta"
			RegresaEstatus += " SET OV_EstatusCG51 = 1"
			RegresaEstatus += " WHERE OV_ID= "+OV_ID
				
			Ejecuta(RegresaEstatus,0)
			
			sResultado = 1
		}catch(err){
			sResultado = -1
		}
			
		break;
		case 12:
		var TA_Folio = Parametro("TA_Folio",-1)
		var TA_Guia = Parametro("TA_Guia",-1)
		var TA_Transportista = Parametro("TA_Transportista",-1)
		
		try{
		var iSQL = "SELECT * FROM TransferenciaAlmacen WHERE TA_Folio = '"+TA_Folio+"'"
		var rsTRA = AbreTabla(iSQL,1,0)
		if(!rsTRA.EOF){
			var TA_ID = rsTRA.Fields.Item("TA_ID").Value

			var GuiaUpdate = "UPDATE TransferenciaAlmacen "
			    GuiaUpdate += " SET TA_Guia = '"+TA_Guia+"'"
			    GuiaUpdate += " , TA_Transportista = '"+TA_Transportista+"'"
			    GuiaUpdate += " WHERE TA_ID = "+TA_ID

				Ejecuta(GuiaUpdate,0)
				
				sResultado = 1

		}else{
			sResultado = -2
		}

		}catch(err){
			sResultado = -1
		}
			
		break;
		
		case 13:
		var OV_Folio = Parametro("OV_Folio","")
		var Estatus  = Parametro("Estatus",-1)
		
		
		var InfoFolio = "SELECT * FROM Orden_Venta WHERE OV_Folio = '"+OV_Folio+"'"
		var rsInfo = AbreTabla(InfoFolio,1,0)
		if(!rsInfo.EOF){
			var OV_ID = rsInfo.Fields.Item("OV_ID").Value
			
			var LastStatus =  rsInfo.Fields.Item("OV_EstatusCG51").Value
			
			
			
				
					var Tacos = "UPDATE Orden_Venta"
						Tacos += " SET OV_EstatusCG51 = "+Estatus
						Tacos += " , OV_UsuarioCambioEstatus = "+IDUsuario
						Tacos += " WHERE OV_ID= "+OV_ID
						
						Ejecuta(Tacos,0)
						
						
					sResultado = OV_ID
					
			
		}
		break;
		
}
Response.Write(sResultado)
%>
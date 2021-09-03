<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var sResultado = ""
    var Usu_ID = Parametro("Usu_ID",-1) 
    var Man_ID = Parametro("Man_ID",-1) 
    var TA_ID = Parametro("TA_ID",-1) 
    var OV_ID = Parametro("OV_ID",-1) 
	var TA_Folio = Parametro("TA_Folio","") 
	var OV_Folio = Parametro("OV_Folio","") 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var Man_FolioCliente = Parametro("Man_FolioCliente","")
	var Man_Vehiculo = Parametro("Man_Vehiculo","")
    var Man_Placas = Parametro("Man_Placas","")
    var Man_Operador = Parametro("Man_Operador","")
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var Man_Ruta = Parametro("Man_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
	var ProG_NumeroGuia = Parametro("ProG_NumeroGuia","")
	var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")
	var TAC_Codigo = Parametro("TAC_Codigo","") 

    var result = ""
    var message = ""
   
   
	switch (parseInt(Tarea)) {
		case 1:
		
			if(Man_ID != -1){
				if(TA_Folio.slice(0,3) == "TRA"){
				if(TA_Folio != ""){
					
					var TA_ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+TA_Folio+"'",-1,0) 

					if(TA_ID > -1){
												

				var Existe = BuscaSoloUnDato("Man_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0) 
				var Disponible = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Cancelada = 0 AND TA_EstatusCG51 = 4 OR TA_EstatusCG51 = 16 AND TA_ID = "+TA_ID,-1,0) 
				var Cancelada = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen"," TA_EstatusCG51 = 11 AND TA_ID = "+TA_ID,-1,0) 
						if(Cancelada == -1){
							if(Existe == -1){
								var HojaRuta =  BuscaSoloUnDato("ISNULL(TA_FolioRuta,-1)","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0) 
								var Cli_ID = BuscaSoloUnDato("Cli_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0)  
								if((HojaRuta != -1 && Cli_ID == 6) || (HojaRuta == -1 && Cli_ID != 6)){
									if(Disponible > -1){
									//	var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
										//var Man_ID = Man_ID -1
									var sSQLTr = "UPDATE TransferenciaAlmacen SET Man_ID = " + Man_ID
										sSQLTr += " , Man_Usuario= "+Usu_ID
										sSQLTr += " , Man_FechaRegistro = getdate() "
										sSQLTr += " WHERE TA_ID= " + TA_ID		
			
										if(Ejecuta(sSQLTr,0)){
										   result = 1
										   message = "Transferencia a&ntilde;adida al manifiesto"
										} else {
											result = -1
											message = "Error al colocar el dato en la base de datos"
										}
									} else {// respuesta por transferencia repetida
										result = 0
										message = "La transferencia no se encuentra en shipping"
									}
								} else {
									result = -1
									message = "Esta caja no contiene folio de ruta, devolver embarques"
								}
						   } else {//respuesta en caso de no estar disponible
							  var ManFolio = BuscaSoloUnDato("Man_Folio","Manifiesto_Salida"," Man_ID = "+Existe,-1,0)
							  result = -10
							  message = "La transferencia ya fue a&ntilde;adida al manifiesto "+ManFolio+", verifica que no haya cajas duplicadas!"
						   }
						} else {
							result = -10
							message= "Esta transferencia esta cancelada, mandar a logistica inversa."	
						}
					} else {
							result = -1
							message = "Folio no encontrado, intente de nuevo"
					}
				} else {
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
				}
				if(OV_Folio.slice(0,2) == "SO"){
				if(OV_Folio != ""){
					
					var OV_ID = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Folio = '"+OV_Folio+"'",-1,0) 

					if(OV_ID > -1){
												

				var Existe = BuscaSoloUnDato("ManD_ID","Orden_Venta","OV_ID = "+OV_ID,-1,0) 
				var Disponible = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Cancelada = 0 AND OV_EstatusCG51 =5 AND Cli_ID = 2  AND OV_ID = "+OV_ID,-1,0) 
					if( Disponible > -1){
							if(Existe == -1){
							//	var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
								//var Man_ID = Man_ID -1
							var sSQLTr = "UPDATE Orden_Venta SET Man_ID = " + Man_ID
								       + " , Man_Usuario= "+Usu_ID
                                       + " , Man_FechaRegistro = getdate() WHERE OV_ID= " + OV_ID		

								if(Ejecuta(sSQLTr,0)){
								   result = 1
								   message = "SO a&ntilde;adida al manifiesto"
								} else {
									result = -1
									message = "Error al colocar el dato en la base de datos"
								}
								
							} else {// respuesta por transferencia repetida
								result = 0
								message = "La SO ya fue a&ntilde;adida al manifiesto, verifica que no haya cajas duplicadas!"
							}
						
				   } else {//respuesta en caso de no estar disponible
					  result = 0
					  message = "La SO no se encuentra en shipping"
				   }
					} else {
							result = -1
							message = "Folio no encontrado, intente de nuevo"
					}
				} else {
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
				}
			} else {
               // var TA_ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+TA_Folio+"'",-1,0) 
//                var sSQL = "UPDATE TransferenciaAlmacen  "
//                  sSQL += " SET Man_ID = -1, Man_Usuario = -1 " 
//                  sSQL += " ,Man_FechaRegistro = NULL "
//                  sSQL += " WHERE TA_ID = " + TA_ID
//                  sSQL += " AND Man_CargaTransportista = 0 AND Man_ID > 0 and ManD_ID = -1 AND TA_Cancelada = 0 "
//		
//				Ejecuta(sSQL,0)                
                
				result = -1
				message = "No encontramos el borrador del manifiesto, crea uno o si ya tiene comunicarse a sistemas"
                
			}
                  
           Respuesta = '{"result":'+result+',"message":"'+message+'"}'
           Response.Write(Respuesta)

		break;
		case 2:	
			
            var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
				sSQLTr = "INSERT INTO Manifiesto_Salida"
                                + " ( Man_ID, Man_FolioCliente, Man_Operador "
				                + " , Man_Vehiculo, Man_Placas, Prov_ID, Man_TipoDeRutaCG94 "
                                + " , Aer_ID, Man_Ruta, Edo_ID, Man_Usuario)  "
				           + "VALUES(" + Man_ID + ", '" + Man_FolioCliente + "', '" + Man_Operador +"',"
                           + "'" + Man_Vehiculo + "', '" + Man_Placas + "', " + Prov_ID + ", " + Cat_ID 
                           + "," + Aer_ID + ", " + Man_Ruta + ", " + Edo_ID + ", " + Usu_ID + ")"
		
				if(Ejecuta(sSQLTr,0)){
					result = Man_ID
					message = "Transferencia a&ntilde;adida al manifiesto"
				} else {
					result = -1
					message = "Error al colocar el dato en la base de datos" +sSQLTr
				}
                    
                  
			   Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	           Response.Write(Respuesta)
                    
		break; 
		case 3:	
				//Actualizar
			var sSQLTr = "UPDATE Manifiesto_Salida"
				sSQLTr += " SET  Man_FolioCliente= '" + Man_FolioCliente+"'"
				sSQLTr += " ,  Man_Operador = '" + Man_Operador+"'"
				sSQLTr += " ,  Man_Vehiculo = '" + Man_Vehiculo+"'"
				sSQLTr += " ,  Man_Placas = '" + Man_Placas+"'"
				sSQLTr += " ,  Prov_ID = " +Prov_ID
				sSQLTr += " ,  Man_TipoDeRutaCG94 = " +Cat_ID
				sSQLTr += " ,  Aer_ID = " +Aer_ID
				sSQLTr += " ,  Man_Ruta = '" + Man_Ruta+"'"
				sSQLTr += " ,  Edo_ID = " +Edo_ID
				sSQLTr += " ,  Man_Usuario = " +Usu_ID
				sSQLTr += " WHERE Man_ID = " + Man_ID
				         
				if(Ejecuta(sSQLTr,0)){
					result = 1
					message = "Manifiesto actualizado correctamente"
				} else {
					result = -1
					message = "Error al colocar el dato en la base de datos" +sSQLTr
				}
                    
			   Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	           Response.Write(Respuesta)
		break; 
		case 4:	//Borrar
		      var sSQL = "UPDATE TransferenciaAlmacen  "
                  sSQL += " SET Man_ID = -1, Man_Usuario = -1 " 
                  sSQL += " ,Man_FechaRegistro = NULL "
                  sSQL += " WHERE TA_ID = " + TA_ID
					
				if(Ejecuta(sSQL,0)){
					result = TA_ID
					message = "Transferencia eliminada correctamente del manifiesto"
				} else {
					result = -1
					message = "Error al eliminar el dato en la base de datos, intenta de nuevo"
				}
                  
			   Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	           Response.Write(Respuesta)
		break; 
		case 5:	//Carga el combo de Ciudad
		
            var sEventos = "class='form-control combman'" 
            var sCondicion = "Edo_ID = "+ Edo_ID
            CargaCombo("Ciu_ID",sEventos ,"Ciu_Nombre", "Ciu_Nombre", "Cat_Ciudad"
                      , sCondicion,"","Editar",0,"--Seleccionar--")   
%>            
            <script type="text/javascript">
                    $("#Ciu_ID").select2(); 
            </script>
<%     break;
       case 6://Carga el combo de Aeropuerto
	   
                var sEventos = "class='form-control combman'"
                var sCondicion = "Edo_ID = "+ Edo_ID
                CargaCombo( "CboAer_ID", sEventos, "Aer_ID", "Aer_Nombre", "Cat_Aeropuerto"
                          , sCondicion, "", "Editar", 0, "--Seleccionar--")
%>            
            <script type="text/javascript">
                    $("#CboAer_ID").select2(); 
            </script>
<%     break;
       case 7:
			if(Man_ID != -1){
				if(TAC_Codigo != ""){
					
					var TA_ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen_Caja","TAC_Codigo = '"+TAC_Codigo+"'",-1,0) 

					if(TA_ID > -1){
												
				var validada = 0
				var fsalida = 0
				var tacid = 0
				var Existe = BuscaSoloUnDato("Man_ID","TransferenciaAlmacen","TA_ID = "+TA_ID +" AND Man_ID ="+Man_ID,-1,0) 
				var Disponible = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Cancelada = 0 AND Man_ID > -1 AND TA_ID = "+TA_ID,-1,0) 
					if( Disponible > -1){
						var HojaRuta =  BuscaSoloUnDato("ISNULL(TA_FolioRuta,-1)","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0) 
						if(HojaRuta != -1){
							if(Existe > -1){
							//	var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
								//var Man_ID = Man_ID -1
							var sSQLTr = "UPDATE TransferenciaAlmacen SET Man_CargaTransportista = 1"
												+" , Man_CargaUsuario= "+Usu_ID+" , Man_CargaFecha = getdate() WHERE TA_ID= " + TA_ID		
							
								if(Ejecuta(sSQLTr,0)){
								   result = 1
								   message = "Transferencia validada exitosamente"
								   sSQL = "SELECT TAC_ID FROM TransferenciaAlmacen_Caja WHERE TAC_Codigo='"+ TAC_Codigo +"'"
								   var rsCaja = AbreTabla(sSQL, 1,0)
								   
								   if(!rsCaja.EOF){
   								   tacid =  rsCaja.Fields.Item("TAC_ID").Value

								   sSQL = "UPDATE TransferenciaAlmacen_Caja SET TAC_ValidaManifiesto = 1 WHERE TAC_Codigo='"+ TAC_Codigo +"'"
									Ejecuta(sSQL,0)
									sSQL = "SELECT * FROM TransferenciaAlmacen WHERE Man_ID = "+Man_ID +" AND Man_CargaTransportista=0"
								   	var rsValidar = AbreTabla(sSQL, 1,0)
								   
								   		if(!rsValidar.EOF){
										}else{
										var ExisteCaja = BuscaSoloUnDato("TAC_ID","TransferenciaAlmacen_Caja","TA_ID = "+TA_ID +" AND TAC_ValidaManifiesto = 0",-1,0) 
								   
								   if(ExisteCaja==-1){
											validada = 1
											sSQL = "SELECT * FROM TransferenciaAlmacen t INNER JOIN TransferenciaAlmacen_Caja c ON t.TA_ID=c.TA_ID"
											 			+ " WHERE Man_ID = "+Man_ID +" AND TAC_ValidaManifiesto=0"
								   	var rsFolioSalida = AbreTabla(sSQL, 1,0)
										if(!rsFolioSalida.EOF){
										}else{
								   sSQL = "UPDATE Manifiesto_Salida SET Man_UsuValido = "+Usu_ID+",  Man_FolioSalida = 'MANFS-'+'"+Man_ID+"' WHERE Man_ID="+ Man_ID
								   	Ejecuta(sSQL,0)

											fsalida = 1
										}
								   }
										}
								   }else{
									result = -1
									message = "El folio escaneado no existe. Escanea el folio unico de la caja"
								   }
								} else {
									result = -1
									message = "Error al colocar el dato en la base de datos"
								}
								
							} else {// respuesta por transferencia repetida
								result = 0
								message = "La transferencia "+TA_Folio +" no fue agregada en este manifiesto"
							}
						} else {
							result = -1
							message = "Esta caja no contiene folio de ruta, devolver embarques"
						}
				   } else {//respuesta en caso de no estar disponible
					  result = 0
					  message = "La transferencia no tiene manifiesto"
				   }
					} else {
							result = -1
							message = "Folio no encontrado, intente de nuevo"
					}
				} else {
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
			} else {
				result = -1
				message = "No encontramos el borrador del manifiesto, crea uno o si ya tiene comunicarse a sistemas"
			}
       
           Respuesta = '{"result":'+result+',"message":"'+message+'", "taid":'+TA_ID+', "tacid":'+tacid+', "validada":'+validada+', "fsalida":'+fsalida+'}'
           Response.Write(Respuesta)

		break;
		case 8:	//Borrar
		      var sSQL = "UPDATE Orden_Venta  "
                  sSQL += " SET Man_ID = -1, Man_Usuario = -1 " 
                  sSQL += " ,Man_FechaRegistro = NULL "
                  sSQL += " WHERE OV_ID = " + OV_ID
					

			  if(Ejecuta(sSQL,0)){
					result = TA_ID
					message = "SO eliminada correctamente del manifiesto"
				} else {
					result = -1
					message = "Error al eliminar el dato en la base de datos, intenta de nuevo"
				}
                  
			   Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	           Response.Write(Respuesta)
		break; 
		case 9:	//Carga el combo de Proveedor en el modal
		
            var sCondicion = "Prov_Habilitado = 1 and Prov_EsPaqueteria = 1 AND Prov_TipoDeRutaCG94 = " + Cat_ID
            CargaCombo("Prov_ID","class='form-control'","Prov_ID","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"Selecciona")

        break;   
		case 10:	//Carga el combo de Proveedor
		
            var sCondicion = "Prov_Habilitado = 1 and Prov_EsPaqueteria = 1 AND Prov_TipoDeRutaCG94 = " + Cat_ID
            CargaCombo("CboProv_ID","class='form-control combman'","Prov_Nombre","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"Selecciona")
%>            
            <script type="text/javascript">
                    $("#CboProv_ID").select2(); 
            </script>
<%     break;   

       	case 11:	
			var Man_ID = Parametro("Man_ID",-1)
			var data = "null" 
				var sSQL = "SELECT * "
					sSQL += " FROM Manifiesto_Salida"
					sSQL += " WHERE Man_ID = "+Man_ID
					
				var rsMan = AbreTabla(sSQL,1,0)
				
				if(!rsMan.EOF){ 
					result = 1
					message = "Datos encontrados"
					data = '{' 
					data += '"Man_Operador":"'+rsMan.Fields.Item("Man_Operador").Value+'"'
					data += ',"Man_FolioCliente":"'+rsMan.Fields.Item("Man_FolioCliente").Value+'"'
					data += ',"Man_Placas":"'+rsMan.Fields.Item("Man_Placas").Value+'"'
					data += ',"Man_Vehiculo":"'+rsMan.Fields.Item("Man_Vehiculo").Value+'"'
					data += ',"Aer_ID":'+rsMan.Fields.Item("Aer_ID").Value
					data += ',"Man_TipoDeRutaCG94":'+rsMan.Fields.Item("Man_TipoDeRutaCG94").Value
					data += ',"Prov_ID":'+rsMan.Fields.Item("Prov_ID").Value
					data += ',"Edo_ID":'+rsMan.Fields.Item("Edo_ID").Value
					data += ',"Man_Ruta":'+rsMan.Fields.Item("Man_Ruta").Value
					data += '}'
				}else{
					result = -1
					message = "No hay datos para el manifiesto"
				}
				
			sResultado = '{"result":'+result+',"message":"'+message+'","data":'+data+'}'
			Response.Write(sResultado)
        break; 
          
		  case 12:
		              var ProG_ID = SiguienteID("ProG_ID","Proveedor_Guia","",0)

		  	var sSQL = " INSERT INTO Proveedor_Guia(ProG_ID, Prov_ID, ProG_FechaAsignaGuia, ProG_NumeroGuia, Man_ID, ProG_UsuarioAsigno) "
							+ " VALUES("+ProG_ID+", "+Prov_ID+", getdate(), '"+ProG_NumeroGuia+"', "+Man_ID+", "+Usu_ID+")"	
						//	Response.Write(sSQL)
		  	 	 if(Ejecuta(sSQL,0)){
					result = 1
					message = "Datos agregados correctamente al manifiesto"
				} else {
					result = -1
					message = "Error al insertar datos, intenta de nuevo y comunicate a sistemas de ser necesario"
				}
			sResultado = '{"result":'+result+',"message":"'+message+'","manid":'+Man_ID+'}'
			Response.Write(sResultado)
		  break;
		  case 13:
		  	  sSQL = "SELECT * FROM Proveedor_Guia g"
  			+" INNER JOIN Proveedor p ON g.Prov_ID=p.Prov_ID WHERE Man_ID =" + Man_ID
  		 var rsGuia = AbreTabla(sSQL,1,0)

		  %>
                <a href="#">Transportista Guia</a>
            
            <% if(!rsGuia.EOF){
				%>
            <%=rsGuia.Fields.Item("Prov_Nombre").Value%>
            <br />
            Guias:
            <%
			   while (!rsGuia.EOF){
				   %>
                   <%=rsGuia.Fields.Item("ProG_NumeroGuia").Value%>
 				<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <%
				   rsGuia.MoveNext() 
            }
        rsGuia.Close()    
			 }
			%>
          <%
		  break;
    }
 

%>

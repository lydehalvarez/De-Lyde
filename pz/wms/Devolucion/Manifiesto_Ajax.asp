<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var sResultado = ""
    var Usu_ID = Parametro("Usu_ID",-1) 
    var ManD_ID = Parametro("ManD_ID",-1) 
    var TA_ID = Parametro("TA_ID",-1) 
	var TA_Folio = Parametro("TA_Folio","") 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var ManD_FolioCliente = Parametro("ManD_FolioCliente","")
	var ManD_Vehiculo = Parametro("ManD_Vehiculo","")
    var ManD_Placas = Parametro("ManD_Placas","")
    var ManD_Operador = Parametro("ManD_Operador","")
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var ManD_Ruta = Parametro("ManD_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
	var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")
	var OV_Folio = Parametro("OV_Folio","") 
    var result = ""
    var message = ""
	var Cli_ID = 0
	var Man_ID = 0
	var TA_Cancelada = 0
	var TA_EstatusCG51 = 0
	var Man_CargaTransportista = 0 
    var HojaRuta = ""
    var bProcesa = true

   TA_Folio = TA_Folio.replace("'", "-")            //  cambio apostrofes por guiones
   TA_Folio = TA_Folio.replace(/^\s+|\s+$/g,"");   //   trim
   OV_Folio = OV_Folio.replace("'", "-")            //  cambio apostrofes por guiones
   OV_Folio = OV_Folio.replace(/^\s+|\s+$/g,"");   //   trim
   
	switch (parseInt(Tarea)) {
		case 1:
			if(ManD_ID != -1){
              if(TA_Folio != ""){  
			    if(TA_Folio.slice(0,3) == "TRA"){
				   
                       var sSQL = "SELECT TA_ID, ManD_ID, TA_Cancelada, TA_EstatusCG51, Man_CargaTransportista, Cli_ID, Man_ID "
                                + " FROM TransferenciaAlmacen "
                                + " WHERE TA_Folio = '" + TA_Folio + "'"
                        
                       var rsTra = AbreTabla(sSQL,1,0)
                       if (!rsTra.EOF){
                           Cli_ID = rsTra.Fields.Item("Cli_ID").Value
                           TA_ID = rsTra.Fields.Item("TA_ID").Value
                           Man_ID = rsTra.Fields.Item("Man_ID").Value
                           iManD_ID = rsTra.Fields.Item("ManD_ID").Value
                           TA_Cancelada = rsTra.Fields.Item("TA_Cancelada").Value
                           TA_EstatusCG51 = rsTra.Fields.Item("TA_EstatusCG51").Value
                           Man_CargaTransportista = rsTra.Fields.Item("Man_CargaTransportista").Value 
                           HojaRuta = BuscaSoloUnDato("ISNULL(TA_FolioRuta,-1)","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0)
                       } else {
                           Cli_ID = -1
                           TA_ID = -1
                           iManD_ID = -1
                           Man_ID = -1
                           TA_Cancelada = 0
                           TA_EstatusCG51 = 0
                           Man_CargaTransportista = 0
                           result = -1
                           message = "No se encontro la transferencia " + TA_Folio
                           bProcesa = false
                       }
                       rsTra.Close()
                            
                           
                      //valido que este en alguna salida, porque para devolver debio de haber salido primero, si no es que nunca ha salido       
                      if(bProcesa && Man_ID == -1 && iManD_ID == -1){
                          result = -1
                          message = "La transferencia " + TA_Folio + " no ha estado en alguna salida, no puede ser devuelta, usa el proceso de cancelaci&oacute;n "
                          bProcesa = false
                      }   
                      //valido que no este ya en otra devolucion 
                      if(bProcesa && iManD_ID > -1){
                          result = -1
                          var FoloDevolucion = BuscaSoloUnDato("ManD_Folio","Manifiesto_Devolucion","ManD_ID = "+iManD_ID,-1,0) 
                          message = "La transferencia ya esta ingresada en la devoluci&oacute;n con folio " + FoloDevolucion
                          message += ", verifica que no haya cajas duplicadas!"
                          bProcesa = false
                      }
                          
                      if(bProcesa && Cli_ID == 6 && HojaRuta == -1 && Man_ID > -1 && iManD_ID == -1){ 
                          result = -1
						  message = "Esta caja no contiene folio de ruta, devolver embarques"
                          bProcesa = false
                      }
                        
                      //valida que no este en un Msalida y que no haya sido embarcado
                      //se usara para liberar un Tra que este en un MSalida cerrado    
                      if(bProcesa && Man_CargaTransportista == 0 && Man_ID > -1 && iManD_ID == -1){ 
                          result = 1
                          var FoloDevolucion = BuscaSoloUnDato("Man_Folio","Manifiesto_Salida","Man_ID = "+Man_ID,-1,0) 
                          message = "La transferencia con folio " + TA_Folio + " esta en el manifiesto de salida " + FoloDevolucion + " y esta en espera de salir"
       //                   message = "La transferencia con folio " + TA_Folio + " esta en el manifiesto de salida " + FoloDevolucion + " y no ha salido, se liberara de esa orden de salida"
                          bProcesa = false
                          
                     //     var sSQL = "UPDATE TransferenciaAlmacen "
//                              sSQL += " SET ManD_ID = -1, ManD_Usuario = -1, ManD_FechaRegistro = NULL "
//                              sSQL += " , Man_ID = -1, Man_Usuario = -1, Man_FechaRegistro = NULL " 
//                              sSQL += " , TA_EstatusCG51 = 4 "
//                              sSQL += " WHERE TA_ID = " + TA_ID
//
//                           Ejecuta(sSQL,0)  
                          
                      }
                        
                      if(bProcesa && Man_CargaTransportista == 1 && Man_ID > -1 && iManD_ID == -1){
                          result = 1
                          bProcesa = false
                          var sSQLTr  = "UPDATE TransferenciaAlmacen "
                              sSQLTr += " SET TA_EstatusCG51 = 16 "
                              sSQLTr += " , ManD_ID = " + ManD_ID
							  sSQLTr += " , ManD_Usuario= " + Usu_ID
                              sSQLTr += " , ManD_FechaRegistro = getdate() "
                              sSQLTr += " WHERE TA_ID = " + TA_ID		

                           if(Ejecuta(sSQLTr,0)){
                               result = 1
                               message = "Transferencia a&ntilde;adida al manifiesto"
                           } else {
                                result = -1
                                message = "Error al colocar el dato en la base de datos"
                           }
                          
                      }  
    
                }
				} else {
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
					
				if(OV_Folio.slice(0,2) == "SO"){
				if(OV_Folio != ""){
					
					var OV_ID = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Folio = '"+OV_Folio+"'",-1,0) 

					if(OV_ID > -1){
												

				var Existe = BuscaSoloUnDato("ManD_ID","Orden_Venta","OV_ID = "+OV_ID,-1,0) 
				var Disponible = BuscaSoloUnDato("OV_ID","Orden_Venta","OV_Cancelada = 0 AND OV_EstatusCG51 >= 5  AND OV_ID = "+OV_ID,-1,0) 
					if( Disponible > -1){
							if(Existe == -1){
							//	var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
								//var Man_ID = Man_ID -1
							var sSQLTr = "UPDATE Orden_Venta "
                                       + " SET  OV_EstatusCG51 = 16 "
                                       + ", ManD_ID = " + ManD_ID
								       + " , ManD_Usuario= "+Usu_ID
                                       + " , ManD_FechaRegistro = getdate() "
                                       + " WHERE OV_ID= " + OV_ID		

								if(Ejecuta(sSQLTr,0)){
								   result = 1
								   message = "SO a&ntilde;adida al manifiesto"
								}else {
									result = -1
									message = "Error al colocar el dato en la base de datos"
								}
								
							}else{// respuesta por transferencia repetida
								result = 0
								message = "La SO ya fue a&ntilde;adida al manifiesto, verifica que no haya cajas duplicadas!"
							}
						
				   }else{//respuesta en caso de no estar disponible
					  result = 0
					  message = "La SO no se encuentra en transito"
				   }
					}else{
							result = -1
							message = "Folio no encontrado, intente de nuevo"
					}
				}else{
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
				}
			}else{ 
                var TA_ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+TA_Folio+"'",-1,0) 
                var sSQL = "UPDATE TransferenciaAlmacen  "
                  sSQL += " SET Man_ID = -1, Man_Usuario = -1 " 
                  sSQL += " ,Man_FechaRegistro = NULL "
                  sSQL += " WHERE TA_ID = " + TA_ID
                  sSQL += " AND Man_CargaTransportista = 0 AND Man_ID > 0 and ManD_ID = -1 AND TA_Cancelada = 0 "
		
				Ejecuta(sSQL,0) 
				result = -1
				message = "No encontramos el borrador del manifiesto, crea uno o si ya tiene comunicarse a sistemas"
			}
                  
           Respuesta = '{"result":'+result+',"message":"'+message+'"}'
           Response.Write(Respuesta)

		break;
		case 2:	
			
            var ManD_ID = SiguienteID("ManD_ID","Manifiesto_Devolucion","",0)
				sSQLTr = "INSERT INTO Manifiesto_Devolucion"
                                + " ( ManD_ID, ManD_FolioCliente, ManD_Operador "
				                + " , ManD_Vehiculo, ManD_Placas, Prov_ID, ManD_TipoDeRutaCG94 "
                                + " , Aer_ID, ManD_Ruta, Edo_ID, ManD_Usuario)  "
				           + "VALUES(" + ManD_ID + ", '" + ManD_FolioCliente + "', '" + ManD_Operador +"',"
                           + "'" + ManD_Vehiculo + "', '" + ManD_Placas + "', " + Prov_ID + ", " + Cat_ID 
                           + "," + Aer_ID + ", " + ManD_Ruta + ", " + Edo_ID + ", " + Usu_ID + ")"
		
				if(Ejecuta(sSQLTr,0)){
					result = ManD_ID
					message = "Transferencia a&ntilde;adida al manifiesto"
				}else{
					result = -1
					message = "Error al colocar el dato en la base de datos" +sSQLTr
				}
                    
                  
			   Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	           Response.Write(Respuesta)
                    
		break; 
		case 3:	
				//Actualizar
			var sSQLTr = "UPDATE Manifiesto_Devolucion"
				sSQLTr += " SET  ManD_FolioCliente= '" + ManD_FolioCliente+"'"
				sSQLTr += " ,  ManD_Operador = '" + ManD_Operador+"'"
				sSQLTr += " ,  ManD_Vehiculo = '" + ManD_Vehiculo+"'"
				sSQLTr += " ,  ManD_Placas = '" + ManD_Placas+"'"
				sSQLTr += " ,  Prov_ID = " +Prov_ID
				sSQLTr += " ,  ManD_TipoDeRutaCG94 = " +ManD_TipoDeRutaCG94
				sSQLTr += " ,  Aer_ID = " +Aer_ID
				sSQLTr += " ,  ManD_Ruta = '" + ManD_Ruta+"'"
				sSQLTr += " ,  Edo_ID = " +Edo_ID
				sSQLTr += " ,  ManD_Usuario = " +Usu_ID
				sSQLTr += " WHERE ManD_ID = " + ManD_ID
				         
				if(Ejecuta(sSQLTr,0)){
					result = 1
					message = "Manifiesto actualizado correctamente"
				}else{
					result = -1
					message = "Error al colocar el dato en la base de datos" +sSQLTr
				}
                    
			   Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	           Response.Write(Respuesta)
		break; 
		case 4:	//Borrar
		      var sSQL = "UPDATE TransferenciaAlmacen  "
                  sSQL += " SET ManD_ID = -1, ManD_Usuario = -1 " 
                  sSQL += " ,ManD_FechaRegistro = NULL "
                  sSQL += " WHERE TA_ID = " + TA_ID
					
      
			  if(Ejecuta(sSQL,0)){
					result = TA_ID
					message = "Transferencia eliminada correctamente del manifiesto"
				}else{
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
case 7:	//Actualizar estatus

        if (ManD_ID > -1){
//             var sSQLTr = "UPDATE Manifiesto_Devolucion"
//                 sSQLTr += " SET  ManD_Borrador = 0 "
//                 sSQLTr += " WHERE ManD_ID = " + ManD_ID
//
//             Ejecuta(sSQLTr,0)
//
//             var sSQL  = " UPDATE TransferenciaAlmacen SET TA_EstatusCG51 = 5 "
//                 sSQL += " WHERE  ManD_ID = " + ManD_ID
//
//             Ejecuta(sSQL,0)
			 result = 1
			 message = "Esta accion mueve todo el manifiesto a devueltos" 
        }else{
			 result = -1
			 message = "No se encontr&oacute; el manifiesto de devoluci&oacute;n" 
		}
		
        Respuesta = '{"result":'+result+',"message":"'+message+'"}'
        Response.Write(Respuesta)
		break; 
    }
 

%>

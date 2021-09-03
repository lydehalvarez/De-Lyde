<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var sResultado = ""
    var Usu_ID = Parametro("Usu_ID",-1) 
    var Man_ID = Parametro("Man_ID",-1) 
    var TA_ID = Parametro("TA_ID",-1) 
	var TA_Folio = Parametro("TA_Folio","") 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var Man_FolioCliente = Parametro("Man_FolioCliente","")
	var Man_Vehiculo = Parametro("Man_Vehiculo","")
    var Man_Placas = Parametro("Man_Placas","")
    var Man_Operador = Parametro("Man_Operador","")
    var Man_TipoDeRuta = Parametro("Man_TipoDeRuta",-1)
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var Man_Ruta = Parametro("Man_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
	var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")

    var result = ""
    var message = ""
   
	switch (parseInt(Tarea)) {
		case 1:
			if(Man_ID != -1){
				if(TA_Folio != ""){
					
					var TA_ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+TA_Folio+"'",-1,0) 

					if(TA_ID > -1){
												

				var Existe = BuscaSoloUnDato("Man_ID","TransferenciaAlmacen","TA_ID = "+TA_ID,-1,0) 
				var Disponible = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Cancelada = 0 AND TA_EstatusCG51 = 4 AND TA_ID = "+TA_ID,-1,0) 
					if( Disponible > -1){
						var HojaRuta =  BuscaSoloUnDato("ISNULL(TA_FolioRuta,-1)","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0) 
						if(HojaRuta != -1){
							if(Existe == -1 || Existe == 1){
							//	var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
								//var Man_ID = Man_ID -1
							var sSQLTr = "UPDATE TransferenciaAlmacen "
                                       + " SET Man_ID = " + Man_ID
									   + " , Man_Usuario= "+Usu_ID
                                       + " , Man_FechaRegistro = getdate() "
                                       + " WHERE TA_ID= " + TA_ID		
	
								if(Ejecuta(sSQLTr,0)){
								   result = 1
								   message = "Transferencia a&ntilde;adida al manifiesto"
								}else {
									result = -1
									message = "Error al colocar el dato en la base de datos"
								}
								
							}else{// respuesta por transferencia repetida
								result = 0
								message = "La transferencia ya fue a&ntilde;adida al manifiesto, verifica que no haya cajas duplicadas!"
							}
						}else{
							result = -1
							message = "Esta caja no contiene folio de ruta, devolver embarques"
						}
				   }else{//respuesta en caso de no estar disponible
					  result = 0
					  message = "La transferencia no se encuentra en shipping"
				   }
					}else{
							result = -1
							message = "Folio no encontrado, intente de nuevo"
					}
				}else{
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
			}else{
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
				}else{
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
				}else{
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
					
            Response.Write(sSQL)
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
case 7:
			if(Man_ID != -1){
				if(TA_Folio != ""){
					
					var TA_ID = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Folio = '"+TA_Folio+"'",-1,0) 

					if(TA_ID > -1){
												

				var Existe = BuscaSoloUnDato("Man_ID","TransferenciaAlmacen","TA_ID = "+TA_ID +" AND Man_ID ="+Man_ID,-1,0) 
				var Disponible = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Cancelada = 0 AND TA_EstatusCG51 = 5 AND TA_ID = "+TA_ID,-1,0) 
					if( Disponible > -1){
						var HojaRuta =  BuscaSoloUnDato("ISNULL(TA_FolioRuta,-1)","TransferenciaAlmacen_FoliosEKT","TA_ID = "+TA_ID,-1,0) 
						if(HojaRuta != -1){
							if(Existe > -1){
							//	var Man_ID = SiguienteID("Man_ID","Manifiesto_Salida","",0)
								//var Man_ID = Man_ID -1
							var sSQLTr = "UPDATE TransferenciaAlmacen "
                                       + " SET Man_CargaTransportista = 1"
                                       + ", TA_EstatusCG51 = 5 "
								       + ", Man_CargaUsuario= "+Usu_ID
                                       + ", Man_CargaFecha = getdate() "
                                       + " WHERE TA_ID= " + TA_ID		
							
								if(Ejecuta(sSQLTr,0)){
								   result = 1
								   message = "Transferencia a&ntilde;adida al manifiesto"
								}else {
									result = -1
									message = "Error al colocar el dato en la base de datos"
								}
								
							}else{// respuesta por transferencia repetida
								result = 0
								message = "La transferencia "+TA_Folio +" no fue a&ntilde;adida al manifiesto"
							}
						}else{
							result = -1
							message = "Esta caja no contiene folio de ruta, devolver embarques"
						}
				   }else{//respuesta en caso de no estar disponible
					  result = 0
					  message = "La transferencia no ha pasado a transito o no se encuentra en el manifiesto"
				   }
					}else{
							result = -1
							message = "Folio no encontrado, intente de nuevo"
					}
				}else{
					result = -1
					message = "No se aceptan vacios, intente de nuevo"
				}
			}else{
				result = -1
				message = "No encontramos el borrador del manifiesto, crea uno o si ya tiene comunicarse a sistemas"
			}
       
           Respuesta = '{"result":'+result+',"message":"'+message+'"}'
           Response.Write(Respuesta)

		break;
    }
 

%>

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var Tarea = Parametro("Tarea",-1)
    var InsO_ID = Parametro("InsO_ID",-1)
	var ID_Unico = Parametro("ID_Unico",-1)
	var InsO_ID = Parametro("InsO_ID",-1)
	var Ins_ID = Parametro("Ins_ID",-1)
    var Chkdo = Parametro("Chkdo",0)
	var InsCm_Observacion = utf8_decode(Parametro("InsCm_Observacion",""))
	var sResultado = ""
    var InsT_Padre = Parametro("InsT_Padre",0)
	var InsT_Nombre = decodeURIComponent(Parametro("InsT_Nombre",""))
	var InsT_Descripcion = Parametro("InsT_Descripcion","")
	var InsT_PrioridadCG33 = Parametro("InsT_PrioridadCG33",1)
	var InsT_SeveridadCG32 = Parametro("InsT_SeveridadCG32",1)
	var InsT_EstrellasCG33 = Parametro("InsT_EstrellasCG33",0)
	var InsT_PrioridadABC = Parametro("InsT_PrioridadABC",1)
	var InsT_Orden = Parametro("InsT_Orden",1)
    var InsT_MoScoWCG24 = Parametro("InsT_MoScoWCG24",4)
	var InsT_TallaCG25 = Parametro("InsT_TallaCG25",0)
	var InsT_SLAAtencion = Parametro("InsT_SLAAtencion",-1)
	var InsT_SLAResolucion = Parametro("InsT_SLAResolucion",-1)
    var InsT_Problema_For_ID = Parametro("InsT_Problema_For_ID",-1)
    var InsT_Comentarios_For_ID = Parametro("InsT_Comentarios_For_ID",-1)
	var InsT_TipoCG28 = Parametro("InsT_TipoCG28",4)
	var InsT_TipoMedicionCG29 = Parametro("InsT_TipoMedicionCG29",-1)
	var Ins_Titulo = decodeURIComponent(Parametro("Ins_Titulo",""))
	var Ins_Asunto = decodeURIComponent(Parametro("Ins_Asunto",""))
	var Ins_Descripcion = decodeURIComponent(Parametro("Ins_Descripcion",""))
	var Ins_Problema = decodeURIComponent(Parametro("Ins_Problema",""))
	var Ins_Causa = decodeURIComponent(Parametro("Ins_Causa",""))
	var Ins_Ventana = decodeURIComponent(Parametro("Ins_Ventana",""))
	var Ins_Accion = decodeURIComponent(Parametro("Ins_Accion",""))
	var Ins_MensajeError = decodeURIComponent(Parametro("Ins_MensajeError",""))
    var TA_ID = Parametro("TA_ID",-1)
    var TA_Folio = Parametro("TA_Folio","")
    var OC_ID = Parametro("OC_ID",-1)
    var OV_ID = Parametro("OV_ID",-1)
    var OV_Folio = Parametro("OV_Folio","")
    var Cli_ID = Parametro("Cli_ID",-1)
    var CCgo_ID = Parametro("CCgo_ID",-1)
    var Prov_ID = Parametro("Prov_ID",-1)
    var Pt_ID = Parametro("Pt_ID",-1)
    var Pt_ID = Parametro("Pt_ID",-1)
	var Tag_ID = Parametro("Tag_ID",-1)
    var Man_ID = Parametro("Man_ID",-1)
    var ManD_ID = Parametro("ManD_ID",-1)
    var Inv_ID = Parametro("Inv_ID",-1)
    var Pro_ID = Parametro("Pro_ID",-1)
    var ProC_ID = Parametro("ProC_ID",-1)
    var Lot_ID = Parametro("Lot_ID",-1)
    var Alm_ID = Parametro("Alm_ID",-1)
    var For_ID = Parametro("For_ID",-1)
	var Alm_Numero = Parametro("Alm_Numero","")
	var Ins_Usu_Reporta = Parametro("Ins_Usu_Reporta",-1)
    var Ins_Usu_Recibe = Parametro("Ins_Usu_Recibe",-1)
    var Ins_Tarea_FechaAtendida = Parametro("Ins_Tarea_FechaAtendida","")
    var Ins_Tarea_FechaLIberada = Parametro("Ins_Tarea_FechaLIberada","")
    var Ins_FechaInicio_Tarea = Parametro("Ins_FechaInicio_Tarea","")
    var Ins_FechaEntrega_Tarea = Parametro("Ins_FechaEntrega_Tarea","")
    var Ins_Usu_Escalado = Parametro("Ins_Usu_Escalado",-1)
    var Ins_EstatusCG27 = Parametro("Estatus",2)
    var InsT_ID = Parametro("InsT_ID",-1)
    var InsCm_ID = Parametro("InsCm_ID",-1)
    var InsCm_Padre = Parametro("InsCm_Padre",0)
    var InsT_ID = Parametro("InsT_ID",-1)
    var Ins_Prioridad = Parametro("Ins_Prioridad",-1)
    var Ins_Severidad = Parametro("Ins_Severidad",-1)
    var Tag_Nombre = Parametro("Tag_Nombre","")
    var Tag_Descripcion = Parametro("Tag_Descripcion","")
    var Tag_Origen = Parametro("Tag_Origen",-1)
    var Tag_Publica = Parametro("Tag_Publica",-1)
    var IDUsuario = Parametro("Usuario", -1)  
	var Asignado = Parametro("Asignado", -1)  
	var Ins_GrupoID = Parametro("Ins_GrupoID", -1)
	var Ins_TipoInvolucradoCG26 = Parametro("Ins_TipoInvolucradoCG26", -1)
	var T_Involucrado = Parametro("T_Involucrado", -1)
	var Involucrado = Parametro("Involucrado", -1)
	var Subtarea = Parametro("Subtarea",-1)
    var Ins_Padre = Parametro("Ins_ID",0)
    var Shipping = Parametro("Shipping","")
	var SKUSob = Parametro("SKUSob",-1)
    var SKU1 = Parametro("SKU1","")
    var SKU2 = Parametro("SKU2","")
    var SKU3 = Parametro("SKU3","")
    var SKU4 = Parametro("SKU4","")
    var SKU5 = Parametro("SKU5","")
	var SKUCambiado = Parametro("SKUCambiado",-1)
	var ChkSKU = Parametro("ChkSKU",-1)
    var FechaAviso = Parametro("FechaAviso","")
    var Serie = Parametro("Serie","")
    var Inv_ID = Parametro("Inv_ID","")
	var TdaOrig = Parametro("TdaOrig",-1)
	var TdaDest = Parametro("TdaDest",-1)
	var FechaRecIni = Parametro("FechaRecIni",-1)
	var FechaRecFin = Parametro("FechaRecFin",-1)
	var Auditor = Parametro("Auditor",-1)
	var result = 0
	
	switch (parseInt(Tarea)) {
         case 1:
            try {	

                var sSQL = "DELETE FROM Incidencia_Usuario "
                    sSQL += " WHERE InsO_ID = " + InsO_ID 
                    sSQL += " and ID_Unico = " + ID_Unico

                Ejecuta(sSQL,0)		

                sResultado = "OK"		
            } catch(err) {
                sResultado = "falla"	
            }

            sResultado = "OK"               
            
            if(Chkdo == 1){
                try {	

                    var sSQL = "INSERT INTO Incidencia_Usuario(InsO_ID, InU_IDUnico) " 
                        sSQL += " VALUES (" + InsO_ID + "," + ID_Unico + ")"					

                    Ejecuta(sSQL,0)		

                    sResultado = "OK"		
                } catch(err) {
                    sResultado = "falla"	
                }                
            }

         break;

		case 2:
		         var sSQL = "INSERT INTO Incidencia_Comentario(Ins_ID, InsCm_Padre,"
				 	if(Asignado > -1){
					  sSQL += "InsCm_AsignadoA,"
					}
				  	  sSQL += " InsCm_Observacion, InsCm_Autor_IDU) " 
                      sSQL += " VALUES (" + Ins_ID + "," + InsCm_Padre 
						if(Asignado > -1){
						 sSQL += "," + Asignado
						}
						sSQL += ", '"+InsCm_Observacion +"', " + IDUsuario +")"					
					
                    Ejecuta(sSQL,0)		
					
					
					if(Asignado > -1){
						var sSQL = "UPDATE Incidencia SET Ins_EstatusCG27=3, Ins_Usu_Escalado = "+Asignado
								+ " WHERE Ins_ID="+Ins_ID
	
                    	Ejecuta(sSQL,0)		
					}
		break;
		
				case 3:
				            var InsT_ID = SiguienteID("InsT_ID","Incidencia_Tipo","",0)

		         var sSQL = " INSERT INTO Incidencia_Tipo(InsT_Padre, InsT_ID, InsT_Nombre, InsT_Descripcion, InsT_PrioridadCG33, InsT_SeveridadCG32, InsT_EstrellasCG33, "						
				 				+ " InsT_PrioridadABC, InsT_Orden, InsT_MoScoWCG24, InsT_TallaCG25, InsT_SLAAtencion, "
                         		+ " InsT_SLAResolucion, InsT_Problema_For_ID, InsT_Comentarios_For_ID, InsT_TipoCG28, InsT_TipoMedicionCG29) " 
                        		+ " VALUES (" + InsT_Padre + "," + InsT_ID + ",'" + InsT_Nombre + "','" + InsT_Descripcion + "'," + InsT_PrioridadCG33 + "," + InsT_SeveridadCG32 
								+ "," + InsT_EstrellasCG33 + "," + InsT_PrioridadABC + ","+ "" + InsT_Orden + "," + InsT_MoScoWCG24 + "," + InsT_TallaCG25 + "," + InsT_SLAAtencion
							    + "," + InsT_SLAResolucion + "," + InsT_Problema_For_ID + "," + InsT_Comentarios_For_ID + "," + InsT_TipoCG28 + "," + InsT_TipoMedicionCG29 +")"					
				
                    Ejecuta(sSQL,0)		
			
		break;
	
		case 4:
		
				
				if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
            	}
				
				if(OV_Folio !=""){
				sSQL = "SELECT OV_ID FROM Orden_Venta WHERE OV_Folio = '" + OV_Folio + "'"	
				var rsOV = AbreTabla(sSQL,1,0)
					if(!rsOV.EOF){
						OV_ID = rsOV.Fields.Item("OV_ID").Value
					}else{
					sResultado = 0
					}
            	}
				if((OV_ID>-1||TA_ID>-1)||(OV_Folio =="" && TA_Folio =="")){
							
				            var Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)
								
							if(Ins_FechaInicio_Tarea != "" && Ins_FechaEntrega_Tarea != ""){
							Ins_FechaInicio_Tarea=CambiaFormatoFecha(Ins_FechaInicio_Tarea,"dd/mm/yyyy","yyyy-mm-dd")
							Ins_FechaEntrega_Tarea=CambiaFormatoFecha(Ins_FechaEntrega_Tarea,"dd/mm/yyyy","yyyy-mm-dd")
							}
		         var sSQL = " INSERT INTO Incidencia (Ins_ID, Ins_Padre, Ins_Titulo, Ins_Asunto, Ins_Descripcion, Ins_Problema, Ins_Causa,  Ins_Ventana, Ins_Accion,"
				 				+ " Ins_MensajeError,TA_ID, OC_ID, OV_ID, Cli_ID, "
				 				+ " CCgo_ID, Prov_ID, Pt_ID, Tag_ID, Man_ID, ManD_ID, Inv_ID, Lot_ID, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, "
								+ "  Ins_Usu_Escalado, Ins_EstatusCG27, InsT_ID, InsO_ID, InsCm_ID, Ins_Prioridad, Ins_Severidad, Ins_FechaInicio_Tarea,Ins_FechaEntrega_Tarea) " 
                        		+ " VALUES (" + Ins_ID + "," + Ins_Padre + ",'" + Ins_Titulo + "','" + Ins_Asunto + "','" + Ins_Descripcion + "','" + Ins_Problema + "','" + Ins_Causa 
								+ "','" + Ins_Ventana + "','" + Ins_Accion + "','" + Ins_MensajeError
								+ "'," + TA_ID + "," + OC_ID + ","+ OV_ID + "," + Cli_ID + "," + CCgo_ID + "," + Prov_ID
							    + "," + Pt_ID + "," + Tag_ID + "," + Man_ID + "," + ManD_ID +"," + Inv_ID + "," + Lot_ID + "," + Ins_Usu_Reporta + "," + Ins_Usu_Recibe + "," + Prov_ID
								+ "," + Ins_Usu_Escalado + "," + Ins_EstatusCG27 
								+ "," + InsT_ID + "," + InsO_ID + "," + InsCm_ID + "," + Ins_Prioridad +"," + Ins_Severidad + ", '"+Ins_FechaInicio_Tarea+"', '"
								+Ins_FechaEntrega_Tarea+"')"					
          //Response.Write(sSQL)
				if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result
				}
		break;
		case 5:
				            Tag_ID = SiguienteID("Tag_ID","TAG","",0)

		         var sSQL = " INSERT INTO TAG(Tag_ID, Tag_Nombre , Tag_UsuarioPropietario)"
                        		+ " VALUES (" + Tag_ID + ",'" + Tag_Nombre + "'," + ID_Unico + ")"
                  if(Ejecuta(sSQL,0)){
				result = 1
		
				}else{
				result = 0
				}
			
			sResultado  = '{"result":'+result+',"tagid":'+Tag_ID+'}'
			
			
		break;
		case 6:

		         var sSQL = " UPDATE TAG SET  Tag_Descripcion='"+Tag_Descripcion+"' , Tag_Publica ="+Tag_Publica+" , Tag_OrigenCG252="+Tag_Origen
                        		+ " WHERE Tag_ID="+Tag_ID
					
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result

		break;
		
		case 7:
        var sSQL= "DELETE FROM Tag_Usuarios WHERE Tag_ID = "+ Tag_ID
		if(IDUsuario > -1){
			sSQL+=" and Usu_ID = "+ IDUsuario
		}
			
		Ejecuta(sSQL,0)
		break;
		
		case 8:
		if(TA_ID==-1 && OV_ID ==-1 && Alm_ID ==-1 && Inv_ID==-1){
						result = "<p style='color:red;'>No es posible relacionar tags desde esta ventana</p>"
	
		}else{
			     var sSQL = " INSERT INTO TAG_Marcados(Tag_ID, TA_ID, OV_ID, Alm_ID, Inv_ID, Pro_ID)"
                        		+ " VALUES (" + Tag_ID + "," + TA_ID + "," + OV_ID + ", " + Alm_ID + "," + Inv_ID + ", " + Pro_ID+ ")"
						
                  if(Ejecuta(sSQL,0)){
					result= ""
				}else{
				result = "<p style='color:red;'>Error al relacionar tag</p>"
				}
		}
							sResultado =result

		break;
			case 9:
        var sSQL= "DELETE FROM Tag_Marcados WHERE Tag_ID = "+ Tag_ID
					  + " AND TA_ID = " + TA_ID + " AND OV_ID=" + OV_ID + " AND Alm_ID = " + Alm_ID + " AND Inv_ID=" + Inv_ID
		Ejecuta(sSQL,0)
		break;
		
				case 10:
		         var sSQL = "INSERT INTO Tag_Usuarios(Tag_ID, Usu_ID) " 
                        sSQL += " VALUES (" + Tag_ID + "," + IDUsuario+ ")"					
                    Ejecuta(sSQL,0)		

		
		
		break;
			case 11:
// ESTO ESTA EN UN TRIGGER
	//			var sSQL = " INSERT INTO Incidencia_HistoriaLectura (Ins_ID, InsH_Leyo_UID)"
//								+ "VALUES ("+Ins_ID+", "+ IDUsuario+")"
//					
//						Ejecuta(sSQL,0)
//								
		         var sSQL = " UPDATE Incidencia SET  Ins_UltimoLeyo_UID="+IDUsuario + ", Ins_UltimoLeyoFecha = getdate()"
                        		+ " WHERE Ins_ID="+Ins_ID
				//Response.Write(sSQL)
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result

		break;
				case 12:

		var sSQL = " UPDATE Incidencia_Tipo SET "
						if(InsT_Padre > 0){
							sSQL +=" InsT_Padre = "+InsT_Padre+", "
						}
				sSQL += " InsT_Nombre = '" + InsT_Nombre + "' , InsT_Descripcion= '" + InsT_Descripcion + "', "				 
				sSQL += " InsT_PrioridadCG33=" + InsT_PrioridadCG33 + ", InsT_SeveridadCG32=" + InsT_SeveridadCG32 + ", InsT_EstrellasCG33= "+ InsT_EstrellasCG33 		
				sSQL += ", InsT_PrioridadABC=" + InsT_PrioridadABC + ", InsT_Orden= " + InsT_Orden + ", InsT_MoScoWCG24=" + InsT_MoScoWCG24
				sSQL += ", InsT_TallaCG25="+ InsT_TallaCG25 + ", InsT_SLAAtencion=" + InsT_SLAAtencion
				sSQL += ", InsT_SLAResolucion=" + InsT_SLAResolucion + ", InsT_Problema_For_ID=" + InsT_Problema_For_ID 
				sSQL += ", InsT_Comentarios_For_ID=" + InsT_Comentarios_For_ID + ", InsT_TipoCG28=" + InsT_TipoCG28 + ", InsT_TipoMedicionCG29=" + InsT_TipoMedicionCG29 										
				sSQL += " WHERE InsT_ID=" + InsT_ID               	
						//Response.Write(sSQL)
                    Ejecuta(sSQL,0)		
			
		break;
			case 13:
			var FechaLiberado = "''"
			if(Ins_EstatusCG27==4){
			FechaLiberado = "getdate()"	
			}
		         var sSQL = " UPDATE Incidencia SET  Ins_EstatusCG27="+Ins_EstatusCG27 
				 				+ " , Ins_Tarea_FechaLiberada = " + FechaLiberado
                        		+ " WHERE Ins_ID="+Ins_ID
				//Response.Write(sSQL)
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result

		break;
				case 14:
				  
				
		         var sSQL = "INSERT INTO Incidencia_Involucrados(Ins_ID, Ins_GrupoID, Ins_UsuarioID, Ins_TipoInvolucradoCG26) " 
                        sSQL += " VALUES (" + Ins_ID + "," + Ins_GrupoID+ "," + IDUsuario + "," + Ins_TipoInvolucradoCG26+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}
					
					sResultado  = '{"result":'+result+'}'
		
		
		break;
		case 15:
		
		         var sSQL = " UPDATE Incidencia_Involucrados SET Ins_TipoInvolucradoCG26="+Ins_TipoInvolucradoCG26 
				 			if(T_Involucrado==1){
				 				sSQL += "WHERE  Ins_GrupoID = " + Involucrado
							}if(T_Involucrado==2){
				 				sSQL += "WHERE  Ins_UsuarioID = " + Involucrado
							}
        				sSQL += " AND Ins_ID= "+ Ins_ID
				
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
				sResultado  = '{"result":'+result+'}'

		break;
		case 16:
		
		         var sSQL = " DELETE FROM Incidencia_Involucrados " 
				 			if(T_Involucrado==1){
				 				sSQL += "WHERE  Ins_GrupoID = " + Involucrado
							}if(T_Involucrado==2){
				 				sSQL += "WHERE  Ins_UsuarioID = " + Involucrado
							}
        				sSQL += " AND Ins_ID= "+ Ins_ID
				
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
																													
				sResultado  = '{"result":'+result+'}'

		break;
		
		case 17:
		
				
				if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
            	}
				var Alm_ID = -1
				var Alm_Nombre = ""
				if(Alm_Numero !=""){
				sSQL = "SELECT Alm_ID, Alm_Nombre FROM Almacen a "
							//+ "INNER JOIN TransferenciaAlmacen t ON  t.TA_End_Warehouse_ID = a.Alm_ID "
							+" WHERE Alm_Numero = '" + Alm_Numero + "'" //AND t.TA_ID ="+ TA_ID
				var rsAlm = AbreTabla(sSQL,1,0)
					//Response.Write(sSQL)
					if(!rsAlm.EOF){
						Alm_ID = rsAlm.Fields.Item("Alm_ID").Value
						Alm_Nombre = rsAlm.Fields.Item("Alm_Nombre").Value
					}else{
					sResultado = 0
					}
            	}
				if((Alm_ID >-1 && TA_ID >-1)||(Shipping != "" && TA_ID >-1)||(SKUSob >-1)||(SKUCambiado > -1)||(TdaOrig > -1)||(TA_ID >-1 && Ins_Titulo!="")||(FechaAviso != "" && TA_ID >-1)){
							if(TA_ID >-1 && Ins_Titulo!=""){
								var Titulo = Ins_Titulo
							   var Asunto = Ins_Titulo + " - " + TA_Folio
							 }
							if(Alm_ID>-1){
								var Titulo = "Entrega cruzada"
								var Asunto = "Entrega en tienda "+Alm_Numero+" - " +Alm_Nombre+ " - "+ TA_Folio
							}
							if(TdaOrig >-1){
									//sSQL = "INSERT INTO TransferenciaAlmacen ()"
								
								var Titulo = "Recoleccion"
								var Asunto = "Recoleccion en tienda "+Alm_Numero+" - " +Alm_Nombre
							}
							if(Shipping != ""){
								var Titulo = "Shipping"
								var Asunto = "Shipping Nota de Cargo  - "+ TA_Folio
							}
							if(FechaAviso != ""){
								var Titulo = "Costo Logistico"
								var Asunto = "Costo Logistico - " +TA_Folio
								sSQL = "SELECT CONVERT(VARCHAR, CONVERT(DATETIME, '"+FechaAviso+"'), 20) as fecha_aviso"
								var rsFechaAviso = AbreTabla(sSQL,1,0)
								FechaAviso = rsFechaAviso.Fields.Item("fecha_aviso").Value
							}
							if(SKUSob > -1){
								var Titulo = "Diferencia en remision"
								var Asunto = "SKU Sobrante - "+TA_Folio 
							}
							if(SKUCambiado > -1){
								var Titulo = "Diferencia en remision"
								var Asunto = "SKU Cambiado - "+TA_Folio 
							}
							if(InsT_ID==29){
								var Asunto = "SKU Faltante  - "+TA_Folio
							}
					
				            var Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)
								
							if(Ins_FechaInicio_Tarea != "" && Ins_FechaEntrega_Tarea != "" && (Ins_Padre ==20||Ins_Padre==19)){
							Ins_FechaInicio_Tarea=CambiaFormatoFecha(Ins_FechaInicio_Tarea,"dd/mm/yyyy","yyyy-mm-dd")
							Ins_FechaEntrega_Tarea=CambiaFormatoFecha(Ins_FechaEntrega_Tarea,"dd/mm/yyyy","yyyy-mm-dd")
							}
		         var sSQL = " INSERT INTO Incidencia (Ins_ID, Ins_Padre, Ins_Titulo, Ins_Asunto, Ins_Descripcion,TA_ID"
				 				+ ", Prov_ID, Alm_ID, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, "
								+ "  Ins_Usu_Escalado, Ins_EstatusCG27, InsT_ID, InsO_ID, InsCm_ID, Ins_Prioridad, Ins_Severidad, Ins_FechaInicio_Tarea,Ins_FechaEntrega_Tarea, Ins_FechaAvisoCosto) " 
                        		+ " VALUES (" + Ins_ID + "," + Ins_Padre + ",'"+Titulo+"','"+Asunto+"','" + Ins_Descripcion 
								+ "'," + TA_ID + "," + Prov_ID+ "," + Alm_ID+ ","	+ Ins_Usu_Reporta + "," + Ins_Usu_Recibe + "," + Prov_ID
								+ "," + Ins_Usu_Escalado + "," + Ins_EstatusCG27 + "," + InsT_ID + "," + InsO_ID + "," + InsCm_ID + "," + Ins_Prioridad
				 				+ "," + Ins_Severidad + ", '"+Ins_FechaInicio_Tarea+"', '"+ Ins_FechaEntrega_Tarea +"', '"+FechaAviso+"')"					
          					//Response.Write(sSQL)
				if(Ejecuta(sSQL,0)){
					result = 1
				}else{
					result = 2
				}
					sResultado =result
				}
			
			
		break;
		case 18:
				if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
            	}
			sSQL = "SELECT p.Pro_SKU, p.Pro_Nombre, p.Pro_ID  FROM TransferenciaAlmacen_Articulo_Picking a "
					  + " INNER JOIN TransferenciaAlmacen t ON a.TA_ID=t.TA_ID "
					  + " INNER JOIN Producto p ON p.Pro_ID=a.Pro_ID"
					  + " WHERE a.TA_ID = "+TA_ID
					  + "GROUP BY p.Pro_SKU, p.Pro_Nombre, p.Pro_ID "
			%>
			<table class="table table-hover">
        		<tbody>
			<td><strong>Selecciona</strong></td>
			<td><strong>SKU</strong></td>
			<td><strong>Modelo</strong></td>			
   <%
    var rsSKU = AbreTabla(sSQL,1,0)
    while (!rsSKU.EOF){

 		if(Ins_ID>-1){
		sSQL = "SELECT Pro_ID FROM TransferenciaAlmacen_Articulo_Picking "
				  + " WHERE Ins_ID=" + Ins_ID + " AND Pro_ID="+rsSKU.Fields.Item("Pro_ID").Value + " AND TA_ID="+TA_ID
		var rsSKUsel =  AbreTabla(sSQL,1,0)
		}
//  var iEstatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value
//           
//          ClaseEstatus = "plain"
//          switch (parseInt(iEstatus)) {
//	 		
//	 		case 1:
//                 ClaseEstatus = "plain"   
//            break;    
//            case 3:
//                ClaseEstatus = "warning"
//            break;     
//            case 4:
//                ClaseEstatus = "success"
//            break;    
//            case 2:
//                ClaseEstatus = "warning"
//            break;   
//            case 5:
//                ClaseEstatus = "danger"
//            break;        
//            }   
	
	var sChecked =""
	var Pro_Cambio = "placeholder='SKU Cambiado'"
	if(Ins_ID>-1){
			if(!rsSKUsel.EOF){
			 sChecked = "checked='checked'"
			}        
     }   

%>
          	<tr>
            
             
				<td>
                    <input type="checkbox" class="i-checks ChkSKU<%=rsSKU.Fields.Item("Pro_ID").Value%>"  <%=sChecked%> onclick="FunctionInsert.AgregarSKU(<%=rsSKU.Fields.Item("Pro_ID").Value%>, <%=TA_ID%>)">
                  </td>
				<td>
                  <strong><%=rsSKU.Fields.Item("Pro_SKU").Value%> </strong>
                </td>
<%/*%>                	<td >
         		   		<span class="label label-<%=ClaseEstatus%>"><%=rsSKU.Fields.Item("Cat_Nombre").Value%> </span>
               	</td><%*/%>
                <td><strong><%=rsSKU.Fields.Item("Pro_Nombre").Value%></strong></td>
            </tr>
<%	
  
        rsSKU.MoveNext() 
        }
    rsSKU.Close()  

%>
            </tbody>
     </table>
<%
		break;
			case 19:
			
			if(Ins_ID ==-1){
	            Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)
			}
			
		         var sSQL = " UPDATE TransferenciaAlmacen_Articulo_Picking SET Ins_ID="
				 	if(ChkSKU==1){
						sSQL +=  Ins_ID
					}
					if(ChkSKU==0){
						sSQL += "-1"
					}
				 		sSQL += " WHERE  TA_ID = " + TA_ID
        				sSQL += " AND Pro_ID= "+ Pro_ID
				Response.Write(sSQL)
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
				sResultado  = '{"result":'+result+'}'

		break;
			
				case 20:

		       	var sSQL = "SELECT For_ID FROM Formato WHERE For_ParIncidencias="+For_ID
				//Response.Write(sSQL)
				var rsFormato = AbreTabla(sSQL,1,0)
				if(!rsFormato.EOF){
				 result = rsFormato.Fields.Item("For_ID").Value

				}else{
				result = 0
				}
			
				sResultado  = '{"result":'+result+'}'

		break;
		  case 21:
			var Pro_ID = 0
			var Pro_ID2 = 0
			var Pro_ID3 = 0
			var Pro_ID4 = 0
			var Pro_ID5 = 0
			
			  //if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
			//  }
       	if(TA_ID > -1){
          var Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)

			if(SKU1 !=""){
				sSQL = "SELECT Pro_ID, Inv_ID FROM Inventario WHERE Inv_Serie = '" + SKU1 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID = rsPro.Fields.Item("Pro_ID").Value
						Inv_ID = rsPro.Fields.Item("Inv_ID").Value

					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID, Inv_ID) " 
                        sSQL += " VALUES (" + Ins_ID + ",-1,"+Pro_ID+","+Inv_ID+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			if(SKU2 !=""){
				sSQL = "SELECT Pro_ID, Inv_ID FROM Inventario WHERE Inv_Serie = '" + SKU2 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID = rsPro.Fields.Item("Pro_ID").Value
						Inv_ID = rsPro.Fields.Item("Inv_ID").Value

					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID, Inv_ID) " 
                        sSQL += " VALUES (" + Ins_ID + ",-1,"+Pro_ID+","+Inv_ID+")"			
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }

			if(SKU3 !=""){
				sSQL = "SELECT Pro_ID, Inv_ID FROM Inventario WHERE Inv_Serie = '" + SKU3 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID = rsPro.Fields.Item("Pro_ID").Value
						Inv_ID = rsPro.Fields.Item("Inv_ID").Value

					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID, Inv_ID) " 
                        sSQL += " VALUES (" + Ins_ID + ",-1,"+Pro_ID+","+Inv_ID+")"		
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			if(SKU4 !=""){
				sSQL = "SELECT Pro_ID, Inv_ID FROM Inventario WHERE Inv_Serie = '" + SKU4 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID = rsPro.Fields.Item("Pro_ID").Value
						Inv_ID = rsPro.Fields.Item("Inv_ID").Value

					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID, Inv_ID) " 
                        sSQL += " VALUES (" + Ins_ID + ",-1,"+Pro_ID+","+Inv_ID+")"
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			if(SKU5 !="" ){
					sSQL = "SELECT Pro_ID, Inv_ID FROM Inventario WHERE Inv_Serie = '" + SKU5 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID = rsPro.Fields.Item("Pro_ID").Value
						Inv_ID = rsPro.Fields.Item("Inv_ID").Value

					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID, Inv_ID) " 
                        sSQL += " VALUES (" + Ins_ID + ",-1,"+Pro_ID+","+Inv_ID+")"
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			
					if(Pro_ID > 0 || Pro_ID2 > 0 || Pro_ID3 > 0||Pro_ID4 >0||Pro_ID5 >0){
						var sSQL = " INSERT INTO Incidencia (Ins_ID, Ins_Padre, Ins_Titulo, Ins_Asunto, Ins_Descripcion,TA_ID"
				 				+ ", Prov_ID, Alm_ID, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, "
								+ "  Ins_Usu_Escalado, Ins_EstatusCG27, InsT_ID, InsO_ID, InsCm_ID, Ins_Prioridad, Ins_Severidad, Ins_FechaInicio_Tarea,Ins_FechaEntrega_Tarea) " 
                        		+ " VALUES (" + Ins_ID + "," + Ins_Padre + ",'"+Ins_Titulo+"','"+Ins_Titulo+"','" + Ins_Descripcion 
								+ "'," + TA_ID + "," + Prov_ID+ "," + Alm_ID+ ","	+ Ins_Usu_Reporta + "," + Ins_Usu_Recibe + "," + Prov_ID
								+ "," + Ins_Usu_Escalado + "," + Ins_EstatusCG27 + "," + InsT_ID + "," + InsO_ID + "," + InsCm_ID + "," + Ins_Prioridad
				 				+ "," + Ins_Severidad + ", '"+Ins_FechaInicio_Tarea+"', '"+ Ins_FechaEntrega_Tarea +"')"					
          						//Response.Write(sSQL)
								if(Ejecuta(sSQL,0)){
									result = 1
								}else{
									result = 0
								}
			
					}
					sResultado  = '{"result":'+result+'}'

		}
			break;
	
		case 22:
		 		var sSQL = "SELECT   Pro_Nombre "
				sSQL +=" FROM Producto p INNER JOIN Inventario i ON p.Pro_ID=i.Pro_ID"
				sSQL +=" WHERE Inv_Serie = '"+ SKU1 + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
			var NoExiste = "No existe"
			if(!rsPro.EOF){
			var Producto = rsPro.Fields.Item("Pro_Nombre").Value

	%>
    	     <label type="text" ><%=Producto%></label>
	<%
		 
			}else{
				%>
    	     <label type="text" style = "color:red" ><%=NoExiste%></label>
				<%
			}
			
 break;
						
				
	case 23:
				if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
            	}
			sSQL = "SELECT p.Pro_SKU, p.Pro_Nombre, p.Pro_ID  FROM TransferenciaAlmacen_Articulo_Picking a "
					  + " INNER JOIN TransferenciaAlmacen t ON a.TA_ID=t.TA_ID "
					  + " INNER JOIN Producto p ON p.Pro_ID=a.Pro_ID"
					  + " WHERE a.TA_ID = "+TA_ID
					  + "GROUP BY p.Pro_SKU, p.Pro_Nombre, p.Pro_ID "
			%>
			<table class="table table-hover">
        		<tbody>
			<td><strong>Cambiado</strong></td>
			<td><strong>SKU</strong></td>
			<td><strong>Modelo</strong></td>	
			<td><strong>SKU enviado</strong></td>

   <%
    var rsSKU = AbreTabla(sSQL,1,0)
    while (!rsSKU.EOF){
		if(Ins_ID>-1){
		sSQL = "SELECT s.*, p.Pro_SKU FROM Incidencia_SKU s LEFT JOIN Producto p ON s.Pro_ID_Cambio=p.Pro_ID"
				  + " WHERE s.Ins_ID=" + Ins_ID + " AND s.Pro_ID="+rsSKU.Fields.Item("Pro_ID").Value + " AND s.TA_ID="+TA_ID
		var rsSKUsel =  AbreTabla(sSQL,1,0)
		}
//  var iEstatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value
//           
//          ClaseEstatus = "plain"
//          switch (parseInt(iEstatus)) {
//	 		
//	 		case 1:
//                 ClaseEstatus = "plain"   
//            break;    
//            case 3:
//                ClaseEstatus = "warning"
//            break;     
//            case 4:
//                ClaseEstatus = "success"
//            break;    
//            case 2:
//                ClaseEstatus = "warning"
//            break;   
//            case 5:
//                ClaseEstatus = "danger"
//            break;        
//            }   
	
	var sChecked =""
	var Pro_Cambio = "placeholder='SKU Cambiado'"
	if(Ins_ID>-1){
			if(!rsSKUsel.EOF){
			 sChecked = "checked='checked'"
			Pro_Cambio = "value='"+ rsSKUsel.Fields.Item('Pro_SKU').Value + "'"
			}
	}
%>
          	<tr>
            
             
				<td>
                    <input type="checkbox" class="i-checks ChkSKU<%=rsSKU.Fields.Item("Pro_ID").Value%>" <%=sChecked%> onclick="FunctionInsert.AgregarSKU(<%=rsSKU.Fields.Item("Pro_ID").Value%>, <%=TA_ID%>)">
                  </td>
				<td>
                  <strong><%=rsSKU.Fields.Item("Pro_SKU").Value%> </strong>
                </td>
<%/*%>                	<td >
         		   		<span class="label label-<%=ClaseEstatus%>"><%=rsSKU.Fields.Item("Cat_Nombre").Value%> </span>
               	</td><%*/%>
                <td><strong><%=rsSKU.Fields.Item("Pro_Nombre").Value%></strong></td>
				<td>     <input class="form-control SKU<%=rsSKU.Fields.Item("Pro_ID").Value%>" <%=Pro_Cambio%>></input>
 </td>
            </tr>
<%	
  
        rsSKU.MoveNext() 
        }
    rsSKU.Close()  

%>
            </tbody>
     </table>
<%
		break;

	case 24:
				var message =""
				
				var sSQL = "SELECT   Pro_ID, Pro_Nombre "
				sSQL +=" FROM Producto"
				sSQL +=" WHERE Pro_SKU = '"+ SKUCambiado + "'"
				
			var rsPro = AbreTabla(sSQL,1,0)
			if(!rsPro.EOF){
			var ProC_ID = rsPro.Fields.Item("Pro_ID").Value
			if(Ins_ID==-1){
			Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)
			}
				if(ChkSKU==1){

		         var sSQL = " INSERT INTO Incidencia_SKU (Ins_ID, TA_ID, Pro_ID, Pro_ID_Cambio)"
								+ " VALUES ("+Ins_ID +", " + TA_ID +", "+ Pro_ID +", "+ ProC_ID +")"
					//Response.Write(sSQL)
					if(Ejecuta(sSQL,0)){
					result = 1
						message = "Producto cambiado por: " + rsPro.Fields.Item("Pro_Nombre").Value
					}else{
					result = 0
					}
				}else{
					var sSQL = "DELETE FROM Incidencia_SKU WHERE Ins_ID = " +Ins_ID +" AND TA_ID = "+TA_ID
									+ " AND Pro_ID="+Pro_ID+" AND Pro_ID_Cambio="+ProC_ID
				//	Response.Write(sSQL)
						if(Ejecuta(sSQL,0)){
						result = 1
						 message = "SKU " + SKUCambiado + " desvinculado exitosamente"
						}else{
						result = 0
						}
				}
				}else{
			result = 0
			 message = "No existe el SKU " + SKUCambiado
			}
			sResultado = '{"result":'+result+',"message":"'+message+'"}'

		break;
		
		case 25:
				%>
		                        <label class="control-label col-md-2"><strong>Tipo</strong></label>
                         <div class="col-md-4">
<%
//						if(Procedencia ==""){

                            var sCondicion = "InsT_Padre = 0"
                            var campo = "InsT_Nombre"
                            
                            CargaCombo("InsT_Padre","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")
%>
								<div class="col-md-6">
									
								</div>

					</div>	
				<%
		break;
				
				case 26:
				
				var Asunto= "Ins_Asunto"
				if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
					sSQL = "SELECT TA_ID FROM Incidencia WHERE Ins_ID ="+Ins_ID
						var rsTA = AbreTabla(sSQL,1,0)
						TA_ID_Inc = rsTA.Fields.Item("TA_ID").Value
					if(TA_ID!=TA_ID_Inc){
						sSQL = "DELETE FROM Incidencia_SKU WHERE Ins_ID="+Ins_ID+ " AND TA_ID="+TA_ID_Inc
						Ejecuta(sSQL,0)
					}

            	}
				var Alm_ID = -1
				var Alm_Nombre = ""
				if(Alm_Numero !=""){
				sSQL = "SELECT Alm_ID, Alm_Nombre FROM Almacen a "
							//+ "INNER JOIN TransferenciaAlmacen t ON  t.TA_End_Warehouse_ID = a.Alm_ID "
							+" WHERE Alm_Numero = '" + Alm_Numero + "'" //AND t.TA_ID ="+ TA_ID
				var rsAlm = AbreTabla(sSQL,1,0)
					//Response.Write(sSQL)
					if(!rsAlm.EOF){
						Alm_ID = rsAlm.Fields.Item("Alm_ID").Value
						Alm_Nombre = rsAlm.Fields.Item("Alm_Nombre").Value
					}else{
					sResultado = 0
					}
            	}
					if(SKUCambiado > -1){
								var Asunto = "SKU Cambiado - "+TA_Folio 
					}
					if(SKUSob > -1){
								var Asunto = "SKU Sobrante - "+TA_Folio 
					}
					if(InsT_ID==29){
								var Asunto = "SKU Faltante - "+TA_Folio 
					}
					if(InsT_ID==30){
								var Asunto = "Entrega Parcial - "+TA_Folio 
					}
					if(Shipping != ""){
								var Titulo = "Shipping"
								var Asunto = "Shipping Nota de Cargo  - "+ TA_Folio
					}
					if(InsT_ID==38){
								var Asunto = "Costo logistico - "+TA_Folio 
					}
					if(Alm_ID>-1){
								var Asunto = "Entrega en tienda "+Alm_Numero+" - " +Alm_Nombre+ " - "+ TA_Folio
					}
				sSQL="UPDATE Incidencia SET "
						+ "Ins_Usu_Recibe = "+Ins_Usu_Recibe
				if(InsT_ID != 39 && InsT_ID != 40){
						sSQL += ", Ins_Asunto ='"+Asunto+"'"
				}
						sSQL += ", Ins_Descripcion= '"+Ins_Descripcion+"'"
				if(Alm_ID>-1){
					sSQL += ", Alm_ID="+Alm_ID
				}
				if(TA_ID>-1){
					sSQL += ", TA_ID="+TA_ID
				}
				if(InsT_ID==38){
					sSQL += ", Ins_FechaAvisoCosto = '"+ FechaAviso + "'"
				}
				if(InsT_ID == 39||InsT_ID==40){
						sSQL += ", Ins_Asunto= '"+Ins_Asunto+"'"
						sSQL += ", Ins_Titulo= '"+Ins_Titulo+"'"
						sSQL += ", Ins_Causa= '"+Ins_Causa+"'"
						sSQL += ", Ins_Problema= '"+Ins_Problema+"'"
				
				}
				sSQL += " WHERE Ins_ID = "+Ins_ID
				//Response.Write(sSQL)
					if(Ejecuta(sSQL,0)){
					result = 1
				}else{
					result = 0
				}
			
				if(SKU1 !=""){
				sSQL = "DELETE FROM Incidencia_SKU WHERE Ins_ID ="+Ins_ID
				Ejecuta(sSQL,0)
				sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU1 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID = rsPro.Fields.Item("Pro_ID").Value
					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
                        sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ ","+Pro_ID+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			if(SKU2 !=""){
				sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU2 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID2 = rsPro.Fields.Item("Pro_ID").Value
				        var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
                        sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID2+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }

			if(SKU3 !=""){
				sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU3 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID3 = rsPro.Fields.Item("Pro_ID").Value
					    var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
                        sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID3+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			if(SKU4 !=""){
				sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU4 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID4 = rsPro.Fields.Item("Pro_ID").Value
  			            var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
                        sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID4+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
			if(SKU5 !="" ){
				sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '" + SKU5 + "'"	
				var rsPro = AbreTabla(sSQL,1,0)
					if(!rsPro.EOF){
						Pro_ID5 = rsPro.Fields.Item("Pro_ID").Value
				         var sSQL = "INSERT INTO Incidencia_SKU(Ins_ID, TA_ID, Pro_ID) " 
                        sSQL += " VALUES (" + Ins_ID + "," + TA_ID+ "," + Pro_ID5+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}

					}else{
						result = 2
					}
			  }
				//Response.Write(sSQL)
					sResultado =result
				
			
				break;
				
		case 27:
				
				sSQL = "SELECT Inv_ID FROM Inventario WHERE Inv_Serie='"+Serie+"'"
				//Response.Write(sSQL)
				var rsInv = AbreTabla(sSQL,1,0)
				if(!rsInv.EOF){	
				sSQL = "SELECT * FROM Incidencia_SKU WHERE Ins_ID="+Ins_ID
						+ " AND Pro_ID = "+Pro_ID+" AND TA_ID="+ TA_ID+" AND (Inv_ID ="
						+ rsInv.Fields.Item("Inv_ID").Value + " OR Inv_ID_Cambio = "+rsInv.Fields.Item("Inv_ID").Value+")" 
				var rsTA = AbreTabla(sSQL,1,0)
			
				sSQL = "select top 1 * from pallet where ubi_ID in ( select Ubi_ID from ubicacion "
						 + " where are_id = 17) and Pro_ID = "+Pro_ID
			//	Response.Write(sSQL)
				var rsUbi = AbreTabla(sSQL,1,0)
				if(!rsTA.EOF){
//					if(rsTA.Fields.Item("TAS_Serie").Value == Serie){
						sSQL = "SELECT Alm_ID FROM Inventario WHERE Inv_ID="+rsTA.Fields.Item("Inv_ID").Value
						var rsAlm = AbreTabla(sSQL,1,0)
						
					sSQL = "UPDATE Inventario SET Inv_EstatusCG20=13, Inv_EnAlmacen = 0, Inv_EstatusTiendasCG20 =1,"
							+" Alm_ID = "+rsAlm.Fields.item("Alm_ID").Value+", Ubi_ID =1353"
							+", Pt_ID = -1 WHERE Inv_Serie = '"+Serie+"'"
					//Response.Write(sSQL)
				if(Ejecuta(sSQL,0)){
					result = 1
					sResultado =result
				}else{
						result = 0
						sResultado =result
				}
					if(InsT_ID==27){
						sSQL = "UPDATE Inventario SET Inv_EstatusCG20=1, Inv_EnAlmacen = 1, Alm_ID = 324, Ubi_ID ="+rsUbi.Fields.Item("Ubi_ID").Value
									+", Pt_ID = "+rsUbi.Fields.Item("Pt_ID").Value+" WHERE Inv_ID =" + rsTA.Fields.Item("Inv_ID").Value
						//Response.Write(sSQL)
						if(Ejecuta(sSQL,0)){
							result = 1
							sResultado =result
						}else{
							result = 0
							sResultado =result
						}	
					}
				//}else{
//						
//				}
				}
				//	else{
//					if(TA_ID==-1){ // Obtener TA_ID de los SKU Sobrantes
//					var sSQL = "SELECT TA_ID FROM TransferenciaAlmacen_Articulo_Picking WHERE Inv_ID="+Inv_ID
//					var rsTAID = AbreTabla(sSQL,1,0)
//					TA_ID = rsTAID.Fields.Item("TA_ID").Value
//					}
	//					sSQL = "SELECT Inv_Serie FROM Inventario WHERE Inv_ID="+Inv_ID
//				var rsSerie = AbreTabla(sSQL,1,0)
				//	if(!rsTAID.EOF){
//							sSQL = "UPDATE TransferenciaAlmacen_Articulo_Picking SET  TAS_Serie = '"+rsSerie.Fields.Item("Inv_Serie").Value+"', Inv_ID =" 
//					 + Inv_ID +" WHERE Inv_ID =" +rsInv.Fields.Item("Inv_ID").Value
//
//						if(Ejecuta(sSQL,0)){
//							result = 1
//						//Response.Write(sSQL)
//						}
//			sSQL = "UPDATE TransferenciaAlmacen_Articulo_Picking SET  TAS_Serie = '"+Serie+"', Inv_ID =" +rsInv.Fields.Item("Inv_ID").Value
//					  +" WHERE TAS_Serie = '"+rsSerie.Fields.Item("Inv_Serie").Value+"' AND TA_ID="+TA_ID
//				//	Response.Write(sSQL)
//				if(Ejecuta(sSQL,0)){
//				
//				}else{
//						result = 0
//						sResultado =result
//				}
//					}
			if((rsTA.Fields.Item("Inv_ID_Cambio").Value != rsInv.Fields.Item("Inv_ID").Value && InsT_ID==27)||(rsTA.Fields.Item("Inv_ID").Value != rsInv.Fields.Item("Inv_ID").Value && InsT_ID==28)){
						 
					sSQL = "UPDATE Incidencia_SKU SET Inv_ID_Cruzado ="+ rsInv.Fields.Item("Inv_ID").Value
							 + " WHERE Inv_ID ="+ rsTA.Fields.Item("Inv_ID").Value+" AND  Ins_ID = "+Ins_ID
				if(Ejecuta(sSQL,0)){
					result = 1
					sResultado =result
				}else{
					result = 0
					sResultado =result
				}
			}

				}else{
					result=2
				}
//				}else{
//					result = 3 
					sResultado = result
			
				break;
		
			case 28:
				
				sSQL = "SELECT Inv_ID FROM Inventario WHERE Inv_Serie='"+Serie+"'"
				var rsInv = AbreTabla(sSQL,1,0)
				Response.Write(sSQL)
				if(!rsInv.EOF){	
				sSQL = "SELECT * FROM Incidencia_SKU WHERE Ins_ID="+Ins_ID
						+ " AND Pro_ID = "+Pro_ID+" AND TA_ID="+ TA_ID+" AND (Inv_ID ="
						+ rsInv.Fields.Item("Inv_ID").Value + " OR Inv_ID_Cambio = "+rsInv.Fields.Item("Inv_ID").Value+")" 
				var rsTA = AbreTabla(sSQL,1,0)
			
				sSQL = "select top 1 * from pallet where ubi_ID in ( select Ubi_ID from ubicacion "
						 + " where are_id = 17) and Pro_ID = "+Pro_ID
				//	Response.Write(sSQL)
				var rsUbi = AbreTabla(sSQL,1,0)
				if(!rsTA.EOF){
//					if(rsTA.Fields.Item("TAS_Serie").Value == Serie){
					
					sSQL = "UPDATE Inventario SET Inv_EstatusCG20=1, Inv_EnAlmacen = 1, Alm_ID = 324, Ubi_ID ="+rsUbi.Fields.Item("Ubi_ID").Value
							+", Pt_ID = "+rsUbi.Fields.Item("Pt_ID").Value+" WHERE Inv_Serie = '"+Serie+"'"
				if(Ejecuta(sSQL,0)){
					result = 1
					sResultado =result
				}else{
						result = 0
						sResultado =result
				}
					if(InsT_ID==27){
						sSQL = "UPDATE Inventario SET Inv_EstatusCG20=1, Inv_EnAlmacen = 1, Alm_ID = 324, Ubi_ID ="+rsUbi.Fields.Item("Ubi_ID").Value
									+", Pt_ID = "+rsUbi.Fields.Item("Pt_ID").Value+" WHERE Inv_ID =" + rsTA.Fields.Item("Inv_ID").Value
						if(Ejecuta(sSQL,0)){
							result = 1
							sResultado =result
						}else{
							result = 0
							sResultado =result
						}	
					}
				}

					if((rsTA.Fields.Item("Inv_ID_Cambio").Value != rsInv.Fields.Item("Inv_ID").Value && InsT_ID==27)||(rsTA.Fields.Item("Inv_ID").Value != rsInv.Fields.Item("Inv_ID").Value && InsT_ID==28)){
						 
					sSQL = "UPDATE Incidencia_SKU SET Inv_ID_Cruzado ="+ rsInv.Fields.Item("Inv_ID").Value
							 + " WHERE Inv_ID ="+ Inv_ID+" AND  Ins_ID = "+Ins_ID
					if(Ejecuta(sSQL,0)){
					result = 1
					sResultado =result
				}else{
						result = 0
						sResultado =result
				}
					}
				}
//				}else{
//					result = 3 
					sResultado = result
			
	
				break;
			}
										  
	

    Response.Write(result)
			
%>


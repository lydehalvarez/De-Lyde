<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea = Parametro("Tarea",0)
var IDUnica = Parametro("IDUnica",-1)
var Aud_ID = Parametro("Aud_ID",-1)
var result = -1
var message = ""


var sResultado = ""

   switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
			bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
            var sResultado = '{"result":-1,"message":"No entro a ninguna tarea","Tarea":' + Tarea + '}'
		break; 
        case 1: //Habilita / deshabilita usuario a una auditoria
            
            var Usu_ID = Parametro("Usu_ID",-1)
            var Chkdo  = Parametro("Chkdo",0)
            var Hab  = Parametro("Hab",0)
             
            var sMensaje = "El auditor fue eliminado de la lista de auditores activos"

            try {	

                var sSQL = "IF NOT EXISTS( SELECT 1 FROM Auditorias_Auditores "
                         +                " WHERE Aud_ID = " + Aud_ID 
                         +                "   AND Usu_ID = " + Usu_ID + ")"
                         + " INSERT INTO Auditorias_Auditores( Aud_ID, Usu_ID, Aud_Habilitado, Aud_Externo ) " 
                         + " VALUES( " + Aud_ID + ", " + Usu_ID + ", 0, 0 ) "

                Ejecuta(sSQL,0)		

                
                var sSQL = "UPDATE Auditorias_Auditores "
                    if(Hab == 1) {
                        sSQL += " SET Aud_Habilitado = " + Chkdo
                    } else {
                        sSQL += " SET Aud_Externo = " + Chkdo
                    }
                    sSQL += " WHERE Aud_ID = " + Aud_ID 
                    sSQL += " AND Usu_ID = " + Usu_ID 

                    Ejecuta(sSQL,0)				

                if(Chkdo ==1){
                    sMensaje = "El auditor fue agregado correctamente"
                } else {
                    sMensaje = "El auditor fue deshabilitado"
                }

                 sResultado = '{"result":1,"message":"' + sMensaje + '","Tarea":' + Tarea + '}'		
            } catch(err) {
                sResultado = '{"result":-1,"message":"Falla al agregar al auditor id " + Usu_ID,"Tarea":' + Tarea + '}'
            }
 	
        break; 
		case 2:	//busca un codigo de barras de una auditoria a recibir
		
            var Aud_ID = Parametro("Aud_ID",-1)
            var CB  = Parametro("CB",0)
            
			var result = -1
			var message = ""
            var sMensaje = ""
			var data = null

            try {
                var sSQL = "select   u.Pt_ID, AudU_ID, AudU_Veces, AudU_AsignadoA, AudU_Terminado "
                         +      ", AudU_TerminadoFecha, AudU_MBCantidad, AudU_MBCantidadArticulos "
                         +      ", AudU_ArticulosConteoTotal, AudU_FechaConteo, AudU_TipoConteoCG142 "
                         +      ", AudU_HallazgoCG144, AudU_Comentario, AudU_FechaRegistro, AudU_EnProceso "
                         +      ", AudU_MBCantidadSobrante, AudU_ConteoInterno, AudU_ImpresionPapeleta "
                         +      ", Pt_LPN, Pt_SKU, Ubi_Nombre, ISNULL(Ubi_Etiqueta,'') as Etiqueta "
                         +      ", Pro_SKU, Pro_Nombre "
//                         +      ", ISNULL(Usu_Nombre,'') as Auditor "
                         +  " FROM Auditorias_Ubicacion u "
                         + " INNER JOIN Auditorias_Ciclicas ac "
                         +    " ON u.Aud_ID = ac.Aud_ID "
                         + " INNER JOIN Auditorias_Pallet ap "
                         +    " ON u.Aud_ID = ap.Aud_ID "
						 		+" AND u.Pt_ID = ap.Pt_ID "
                         + " INNER JOIN Producto pr "
                         +    " ON pr.Pro_ID = ap.Pro_ID "
                         + " LEFT JOIN Ubicacion ur "
                         +    " ON ur.Ubi_ID = ap.Ubi_ID "
//                         +  " LEFT JOIN Usuario us "
//                         +    " ON us.Usu_ID = u.AudU_AsignadoA "
                         + " WHERE u.AudU_CodigoBarras = "+CB 
                         +   " AND u.Aud_ID = "+Aud_ID
                         +   " AND u.AudU_Veces = ac.Aud_VisitaActual "
						 
						 //Response.Write(sSQL)
						 
						

                var rsPallet = AbreTabla(sSQL, 1, 0)

                if( !(rsPallet.EOF) ){
					result = 1
					message = "Se encontro el Pallet "+rsPallet.Fields.Item("Pt_LPN").Value
					
					data  = ' "InfoPallet" :{"ConteoInterno":"' +  rsPallet.Fields.Item("AudU_ConteoInterno").Value  + '"'
                    data += ',"Pt_ID":"' +  rsPallet.Fields.Item("Pt_ID").Value  + '"'
                    data += ',"AudU_ID":"' +  rsPallet.Fields.Item("AudU_ID").Value  + '"'
                    data += ',"Vez":"' +  rsPallet.Fields.Item("AudU_Veces").Value  + '"'
                    data += ',"Pt_LPN":"' +  rsPallet.Fields.Item("Pt_LPN").Value  + '"'                    
                    data += ',"Pro_SKU":"' +  rsPallet.Fields.Item("Pro_SKU").Value  + '"'   
                    data += ',"Pro_Nombre":"' +  rsPallet.Fields.Item("Pro_Nombre").Value  + '"'   
                    data += ',"Ubi_Nombre":"' +  rsPallet.Fields.Item("Ubi_Nombre").Value  + '"' 
                    data += ',"Etiqueta":"' +  rsPallet.Fields.Item("Etiqueta").Value  + '"'    
                    data += ',"AsignadoA":"' +  rsPallet.Fields.Item("AudU_AsignadoA").Value  + '"' 
                    data += ',"Comentario":"' +  rsPallet.Fields.Item("AudU_Comentario").Value  + '"'    
                    data += ',"ConteoTotal":"' +  rsPallet.Fields.Item("AudU_ArticulosConteoTotal").Value  + '"' 
                    data += '}'  
					
					
					var auditores = "SELECT * "
								+ "FROM Auditorias_Ubicacion"
								+" WHERE Pt_ID = " +rsPallet.Fields.Item("Pt_ID").Value
								+" AND AudU_Terminado = 0 "
								+" AND Aud_ID = "+Aud_ID
								+" ORDER BY AudU_FechaRegistro DESC "

					var rsAud = AbreTabla(auditores, 1, 0)
	
					if(!(rsAud.EOF)){		
						data += ', "DatoAudi":[ '
						var coma = 0
						while( !(rsAud.EOF) ){
							if(coma > 0){
								data += ","
							}
							data += ' {"AudU_ID":'+rsAud.Fields.Item("AudU_ID").Value 
							data += ', "AudU_AsignadoA":'+rsAud.Fields.Item("AudU_AsignadoA").Value 
							data += ', "Comentario": "'+rsAud.Fields.Item("AudU_Comentario").Value+'"'
							data += ', "AudU_ConteoInterno": '+rsAud.Fields.Item("AudU_ConteoInterno").Value
							data += ', "Total":'+rsAud.Fields.Item("AudU_ArticulosConteoTotal").Value +'}'
							rsAud.MoveNext
								coma++

						}
						rsAud.Close
						data += '] '
					}else{
						data += ', "DatoAudi": null '
					}

                }else{
					result = 2
					message = "No se encontro una papeleta "+CB+" con ese codigo, avisar al administrador"
					data = '"datos": "'+sSQL+'"'
				}
 	
            } catch(err) {
				result = 2
				message = "Falla al agregar al auditor"
				data = '"data":null'
            }
			sResultado = '{"result":"'+result+'","message":"'+message+'" ,"Tarea":' + Tarea + ',"data":{'+data+'}}'
			
        break; 
		case 3:	//busca un codigo de barras de una auditoria a recibir   
               
             var Aud_ID = Parametro("Aud_ID",-1)
             var Cantidad = Parametro("Cantidad",0)
             var Comentario = Parametro("Comentario","")
             var Pt_ID = Parametro("Pt_ID",-1)
             var AudU_ID = Parametro("AudU_ID",-1)
             var Usu_ID = Parametro("Usu_ID",-1)
             var Hallazgo = Parametro("Hallazgo",-1)
                                     
            var Interno = 1
             try {
				 if(Usu_ID > -1){
					 Interno = BuscaSoloUnDato("Aud_Externo","Auditorias_Auditores","Usu_ID = "+Usu_ID,-1,0)
				 }
                var sSQL = "UPDATE Auditorias_Ubicacion "
                         +   " SET AudU_AsignadoA = " + Usu_ID
                         +      ", AudU_ArticulosConteoTotal = " + Cantidad
                         +      ", AudU_TerminadoFecha = getdate() "  
                         +      ", AudU_Comentario = '" + Comentario + "'"
                         +      ", AudU_Terminado = 1 " 
                         +      ", AudU_HallazgoCG144 = " + Hallazgo
                         + " WHERE Aud_ID = " + Aud_ID 
                         +   " AND Pt_ID = " + Pt_ID
                         +   " AND AudU_Terminado = 0 "
                         +   " AND AudU_ConteoInterno = " + Interno

                  if(Ejecuta(sSQL,0))
				  {
					 sResultado = '{"result":1,"message":"La papeleta fue actualizada correctamente","Tarea":' + Tarea + '}'	
				  }
				  else
				  {
					 sResultado = '{"result":-1,"message":"Dato no guardado correctamente"}'	
				  }
                 
            
            } catch(err) {
                sResultado = '{"result":-1,"message":"Falla al actualizar los datos de la papeleta ","Tarea":' + Tarea + '}'
            }

        break; 
		case 4:	//Busca   
               
             var Aud_ID = Parametro("Aud_ID",-1)
                               
			var sSQL = "SELECT Usu_ID,Aud_Externo FROM Auditorias_Auditores WHERE Aud_ID = "+Aud_ID
			var rsAud = AbreTabla(sSQL, 1, 0)
			var data = ""
				
			if(!(rsAud.EOF)){	 
				result = 1
				message = "Usuarios encontrados"	
				var coma = 0 
				while( !(rsAud.EOF) ){
					if(coma > 0){
						data += ","
					}  
						data += '{'
						data += '"Usu_ID":'+rsAud.Fields.Item("Usu_ID").Value 
						data += ',"Aud_Externo":'+rsAud.Fields.Item("Aud_Externo").Value 
						data +='}'
						rsAud.MoveNext
					coma++
				}
				rsAud.Close
				
			}else{
				result = -1
				message = "Usuarios no encontrados"	
				data = null
			}
            
			sResultado = '{"result":"'+result+'","message":"'+message+'","data":['+data+']}'
        break; 
    }

Response.Write(sResultado)
%>
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
            var CB  = Parametro("CB","")
			    CB = CB.replace("'", "-")            //  cambio apostrofes por guiones
			    CB = CB.replace(/^\s+|\s+$/g,"");   //   trim
            
            var IDUsu_Auditor = Parametro("IDUsu_Auditor",-1)
            var ConteoExterno = Parametro("ConteoExterno",-1)
            
			var result = -1
			var message = ""
            var sMensaje = ""
			var data = null

            try {
				if(IDUsu_Auditor > -1){
                    
					var ValidaLPN = "SELECT AudU_CodigoBarras " +
									" FROM Auditorias_Pallet a, Auditorias_Ubicacion b, Auditorias_Ciclicas c " +
									" WHERE Pt_LPN = '"+CB+"'" +
									" AND a.Aud_ID = " + Aud_ID +
									" AND a.Aud_ID = b.Aud_ID " +
									" AND a.Aud_ID = c.Aud_ID " +
									" AND a.Pt_ID = b.Pt_ID " +
									" AND b.AudU_Veces = c.Aud_VisitaActual " +
									" AND AudU_ConteoInterno = " +ConteoExterno
                    
					
					var rsLPN = AbreTabla(ValidaLPN, 1, 0)
					if(!rsLPN.EOF){
						CB = rsLPN.Fields.Item("AudU_CodigoBarras").Value
					}
					else 
					{
                       var sCondicion = " Aud_ID = "+Aud_ID
				       var PuedeAgregar = BuscaSoloUnDato("Aud_PermiteAgregarPallets","Auditorias_Ciclicas",sCondicion,-1,0)  
                       
                       if(PuedeAgregar == 1) {
						   
                          var sSQLNP = "SELECT Pt_ID "+
                                      " FROM Pallet "+
									  " WHERE Pt_LPN = '" + CB + "'"
                         
						 
						  rsLPN = AbreTabla(sSQLNP, 1, 0)
						  
						  if(!rsLPN.EOF){
							  var  AgregaPappeleta = "exec SPR_Auditoria_Generar_Papeletas @Opcion = 5,@Aud_ID ="+Aud_ID+" ,@Pt_ID = "+rsLPN.Fields.Item("Pt_ID").Value
							  Ejecuta(AgregaPappeleta,0)
						  
								var ValidaLPN = "SELECT AudU_CodigoBarras " +
												" FROM Auditorias_Pallet a, Auditorias_Ubicacion b, Auditorias_Ciclicas c " +
												" WHERE Pt_LPN = '"+CB+"'" +
												" AND a.Aud_ID = " + Aud_ID +
												" AND a.Aud_ID = b.Aud_ID " +
												" AND a.Aud_ID = c.Aud_ID " +
												" AND a.Pt_ID = b.Pt_ID " +
												" AND b.AudU_Veces = c.Aud_VisitaActual ";
												//" AND AudU_ConteoInterno = " +ConteoExterno
	
							  rsLPN = AbreTabla(ValidaLPN, 1, 0)
	
								  if(!rsLPN.EOF){
									CB = rsLPN.Fields.Item("AudU_CodigoBarras").Value
								  } 
						  }else{
							 CB = -1; 
						  } 
					   }
                    }
					 rsLPN.Close()
					
					var sSQL = "select u.Pt_ID, AudU_ID, AudU_Veces, AudU_AsignadoA, AudU_Terminado "
							 +      ", AudU_TerminadoFecha, AudU_MBCantidad, AudU_MBCantidadArticulos "
							 +      ", AudU_ArticulosConteoTotal, AudU_FechaConteo, AudU_TipoConteoCG142 "
							 +      ", AudU_HallazgoCG144, AudU_Comentario, AudU_FechaRegistro, AudU_EnProceso "
							 +      ", AudU_MBCantidadSobrante, AudU_ConteoInterno, AudU_ImpresionPapeleta "
							 +      ", Pt_LPN, Pt_SKU, Ubi_Nombre, ISNULL(Ubi_Etiqueta,'') as Etiqueta "
							 +      ", Pro_SKU, Pro_Nombre "
							 +      ", (SELECT COUNT(*) FROM Inventario "
                                     + " WHERE Pt_ID = u.Pt_ID AND Inv_EnAlmacen = 1) CantidadActual "
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
							 +   " AND AudU_ConteoInterno =  "+ConteoExterno
							 +   " AND u.AudU_Veces = ac.Aud_VisitaActual "
							 
							 //Response.Write(sSQL)
							 
							
	
					var rsPallet = AbreTabla(sSQL, 1, 0)
	
					if(!rsPallet.EOF){
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
						data += ',"CantidadActual":"' +  rsPallet.Fields.Item("CantidadActual").Value  + '"' 
						data += ',"CB":"' +  CB  + '"' 
						data += ',"SQL":"' +  ValidaLPN  + '"' 
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
						}
						else{
							data += ', "DatoAudi": null '
						}
						rsPallet.Close()
					}
					else{
						result = 2
						message = "No se encontro una papeleta "+CB+" con ese codigo, avisar al administrador"
						data = '"datos": "'+sSQL+'"'

					}
				
				}else{
					result = -1
					message = "No se encontro la configuraci&oacute;n del auditor"
					data = '"datos": {"Aud_ID":'+Aud_ID+', "Usu_ID":'+IDUsu_Auditor+'}'
				}
 	
            }catch(err) {
				result = 2
				message = "Falla al agregar al auditor"
				data = '"data": '+data
            }
			sResultado = '{"result":"'+result+'","message":"'+message+'" ,"Tarea":' + Tarea + ',"data":{'+data+'}}'
			
        break; 
		case 3:	//busca un codigo de barras de una auditoria a recibir   
               
             var Aud_ID = Parametro("Aud_ID",-1)
             var Cantidad = Parametro("Cantidad",0)
             var Comentario = utf8_decode(Parametro("Comentario",""))
             var Pt_ID = Parametro("Pt_ID",-1)
             var UsuAud_ID = Parametro("UsuAud_ID",-1)
             var Hallazgo = Parametro("Hallazgo",-1)
             var ConteoExterno = Parametro("ConteoExterno",-1)
			 var AudU_CodigoBarras = Parametro("CB",-1)
			 var AudU_Veces = Parametro("AudU_Veces",-1)
             var data = "null"   
				                     
             try {
                var sSQLu = "UPDATE Auditorias_Ubicacion "
                         +   " SET AudU_AsignadoA = " + UsuAud_ID
                         +      ", AudU_ArticulosConteoTotal = " + Cantidad
                         +      ", AudU_TerminadoFecha = getdate() "  
                         +      ", AudU_Comentario = '" + Comentario + "'"
                         +      ", AudU_Terminado = 1 " 
                         +      ", AudU_HallazgoCG144 = " + Hallazgo
                         + " WHERE Aud_ID = " + Aud_ID 
                         +   " AND Pt_ID = " + Pt_ID
                         +   " AND AudU_CodigoBarras = " + AudU_CodigoBarras
                         +   " AND AudU_Terminado = 0 "
                         +   " AND AudU_ConteoInterno = " + ConteoExterno
						 +   " AND AudU_Veces = " + AudU_Veces

                  if(Ejecuta(sSQLu,0)){					  
					 var ActualizaPallet = "UPDATE Pallet SET Pt_Auditado = 1 WHERE Pt_ID = "+Pt_ID
					 Ejecuta(ActualizaPallet,0)
					 result = 1
					 message = "Cantidad auditada ha sido colocada correctamente"
					 
					 var CantidadExacta = "SELECT CASE  " +
										" WHEN b.PT_Cantidad_Actual = AudU_ArticulosConteoTotal " +
										" THEN '&iexcl;&iexcl;Coincidenica exacta!!, ya se puede colocar el pallet '+b.Pt_LPN+' en ubicaci&oacute;n' " +
										" WHEN b.PT_Cantidad_Actual < AudU_ArticulosConteoTotal " +
										" THEN 'Sobrante, lo sentimos la cantidad contada dio m&aacute;s de lo esperado' " +
										" WHEN b.PT_Cantidad_Actual > AudU_ArticulosConteoTotal " +
										" THEN 'Faltante, lo sentimos la cantidad dio menor a la esperada, se recomienda no regresar el pallet '+b.Pt_LPN+' a su ubicaci&oacute;n' " +
										" END Resultado " +
										" ,CASE " +
										" WHEN b.PT_Cantidad_Actual = AudU_ArticulosConteoTotal " +
										" THEN 0 " +
										" WHEN b.PT_Cantidad_Actual < AudU_ArticulosConteoTotal " +
										" THEN 1 " +
										" WHEN b.PT_Cantidad_Actual > AudU_ArticulosConteoTotal " +
										" THEN -1 " +
										" END ResultadoAlert " +
										" ,PT_Cantidad_Actual,AudU_ArticulosConteoTotal " +
										" fROM Auditorias_Ubicacion a, Auditorias_Pallet b " +
										" WHERE a.Aud_ID = " + Aud_ID +
										" AND a.Aud_ID = b.Aud_ID " +
										" AND a.Pt_ID = b.Pt_ID " +
										" AND  AudU_CodigoBarras = "+AudU_CodigoBarras
					
	
					var rsCon = AbreTabla(CantidadExacta, 1, 0)
	
					if(!rsCon.EOF){
						data  = '{"Conclusion" :'
						data +='{"Resultado":"' +  rsCon.Fields.Item("Resultado").Value  + '"'
						data += ',"ResultadoAlert":' +  rsCon.Fields.Item("ResultadoAlert").Value 
						data += ',"CantidadPallet":' +  rsCon.Fields.Item("PT_Cantidad_Actual").Value 
						data += ',"CantidadConteo":' +  rsCon.Fields.Item("AudU_ArticulosConteoTotal").Value 
						data += ',"SQL":"'+sSQLu+'"'  
						data += '}}'  
					}
					rsCon.Close()
					 
				  } else {
					 result = -1
					 message = "Ocurri&oacute; un error al guardar, intente de nuevo"
					 data = '{"Tarea":"3","query":"' + sSQLu + '" }'	
				  }
            } catch(err) {
					 result = -1
					 message = "Falla al actualizar los datos de la papeleta"
					 data = '{"Tarea":' + Tarea + '}'
            }
			sResultado = '{"result":'+result+',"message":"'+message+'","data":'+data+'}'
				
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
		case 5:
             var Aud_ID = Parametro("Aud_ID",-1)
             var Aud_Externo = Parametro("Aud_Externo",-1)
			 if(Aud_Externo == 0){
				 Aud_Externo = 1
			 }else{
				 Aud_Externo = 0
			 }
		 
			var sEventos = " class='form-control cbo' onchange='Papeleta.AuditorEscogido($(this))' "
			var sCondicion = " Aud_ID = " + Aud_ID+ " AND Aud_Externo = "+Aud_Externo
			CargaCombo("UsuAud_ID",sEventos,"IDUnico","(SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](IDUnico)) Nombre","Auditorias_Auditores",sCondicion,"(SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](IDUnico))",-1,0,"Seleccione un auditor")
						
		
		break;
		case 6: //Concluir auditoria ROG jr 29/08/2021 solicitud dos días antes de la auditoria :)
            var Aud_ID = Parametro("Aud_ID",-1)
			var data = null 
			
			var sQSLConcluir = "SELECT COUNT(*) Total " +
				" ,SUM(CASE WHEN b.AudU_ConteoInterno = 1 THEN 1 ELSE 0 END) AuditorInterno " +
				" ,SUM(CASE WHEN b.AudU_ConteoInterno = 0 THEN 1 ELSE 0 END) AuditorExterno " +
				" frOM Auditorias_Ciclicas  a,Auditorias_Ubicacion b " +
				" WHERE a.Aud_ID =  " +Aud_ID +
				" AND  a.Aud_ID = b.Aud_ID " +
				" AND AudU_Terminado = 0";
				
			var rsCon = AbreTabla(sQSLConcluir, 1, 0)
			var data = ""
				
			if(!rsCon.EOF){
				var total = rsCon.Fields.Item("Total").Value
				data = '{"Total":'+total +
						',"AuditorInterno":'+rsCon.Fields.Item("AuditorInterno").Value +
						',"AuditorExterno":'+rsCon.Fields.Item("AuditorExterno").Value +
						'}';
				if(total == 0){
					var upAud = "UPDATE Auditorias_Ciclicas SET Aud_EstatusCG141 = 3 WHERE Aud_ID = "+Aud_ID;
					if(Ejecuta(upAud,0)){
						result = 1;	
						message = "Aditoria concluida con exito";
					}else{
						result = -2;	
						message = "Ocurri&oacute; un error al actualizar";
					}
						
				}else{
					result = 0;	
					message = "Lo sentimos no se puede concluir la auditoria";	
				}
			}
			rsCon.Close()
										
			sResultado = '{"result":"'+result+'","message":"'+message+'","data":'+data+'}'
		break;
		
    }

Response.Write(sResultado)
%>
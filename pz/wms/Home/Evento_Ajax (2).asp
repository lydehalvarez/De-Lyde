<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",0)
	var ibQ4Web = false
		 
	var iEveID = Parametro("Eve_ID",-1)
	var iEveTipID = Parametro("EveTip_ID",-1) 
	var sEveTitulo = utf8_decode(Parametro("Eve_Titulo",""))
	var sEveDescripcion = utf8_decode(Parametro("Eve_Descripcion",""))
	 
	var sEveFechaInicio = Parametro("Eve_FechaInicio","")
	var sEveHoraInicio = Parametro("Eve_HoraInicio","") 
	var sEveFechaFin = Parametro("Eve_FechaFin","") 
	var sEveHoraFin = Parametro("Eve_HoraFin","") 
	var iEveUsuarioAlta = Parametro("Eve_UsuarioAlta",-1) 
	 
	var sResultado = "1"	 
	
	//Evento
	//Eve_ID, EveTip_ID, Eve_Titulo, Eve_Descripcion, Eve_FechaInicio, Eve_HoraInicio, Eve_FechaFin, Eve_HoraFin, Eve_UsuarioAlta, Eve_FechaRegistro
	 
	switch (parseInt(Tarea)) {
	 		//New
	 		case 1:
	 				try {
	 
							var sCondEve = "EveTip_ID = " + iEveTipID
							var iNvoEveID = BuscaSoloUnDato("ISNULL((MAX(Eve_ID) + 1),0)","Evento",sCondEve,0,0)	 						
	 
							var sInsertEve  = " INSERT Evento "
								sInsertEve += " (Eve_ID, EveTip_ID, Eve_Titulo, Eve_Descripcion, Eve_FechaInicio, Eve_HoraInicio, Eve_FechaFin, Eve_HoraFin, Eve_UsuarioAlta)"
								sInsertEve += " VALUES(" + iNvoEveID + "," + iEveTipID + ",'" + sEveTitulo + "','" + sEveDescripcion + "'" 
								sInsertEve += ",'" + CambiaFormatoFecha(sEveFechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR) + "'"
	 							sInsertEve += ",'" + sEveHoraInicio + "'"
	 							sInsertEve += ",'" + CambiaFormatoFecha(sEveFechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR) + "'"
	 							sInsertEve += ",'" + sEveHoraFin + "'"
	 							sInsertEve += "," + iEveUsuarioAlta
	 							sInsertEve += ")"	 
	 							
	 							if(ibQ4Web){ Response.Write(sInsertEve) }
	 							Ejecuta(sInsertEve,0)	
	 
	 							sResultado = iNvoEveID + "|" + iEveTipID
	 
	 				}
					catch(err) {
						sResultado = "-1|-1"
					}
	 
	 				Response.Write(sResultado)
	 
			break;
	 		//Edit
	 		case 2:
	 				try {

	 						var sUpdateEve = " UPDATE Evento SET "
	 								sUpdateEve += " Eve_Titulo = '" + sEveTitulo + "'"
	 								sUpdateEve += ",Eve_Descripcion = '" + sEveDescripcion + "'"
	 								sUpdateEve += ",Eve_FechaInicio = '" + CambiaFormatoFecha(sEveFechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR) + "'"
	 								sUpdateEve += ",Eve_HoraInicio = '" + sEveHoraInicio + "'"
	 								sUpdateEve += ",Eve_FechaFin = '" + CambiaFormatoFecha(sEveFechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR) + "'"
	 								sUpdateEve += ",Eve_HoraFin = '" + sEveHoraFin + "'"
	 								sUpdateEve += ",Eve_UsuarioEdita = " + iEveUsuarioAlta
	 								sUpdateEve += " WHERE Eve_ID = " + iEveID
	 								sUpdateEve += " AND EveTip_ID = " + iEveTipID
	 								
	 								if(ibQ4Web){ Response.Write(sUpdateEve) }
	 								Ejecuta(sUpdateEve,0)
	 
	 								sResultado = iEveID + "|" + iEveTipID	
	 
	 				}
					catch(err) {
						sResultado = "-1|-1"
					}
	 
	 				Response.Write(sResultado)
	 
	 		break;
	 		//Delete
	 		case 3:
	 				try {

	 						var sDeleteEve = " DELETE FROM Evento "
	 								sDeleteEve += " WHERE Eve_ID = " + iEveID
	 								sDeleteEve += " AND EveTip_ID = " + iEveTipID
	 								
	 								if(ibQ4Web){ Response.Write(sDeleteEve) }
	 								Ejecuta(sDeleteEve,0)
	 
	 								sResultado = iEveID + "|" + iEveTipID	
	 
	 				}
					catch(err) {
						sResultado = "-1|-1"
					}
	 
	 				Response.Write(sResultado)
	 
	 		break;
	 		
	 
	}
	 
%>	 

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
    var Tarea = Parametro("Tarea",0)
    var OC_ID = Parametro("OC_ID",-1)
    var OCSeg_ID = Parametro("OCSeg_ID",-1)
    var IDUsuario = Parametro("IDUsuario",-1)
   
 	var sResultado = 0

	switch (parseInt(Tarea)) {
		case 1:
		var OCSeg_IMEI = Parametro("OCSeg_IMEI","")
		var OCSeg_ICC = Parametro("OCSeg_ICC","")

			if(OCSeg_ID == -1){
			try {
					sCond = " OC_ID = " + OC_ID
					OCSeg_ID = BuscaSoloUnDato("ISNULL((MAX(OCSeg_ID)),0)+1","Izzi_Orden_Venta_Seguimiento",sCond,-1,0)
	
					var sSQL = " INSERT INTO Izzi_Orden_Venta_Seguimiento (OC_ID, OCSeg_ID) "
						sSQL += " VALUES (" +OC_ID +"," +OCSeg_ID+")"
	
						Ejecuta(sSQL, 0)
						
				} catch (err) {
					sResultado = -1
				}
			}
				try {
					var sUPD  = " UPDATE Izzi_Orden_Venta_Seguimiento "
						sUPD += " SET OCSeg_IMEI = '"+OCSeg_IMEI+"'"
						sUPD += " ,OCSeg_ICC = '"+OCSeg_ICC+"'"
						sUPD += " ,OCSeg_UsuarioPaso1 = '"+IDUsuario+"'"
						sUPD += " ,OCSeg_FechaPaso1 = getdate() "
						sUPD += " ,OCSeg_Paso = 2 "
						sUPD += " WHERE OC_ID = " + OC_ID
						sUPD += " AND OCSeg_ID = " + OCSeg_ID
						
						
						Ejecuta(sUPD,0)
						
						sResultado = OCSeg_ID
						
					} catch (err) {
						sResultado = -2 
					}
		break;
		case 2:
		var OCSeg_Guia = Parametro("OCSeg_Guia","")
		var Trans_ID = Parametro("Trans_ID",-1)
		
			try {
				var sUPD  = " UPDATE Izzi_Orden_Venta_Seguimiento "
					sUPD += " SET OCSeg_Guia = '"+OCSeg_Guia+"'"
					sUPD += " ,Trans_ID = "+ Trans_ID
					sUPD += " ,OCSeg_UsuarioPaso2 = '"+IDUsuario+"'"
					sUPD += " ,OCSeg_FechaPaso2 = getdate() "
					sUPD += " ,OCSeg_Paso = 3 "
					sUPD += " WHERE OC_ID = " + OC_ID
					sUPD += " AND OCSeg_ID = " + OCSeg_ID
					
					
					Ejecuta(sUPD,0)
					
					sResultado = OCSeg_ID
					
				} catch (err) {
					sResultado = -2
				}
		break;
		case 3:
		var OCSeg_ConfirmaEntrega = Parametro("OCSeg_ConfirmaEntrega",-1)
			try {
				var sUPD  = " UPDATE Izzi_Orden_Venta_Seguimiento "
					sUPD += " SET OCSeg_ConfirmaEntrega = "+ OCSeg_ConfirmaEntrega
					sUPD += " ,OCSeg_UsuarioConfirma = '"+IDUsuario+"'"
					sUPD += " ,OCSeg_ConfirmaFecha = getdate() "
					sUPD += " ,OCSeg_Paso = 4 "
					sUPD += " WHERE OC_ID = " + OC_ID
					sUPD += " AND OCSeg_ID = " + OCSeg_ID
					
					
					Ejecuta(sUPD,0)
					
					sResultado = OCSeg_ID
					
				} catch (err) {
					sResultado = -2
				}
		break;
	}
Response.Write(sResultado)

%>   

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUN-23 Se crea el Archivo
// HA ID: 2 2020-JUN-25 Se Agrega opcion de Cancelación de Orden de Venta

var rqIntTarea = Parametro("Tarea",0)

switch (parseInt(rqIntTarea)) {
	//Actualizacion de Datos Generales de la Orden de Venta
	case 1: {
		
		var errADGError = 0; 
		
		var rqIntADGOV_ID = Parametro("OV_ID", -1)
		var rqStrADGCalle = utf8_decode(Parametro("Calle", ""))   
		var rqStrADGNumeroExterior = utf8_decode(Parametro("NumeroExterior", ""))
		var rqStrADGNumeroInterior = utf8_decode(Parametro("NumeroInterior", ""))
		var rqStrADGColonia = utf8_decode(Parametro("Colonia", ""))
		var rqStrADGDelegacion = utf8_decode(Parametro("Delegacion", ""))
		var rqStrADGCiudad = utf8_decode(Parametro("Ciudad", ""))
		var rqStrADGEstado = utf8_decode(Parametro("Estado", ""))
		var rqStrADGCodigoPostal = utf8_decode(Parametro("CodigoPostal", ""))
		var rqStrADGTelefono = utf8_decode(Parametro("Telefono", ""))
		var rqStrADGEmail = utf8_decode(Parametro("Email", ""))
		
		var sqlADG = "UPDATE Orden_Venta "
			+ "SET OV_Calle = '" + rqStrADGCalle + "' "
				+ ", OV_NumeroExterior = '" + rqStrADGNumeroExterior + "' "
				+ ", OV_NumeroInterior = '" + rqStrADGNumeroInterior + "' "
				+ ", OV_CP = '" + rqStrADGCodigoPostal + "' "
				+ ", OV_Colonia = '" + rqStrADGColonia + "' "
				+ ", OV_Delegacion = '" + rqStrADGDelegacion + "' "
				+ ", OV_Ciudad = '" + rqStrADGCiudad + "' "
				+ ", OV_Estado = '" + rqStrADGEstado + "' "
				+ ", OV_Telefono = '" + rqStrADGTelefono + "' "
				+ ", OV_Email = '" + rqStrADGEmail + "' "
			+ "WHERE OV_ID = " + rqIntADGOV_ID
		
		try {
		
			Ejecuta(sqlADG, 0)
			
		} catch(err) {
			
			errADGError = 1
			
		}
		
		Response.Write(errADGError)
		
	} break;
	
	// HA ID: 2 INI Bloque de Cancelación de Orden de Venta
	//Cancelación de Orden de Compra
	case 2: {
		
		var errCanError = 0
		
		var rqIntCanOV_ID = Parametro("OV_ID", -1)
		var rqStrCanMotivoCancelacion = utf8_decode(Parametro("MotivoCancelacion", ""))
		var rqIntCanIzziCancela = Parametro("IzziCancela", 0)
		
		var ssIntIdUnica = Parametro("IDUsuario", -1)
		
		//rqIntCanOV_ID = 454
		
		var sqlCan = "UPDATE Orden_Venta "
			+ "SET OV_EstatusCG51 = 11 /* Cancelado */ "
				+ ", OV_Cancelada = 1 "
				+ ", OV_CancelacionFecha = GETDATE() "
				+ ", OV_UsuarioIzziCancela = " + rqIntCanIzziCancela + " "
				+ ", OV_UsuarioCancela = " + ssIntIdUnica + " "
				+ ", OV_MotivoCancelacion = '" + rqStrCanMotivoCancelacion + "' "
			+ "WHERE OV_ID = " + rqIntCanOV_ID + " "
		
		try {
		
			Ejecuta(sqlCan, 0) 
			
		} catch(err) {
		
			errCanError = 1
			
		}
		
		Response.Write(errCanError)
		
	} break;
	
	// HA ID: 2 FIN
}

%>
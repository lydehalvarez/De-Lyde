<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
//HA ID: 1 2020-JUN-23 Se crea el Archivo

var Tarea = Parametro("Tarea",0)

switch (parseInt(Tarea)) {
	
	case 1: {
		
		var Error = 0; 
		
		var rqIntOV_ID = Parametro("OV_ID", -1)
		var rqStrCalle = utf8_decode(Parametro("Calle", ""))   
		var rqStrNumeroExterior = Parametro("NumeroExterior", "")
		var rqStrNumeroInterior = Parametro("NumeroInterior", "")
		var rqStrColonia = Parametro("Colonia", "")
		var rqStrDelegacion = Parametro("Delegacion", "")
		var rqStrCiudad = Parametro("Ciudad", "")
		var rqStrEstado = Parametro("Estado", "")
		var rqStrCodigoPostal = Parametro("CodigoPostal", "")
		var rqStrTelefono = Parametro("Telefono", "")
		var rqStrEmail = Parametro("Email", "")
		
		var strSql = "UPDATE Orden_Venta "
			+ "SET OV_Calle = '" + rqStrCalle + "' "
				+ ", OV_NumeroExterior = '" + rqStrNumeroExterior + "' "
				+ ", OV_NumeroInterior = '" + rqStrNumeroInterior + "' "
				+ ", OV_CP = '" + rqStrCodigoPostal + "' "
				+ ", OV_Colonia = '" + rqStrColonia + "' "
				+ ", OV_Delegacion = '" + rqStrDelegacion + "' "
				+ ", OV_Ciudad = '" + rqStrCiudad + "' "
				+ ", OV_Estado = '" + rqStrEstado + "' "
				+ ", OV_Telefono = '" + rqStrTelefono + "' "
				+ ", OV_Email = '" + rqStrEmail + "' "
			+ "WHERE OV_ID = " + rqIntOV_ID
		
		try {
		
			Ejecuta(strSql, 0)
			
		} catch(err) {
			
			Error = 1
			
		}
		
		Response.Write(Error)
		
	} break;
	
}

%>
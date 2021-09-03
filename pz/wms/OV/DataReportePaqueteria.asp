<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%><!--#include file="../../../Includes/iqon.asp" -->[<%

var Prov_ID = Parametro("Prov_ID",-1)
var Rango = Parametro("Rango",-1)
var FechaInicio = Parametro("FechaInicio",-1)
var FechaFinal = Parametro("FechaFinal",-1)

var Hora1 = ""
var Hora2 = ""
	if(Rango == 1){
		Hora1 = "10:00:00"
		Hora2 = "16:00:00"
	}else{
		Hora1 = "16:00:00"
		Hora2 = "10:00:00"
	}

	var sSQLOV = "SELECT ISNULL(p.OV_Folio,'') Folio " 
		sSQLOV += ",ISNULL(p.OV_TRACKING_NUMBER,'') Guia ,ISNULL(p.OV_CUSTOMER_SO,'') CSO "
		sSQLOV += ",ISNULL(p.OV_CUSTOMER_NAME,'') Name ,ISNULL(p.OV_Calle,'') Calle,ISNULL(p.OV_NumeroExterior,'') Ext "
		sSQLOV += ",ISNULL(p.OV_NumeroInterior,'') Int,ISNULL(p.OV_CP,'') CP ,ISNULL(p.OV_Colonia,'') col,ISNULL(p.OV_Delegacion,'') del "
		sSQLOV += ",ISNULL(p.OV_Ciudad,'') Ciu,ISNULL(p.OV_Estado,'') Edo ,ISNULL(p.OV_Pais,'') Pai ,ISNULL(p.OV_Telefono,'') Tel "
		sSQLOV += ",ISNULL(p.OV_Email,'') Ema ,ISNULL(p.OV_ReferenciaDomicilio1,'') Ref1,ISNULL(p.OV_ReferenciaDomicilio2,'') ref2 "
		sSQLOV += ",ISNULL(p.OV_ReferenciaTelefono,'') reftel,ISNULL(p.OV_ReferenciaPersona,'') refPer "
		sSQLOV += ",dbo.fn_CatGral_DameDato(51,p.OV_EstatusCG51) as Estatus  "
		sSQLOV += " FROM Orden_Venta p "
		sSQLOV += " WHERE OV_ID in ( "
		sSQLOV +=  "SELECT distinct o.OV_ID "
		sSQLOV += " FROM Orden_Venta o, [dbo].[Proveedor_Guia] g, [dbo].[Orden_Venta_Historico_Direccion] h "
		sSQLOV += " WHERE o.OV_ID = g.OV_ID AND o.OV_ID = h.OV_ID "
		sSQLOV += " AND g.Prov_ID = " + Prov_ID
		sSQLOV += " AND  o.OV_TRACKING_NUMBER = g.[ProG_NumeroGuia] "
		sSQLOV += " AND  h.OV_FechaCambio BETWEEN '"+FechaInicio+" "+Hora1+"' AND '"+FechaFinal+" "+Hora2+"') "
		
	//Response.Write(sSQLOV)

	var i = 0

		var rsRTI = AbreTabla(sSQLOV,1,0)
		while (!rsRTI.EOF){
			var OV_Folio = DSITrim(rsRTI.Fields.Item("Folio").Value)
			var OV_TRACKING_NUMBER = DSITrim(rsRTI.Fields.Item("Guia").Value) 
			var OV_CUSTOMER_SO = DSITrim(rsRTI.Fields.Item("CSO").Value) 
			var OV_CUSTOMER_NAME = DSITrim(rsRTI.Fields.Item("Name").Value) 
			var OV_Calle = DSITrim(rsRTI.Fields.Item("Calle").Value) 
			var OV_NumeroExterior = DSITrim(rsRTI.Fields.Item("Ext").Value) 
			var OV_NumeroInterior = DSITrim(rsRTI.Fields.Item("Int").Value) 
			var OV_CP = DSITrim(rsRTI.Fields.Item("CP").Value) 
			var OV_Colonia = DSITrim(rsRTI.Fields.Item("col").Value) 
			var OV_Delegacion = DSITrim(rsRTI.Fields.Item("del").Value) 
			var OV_Ciudad = DSITrim(rsRTI.Fields.Item("Ciu").Value) 
			var OV_Estado = DSITrim(rsRTI.Fields.Item("Edo").Value) 
			var OV_Pais = DSITrim(rsRTI.Fields.Item("Pai").Value) 
			var OV_Telefono = DSITrim(rsRTI.Fields.Item("Tel").Value) 
			var OV_Email = DSITrim(rsRTI.Fields.Item("Ema").Value) 
			var OV_ReferenciaDomicilio1 = DSITrim(rsRTI.Fields.Item("Ref1").Value) 
			var OV_ReferenciaDomicilio2 = DSITrim(rsRTI.Fields.Item("ref2").Value) 
			var OV_ReferenciaTelefono = DSITrim(rsRTI.Fields.Item("reftel").Value) 
			var OV_ReferenciaPersona = DSITrim(rsRTI.Fields.Item("refPer").Value) 
			var Estatus = DSITrim(rsRTI.Fields.Item("Estatus").Value) 
			
				
%>{
    "OV_Folio":"<%=OV_Folio%>",
    "OV_TRACKING_NUMBER":"<%=OV_TRACKING_NUMBER%>",
    "OV_CUSTOMER_SO":"<%=OV_CUSTOMER_SO%>",
    "OV_CUSTOMER_NAME":"<%=OV_CUSTOMER_NAME%>",
    "OV_Calle":"<%=OV_Calle%>",
    "OV_NumeroExterior":"<%=OV_NumeroExterior%>",
    "OV_NumeroInterior":"<%=OV_NumeroInterior%>",
    "OV_CP":"<%=OV_CP%>",
    "OV_Colonia":"<%=OV_Colonia%>",
    "OV_Delegacion":"<%=OV_Delegacion%>",
    "OV_Ciudad":"<%=OV_Ciudad%>",
    "OV_Estado":"<%=OV_Estado%>",
    "OV_Pais":"<%=OV_Pais%>",
    "OV_Telefono":"<%=OV_Telefono%>",
    "OV_Email":"<%=OV_Email%>",
    "OV_ReferenciaDomicilio1":"<%=OV_ReferenciaDomicilio1.replace(/['"]+/g, '').replace(":", '').replace('\t','')%>",
    "OV_ReferenciaDomicilio2":"<%=OV_ReferenciaDomicilio2.replace(/['"]+/g, '').replace(":", '').replace('\t','')%>",
    "OV_ReferenciaTelefono":"<%=OV_ReferenciaTelefono%>",
    "OV_ReferenciaPersona":"<%=OV_ReferenciaPersona%>",
    "Estatus":"<%=Estatus%>"
} <%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %>

<%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>]
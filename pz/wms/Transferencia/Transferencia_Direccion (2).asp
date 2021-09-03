<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	var TA_TipoTransferenciaCG65 = Parametro("TA_TipoTransferenciaCG65",-1)


if(TA_TipoTransferenciaCG65 == 2){

	var sSQLO = "SELECT TA_Folio  "
		sSQLO += ",'Sucursal Izzi '+(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		sSQLO += ",(SELECT Alm_Responsable FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Reponsable_Contacto "
		sSQLO += ",(SELECT Alm_RespTelefono FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Telefono_Contacto "
		sSQLO += ",(SELECT Alm_DireccionCompleta FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Direccion_Detino "

		sSQLO += ",(SELECT Alm_Calle FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_Calle "
		sSQLO += ",(SELECT Alm_NumExt FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_NumExt "
		sSQLO += ",(SELECT Alm_NumInt FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_NumInt "
		sSQLO += ",(SELECT Alm_Colonia FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_Colonia "
		sSQLO += ",(SELECT Alm_Delegacion FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_Delegacion "
		sSQLO += ",(SELECT Alm_Ciudad FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_Ciudad "
		sSQLO += ",(SELECT Alm_CP FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_CP "
		sSQLO += ",(SELECT Alm_Estado FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_Estado "
		sSQLO += ",(SELECT Alm_Pais FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_Pais "
		sSQLO += ",(SELECT Alm_RespEmail FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Alm_RespEmail "

		sSQLO += ",'Es una sucursal Izzi' as Refrencias_Transportistas "
		sSQLO += "FROM [dbo].[TransferenciaAlmacen] h "
		sSQLO += "WHERE TA_ID in (SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_ArchivoID = "+TA_ArchivoID+") "

var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var TA_Folio =  rsJson.Fields.Item("TA_Folio").Value
	var Sucursal_Destino =  rsJson.Fields.Item("Sucursal_Destino").Value
	var Reponsable_Contacto =  rsJson.Fields.Item("Reponsable_Contacto").Value
	var Telefono_Contacto =  rsJson.Fields.Item("Telefono_Contacto").Value
	var Alm_Calle =  rsJson.Fields.Item("Alm_Calle").Value
	var Alm_NumExt =  rsJson.Fields.Item("Alm_NumExt").Value
	var Alm_NumInt =  rsJson.Fields.Item("Alm_NumInt").Value
	var Alm_Colonia =  rsJson.Fields.Item("Alm_Colonia").Value
	var Alm_Delegacion =  rsJson.Fields.Item("Alm_Delegacion").Value
	var Alm_Ciudad =  rsJson.Fields.Item("Alm_Ciudad").Value
	var Alm_CP =  rsJson.Fields.Item("Alm_CP").Value
	var Alm_Estado =  rsJson.Fields.Item("Alm_Estado").Value
	var Alm_Pais =  rsJson.Fields.Item("Alm_Pais").Value
	var Alm_RespEmail =  rsJson.Fields.Item("Alm_RespEmail").Value
%>{
    "EMPRESA":"IZZI",
    "CONTACTO":"<%=Reponsable_Contacto%>",
    "DIRECCION1":"<%=Alm_Calle%> <%=Alm_NumExt%>",
    "DIRECCION2":"<%=Alm_Colonia%>",
    "DIRECCION3":"<%=Alm_NumInt%>",
    "CIUDAD":"<%=Alm_Colonia%>",
    "ESTADO":"<%=Alm_Estado%>",
    "CP":"<%=Alm_CP%>",
    "PAIS":"<%=Alm_Pais%>",
    "TELEFONO":"<%=Telefono_Contacto%>",
    "EMAIL":"<%=Alm_RespEmail%>",
    "DESCRIPMERC":"",
    "NumPaquetes":"1",
    "Servicio":"SV",
    "TipoPaquete":"CP",
    "PesoPaq":"1",
    "PagoFlete":"SHP",
    "REF2":"<%=TA_Folio%>",
    "Email1":"upsentregaslyde@gmail.com",
    "Personaemail1":"Entregas Lyde",
    "Envio1":"Y",
    "Excepcion1":"Y"
    
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close()
}else if (TA_TipoTransferenciaCG65 == 1){

	var sSQLO = "SELECT TA_Folio  "
		sSQLO += ",'Sucursal Izzi '+(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		sSQLO += ",(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		sSQLO += ",(SELECT Alm_Responsable FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Reponsable_Contacto "
		sSQLO += ",(SELECT Alm_RespTelefono FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Telefono_Contacto "
		sSQLO += ",(SELECT Alm_DireccionCompleta FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Direccion_Origen "
		sSQLO += ",(SELECT Alm_DireccionCompleta FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Direccion_Destino "
		sSQLO += ",'Es una sucursal Izzi' as Refrencias_Transportistas "
		sSQLO += "FROM [dbo].[TransferenciaAlmacen] h "
		sSQLO += "WHERE TA_ID in (SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_ArchivoID = "+TA_ArchivoID+") "


var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var TA_Folio =  rsJson.Fields.Item("TA_Folio").Value
	var Sucursal_Origen =  rsJson.Fields.Item("Sucursal_Origen").Value
	var Sucursal_Destino =  rsJson.Fields.Item("Sucursal_Destino").Value
	var Reponsable_Contacto =  rsJson.Fields.Item("Reponsable_Contacto").Value
	var Telefono_Contacto =  rsJson.Fields.Item("Telefono_Contacto").Value
	var Direccion_Origen =  rsJson.Fields.Item("Direccion_Origen").Value
	var Direccion_Destino =  rsJson.Fields.Item("Direccion_Destino").Value
%>{
    "Folio":"<%=TA_Folio%>",
    "Sucursal Origen":"<%=Sucursal_Origen%>",
    "Sucursal Destino":"<%=Sucursal_Destino%>",
    "Reponsable Contacto":"<%=Reponsable_Contacto%>",
    "Telefono Contacto":"<%=Telefono_Contacto%>",
    "Reponsable Destino":"<%=Reponsable_Destino%>",
    "Direccion Origen":"<%=Direccion_Origen%>",
    "Direccion Destino":"<%=Direccion_Destino%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close()
}else if(TA_TipoTransferenciaCG65 == 3){

	var sSQLO = "SELECT TA_Folio  "
		sSQLO += ",'Sucursal Izzi '(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		sSQLO += ",'Sucursal Izzi '(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		sSQLO += ",(SELECT Alm_Responsable FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Reponsable_Origen "
		sSQLO += ",(SELECT Alm_RespTelefono FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Telefono_Origen "
		sSQLO += ",(SELECT Alm_Responsable FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Reponsable_Destino "
		sSQLO += ",(SELECT Alm_RespTelefono FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Telefono_Destino "
		sSQLO += ",(SELECT Alm_DireccionCompleta FROM Almacen WHERE Alm_ID = h.TA_Start_Warehouse_ID) Direccion_Origen "
		sSQLO += ",(SELECT Alm_DireccionCompleta FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) Direccion_Destino "
		sSQLO += ",'Es una sucursal Izzi' as Refrencias_Transportistas "
		sSQLO += "FROM [dbo].[TransferenciaAlmacen] h "
		sSQLO += "WHERE TA_ID in (SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_ArchivoID = "+TA_ArchivoID+") "


var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var TA_Folio =  rsJson.Fields.Item("TA_Folio").Value
	var Sucursal_Origen =  rsJson.Fields.Item("Sucursal_Origen").Value
	var Sucursal_Destino =  rsJson.Fields.Item("Sucursal_Destino").Value
	var Reponsable_Origen =  rsJson.Fields.Item("Reponsable_Origen").Value
	var Telefono_Origen =  rsJson.Fields.Item("Telefono_Origen").Value
	var Reponsable_Destino =  rsJson.Fields.Item("Reponsable_Destino").Value
	var Direccion_Origen =  rsJson.Fields.Item("Direccion_Origen").Value
	var Direccion_Destino =  rsJson.Fields.Item("Direccion_Destino").Value
	var Refrencias_Transportistas =  rsJson.Fields.Item("Refrencias_Transportistas").Value
%>{
    "Folio":"<%=TA_Folio%>",
    "Sucursal Origen":"<%=Sucursal_Origen%>",
    "Sucursal Destino":"<%=Sucursal_Destino%>",
    "Reponsable Origen":"<%=Reponsable_Origen%>",
    "Telefono Origen":"<%=Telefono_Origen%>",
    "Reponsable Destino":"<%=Reponsable_Destino%>",
    "Direccion Origen":"<%=Direccion_Origen%>",
    "Direccion Destino":"<%=Direccion_Destino%>",
    "Referencias":"<%=Refrencias_Transportistas%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close()
}

%>]
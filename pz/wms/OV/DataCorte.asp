<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%

	var Cort_ID = Parametro("Cort_ID",-1)
	
	var sSQLOV = " SELECT  (SELECT OV_Folio FROM Orden_Venta WHERE OV_ID = p.OV_ID ) FolioLyde, OVP_Serie "
		sSQLOV += " ,(SELECT Pro_Nombre FROM Producto h, Inventario i WHERE h.Pro_ID = i.Pro_ID AND i.Inv_Serie = p.OVP_Serie) Nombre "
		sSQLOV += " ,(SELECT Pro_ClaveAlterna FROM Producto h, Inventario i WHERE h.Pro_ID = i.Pro_ID AND i.Inv_Serie = p.OVP_Serie) SKU "
		sSQLOV += " ,(SELECT Cort_ID FROM Orden_Venta WHERE OV_ID = p.OV_ID ) Corte "
		sSQLOV += " ,OVP_FechaRegistro "
		sSQLOV += " ,(SELECT [dbo].[fn_Usuario_DameUsuario](OVP_Usuario))  Usuario "
		sSQLOV += " FROM Orden_Venta_Picking p "
		sSQLOV += " WHERE (SELECT Cort_ID FROM Orden_Venta WHERE OV_ID = p.OV_ID ) = "+Cort_ID
		sSQLOV += " Order BY (SELECT Cort_ID FROM Orden_Venta WHERE OV_ID = p.OV_ID ) ASC "
   
   
		var i = 0
	
            var rsRTI = AbreTabla(sSQLOV,1,0)
            while (!rsRTI.EOF){
                var FolioLyde = rsRTI.Fields.Item("FolioLyde").Value 
                var OVP_Serie = rsRTI.Fields.Item("OVP_Serie").Value 
                var Nombre = rsRTI.Fields.Item("Nombre").Value 
                var SKU = rsRTI.Fields.Item("SKU").Value 
                var Usuario = rsRTI.Fields.Item("Usuario").Value 
                var OVP_FechaRegistro = rsRTI.Fields.Item("OVP_FechaRegistro").Value 
				
%>{
    "FolioLyde":"<%=FolioLyde%>",
    "OVP_Serie":"<%=OVP_Serie%>",
    "Nombre":"<%=Nombre%>",
    "SKU":"<%=SKU%>",
    "Usuario":"<%=Usuario%>",
    "Corte":"<%=Cort_ID%>",
    "Fecha Registro":"<%=OVP_FechaRegistro%>"
}<%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %><%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>
]
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
var Aud_ID = Parametro("Aud_ID",-1)

var sSQL  = "	select p.Pro_SKU as SKU, p.pro_Nombre, u.Ubi_Nombre "
				+", ap.Pt_LPN, ap.PT_Cantidad_Actual "
				+",ISNULL((select top 1 [AudU_ArticulosConteoTotal] from [dbo].[Auditorias_Ubicacion] u1 "
				+"where u1.pt_id = ap.pt_id and AudU_ConteoInterno = 1 and AudU_Veces = ac.Aud_VisitaActual "
				+"and [AudU_ArticulosConteoTotal] > 0),0) as ConteoInterno "
				+",ISNULL((select top 1 [AudU_ArticulosConteoTotal]  "
				+"from [dbo].[Auditorias_Ubicacion] u2  "
				+"where u2.pt_id = ap.pt_id and AudU_ConteoInterno = 0 and AudU_Veces = ac.Aud_VisitaActual "
				+"and [AudU_ArticulosConteoTotal] > 0 ),0) as ConteoExterno "
				+"from Auditorias_Pallet ap, Ubicacion u, Producto p, Auditorias_Ciclicas ac "
				+"where ap.Ubi_ID = u.Ubi_ID "  
				+"and ac.Aud_ID = ap.Aud_ID  "
				+"and ap.Pro_ID = p.Pro_ID "
				+"and ap.Aud_ID = " + Aud_ID 
				+"and ap.Pt_ResultadoCG147  = 3"
				+ " ORDER BY ap.Ubi_ID"
		var i = 0
		var rsRe = AbreTabla(sSQL,1,0)

	while (!rsRe.EOF){
  	     var Ubicacion = rsRe.Fields.Item("Ubi_Nombre").Value   
		 var LPN = rsRe.Fields.Item("Pt_LPN").Value   
	     var SKU  = rsRe.Fields.Item("SKU").Value 
		 var Producto  = rsRe.Fields.Item("pro_Nombre").Value
		 var Cantidad  = rsRe.Fields.Item("PT_Cantidad_Actual").Value   
		var ConteoInterno =  rsRe.Fields.Item("ConteoInterno").Value  
		var ConteoExterno =  rsRe.Fields.Item("ConteoExterno").Value   
 
	%>
    <%=(i > 0 ) ? "," : ""  %>
    {
    "Ubicacion":"<%=Ubicacion%>",
    "LPN":"<%=LPN%>",
    "SKU":"<%=SKU%>",
    "Producto":"<%=Producto%>",
    "Cantidad":"<%=Cantidad%>",
     "Conteo Interno":<%=ConteoInterno%>, 
     "Conteo Externo":<%=ConteoExterno%>
}
<%
i++;
            rsRe.MoveNext() 
        }
         rsRe.Close()   
       
%>]


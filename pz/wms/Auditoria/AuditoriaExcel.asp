<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
var Aud_ID = Parametro("Aud_ID",-1)
var Aud_HayConteoExterno = Parametro("Aud_HayConteoExterno",-1)
var Pt_ResultadoCG147 = Parametro("Pt_ResultadoCG147",-1)

var sSQL  = " SELECT p.Pro_SKU as SKU, p.pro_Nombre, u.Ubi_Nombre "
				+", ap.Pt_LPN, ap.PT_Cantidad_Actual "
				+",(SELECT AudU_ArticulosConteoTotal FROM Auditorias_Ubicacion WHERE Aud_ID = ap.AuD_ID AND Pt_ID = ap.Pt_ID AND AudU_Veces = Pt_VisitaActual  AND AudU_ConteoInterno = 1) as ConteoInterno "
				+",(SELECT AudU_ArticulosConteoTotal FROM Auditorias_Ubicacion WHERE Aud_ID = ap.AuD_ID AND Pt_ID = ap.Pt_ID  AND AudU_Veces = Pt_VisitaActual AND AudU_ConteoInterno = 0) as ConteoExterno "
				+",ap.Pt_VisitaActual"
				+" FROM Auditorias_Pallet ap, Ubicacion u, Producto p, Auditorias_Ciclicas ac "
				+" WHERE ap.Ubi_ID = u.Ubi_ID "  
				+" AND ac.Aud_ID = ap.Aud_ID  "
				+" AND ap.Pro_ID = p.Pro_ID "
				+" AND ap.Aud_ID = " + Aud_ID 
				+" AND ap.Pt_ResultadoCG147  = " +Pt_ResultadoCG147
				+ " ORDER BY ap.Ubi_ID"
		var i = 0
		var rsRe = AbreTabla(sSQL,1,0)
		
var Ubicacion = ""
var LPN = ""
var SKU = ""
var Producto = ""
var Cantidad = ""
var ConteoInterno = ""
var ConteoExterno = ""
var Pt_VisitaActual = ""


	while (!rsRe.EOF){
		Ubicacion = rsRe.Fields.Item("Ubi_Nombre").Value   
		LPN = rsRe.Fields.Item("Pt_LPN").Value   
		SKU  = rsRe.Fields.Item("SKU").Value 
		Producto  = rsRe.Fields.Item("pro_Nombre").Value
		Cantidad  = rsRe.Fields.Item("PT_Cantidad_Actual").Value   
		ConteoInterno =  rsRe.Fields.Item("ConteoInterno").Value  
		ConteoExterno =  rsRe.Fields.Item("ConteoExterno").Value   
		Pt_VisitaActual =  rsRe.Fields.Item("Pt_VisitaActual").Value   
 
	%>
    <%=(i > 0 ) ? "," : ""  %>
    {
    "Ubicacion":"<%=Ubicacion%>",
    "LPN":"<%=LPN%>",
    "SKU":"<%=SKU%>",
    "Producto":"<%=Producto%>",
    "Cantidad":"<%=Cantidad%>",
     "Conteo Interno":<%=ConteoInterno%>
     <%if(Aud_HayConteoExterno == 1){%> 
     ,"Conteo Externo":<%=ConteoExterno%>
     <%}%>
     ,"Ultimo conteo":<%=Pt_VisitaActual%>
}
<%
i++;
            rsRe.MoveNext() 
        }
         rsRe.Close()   
       
%>]


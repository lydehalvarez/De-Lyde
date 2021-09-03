<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
var Aud_ID = Parametro("Aud_ID",-1)
   
//el objetivo de esta impresion es determinar al iniciar la auditoria que s lo que se va a revisar
//se debe garantizar que lpn se consultaran de tal manera que no se agreguen o quiten durante el conteo   
   
var Aud_EsCiego = 0
var Aud_HayConteoExterno = 0
   
var sSQL = "select Aud_HayConteoExterno, ISNULL(Aud_EsCiego,1) as EsCiego "
         + " FROM Auditorias_Ciclicas ac "
         + " WHERE Aud_ID = " + Aud_ID
   
var rsPorc = AbreTabla(sSQL, 1, 0);

if( !(rsPorc.EOF) ){
    Aud_EsCiego  = rsPorc("EsCiego").Value
    Aud_HayConteoExterno  = rsPorc("Aud_HayConteoExterno").Value   
}

rsPorc.Close();

var sSQL  = "SELECT * " 
	sSQL += " , ConteoInterno - PT_Cantidad_Actual as Diferencia_Lyde " 
	
	if(Aud_HayConteoExterno == 1){
	sSQL += " , ConteoExterno - PT_Cantidad_Actual  as Diferencia_Cliente "
	sSQL += " , ConteoInterno - ConteoExterno as Diferencia_Lyde_Cliente " 
	}
	sSQL += " FROM ( " 
	sSQL +=" select p.Pro_SKU, p.pro_Nombre,u.Ubi_ID, u.Ubi_Nombre  " 
	sSQL +=" , ap.Pt_LPN " 
	sSQL +=" , ap.PT_Cantidad_Actual  " 
	sSQL += " ,(SELECT AudU_ArticulosConteoTotal FROM Auditorias_Ubicacion WHERE Aud_ID = ap.AuD_ID AND Pt_ID = ap.Pt_ID AND AudU_Veces = Pt_VisitaActual  AND AudU_ConteoInterno = 1) as ConteoInterno  " 
	if(Aud_HayConteoExterno == 1){
		sSQL += " ,(SELECT AudU_ArticulosConteoTotal FROM Auditorias_Ubicacion WHERE Aud_ID = ap.AuD_ID AND Pt_ID = ap.Pt_ID  AND AudU_Veces = Pt_VisitaActual AND AudU_ConteoInterno = 0) as ConteoExterno " 
	}
	sSQL +=" , dbo.fn_CatGral_DameDato(147,ap.Pt_ResultadoCG147) Estatus_Cantidad " 
	sSQL +=" , dbo.fn_CatGral_DameDato(146,ap.Pt_EstatusCG146) Estatus_Auditoria " 
	sSQL +=" ,Pt_VisitaActual UltimoConteo " 
	sSQL +=" from Auditorias_Pallet ap " 
	sSQL +=" INNER JOIN Ubicacion u " 
		sSQL +=" ON ap.Ubi_ID = u.Ubi_ID " 
	sSQL +=" INNER JOIN Producto p " 
		sSQL +=" ON ap.Pro_ID = p.Pro_ID  " 
	sSQL +=" INNER JOIN Auditorias_Ciclicas ac  " 
		sSQL +=" ON ac.Aud_ID = ap.Aud_ID " 
	sSQL +=" where ap.Aud_ID = " +Aud_ID
	sSQL += " )as tb " 
	sSQL +=" ORDER BY tb.Pro_SKU, tb.Ubi_ID "



var i = 0
var rsRe = AbreTabla(sSQL,1,0) 
var Ubicacion = ""
var LPN = ""   
var SKU  = ""
var Producto  = ""
var Estatus  = ""
var Cantidad  = 0
var ConteoInterno  = 0
var ConteoExterno  = 0
var Diferencia_Lyde  = 0
var Diferencia_Cliente  = 0
var Diferencia_Lyde_Cliente  = 0
	while (!rsRe.EOF){
  	     Ubicacion = rsRe.Fields.Item("Ubi_Nombre").Value   
		 LPN = rsRe.Fields.Item("Pt_LPN").Value   
	     SKU  = rsRe.Fields.Item("Pro_SKU").Value 
		 Producto  = rsRe.Fields.Item("pro_Nombre").Value
		 Estatus  = rsRe.Fields.Item("Estatus_Cantidad").Value
		 Cantidad  = rsRe.Fields.Item("PT_Cantidad_Actual").Value
		 ConteoInterno  = rsRe.Fields.Item("ConteoInterno").Value
		 Diferencia_Lyde  = rsRe.Fields.Item("Diferencia_Lyde").Value
		 if(Aud_HayConteoExterno == 1){
		 	 ConteoExterno = rsRe.Fields.Item("ConteoExterno").Value
			 Diferencia_Cliente  = rsRe.Fields.Item("Diferencia_Cliente").Value
			 Diferencia_Lyde_Cliente  = rsRe.Fields.Item("Diferencia_Lyde_Cliente").Value
		 }
	%>
    <%=(i > 0 ) ? "," : ""  %>
    {
    "Ubicacion":"<%=Ubicacion%>"
    ,"LPN":"<%=LPN%>"
    ,"SKU":"<%=SKU%>"
    ,"Producto":"<%=Producto%>"
    ,"Estatus":"<%=Estatus%>"
    
<% if(Aud_EsCiego == 0){ %>
        ,"Cantidad":<%=Cantidad%>
<% }%>

	,"Conteo Interno":<%=ConteoInterno%>
    ,"Diferencia Lyde":<%=Diferencia_Lyde%>
	<%if(Aud_HayConteoExterno == 1){%>
        ,"Conteo Externo":<%=ConteoExterno%>
        ,"Diferencia Cliente":<%=Diferencia_Cliente%>
        ,"Diferencia Conteo Lyde y Cliente":<%=Diferencia_Lyde_Cliente%>
    <%}%>
}
<%
        i++;
        rsRe.MoveNext() 
    }
     rsRe.Close()   
       
%>]


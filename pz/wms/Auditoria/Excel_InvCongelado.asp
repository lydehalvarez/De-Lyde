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

var sSQL  = "select p.Pro_SKU as SKU, p.pro_Nombre, u.Ubi_Nombre "
          + ", ap.Pt_LPN, ap.PT_Cantidad_Actual "
          //  +" ,ISNULL((select top 1 [AudU_ArticulosConteoTotal] from [dbo].[Auditorias_Ubicacion] u1 "
          //  +" where u1.pt_id = ap.pt_id and AudU_ConteoInterno = 1 and AudU_Veces = ac.Aud_VisitaActual "
          //  +" and [AudU_ArticulosConteoTotal] > 0),0) as ConteoInterno "
          //  +" ,ISNULL((select top 1 [AudU_ArticulosConteoTotal]  "
          //  +" from [dbo].[Auditorias_Ubicacion] u2  "
          //  +" where u2.pt_id = ap.pt_id and AudU_ConteoInterno = 0 and AudU_Veces = ac.Aud_VisitaActual "
          //  +" and [AudU_ArticulosConteoTotal] > 0 ),0) as ConteoExterno "
          + " from Auditorias_Pallet ap, Ubicacion u, Producto p, Auditorias_Ciclicas ac "
          + " where ap.Ubi_ID = u.Ubi_ID "  
          + " and ac.Aud_ID = ap.Aud_ID "
          + " and ap.Pro_ID = p.Pro_ID "
          + " and ap.Aud_ID = " + Aud_ID 
          + " ORDER BY p.Pro_SKU, ap.Ubi_ID "

var i = 0
var rsRe = AbreTabla(sSQL,1,0) 
var Ubicacion = ""
var LPN = ""   
var SKU  = ""
var Producto  = ""
var Cantidad  = 0
	while (!rsRe.EOF){
  	     Ubicacion = rsRe.Fields.Item("Ubi_Nombre").Value   
		 LPN = rsRe.Fields.Item("Pt_LPN").Value   
	     SKU  = rsRe.Fields.Item("SKU").Value 
		 Producto  = rsRe.Fields.Item("pro_Nombre").Value
		 Cantidad  = rsRe.Fields.Item("PT_Cantidad_Actual").Value
	%>
    <%=(i > 0 ) ? "," : ""  %>
    {
    "Ubicacion":"<%=Ubicacion%>",
    "LPN":"<%=LPN%>",
    "SKU":"<%=SKU%>",
    "Producto":"<%=Producto%>"
<% if(Aud_EsCiego == 0){ %>
    ,"Cantidad":<%=Cantidad%>
<% } %>
}
<%
        i++;
        rsRe.MoveNext() 
    }
     rsRe.Close()   
       
%>]


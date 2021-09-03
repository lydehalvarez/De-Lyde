<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
var Aud_ID = Parametro("Aud_ID",-1)

var sSQL  = "	select Pro_SKU, Pro_Nombre, Aud_ExistenciaCongelada, Aud_CuarentenaCongelada, "
				+" Aud_EnProcesoCongelado, Aud_ConteoInterno, Aud_ConteoExterno "
				+ " from Auditorias_ExistenciasCongeladas e, Producto p "
				+" where e.Pro_ID = p.Pro_ID and e.Aud_ID = " + Aud_ID 
				+ " ORDER BY Pro_SKU"
		var i = 0
		var rsRe = AbreTabla(sSQL,1,0)

	while (!rsRe.EOF){
  	     var ConteoExterno = rsRe.Fields.Item("Aud_ConteoExterno").Value   
		 var ConteoInterno = rsRe.Fields.Item("Aud_ConteoInterno").Value   
	     var SKU  = rsRe.Fields.Item("Pro_SKU").Value 
		 var Producto  = rsRe.Fields.Item("Pro_Nombre").Value
		 var Aud_EnProcesoCongelado  = rsRe.Fields.Item("Aud_EnProcesoCongelado").Value   
		var Aud_ExistenciaCongelada =  rsRe.Fields.Item("Aud_ExistenciaCongelada").Value  
		var Aud_CuarentenaCongelada =  rsRe.Fields.Item("Aud_CuarentenaCongelada").Value   
 
	%>
    <%=(i > 0 ) ? "," : ""  %>
    {
   
    "SKU":"<%=SKU%>",
    "Producto":"<%=Producto%>",
    "Existencia Congelada":"<%=Aud_ExistenciaCongelada%>",
    "Cuarentena Congelada":"<%=Aud_CuarentenaCongelada%>",
    "En Proceso Congelado":"<%=Aud_EnProcesoCongelado%>",
     "Conteo Interno":"<%=ConteoInterno%>", 
     "Conteo Externo":"<%=ConteoExterno%>"
}
<%
i++;
            rsRe.MoveNext() 
        }
         rsRe.Close()   
       
%>]


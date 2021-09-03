<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
    var Aud_ID = Parametro("Aud_ID",-1)
   
//el objetivo de esta impresion es determinar al iniciar la auditoria que s lo que se va a revisar
//se debe garantizar que lpn se consultaran de tal manera que no se agreguen o quiten durante el conteo   

    var SKU  = "" 
    var Producto = ""
    var Aud_EnProcesoCongelado  = 0   
    var Aud_ExistenciaCongelada = 0
    var Aud_CuarentenaCongelada = 0 

    var sSQL = "select Pro_SKU, Pro_Nombre, Aud_ExistenciaCongelada "
			 + " , Aud_CuarentenaCongelada "
			//+", Aud_EnProcesoCongelado "
			 + " from Auditorias_ExistenciasCongeladas e, Producto p "
			 + " where e.Pro_ID = p.Pro_ID and e.Aud_ID = " + Aud_ID 
			 + " ORDER BY Pro_SKU "
   
    var i = 0
    var rsRe = AbreTabla(sSQL,1,0)

	while (!rsRe.EOF){
	    SKU  = rsRe.Fields.Item("Pro_SKU").Value 
		Producto  = rsRe.Fields.Item("Pro_Nombre").Value
		Aud_ExistenciaCongelada =  rsRe.Fields.Item("Aud_ExistenciaCongelada").Value  
		Aud_CuarentenaCongelada =  rsRe.Fields.Item("Aud_CuarentenaCongelada").Value   
 
	%>
    <%=(i > 0 ) ? "," : ""  %>
    {
   
    "SKU":"<%=SKU%>",
    "Producto":"<%=Producto%>",
    "Existencia Congelada":<%=Aud_ExistenciaCongelada%>,
    "Cuarentena Congelada":<%=Aud_CuarentenaCongelada%>
}
<%
        i++;
        rsRe.MoveNext() 
    }
    rsRe.Close()   
       
%>]


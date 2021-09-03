<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var sSQLOV = " SELECT Pro_Nombre "
		sSQLOV += "FROM Producto"

	var rsProd = AbreTabla(sSQLOV,1,0)
%>[<%
    while (!rsProd.EOF){
        var Pro_Nombre = rsProd.Fields.Item("Pro_Nombre").Value	
%>"<%=Pro_Nombre%>",<%
            rsProd.MoveNext() 
        }
        rsProd.Close()  
%>"N/A"]
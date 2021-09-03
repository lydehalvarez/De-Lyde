<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%

	var sSQL = "  SELECT * "
		sSQL += " , ISNULL(CORID,'') as CORID1 "
		sSQL += " , ISNULL(CUSTOMER_SO,'') CUSTOMERSO "
		sSQL += " , ISNULL(SHIPPIED_QTY,'') SHIPPIEDQTY "
		sSQL += " , ISNULL(SHIPPING_ADDRESS,'') SHIPPINGADDRESS "
		sSQL += " FROM Izzi_Orden_Venta"
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQL,0)	
	
	
	
%>	
    {
     "data": [
<%
        var rsOrdVen = AbreTabla(sSQL,1,0)
         while (!rsOrdVen.EOF){ 
		 var OC_ID = rsOrdVen.Fields.Item("OC_ID").Value
		 var dato1 = rsOrdVen.Fields.Item("CORID1").Value
		 var dato2 = rsOrdVen.Fields.Item("CUSTOMERSO").Value
		 var dato3 = rsOrdVen.Fields.Item("SHIPPIEDQTY").Value
		 var dato4 = rsOrdVen.Fields.Item("SHIPPINGADDRESS").Value
		 if(dato1 == ""){
		  dato1 = "&nbsp;"
		 }
		 if(dato2 == ""){
		  dato2 = "&nbsp;"
		 }
		 if(dato3 == ""){
		  dato3 = "&nbsp;"
		 }
		 if(dato4 == ""){
		  dato4 = "&nbsp;"
		 }
		 
%>		 
		[ "<%=dato1%>",
        "<%=dato2%>",
        "<%=dato3%>",
        "<%=dato4%>"
        ],
<%		 
		
			rsOrdVen.MoveNext()
			}
		rsOrdVen.Close()
		%>
            [ "&nbsp;",
              "&nbsp;",
              "&nbsp;",
              "&nbsp;"
            ]
        ]
    }

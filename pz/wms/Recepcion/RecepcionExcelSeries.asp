<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
	var IR_ID = Parametro("IR_ID",-1)
    var sSQL  = "SELECT Pt_Modelo, Ser_Serie, Pt_LPN FROM Recepcion_Pallet p" 
					+ " INNER JOIN Recepcion_Series s ON p.Pt_ID=s.Ser_ID WHERE p.IR_ID = "+IR_ID
					+" ORDER BY s.Ser_Serie"
	var rsRe = AbreTabla(sSQL,1,0)

		    while (!rsRe.EOF){
  	     var Pallet = rsRe.Fields.Item("Pt_LPN").Value 
		 var Serie = rsRe.Fields.Item("Ser_Serie").Value   
		 var Modelo = rsRe.Fields.Item("Pt_Modelo").Value   

	
	%>{
    "Producto":"<%=Modelo%>",
    "Pallet":"<%=Pallet%>",
    "Serie":"<%=Serie%>"

    
}<%=(i < rsRe.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
            rsRe.MoveNext() 
        }
         rsRe.Close()   
       
%>]


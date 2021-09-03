<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

[
<%
	var sSQLO = "  SELECT * "
		sSQLO += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 126) AS IRFechaEntrega "
		sSQLO += ", CONVERT(VARCHAR(20), IR_FechaEntregaTermina, 126) AS IRFechaEntregaTermina "
		sSQLO += ", CONVERT(VARCHAR(5), IR_FechaEntrega, 108) AS Hora "
		sSQLO += ", CONVERT(VARCHAR(5), IR_FechaEntregaTermina, 108) AS HoraT "
		sSQLO += " FROM Inventario_Recepcion "
		sSQLO += " WHERE IR_Habilitado = 1 "

	var i = 0
	var rsEventos = AbreTabla(sSQLO,1,0)
	while (!rsEventos.EOF){ 
	
		var clase = "bg-success"
		var IR_EstatusCG52 = rsEventos.Fields.Item("IR_EstatusCG52").Value
		if(IR_EstatusCG52 == 18){
			clase = "bg-info"
		}
		var IR_ID =  rsEventos.Fields.Item("IR_ID").Value
		var IR_Folio =  rsEventos.Fields.Item("IR_Folio").Value
		var IR_FechaEntrega =  rsEventos.Fields.Item("IRFechaEntrega").Value
		var IR_FechaEntregaTermina =  rsEventos.Fields.Item("IRFechaEntregaTermina").Value
		var Hora =  rsEventos.Fields.Item("Hora").Value
		var HoraT =  rsEventos.Fields.Item("HoraT").Value
		var IR_Color =  rsEventos.Fields.Item("IR_Color").Value

%>{
    "id": <%=IR_ID%>,
    "title": "<%=IR_Folio%>",
    "start": "<%=IR_FechaEntrega%>",
    "end": "<%=IR_FechaEntregaTermina%>",
    "description":"<%=Hora%>-<%=HoraT%>",
    "className": "<%=clase%>",
    "backgroundColor":"<%=IR_Color%>"
  }<%=(i < rsEventos.RecordCount - 1 ) ? "," : ""  %>
<%
   rsEventos.MoveNext()
i++;
 }
 rsEventos.Close() 
%>
]


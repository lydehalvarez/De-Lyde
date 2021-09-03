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

	var rsEventos = AbreTabla(sSQLO,1,0)
	while (!rsEventos.EOF){ 
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
    "className": "bg-success",
    "backgroundColor":"<%=IR_Color%>"
  },
<%
   rsEventos.MoveNext()
 }
 rsEventos.Close() 
%>
{
    "id": -1,
    "title": "Folio fantasma",
    "start": "2099-01-01",
    "end": "2099-01-01"
}
]


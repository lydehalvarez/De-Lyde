<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var auditorResponsable = Parametro("AuditorResponsable",-1);
    var auditTypeWork = Parametro("AuditTypeWork",-1);
    var initDate = Parametro("InitDate",-1);
    
    try {
        var sSQL = ;
            Ejecuta(sSQL,0);			
            sResultado = '{"result":1,"message":"La auditoria fue actualizada con exito", "query": "'+ query +'"}';	
    } catch(err) {
        sResultado = '{"result":-1,"message": "Error al tratar de actualizar la auditoria"}';
    }

    Response.Write(sResultado);
%>

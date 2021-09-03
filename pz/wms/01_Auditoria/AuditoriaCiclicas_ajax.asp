<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var client = Parametro("Client",-1);
    var auditorResponsable = Parametro("AuditorResponsable",-1);
    var creator = Parametro("Creator",-1);
    var auditType = Parametro("AuditType",-1);
    var auditTypeWork = Parametro("AuditTypeWork",-1);
    var initDate = Parametro("InitDate",-1);
    var auditName = Parametro("Name",-1);
    var description = Parametro("Description",-1);

    try {
		var Aud_ID = SiguienteID("Aud_ID","Auditorias_Ciclicas","",0)
        var sSQL = "INSERT INTO  Auditorias_Ciclicas("
            + " Aud_ID, Aud_Nombre, Cli_ID, Aud_TipoCG140, Aud_EstatusCG141, Aud_UsuarioResponsable_UID, Aud_AbiertaPor_UID, Aud_Avance, Aud_FechaCongelacion, Aud_FormaConteoCG143, Aud_Descripcion, Aud_FechaRegistro)"
            + " values ("
			+ Aud_ID
            + ", '" + auditName + "',"  //name
            + " " + client + "," //client
            + " " + auditType + "," // CG140 tipoAuditoria
            + " 1,"  //CG141 status
            + " [dbo].[fn_Usuario_DameIDUnico](NULL,NULL,NULL,NULL," + auditorResponsable + ",NULL),"  //auditorRespo
            + " " + creator + ","  //abiertaPor
            + " 0,"  //avance
            + " CAST('" + CambiaFormatoFecha(initDate,"dd/mm/yyyy",FORMATOFECHASERVIDOR) + "' AS DATE),"  //fechaCongelacion
            + " " + auditTypeWork + "," //tipoTrabajo
            + " '" + description + "',"  //descripcion
            + " GETDATE()" //registro
            + " )";
        var query = "";
        query +=sSQL;
		
            Ejecuta(sSQL,0);			
            sResultado = '{"result":1,"message":"La auditoria fue creada con exito", "query": "'+ query +'"}';	
    } catch(err) {
        sResultado = '{"result":-1,"message": "Error al tratar de crear la reserva"}';
    }

    Response.Write(sResultado);
%>

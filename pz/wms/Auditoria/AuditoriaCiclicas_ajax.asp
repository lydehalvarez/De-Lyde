<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var client = Parametro("Client",-1)
    var auditorResponsable = Parametro("AuditorResponsable",-1)
    var creator = Parametro("Creator",-1)
    var auditType = Parametro("AuditType",2)
    var auditTypeWork = Parametro("AuditTypeWork",1)
    var initDate = Parametro("InitDate",-1)
    var auditName = Parametro("Name","")
    var description = utf8_decode(Parametro("Description",""))
	var Aud_EsCiego = Parametro("Aud_EsCiego",1)
    var Aud_VisitasContinuas = Parametro("Aud_VisitasContinuas",1)
    var Aud_HayConteoExterno = Parametro("Aud_HayConteoExterno",0)

    try {
		var Aud_ID = SiguienteID("Aud_ID","Auditorias_Ciclicas","",0)
        var sSQL = "INSERT INTO  Auditorias_Ciclicas("
            + "  Aud_ID, Aud_Nombre, Cli_ID, Aud_TipoCG140, Aud_EstatusCG141, Aud_UsuarioResponsable_UID "
            + ", Aud_AbiertaPor_UID, Aud_Avance, Aud_FormaConteoCG143, Aud_Descripcion "
            + ", Aud_EsCiego, Aud_VisitasContinuas, Aud_HayConteoExterno )"
            + " values (" + Aud_ID
            + " , '" + auditName + "'"     //name
            + " , " + client                //client
            + " , " + auditType             // CG140 tipoAuditoria
            + " , 1 "                       //CG141 status
            + " , dbo.fn_Usuario_DameIDUnico(NULL,NULL,NULL,NULL," + auditorResponsable + ",NULL,NULL) "  //auditorRespo
            + " , " + creator               //abiertaPor
            + " , 0 "                       //avance
            + " , " + auditTypeWork         //tipoTrabajo
            + " , '" + description + "'"    //descripcion
            + " , " + Aud_EsCiego 
            + " , " + Aud_VisitasContinuas 
            + " , " + Aud_HayConteoExterno 
            + " )";
   
        var query = "";
        query +=sSQL;
		
            if(Ejecuta(sSQL,0)){
				sResultado = '{"result":1,"message":"La auditoria fue creada con exito", "query": "'+ query +'"}';	
			}else{
				sResultado = '{"result":-1,"message":"Ocurr&oacute; un error", "query": "'+ query +'"}';	
			}
    } catch(err) {
        sResultado = '{"result":-1,"message": "Error al tratar de crear la reserva"}';
    }

    Response.Write(sResultado);
%>

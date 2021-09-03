<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<!--#include file="./Grid.asp" -->
<!--#include file="./utils-js.asp" -->

<%
    var Cli_ID = Parametro("Cli_ID",-1)
    var AuditType = Parametro("AuditType",-1)
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
    var AuditEstatus = Parametro("AuditEstatus",-1)
    var Auditor = Parametro("Auditor",-1)

    var sSQL = "SELECT Top 30 " 
             + "  c.Cli_ID"
             + ", Cli_Nombre"
             + ", dbo.fn_CatGral_DameDato(140,Aud_TipoCG140) as tipo"
             + ", dbo.fn_CatGral_DameDato(141,Aud_EstatusCG141) as estatus"
             + ", dbo.fn_Usuario_DameIDUsuario(Aud_UsuarioResponsable_UID) as auditorResponsable"
             + ", (select count(Aud_ID) from Auditorias_Ubicacion au where au.Aud_ID = ac.Aud_ID) as totalUbicaciones"
             + ", CONVERT(NVARCHAR(10),Aud_FechaRegistro,103)+' '+CONVERT(NVARCHAR(10),Aud_FechaRegistro,108) FechaRegistro "
             + ", CONVERT(NVARCHAR(10),Aud_FechaCongelacion,103) AudFechaCongelacion "
             + ", (CASE WHEN Aud_EsCiego = 0 THEN 'No' ELSE 'Si' END) as ConteoCiego "
			 + ", (CASE WHEN Aud_HayConteoExterno = 0 THEN 'Lyde auditoria' ELSE 'Lyde y Cliente auditan' END) as AudHayConteoExterno "
             + ", ac.* "
             + " FROM Auditorias_Ciclicas ac, Cliente c "
			 + " WHERE ac.Cli_ID = c.Cli_ID "
			 
	if (Cli_ID > -1) {
		sSQL += " AND ac.Cli_Id = " + Cli_ID;
	}

	if (AuditType > -1) {
		sSQL += " AND ac.Aud_TipoCG140 = " + AuditType;
	}

	if (FechaInicio == "" && FechaFin == "") {    
		//FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
		//sSQL += " AND CAST(ac.Aud_FechaRegistro as date)  >= DATEADD(month,-1,getdate()) "
	} else {   
		if(FechaInicio == "" ) {
			if(FechaFin != "" ) {
				FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
				sSQL += " AND CAST(ac.Aud_FechaRegistro as date)  <= '" + FechaFin + "'"
			}
		} else {
			FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
			if(FechaFin == "" ) {
				sSQL += " AND CAST(ac.Aud_FechaRegistro as date)  >= '" + FechaFin + "'"
			} else {
				FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
				sSQL += " AND CAST(ac.Aud_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "
			}
		}
	}

	if (AuditEstatus > -1) {
		sSQL += " AND ac.Aud_EstatusCG141 = " + AuditEstatus
	}

	if (Auditor > -1) {
		sSQL += " AND dbo.fn_Usuario_DameIDUsuario(Aud_UsuarioResponsable_UID) = " + Auditor
	}
		sSQL += " ORDER BY Aud_ID DESC "
	
	//Response.Write(sSQL)
	var rsAudi = AbreTabla(sSQL,1,0)

%>

<div class="ibox">
    <div class="ibox-title">
        <h5>Auditorias</h5>
    </div>
    <div class="row">
    	<div class="col-md-12">
            <div class="project-list">
                <table class="table table-hover">
                    <tbody>
                        <%
                            var Aud_ID = -1
                            var Cli_ID = -1
                            if(!rsAudi.EOF){
                            while (!rsAudi.EOF){
                                Aud_ID = rsAudi.Fields.Item("Aud_ID").Value
                                Cli_ID = rsAudi.Fields.Item("Cli_ID").Value
                        %>
                    <tr>
                        <td class="project-status">
                              <table class="table table-hover">
                                    <tr>
                                        <td class="project-status textCopy">
                                           <h2><%=Aud_ID%></h2>
                                        </td>
                                        <td class="project-title">
                                            <span class="textCopy text-navy"><h3><strong><%=rsAudi.Fields.Item("Cli_Nombre").Value%></strong></h3></span>
                                            <br/>
                                            <strong>Tipo</strong>:&nbsp;<%=rsAudi.Fields.Item("tipo").Value%>
                                        </td>
    
                                        <td class="project-title" width="30%">
                                            <strong>Titulo:</strong>&nbsp;<%=rsAudi.Fields.Item("Aud_Nombre").Value%>
                                            <br/>
                                            <strong>Descripci&oacute;n</strong>&nbsp;<%=rsAudi.Fields.Item("Aud_Descripcion").Value%>
                                            <br/>
                                            <strong>Conteo ciego</strong>:&nbsp;<%=rsAudi.Fields.Item("ConteoCiego").Value%>
                                            <br/>
                                            <strong>Tipo auditoria</strong>:&nbsp;<%=rsAudi.Fields.Item("AudHayConteoExterno").Value%>
                                        </td>
                                        <td class="project-title">
                                            <strong>Fecha registro:</strong>&nbsp;<%=rsAudi.Fields.Item("FechaRegistro").Value%>
                                            <br/>
                                            <strong>Fecha congelaci&oacute;n:</strong> <%=rsAudi.Fields.Item("AudFechaCongelacion").Value%>
                                        </td>  
                                        <td class="project-title">
                                            <span>Ubicaciones</span>
                                            <br/>
                                            <%
                                                var ubication = getUbicationsInfo(Aud_ID);
                                            %>
    
                                            <small><%= "<br>" + ubication.total + " Visitadas " + ubication.visited + "<br> Por Visitar " + ubication.notVisited %></small>
                                        </td>
                                        <td class="project-completion">
                                                <small>Completado <%=rsAudi.Fields.Item("Aud_Avance").Value%>%</small>
                                                <div class="progress progress-mini">
                                                    <div style="width: <%=rsAudi.Fields.Item("Aud_Avance").Value%>%;" class="progress-bar"></div>
                                                </div>
                                        </td>
                                        
                                        <td class="project-actions">
                                            <a class="btn btn-white btn-sm btnVer" data-audid="<%=Aud_ID%>" data-cliid="<%=Cli_ID%>"><i class="fa fa-folder"></i>&nbsp;Ver</a>
                                        </td>
                                    </tr>
                                    <tr>
                                      <td class="project-status">&nbsp;</td>  
                                      <td valign="top" class="project-status"><span class="project-title">Auditores</span></td>
                                      <td colspan="5" align="left" valign="top" class="project-people">
                                          
                                            <%
                                                var auditors = getAuditorsInfo(Aud_ID);
                                                for(var count = 0; count < auditors.length; count++){
                                                    var auditor = auditors[count];
                                                    if(auditor.url != undefined) {
                                            %>
                                                        <span><img title="<%=auditor.name%>" class="img-circle" src="<%=auditor.url%>"></span>
                                                    <%
                                                        } else {
                                                    %>
                                                        <span title="<%=auditor.name%>"><span class="fa fa-user-circle"></span><%=auditor.name.substring(0,1)%></span>
                                                    <%
                                                        }
                                                }
                                                    %>
                                            <br/>
                                            
                                        </td>
                                    </tr>
                   
                              </table>
                        </td>        
                    </tr>    
                            
                            
                   <%
                            rsAudi.MoveNext();
                        }
                        rsAudi.Close();
                    }else{%>
                        <h4>No se encontr&oacute; alguna auditoria abierta</h4>
                    
                    <%}%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<script type="application/javascript">
    
    $(document).ready(function(){


          $('.btnVer').click(function(e) {
            e.preventDefault();
             
            $("#Aud_ID").val( $(this).data('audid') );
            $("#Cli_ID").val( $(this).data('cliid') );
            CambiaSiguienteVentana()
 
        });
        
        
        
        
    });


</script>




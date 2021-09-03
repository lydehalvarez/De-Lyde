<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<!--#include file="./Grid.asp" -->
<!--#include file="./utils-js.asp" -->

<div class="ibox">
    <div class="ibox-title">
        <h5>Auditorias</h5>
    </div>
    <div class="ibox-content">
        <div class="project-list">
            <table class="table table-hover">
                <tbody>
                    <%
                        var iRenglon = 0;
                        var rsTransferencia = AbreTabla(sSQL,1,0);
                        while (!rsTransferencia.EOF){
                            iRenglon++;
                    %>
                <tr>
                    <td class="project-status">
                        <span class=""><%=iRenglon%></span>
                    </td>
                    <td class="project-title">
                        <spa><%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></spa>
                        <br/>
                        <small>Originado <%=rsTransferencia.Fields.Item("tipo").Value%></small>
                    </td>
                    <td class="project-title">
                        <span><%=shrunkDate(rsTransferencia.Fields.Item("Aud_FechaRegistro").Value)%></span>
                        <br/>
                        <small><%=dateFormatter(rsTransferencia.Fields.Item("Aud_FechaRegistro").Value)%></small>
                    </td>
                    <td class="project-title">
                        <span>Ubicaciones</span>
                        <br/>
                        <%
                            var ubication = getUbicationsInfo(rsTransferencia.Fields.Item("Aud_ID").Value);
                        %>
                        
                        <small><%= "Total " + ubication.total + " Visitadas " + ubication.visited + " Por Visitar " + ubication.notVisited %></small>
                    </td>
                    <td class="project-completion">
                            <small>Completado <%=rsTransferencia.Fields.Item("Aud_Avance").Value%>%</small>
                            <div class="progress progress-mini">
                                <div style="width: <%=rsTransferencia.Fields.Item("Aud_Avance").Value%>%;" class="progress-bar"></div>
                            </div>
                    </td>
                    <td class="project-people">
                        <%
                            var auditors = getAuditorsInfo(rsTransferencia.Fields.Item("Aud_ID").Value);
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
                        <span class="project-title">Auditores</span>
                    </td>
                    <td class="project-actions">
                        <a href="#" class="btn btn-white btn-sm btnVer" data-audid="<%=rsTransferencia.Fields.Item("Aud_ID").Value%>"><i class="fa fa-folder"></i> Ver </a>
                    </td>
                </tr>
                <%
                        rsTransferencia.MoveNext();
                    }
                    rsTransferencia.Close();
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>


<script type="application/javascript">
    
    $(document).ready(function(){


          $('.btnVer').click(function(e) {
            e.preventDefault();
             
            $("#Aud_ID").val( $(this).data('audid') )
           
            CambiaSiguienteVentana()
 
        });
        
        
        
        
    });


</script>




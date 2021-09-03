<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<!--#include file="./Grid.asp" -->
<!--#include file="./utils-js.asp" -->

<div class="table-responsive">
    <table class="table table-striped">
        <thead>
            <tr>
                <th></th>
                <th>Cliente </th>
                <th>Originado </th>
                <th>Fecha </th>
                <th>Visitadas </th>
                <th>Por visitar </th>
                <th>Total </th>
                <th>Completado %</th>
                <th>Auditores </th>
            </tr>
        </thead>
        <tbody>
            <%
                var iRenglon = 0;
                var rsTransferencia = AbreTabla(sSQL,1,0);
                while (!rsTransferencia.EOF) {
                    iRenglon++;
                    var ubication = getUbicationsInfo(rsTransferencia.Fields.Item("Aud_ID").Value);

            %>
            <tr>
                <th><small><%=iRenglon%></small></th>
                <th><small><%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></small></th>
                <th><small><%=rsTransferencia.Fields.Item("tipo").Value%></small></th>
                <th><small><%=dateFormatter(rsTransferencia.Fields.Item("Aud_FechaRegistro").Value)%></small></th>
                <th><small><%=ubication.visited%></small></th>
                <th><small><%=ubication.notVisited%></small></th>
                <th><small><%=ubication.total%></th>
                <th><small><%=rsTransferencia.Fields.Item("Aud_Avance").Value%>%</small></th>
                <th>
                    <small>
                        <%
                            var auditors = getAuditorsInfo(rsTransferencia.Fields.Item("Aud_ID").Value);
                            for(var i = 0; i < auditors.length; i++) {
                                var auditor = auditors[i];
                        %>
                            <%=auditor.name%><br />
                        <%
                            }
                        %>
                        <!-- <%=getAuditorsInfoFormatted(rsTransferencia.Fields.Item("Aud_ID").Value)%> -->
                    </small>
                </th>
            </tr>
            <%
                    rsTransferencia.MoveNext();
                }
                rsTransferencia.Close();
            %>
        </tbody>
    </table>
</div>
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

    var rqIntUbi_ID = Parametro("Ubi_ID", 0)
    var Pro_ID = Parametro("Pro_ID", -1)

    sqlPTExt = "EXEC SPR_Pallet "
          + "@Opcion = 1000 "
        + ", @PT_PorBuscar = 1 "
    if(Pro_ID > -1) {
        sqlPTExt += ", @Pro_ID = " + Pro_ID
    }

    rsPTExt = AbreTabla(sqlPTExt, 1, 0)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPN Por Buscar</h5>
        </div>
        <div class="ibox-content">
            <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>LPN</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
<%
    if( !(rsPTExt.EOF) ){
        var i = 0
        while( !(rsPTExt.EOF) ){
%>
                    <tr>
                        <td><%= ++i %></td>
                        <td class="issue-info">
                            <a>
                                <%= rsPTExt("PT_LPN") %>
                            </a>
                            <small><%= rsPTExt("Pro_SKU") %> - <%= rsPTExt("Pro_Nombre") %></small>
                        </td>
                        <td>
                            <a class="btn btn-success btn-xs" onclick='TemporalCargaInicialCantidad.LPNSeleccionar({LPN: "<%= rsPTExt("PT_LPN") %>", Cantidad: "<%= rsPTExt("PT_ConteoFisico").Value %>"});' title="Seleccionar LPN">
                                <i class="fa fa-files-o"></i>
                            </a>
                        </td>
                    </tr>
<%
            rsPTExt.MoveNext()
        }
    } else {
%>
                    <tr>
                        <td colspan="4">
                            <i class="fa fa-exclamation-circle"></i> No hay Registros
                        </td>
                    </tr>
<%
    }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
    rsPTExt.close()
   
   
%>

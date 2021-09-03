<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-28 Surtido: Creación de archivo

var cxnTipo = 0;

var rqDateFecha = Parametro("Fecha", "");
var rqIntEst_ID = Parametro("Est_ID", -1);
var rqIntProv_ID = Parametro("Prov_ID", -1)
var rqIntCli_ID = Parametro("Cli_ID", -1)
var rqStrEst_Nombre = Parametro("Est_Nombre", "");

var sqlEntSeg = "EXEC SPR_Proveedor_Entregas_Monitoreo "
      + "@Opcion = 1100 "
    + ", @Est_ID = " + ( ( rqIntEst_ID > -1 ) ? rqIntEst_ID : "NULL" ) + " "
    + ", @Prov_ID = " + ( ( rqIntProv_ID > -1 ) ? rqIntProv_ID : "NULL" ) + " "
    + ", @Cli_ID = " + ( ( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL" ) + " "
    + ", @FechaInicial = " + ( ( rqDateFecha.length > 0 ) ? "'" + rqDateFecha + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( ( rqDateFecha.length > 0 ) ? "'" + rqDateFecha + "'" : "NULL" ) + " "

var rsEntSeg = AbreTabla(sqlEntSeg, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h3>Fecha: <%= CambiaFormatoFecha(rqDateFecha, "yyyy-mm-dd", "dd-mm-yyyy") %><%= ((rqStrEst_Nombre != "") ? " - " : " ") %><span class="text-danger"><%= rqStrEst_Nombre %></span></h3>
            <div class="ibox-tools">
                <button type="button" class="btn btn-danger btn-sm" onclick="Proveedor.Entrega.ListadoLimpiar( $(this) )">
                    <i class="fa fa-trash-o"></i> Cerrar
                </button>
                <button type="button" class="btn btn-white btn-sm" onclick='Proveedor.Entrega.Exportar({Fecha: "<%= rqDateFecha %>", Est_ID: <%= rqIntEst_ID %> })'>
                    <i class="fa fa-file-excel-o"></i> Exportar
                </button>
            </div>
        </div>
        <div class="ibox-content">

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Folio</th>
                        <th>Pedido</th>
                        <th>Estatus</th>
                        <th>Transportista</th>
                        <th>Guia</th>
                        <th>Manifiesto</th>
                        <th>Dias Transito</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>

<%
if( !(rsEntSeg.EOF) ){

    while(!(rsEntSeg.EOF)){
%>
                    <tr class="cssRegEnt">
                        <td><%= rsEntSeg("ID").Value %></td>
                        <td>
                            <a class="text-danger" onclick='Proveedor.Entrega.DetalleVer({TA_ID: <%= rsEntSeg("TA_ID").Value %>})'>
                                <%= rsEntSeg("Folio").Value %>
                            </a>
                        </td>
                        <td><%= rsEntSeg("Pedido").Value %></td>
                        <td><%= rsEntSeg("Est_Nombre").Value %></td>
                        <td><%= rsEntSeg("Prov_Nombre").Value %></td>
                        <td><%= rsEntSeg("Guia").Value %></td>
                        <td>
                            <a class="text-success" onclick='Proveedor.Manifiesto.DetalleVer({Man_ID: "<%= rsEntSeg("Man_ID").Value %>"})'>
                                <%= rsEntSeg("Man_Folio").Value %>
                            </a>
                        </td>
                        <td><%= rsEntSeg("DiasTransito").Value %></td>
                        <td>
                            <a class="btn btn-white btn-sm" onclick='Proveedor.Entrega.Redireccionar({Folio: "<%= rsEntSeg("Folio").Value %>"})'>
                                <i class="fa fa-file-text-o"></i> Ver
                            </a>
                        </td>
                    </tr>
<%  
        Response.Flush()
        rsEntSeg.MoveNext()
    }        
}
%>
                </tbody>
            </table>
        </div>
    </div>                
<%
rsEntSeg.Close()
%>
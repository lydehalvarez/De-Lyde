<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Movimiento: Creación de archivo

var cxnTipo = 0

var rqIntIOM_ID = Parametro("IOM_ID", -1)

var sqlProLis = "EXEC SPR_Inventario_OrdenMovimiento_Producto "
      + "@Opcion = 1000 "
    + ", @IOM_ID = " + rqIntIOM_ID + " "

var rsProLis = AbreTabla(sqlProLis, 1, cxnTipo)
%>
    <table class="table table-striped table-bordered">
        <thead>
            <tr>
                <th class="col-2-sm">
                    Cliente
                </th>
                <th class="col-4-sm">
                    Producto
                </th>
                <th class="col-4-sm">
                    Ubi. Destino
                </th>
                <th class="col-1-sm">
                    Cant. Solicitada
                </th>
                <th class="col-1-sm">
                    Cant. Entregada
                </th>
            </tr>
        </thead>
        <tbody>    
<%

if( !(rsProLis.EOF) ){

    while( !(rsProLis.EOF) ){

        for(var i=0;i<rsProLis.Count;i++){
            Response.Write("Nombre: " + rsProLis(i).Name + "<br>")
        }
%>
            <tr>
                <td>
                    <%= rsProLis("Cli_Nombre").Value %>
                </td>
                <td class="project-title">
                    <a>
                        <%= rsProLis("Pro_SKU").Value %>
                    </a>
                    <br>
                    <small><%= rsProLis("Pro_Nombre").Value %></small>
                </td>
                <td class="project-title">
                    <a>
                        <%= rsProLis("Ubi_Nombre_Destino").Value %>
                    </a>
                    <br>
                    <small><%= rsProLis("Are_Nombre_Destino").Value %></small>
                </td>
                <td class="project-title">
                    <%= rsProLis("IOMP_CantidadSolicitada").Value %>
                </td>
                <td class="project-title">
                    <%= rsProLis("IOMP_CantidadEntregada").Value %>
                </td>
            </tr>
<%
        rsProLis.MoveNext()
    }
} else {
%>
            <tr>
                <td colspan="6">
                    <i class="fa fa-exclamation-circle-o text-success"></i> No tiene Productos
                </td>
            </tr>
<%
}
%>
        </tbody>
    </table>
<%
rsProLis.Close()
%>
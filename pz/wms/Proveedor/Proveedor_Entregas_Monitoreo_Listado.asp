<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-28 Surtido: Creación de archivo

var cxnTipo = 0;

var rqIntProv_ID = Parametro("Prov_ID", -1)
var rqIntCli_ID = Parametro("Cli_ID", -1)
var rqDateFecIni = Parametro("FechaInicial", "")
var rqDateFecFin = Parametro("FechaFinal", "")
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0) 
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10)

var Proveedor = {
    Estatus: {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , AvisoDevolucion: 22
    }
}

var sqlEntSeg = "EXEC SPR_Proveedor_Entregas_Monitoreo "
      + "@Opcion = 1000 "
    + ", @Cli_ID = " + ( ( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL" ) + " "
    + ", @Prov_ID = " + ( ( rqIntProv_ID > -1 ) ? rqIntProv_ID : "NULL" ) + " "
    + ", @FechaInicial = " + ( ( rqDateFecIni.length > 0 ) ? "'" + rqDateFecIni + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( ( rqDateFecFin.length > 0 ) ? "'" + rqDateFecFin + "'" : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "

var rsEntSeg = AbreTabla(sqlEntSeg, 1, cxnTipo)

if( !(rsEntSeg.EOF) ){

    while(!(rsEntSeg.EOF)){
%>
                    <tr class="cssReg text-center">
                        <td title="Fecha" style="cursor: pointer;" onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: -1, Est_Nombre: ""})'>
                            <%= CambiaFormatoFecha(rsEntSeg("Fecha").Value, "yyyy-mm-dd", "dd-mm-yyyy") %>
                        </td>
                        <td title="Transito" 
                        <% if( parseInt(rsEntSeg("Transito").Value) > 0 ){ %> class="bg-success" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("Transito").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.Transito %>, Est_Nombre: "Transito"})' <% } %>>
                            <%= rsEntSeg("Transito").Value %>
                        </td>
                        <td title="1er Intento" 
                        <% if( parseInt(rsEntSeg("PrimerIntento").Value) > 0 ){ %> class="bg-warning" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("PrimerIntento").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.PrimerIntento %>, Est_Nombre: "1er Intento"})' <% } %>>
                            <%= rsEntSeg("PrimerIntento").Value %>
                        </td>
                        <td title="2do Intento" 
                        <% if( parseInt(rsEntSeg("SegundoIntento").Value) > 0 ){ %> class="bg-warning" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("SegundoIntento").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.SegundoIntento %>, Est_Nombre: "2do Intento"})' <% } %>>
                            <%= rsEntSeg("SegundoIntento").Value %>
                        </td>
                        <td title="3er Intento" 
                        <% if( parseInt(rsEntSeg("TercerIntento").Value) > 0 ){ %> class="bg-warning" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("TercerIntento").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.TercerIntento %>, Est_Nombre: "3er Intento"})' <% } %>>
                            <%= rsEntSeg("TercerIntento").Value %>
                        </td>
                        <td title="Entrega Exitosa" 
                        <% if( parseInt(rsEntSeg("EntregaExitosa").Value) > 0 ){ %> class="bg-primary" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("EntregaExitosa").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.EntregaExitosa %>, Est_Nombre: "Entrega Exitosa"})' <% } %>>
                            <%= rsEntSeg("EntregaExitosa").Value %>
                        </td>
                        <td title="Falla Entrega" 
                        <% if( parseInt(rsEntSeg("FallaEntrega").Value) > 0 ){ %> class="bg-danger" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("FallaEntrega").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.FallaEntrega %>, Est_Nombre: "Falla Entrega"})' <% } %>>
                            <%= rsEntSeg("FallaEntrega").Value %>
                        </td>
                        <td title="Aviso Devoluci&oacute;n" 
                        <% if( parseInt(rsEntSeg("AvisoDevolucion").Value) > 0 ){ %> class="bg-danger" style="cursor: pointer;" <% } %>
                        <% if( parseInt(rsEntSeg("AvisoDevolucion").Value) > 0 ){ %> onclick='Proveedor.Entrega.ListadoCargar({Objeto: $(this).parent("tr"), Fecha: "<%= rsEntSeg("Fecha").Value %>", Est_ID: <%= Proveedor.Estatus.AvisoDevolucion %>, Est_Nombre: "Aviso Devolucion"})' <% } %>>
                            <%= rsEntSeg("AvisoDevolucion").Value %>
                        </td>
                        <td><%= rsEntSeg("Total").Value %></td>
                    </tr>
<%  
        Response.Flush()
        rsEntSeg.MoveNext()
    }        
    
}
rsEntSeg.Close()
%>
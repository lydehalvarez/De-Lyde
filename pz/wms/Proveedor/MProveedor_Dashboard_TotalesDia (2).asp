<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Extraccion de Informacion
    case 1010: {

        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqIntCli_ID = Parametro("Cli_ID", -1)

        var sqlDas = "EXEC SPR_MProveedor "
              + "@Opcion = 1010 "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL" ) + " "

        var rsDas = AbreTabla(sqlDas, 1, cxnTipo)

        var strColor = ""

        while( !(rsDas.EOF) ){

            switch( parseInt( rsDas("Dia").Value ) ){
                case 0: { strColor = "success" } break;
                case 1: case 2: case 3: { strColor = "info" } break;
                case 4: case 5: case 6: case 7: { strColor = "warning" } break;
                default: { strColor = "danger" };
            }
%>
        <div class="col-md-2" style="cursor: pointer"
         onclick='MProveedor.Dashboard.ListadoCargar({Dias: "<%= rsDas("DIAS").Value %>", Tipo: <%= rsDas("Tipo").Value %>, Fecha: "<%= rsDas("Fecha").Value %>"})'>
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <span class="label label-<%= strColor %> pull-right">
                        <%= CambiaFormatoFecha(rsDas("Fecha").Value, "yyyy-mm-dd", "dd/mm/yyyy")  %>
                    </span>
                    <h5>
                        <%= rsDas("DIAS").Value %>
                    </h5>
                </div>

                <div class="ibox-content">
                    <h1 class="no-margins"><%= rsDas("Total_Pendientes").Value %></h1>
                    <div class="stat-percent font-bold text-success"><%= formato_numero(rsDas("Porcentaje_Entregas").Value, 2) %>% </div>
                    <small></small>
                </div>

            </div>
        </div>
<%
            rsDas.MoveNext()
        }

        rsDas.Close()

    } break;
}
%>
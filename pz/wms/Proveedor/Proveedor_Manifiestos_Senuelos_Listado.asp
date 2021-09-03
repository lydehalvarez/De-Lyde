<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUL-21 Manifiesto: Creación de archivo

var cxnTipo = 0

var rqIntMan_ID = Parametro("Man_ID", -1)
var rqBolTransportista = Parametro("Transportista", 0)

var bolEsTransportista = ( rqBolTransportista == 1 )

var sqlManSnl = "EXEC SPR_Manifiesto_Monitoreo "
      + "@Opcion = 1140 "
    + ", @Man_ID = " + ( (rqIntMan_ID > -1) ? rqIntMan_ID : "NULL" ) + " "
   
var rsManSnl = AbreTabla(sqlManSnl, 1, cxnTipo)
%>
     <div class="ibox">
        <div class="ibox-title">
            <h5 class="text-navy">
                <i class="fa fa-wifi"></i> Se&ntilde;uelos
            </h5>
            <div class="ibox-tools">

                <label class="pull-right form-group">
                    <span class="text-success" id="lblManSnlLisTot">
                        
                    </span> Registros
                </label>

            </div>
        </div>
        <div class="ibox-content">
            <table class="table table-hover">
                <tbody id="tbManSnlLis">
<%
while(!(rsManSnl.EOF)){
%> 
                    <tr class="cssTrManSnlLisReg">
                        <td>
                            <%= rsManSnl("ID").Value %>
                        </td>
                        <td class="project-title">
                            <a class="text-danger">
                                <%= rsManSnl("ManG_SerieGPS").Value %>
                            </a>
                            <br>
                            <small>
                                Se&ntilde;elo
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsManSnl("Usu_Nombre").Value %>
                            </a>
                            <br>
                            <small>
                                Usuario
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsManSnl("ManG_FechaRegistro").Value %>
                            </a>
                            <br>
                            <small>
                                Fecha Registro
                            </small>
                        </td>
                        
                    </tr>
<%
    Response.Flush()
    rsManSnl.MoveNext()
}

rsManSnl.Close()
%>
                </tbody>
                <tfoot>
                    <tr>
                        <td id="tfManSnlLisCar" colspan="4">
                        
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>   
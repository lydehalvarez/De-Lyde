<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUL-21 Manifiesto: Creación de archivo

var cxnTipo = 0

var rqIntMan_ID = Parametro("Man_ID", -1)
var rqBolTransportista = Parametro("Transportista", 0)

var bolEsTransportista = ( rqBolTransportista == 1 )

var sqlManGuia = "EXEC SPR_Manifiesto_Monitoreo "
      + "@Opcion = 1110 "
    + ", @Man_ID = " + ( (rqIntMan_ID > -1) ? rqIntMan_ID : "NULL" ) + " "
   
var rsManGuia = AbreTabla(sqlManGuia, 1, cxnTipo)
%>
     <div class="ibox">
        <div class="ibox-title">
            <h5 class="text-navy">
                <i class="fa fa-id-card-o"></i> Guias
            </h5>
            <div class="ibox-tools">

                <label class="pull-right form-group">
                    <span class="text-success" id="lblManGuiLisTot">
                        
                    </span> Registros
                </label>

            </div>
        </div>
        <div class="ibox-content">
            <table class="table table-hover">
                <tbody id="tbManGuiLis">
<%
while(!(rsManGuia.EOF)){
%> 
                    <tr class="cssTrManGuiLisReg">
                        <td>
                            <%= rsManGuia("ID").Value %>
                        </td>
                        <td class="project-title">
                            <a class="textCopy text-danger">
                                <%= rsManGuia("ProG_NumeroGuia").Value %>
                            </a>
                            <br>
                            <small>
                                Gu&iacute;a
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsManGuia("ProG_FechaAsignaGuia").Value %>
                            </a>
                            <br>
                            <small>
                                Fecha Asignaci&oacute;n
                            </small>
                        </td>
                        
                    </tr>
<%
    Response.Flush()
    rsManGuia.MoveNext()
}

rsManGuia.Close()
%>
                </tbody>
                <tfoot>
                    <tr>
                        <td id="tfManGuiLisCar" colspan="4">
                        
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>   
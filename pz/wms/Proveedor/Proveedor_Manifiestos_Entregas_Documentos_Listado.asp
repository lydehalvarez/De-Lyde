<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUL-21 Manifiesto: Creación de archivo

var cxnTipo = 0

var rqIntMan_ID = Parametro("Man_ID", -1)
var rqBolTransportista = Parametro("Transportista", 0)

var bolEsTransportista = ( rqBolTransportista == 1 )

var sqlManDoc = "EXEC SPR_Manifiesto_Monitoreo "
      + "@Opcion = 1120 "
    + ", @Man_ID = " + ( (rqIntMan_ID > -1) ? rqIntMan_ID : "NULL" ) + " "
   
var rsManDoc = AbreTabla(sqlManDoc, 1, cxnTipo)
%>
     <div class="ibox">
        <div class="ibox-title">
            <h5 class="text-navy">
                <i class="fa fa-archive"></i> Documentos de Entregas
            </h5>
            <div class="ibox-tools">

                <label class="pull-right form-group">
                    <span class="text-success" id="lblManDocEntLisTot">
                        
                    </span> Registros
                </label>

            </div>
        </div>
        <div class="ibox-content">
            <table class="table table-hover">
                <tbody id="tbManDocEntLis">
<%
while(!(rsManDoc.EOF)){
%> 
                    <tr class="cssTrManDocEntLisReg">
                        <td>
                            <%= rsManDoc("ID").Value %>
                        </td>
                        <td>
                            <a onclick='Entregas.Documentos.Visualizar({Arc_Nombre: "<%= rsManDoc("Docs_Nombre").Value %>", Arc_Ruta: "<%= rsManDoc("Docs_RutaArchivo").Value %>"});'>
                                <i class="fa fa-file-text-o fa-3x"></i>
                            </a>
                        </td>
                        <td class="project-title">
                            <a class="textCopy text-danger">
                                <%= rsManDoc("Ent_Folio").Value %>
                            </a>
                            <br>
                            <small>
                                Folio Entrega
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsManDoc("Doc_Nombre").Value %>
                            </a>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsManDoc("Docs_Titulo").Value %>
                            </a>
                            <br>
                            <small title="Usuario Registro">
                                <i class="fa fa-user"></i> <%= rsManDoc("Usu_Nombre").Value %>
                            </small>
                            <br>
                            <small title="Fecha Registro">
                                <i class="fa fa-clock-o"></i> <%= rsManDoc("Docs_FechaRegistro").Value %>
                            </small>
                        </td>
                        <td class="project-title">
<%      if( parseInt(rsManDoc("Docs_Validado").Value) == 1 ){
%>
                            <i class="fa fa-check-circle fa-2x text-success" title="Documento Validado"></i>
<%      }
%>
                        </td>
                    </tr>
<%
    Response.Flush()
    rsManDoc.MoveNext()
}

rsManDoc.Close()
%>
                </tbody>
                <tfoot>
                    <tr>
                        <td id="tfManDocEntLisCar" colspan="4">
                        
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>   
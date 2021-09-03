<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAY-21 Carga Masiva de Archivos: Creación de archivo

var cxnTipo = 0

var rqIntProv_ID = Parametro("Prov_ID", "-1")
var rqStrArchivoNombre = Parametro("ArchivoNombre", "")
var rqStrFolio = Parametro("Folio", "")
var rqIntArchivoRelacionado = Parametro("ArchivoRelacionado", -1)
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 100)

var Estatus = {
      Nuevo: 1
    , Relacionado: 2
    , NoRelacionado: 3
    , Relacion_Manual: 4
}

var sqlArc = "EXEC SPR_CargaArchivosMasivo "
      + "@Opcion = 1000 "
    + ", @Prov_ID = " + (( rqIntProv_ID > -1 ) ? rqIntProv_ID : "NULL" ) + " "
    + ", @TextoBuscar = " + ( (rqStrArchivoNombre.length > 0 ) ? "'" + rqStrArchivoNombre + "'" : "NULL" ) + " "
    + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @EsRelacionado = " + ( (rqIntArchivoRelacionado > -1) ? rqIntArchivoRelacionado : "NULL" ) + " "
    + ", @FechaInicial = " + ( ( rqDateFechaInicial.length > 0 ) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( ( rqDateFechaFinal.length > 0 ) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > -1) ? rqIntSiguienteRegistro : "NULL" ) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ? rqIntRegistrosPagina : "NULL" ) + " "

var rsArc = AbreTabla(sqlArc, 1, cxnTipo)

var strLblEstatus = ""

if( !(rsArc.EOF) ){
    var i = 0;

    while( !(rsArc.EOF) ){

        intID = rsArc("Doc_ID").Value

        switch( parseInt(rsArc("Est_ID").Value) ){
            case Estatus.Nuevo: { strLblEstatus = "" } break;
            case Estatus.Relacionado: { strLblEstatus = "label-info" } break;
            case Estatus.NoRelacionado: { strLblEstatus = "label-warning" } break;
            case Estatus.Relacion_Manual: { strLblEstatus = "label-success" } break;
        }
%>
        <tr class="cssReg">
            <td id='regEsRel_<%= intID %>'>
<%
        if( rsArc("EsRelacionado").Value == 0){
%>
                <input type="checkbox" class="cssAlgArcRel" value="<%= intID %>" style="display: none;"
                onclick="Proveedor.RelacionarArchivo.AlgunoSeleccionar()">
<%      }
%>
            </td>
            <td>
                <%= rsArc("ID").Value %>
            </td>
            <td class="col-sm-1" id="regEst_ID_<%= intID %>">
                <label class="label <%= strLblEstatus %>">
                    <%= rsArc("Est_Nombre").Value %>
                </label>
            </td>
            <td id="regCar_<%= intID %>">

            </td>
            <td class="col-sm-3">
                <%= rsArc("Doc_Nombre").Value %>
            </td>
            <td class="col-sm-2" id="regDoc_Folio_<%= intID %>">
                <%= rsArc("Doc_Folio").Value %>
            </td>
            <td class="col-sm-2" id="regTransportista_<%= intID %>">
                <%= rsArc("Transportista").Value %>
            </td>
            <td class="col-sm-2" id="regGuia_<%= intID %>">
                <%= rsArc("Guia").Value %>
            </td>
            <td class="col-sm-2">
                <%= rsArc("Docs_FechaRegistro").Value %>
            </td>
            <td>

            </td>
        </tr>
<%
        rsArc.MoveNext()
    }

}
rsArc.Close()
%>
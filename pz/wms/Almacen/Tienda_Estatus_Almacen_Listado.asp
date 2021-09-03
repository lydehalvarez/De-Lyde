<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Tiedas y entregas: Creación de archivo

var cxnTipo = 0

var rqStrTexto = Parametro("Texto", "")
var rqStrTag_IDs = Parametro("Tag_IDs", "")

var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10)

var strLblTipo = ""

var Almacen = {
    Tipo: {
          CeDis: 1
        , Tienda: 2
    }
}

var sqlTieEst = "EXEC SPR_Almacen "
      + "@Opcion = 1000 "
    + ", @Tag_IDs = " + ( (rqStrTag_IDs.length > 0) ? "'" + rqStrTag_IDs + "'" : "NULL" ) + " "
    + ", @Texto = " + ( (rqStrTexto.length > 0) ? "'" + rqStrTexto + "'" : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > -1) ? rqIntSiguienteRegistro : "NULL" ) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ? rqIntRegistrosPagina : "NULL" ) + " "

    //Response.Write(sqlTieEst)

var rsTieEst = AbreTabla(sqlTieEst, 1, cxnTipo)

while( !(rsTieEst.EOF) ){
    
    switch( parseInt(rsTieEst("Tpo_ID").Value) ){
        case Almacen.Tipo.CeDis: { strLblTipo = "label-primary" } break;
        case Almacen.Tipo.Tienda: { strLblTipo = "label-success" } break;
    }

%>
    <li class="warning-element cssAlmReg" data-alm_id="<%= rsTieEst("Alm_ID").Value %>">
        <div class="pull-right cssThumbs">
            
        </div>
        <h3>
             <%= rsTieEst("Alm_Numero").Value %>
        </h3>
        <div class="row">
            <div class="col-sm-10">
                <%= rsTieEst("Alm_Nombre").Value %>
            </div>
        </div>
        <div class="agile-detail">
            <a class="pull-right btn btn-xs btn-white" onclick='Tienda.Buscar.Seleccionar(this);'>
                <i class="fa fa-reply"></i> Ver
            </a>
            <i class="fa fa-home"></i> <%= rsTieEst("Tpo_Nombre").Value %>
        </div>
    </li>
<%
    Response.Flush()
    rsTieEst.MoveNext()
}

rsTieEst.Close()
%>
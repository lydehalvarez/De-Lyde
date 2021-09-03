<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Auditoria Pallet - Auditoria: Creación de archivo
var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntAud_ID = Parametro("Aud_ID", -1)
var rqIntPT_ID = Parametro("PT_ID", -1)
var rqIntAudU_ID = Parametro("AudU_ID", -1)

var intErrorNumero = 0
var strErrorDescripcion = ""

var strUbi_Nombre = ""
var strPT_LPN = ""

var intAudU_MBCantidad = 0
var intAudU_MBCantidadArticulos = 0
var intAudU_MBCantidadSobrante = 0
var intAudU_ArticulosConteoTotal = 0
var intAudU_TipoConteoCG142 = 0
var intAudU_HallazgoCG144 = 0
var strAudU_Comentario = ""
var strTIC_Nombre = ""

//Extracción de informacion de la Auditoria Ubicacion - Pallet

var sqlAAU = "EXEC SPR_Auditorias_Ubicacion "
      + "@Opcion = 1000 "
    + ", @Aud_ID = " + rqIntAud_ID + " "
    + ", @PT_ID = " + rqIntPT_ID + " "  
    + ", @AudU_ID = " + rqIntAudU_ID + " "

var rsAAU = AbreTabla(sqlAAU, 1, cxnTipo)

if( !(rsAAU.EOF) ){
    
    strUbi_Nombre = rsAAU("Ubi_Nombre").Value
    strPT_LPN = rsAAU("PT_LPN").Value
    intAudU_MBCantidad = rsAAU("AudU_MBCantidad").Value
    intAudU_MBCantidadArticulos = rsAAU("AudU_MBCantidadArticulos").Value
    intAudU_MBCantidadSobrante = rsAAU("AudU_MBCantidadSobrante").Value
    intAudU_ArticulosConteoTotal = rsAAU("AudU_ArticulosConteoTotal").Value
    intAudU_TipoConteoCG142 = rsAAU("AudU_TipoConteoCG142").Value
    intAudU_HallazgoCG144 = rsAAU("AudU_HallazgoCG144").Value
    strAudU_Comentario = rsAAU("AudU_Comentario").Value
    strTIC_Nombre = rsAAU("TIC_Nombre").Value

}

rsAAU.Close();

//Actualizacion de en Proceso
var sqlEnPro = "EXEC SPR_Auditorias_Ubicacion "
      + "@Opcion = 3000 "
    + ", @Aud_ID = " + rqIntAud_ID + " " 
    + ", @PT_ID = " + rqIntPT_ID + " " 
    + ", @AudU_ID = " + rqIntAudU_ID + " " 
    + ", @AudU_EnProceso = 1 "

var rsEnPro = AbreTabla(sqlEnPro, 1, cxnTipo)

if( !(rsEnPro.EOF) ){
    intErrorNumero = rsEnPro("ErrorNumero").Value
    strErrorDescripcion = rsEnPro("ErrorDescripcion").Value
}

rsEnPro.Close()

%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Almacen/Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Almacen/Ubicacion/js/Ubicacion.js"></script>

<script type="text/javascript" src="<%= urlBase %>Auditoria/AuditoriasUbicacion/js/AuditoriasUbicacion.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
        
        Catalogo.ComboCargar({
              Contenedor: "selAAUEAudU_HallazgoCG144"
            , SEC_ID: 144
        });

    })

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Informacion de Audtoria</h5>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">    
                                
                                <div class="form-group row">

                                    <label class="col-xs-4 control-label">Ubicacion:</label>
                                    <div class="col-xs-8 m-b-xs text-success">
                                        <%= strUbi_Nombre %>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-xs-4 control-label">LPN:</label>
                                    <div class="col-xs-8 m-b-xs text-success">
                                        <%= strPT_LPN %>
                                    </div>

                                </div>

                            </div>

                            <div class="col-sm-12 m-b-xs">    
                                <div class="form-group row">
                                    <label class="col-xs-4 control-label">Tipo de Conteo:</label>
                                    <div class="col-xs-8 m-b-xs text-success">
                                        <%= strTIC_Nombre %>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Auditoria</h5>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">    
                                
                                <input type="hidden" id="hidAAUEAud_ID" value="<%= rqIntAud_ID %>">
                                <input type="hidden" id="hidAAUEPT_ID" value="<%= rqIntPT_ID %>">
                                <input type="hidden" id="hidAAUEAudU_ID" value="<%= rqIntAudU_ID %>">

                                <input type="hidden" id="hidAudU_TipoConteoCG142" value="<%= intAudU_TipoConteoCG142 %>">
                                
                                <div class="form-group row">
                                    
                                    <label class="col-sm-2 control-label">Comentario:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <textarea id="txtAAUEAudU_Comentario" class="form-control" placeholder="Comentario del Conteo" maxlength="8000"
                                        ><%= strAudU_Comentario %></textArea>
                                    </div>

                                    <label class="col-sm-2 control-label">Hallazgo:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selAAUEAudU_HallazgoCG144" class="form-control">

                                        </select>
                                    </div>

                                </div>

                                <!-- Tipo de Conteo -->
<%
    var bolCanTotLec = (intAudU_TipoConteoCG142 == 2 || intAudU_TipoConteoCG142 == 3 )
%>
                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">Cantidad Encontrada:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_ArticulosConteoTotal" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_ArticulosConteoTotal %>" <%= ( ( bolCanTotLec ) ? "readonly" : "" ) %> >
                                    </div>
                                </div>    
<%
    if( intAudU_TipoConteoCG142 == 2 ){
%>
                                <div class="form-group row">
                                    
                                    <label class="col-sm-2 control-label">Cantidad MB:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_MBCantidad" class="form-control" placeholder="Total" 
                                        maxlength="10" autocomplete="off" value="<%= intAudU_MBCantidad %>" onkeyup="AuditoriaUbicacion.Sumar();">
                                    </div>
                                
                                    <label class="col-sm-2 control-label">Cantidad Articulos en MB:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_MBCantidadArticulos" class="form-control" placeholder="Total" 
                                        maxlength="10" autocomplete="off" value="<%= intAudU_MBCantidadArticulos %>" onkeyup="AuditoriaUbicacion.Sumar();" >
                                        </div>

                                </div>
                                    
                                <div class="form-group row">
                                    
                                    <label class="col-sm-2 control-label">Sobrante:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_MBCantidadSobrante" class="form-control" placeholder="Total" 
                                        maxlength="10" autocomplete="off" value="<%= intAudU_MBCantidadSobrante %>" onkeyup="AuditoriaUbicacion.Sumar();" >
                                    </div>
                                    
                                </div>
<%
    }

    if( intAudU_TipoConteoCG142 == 3 ){
%>
                                <div class="form-group row">
                                    
                                    <div class="ibox">
                                        <div class="ibox-title">
                                            <h4>Series</h4>
                                            <div class="ibox-tools">    

                                            </div>
                                        </div>
                                        <div class="ibox-content">
                                            <div class="row"> 
                                                <div class="col-sm-12 m-b-xs">    
                                                    <div class="form-group row">
                                    
                                                        <label class="col-sm-2 control-label">Serie:</label>
                                                        <div class="col-sm-4 m-b-xs">
                                                            <input type="text" id="inpAAUESerie" class="form-control" placeholder="Total" 
                                                             maxlength="50" autocomplete="off" value="" >
                                                        </div>

                                                    </div>

                                                    <div class="form-group row" id="divSeries">

                                                    </div>

                                                </div>

                                            </div>

                                        </div>

                                    </div>

                                </div>
<%
    }
%>
                            </div>
                        </div>
                    </div>
                    <div class="ibox-footer">
                        <div class="row" style="margin-right: 0px;">
                            <div class="pull-right">
                                <a class="btn btn-white" onclick="AuditoriasUbicacion.Cancelar();">
                                    <i class="fa fa-times"></i> Cancelar
                                </a>
                                <a class="btn btn-success" onclick="AuditoriasUbicacion.Terminar();">
                                    <i class="fa fa-check"></i> Terminar
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
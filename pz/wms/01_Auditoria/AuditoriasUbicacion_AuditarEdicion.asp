<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Auditoria Pallet - Auditoria: Creación de archivo
var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntAudU_ID = Parametro("AudU_ID", -1)

var intErrorNumero = 0
var strErrorDescripcion = ""

var strUbi_Nombre = ""
var StrPT_LPN = ""

var intAud_ID = 0
var intPT_ID = 0

var intAudU_MBCantidad = 0
var intAudU_MBCantidadArticulos = 0
var intAudU_ArticulosConteoTotal = 0
var intAudU_TipoConteoCG142 = 0
var intAudU_HallazgoCG144 = 0
var srtAudU_Comentario = ""

//Extracción de informacion de la Auditoria Ubicacion - Pallet

var sqlAAU = "EXEC SPR_Auditorias_Ubicacion "
      + "@Opcion = 1000 "
    + ", @AudU_ID = " + rqIntAudU_ID + " "

var rsAAU = AbreTabla(sqlAAU, 1, cxnTipo)

if( !(rsAAU.EOF) ){
    
    intAud_ID = rsAAU("Aud_ID").Value
    intPT_ID = rsAAU("PT_ID").Value
    strUbi_Nombre = rsAAU("Ubi_Nombre").Value
    StrPT_LPN = rsAAU("PT_LPN").Value
    intAudU_MBCantidad = rsAAU("AudU_MBCantidad").Value
    intAudU_MBCantidadArticulos = rsAAU("AudU_MBCantidadArticulos").Value
    intAudU_ArticulosConteoTotal = rsAAU("AudU_ArticulosConteoTotal").Value
    intAudU_TipoConteoCG142 = rsAAU("AudU_TipoConteoCG142").Value
    intAudU_HallazgoCG144 = rsAAU("AudU_HallazgoCG144").Value
    srtAudU_Comentario = rsAAU("AudU_Comentario").Value

}

rsAAU.Close();


//Actualizacion de en Proceso
var sqlEnPro = "EXEC SPR_Auditorias_Ubicacion "
      + "@Opcion = 3000 "
    + ", @AudU_ID = " + rqIntAudU_ID + " " 
    + ", @AudU_EnProceso = 1 "
    + ", @AudU_EnProceso = 1 "

var rsEnPro = AbreTabla(sqlEnPro, 1, cxnTipo)

if( !(rsEnPro.EOF) ){
    intErrorNumero = rsEnPro("ErrorNumero").Value
    strErrorDescripcion = rsEnPro("ErrorDescripcion").Value
}

rsEnPro.Close()

//Actualizacion del Estatus de la Auditoria Pallet
if( intAud_ID > -1 && intPT_ID > -1){

    //Actualizacion de Estatus
    var sqlEstAud = "EXEC SPR_Auditorias_Pallet "
        + "@Opcion = 3000 "
        + ", @Aud_ID = " + intAud_ID + " "
        + ", @PT_ID = " + intPT_ID + " "
        + ", @PT_EstatusCG146 =  2 /* En proceso*/"

    var rsEstAud = AbreTabla(sqlEstAud, 1, cxnTipo)

    if( !(rsEstAud.EOF) ){
        intErrorNumero = rsEstAud("ErrorNumero").Value
        strErrorDescripcion = rsEstAud("ErrorDescripcion").Value
    }

    rsEstAud.Close()

}
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
              Contenedor: "selAAABEstatus"
            , SEC_ID: 146
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

                                    <label class="col-sm-2 control-label">Ubicacion:</label>
                                    <div class="col-sm-10 m-b-xs">
                                        <%= strUbi_Nombre %>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">LPN:</label>
                                    <div class="col-sm-10 m-b-xs">
                                        <%= StrPT_LPN %>
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
                                
                                <input type="hidden" id="hidAAUEAudU_ID" value="<%= rqIntAudU_ID %>">
                                <input type="hidden" id="hidAudU_TipoConteoCG142" value="<%= intAudU_TipoConteoCG142 %>">
                                
                                <div class="form-group row">
                                    
                                    <label class="col-sm-2 control-label">Comentario:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <textarea id="txtAAUEAudU_Comentario" class="form-control" placeholder="Comentario de la Auditoria" maxlength="8000"
                                        ><%=  %></textArea>
                                    </div>

                                    <label class="col-sm-2 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selAAUEAudU_HallazgoCG144" class="form-control">

                                        </select>
                                    </div>

                                </div>

                                <!-- Tipo de Conteo -->
<%
    switch( parseInt( intAudU_TipoConteoCG142 ) ){
        //Vista
        case 1: {
%>
                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">Cantidad Total:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="txtAAUEAudU_CantidadTotal" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_ArticulosConteoTotal %>" >
                                    </div>
                                </div>                              
<%
        } break;

        //MasterBox
        case 2: {
%>
                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">Cantidad Total:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="txtAAUEAudU_CantidadTotal" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_ArticulosConteoTotal %>" readonly >
                                    </div>

                                </div>

                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">Cantidad MB:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_MBCantidad" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_MBCantidad %>" >
                                    </div>

                                    <label class="col-sm-2 control-label">Cantidad Articulos en MB:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_MBCantidadArticulos" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_MBCantidadArticulos %>" >
                                    </div>
                                    
                                    <label class="col-sm-2 control-label">Sobrante:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpAAUEAudU_MBCantidadSobrante" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_MBCantidadSobrante %>" >
                                    </div>
                                    
                                </div>
<%
        } break;

        //Series
        case 3: {
%>
                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">Cantidad Total:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="txtAAUEAudU_CantidadTotal" class="form-control" placeholder="Total" 
                                         maxlength="10" autocomplete="off" value="<%= intAudU_ArticulosConteoTotal %>" >
                                    </div>
                                </div>
<%
        } break;    
    }

%>
                            </div>
                        </div>
                    </div>
                    <div class="ibox-footer">
                        <div class="row">
                            <div class="pull-right">
                                <button class="btn btn-white" onclick="">
                                    <i class="fa fa-times"></i> Cancelar
                                </button>
                                <button class="btn btn-info" onclick="">
                                    <i class="fa fa-floppy-o"></i> Guardar
                                </button>
                                <button class="btn btn-success" onclick="">
                                    <i class="fa fa-check"></i> Terminar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
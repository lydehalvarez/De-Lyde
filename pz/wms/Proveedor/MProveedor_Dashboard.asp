<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-10 Surtido: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/Proveedor/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntProv_ID = Parametro("Prov_ID", -1)

var bolHayProv = ( rqIntProv_ID > -1 )
%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Export -->
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<!-- Referencias -->
<script src="<%= urlBase %>js/Proveedor.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
<%
if( !(bolHayProv) ){
%>
        Proveedor.ComboCargar({
              Contenedor: "selTransportista"
            , Prov_EsPaqueteria: 1
            , Prov_Habilitado: 1
        });
<%
}
%>
        MProveedor.Dashboard.TotalesDiaCargar();
    });

    var MProveedor = {
          url: "/pz/wms/Proveedor/"
        , Dashboard: {
              Fecha: ""
            , Tipo: 1
            , Proveedor: -1
            , Cliente: -1
            , TotalesDiaCargar: function(){
                
                MProveedor.Dashboard.Proveedor = $("#selTransportista").val();
                MProveedor.Dashboard.Cliente = $("#selCliente").val();

                Procesando.Visualizar({Contenedor: "divProvDasDias"})

                $.ajax({
                      url: MProveedor.url + "MProveedor_Dashboard_TotalesDia.asp"
                    , method: "post"
                    , async: true
                    , data: {
                        Tarea: 1010
                        , Prov_ID: MProveedor.Dashboard.Proveedor
                        , Cli_ID: MProveedor.Dashboard.Cliente
                    }
                    , success: function( res ){
                        Procesando.Ocultar();
                        $("#divProvDasDias").html( res );
                        $("#divProvLis").html("");
                        
                        
                    }
                    , error: function(){
                        Avisa("error", "Proveedor - Dashboard", "NO se puede cargar los totales de Entregas Pendientes");
                        Procesando.Ocultar();
                    }
                });
            }
            , ListadoCargar: function(){

                var bolError = false;
                var arrError = [];

                var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
                
                MProveedor.Dashboard.Fecha = ( !(jsonPrm.Fecha == undefined) ) ? jsonPrm.Fecha : "";
                MProveedor.Dashboard.Tipo = ( !(jsonPrm.Tipo == undefined) ) ? jsonPrm.Tipo: 1;
                MProveedor.Dashboard.Proveedor = $("#selTransportista").val();
                MProveedor.Dashboard.Cliente = $("#selCliente").val();

                var strDias = ( !(jsonPrm.Dias == undefined) ) ? jsonPrm.Dias : "";

                if( MProveedor.Dashboard.Fecha == ""){
                    bolError = true;
                    arrError.push("- Seleccionar una Fecha");
                }

                if( MProveedor.Dashboard.Tipo == ""){
                    bolError = true;
                    arrError.push("- Seleccionar el Tipo");
                }

                if( bolError ){
                    Avisa("warning", "Transportista - Dashboard", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    
                    Procesando.Visualizar({Contenedor: "divProvLis"})
                    
                    $.ajax({
                        url: MProveedor.url + "MProveedor_Dashboard_Listado.asp"
                        , method: "post"
                        , async: true
                        , data: {
                            Tipo: MProveedor.Dashboard.Tipo
                            , Fecha: MProveedor.Dashboard.Fecha
                            , Prov_ID: MProveedor.Dashboard.Proveedor
                            , Cli_ID: MProveedor.Dashboard.Cliente
                            , EsTransportista: <%= ( bolHayProv ) ? 1 : 0 %>
                        }
                        , success: function( res ){
                            Procesando.Ocultar();
                            $("#divProvLis").html( res );
                            $("#spanProvLisDias").text( strDias + ' - ' + MProveedor.Dashboard.Fecha );
                            
                        }
                        , error: function(){
                            Avisa("error", "Transportista - Dashboard", "NO se puede cargar el Listado de las Entregas Pendientes");
                            Procesando.Ocultar();
                        }
                    });
                }
            }
            , Exportar: function(){

                var bolError = false;
                var arrError = [];

                if( MProveedor.Dashboard.Fecha == ""){
                    bolError = true;
                    arrError.push("- Seleccionar una Fecha");
                }

                if( MProveedor.Dashboard.Tipo == ""){
                    bolError = true;
                    arrError.push("- Seleccionar el Tipo");
                }

                if( bolError ){
                    Avisa("warning", "Transportista - Dashboard", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    Cargando.Iniciar();

                    $.ajax({
                        url: MProveedor.url + "MProveedor_Dashboard_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 1100
                            , Tipo: MProveedor.Dashboard.Tipo
                            , Fecha: MProveedor.Dashboard.Fecha
                            , Prov_ID: MProveedor.Dashboard.Proveedor
                            , Cli_ID: MProveedor.Dashboard.Cliente
                            , EsTransportista: <%= ( bolHayProv ) ? 1 : 0 %>
                        }
                        , success: function( res ){

                            var xlsData = XLSX.utils.json_to_sheet( res );
                            var xlsBook = XLSX.utils.book_new(); 

                            XLSX.utils.book_append_sheet(xlsBook, xlsData, "Entregas");

                            XLSX.writeFile(xlsBook, "Entregas.xlsx");

                            Cargando.Finalizar();
                        }
                        , error: function(){
                            Avisa("error", "Transportista - Dashboard", "NO se puede exportar las Entregas Pendientes");
                            Cargando.Finalizar();
                        }
                    });
                }

            }
        }
        , DetalleVer: function(){

            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intTA_ID = ( !(jsonPrm.TA_ID == undefined) ) ? jsonPrm.TA_ID : -1;
            var intOV_ID = ( !(jsonPrm.OV_ID == undefined) ) ? jsonPrm.OV_ID : -1;

            var strUrl = "";
            var intProv_ID = $("#selTransportista").val();

            if( intTA_ID > -1 ){
                strUrl = "TA/TA_Ficha.asp"
            } else if( intOV_ID > -1 ){
                strUrl = "OV/OV_Ficha.asp"
            }

            if( strUrl.length != "" ){
                $.ajax({
                    url: "/pz/wms/" + strUrl
                    , method: "post"
                    , async: true
                    , data: {
                          TA_ID: intTA_ID
                        , OV_ID: intOV_ID
                        , EsTransportista: <%= ( bolHayProv ) ? 1 : 0 %>
                    }
                    , success: function( res ){

                        $("#mdlProvDocBody").html( res );
                        $("#mdlProvDoc").modal("show");
                    
                    }
                    , error: function(){
                        Avisa("error", "Entrega", "No se puede Acceder a la Entrega");
                    }
                });
            } else {
                    Avisa("error", "Entrega", "No se puede Acceder a la Entrega.");
            }
        }
    }

</script>

<div class="wrapper wrapper-content">
    <div class="row">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h3>Entregas</h3>
<%
if( !(bolHayProv) ){
%>
                        <div class="ibox-tools">
                            <button type="button" class="btn btn-success" onclick="MProveedor.Dashboard.TotalesDiaCargar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                        </div>
<%
}
%>                        
                    </div>
<%
if( !(bolHayProv) ){
%>
                    <div class="ibox-content">
                        <div class="row">
                            <label class="col-sm-2 control-label">Cliente:</label>    
                            <div class="col-sm-4 m-b-xs">
<%
        CargaCombo("selCliente", "class='form-control select2'", "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre ASC", "", cxnTipo, "TODOS", "")
%>
                            </div>

                            <label class="col-sm-2 control-label">Transportista:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <select id="selTransportista" class="form-control">

                                </select>
                            </div>

                        </div>
                    </div>
<%
} else {
%>
                        <input type="hidden" id="selTransportista" value="<%= rqIntProv_ID %>">
<%
}
%>
                </div>
            </div>  
        </div>

    </div>

    <div class="row">

        <div class="row"  id="divProvDasDias">
           
        </div>

    </div>
    
    <div class="row">
        <div class="row">
            <div class="col-lg-12" id="divProvLis">
            
            </div>
        </div>

    </div>
   
</div>

<div class="modal fade" id="mdlProvDoc" tabindex="-1" role="dialog" aria-labelledby="divProvDoc" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divProvDoc">
                    <i class="fa fa-file-text-o"></i> Entrega 
                    <br />
                    <small>Entrega</small>
                </h2>
                
            </div>
            <div class="modal-body" id="mdlProvDocBody">

                
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>
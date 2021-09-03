<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAY-19 Carga masiva de Documentos: creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntProv_ID = Parametro("Prov_ID", -1)
var bolEsTransportista = Parametro("Transportista", 0)
%>

<link href="<%= urlBaseTemplate %>css/plugins/dropzone/dropzone.css" rel="stylesheet">

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnBusLim">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnBusBus">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                            <button class="btn btn-info btn-sm" type="button" id="btnCarArcVis">
                                <i class="fa fa-upload"></i> Cargar Archivos
                            </button>

                            <button class="btn btn-warning btn-sm" type="button" id="btnRelArcVis">
                                <i class="fa fa-handshake-o"></i> Relacionar Archivos
                            </button>

                        </div>
                    </div>

                    <div class="ibox-content">
<%
    if( !(bolEsTransportista) ){
%>
                        <div class="form-group row">
                            <label class="col-sm-2 control-label">
                                Transportista
                            </label>
                            <div class="col-sm-4 m-b-xs">
<%
                                CargaCombo("objBusProv_ID", "class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>
                            </div>

                        </div>
<%
    } else {
%>
                        <input type="hidden" id="objBusProv_ID" value="<%= rqIntProv_ID %>">
<%
    }
%> 
                        <div class="form-group row">

                            <label class="col-sm-2 control-label">Nombre Archivo</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpArcNom" class="form-control" placeholder="Nombre"
                                    autocomplete="off" maxlength="50">
                            </div>

                            <label class="col-sm-2 control-label">Folio</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpFol" class="form-control" placeholder="Folio SO o TRA"
                                    autocomplete="off" maxlength="50">
                            </div>                             

                        </div>

                        <div class="form-group row">

                            <label class="col-sm-2 control-label">Fecha</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpFecBus" class="form-control" placeholder="Rango Fechas"
                                    autocomplete="off" maxlength="50">
                                <input type="hidden" id="inpFecIni">
                                <input type="hidden" id="inpFecFin">
                            </div>

                            <label class="col-sm-2 control-label">Archivos Relacionados:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <select id="selArcRel" class="form-control select2">
                                    <option value="-1">TODOS</option>
                                    <option value="0">NO</option>
                                    <option value="1">SI</option>
                                </select>
                            </div>                       
                            
                        </div>
                            
                    </div>

                </div>

            </div>

            <div class="col-sm-12" id="divCarArc" style="display: none;">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Carga de Archivos </h5>
                        <div class="ibox-tools">
                            <button type="button" id="btnCarArcLim" class="btn btn-white">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>                            
                        </div>
                    </div>
                    <div class="ibox-content">
                        <form action="#" class="dropzone" id="formDropZone">
                            <div class="fallback">
                                <input name="inpArc" id="inpArc" type="file" multiple />
                            </div>
                        </form>
                    </div>
                    <div class="ibox-footer">
                        <div class="ibox-tools">
                            <button type="button" id="btnCarArcOcu" class="btn btn-white">
                                <i class="fa fa-times"></i> Cancelar
                            </button>

                            <button type="button" id="btnCarArcCar" class="btn btn-success">
                                <i class="fa fa-upload"></i> Cargar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-12" id="divRelArc" style="display: none;">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Relaci&oacute;n de Archivos </h5>
                        <div class="ibox-tools">
                            <button type="button" id="btnRelArcLim" class="btn btn-white">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button type="button" id="btnRelArcBus" class="btn btn-success">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        
                        <div class="form-group row">

                            <label class="col-sm-2 control-label">Folio</label>    
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpFolRel" class="form-control" placeholder="Folio SO o TRA"
                                    autocomplete="off" maxlength="50">
                            </div>

<%
    if( !(bolEsTransportista) ){
%>
                        <div class="form-group row">
                            <label class="col-sm-2 control-label">
                                Transportista
                            </label>
                            <div class="col-sm-4 m-b-xs">
<%
                                CargaCombo("objRelProv_ID", "class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>
                            </div>

                        </div>
<%
    } else {
%>
                        <input type="hidden" id="objRelProv_ID" value="<%= rqIntProv_ID %>">
<%
    }
%> 
                        </div>

                        <div class="form-group row cssFolio" style="display: none;">

                            <label class="col-sm-4 control-label">
                                <a id="lblDestino">

                                </a>
                                <br>
                                <small>
                                    <i class="fa fa-home"></i> Destino
                                </small>
                            </label>

                            <label class="col-sm-4 control-label">
                                <a id="lblFechaRegistro">

                                </a>
                                <br>
                                <small>
                                    <i class="fa fa-calendar"></i> Fecha Registro
                                </small>
                            </label>
                            <label class="col-sm-4 control-label">
                                <a id="lblTransportista">
                                    
                                </a>
                                <br>
                                <small>
                                    <i class="fa fa-truck"></i> Transportista
                                </small>
                            </label>
                        </div>

                    </div>
                    <div class="ibox-footer">
                        <div class="ibox-tools">
                            <button type="button" id="btnRelArcOcu" class="btn btn-white">
                                <i class="fa fa-times"></i> Cancelar
                            </button>

                            <button type="button" id="btnRelArcRel" class="btn btn-success">
                                <i class="fa fa-handshake-o"></i> Relacionar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                        <div class="ibox-tools">

                            <label class="pull-right form-group">
                                <span class="text-success" id="lblTotReg">

                                </span> Registros
                            </label>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <td>
                                        <input type="checkbox" id="chbTodArcRel" class="cssTodArcRel" style="display: none;"
                                        onclick="Proveedor.RelacionarArchivo.TodosSeleccionar()">
                                    </td>
                                    <td>#</td>
                                    <td>Estatus</td>
                                    <td>&nbsp;</td>
                                    <td>Archivo</td>
                                    <td>Folio</td>
                                    <td>Transportista</td>
                                    <td>Guia</td>
                                    <td>Fecha Registro</td>
                                    <td></td>
                                </tr>
                            </thead>
                            <tbody id="tboLis">

                            </tbody>
                            <tfoot>
                                <tr>
                                    <td id="tdDigCar" colspan="9">
                                    
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                    
            </div>

        </div>
    </div>
</div>

<!-- DROPZONE -->
<script src="<%= urlBaseTemplate %>js/plugins/dropzone/dropzone.js"></script>

<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        Dropzone.autoDiscover = false

        var myDropzone = new Dropzone("#formDropZone", { 
                paramName: "file"
                , maxFilesize: 4
                , dictDefaultMessage: "<strong>Zona de carga de archivos. </strong></br><i class='fa fa-file-text-o fa-5x'></i><br>Arrastrar a este cuadro los archivos o haz click aqu&iacute; para seleccionar;"
                , addRemoveLinks: true
                , dictRemoveFile: "Eliminar"
                , dictCancelUpload: "Cancelar Carga"
                , acceptedFiles: "image/*,application/pdf"
            });

       // $(".select2").select2();

        $('#inpFecBus').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
           // "setDate": Today,
            "autoApply": true,
			"ranges": {
               'Hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                
			   '7 Dias': [moment().subtract(6, 'days'), moment()],
               '15 Dias': [moment().subtract(15, 'days'), moment()],
			   '30 Dias': [moment().subtract(29, 'days'), moment()],
			},			
			"locale": {
				"format": "MM/DD/YYYY", 
				"separator": " - ",
				"applyLabel": "Aplicar",
				"cancelLabel": "Cancelar",
				"fromLabel": "Desde",
				"toLabel": "Hasta",
				"customRangeLabel": "Personalizado",
				"weekLabel": "W",
				"daysOfWeek": ["Do","Lu","Ma","Mi","Ju","Vi","Sa"],
				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio"
				               ,"Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
			//"alwaysShowCalendars": true,	
			}}, function(start, end, label) {
				$("#inpFecIni").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpFecFin").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpFecBus").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );
        
    });

    $(document).ready(function(){
        
        //Buscador
        $("#btnBusLim").on("click", function(){ 
            Proveedor.Buscar.FiltrosLimpiar(); 
        });

        $("#btnBusBus").on("click", function(){ 
            Proveedor.Buscar.ListadoBuscar(); 
        });

        $("#btnRelArcBus").on("click", function(){
            Proveedor.RelacionarArchivo.FolioBuscar();
        });

        //Carga de Archivos
        $("#btnCarArcVis").on("click", function(){
            Proveedor.CargarArchivo.FormularioVisualizar();
        });

        $("#btnCarArcLim").on("click", function(){
            Proveedor.CargarArchivo.FormularioLimpiar();
        });

        $("#btnCarArcCar").on("click", function(){
            Proveedor.CargarArchivo.ArchivosCargar();
        });

         $("#btnCarArcOcu").on("click", function(){
            Proveedor.CargarArchivo.FormularioOcultar();
        });

        //Relacionador de Archivos
        $("#btnRelArcVis").on("click", function(){
            Proveedor.RelacionarArchivo.FormularioVisualizar();
        });

        $("#btnRelArcLim").on("click", function(){
            Proveedor.RelacionarArchivo.FormularioLimpiar();
        });

        $("#btnRelArcRel").on("click", function(){
            Proveedor.RelacionarArchivo.Relacionar();
        });

        $("#btnRelArcOcu").on("click", function(){
            Proveedor.RelacionarArchivo.FormularioOcultar();
        });

    });

    var Buscar = {
          RegistrosPagina: 100
        , Filtros: {
              ArchivoNombre: ""
            , ArchivoRelacionado: -1
            , Folio: ""
            , FechaBuscar: ""
            , FechaInicial: ""
            , FechaFinal: ""
            , Prov_ID: -1
        }
        , FiltrosLimpiar: function(){
            
            $("#inpArcNom").val("");
            $("#selArcRel").val("-1");
            $("#inpFol").val("");
            $("#inpFecBus").val("");
            $("#inpFecIni").val("");
            $("#inpFecFin").val("");
            $("#selFilProv_ID").val("-1");

            this.Filtros.ArchivoNombre = "";
            this.Filtros.ArchivoRelacionado = "-1"
            this.Filtros.Folio = "";
            this.Filtros.FechaBuscar = "";
            this.Filtros.FechaInicial = "";
            this.Filtros.FechaFinal = "";
            this.Filtros.Prov_ID = "-1"
        }
        , ListadoBuscar: function(){

            Proveedor.CargarArchivo.FormularioOcultar();
            Proveedor.RelacionarArchivo.FormularioOcultar();

            var bolError = false;
            var arrError = [];

            var intProv_ID = $("#objBusProv_ID").val();
            var strArchivoNombre = $("#inpArcNom").val();
            var intArchivoRelacionado = $("#selArcRel").val();
            var strFolio = $("#inpFol").val()
            var dateFechaBuscar = $("#inpFecBus").val();
            var dateFechaInicial = $("#inpFecIni").val();
            var dateFechaFinal = $("#inpFecFin").val();

           if( strArchivoNombre == "" && intArchivoRelacionado == -1 && strFolio == "" && dateFechaInicial == "" && dateFechaFinal == "" ){
               bolError = true;
               arrError.push("- Introducir al menos un filtro de b&uacute;squeda")
           }

            if( bolError ){
                Avisa("warning", "Buscar Archivo", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
            
                this.Filtros.ArchivoNombre = $("#inpArcNom").val();
                this.Filtros.ArchivoRelacionado = $("#selArcRel").val();
                this.Filtros.Folio = $("#inpFol").val()
                this.Filtros.FechaBuscar = $("#inpFecBus").val();
                this.Filtros.FechaInicial = $("#inpFecIni").val();
                this.Filtros.FechaFinal = $("#inpFecFin").val();
                this.Filtros.Prov_ID = $("#objBusProv_ID").val();

                this.ListadoCargar(true);
            }
        }
        , ListadoCargar: function( prmBolIniBus ){
            var intReg =  $(".cssReg").length;
            var intSigReg = ( prmBolIniBus ) ? 0: intReg;
            var intRegPags = $("#inpRegPag").val();

            var intRegPag = (intRegPags == "" || intRegPags == undefined ) ? this.RegistrosPagina : intRegPags;

            if( prmBolIniBus ){
                $("#tboLis").html("");
                $("#lblTotReg").text("");
            }

            Procesando.Visualizar({Contenedor: "tdDigCar"});

            $.ajax({
                url: Proveedor.url + "MProveedor_CargaArchivosMasivo_Listar.asp"
                , method: "post"
                , async: true
                , data: {
                      Prov_ID: this.Filtros.Prov_ID
                    , ArchivoNombre: this.Filtros.ArchivoNombre
                    , ArchivoRelacionado: this.Filtros.ArchivoRelacionado
                    , Folio: this.Filtros.Folio
                    , FechaInicial: this.Filtros.FechaInicial
                    , FechaFinal: this.Filtros.FechaFinal
                    , SiguienteRegistro: intSigReg
                    , RegistrosPagina: intRegPag
                }
                , success: function( res ){

                    Procesando.Ocultar();

                    if( prmBolIniBus ){
                        $("#tboLis").html( res ); 
                    } else {
                        $("#tboLis").append( res ); 
                    }

                    var objMas = "";

                    if( res != ""){

                        objMas = "<div class='row'>"
                                + "<div class='col-sm-9'>"
                                    + "<button type='button' class='btn btn-white btn-block' onClick='Proveedor.Buscar.ListadoCargar()'>"
                                        + "<i class='fa fa-arrow-down'></i> Ver mas"
                                    + "</button>" 
                                + "</div>"
                                + "<div class='col-sm-2 input-group'>"
                                    + "<input type='number' id='inpRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='100' maxlength='3' >"
                                    + "<span class='input-group-addon'> Reg/Pag </span>"
                                + "</div>"
                            + "</div>"

                    } else if( prmBolIniBus ){
                        objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                    }

                    $("#tdDigCar").html(objMas);
                }
                , error: function(){

                    Avisa("error", "Carga masiva archivos", "No realizó la peticion");

                    Procesando.Ocultar();
                }
            });

        }
        , ListadoRegistrosContar: function(){
            var intReg = $(".cssReg").length;

           $("#lblTotReg").text(intReg);
        }
        , ListadoLimpiar: function(){
            $("#tboLis").html(""); 
            $("#tdDigCar").html("");
        }
    }

    var CargarArchivo = {
          FormularioVisualizar: function(){
            $("#divCarArc").show();
            $("#btnCarArcVis").prop("disabled", true);

            RelacionarArchivo.FormularioOcultar();
            Buscar.ListadoLimpiar();
        }
        , FormularioOcultar: function(){
            $("#divCarArc").hide();
            $("#btnCarArcVis").prop("disabled", false);

            CargarArchivo.FormularioLimpiar();
        }
        , FormularioLimpiar: function(){
           var arrFiles = $('.dropzone')[0].dropzone.files;

            arrFiles.forEach(function(file) { 
                file.previewElement.remove(); 
            });

            arrFiles.splice(0, arrFiles.length);

            $('.dropzone').removeClass('dz-started');
        }
        , ArchivosCargar: function(){
            var bolError = false;
            var arrError = [];

            var intIDUsuario = $("#IDUsuario").val();
            var intProv_ID = $("#objBusProv_ID").val();

            var aFiles = $('.dropzone')[0].dropzone.files;

            if( aFiles.length == 0 ){
                bolError = true;
                arrError.push("- Agregar al menos un archivo");
            } else {
                var arrArcNo = [];

                var exrArc = /\.(pdf)|(bmp)|(gif)|(jpeg)|(jpg)|(png)$/g;

                for(var i=0;i<aFiles.length;i++){

                    var strNombre = aFiles[i].name;

                    if( !(strNombre.match(exrArc) ) ){
                        arrArcNo.push("- " + strNombre);
                    }

                }

                if( arrArcNo.length > 0 ){
                    bolError = true;
                    arrError.push("Archivos no permitidos: <br> " + arrArcNo.join("<br>"));
                }
            }

            if( bolError ){

                Avisa("warning", "Carga archivos masivos", "Verificar Formulario<br>" + arrError.join("<br>"));

            } else {
                
                for(var i=0;i<aFiles.length;i++){
                    
                    Cargando.Iniciar();

                    var strNombre = aFiles[i].name;
                    var strNombreArchivo = "";
                    var intDoc_ID = -1

                    var aFile = aFiles[i];
            
                    var formData = new FormData();
                    
                    formData.append("file", aFile);

                    //Registrar el archivo en la BD
                    $.ajax({
                        url: Proveedor.url + "MProveedor_CargaArchivosMasivo_Ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 2000
                            , ArchivoNombre: strNombre
                            , Prov_ID: intProv_ID
                            , IDUsuario: intIDUsuario
                        }
                        , success: function( resReg ){

                            //validacion de registro en BD correcto
                            if( resReg.Error.Numero == 0 ){

                                CargarArchivo.FilaAgregar( resReg.Registro );

                                var intDoc_ID = resReg.Registro.Doc_ID;
                                var strNombreArchivo = resReg.Registro.Doc_NombreArchivo;

                                Avisa("warning", "Carga archivos masivos - Registro", resReg.Error.Descripcion);
                                
                                $.ajax({
                                    url: Proveedor.url + "MProveedor_CargaArchivosMasivo_Cargar.asp?Doc_Nombre=" + strNombreArchivo
                                    , method: "post"
                                    , async: true
                                    , dataType: "json"
                                    , data: formData
                                    , cache: false
                                    , contentType: false
                                    , processData: false
                                    , success: function( resCar ){

                                        if( resCar.Error.Numero == 0 ){
                                            
                                            $.ajax({
                                                  url: Proveedor.url + "MProveedor_CargaArchivosMasivo_Ajax.asp"
                                                , method: "post"
                                                , async: true
                                                , dataType: "json"
                                                , data: {
                                                    Tarea: 3110
                                                    , Doc_ID: intDoc_ID
                                                    , IDUsuario: intIDUsuario
                                                }
                                                , success: function( resCarReg ){
                                                    if( resCarReg.Error.Numero == 0 ){

                                                        CargarArchivo.FilaActualizar( resCarReg.Registro );

                                                        Avisa("success", "Carga archivos masivos - Actualizar Carga", resCarReg.Error.Descripcion);
                                                    } else {
                                                        Avisa("warning", "Carga archivos masivos - Actualizar Carga", resCarReg.Error.Descripcion);
                                                    }

                                                    Cargando.Finalizar();
                                                }
                                                , error: function(){
                                                    Avisa("warning", "Carga archivos masivos - Actualizar Carga", "Error en la pericion de actualizacion de carga");
                                                    Cargando.Finalizar();
                                                }
                                            });

                                        } else {
                                            Avisa("warning", "Carga archivos masivos - Carga", resCar.Error.Descripcion);
                                        }

                                        //Visualizar icono
                                        CargarArchivo.IconoVisualizar({
                                              Doc_ID: intDoc_ID
                                            , Docs_Cargado: 1
                                            , Error: {
                                                Numero: resCar.Error.Numero
                                            }
                                        });

                                    }
                                    , error: function(){
                                        Avisa("error", "Carga archivos masivos - Carga", "Error en la peticion de carga de archivo");

                                        CargarArchivo.IconoVisualizar({
                                              Doc_ID: intDoc_ID
                                            , Docs_Cargado: 1
                                            , Error: {
                                                Numero: 1
                                            }
                                        });

                                        Cargando.Finalizar();
                                    } 
                                });

                            } else {
                                Avisa("warning", "Carga archivos masivos - Registro", resReg.Error.Descripcion);
                            }

                           
                        }
                        , error: function(){
                            Avisa("error", "Carga archivos masivos - Registro", "Error en la peticion de registro de archivo");
                            Cargando.Finalizar();
                        }
                    });

                }

                CargarArchivo.FormularioOcultar();

            }
        }
        , FilaAgregar( prmJson ){
            var intDoc_ID = prmJson.Doc_ID;

            var intID = ( $(".cssReg").length ) + 1;

            var objFila = "<tr class='cssReg'>"
                    + "<td id='regEsRel_" + intDoc_ID + "'></td>"
                    + "<td>" + intID + "</td>"
                    + "<td class='col-sm-1' id='regEst_ID_" + intDoc_ID + "'></td>"
                    + "<td id='regCar_" +intDoc_ID + "'></td>"
                    + "<td class='col-sm-3'>" + prmJson.Doc_Nombre + "</td>"
                    + "<td class='col-sm-2' id='regDoc_Folio_" + intDoc_ID + "'></td>"
                    + "<td class='col-sm-2' id='regTransportista_" + intDoc_ID + "'></td>"
                    + "<td class='col-sm-2' id='regGuia_" + intDoc_ID + "'></td>"
                    + "<td class='col-sm-2'>" + prmJson.Docs_FechaRegistro + "</td>"
                    + "<td></td>"
                + "</tr>"

            $("#tboLis").append( objFila );

            CargarArchivo.FilaActualizar({
                  Doc_ID: intDoc_ID
                , Est_ID: prmJson.Est_ID
                , Est_Nombre: prmJson.Est_Nombre
                , Doc_Folio: prmJson.Doc_Folio
                , EsRelacionado: prmJson.EsRelacionado
                , Transportista: prmJson.Transportista
                , Guia: prmJson.Guia
            });

           CargarArchivo.IconoVisualizar({
                  Doc_ID: prmJson.Doc_ID
                , Docs_Cargado: 0
                , Error: {
                    Numero: 0
                }
            });

            Buscar.ListadoRegistrosContar();

        }
        , FilaActualizar: function( prmJson ){

            var intDoc_ID = prmJson.Doc_ID
            var strlblEstatus = "";

            switch( parseInt(prmJson.Est_ID) ){
                case Proveedor.Estatus.Nuevo: { strlblEstatus = ""; } break;
                case Proveedor.Estatus.Relacionado: { strlblEstatus = "label-info"; } break;
                case Proveedor.Estatus.NoRelacionado: { strlblEstatus = "label-warning"; } break;
                case Proveedor.Estatus.Relacion_Manual: { strlblEstatus = "label-success"; } break;
            }

            var objLbl = "<label class='label " + strlblEstatus + "'>"
                    + "" + prmJson.Est_Nombre + ""
                + "</label>"

            $("#regEst_ID_" + intDoc_ID).html( objLbl );
            $("#regDoc_Folio_" + intDoc_ID).text( prmJson.Doc_Folio );
            $("#regTransportista_" + intDoc_ID).text( prmJson.Transportista );
            $("#regGuia_" + intDoc_ID).text( prmJson.Guia );

            CargarArchivo.Relacionador({
                  Doc_ID: intDoc_ID
                , EsRelacionado: prmJson.EsRelacionado
            });

        }
        , Relacionador: function( prmJson ){

            var intDoc_ID = prmJson.Doc_ID

            if( prmJson.EsRelacionado == 0 ){
    
                var objRel = "<input type='checkbox' class='cssAlgArcRel' value='" + intDoc_ID + "' style='display: none;' onclick='Proveedor.RelacionarArchivo.AlgunoSeleccionar()'>"

                $("#regEsRel_" + intDoc_ID).html( objRel );

            } else {

                $("#regEsRel_" + intDoc_ID).html("");

            }

        }
        , IconoVisualizar: function( prmJson ){
            
            var icoObj = "";

            var intDoc_ID = prmJson.Doc_ID;
            var intDocs_Cargado = prmJson.Docs_Cargado;
            var intError = prmJson.Error.Numero;

            if( intDocs_Cargado == 0 ){
                icoObj = "<i class='text-info fa fa-spinner fa-pulse fa-lg fa-fw' title='Cargando...'></i>";
            } else {
                if( intError == 0) {
                    icoObj = "<i class='text-success fa fa-check fa-lg' title='Se carg&oacute;'></i>";
                } else {
                    icoObj = "<i class='text-danger fa fa-times fa-lg' title='No se carg&oacute;'></i>";
                }
            }

            $("#regCar_" + intDoc_ID).html( icoObj );
            
        } 
    }

    var RelacionarArchivo = {
          FormularioVisualizar: function(){
            $("#divRelArc").show();
            $("#btnRelArcVis").prop("disabled", true);

            $(".cssTodArcRel").show();
            $(".cssAlgArcRel").show();

             Proveedor.CargarArchivo.FormularioOcultar();
        }
        , FormularioOcultar: function(){
            $("#divRelArc").hide();
            $("#btnRelArcVis").prop("disabled", false);

            this.FormularioLimpiar();
        }
        , FormularioLimpiar: function(){
            $("#inpFolRel").val("");
            $(".cssAlgArcRel:checked").prop("checked", false);
            $(".cssAlgArcRel").hide();
            $(".cssTodArcRel").hide();

            $("#lblDestino").text("")
            $("#lblFechaRegistro").text("")
            $("#lblTransportista").text("")

            $(".cssFolio").hide();
        }
        , FolioBuscar: function(){
            var bolError = false;
            var arrError = [];

            var exrTR = /^TRA-[0-9]{6}$/g;
            var exrOV = /^SO-[0-9]{9}$/g;

            var strFolRel = $("#inpFolRel").val().trim();
            var intProv_ID =$("#objRelProv_ID").val();
            
            if( strFolRel == ""){
                bolError = true;
                arrError.push("- Agregar el Folio a Relacionar los archivos");
            } else {

                if( !(exrTR.test(strFolRel)) && !(exrOV.test(strFolRel)) ){
                    bolError = true
                    arrError.push("- Folio a relacionar no cumple con el formato");
                }

            }

            if( bolError ){
                Avisa("warning", "Buscar Folio", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                Cargando.Iniciar();

                Proveedor.RelacionarArchivo.DatosFolioLimpiar();

                $.ajax({
                    url: Proveedor.url + "MProveedor_CargaArchivosMasivo_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 1100
                        , Folio: strFolRel
                        , Prov_ID: intProv_ID
                    }
                    , success: function( res ){

                        //Campos de busqueda de transferencia u orden de venta
                        if( res.Error.Numero == 0 ){
                            Proveedor.RelacionarArchivo.DatosFolioCargar( res.Registro );
                        } else {
                            Avisa("warning", "Buscar Folio", res.Error.Descripcion );
                        }
                        
                        Cargando.Finalizar()
                    }
                    , error: function(){
                        Avisa("error", "Buscar Folio", "No ejecuto la peticion"); 
                        Cargando.Finalizar()
                    }
                });

            }
        }
        , DatosFolioCargar: function( prmJsonReg ){
            $(".cssFolio").show();

            $("#lblDestino").text(prmJsonReg.Destino);
            $("#lblFechaRegistro").text(prmJsonReg.FechaRegistro);
            $("#lblTransportista").text(prmJsonReg.Transportista);
        }
        , DatosFolioLimpiar: function(){
            $(".cssFolio").hide();

            $("#lblDestino").text("");
            $("#lblFechaRegistro").text("");
            $("#lblTransportista").text("");
        }
        , Relacionar: function(){
            var bolError = false;
            var arrError = [];
            var strDocs = "";
            var arrDocs = [];

            var exrTR = /^TRA-[0-9]{6}$/g;
            var exrOV = /^SO-[0-9]{9}$/g;

            var intIDUsuario = $("#IDUsuario").val();

            var strFolRel = $("#inpFolRel").val().trim();

            var intProv_ID = $("#objRelProv_ID").val();
            
            if( strFolRel == ""){
                bolError = true;
                arrError.push("- Agregar el Folio a Relacionar los archivos");
            } else {

                if( !(exrTR.test(strFolRel)) && !(exrOV.test(strFolRel)) ){
                    bolError = true
                    arrError.push("- Folio a relacionar no cumple con el formato");
                }

            }

            if( intProv_ID == -1 ){
                bolError = true;
                arrError.push("- Seleccionar el proveedor");
            }

            if( $(".cssAlgArcRel:checked").length == 0 ){
                bolError = true;
                arrError.push("- Seleccionar al menos un archivo a relacionar");
            } else {

                $(".cssAlgArcRel:checked").each(function(){
                    arrDocs.push($(this).val());
                });

                strDocs = arrDocs.join(",");
            }

            if( bolError ){
                Avisa("warning", "Relacion Archivos", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                
                Cargando.Iniciar();

                $.ajax({
                      url: Proveedor.url + "MProveedor_CargaArchivosMasivo_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 3100
                        , Folio: strFolRel
                        , Doc_IDs: strDocs
                        , Prov_ID: intProv_ID
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res) {

                        if( res.Error.Numero == 0){
                            Avisa("success", "Archivos Relacionados", res.Error.Descripcion);

                            Proveedor.RelacionarArchivo.FormularioOcultar();
                            Proveedor.Buscar.ListadoBuscar();
                        } else {
                            Avisa("warning", "Archivos Relacionados", res.Error.Descripcion);
                        }
                        
                        Cargando.Finalizar();
                    
                    }
                    , error: function(){
                        Avisa("error", "Archivos Relacionados", "No se ejecuto la peticion");

                        Cargando.Finalizar();
                    }
                });
            }
        }
        , AlgunoSeleccionar: function(){
            var bolSelTod = ( $(".cssAlgArcRel").length == $(".cssAlgArcRel:checked").length );

            $("#chbTodArcRel").prop("checked", bolSelTod);
        }
        , TodosSeleccionar: function(){
            var bolSelTod = $("#chbTodArcRel").is(":checked");

            $(".cssAlgArcRel").prop("checked", bolSelTod);
        }
    }

    var Proveedor = {
          url: "/pz/wms/Proveedor/" 
        , TipoDocumento: {
              Ninguno: 0
            , Transferencia: 1
            , OrdenVenta: 2
        }
        , Estatus: {
              Nuevo: 1
            , Relacionado: 2
            , NoRelacionado: 3
            , Relacion_Manual: 4
        }
        , Buscar: Buscar
        , CargarArchivo: CargarArchivo
        , RelacionarArchivo: RelacionarArchivo
    }

</script>
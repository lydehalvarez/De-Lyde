<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0

var rqIntProv_ID = Parametro("Prov_ID", -2)
%>

<!-- loading -->
<script src="/template/inspina/js/loading.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        /* Transportista */
        $("#btnTLMLimpiar").on("click", function(){
            Transportista.LimiteMonto.Limpiar();
        });

        $("#btnTLMGuardar").on("click", function(){
            Transportista.LimiteMonto.Guardar();
        });

        $("#inpTLMMontoLocal").on("keyup", function(){
            Transportista.LimiteMonto.Sumar();
        });

        $("#inpTLMMontoForaneo").on("keyup", function(){
            Transportista.LimiteMonto.Sumar();
        });

        /* Vehiculo */
        $(".cssVLMMontoLocal").on("keyup", function(){
            Vehiculo.LimiteMonto.Sumar({Objeto: this});
        });

        $(".cssVLMMontoForaneo").on("keyup", function(){
            Vehiculo.LimiteMonto.Sumar({Objeto: this});
        });

        $("#btnVLMTodoLimpiar").on("click", function(){
            Vehiculo.LimiteMonto.TodoLimpiar();
        });

        $("#btnVLMTodoGuardar").on("click", function(){
            Vehiculo.LimiteMonto.TodoGuardar();
        });

        $(".cssBtnVLMLimpiar").on("click", function(){
            Vehiculo.LimiteMonto.Limpiar({Objeto: this});
        });

        $(".cssBtnVLMGuardar").on("click", function(){
            Vehiculo.LimiteMonto.Guardar({Objeto: this});
        });

        Vehiculo.LimiteMonto.Sumar();      
        Transportista.LimiteMonto.Sumar();
        Vehiculo.LimiteMonto.Validar();

    });

    var Transportista = {
          url: "pz/wms/Proveedor/Transportista/"
        , LimiteMonto: {
            Guardar: function(){
                var bolError = false;
                var arrError = [];

                var expRegMon = /^[0-9]+([.])?([0-9]+)?$/g;

                var intProv_ID = $("#Prov_ID").val();
                var dblTLMMontoLocal = $("#inpTLMMontoLocal").val();
                var dblTLMMontoForaneo = $("#inpTLMMontoForaneo").val();

                var intIDUsuario = $("#IDUsuario").val();

                if( !(parseInt(intProv_ID) > -1) ){
                    bolError = true;
                    arrError.push("- Identificador de Proveedor no permitido");
                }

                if( parseFloat(dblTLMMontoLocal) <= 0 ){
                    bolError = true;
                    arrError.push("- Agregar Monto Local mayor a 0");
                }

                if( parseFloat(dblTLMMontoForaneo) <= 0 ){
                    bolError = true;
                    arrError.push("- Agregar Monto Foraneo mayor a 0");
                }

                if( bolError ){
                    Avisa("warning","Transportista - Limite Monto - Guardar","Verificar Formulario<br>" + arrError.join("<br>"));
                } else {
                    
                    $.ajax({
                          url: Transportista.url + "Transportista_LimiteMontoCarga_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 3910
                            , Prov_ID: intProv_ID
                            , Prov_LimiteMontoLocal: dblTLMMontoLocal
                            , Prov_LimiteMontoForaneo: dblTLMMontoForaneo
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){

                            if( res.Error.Numero == 0 ){
                                Avisa("success", "Transportista - Limite Monto - Guardar", res.Error.Descripcion );
                            } else {
                                Avisa("warning", "Transportista - Limite Monto - Guardar", res.Error.Descripcion );
                            }

                        }
                        , error: function(){
                            Avisa("error", "Transportista - Limite Monto - Guardar", "Error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }

                    });

                }
            }
            , Limpiar: function(){

                $("#inpTLMMontoLocal").val("");
                $("#inpTLMMontoForaneo").val("");

                $(".cssTLMTotal").text("");

            }
            , Sumar: function(){
                var dblTotalTra = 0.0;
                var dblTotalVeh = 0.0;

                $(".cssTLMMonto").each(function(){
                    dblTotalTra += ( !(isNaN($(this).val())) ) ? parseFloat($(this).val()) : parseFloat(0.0);
                });

                $(".cssTLMTotal").text(dblTotalTra);

                $(".cssVLMMonto").each(function(){
                    dblTotalVeh += ( !(isNaN($(this).text())) ) ? parseFloat($(this).text()) : parseFloat(0.0);
                });

                $(".cssVLMTotal").text(dblTotalVeh);

                Vehiculo.LimiteMonto.Validar();
            }
        }
    }

    var Vehiculo = {
          url: "pz/wms/Proveedor/Transportista/"
        , LimiteMonto: {
            Guardar: function( prmJson ){
                var objBase = prmJson.Objeto;
                var bolEsTodo = (prmJson.EsTodo != undefined) ? prmJson.EsTodo : false;
                var objPadre = $(objBase).parents("tr");

                var intProv_ID = $("#Prov_ID").val();
                var intVeh_ID = $(objPadre).data("veh_id");

                var dblVLMMontoLocal = $(".cssVLMMontoLocal", objPadre).val();
                var dblVLMMontoForaneo = $(".cssVLMMontoForaneo", objPadre).val();

                var intIDUsuario = $("#IDUsuario").val();

                $(".cssTdValida", objPadre).text("");

                var bolError = false;
                var arrError = [];

                var expRegMon = /^[0-9]+([.])?([0-9]+)?$/g;

                var objValida = "";

                if( !(parseInt(intProv_ID) > -1) ){
                    bolError = true;
                    arrError.push("- identificador de Proveedor no permitido");
                }

                if( !(parseInt(intVeh_ID) > -1) ){
                    bolError = true;
                    arrError.push("- identificador de Vehiculo no permitido");
                } 
                
                if( parseFloat(dblVLMMontoLocal) <= 0 ){
                    bolError = true;
                    arrError.push("- Agregar Monto Local mayor a 0");
                }

                if( parseFloat(dblVLMMontoForaneo) <= 0 ){
                    bolError = true;
                    arrError.push("- Agregar Monto Foraneo mayor a 0");
                }
                
                if( bolError ){

                    if( !(bolEsTodo) ){
                        Avisa("warning", "Vehiculo - Limite Monto - Guardar", "Verificar Formulario<br>" + arrError.join("<br>"));
                    }
                    
                    objValida = "<i class='fa fa-exclamation-circle fa-2x text-danger cssVehError' title='" + arrError.join(", ") + "'></i>"

                    $(".cssTdValida", objPadre).html(objValida);             

                } else {
                    
                    $.ajax({
                        url: Vehiculo.url + "Vehiculo_LimiteMontoCarga_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                            Tarea: 3910
                            , Prov_ID: intProv_ID
                            , Veh_ID: intVeh_ID
                            , Veh_LimiteMontoLocal: dblVLMMontoLocal
                            , Veh_LimiteMontoForaneo: dblVLMMontoForaneo
                            , IDUsuario: intIDUsuario
                        }
                        , beforeSend: function(){
                            if( !(bolEsTodo) ){
                                Cargando.Iniciar();
                            }
                        }
                        , success: function( res ){
                            if( res.Error.Numero == 0){
                                if( !(bolEsTodo) ){
                                    Avisa("success", "Vehiculo - Limite Monto - Guardar", res.Error.Descripcion);
                                }
                            } else {
                                if( !(bolEsTodo) ){
                                    Avisa("warning", "Vehiculo - Limite Monto - Guardar", res.Error.Descripcion);                                   
                                }

                                objValida = "<i class='fa fa-exclamation-circle fa-2x text-danger cssVehError' title='" + res.Error.Descripcion + "'></i>"

                                $(".cssTdValida", objPadre).html(objValida);
                            }
                        }
                        , error: function(){   
                            if( !(bolEsTodo) ){
                                Avisa("error", "Vehiculo - Limite Monto - Guardar", "error en la peticion");
                            }

                            objValida = "<i class='fa fa-exclamation-circle fa-2x text-danger cssVehError' title='error en la peticion'></i>"

                            $(".cssTdValida", objPadre).html(objValida);
                        }
                        , complete: function(){
                            if( !(bolEsTodo) ){
                                Cargando.Finalizar();
                            }
                        }
                    });

                }
                
            }
            , TodoGuardar: function(){

                var bolError = false;
                var arrError = [];

                Cargando.Iniciar();

                $(".cssBtnVLMGuardar").each(function(){
                    Vehiculo.LimiteMonto.Guardar({Objeto: this, EsTodo: true});
                });

                $(".cssVehError").each(function(){
                    
                    var objPadre = $(this).parents("tr");
                    var intID = $(objPadre).data("id");
                    
                    bolError = true;
                    arrError.push("- Error en Vehiculo No. " + intID);
                });

                if( bolError ){
                    Avisa("warning", "Vehiculo - Limite Monto - Guardar", "Verificar formulario<br>" + arrError.join("<br>"));
                } else {
                    Avisa("success", "Vehiculo - Limite Monto - Guardar", "Monto de Vehiculos Guardados")
                }

                Cargando.Finalizar();

            }
            , Limpiar: function( prmJson ){
                var objBase = prmJson.Objeto;
                var objPadre = $(objBase).parents("tr");

                $(".cssVLMMontoLocal", objPadre).val("");
                $(".cssVLMMontoForaneo", objPadre).val("");
                $(".cssTdValida", objPadre).text("");
            }
            , TodoLimpiar: function(){
                $(".cssVLMMontoLocal").val("");
                $(".cssVLMMontoForaneo").val("");
                $(".cssTdValida").text("");
            }
            , Sumar: function(){

                var dblTotLoc = 0.0;
                var dblTotFor = 0.0;

                $(".cssRegTraVeh").each(function(){

                    dblTotLoc += ( !(isNaN($(this).val())) ) ? parseFloat($(".cssVLMMontoLocal", this).val()) : parseFloat(0.0);
                    dblTotFor += ( !(isNaN($(this).val())) ) ? parseFloat($(".cssVLMMontoForaneo", this).val()) : parseFloat(0.0);

                });

                $(".cssVLMTotalLocal").text(dblTotLoc);
                $(".cssVLMTotalForaneo").text(dblTotFor);

                Transportista.LimiteMonto.Sumar();

                this.Validar();

            }
            , Validar: function(){

                var dblAceRan = 0.01;
                var dblPerRan = 0.10;

                var objValIcono = "";

                $(".cssValidacion").each(function(){

                    var objPadre = $(this).parent();

                    var dblTraMon = $(objPadre).find(".cssMontoTransportista").val();
                    var dblVehMon = $(objPadre).find(".cssMontoVehiculo").text();

                    var dblAceInf = dblTraMon * ( 1 - dblAceRan );
                    var dblAceSup = dblTraMon * ( 1 + dblAceRan );

                    var dblPerInf = dblTraMon * ( 1 - dblPerRan );
                    var dblPerSup = dblTraMon * ( 1 + dblPerRan );

                    if( 0 < dblVehMon && dblVehMon <= dblPerInf ){
                        objValIcono = "<i class='fa fa-arrow-circle-o-down fa-lg text-danger'></i><br><small>Abajo de lo permitido</small>"
                    }

                    if( dblPerInf < dblVehMon && dblVehMon <= dblAceInf ){
                        objValIcono = "<i class='fa fa-arrow-circle-o-down fa-lg text-warning'></i><br><small>Abajo de lo Aceptable</small>"
                    }

                    if( dblAceInf < dblVehMon && dblVehMon <= dblAceSup ){
                        objValIcono = "<i class='fa fa-check-circle fa-lg text-success'></i><br><small>Aceptable</small>"
                    }

                    if( dblAceSup < dblVehMon && dblVehMon <= dblPerSup ){
                        objValIcono = "<i class='fa fa-arrow-circle-o-up fa-lg text-warning'></i><br><small>Arriba de lo Aceptable</small>"
                    }

                    if( dblPerSup < dblVehMon ){
                        objValIcono = "<i class='fa fa-arrow-circle-o-up fa-lg text-danger'></i><br><small>Arriba de lo Permitido</small>"
                    }

                    $(this).html(objValIcono);

                });
                
            }
        }
    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">

            <div class="col-sm-12">

<%
    var intProv_LimiteMontoLocal = 0
    var intProv_LimiteMontoForaneo = 0

    var sqlTraLimMon = "EXEC SPR_Proveedor "
          + "@Opcion = 1000 "
        + ", @Prov_ID = " + rqIntProv_ID + " "

    var rsTraLimMon = AbreTabla(sqlTraLimMon, 1, cxnTipo)

    if( !(rsTraLimMon.EOF) ){
        intProv_LimiteMontoLocal = rsTraLimMon("Prov_LimiteMontoLocal").Value;
        intProv_LimiteMontoForaneo = rsTraLimMon("Prov_LimiteMontoForaneo").Value;
    }

    rsTraLimMon.Close()
%>

                <div class="ibox">

                    <div class="ibox-title">

                        <h5 class="text-navy">
                            <i class="fa fa-user-circle-o"></i> Transportista - Monto L&iacute;mite de Carga
                        </h5>

                        <div class="ibox-tools">
                            <button class="btn btn-white btn-sm" type="button" id="btnTLMLimpiar">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnTLMGuardar">
                                <i class="fa fa-floppy-o"></i> Guardar
                            </button>
                        </div>

                    </div>

                    <div class="ibox-content">

                        <div class="row form-group">

                            <label class="col-sm-2 control-label">
                                L&iacute;mite Monto
                            </label>
                            <label class="col-sm-3 control-label">
                                Transportista
                            </label>

                            <label class="col-sm-3 control-label">
                                Veh&iacute;culo
                            </label>
                            <label class="col-sm-2 control-label">
                                
                            </label>

                        </div>

                        <div class="row form-group">

                            <label class="col-sm-2 control-label">
                                Local
                            </label>
                            <div class="col-sm-3">
                                <input type="text" id="inpTLMMontoLocal" class="form-control text-right cssTLMMonto cssMontoTransportista" 
                                 value="<%= intProv_LimiteMontoLocal %>" autocomplete="off" maxlength="25" placeholder="0.0">
                            </div>

                            <label class="col-sm-3 control-label text-right cssVLMTotalLocal cssVLMMonto cssMontoVehiculo">
                                0.0
                            </label>
                            <label class="col-sm-2 control-label cssValidacion">
                                
                            </label>

                        </div>

                        <div class="row form-group">

                            <label class="col-sm-2 control-label">
                                Foraneo
                            </label>
                            <div class="col-sm-3">
                                <input type="text" id="inpTLMMontoForaneo" class="form-control text-right cssTLMMonto cssMontoTransportista" 
                                  value="<%= intProv_LimiteMontoForaneo %>" autocomplete="off" maxlength="25" placeholder="0.0">
                            </div>

                            <label class="col-sm-3 control-label text-right cssVLMTotalForaneo cssVLMMonto cssMontoVehiculo">
                                0.0
                            </label>
                            <label class="col-sm-2 control-label cssValidacion">
                                
                            </label>

                        </div>

                        <div class="row">

                            <label class="col-sm-2 control-label text-right">
                                Total
                            </label>
                            <label class="col-sm-3 control-label text-right cssTLMTotal">
                                0.0
                            </label>

                            <label class="col-sm-3 control-label text-right cssVLMTotal">
                                
                            </label>
                            <label class="col-sm-2 control-label">
                                
                            </label>

                        </div>

                    </div>

                </div>

            </div>

            <div class="col-sm-12">

                <div class="ibox">

                    <div class="ibox-title">

                        <h5 class="text-navy">
                            <i class="fa fa-truck"></i>  Veh&iacute;culo - Monto L&iacute;mite de Carga
                        </h5>

                        <div class="ibox-tools">
                            <button class="btn btn-white btn-sm" type="button" id="btnVLMTodoLimpiar">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnVLMTodoGuardar">
                                <i class="fa fa-floppy-o"></i> Guardar
                            </button>
                        </div>

                    </div>

                    <div class="ibox-content">

                        <div class="row">
<%
    var sqlVehLimMon = "EXEC SPR_Proveedor_Vehiculo " 
          + "@Opcion = 1000 "
        + ", @Prov_ID = " + rqIntProv_ID + " "

    var rsVehLimMon = AbreTabla(sqlVehLimMon, 1, cxnTipo)
%>
                            <table class="table table-responsive">
                                <thead>
                                    <tr>
                                        <th class="col-sm-1"></th>
                                        <th class="col-sm-4">Vehiculo</th>
                                        <th class="col-sm-2 text-right">
                                            <a class="cssVLMTotalLocal">
                                                0.0
                                            </a>
                                            <br>
                                            <small>
                                                Total Monto Local
                                            </small>
                                        </th>
                                        <th class="col-sm-2 text-right">
                                            <a class="cssVLMTotalForaneo">
                                                0.0
                                            </a>
                                            <br>
                                            <small>
                                                Total Monto Foraneo
                                            </small>
                                        </th>
                                        <th>

                                        </th>
                                        <th class="col-sm-3">

                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
<%
    if( !(rsVehLimMon.EOF) ){
        
        while( !(rsVehLimMon.EOF) ){
%>
                                    <tr class="cssRegTraVeh" data-veh_id="<%= rsVehLimMon("Veh_ID").Value %>" data-id="<%= rsVehLimMon("ID").Value %>">
                                        <td class="faq-question text-center">
                                            <h1 class="font-bold"><%= rsVehLimMon("ID").Value %></h1>
                                        </td>
                                        <td class="project-title">
                                            <a>
                                                <%= rsVehLimMon("Veh_PlacaVM").Value %>
                                            </a>
                                            <br>
                                            <small>
                                                <%= rsVehLimMon("Veh_TipoUnidad").Value %> - <%= rsVehLimMon("Veh_AnioModeloVM").Value %>
                                            </small>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control text-right cssVLMMontoLocal" value="<%= rsVehLimMon("Veh_LimiteMontoLocal").value %>"
                                            autocomplete="off" maxlength="25" placeholder="0.0">
                                        </td>
                                        <td>
                                            <input type="text" class="form-control text-right cssVLMMontoForaneo" value="<%= rsVehLimMon("Veh_LimiteMontoForaneo").value %>"
                                            autocomplete="off" maxlength="25" placeholder="0.0">
                                        </td>
                                        <td class="cssTdValida">

                                        </td>
                                        <td class="project-actions">
                                            <a class="btn btn-sm btn-white cssBtnVLMLimpiar" title="Limpiar">
                                                <i class="fa fa-trash-o"></i> Limpiar
                                            </a>
                                            <a class="btn btn-sm btn-success cssBtnVLMGuardar" title="Guardar">
                                                <i class="fa fa-floppy-o"></i> Guardar
                                            </a>
                                        </td>
                                    </tr>
<%
            rsVehLimMon.MoveNext()
        }
    } else {
%>
                                    <tr>
                                        <td colspan="6">
                                            <i class="fa fa-exclamation-circle text-success"></i> No hay Veh&iacute;culos
                                        </td>
                                    </tr>
<%
    }
%>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th class="col-sm-1"></th>
                                        <th class="col-sm-4">Vehiculo</th>
                                        <th class="col-sm-2 text-right">
                                            <a class="cssVLMTotalLocal">
                                                0.0
                                            </a>
                                            <br>
                                            <small>
                                                Total Monto Local
                                            </small>
                                        </th>
                                        <th class="col-sm-2 text-right">
                                            <a class="cssVLMTotalForaneo">
                                                0.0
                                            </a>
                                            <br>
                                            <small>
                                                Total Monto Foraneo
                                            </small>
                                        </th>
                                        <th>

                                        </th>
                                        <th class="col-sm-3">

                                        </th>
                                    </tr>
                                </tfoot>
                            </table>

                        </div>
                    </div>

                </div>

            </div>

        </div>
    </div>
</div>
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-NOV-12 Movimiento: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<script src="<%= urlBaseTemplate %>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="<%= urlBaseTemplate %>js/inspinia.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/pace/pace.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript">
 
    $(document).ready(function(){

        Ubicacion.ComboCargar();
//        TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar(-1);

        $(".comboSelect").select2();
        $("#selUbicacion").select2();
        $(".select2").hide();
    })
	
	$(document).keydown(function(e) {
		if(e.which == 27){
			TemporalCargaInicialCantidad.LimpiaEspacio(e) 
		}
    });
    
    $("#Pro_ID").val(-1);
	
	
	$('#mdlCISerie').on('shown.bs.modal', function () {
	  $('#inpMdlCISerie').focus()
	})
	
	$('.Cambia').keypress(function(e) {
            var str = $(this).val();
                str = str.replace(/[\']/g, "-");

                $(this).val(str);

    });

    var urlBase = "<%= urlBase %>";

    var TemporalCargaInicialCantidad = {
          LPNCambiarConteoFisico: function(){
            
            var jsonPrm = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intPT_ID = ( !( jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;

            var intConteoFisico = $("#ConteoFisico_" + intPT_ID).val();

            var bolError = false;
            var arrError = [];

            if( !(intPT_ID > -1) ){
                bolError = true;
                arrError.push("-Seleccionar el identificador del Pallet");
            }

            if( !(parseInt(intConteoFisico) > -1) ){
                bolError = true;
                arrError.push("-Agregar Cantidad positiva");
            }

            if( bolError ){
                Avisa("warning", "Carga Inicial", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                $.ajax({
                    url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 5
                        , PT_ID: intPT_ID
                        , ConteoFisico: intConteoFisico
                    }
                    , success: function(res){
                        if(res.result == 1){
                            Avisa("success", "Carga Inicial", res.message);
                        } else {
                            Avisa("warning", "Carga Inicial", res.message);
                        }
                    }
                });    
            }     
        }
        , LPNLimpiar: function(){

            $("#inpLPN").val("");
            $("#inpCantidadReal").val("");
            $("#divUbicacion").html("");
            $("#inpLPNUbicacion").val("");
			$("#btnNewLPN").prop('disabled',true)
            $("#Ubi_ID").val(-1);

        },
		LimpiaEspacio:function(e){
			console.log(e.which)
			TemporalCargaInicialCantidad.UbicacionSeleccionarLimpiar(); 
		}
        , LPNListadoCargar: function(){

            var intUbi_ID = $("#selUbicacion").val();
            //console.log("99) intUbi_ID " + intUbi_ID)
            var sUbicacion =  $("#inpUbicacion").val();
           // console.log("99) sUbicacion " + sUbicacion)
            $("#Ubi_ID").val(intUbi_ID);
            $("#loading").show('slow');
            $("#divLPN").hide('fast').empty();
            
           var dato = {}; 
           dato.Ubi_ID = intUbi_ID;    
           dato.Ubi_Nombre = sUbicacion    
           $("#divLPN").load("/pz/wms/Almacen/Temporal_CargaInicial_Grid.asp"
                             , dato
                             , function(){
                                $("#loading").hide('slow');
                                $("#divLPN").show('slow');
                                $('html, body').animate({ scrollTop: $('#divLPN').offset().top }, 'slow');
                               });


        }
        , LPNMover: function(){

            var strLPNUbicacion = $("#inpLPNUbicacion").val();
                strLPNUbicacion = strLPNUbicacion.replace(/[\']/g, "-");

                $("#inpLPNUbicacion").val(strLPNUbicacion);
			

            var strLPN = $("#inpLPN").val();
				strLPN = strLPN.replace(/[\']/g, "-");

                $("#inpLPN").val(strLPN);

            var intCantidadReal = $("#inpCantidadReal").val();
            var intIDUsuario = $("#IDUsuario").val();

            var bolError = false;
            var arrError = [];

            if( strLPNUbicacion == "" ){
                bolError = true;
                arrError.push("- Agregar la Ubicacion Destino");
            }

            if( strLPN == "" ){
                bolError = true;
                arrError.push("- Agregar el LPN");
            }

//            if( !( parseInt(intCantidadReal) > -1) ){
//                bolError = true;
//                arrError.push("- Agregar la Cantidad");
//            }

            if( bolError ){
                Avisa("warning", "Ubicacion", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                $.ajax({
                    url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 1
                        , LPNUbicacion: strLPNUbicacion
                        , LPN: strLPN
                        , CantidadReal: intCantidadReal
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res){

                        if(res.Error.Numero == 0){
                            Avisa("success", "Series", res.Error.Descripcion);

                            TemporalCargaInicialCantidad.LPNLimpiar();
                            TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar(-1);
                            TemporalCargaInicialCantidad.LPNListadoCargar();

                        } else {
                            Avisa("warning", "Series", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , LPNPorBuscarPoner: function(){
            
            var jsonPrm = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intPT_ID = ( !( jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;

            var arrError = [];
            var bolError = false;

            if( !(intPT_ID > - 1) ){
                bolError = true;
                arrError.push("- Seleccionar el LPN que estará por buscar");
            }

            if( bolError ){
                Avisa("warning", "LPN", "Verificar el formulario<br>" + arrError.join("<br>"));
            } else {

                $.ajax({
                    url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                        Tarea: 2
                        , PT_ID: intPT_ID
                    }
                    , success: function(res){
                        if( res.Error.Numero == 0 ){
                            Avisa("success", "LPN", res.Error.Descripcion);
                            TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar(-1);
                            TemporalCargaInicialCantidad.LPNListadoCargar();
                        } else {
                            Avisa("warning", "LPN", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , LPNPorBuscarListadoCargar: function(proid){
            

           $("#divPalletPerdidos").hide('fast').empty();
            
           var dato = {};
           dato.Pro_ID = proid;
           $("#divPalletPerdidos").load("/pz/wms/Almacen/Temporal_CargaInicial_PorBuscar.asp"
                             , dato
                             , function(){
                                $("#divPalletPerdidos").show('slow');
                               });

//            $.ajax({
//                url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
//                , method: "post"
//                , async: true
//                , data: {
//                    Tarea: 4
//                }
//                , success: function(res){
//                    $("#divPalletPerdidos").html(res);
//                }
//            });

        }
        , LPNSeleccionar: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intLPN = ( !(jsonPrm.LPN == undefined ) ) ? jsonPrm.LPN : "";
            var intCantidad = ( !(jsonPrm.Cantidad == undefined) ) ? jsonPrm.Cantidad : "";
            var Pro_ID = ( !(jsonPrm.Pro_ID == undefined) ) ? jsonPrm.Pro_ID : -1;

            $("#inpLPN").val(intLPN);
            $("#inpLPN").focus();
            $("#inpCantidadReal").val(intCantidad);
            
            TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar(Pro_ID)
        }
        , UbicacionSeleccionVisualizar: function(){
            var bolVisualiza = $("#chkUbicacion").is(":checked");

            if( bolVisualiza ){
                $(".Seleccion").show();
                $(".select2").show();
                $(".Escaneo").hide();
            } else {
                $(".Seleccion").hide();
                $(".select2").hide();
                $(".Escaneo").show();
            }
        }
        , UbicacionSeleccionar: function( e ){
            if( e.which == 13 ){
                var strUbicacion = $("#inpUbicacion").val();
                
                strUbicacion = strUbicacion.replace(/[\']/g, "-");

                $("#inpUbicacion").val(strUbicacion);
				
              //  $.post(urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
//                      ,{ Tarea:9,ubiNombre:strUbicacion }
//                      , function(res){
//                            $("#Ubi_ID").val(res);
//                            console.log("278) ubi_id " + res)
//                        });
               
                var intUbi_ID = -1

                $("#selUbicacion").find("option").each(function(){
                    if( $(this).text().trim().toLowerCase() == strUbicacion.toLowerCase() ){
                    intUbi_ID = $(this).val();
                      
                    }
                });
				$("#divUbicacion").html(strUbicacion);
				$("#btnNewLPN").prop('disabled',false);
                $("#selUbicacion").val(intUbi_ID);
                $("#select2-selUbicacion-container").text(strUbicacion);

                TemporalCargaInicialCantidad.LPNListadoCargar();
                
            }

        }
        , UbicacionSeleccionarLimpiar: function(){
            $("#inpUbicacion").val("");
            $("#inpUbicacion").focus();
		    $("#btnNewLPN").prop('disabled',true);
            $("#selUbicacion").val("");
            $("#select2-selUbicacion-container").text("TODOS");
            $("#divPalletPerdidos").hide('fast').empty();
        }
        , ImprimirLPN: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var url = "/pz/wms/Almacen/ImpresionLPN.asp?PT_ID="+intPT_ID+"";
        
            window.open(url, "Impresion Papeleta" );
        }
        , ImprimirAuditoria: function(pt_Object){
            var PT_ID = pt_Object.PT_ID;
			$.ajax({
				  url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
				, method: "post"
				, async: true
				, data: {
					  Tarea: 11
					, PT_ID: PT_ID
				}
				, success: function( res ){ 

						var url = "/pz/wms/Auditoria/Impresion_Papeleta2.asp?Aud_ID=1&PT_ID="+PT_ID;
						window.open(url, "Impresion Papeleta" );
				}
			});
        }
        , SeriesModalAbrir: function(){

            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var intUbi_ID = ( !(jsonPrm.Ubi_ID == undefined ) ) ? jsonPrm.Ubi_ID : -1; 
            var intPT_LPN = ( !(jsonPrm.PT_LPN == undefined ) ) ? jsonPrm.PT_LPN : "";
            var intPro_ID = ( !(jsonPrm.Pro_ID == undefined ) ) ? jsonPrm.Pro_ID : -1;
            var intUbi_Nombre = ( !(jsonPrm.Ubi_Nombre == undefined ) ) ? jsonPrm.Ubi_Nombre : ""; 
            var Pro_Sku = ( !(jsonPrm.Pro_Sku == undefined ) ) ? jsonPrm.Pro_Sku : ""; 
                     
            $("#Pro_ID").val(intPro_ID);

            this.SeriesModalLimpiar();

                $.ajax({
                     url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , cache: false
                    , dataType: "json"
                    , data: {
                          Tarea: 2020
                        , PT_ID: intPT_ID
                        , Ubi_ID: intUbi_ID
                    }
                    , success: function(res){
                        $("#lblMdlCITotal").text(res.Registro.Total);
                        $("#hidMdlCIUbi_ID").val(intUbi_ID);
                        $("#hidMdlCIPT_ID").val(intPT_ID);
                        $("#bMdlCIPT_LPN").text(intPT_LPN);
                        $("#bMdlCIUbi_Nombre").text(intUbi_Nombre);
                        $("#bMdlCIPro_Sku").text(Pro_Sku);
                        $("#mdlCISerie").modal('show');
                        
                        TemporalCargaInicialCantidad.SeriesModalListar();
                    }
                });

        }
        , SeriesModalGuardarEscaner: function( prmEvent ){

            var tecla = (document.all) ? prmEvent.keyCode : prmEvent.which;

            if( tecla == 13 ){
                this.SeriesModalGuardar();
            }
        }
        , SeriesModalGuardar: function(){

            var strSerie = $("#inpMdlCISerie").val();
            var intPT_ID = $("#hidMdlCIPT_ID").val();
            var intUbi_ID = $("#hidMdlCIUbi_ID").val();

            var bolError = false;
            var arrError = [];

            if( !(intPT_ID > -1) && !(intUbi_ID > -1) ){
                bolError = true;
                arrError.push("Identificadores del Pallet y la ubicacion No Permitidos");
            }

            if(strSerie == ""){
                bolError = true;
                arrError.push("Escanear la Serie correcta");
            }

            if( bolError ){
                Avisa("warning", "Series Escaneadas", arrError.join("<br>"));
            } else {
				var data = {
                          Entrante_PT_ID: intPT_ID
                        , Entrante_Ubi_ID: intUbi_ID
                        , Pro_ID:$("#Pro_ID").val()
                        , Serie: strSerie
                    }
				console.log(data)
                $.ajax({
                      url: "https://wms.lydeapi.com/api/s2008/CargaInicial/Escaneo"
                    , method: "post"
					, contentType:'application/json'
                    , async: true
                    , data: JSON.stringify(data)
                    , success: function(res){
						$('#inpMdlCISerie').val("");
						$('#inpMdlCISerie').focus();
						console.log(res)
                        if(res.result == 1){
                            Avisa("success", "Serie Escaneada", res.message);
                            $("#lblMdlCITotal").text(res.data.Total);
                            var color = "bg-info"  
                            $("#Encabezado").prepend(TemporalCargaInicialCantidad.Renglon(res));
							setTimeout(function(){
								$('#'+res.data.Serie).removeClass('bg-primary');
							},1500)
                            TemporalCargaInicialCantidad.SeriesModalLimpiarSerie();

                        } else if(res.result == -2){
							$('#'+res.data.Serie).addClass('bg-warning');

                            Avisa("error", "Error", res.message);
                        }else{
                            Avisa("error", "Error", res.message);
						}
                    }
                });
            }

        }
        , SeriesModalListar: function(){

            var intPT_ID = $("#hidMdlCIPT_ID").val();
            var intUbi_ID = $("#hidMdlCIUbi_ID").val();

            var bolError = false;
            var arrError = [];

            if( !(intPT_ID > -1) && !(intUbi_UD > -1) ){
                bolError = true;
                arrError.push("Identificadores del Pallet y la ubicacion No Permitidos");
            }

            if( bolError ){
                Avisa("warning", "Series Escaneadas", arrError.join("<br>"));
            } else {

                $.ajax({
                      url: urlBase + "Temporal_CargaInicial_Modal.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Tarea: 1100
                        , PT_ID: intPT_ID
                        , Ubi_ID: intUbi_ID
						, Pro_ID: $('#Pro_ID').val()
                    }
                    , success: function( res ){
                        $("#ModalBodySeries").html(res);
                    }
                });
            }

        }
        , SeriesModalLimpiar: function(){
            $("#hidMdlCIUbi_ID").val("");
            $("#hidMdlCIPT_ID").val("");
            $("#bMdlCIPT_LPN").text("");
            $("#bMdlCIUbi_Nombre").text("");
            $("#lblMdlCITotal").text("0");

            /*
            $("#divMdlCIListado tr").each(function(){
                if( $(this).prop("id") != "Encabezado" ){
                    $(this).remove();
                }
            })
            */
        }
        , SeriesModalCerrar: function(){
            this.SeriesModalListar();
            $("#mdlCISerie").modal('hide');
            $("#Pro_ID").val(-1);
        }
        , SeriesModalLimpiarSerie: function(){
            $("#inpMdlCISerie").val("");
			$("#inpMdlCISerie").focus();
        }
		,Renglon:function(arr){
			var renglon = '<tr id="'+arr.data.Serie+'" class="bg-primary"><td>'+arr.data.Total+'</td><td>'+arr.data.Serie+'</td><td>'+arr.message+'</td></tr>'
			return renglon;
		}
		,IntegraPallet:function(){
			swal({
				title: "A&ntilde;adir equipos",
				text: "<strong>Al confirmar se moveran todos los equipos escaneados a la ubicaci&oacute;n &iquest;Desea continua?</strong>", 
				type: "warning",
				closeOnConfirm: true,
				showCancelButton: true,
				confirmButtonText: "Si, adelante!",
				html:true
			}, function (data) {
				if(data){
					$.ajax({
						 url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
						, method: "post"
						, async: true
						, cache: false
						, dataType: "json"
						, data: {
							  Tarea: 6
							, PT_ID: $('#hidMdlCIPT_ID').val()
							, Ubi_ID: $('#hidMdlCIUbi_ID').val()
						}
						, success: function(res){
							if(res.result == 1){
								$('#mdlCISerie').modal('hide')
								TemporalCargaInicialCantidad.LPNListadoCargar();
								Avisa("success","Aviso",res.message)
							}else{
								Avisa("error","Error",res.message)
							}
						}
					});
				}
			});
		}
		,LPNCrea:function(){
			swal({
				title: "Crear nuevo LPN",
				text: "<strong>Al crear este nuevo LPN puedes meter unicamente series o art&iacute;culos del SKU seleccionado previamente<br />&iquest;Desea continuar?</strong>", 
				type: "warning",
				closeOnConfirm: true,
				showCancelButton: true,
				confirmButtonText: "Si, crear!",
				html:true
			}, function (data) {
				if(data){
					$.ajax({
						 url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
						, method: "post"
						, async: true
						, cache: false
						, dataType: "json"
						, data: {
							Tarea:8,
							Cli_ID:$('#Cli_ID').val(),
							Pro_ID:$('#cPro_ID').val(),
							Ubi_ID:$('#Ubi_ID').val()
						}
						, success: function(res){
							$('#ModalNuevoLPN').modal('hide');
							if(res.result == 1){
								TemporalCargaInicialCantidad.LPNListadoCargar();
								Avisa("success","Pallet creado",res.message)
							}else{
								Avisa("error","Ocurri&oacute; un error",res.message)
							}
						}
					});
				}
			});
			
		}
		,CargaProductos:function(cli_id){ 
			$("#divProductos").hide('slow')
			$("#divProductos").load("/pz/wms/Almacen/Temporal_CargaInicialCantidad_ajax.asp",{Tarea:7
			,Cli_ID:cli_id
			,SKU:$('#txtBuscaSKU').val()
			},
			function(){$("#divProductos").show('slow')}
			);
		}
		,GuardaCantidad :function(Cantidad){
			swal({
				title: "A&ntilde;adir "+Cantidad+" art&iacute;culo(s)",
				text: "<strong>Al confirmar se moveran todos los art&iacute;culos a la ubicaci&oacute;n seleccionada &iquest;Desea continua?</strong>", 
				type: "warning",
				closeOnConfirm: true,
				showCancelButton: true,
				confirmButtonText: "Si, adelante!",
				html:true
			}, function (data) {
				if(data){
					$.ajax({
						 url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
						, method: "post"
						, async: true
						, cache: false
						, dataType: "json"
						, data: {
							  Tarea: 12
							, PT_ID: $('#hidMdlCIPT_ID').val()
							, Ubi_ID: $('#hidMdlCIUbi_ID').val()
							, Pro_ID: $('#Pro_ID').val()
							, Cantidad: Cantidad
						}
						, success: function(res){
							if(res.result == 1){
								$('#mdlCISerie').modal('hide')
								TemporalCargaInicialCantidad.LPNListadoCargar();
								Avisa("success","Aviso",res.message)
							}else{
								Avisa("error","Error",res.message)
							}
						}
					});
				}
			});
		}
		
    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-9">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-white btn-sm" type="button" title="Limpiar Busqueda"
                                onclick="TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar(-1);">
                                <i class="fa fa-search"></i> Carga pallets sin ubicaci&oacute;n
                            </button>
                            <button class="btn btn-white btn-sm" type="button" title="Limpiar Busqueda"
                                onclick="TemporalCargaInicialCantidad.UbicacionSeleccionarLimpiar();">
                                <i class="fa fa-trash"></i> Limpiar
                            </button>
                            <button class="btn btn-success btn-sm Seleccion" type="button" id="btnBusLPN" title="Buscar"
                                onclick="TemporalCargaInicialCantidad.LPNListadoCargar()" style="display: none;">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                               
                                <div class="row">
                                    <label class="col-sm-2 control-label">
                                        Ubicaci&oacute;n:
                                    </label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpUbicacion" class="form-control Escaneo" autocomplete="off" placeholder="Ubicaci&oacute;n"
                                         onkeypress="TemporalCargaInicialCantidad.UbicacionSeleccionar(event);">
                                        
                                        <select id="selUbicacion" class="Seleccion form-control" style="display: none;">

                                        </select>                                        
                                    </div>

                                    <div class="col-sm-6 m-b-xs">
                                        <input type="checkbox" id="chkUbicacion" value="0" onclick="TemporalCargaInicialCantidad.UbicacionSeleccionVisualizar()" title="Seleccionar la ubicaci&oacute;n">
                                         Seleccionar Ubicacion
                                    </div>
                                    
                                </div>
                                   
                            </div>
                        </div>
                    </div>
                </div>
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Mover LPN</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-white btn-sm" type="button" onclick="TemporalCargaInicialCantidad.LPNLimpiar()">
                                <i class="fa fa-trash"></i> Limpiar
                            </button>
                            <button class="btn btn-primary btn-sm" type="button" id="btnNewLPN" disabled data-toggle="modal" data-target="#ModalNuevoLPN">
                                <i class="fa fa-plus"></i> Crear LPN
                            </button>
                            <button class="btn btn-success btn-sm" type="button" onclick="TemporalCargaInicialCantidad.LPNMover()">
                                <i class="fa fa-share"></i> Mover LPN
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                                <div class="row">
                                    <label class="col-sm-2 control-label">Ubicacion:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpLPNUbicacion" class="form-control Cambia" placeholder="Ubicacion" autocomplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label"></label>    
                                    <div class="col-sm-4 m-b-xs">
                                        
                                    </div>
                                </div>

                                <div class="row">
                                    <label class="col-sm-2 control-label">LPN:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpLPN" class="form-control Cambia" placeholder="LPN" autocomplete="off">
                                    </div>

                                    <label class="col-sm-2 control-label">Cantidad:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpCantidadReal" class="form-control" placeholder="Cantidad" autocomplete="off">
                                    </div>

                                </div>   
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="text-center" id="loading" style="display: none;">
                        <div class="spiner-example">
                            <div class="sk-spinner sk-spinner-three-bounce">
                                <div class="sk-bounce1"></div>
                                <div class="sk-bounce2"></div>
                                <div class="sk-bounce3"></div>
                            </div>
                        </div>
                        <div>Cargando informaci&oacute;n, espere un momento...</div>
                    </div>
                    <div id="divLPN">

                    </div>
                </div>
            </div>
            <div class="col-sm-3" id="divPalletPerdidos">
                    
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="Ubi_ID" value="">



<div class="modal fade" id="mdlCISerie" tabindex="-1" role="dialog" aria-labelledby="divCISerie" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="TemporalCargaInicialCantidad.SeriesModalCerrar()">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divCISerie">
                    <i class="fa fa-file-text-o"></i> Escanear Series
                    <br />
                    <h3>
                        LPN: <strong><span id="bMdlCIPT_LPN"> </span></strong><br /><br />
                        Ubicaci&oacute;n: <strong><span id="bMdlCIUbi_Nombre"></span></strong><br /><br />
                        SKU: <strong><span id="bMdlCIPro_Sku"> </span></strong>
                    </h3>
                </h2>
                
            </div>
            <div class="modal-body" id="ModalBodySeries">

                             
            </div>
            <input type="hidden" id="hidMdlCIUbi_ID" value="">
            <input type="hidden" id="hidMdlCIPT_ID" value="">

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="TemporalCargaInicialCantidad.SeriesModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                <button type="button" class="btn btn-primary btn-seg" id="btnIntegraPallet" onclick="TemporalCargaInicialCantidad.IntegraPallet();">
                    <i class="fa fa-plus"></i>&nbsp;&nbsp;Integrar series a pallet
                </button>
                <button type="button" class="btn btn-primary btn-seg" id="btnMdlGuardaCantidad" onclick="TemporalCargaInicialCantidad.GuardaCantidad($('#inpCantidad').val());">
                    <i class="fa fa-plus"></i>&nbsp;&nbsp;Integrar piezas a pallet
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="ModalNuevoLPN" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Nuevo LPN</h4>
      </div>
      <div class="modal-body">
            <div class="form-group row">
                <label class="col-md-3 control-label">Ubicaci&oacute;n: </label>   
                <div class="col-md-8"><span id="divUbicacion"></span></div>
            </div>
            <div class="form-group row">
                <label class="col-md-3 control-label">Cliente: </label>   
                <div class="col-md-8">
                    <%CargaCombo("Cli_ID","class='form-control' onchange='TemporalCargaInicialCantidad.CargaProductos($(this).val())'","Cli_ID","Cli_Nombre","Cliente","","Cli_ID",-1,0,"Selecciona")%>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-3 control-label">SKU: </label>   
                <div class="col-md-8"><input type="text" onkeypress='TemporalCargaInicialCantidad.CargaProductos($("#Cli_ID").val())' id="txtBuscaSKU" value="" class="form-control"/></div>

            </div>
            <div class="form-group row">
                <label class="col-sm-3 control-label">Producto: </label>   
                <div class="col-md-8" id="divProductos"></div>
            </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary" onclick="TemporalCargaInicialCantidad.LPNCrea();">Crear LPN</button>
      </div>
    </div>
  </div>
</div>
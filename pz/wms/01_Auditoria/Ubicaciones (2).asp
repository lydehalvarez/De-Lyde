<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252" %>
<!--#include file="../../../Includes/iqon.asp" -->
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="/Template/inspina/css/animate.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<div id="wrapper">
    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                        </div>
                        <div class="ibox-content">
                            <div class="col-sm-12 m-b-xs">
                                <div class="row">
                                    <label class="col-sm-2 control-label">SKU:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input class="form-control texto" id="idSKU" type="text" value="" style="width: 200px;float: left;">
                                    </div>
                                    <label class="col-sm-2 control-label">Ubicaci&oacute;n:</label>
                                    <div class="col-sm-3 m-b-xs">
                                        <input class="form-control texto" id="idUbicacion" type="text" value="" style="width: 200px;float: left;">
                                    </div>
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">
                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar">
                                            <i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">LPN:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input class="form-control texto" id="idLPN" type="text" value="" style="width: 200px;float: left;">
                                    </div>
                                    <label class="col-sm-2 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            ComboSeccion("idEstatus",sEventos,146,-1,0,"Todos","","Editar");
                                        %>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">Auditor:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <%
                                            var sEventos=" class='input-sm form-control cbo2'  style='width:200px'" ;
                                            var sCondicion="Usu_Habilitado = 1";
                                            CargaCombo("cbAuditor", sEventos, "Usu_ID" , "Usu_Nombre" , "Usuario" , sCondicion, "Usu_ID" ,
                                            -1, 0, "Todos" , "Editar" );
                                        %>
                                    </div>
                                    <label class="col-sm-2 control-label">Resultado:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            ComboSeccion("idResultado",sEventos,147,-1,0,"Todos","","Editar");
                                        %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">

                            </div>
                        </div>
                        <div class="text-center" id="loading">
                            <div class="spiner-example">
                                <div class="sk-spinner sk-spinner-three-bounce">
                                    <div class="sk-bounce1"></div>
                                    <div class="sk-bounce2"></div>
                                    <div class="sk-bounce3"></div>
                                </div>
                            </div>
                            <div>Cargando informaci&oacute;n, espere un momento...</div>
                        </div>
                        <div class="table-responsive" id="dvUbicaciones"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<!-- Loading -->
<script src="/Template/inspina/js/loading.js"></script>
<script src="/pz/wms/Auditoria/AuditoriasUbicacion/js/AuditoriasUbicacion.js"></script>
<script src="/pz/wms/Auditoria/AuditoriasAuditores/js/AuditoriasAuditores.js"></script>
<script src="/pz/wms/Almacen/Catalogo/js/Catalogo.js"></script>

<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />

<script type="text/javascript">
    var dato = {};
    var tab = "/pz/wms/Auditoria/Ubicaciones_Grid.asp";
    $(document).ready(function () {

        $('.cbo2').select2();

        //CargaGridInicial();
		$('#loading').hide('slow')
    });
	
	$('.texto').keydown(function(event) {
		if(event.which == 13){
			var str = $(this).val();
			str = str.replace(/[\']/g, "-");
			$(this).val(str);
			UbicacionFunction.CargaGrid();
		}
	});

	$("#btnBuscar").click(function (event) {
		UbicacionFunction.CargaGrid();
	});

	var UbicacionFunction = {
		CargaGrid:function(){
			$('#loading').show('slow');
			$("#dvUbicaciones").hide('slow')
			var dato =  {
				Lpp:1,
				Aud_ID: $('#Aud_ID').val(),
				Sku: $('#idSKU').val(),
				Ubicacion: $('#idUbicacion').val(),
				Lpn: $('#idLPN').val(),
				Estatus: $('#idEstatus').val(),
				Resultado: $('#idResultado').val(),
				Auditor: $('#cbAuditor').val()
				
			}
			$("#dvUbicaciones").load(tab, dato,function(){$('#loading').hide('slow');$("#dvUbicaciones").show('slow')});
		}
		
	}

</script>
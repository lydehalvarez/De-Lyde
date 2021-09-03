<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

   
%>
    
    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
        
<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
          <div class="ibox-title">
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
              <!--a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-wrench"></i></a>
              <ul class="dropdown-menu dropdown-user">
                <li>
                  <a href="#">Config option 1</a>
                </li>
                <li>
                  <a href="#">Config option 2</a>
                </li>
              </ul><a class="close-link"><i class="fa fa-times"></i></a>
            </div-->
          </div>
          <div class="ibox-content">
            <div class="row"> 
                <div class="col-sm-12 m-b-xs">        
                    <div class="row">
                        <label class="col-sm-2 control-label">Cliente:</label>
                        <div class="col-sm-4 m-b-xs">
                            <% var sEventos = " class='BusCli_ID input-sm form-control' "
                               var sCondicion = ""
                               CargaCombo("Cli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre"
                                          , Parametro("Cli_ID",-1), 0, "Seleccione", "Editar")%>
                        </div>
                        <label class="col-sm-1 control-label">Producto:</label>    
                        <div class="col-sm-4 m-b-xs">
                            <% var sEventos = "class='BusPro_ID input-sm form-control'"
                               var sCondicion = "ProC_EsKit = 1 AND Cli_ID = " + Parametro("Cli_ID",-1)
                               CargaCombo("Pro_ID", sEventos, "Pro_ID", "ProC_Nombre", "Producto_Cliente", sCondicion
                                         , "ProC_Nombre", Parametro("Pro_ID",-1), 0, "Todos", "Editar")%>
                        </div>
                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">
                        <label class="col-sm-2 control-label">Nombre de la receta:</label>
                        <div class="col-sm-4 m-b-xs">
                            <input id="FFRec_Nombre" class="input-sm form-control" type="text" value="">
                        </div>
                        <label class="col-sm-1 control-label">&nbsp;</label>
                        <div class="col-sm-3 m-b-xs">
                            <!-- input name="BusCli_RFC" id="BusCli_RFC" class="input-sm form-control" placeholder="R.F.C." type="text" value=""  -->
                        </div>
                        <div class="col-sm-2 m-b-xs text-rigth">
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                        </div>
                    </div>    
                </div>
            </div>
            <!-- div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">
                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
                            <% ComboSeccion("BusCot_EstatusCG93","class='BusCot_EstatusCG93 input-sm from-control'",93,Parametro("BusCot_EstatusCG93",-1),0,"Seleccione","Cat_Orden","Editar")%>
                        </div>
                        <label class="col-sm-1 control-label"></label>
                        <div class="col-sm-3 m-b-xs">
                            
                        </div>

                    </div>    
                </div>
            </div -->
                    
            <div class="table-responsive" id="dvTablaRecetas"></div>  
          </div>
        </div>
      </div>
    </div>
    </div>                  
</div>
              
    <!-- Mainly scripts -->
    <!-- script src="/Template/inspina/js/jquery-3.1.1.min.js"></script -->
    <!-- script src="/Template/inspina/js/bootstrap.min.js"></script -->
    <script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Custom and plugin javascript -->
    <!--  script src="/Template/inspina/js/inspinia.js"></script -->
    <script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>

    <!-- iCheck -->
    <script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

    <!-- Select2 -->
    <script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
          
    <!-- MENU -->
    <!-- script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script -->

<script type="text/javascript">
        
$(document).ready(function(){

    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        //radioClass: 'iradio_square-green',
    });

    $(".BusEqp_ID").select2({
        /*placeholder: "Selecciona un equipo de ventas",
        allowClear: false*/
    });    

    $(".BusAgt_ID").select2({
        /*placeholder: "Selecciona un equipo de ventas",
        allowClear: false*/
    });        
    
    $(".BusCot_EstatusCG93").select2({
        /*placeholder: "Selecciona un equipo de ventas",
        allowClear: false*/
    });    
    
    
    $("#Cli_ID").click(function(event) {

        var sDatos = "Cli_ID=" + $("#Cli_ID").val();
            sDatos += "&Pro_ID=" + $("#Pro_ID").val();       
            sDatos += "&FFRec_Nombre=" + escape($("#FFRec_Nombre").val());
        var arDatos = {}
            arDatos
       var dato = {}
	
		dato['Cli_ID'] = $('#Cli_ID').val()
		dato['CliOC_ID'] = $('#CliOC_ID').val()
        dato['CliEnt_ID'] = $('#CliEnt_ID').val()
		dato['OC_ID'] = $('#OC_ID').val()
		dato['Prov_ID'] = $('#Prov_ID').val()
		dato['Pro_ID'] = $('#cboPro_ID').val()

        $("#divMB").load("/pz/wms/Recepcion/RecepcionCargaEscaneo.asp",dato);
            
        
        $.ajax({
			type: "POST",
			url: "/pz/wms/FF/Recetas_Grid.asp", //dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data: sDatos,
			cache: false, //por el cache al tratar de usar load no cambiaba los parámetros que se usan como filtros
			async: false,
			processData: false,
			success: function(Datos) {           
        
                //$("#dvTablaClientes").load(Datos);
                $("#dvTablaCotizaciones").html(Datos);
                
            },error:function(XMLHttpRequest, textStatus, errorThrown) {
                console.log("XMLHttpRequest " + XMLHttpRequest + " textStatus " + textStatus + " errorThrown " + errorThrown);
				var sMensaje = "Error: " + errorThrown
				    sMensaje += ", por favor, notifique de este error con su administrador ."
				var sTitulo = "Error, de acceso"
				//toastr.error(sMensaje, sTitulo)
			}
                
        });

    });

    
});
        
</script>




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
<% 
    var sEventos = " class='input-sm form-control' "
    var sCondicion = ""

    CargaCombo("Cli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre"
              , Parametro("Cli_ID",-1), 0, "No aplica", "Editar")
%>
                        </div>
                        <label class="col-sm-1 control-label">Tipo:</label>    
                        <div class="col-sm-4 m-b-xs">
<%    
    var sEventos = "class='input-sm form-control'"
   /*%> ComboSeccion("cboTipo",sEventos,88,-1,0,"No Aplica","Cat_Orden","Editar")
<%*/	    CargaCombo("Are_ID", sEventos, "Are_ID", "Are_Nombre", "Ubicacion_Area", "", "Are_Nombre"
              , Parametro("Are_ID",-1), 0, "No aplica", "Editar")

%> 
                        </div>
                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">
                        <label class="col-sm-2 control-label">Nombre del &aacute;rea:</label>
                        <div class="col-sm-4 m-b-xs">
                            <input id="Are_Nombre" class="input-sm form-control" type="text" value="">
                        </div>
                        <label class="col-sm-1 control-label">&nbsp;</label>
                        <div class="col-sm-5 m-b-xs" style="text-align: right;"> 
                            <button class="btn btn-info btn-sm" type="button" id="btnNuevo"><i class="fa fa-plus"></i>&nbsp;&nbsp;<span class="bold">Nueva &aacute;rea</span></button> 
                            
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
                    
            <div class="table-responsive" id="dvTablaAreas"></div>  
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

//    $('.i-checks').iCheck({
//        checkboxClass: 'icheckbox_square-green',
//        //radioClass: 'iradio_square-green',
//    });

//    $(".BusEqp_ID").select2({
//        /*placeholder: "Selecciona un equipo de ventas",
//        allowClear: false*/
//    });    
//
//    $(".BusAgt_ID").select2({
//        /*placeholder: "Selecciona un equipo de ventas",
//        allowClear: false*/
//    });        
//    
//    $(".BusCot_EstatusCG93").select2({
//        /*placeholder: "Selecciona un equipo de ventas",
//        allowClear: false*/
//    });    
    
    CargaGridInicial()
    
  

     
});
      $("#btnBuscar").click(function(event) {

       var dato = {}
    dato['Are_ID'] = $('#Are_ID').val()
	dato['Are_Nombre'] = $('#Are_Nombre').val()
    
    $("#dvTablaAreas").load("/pz/wms/Ubicacion/Grid_Areas.asp",dato);
      
	   });
function CargaGridInicial(){
    
    var dato = {}
    dato['Are_ID'] = $('#Are_ID').val()
	dato['Are_Nombre'] = $('#Are_Nombre').val()
    
    $("#dvTablaAreas").load("/pz/wms/Ubicacion/Grid_Areas.asp",dato);
    
}
        
</script>




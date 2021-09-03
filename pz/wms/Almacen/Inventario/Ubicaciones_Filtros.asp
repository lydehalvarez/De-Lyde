<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>    
<link href="/Template/inspina/css/animate.css" rel="stylesheet"/>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet"/>

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
                            <div class="col-sm-12 m-b-xs" id="ciclicAuditsFilters">    
                                <div class="row"> 
                                    <label class="col-sm-1 control-label">Cliente:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = "";
                                            CargaCombo("cbCli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre", Parametro("Cli_ID",-1), 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label">Area:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                         var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                         var sCondicion = "Are_AmbientePallet in (1,5)";
                                         CargaCombo("Are_ID", sEventos, "Are_ID", "Are_Nombre", "Ubicacion_Area", sCondicion, "Are_Nombre", Parametro("Are_ID",-1), 0, "Todos", "Editar");
                                        %>
                                    </div>
                                   
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                                    </div>
                                </div>    
                                <div class="row">
                                    <label class="col-sm-1 control-label">Rack:</label>    
                                    <div class="col-sm-4 m-b-xs" id="divRack">
                                        <% 
                                            
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = "Are_ID in (select Are_ID from Ubicacion_Area where Are_AmbientePallet in (1,5))";
                                            CargaCombo("Rac_ID", sEventos, "Rac_ID", "Rac_Prefijo", "Ubicacion_Rack", "", "Rac_Prefijo", Parametro("Rac_ID",-1), 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label">Ubicaci&oacute;n:</label>
                                    <div class="col-sm-4 m-b-xs" id="divUbicacion">
                                        <% 
                                            
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                           // var sCondicion = "Are_ID in (select Are_ID from Ubicacion_Area where Are_AmbientePallet in (1,5))";
                                            CargaCombo("Ubi_ID", sEventos, "Ubi_ID", "Ubi_Nombre", "Ubicacion", "", "Ubi_Nombre", Parametro("Ubi_ID",-1), 0, "Todos", "Editar");
                                        %>
                                    </div>
                                </div>
                                <div class="row"> 
                                    <label class="col-sm-1 control-label">SKU:</label>
                                    <div class="col-sm-4 m-b-xs">
                                       <input type="text" class="form-control Pro_SKU" autocomplete="off" placeholder="SKU"></input>

                                    </div>
                                        <label class="col-sm-1 control-label">LPN:</label>
                                    <div class="col-sm-4 m-b-xs">
                                       <input type="text" class="form-control Pt_LPN" autocomplete="off" placeholder="LPN"></input>
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
                         <div class="table-responsive" id="dvTablaDisponible"></div>  
                        <div class="table-responsive" id="dvTablaUbicaciones"></div>  
                    </div>
                </div>
            </div>
        </div>
    </div>                  
</div>

<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>     


<script type="text/javascript">
$("#loading").hide();
var loading = '<div class="spiner-example">'
					+'<div class="sk-spinner sk-spinner-three-bounce">'
						+'<div class="sk-bounce1"></div>'
						+'<div class="sk-bounce2"></div>'
						+'<div class="sk-bounce3"></div>'
					+'</div>'
				+'</div>'

    var dato = {};    
    $(document).ready(function() {
        
         
        $('.cbo2').select2();
        
        $("#btnBuscar").click(function(){
			//CargarDisponible()
            CargarGrid()
        })
        
        
        $("#Are_ID").change(function(){
            CargaCombos()
            
        })
		
		  $("#Rac_ID").change(function(){
            CargaComboUbicacion()
            
        })
    
    });
        
    	    function CargarDisponible() {
        $("#dvTablaDisponible").empty();
		
			var sDatos    = "?Cli_ID=" + $('#cbCli_ID').val()
				   sDatos += "&Pro_SKU=" + $('.Pro_SKU').val()
		
				 var Cli_ID =  $('#cbCli_ID').val(); 
				 var Ubi_ID =  $('#Ubi_ID').val();
				 var Are_ID =  $('#Are_ID').val();
				 var Rac_ID =  $('#Rac_ID').val();
				 var Pro_SKU =  $('.Pro_SKU').val();
				 var Pt_LPN =  $('.Pt_LPN').val();
			
				if(Cli_ID != "" || Ubi_ID != "" || Are_ID != "" || Rac_ID != "" || Pro_SKU != "" || Pt_LPN != ""){
					
				
				
				$("#dvTablaDisponible").load("/pz/wms/Almacen/Inventario/Inventario_Contenido.asp"+sDatos, function() {
				$("#loading").hide('slow');
			$("#dvTablaDisponible").show('slow');
			
		});
				}
    }
    function CargarGrid() {
		$("#loading").show('slow');
        $("#dvTablaUbicaciones").empty();
  var  sDatos    = "?Cli_ID=" + $('#cbCli_ID').val(); 
    	  sDatos += "&Ubi_ID=" + $('#Ubi_ID').val();
		  sDatos += "&Are_ID=" + $('#Are_ID').val();
		  sDatos += "&Rac_ID=" + $('#Rac_ID').val();
    	  sDatos += "&Pro_SKU=" + $('.Pro_SKU').val();
    	  sDatos += "&Pt_LPN=" + $('.Pt_LPN').val();
		  
		  
        	$("#dvTablaUbicaciones").load("/pz/wms/Almacen/Inventario/Ubicaciones_Grid.asp"+sDatos, function() {
			$("#loading").hide('slow');
			$("#dvTablaUbicaciones").show('slow');
		});
		
    }
    
    
    function  CargaCombos(){
        
       //  $("#divRack").load("/pz/wms/Almacen/Inventario/inventario_ajax.asp"
//              , {Tarea:11, Are_ID:$("#Are_ID").val()}
//              )
        $.post("/pz/wms/Almacen/Inventario/inventario_ajax.asp"
              , {Tarea:11, Are_ID:$("#Are_ID").val()}
              ,function(result){
            $("#divRack").html(result)
            
        })
		  $.post("/pz/wms/Almacen/Inventario/inventario_ajax.asp"
              , {Tarea:12, Are_ID:$("#Are_ID").val()}
              ,function(result){
            $("#divUbicacion").html(result)
            
        })
        
        
    }
    
	    function  CargaComboUbicacion(){
        
        $.post("/pz/wms/Almacen/Inventario/inventario_ajax.asp"
              , {Tarea:12, Rac_ID:$("#Rac_ID").val()}
              ,function(result){
            $("#divUbicacion").html(result)
            
        })
        
        
    }
    
    
</script>

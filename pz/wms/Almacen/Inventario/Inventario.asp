<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">

<div class="form-horizontal" id="toPrint">
    <div class="wrapper wrapper-content  animated fadeInRight">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Inventario de almac&eacute;n</h5>
                        <div class="ibox-tools">
                            <a href="#" class="btn btn-primary btnSearch"><i class="fa fa-search"></i>&nbsp;&nbsp;Buscar</a>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">
                                    <label class="col-sm-1 control-label">Cliente:</label>
                                    <div class="col-sm-3 m-b-xs">
										<%
                                            CargaCombo("cbCli_ID","class='form-control cboCli_ID'" 
                                            ,"Cli_ID","Cli_Nombre","Cliente","","Cli_Nombre",-1,0,"Selecciona")
                                        %>
                                    </div>
                                    <label class="col-sm-2 control-label">Serie:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="Serie" id="Serie"
                                               onkeypress="Buscar(this, event)" />
                                    </div>  
                            </div>
                        </div>                    
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">
                                    <label class="col-sm-1 control-label">Almac&eacute;n:</label>
                                    <div class="col-sm-3 m-b-xs alma" id="cboAlmacen"><select class="form-control alma"></select>
                                    </div>
                                    <label class="col-sm-2 control-label">SKU:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="SKU" id="SKU"
                                               onkeypress="Buscar(this, event)" />
                                    </div>
                            </div>
                        </div>                    
                        <!-- div class="row">
                            <div class="col-sm-12 m-b-xs">
                                    <label class="col-sm-2 control-label">Master box:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="Masterbox del Pallet" />
                                    </div>
                                    <label class="col-sm-2 control-label">LPN:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="LPN de Pallet" />
                                    </div>
                            </div>
                        </div -->                     
                        <div class="row" >
                            <div class="col-sm-12 m-b-xs">
                                    <label class="col-sm-1 control-label">Nombre:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="Nombre" id="Nombre" 
                                               onkeypress="Buscar(this, event)" />
                                    </div>
                                    <label class="col-sm-2 control-label">insumo:</label>
                                    <div class="col-sm-3 m-b-xs">
										No <input type="radio" name="OptIns" class="OptIns" 
                                                  id="InsNo" checked="checked" >  &nbsp;&nbsp; 
                                        Si <input type="radio" name="OptIns" id="InsSI" class="OptIns">
                              </div>
                            </div>
                                                             
                        </div>                    
<!--                        <div class="m-b-lg">
                            <div class="m-t-md">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-comments"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-user"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-list"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-pencil"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-print"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-cogs"></i> </button>
                                </div>
                                <strong> 61 incidencias encontradas.</strong>
                            </div>
                        </div>
-->                     
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
                        <div class="table-responsive" id="divDatos">
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="application/javascript">

$("#loading").hide();
var loading = '<div class="spiner-example">'
					+'<div class="sk-spinner sk-spinner-three-bounce">'
						+'<div class="sk-bounce1"></div>'
						+'<div class="sk-bounce2"></div>'
						+'<div class="sk-bounce3"></div>'
					+'</div>'
				+'</div>'


    
$(document).ready(function(e) {
   // InventarioFunciones.CargaGrid(1,2);
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green',
    });
    
   
   	$('.btnExcel').click(function(e) { 
		var ip = Date()
		$.post("/pz/wms/Almacen/Inventario/ExcelInventario.asp"
               , {  }
               , function(data){
                  
                    var response = JSON.parse(data)
                    var ws = XLSX.utils.json_to_sheet(response);
                    var wb = XLSX.utils.book_new(); 
                    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
                    XLSX.writeFile(wb, ip +"Inventario.xlsx");
                });
	});

    $('.cboCli_ID').change(function(e) {
        e.preventDefault()
        $(".alma").prop('disabled',true)
        var dato = {
           Cli_ID:$(this).val(),
           Tarea:1
        }
        $("#cboAlmacen").load("/pz/wms/Almacen/Inventario/inventario_ajax.asp", dato,function(){
            $(".alma").prop('disabled',false)
        });
    });
    
    $('.btnSearch').click(function(e) {
        e.preventDefault();
        InventarioFunciones.CargaGrid($('#cbCli_ID').val(),$('#Alm_ID').val(),$('#SKU').val(),$('#Serie').val(),$('#Nombre').val())
    });

});   
    
var InventarioFunciones = {
	CargaGrid:function(Cli_ID,Alm_ID,sSKU,sSerie,sNombre){
	$("#loading").show('slow');
	$("#divDatos").hide('slow'); 
		var dato = {
		   Cli_ID:Cli_ID,
		   Alm_ID:Alm_ID, 
           Pro_SKU:sSKU,
           Serie:sSerie,
           Nombre:sNombre 
		}
        console.log("Cli_ID = " + Cli_ID + " alm " + Alm_ID + " sku " + sSKU)
        console.log("checado "  +$("#InsNo").is(':checked') )
        if ($("#InsNo").is(':checked')){
            $("#divDatos").load("/pz/wms/Almacen/Inventario/Inventario_SKU.asp", dato, function() {
                $("#loading").hide('slow');
                $("#divDatos").show('slow');
            })                        
        } else {
            $("#divDatos").load("/pz/wms/Almacen/Inventario/Inventario_Insumo.asp", dato, function() {
                $("#loading").hide('slow');
                $("#divDatos").show('slow');
            });    
        }
        

	},
	ExportarSeries:function(Pt_ID,Pallet){
		$.post("/pz/wms/Almacen/Inventario/Inventario_Serie.asp",
			{Pt_ID:Pt_ID,Cli_ID:$('#cbCli_ID').val()}
			,function(data){
				var response = JSON.parse(data); 
				var ws = XLSX.utils.json_to_sheet(response);
				var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
				XLSX.writeFile(wb, "Series del pallet "+Pallet+".xlsx");
				Avisa("success","Archivo descargado","El archivo se ha generado correctamente");
			});
	}
}



function Buscar(o,e) {
    if(o.value != "" ){
       var tecla = (document.all) ? e.keyCode : e.which;
       if (tecla==13) {
           InventarioFunciones.CargaGrid($('#cbCli_ID').val(),$('#Alm_ID').val(),$('#SKU').val(),$('#Serie').val(),$('#Nombre').val())
      }        
    }
}


</script>



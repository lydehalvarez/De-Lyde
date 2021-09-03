<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet">
<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                       <label class="control-label col-md-1"><strong>Cliente</strong></label>
                        <div class="col-lg-4">
                           <%
                           var sCampo = "Cli_Nombre"
						   var sCond = ""
						   CargaCombo("Cli_ID"," class='form-control'","Cli_ID",sCampo,
						   "Cliente",sCond,sCampo,-1,0,"Selecciona","Editar")					   
						   %>
                      </div>
                      <div class="col-lg-7"  style="text-align: right;">
                        <input type="button" value="Crear corte" class="btn btn-info btnCortePicking" disabled/>
                      </div>
                     </div>
                     <div id="TablaTRA"></div>
					<div id="TablaCorte">
                        <div class="col-lg-12"  style="text-align: right;">
                            <input type="button" value="Ir a a corte" class="btn btn-info btnCorteValor" disabled/>
                        </div>
                        <table id="example2" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>N&uacute;mero de corte</th>
                                    <th>Cliente</th>
                                    <th>Usuario</th>
                                    <th>Fecha registro</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
 </div>   

<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
<script type="application/javascript">

var Datos = {}

$(document).ready(function() {

	CargaTRA(0)
	
    var table = $('#example2').DataTable( {
		ajax:{
			complete: function (datos) {
			},
			url: "/pz/wms/Transferencia/CortesTransferencia.asp",
		},
		order: [[ 0, 'desc' ]],
		columns: [
            { "data": "TA_ArchivoID" },
            { "data": "Cliente" },
            { "data": "TA_Usuario" },
            { "data": "Fecha" }
        ]
	});
		
	$('#example2 tbody').on('click', 'tr', function () {
        var data = table.row(this).data();
		$('.btnCorteValor').prop('disabled',false);
		$('#TA_ArchivoID').val(data.TA_ArchivoID)
		$('#Cli_ID').val(data.Cli_ID)
		swal({
		  title: 'Corte numero '+data.TA_ArchivoID+' del cliente "'+data.Cliente+'"',
		  text: "Corte generado el "+data.Fecha+" por el usuario "+data.Usuario+" &iquest;Deasea ver o proseguir con el corte generado?",
		  type: "success",
		  showCancelButton: true,
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		},
		function(data){
			if(data){
				CambiaVentana(19,381)
			}
		});		
    });		
	
	
});
$('#Cli_ID').change(function(e) {
	var Cli_ID = $(this).val()
    CargaTRA(Cli_ID)
	$('#Cli_ID').val(Cli_ID)
	$('#TablaTRA').hide()
	$('#TablaCorte').hide()
});

function CargaTRA(Cli_ID){
	$.post("/pz/wms/Transferencia/Transferencia_TRA.asp",{
	Cli_ID:Cli_ID
	},function(data){
		if(data != ""){
			$('#TablaTRA').show()
			$('#TablaCorte').show()
			$('#TablaTRA').html(data)
		}
	});
}


$('.btnCortePicking').click(function(e) {
	e.preventDefault()
	swal({
		  title: "Hacer corte",
		  text: "Al generar el corte las ordenes que est&aacute;n en la tabla se almacenaran, a regresar a la ventana tendr&aacute; nuevas solicitudes",
		  type: "success",
		  showCancelButton: true,
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		},
		function(data){
			if(data){
				GeneraCorte()
			}
		});		

});




function GeneraCorte(){

	var Llaves = []
	Datos.forEach(function(item){
	Llaves.push(item.id)
	});
	var NumElementos = Llaves.length

	//console.log(Llaves)
	
	var jsonString = JSON.stringify(Llaves)
	var res = jsonString.replace('[', "");
	var ta = res.replace(']', "");

	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",{
	Tarea:4,
	IDs:ta,
	Cli_ID:$('#Cli_ID').val(),
	IDUsuario:$('#IDUsuario').val(),
	NumElementos:NumElementos
	},function(data){
		//console.log(data)
		if(data > -1){
			$('#TA_ArchivoID').val(data)
			CambiaVentana(19,381)
		}
	});
}





</script>
    
    
    
    
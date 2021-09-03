<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet">
<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                      <div class="col-lg-12"  style="text-align: right;">
                        <input type="button" value="Crear corte" class="btn btn-info btnCortePicking" disabled/>
                      </div>
                     </div>
                    <table id="example" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Folio</th>
                                    <th>Estatus</th>
                                    <th>Fecha registro</th>
                                </tr>
                            </thead>
                    </table>
                      <div class="col-lg-12"  style="text-align: right;">
                         <input type="button" value="Ir a a corte" class="btn btn-info btnCorteValor" disabled/>
                      </div>
                    <table id="example2" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>N&uacute;mero de corte</th>
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
   
<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
<script type="application/javascript">

	var Datos = {}
$(document).ready(function() {
	$('#Pro_ID').val(4)
    $('#example').DataTable( {
		order: [[ 0, 'desc' ]],
		ajax:{
			complete: function (datos) {
				Datos = datos.responseJSON.data
				console.log(Datos)
				$( ".btnCortePicking" ).prop( "disabled", false );	
			},
			url: "/pz/wms/Transferencia/DataTransferencia.asp",
		},
		columns: [
            { "data": "Folio" },
            { "data": "Estatus" },
            { "data": "Fecha" }
        ]    
	});
    var table = $('#example2').DataTable( {
		ajax:{
			complete: function (datos) {
			},
			url: "/pz/wms/Transferencia/CortesTransferencia.asp",
		},
		order: [[ 0, 'desc' ]],
		columns: [
            { "data": "TA_ArchivoID" },
            { "data": "TA_Usuario" },
            { "data": "Fecha" }
        ]
		});
	$('#example2 tbody').on('click', 'tr', function () {
        var data = table.row(this).data();
        console.log(data);
        console.log(data.TA_ArchivoID);
		$('.btnCorteValor').prop('disabled',false);
		$('#TA_ArchivoID').val(data.TA_ArchivoID)
		swal({
		  title: "Corte numero "+data.TA_ArchivoID,
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

		
    } );		
	
	
});
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
	//console.log(Llaves)
	
	var jsonString = JSON.stringify(Llaves)
	var res = jsonString.replace('[', "");
	var ta = res.replace(']', "");

	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",{
	Tarea:4,
	IDs:ta,
	IDUsuario:$('#IDUsuario').val()
	},function(data){
		//console.log(data)
		if(data > -1){
			$('#TA_ArchivoID').val(data)
			CambiaVentana(19,381)
		}
	});
}





</script>
    
    
    
    
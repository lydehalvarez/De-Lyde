<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->


<div class="form-horizontal" id="frmFicha">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <button type="button" class="btn btn-primary btnIngresa">
                      Ingresar pallet
                    </button>
                </div>
                <div class="ibox-content">
                	<table class="table" id="TablePallet">
                    	<thead>
                        	<th>Pallet</th>
                        	<th>Masters</th>
                        	<th>Art&Iacute;culos por caja</th>
                        	<th>Total</th>
                        	<th>Acciones</th>
                        </thead>
                        <tbody id="ArmadoPallet">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-md-4"><strong>Cajas Master</strong></label>
                <div class="col-md-4"><input type="number" class="form-control Numcajas" min="1" placeholder="Cantidad de caja masters"/></div>
            </div> 
            <div class="form-group">
                <label class="control-label col-md-4"><strong>Art&iacute;culos por caja</strong></label>
                <div class="col-md-4"><input type="number" class="form-control Numarti" min="1" placeholder="Cantidad de art&iacute;culos por caja"/></div>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAgregaPallet">Agregar Pallet</button>
      </div>
    </div>
  </div>
</div>



<script type="application/javascript">

	$(document).ready(function(){
	
		$('.checkbox').iCheck({  checkboxClass: 'icheckbox_square-green' }); 
					   
	}); 
	$('.btnIngresa').click(function(e) {
		e.preventDefault();
        $('#myModal').modal('show');
    });
	var Pallet = 1
	$('.btnAgregaPallet').click(function(e) {
		$('#myModal').modal('hide');
		var numCajas =  $('.Numcajas').val()
		var numArti =  $('.Numarti').val()
		e.preventDefault();
		var Total = numCajas*numArti
		var Acciones = ' <div class="btn-group">'
			Acciones +=	'<button type="button" data-pallet="'+Pallet+'" class="btn btn-danger btnBorraPallet">Borrar</button>'
			Acciones +=	'<button type="button" class="btn btn-info">Editar</button>'
			Acciones +=	'</div>'
			
        var tab = '<tr id="Pallet'+Pallet+'"><td>'+Pallet+'</td><td>'+numCajas+'</td><td>'+numArti+'</td><td>'+Total+'</td><td style="width:19%;">'+Acciones+'</td></tr>'
		$('#ArmadoPallet').append(tab)
		Pallet++
		var numCajas =  $('.Numcajas').val(1)
		var numArti =  $('.Numarti').val(1)
    });
	$("#frmDatos").on("click", ".btnBorraPallet", function(e){
		var pallet = $(this).data('pallet')
		e.preventDefault();
		swal({
			  title: "Borrar Pallet "+pallet,
			  text: "¿Seguro que desea borrar el pallet?",
			  type: "warning",
			  showCancelButton: true,
			  closeOnConfirm: true,
			  closeOnCancel: true,
			  html: true
			},
			function(data){
				if(data){
					$('#Pallet'+pallet).hide('slow')
					setTimeout(function(){$('#Pallet'+pallet).remove()},2000)
				}
		});	
    });
	
	
</script>
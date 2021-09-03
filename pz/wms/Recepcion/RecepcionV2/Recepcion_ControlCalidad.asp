<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->


<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="form-horizontal" >
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
					<table class="table">
                    	<tr>
                        	<td>Tama&ntilde;o del lote</td>
                        	<td>x</td>
                        </tr>
                    	<tr>
                        	<td>Tama&ntilde;o de muestra <small>Escoger a azar</small></td>
                        	<td>y</td>
                        </tr>
                    	<tr>
                        	<td>M&aacute;ximo de aceptaci&oacute;n</td>
                        	<td>z</td>
                        </tr>
                    	<tr>
                        	<td>Rechazo de lote</td>
                        	<td>k</td>
                        </tr>
                    </table>                    
                </div>
                <div class="ibox-content">
                    <div class="form-group" id="CargaSerie">
                        <label class="control-label col-md-2"><strong>Serie</strong></label>
                        <div class="col-md-3"><input type="text" class="form-control Serie" placeholder="Serie de caja master"/></div>
                        <div class="col-md-3"><h2>&nbsp;&nbsp;<span id="contador">0/y</span><small>&nbsp;Tama&ntilde;o de muestra</small></h2></div>
                    </div> 
                    
                    <table class="table">
                    	<thead>
                        	<th style="width: 10%;">#</th>
                        	<th style="width: 20%;">Serie</th>
                        	<th>Resultado</th>
                        </thead>
                        <tbody id="TablaAnalisis">
                        
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
        <h4 class="modal-title" id="myModalLabel"></h4>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <label><input type="checkbox" class="checkbox" id="Campo1" value="E 1">&nbsp;Ejemplo 1</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo2" value="Ejo 2">&nbsp;Ejemplo 2</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo3" value="Ejeo 3">&nbsp;Ejemplo 3</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo4" value="Ejplo 4">&nbsp;Ejemplo 4</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo5" value="Emplo 5">&nbsp;Ejemplo 5</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo6" value="Eje 6">&nbsp;Ejemplo 6</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo7" value="Ejelo 7">&nbsp;Ejemplo 7</label><br>
            <label><input type="checkbox" class="checkbox" id="Campo8" value="Ejelo 8">&nbsp;Ejemplo 8</label>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnGuardaAnalisis">Guardar an&aacute;lisis</button>
      </div>
    </div>
  </div>
</div>


<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script type="application/javascript">

		$('.checkbox').iCheck({  checkboxClass: 'icheckbox_square-green' }); 


$('.Serie').on('keypress',function(e) {
	var inp = $(this)
	if(e.which == 13) {
		$('#myModal').modal('show')
		$('#myModalLabel').html("Serie: "+inp.val())
	}
});


var Renglon = 1;
$('.btnGuardaAnalisis').click(function(e) {
	var Objeto = []
	$(".checkbox").each(function(element, index) {
		var dato = '{ "Nombre":"'+$(index).attr('id')+'","Valor":"'+$(index).val()+'"}'
		var myIbj = JSON.parse(dato)
		Objeto.push(myIbj)
	});
	var largo = Objeto.length;
	var tab = "";
	for(var i = 0;i<largo;i++){
		tab = '<tr><td>'+Objeto[i].Nombre+'</td><td>'+Objeto[i].Valor+'</td></tr>'+tab
		
	}
		
	var tableAn = '<tr><td>'+Renglon+'</td><td>'+$('.Serie').val()+'</td><td><table class="table">'
		tableAn +=' <thead>'
		tableAn +='<th>Criterio</th>'
		tableAn +='<th>Valor</th>'
		tableAn +='</thead>'
		tableAn +='<tbody>'+tab
		tableAn +='</tbody>'
		tableAn +='</table></td></tr>'

	
	
	$('#myModal').modal('hide')
	$('#TablaAnalisis').focus()
	$('#TablaAnalisis').prepend(tableAn)
	$('.Serie').val("")
	$('.Serie').focus()
	$('#contador').html(Renglon+"/y")
	$('#contador').css('color','#06F')
	Renglon++
	
});

</script>
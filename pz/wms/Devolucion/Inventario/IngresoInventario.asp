<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->


<div class="wrapper wrapper-content  animated fadeInRight">
    <div class="form-horizontal" id="toPrint">
        <div class="row">
            <div class="col-lg-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <h2>Ingreso de serie</h2>
                        <div class="form-group" style="text-align:end;">
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <input class="btn btn-info btnIniciarCargaSerie" type="button" value="Iniciar Carga"> 
                              <input class="btn btn-danger btnCancelarCargaSerie" type="button" value="Cancelar Carga">
                              <input class="btn btn-success btnFinalizarSerie" type="button" value="Finalizar carga">
                            </div>                    
                        </div>
                        <div class="form-group divCargaSerie">
                            <label class="control-label col-md-3">Folio</label>
                            <div class="col-md-4">
                                <input class="form-control Serie" placeholder="Ingrese la serie" type="text" value="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                <div class="col-lg-4">
                    <div class="ibox">
                        <div class="ibox-content">
                            <input class="btn btn-success btnDescargaSeries" type="button" value="Descargar SERIES xls">
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Serie</th>
                                        <th>Folio</th>
                                    </tr>
                                </thead>
                                <tbody id="Actividades2"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
    </div>
</div>
<input name="DevC_ID" id="DevC_ID" type="hidden" value="">
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">

$('.divCargaSerie').hide()
$('.btnCancelarCargaSerie').hide()
$('.btnFinalizarSerie').hide()
$('.btnDescargaSeries').hide()

$(document).ready(function() {
		
		$('.btnIniciarCargaSerie').click(function(e) {
            e.preventDefault();
			DevolucionCorte()
			$(this).hide('slow')		
			$('.divCargaSerie').show('slow')
			$('.btnCancelarCargaSerie').show('slow')
			$('.btnFinalizarSerie').show('slow')
			$('.btnDescargaSeries').hide('slow')	
        });
		$('.btnCancelarCargaSerie').click(function(e) {
            e.preventDefault();
			BorraCorte()
			$(this).hide('slow')		
			$('.btnIniciarCargaSerie').show('slow')
			$('.btnFinalizarSerie').hide('slow')
			$('.divCargaSerie').hide('slow')
        });
		
		$('.btnFinalizarSerie').click(function(e) {
            e.preventDefault();
			Series = []
			$(this).hide('slow')
			$('.btnIniciarCargaSerie').show('slow')
			$('.btnCancelarCargaSerie').hide('slow')
			$('.btnDescargaSeries').show('slow')
			$('#Actividades2').html("")
        });
		
		$('.Serie').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
				if(Mayus != ""){
					CargaSerie(Mayus.trim(),$(this))	
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
		});

});

function DevolucionCorte(){
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:2,
		IDUsuario:$("#IDUsuario").val()
		},function(data){
			if(data > 0){
				$("#DevC_ID").val(data)
				var sTipo = "success";   
				var sMensaje = "Ya se puede escanear";
			}else{
				var sTipo = "error";   
				var sMensaje = "Algo ocurri&oacute; mal";
			}
			Avisa(sTipo,"Aviso",sMensaje);		
	});
}
function BorraCorte(){
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:3,
		DevC_ID:$("#DevC_ID").val()
		},function(data){
			if(data == 1){
				$("#DevC_ID").val("")
				var sTipo = "success";   
				var sMensaje = "Corte cancelado correctamente";
			}
			else{
				var sTipo = "error";   
				var sMensaje = "Error al cancelar";
			}
			Avisa(sTipo,"Aviso",sMensaje);		
	});
}
var Series = []
function CargaSerie(Serie,r){
	r.val("")	
	r.focus()
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:4,
		DevS_Serie:Serie,
		IDUsuario:$("#IDUsuario").val(),
		DevC_ID:$("#DevC_ID").val()
		},function(data){
		var json = JSON.parse(data)
		console.log(json)
			if(json.result == 1){
			var tr = "<tr><td>"+Serie+"</td><td>"+json.Folio+"</td></tr>"
			$("#Actividades2").prepend(tr)
			Series.push({"Folio":json.Folio,"Serie":Serie,"Usuario Escaneo":$("#sUsuarioSes").val(),"Corte":$("#DevC_ID").val()})
			
			}else{
				var sTipo = "error";   
				var sMensaje = Serie+" no existe o ya fue escaneado";
				Avisa(sTipo,"Aviso",sMensaje);		
			}
	});
}

$(".btnDescargaSeries").click(function(){
	var date = new Date()
	var months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
	var ws = XLSX.utils.json_to_sheet(Series);
	var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
	XLSX.writeFile(wb, "Devolucion Series "+$("#sUsuarioSes").val()+" "+date.getDate()+" "+months[date.getMonth()]+" "+date.getHours()+"."+date.getMinutes()+" hrs.xlsx");

});

</script>





<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->



<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-lg-8">
            <div class="ibox">
                <div class="ibox-content">
                    <h2>Devoluciones</h2>
                    <div class="form-group" style="text-align:end;">
                        <input class="btn btn-info btnIniciarCarga" type="button" value="Iniciar Carga"> <input class="btn btn-danger btnCancelarCarga" style="display:none" type="button" value="Cancelar Carga">
                    </div>
                    <div class="form-group divCarga" style="display:none">
                        <label class="control-label col-md-3">Folio</label>
                        <div class="col-md-4">
                            <input class="form-control Folio" placeholder="Ingrese el folio" type="text" value="">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="ibox">
                <div class="ibox-content">
                    <input class="btn btn-success btnDescargaFolios" type="button" value="Descarga FOLIOS xls">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>Folio</th>
                            </tr>
                        </thead>
                        <tbody id="Actividades"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-8">
            <div class="ibox">
                <div class="ibox-content">
                    <h2>Ingreso de serie</h2>
                    <div class="form-group" style="text-align:end;">
                        <input class="btn btn-info btnIniciarCargaSerie" type="button" value="Iniciar Carga"> <input class="btn btn-danger btnCancelarCargaSerie" style="display:none" type="button" value="Cancelar Carga"> <input class="btn btn-success btnNuevoCorteSerie" style="display:none" type="button" value="Nuevo corte">
                    </div>
                    <div class="form-group divCargaSerie" style="display:none">
                        <div class="form-group divCarga">
                            <label class="control-label col-md-3">Folio</label>
                            <div class="col-md-4">
                                <input class="form-control Serie" placeholder="Ingrese la serie" type="text" value="">
                            </div>
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

$(document).ready(function() {
	
		$('.btnIniciarCarga').click(function(e) {
            e.preventDefault();
			DevolucionCorte()
			$('.btnCancelarCarga').css('display',"block")			
			$('.divCarga').css('display',"block")
			$(this).hide('slow')		
        });
		$('.btnCancelarCarga').click(function(e) {
            e.preventDefault();
			BorraCorte()
			$(this).hide('slow')
			$('.btnIniciarCarga').show('slow')
			$(this).css('display',"none")
			$('.divCarga').css('display',"none")
        });
		
		$('.btnIniciarCargaSerie').click(function(e) {
            e.preventDefault();
			DevolucionCorte()
			$('.btnCancelarCargaSerie').css('display',"block")			
			$('.divCargaSerie').css('display',"block")
			$(this).hide('slow')		
        });
		$('.btnCancelarCargaSerie').click(function(e) {
            e.preventDefault();
			BorraCorte()
			$(this).hide('slow')
			$('.btnIniciarCargaSerie').show('slow')
			$(this).css('display',"none")
			$('.divCargaSerie').css('display',"none")
        });
		$('.btnNuevoCorteSerie').click(function(e) {
            e.preventDefault();
			Series = []
			DevolucionCorte()
			$(this).hide('slow')
        });
	
		$('.Folio').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
			console.log(Mayus)
				if(res != ""){
					CargaDevolucion(Mayus.trim(),$(this))	
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
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
var Folios = []
function CargaDevolucion(Folio,r){
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:1,
		Dev_Folio:Folio,
		IDUsuario:$("#IDUsuario").val(), 
		DevC_ID:$("#DevC_ID").val()
		},function(data){ 
			if(data == 1){
			var tr = "<tr><td>"+Folio+"</td></tr>"
			$("#Actividades").prepend(tr)
			Folios.push({"Folio":Folio,"Usuario Escaneo":$("#sUsuarioSes").val(),"Corte":$("#DevC_ID").val()})
			
			}else{
				var sTipo = "error";   
				var sMensaje = Folio+" no existe o ya fue escaneado";
				Avisa(sTipo,"Aviso",sMensaje);		
			}
		r.val("")	
	});
}

$(".btnDescargaFolios").click(function(){

console.log(Folios)
console.log(JSON.stringify(Folios))
	var ws = XLSX.utils.json_to_sheet(Folios);
	var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
	XLSX.writeFile(wb, "Devolucion "+$("#DevC_ID").val()+".xlsx");

});
// Function to download data to a file

var Series = []
function CargaSerie(Serie,r){
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:4,
		DevS_Serie:Serie,
		IDUsuario:$("#IDUsuario").val(),
		DevC_ID:$("#DevC_ID").val()
		},function(data){
			if(data != "-1"){
			var tr = "<tr><td>"+Serie+"</td><td>"+data+"</td></tr>"
			$("#Actividades2").prepend(tr)
			Series.push({"Folio":data,"Serie":Serie,"Usuario Escaneo":$("#sUsuarioSes").val(),"Corte":$("#DevC_ID").val()})
			
			}else{
				var sTipo = "error";   
				var sMensaje = Serie+" no existe o ya fue escaneado";
				Avisa(sTipo,"Aviso",sMensaje);		
			}
		r.val("")	
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


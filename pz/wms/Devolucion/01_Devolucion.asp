<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->




<div class="wrapper wrapper-content  animated fadeInRight">
    <div class="form-horizontal" id="toPrint">
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <h2>Devoluciones</h2>
                        <div class="form-group" style="text-align:end;">
                            <input type="button" class="btn btn-info btnIniciarCarga" value="Iniciar Carga"/>
                            <input type="button" style="display:none" class="btn btn-danger btnCancelarCarga" value="Cancelar Carga"/>
                        </div>
                        <div class="form-group divCarga" style="display:none">
                            <label class="control-label col-md-3">Folio</label>
                            <div class="col-md-4"><input type="text" class="form-control Folio" value="" placeholder="Ingrese el folio"/></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="ibox ">    
                    <div class="ibox-content">
                        <div class="form-group"> 
                            <input type="button" class="btn btn-success btnDescargaFolios" value="Descarga xls"/>
                        </div>
                        <table class="table table-striped table-bordered">
                             <thead>
                                <tr> 
                                    <th>Folio</th>
                                </tr>
                            </thead>
                            <tbody id="Actividades">
                            </tbody>
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
	
		$('.Folio').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
			console.log(Mayus)
				if(res != ""){
					CargaDevolucion(Mayus,$(this))	
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
			}	
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
					var sMensaje = "Folio cargado correctamente";
					Avisa(sTipo,"Aviso",sMensaje);			

			}
			else{
				var sTipo = "error";   
				var sMensaje = "Error al cancelar";
				Avisa(sTipo,"Aviso",sMensaje);		
			}
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
			$("#Actividades").append(tr)
			Folios.push({"Folio":Folio,"Papa Sr":Folio})
			
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
	var ws = XLSX.utils.json_to_sheet(Folios);
	var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
	XLSX.writeFile(wb, "Devolucion "+$("#DevC_ID").val()+".xlsx");

});
// Function to download data to a file

</script>


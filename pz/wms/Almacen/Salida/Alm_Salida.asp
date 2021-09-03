<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->



<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <h2>Carga de gu&iacute;as</h2>
                        <div class="form-group">
                            <div class="col-xs-6">
                                <%var sCampo = "Prov_Nombre"
                                  var sCond = "Prov_EsPaqueteria = 1 AND Prov_Habilitado = 1"
                                    CargaCombo("Prov_ID"," class='form-control col-xs-6' ","Prov_ID",sCampo,
                                    "Proveedor",sCond,sCampo,-1,0,"Selecciona","Editar")%>
                            </div> 
                        </div>
                         <h2 class="divGuias" id="CargaGuia"></h2>
                         <div class="form-group divGuias">
                            <label class="control-label col-md-3">Folio</label>
                            <div class="col-md-3">
                                <input class="form-control Folio"  placeholder="Ingrese el folio" type="text" value=""/><br>
                                <small id="Mensaje"></small>
                            </div>
                            <label class="control-label col-md-3">Gu&iacute;a</label>
                            <div class="col-md-3">
                                <input class="form-control Guia" placeholder="Ingrese la gu&iacute;a" type="text" value=""/>
                            </div>
                        </div>
                        <div id="GeneracionGuia" class="form-group">
                            <label class="control-label col-md-1">Pedido</label>
                            <div class="col-md-5">
                                <input class="form-control txtPedido" placeholder="Ingrese el pedido" type="text" value=""/>
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
                                    <th>Guia</th>
                                    <th>Usuario</th>
                                </tr>
                            </thead>
                            <tbody id="Actividades"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="OV_ID" name="OV_ID" />
<input type="hidden" id="Prov" name="Prov" />

<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">

$('.divGuias').hide()
$('#GeneracionGuia').hide()
$(".Guia").prop('disabled',true)

var date = new Date()
var Dia = date.getDate()
if(Dia < 10){
	Dia = "0"+Dia	
}
var Mes = ["01","02","03","04","05","06","07","08","09","10","11","12"]
var Fecha = Dia+""+Mes[date.getMonth()]+""+date.getFullYear()+" "+date.getHours()+"."+date.getMinutes()+" hrs"


$(document).ready(function() {
	
		$('.i-checks').iCheck({ radioClass: 'iradio_square-blue' }); 

		$('.btnFinalizar').click(function(e) {
            e.preventDefault();
        });
		
		$('#Prov_ID').on('change', function(event) {
			var Prov_ID = $(this).val()
			$('#Prov').val(Prov_ID)
			var Transportista = $("#Prov_ID option:selected").text();
			$('#CargaGuia').addClass('navy-text');
			$('#CargaGuia').html("Gu&iacute;as de "+Transportista);
			if(Prov_ID == 4){
				SalidaFunctions.GeneracionGuiaAPI();
			}else{
				SalidaFunctions.CargaGuia();	
			}
		});
		$('.txtPedido').on('keypress',function(e) {
			if(e.which == 13) {	
				var DatoIngreso = $(this).val();
				var res =DatoIngreso.replace("'", "-");
				var Mayus = res.toUpperCase();
				
				var Aviso ={
					Tipo:"error",
					Titulo: "Sin dato",
					Mensaje:"Lo sentimos no se encontro el folio"
				};   
				if(Mayus != ""){
					Aviso.Titulo = "Guia generandose!"
					Aviso.Tipo = "success"
					Aviso.Mensaje = "La guia se esta generando, espere un momento por favor"
					SalidaFunctions.GeneraGuia(Mayus.trim());	
				}
				Avisa(Aviso.Tipo,Aviso.Titulo,Aviso.Mensaje);			

			}
		}); 
			
		$('.Folio').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
			console.log(Mayus)
				if(res != ""){
					VerificaGuia(Mayus.trim(),$(this))	
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
		});
		$('.Guia').on('keypress',function(e) {
			if(e.which == 13) {	
				var DatoIngreso = $(this).val();
				var Proveedor = $("#Prov_ID option:selected").text();
				if(DatoIngreso != ""){
					if(Proveedor == 'RedPack'){
						DatoIngreso = DatoIngreso.substr(1,10)
					}
					ColocarGuia(DatoIngreso.trim(),$(this))	;
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
		});
		

});

var SalidaFunctions = {
	CargaGuia:function(){
		$('.divGuias').hide('slow');
		$('.divGuias').show('slow');
		$('#GeneracionGuia').hide('slow')
	},
	GeneracionGuiaAPI:function(){
		$('.divGuias').hide('slow');
		$('#GeneracionGuia').show('slow')
	},
	GeneraGuia:function(){
		var Prov_ID = $('#Prov').val()
		console.log(Prov_ID)
	}
	
}

function VerificaGuia(Folio,input){
	//input.prop('disabled',true)
	$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",
		{
		Tarea:1,
		OV_Folio:Folio
		},function(data){
			var resp = JSON.parse(data)
			if(resp.result == 1){
				var sTipo = "success";   
				$(".Guia").prop('disabled',false)
				$('.Guia').focus()
				$("#Mensaje").css('color','#09F')
				$("#OV_ID").val(resp.data[0].OV_ID)
			}else if (resp.result == -1){
				var sTipo = "error";   
				$("#Mensaje").css('color','#F00')
				Avisa(sTipo,"Aviso",resp.message);
			}
			$("#Mensaje").html(resp.message)
					
	});
}
var Guias = []
function ColocarGuia(Guia,input){
	
	var Datos = {
			Tarea:2,
			IDUsuario:$("#IDUsuario").val(),
			OV_ID:$("#OV_ID").val(),
			OV_Folio:$(".Folio").val(),
			OV_TRACKING_COM:$("#Prov_ID option:selected").text(),
			OV_TRACKING_NUMBER:Guia
		}
	
	$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",Datos,function(data){
		var response = JSON.parse(data)
			if(response.result == 1){
				var tr = "<tr><td>"+Datos.OV_Folio+"</td><td>"+Datos.OV_TRACKING_NUMBER+"</td><td>"+$("#sUsuarioSes").val()+"</td></tr>"
				$("#Actividades").prepend(tr)
				
				$("#OV_ID").val("")
				$(".Folio").val("")
				$(".Folio").focus()
				$(".Guia").prop('disabled',true)
				$(".Guia").val("")
				
				var sTipo = "success"; 
				Guias.push({"Folio":Datos.OV_Folio,"Guia":Datos.OV_TRACKING_NUMBER,"Usuario Escaneo":$("#sUsuarioSes").val()})
			}else{
				var sTipo = "error";   
			}
			Avisa(sTipo,"Aviso",response.message);		
	});
}

$(".btnDescargaFolios").click(function(){
	var ws = XLSX.utils.json_to_sheet(Guias);
	var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Guias");
	XLSX.writeFile(wb, "MANIFIESTO "+Fecha+".xlsx");

});




</script>

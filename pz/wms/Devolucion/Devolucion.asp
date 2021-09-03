<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var DevC_ID = BuscaSoloUnDato("ISNULL((MAX(DevC_ID)),0)","Devolucion_Corte","",-1,0)
	
%>


<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="form-group">
                            <label class="control-label col-md-2">Corte</label>
                            <div class="col-md-3">
                            <%CargaCombo("DevCorte_ID"," class='form-control'","DevC_ID","DevC_ID","Devolucion_Corte","","",-1,0,"Selecciona","Editar")%>
                       		 </div>
                         </div>
                    </div>    
                </div>    
            </div>    
        </div>    
    
        <div class="row">
            <div class="col-lg-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <h2>Devoluciones <h2 id=""></h2></h2>
                        <div class="form-group"  style="text-align:end;">
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <input class="btn btn-info btnIniciarCarga" type="button" value="Iniciar Carga">
                            </div>                    
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <input class="btn btn-danger btnCancelarCarga" type="button" value="Cancelar Carga">
                              <input class="btn btn-success btnFinalizar" type="button" value="Finalizar carga">
                            </div>                    
                        </div>
                        <div class="form-group divCarga">
                            <label class="control-label col-md-3">Folio</label>
                            <div class="col-md-3">
                                <input class="form-control Folio" placeholder="Ingrese el folio" type="text" value="">
                            </div>
                            <label class="control-label col-md-3">Buscar por Gu&iacute;a</label>
                            <div class="col-md-3">
                                <input class="form-control Guia" placeholder="Ingrese la gu&iacute;a" type="text" value="">
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
                        <h2>&Uacute;ltima devoluci&oacute;n Corte <%=DevC_ID%></h2>
                        <div class="text-right">
                        <input class="btn btn-danger btnDescargarCorte" type="button" value="Descargar corte <%=DevC_ID%>">
                        </div>
                        <table class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Folio</th>
                                    <th>Usuario</th>
                                    <th>Fecha  registro</th>
                                </tr>
                            </thead>
                            <tbody>
                <%
				var sSQLDev = "SELECT * "
					sSQLDev += ", CONVERT(NVARCHAR(20),Dev_FechaRegistro,103) +' '+CONVERT(NVARCHAR(20),Dev_FechaRegistro,108) +' hrs' as FechaRegistro "
					sSQLDev += "FROM Devolucion WHERE DevC_ID = " +DevC_ID
                    var rsDev = AbreTabla(sSQLDev,1,0)
    
                    while (!rsDev.EOF){
                        var Dev_Folio = rsDev.Fields.Item("Dev_Folio").Value 
                        var FechaRegistro = rsDev.Fields.Item("FechaRegistro").Value 
                        var Dev_Usuario = rsDev.Fields.Item("Dev_Usuario").Value 
					                              
                %> 
                            <tr>
                                <td><%=Dev_Folio%></td>
                                <td><%=Dev_Usuario%></td>
                                <td><%=FechaRegistro%></td>
                            </tr>
				<%	
						rsDev.MoveNext() 
					}
                rsDev.Close()   
                %>

                            
                            </tbody>
                        </table>
                        
                    </div>
                </div>
            </div>
        </div>
        </div>
    </div>
</div>


<input name="DevC_ID" id="DevC_ID" type="hidden" value="">
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">
$('.divCarga').hide()
$('.btnCancelarCarga').hide()
$('.btnFinalizar').hide()
$('.btnDescargaFolios').hide()


$(document).ready(function() {
	
		$('.btnIniciarCarga').click(function(e) {
            e.preventDefault();
			DevolucionCorte()
			$('.btnCancelarCarga').show('slow')
			$('.divCarga').show('slow')
			$(this).hide('slow')
			$('.btnDescargaFolios').hide('slow')	
			Folios = []
			$('#Actividades').html("")
        });
		$('.btnCancelarCarga').click(function(e) {
            e.preventDefault();
			BorraCorte()
			$(this).hide('slow')
			$('.btnIniciarCarga').show('slow')
			$('.divCarga').hide('slow')
			Folios = []
			$('#Actividades').html("")
        });
		
		$('.btnFinalizar').click(function(e) {
            e.preventDefault();
			$(this).hide('slow')
			$('.btnIniciarCarga').show('slow')
			$('.btnCancelarCarga').show('slow')
			$('.btnDescargaFolios').show('slow')
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
		$('.Guia').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
			console.log(Mayus)
				if(res != ""){
					BuscaFolio(Mayus.trim(),$(this))	
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
		var response = JSON.parse(data)
			if(response.result == 1){
				$("#DevC_ID").val("")
				var sTipo = "success";   
			}else{
				var sTipo = "error";   
			}
			Avisa(sTipo,"Aviso",response.message);		
	});
}
var Folios = []
function CargaDevolucion(Folio,r){
	r.val("");	
	r.focus();
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{Tarea:1,
		Dev_Folio:Folio,
		IDUsuario:$("#IDUsuario").val(), 
		DevC_ID:$("#DevC_ID").val()
		},function(data){ 
		var response = JSON.parse(data)
		if(response.result == 1){
			var tr = "<tr><td>"+Folio+"</td></tr>"
			$("#Actividades").prepend(tr)
			Folios.push({"Folio":Folio,"Usuario Escaneo":$("#sUsuarioSes").val(),"Corte":$("#DevC_ID").val()})
			$(".btnFinalizar").show('slow')
			var sTipo = "success";   
		}else{
			var sTipo = "error";   
		}
		Avisa(sTipo,"Aviso",response.message);		

	});
}
function BuscaFolio(Folio,r){
	r.val("")	
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:5,
		Guia:Folio
		},function(data){ 
		var response = JSON.parse(data)
			if(response.result == 1){
				CargaDevolucion(response.Folio,r)		
				var sTipo = "success"; 
			}else{
				var sTipo = "error";   
			}
			Avisa(sTipo,"Aviso",response.message);		
	});
}

$(".btnDescargaFolios").click(function(){

console.log(Folios)
console.log(JSON.stringify(Folios))
	var ws = XLSX.utils.json_to_sheet(Folios);
	var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
	XLSX.writeFile(wb, "Devolucion "+$("#DevC_ID").val()+".xlsx");

});

$(".btnDescargarCorte").click(function(){
	var btn = $(this)
	btn.prop('disabled',true)
	$.post("/pz/wms/Devolucion/Devolucion_Data.asp",
		{
		DevC_ID:<%=DevC_ID%>
		},function(data){ 
		var response = JSON.parse(data)
		var ws = XLSX.utils.json_to_sheet(response);
		var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
		XLSX.writeFile(wb, "Devolucion Corte <%=DevC_ID%>.xlsx");
		btn.prop('disabled',false)
	});

});


// Function to download data to a file



</script>


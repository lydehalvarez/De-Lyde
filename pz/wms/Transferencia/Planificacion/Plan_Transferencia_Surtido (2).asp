<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1);
	
	var Total = BuscaSoloUnDato("COUNT(*)","TransferenciaAlmacen","TA_ArchivoID = "+TA_ArchivoID,-1,0);

%>

<div class="container-fluid">
    <div class="form-horizontal">
        <div class="col-lg-12">
            <div class="ibox-title">
                <h1>Corte <%=TA_ArchivoID%> <small>Crear la prioridad de <%=Total%> pedido(s)</small></h1>
            </div>
            <div class="ibox-content">
                <div class="row">
                    <div class="col-md-4">
                        <div style="margin-bottom: 30px;">
                            <div class="form-group">
                               <label class="control-label col-md-4"><strong>Filtro</strong></label>
                               <div class="col-md-8">
                                    <%CargaCombo("Tipo"," class='form-control'","Cat_ID","Cat_Nombre",
                                   "Cat_Catalogo","Sec_ID = 115 ","Cat_Nombre",-1,0,"Total sin asignar","Editar")%>
                               </div>
                           </div> 
                        </div> 
                        <div class="row">
                           <div id="Resumen"></div>  
                       </div> 
                   </div>
                    <div class="col-md-8">
                            <div id="Resultado"></div>            
                    </div>            
                </div>
            </div>
            <div class="ibox-title">
                <h1>Planificaci&oacute;n <small>en la linea de producci&oacute;n de <strong><%=Total%></strong> ordenes</small></h1>
            </div>
            <div class="ibox-content">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                           <label class="control-label col-md-3"><strong>Cantidad de lineas</strong></label>
                            <div class="col-md-3">
                                <input class="form-control" id="Lineas" min="1" placeholder="Lineas" type="number" value="">
                            </div> 
                            <div class="col-md-3">
                                <button type="button" class="btn btn-success btnConfirm">Confirmar</button>
                            </div>
                       </div> 
                       <div id="Organizar"></div>
                       
                   </div>
                </div>
            </div>
        </div>
    </div>
</div>

 
<script src="/pz/wms/Transferencia/Transferencia_Surtido.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="application/javascript">

$('#Resultado').hide()

			
var loading = '<div class="loading sk-spinner sk-spinner-three-bounce">'+
				'<div class="sk-bounce1"></div>'+
				'<div class="sk-bounce2"></div>'+
				'<div class="sk-bounce3"></div>'+
			'</div>'

$(document).ready(function(e) {
	Planificacion.CargaPlan(-1)
});

$("[type='number']").keypress(function (evt) {
    evt.preventDefault();
});


$('#Tipo').change(function(e) {
    e.preventDefault();
	var Tipo = $(this).val()
	Planificacion.CargaPlan(Tipo)
});


$('.btnConfirm').click(function(e) {
    e.preventDefault();
	Planificacion.Organiza();
});

$("#Organizar").on("click", ".btnAddConf", function(e){
    e.preventDefault();
	var ran = $(this).val()
	console.log(ran)
});

$("#Organizar").on("click", ".btnDeleteConf", function(e){
    e.preventDefault();
	var ran = $(this).val()
	$('#Formu_'+ran).remove()
});


var Planificacion = {
	Muestra_Cargando:function(vista){
		vista.prepend(loading);
		vista.show('slow')
	},
	Oculta_Cargando:function(vista){
		$('.loading').hide('slow', function() {
			$('.loading').remove();
		});
	},
	CargaPlan:function(Tipo){
		Planificacion.Resumen()
		$('#Resultado').hide('slow')
		$.post("/pz/wms/Transferencia/Planificacion/Planificacion.asp",
		{
			TA_ArchivoID:$('#TA_ArchivoID').val()
			,Tipo:Tipo
		}
		, function(data){
			if(data != ""){
				$('#Resultado').html(data)
				$('#Resultado').show('slow')
			}
		});
	},
	GuardaPlan:function(Tipo){
		var Data = []
		$(".inValor").each(function() {
			var orden =$(this).val()
			if(orden >0)
			Data.push({IDUsuario:$('#IDUsuario').val(),Tarea:1,Orden:orden,ID:$(this).data('dato'),Tipo:$(this).data('tipo'),TA_ArchivoID:$('#TA_ArchivoID').val()})
		});
		var Limite = Data.length
		for(var i = 0;i<Limite;i++){
			$.post("/pz/wms/Transferencia/Planificacion/Planificacion_Ajax.asp",Data[i], function(data){
				if(Limite == i){
					Planificacion.CargaPlan($('#Tipo').val());
				}
			});
		}
	},
	RestableceOrden:function(Tipo){
			swal({
			  title: "Restablecer orden",
			  text: "Al aceptar se perder&aacute; todo el orden previamente elaborado en este corte &iquest;Desea continuar?",
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonClass: "btn-success",
			  confirmButtonText: "Ok" ,
			  closeOnConfirm: true,
			  html: true
			},
			function(data){
				if(data){
					Planificacion.Restablece();
				}
			});		
	},
	Restablece:function(){
		$.post("/pz/wms/Transferencia/Planificacion/Planificacion_Ajax.asp",{
			TA_ArchivoID:$('#TA_ArchivoID').val(),
			Tarea:2
		}, function(data){
			var resp = JSON.parse(data);
			if(resp.result == 1){
				Planificacion.CargaPlan($('#Tipo').val());
				Avisa("success","Aviso",""+resp.messaage);
			}else{
				Avisa("error","Error",""+resp.messaage);
			}
			
		});
	},
	Organiza:function(){
		$.post("/pz/wms/Transferencia/Planificacion/Planificacion_Lineas.asp",{
			TA_ArchivoID:$('#TA_ArchivoID').val(),
			Linea:$('#Lineas').val()
		}, function(data){
			if(data != ""){
				$('#Organizar').html(data)
			}else{
				Avisa("error","Error","Ocurrio un error :(");
			}
			
		});
	},
	Configuracion:function(Linea){
		Planificacion.Muestra_Cargando($('#Linea_'+Linea))
		$.post("/pz/wms/Transferencia/Planificacion/Planificacion_Ajax.asp",{
			Linea:Linea,
			TA_ArchivoID:$('#TA_ArchivoID').val(),
			Tarea:3
		}, function(data){
			if(data != ""){
				Planificacion.Oculta_Cargando()
				$('#Linea_'+Linea).prepend(data)
			}else{
				Avisa("error","Error","Ocurrio un error :(");
			}
			
		});
	},
	Resumen:function(){
		$('#Resumen').hide('slow')
		$.post("/pz/wms/Transferencia/Planificacion/Planificacion_Resumen.asp",{
			TA_ArchivoID:$('#TA_ArchivoID').val()
		}, function(data){
			if(data != ""){
				$('#Resumen').show('slow')
				$('#Resumen').html(data)
			}else{
				Avisa("error","Error","Ocurrio un error :(");
			}
			
		});
	},
	AddConfig:function(Linea,Ran){
		
		console.log("Linea = "+Linea+ " Prioridad = "+$('#Prioridad_'+Ran+' option:selected').text())
	},
	Maximo:function(Valor,Ran){
		Planificacion.Muestra_Cargando($('#ShowCantidad_'+Ran))
		$.post("/pz/wms/Transferencia/Planificacion/Planificacion_Ajax.asp",{
			identi:Ran,
			TA_Orden:$('option:selected',Valor).text(),
			TA_ArchivoID:$('#TA_ArchivoID').val(),
			Tarea:4
		}, function(data){
			if(data != ""){
				Planificacion.Oculta_Cargando()
				$('#btnAddConfig_'+Ran).prop('disabled',false)
				$('#ShowCantidad_'+Ran).html(data)
			}
		});
	}
}


</script>
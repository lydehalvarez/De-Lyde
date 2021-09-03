<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)

%>
<div class="form-horizontal wrapper wrapper-content animated fadeInRight">
    <div class="col-lg-12">
        <div class="ibox">
            <div class="ibox-title">
                <h5>Planeaci&oacute;n <small>Crear la prioridad de los pedidos</small></h5>
            </div>
            <div class="ibox-content">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                           <label class="control-label col-md-4"><strong>Filtro</strong></label>
                           <div class="col-md-8">
                                <%CargaCombo("Tipo"," class='form-control'","Cat_ID","Cat_Nombre",
                               "Cat_Catalogo","Sec_ID = 115 ","Cat_Nombre",-1,0,"Total sin asignar","Editar")%>
                           </div>
                       </div> 
                   </div>
                    <div class="col-md-8">
                            <div id="Resultado"></div>            
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

$(document).ready(function(e) {
	Planificacion.CargaPlan(-1)
});


$('#Tipo').change(function(e) {
    e.preventDefault();
	var Tipo = $(this).val()
	Planificacion.CargaPlan(Tipo)
});

var Planificacion = {
	CargaPlan:function(Tipo){
		$('#Resultado').hide('slow')
		$.post("/pz/wms/Transferencia/Planificacion.asp",
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
			$.post("/pz/wms/Transferencia/Planificacion_Ajax.asp",Data[i], function(data){
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
		$.post("/pz/wms/Transferencia/Planificacion_Ajax.asp",{
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
	}
}


</script>
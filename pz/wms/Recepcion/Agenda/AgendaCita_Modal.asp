<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="form-horizontal">

    <div class="form-group">
        <label class="control-label col-md-2">Transportista</label>
        <div class="control-label col-md-1"><input type="checkbox" class="Carrier" value="1"/></div>
    </div>
    <div id="CarrierData">
    </div>
    <div class="form-group">
        <label class="control-label col-md-2">Fecha</label>
        <div class="col-md-3">
            <div class="input-group date">
                    <input class="form-control Fecha"
                    id="Ag_FechaEntrega" placeholder="dd/mm/aaaa" type="text" autocomplete="off" value=""> 
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
            </div>
        </div>
       <label class="control-label col-md-3"><strong>Hora inicio</strong></label>
        <div class="col-md-3" id="dvHora">
            <div class="input-group clockpicker" data-autoclose="true">
                <input class="form-control Hora" id="IR_Horario" type="text" autocomplete="off" placeholder="Abrir reloj" value="">
                <span class="input-group-addon"><span class="fa fa-clock-o"></span></span>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label class="control-label col-md-2">Puerta</label>
        <div class="col-md-3">
            <%
                var sCond = "Alm_TipoCG88 = 5 AND Alm_ID = 3"
                CargaCombo("AlmP_ID"," class='form-control' ","AlmP_ID","AlmP_Nombre",
                "Almacen_Posicion",sCond,"AlmP_Nombre",-1,0,"Selecciona","Editar")
            %>
        </div>
    </div>
    
    
</div>

<script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script type="application/javascript">

$(document).ready(function() {
 			
	$('.Fecha').datepicker({
		todayBtn: "linked", 
		language: "es",
		todayHighlight: true,
		autoclose: true
	});
	
	$('.Hora').clockpicker({
		autoclose: true,
		twentyfourhour: true,
	});
});
	$('.Carrier').iCheck({
		checkboxClass: 'icheckbox_square-green'
	});
	$('.Carrier').on('ifChanged', function(event) {	
		console.log(event)
		if(event.target.checked){
			
		}else{
			
		}
	});


</script>

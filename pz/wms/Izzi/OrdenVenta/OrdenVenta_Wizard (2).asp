<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var OC_ID = Parametro("OC_ID",0)

	var sSQL = "  SELECT * "
		sSQL += " FROM Izzi_Orden_Venta_Seguimiento "
		sSQL += " WHERE OC_ID = "+ OC_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQL,0)
			
	var sSQL2 = "  SELECT * "
		sSQL2 += " FROM Izzi_Orden_Venta "
		sSQL2 += " WHERE OC_ID = "+ OC_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQL2,0)	
	
	var OCSeg_Paso = Parametro("OCSeg_Paso",0)
	var OCSeg_ID = Parametro("OCSeg_ID",-1)
	
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">

<div id="wizard" class="wizard-big">
    <h1>Datos orden de venta</h1>
    <div>
        <div class="form-group">
            <label class="control-label col-md-3"><strong>N&uacute;mero de solicitud (Izzi)</strong></label>
            <div class="col-md-3 SoloConsulta">
                <%=Parametro("CORID","")%>
            </div>
            <label class="control-label col-md-3"><strong>Orden de venta</strong></label>
            <div class="col-md-3 SoloConsulta">
                <%=Parametro("CUSTOMER_SO","")%>
            </div>
        </div>                                
        <div class="form-group">
            <label class="control-label col-md-3"><strong>Cantidad</strong></label>
            <div class="col-md-3 SoloConsulta">
                <%=Parametro("SHIPPIED_QTY","")%>
            </div>
        </div>                                
        <div class="form-group">
            <label class="control-label col-md-3"><strong>Direcci&oacute;n</strong></label>
            <div class="col-md-6 SoloConsulta">
                <%=Parametro("SHIPPING_ADDRESS","")%>
            </div>
        </div>                                
        <div class="form-group">
            <label class="control-label col-md-3"><strong>Texto</strong></label>
            <div class="col-md-6 SoloConsulta">
                <%=Parametro("TEXTO","")%>
            </div>
        </div>                                
    </div>   
    <h1>Envio de IMEI + ICC</h1>
    <div>
            <div class="form-group">
                <label class="control-label col-md-2"><strong>IMEI</strong></label>
                <%var OCSeg_IMEI = Parametro("OCSeg_IMEI","")
				if(OCSeg_IMEI == ""){%>
                <div class="col-md-4">
                    <input autocomplete="off" class="form-control required" id="OCSeg_IMEI" 
                    placeholder="IMEI" type="text">
                </div>
                <%}else{Response.Write("<div class='col-md-4 SoloConsulta'>"+OCSeg_IMEI+"</div>")}%>
            </div>
            <div class="form-group">
                <label class="control-label col-md-2"><strong>ICC</strong></label>
                <%var OCSeg_ICC = Parametro("OCSeg_ICC","")
				if(OCSeg_ICC == ""){%>
                <div class="col-md-4">
                    <input autocomplete="off" class="form-control required" id="OCSeg_ICC" 
                    placeholder="ICC" type="text">
                </div>
                <%}else{Response.Write("<div class='col-md-4 SoloConsulta'>"+OCSeg_ICC+"</div>")}
				if(OCSeg_Paso < 1){%>
                    <div class="col-md-3">
                     <button type="button" id="btnEnviarIMEI" class="btn btn-success btnEnviarIMEI">Mandar a Izzi</button>
                    </div>
				 <%}%>
            </div>
    </div>                     
    <h1>Estatus de gu&iacute;a</h1>
    <div>
            <div class="form-group">
                <label class="control-label col-md-2"><strong>Gu&iacute;a</strong></label>
                <%var OCSeg_Guia = Parametro("OCSeg_Guia","")
				if(OCSeg_Guia == ""){%>
                <div class="col-md-4">
                    <input autocomplete="off" class="form-control" id="OCSeg_Guia" 
                    placeholder="Gu&iacute;a de transportista" type="text">
                </div>
                <%}else{Response.Write("<div class='col-md-4 SoloConsulta'>"+OCSeg_Guia+"</div>")}%>
            </div>
            <div class="form-group">
                <label class="control-label col-md-2"><strong>Transportista</strong></label>
                   <% var  Trans_ID = Parametro("Trans_ID",-1)
				   if(Trans_ID > -1){
					   Response.Write("<div class='col-md-4 SoloConsulta'>"+BuscaSoloUnDato("Trans_Nombre","Cat_Transportistas","Trans_ID ="+Trans_ID,"",0)+"</div>")
				   }else{%>
                    <div class="col-md-4">
					   <%CargaCombo("Trans_ID"," class='form-control'","Trans_ID","Trans_Nombre","Cat_Transportistas","Trans_Habilitado = 1","",Parametro("Trans_ID",-1),0,"Selecciona","Editar")%>
				   </div>
				<%}
				if(OCSeg_Paso <= 2){%>
                 <div class="col-md-3">
                 <button type="button" id="btnEnviarGuia" class="btn btn-success btnEnviarGuia">Enviar gu&iacute;a a Izzi</button>
                </div>
				 <%}%>
            </div>
    </div>                     
    <h1>Estatus de entrega</h1>
    <div>
        <div class="form-group">
            <label class="control-label col-md-3"><strong>Confirmaci&oacute;n de entrega</strong></label>
            <div class="col-md-4">
			<%var OCSeg_ConfirmaEntrega = Parametro("OCSeg_ConfirmaEntrega",0)
				if(OCSeg_ConfirmaEntrega == 1){%>
                <input type="checkbox" class="HolaCheck" id="OCSeg_ConfirmaEntrega" checked="checked" disabled="disabled" value="1"/>
            <%}else{%>
                <input type="checkbox" class="HolaCheck" id="OCSeg_ConfirmaEntrega" value="1"/>
            <%}%>
            </div>
			<%if(OCSeg_Paso <= 3){%>
                 <div class="col-md-3">
                 <button type="button" id="btnCorfirmaEntrega" value="-1" class="btn btn-success btnCorfirmaEntrega">Enviar gu&iacute;a a Izzi</button>
                </div>
			 <%}%>
        </div>
    </div>                     
    <h1>Tarea terminada</h1>
    <div style="text-align:center">
    <img src="Img/agt/exito.png" height="250" width="250"/>
    <div>Excelente trabajo.</div>
    </div>                     
</div>

<input type="hidden" id="OCSeg_ID" value="<%=OCSeg_ID%>"/>  

<script src="/Template/inspina/js/plugins/steps/jquery.steps.min.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="/Template/inspina/js/plugins/validate/jquery.validate.min.js"></script>

<script type="application/javascript">

$(document).ready(function() {
	

	var wizard = $("#wizard").steps({
			startIndex: <%=OCSeg_Paso%>,
			headerTag: "h1",
			bodyTag: "div",
			enableFinishButton: false,
			transitionEffect: "slideLeft",
			autoFocus: true,
			labels: {
					cancel: "Cancelar",
					current: "current step:",
					pagination: "Paginaci&oacute;n",
					finish: "Terminar",
					next: "Siguiente",
					previous: "Anterior",
					loading: "Cargando..."
				}
			});

		
	$('.HolaCheck').iCheck({ checkboxClass: 'icheckbox_square-green' }); 
	
	$('.HolaCheck').on('ifChanged', function(event) {
		if(event.target.checked) {
				var Nombre = $(this).attr('id')	
				var Valor = $(this).val()
				$('.btnCorfirmaEntrega').val(Valor)
				console.log("Check en "+Nombre+" "+Valor);
		}
	});
	$('.HolaCheck').on('ifUnchecked', function(event) {
		var Nombre = $(this).attr('id')	
		var Valor = 0
		$('.btnCorfirmaEntrega').val(Valor)
		console.log("Check en "+Nombre+" "+Valor);
	});
	$('.btnEnviarIMEI').click(function(e) {
		e.preventDefault()
		Paso1()
		$('.OCSeg_IMEI').addClass('disabled');
		$('.OCSeg_ICC').addClass('disabled');
		$('.btnEnviarIMEI').addClass('disabled');

	});
	$('.btnEnviarGuia').click(function(e) {
		e.preventDefault()
		Paso2()
		$('.OCSeg_ICC').addClass('disabled');
		$('.btnEnviarGuia').addClass('disabled');
	});
	$('.btnCorfirmaEntrega').click(function(e) {
		e.preventDefault()
		var Valor = $(this).val()
		$('.btnCorfirmaEntrega').addClass('disabled');
		console.log("Paso 3")
		Paso3()
	});
	
});

function Paso1(){
		$.post("/pz/agt/Izzi/OrdenVenta/OrdenVenta_Ajax.asp"
				  , { Tarea:1,
				  	  OC_ID:<%=OC_ID%>,
					  OCSeg_ID:$('#OCSeg_ID').val(),
					  OCSeg_IMEI:$('#OCSeg_IMEI').val(),
					  OCSeg_ICC:$('#OCSeg_ICC').val(),
					  IDUsuario:$('#IDUsuario').val()
				  }             
				  , function(data){
					  if (data >= 1) {
						$('#OCSeg_ID').val(data)
						var Titulo = "&Eacute;xito de env&iacute;o"
						var Body = "Se ha enviado de forma satisfactoria la informaci&oacute;n, se ha avanzado de manera autom&aacute;tica"
						var Type = "success"
						var ButtonConfirm = "Ok!"
						Sweet(Titulo,Body,Type,ButtonConfirm)
					  } else {
						 $('.btnEnviarIMEI').removeClass('disabled');
						sTipo = "warning";   
						sMensaje = "Ocurrio un error al guardar el registro";
						Avisa(sTipo,"Aviso",sMensaje);	
					  } 
			});	
}
function Paso2(){
$.post("/pz/agt/Izzi/OrdenVenta/OrdenVenta_Ajax.asp"
				  , { Tarea:2,
				  	  OC_ID:<%=OC_ID%>,
					  OCSeg_ID:$('#OCSeg_ID').val(),
					  OCSeg_Guia:$('#OCSeg_Guia').val(),
					  Trans_ID:$('#Trans_ID').val(),
					  IDUsuario:$('#IDUsuario').val()
				  }             
				  , function(data){
					  if (data >= 1) {
						$('#OCSeg_ID').val(data)
						var Titulo = "&Eacute;xito de env&iacute;o"
						var Body = "Se ha enviado de forma satisfactoria la informaci&oacute;n, se ha avanzado de manera autom&aacute;tica"
						var Type = "success"
						var ButtonConfirm = "Ok!"
						Sweet(Titulo,Body,Type,ButtonConfirm)
					  } else {
						 $('.btnEnviarGuia').removeClass('disabled');
						sTipo = "warning";   
						sMensaje = "Ocurrio un error al guardar el registro";
						Avisa(sTipo,"Aviso",sMensaje);	
					  } 
			});	
}
function Paso3(){
	var Checked = $(".btnCorfirmaEntrega").val()
	if(Checked <= 0){
		var Titulo = "Es necesario colocar la confirmaci&oacute;n"
		var Body = "Para poder continuar y enviar el estatus de entregado es necesario confirmar"
		var Type = "error"
		var ButtonConfirm = "Ok!"
		Sweet(Titulo,Body,Type,ButtonConfirm)
		 $('.btnCorfirmaEntrega').removeClass('disabled');
	}else{
		$.post("/pz/agt/Izzi/OrdenVenta/OrdenVenta_Ajax.asp"
				  , { Tarea:3,
				  	  OC_ID:<%=OC_ID%>,
					  OCSeg_ID:$('#OCSeg_ID').val(),
					  OCSeg_ConfirmaEntrega:$(".btnCorfirmaEntrega").val(),
					  IDUsuario:$('#IDUsuario').val()
				  }             
				  , function(data){
					  if (data >= 1) {
						$('#OCSeg_ID').val(data)
						var Titulo = "&Eacute;xito de env&iacute;o"
						var Body = "Se ha enviado de forma satisfactoria la informaci&oacute;n, se ha avanzado de manera autom&aacute;tica"
						var Type = "success"
						var ButtonConfirm = "Ok!"
						Sweet(Titulo,Body,Type,ButtonConfirm)
					  } else {
						 $('.btnCorfirmaEntrega').removeClass('disabled');
						sTipo = "warning";   
						sMensaje = "Ocurrio un error al guardar el registro";
						Avisa(sTipo,"Aviso",sMensaje);	
					  } 
			});	
	}
}

function Sweet(Titulo, Body, Type, ConfirmButton){
		swal({
			  title: Titulo,
			  text: Body,
			  type: Type,
			  showCancelButton: true,
			  confirmButtonClass: "btn-success",
			  confirmButtonText: ConfirmButton ,
			  closeOnConfirm: true,
			  html: true
			},
			function(data){
			});
}
	


</script>
                    
                    
                            
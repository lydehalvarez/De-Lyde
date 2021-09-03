<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
    var Aud_ID = Parametro("Aud_ID",1)

    var HayConteoExterno = 0
    var EsCiego = 1
    var PermiteAgregarPallets = 0
    var VisitasContinuas = 0
	var Aud_VisitaActual = 0

    var sSQL = "SELECT ISNULL(Aud_HayConteoExterno,1) as HayConteoExterno "
             + " , ISNULL(Aud_EsCiego,1) as EsCiego "
             + " , ISNULL(Aud_PermiteAgregarPallets,1) as PermiteAgregarPallets "
             + " , ISNULL(Aud_VisitasContinuas,0) as VisitasContinuas "
             + " , Aud_VisitaActual "
             + " FROM Auditorias_Ciclicas ac "
             + " WHERE Aud_ID = " + Aud_ID

    var rsAud = AbreTabla(sSQL, 1, 0);

    if( !(rsAud.EOF) ){
        HayConteoExterno       = rsAud("HayConteoExterno").Value
        EsCiego                = rsAud("EsCiego").Value
        PermiteAgregarPallets  = rsAud("PermiteAgregarPallets").Value
        VisitasContinuas       = rsAud("VisitasContinuas").Value
        Aud_VisitaActual       = rsAud("Aud_VisitaActual").Value
    }

    rsAud.Close();
	
	var Auditores = "SELECT Aud_Externo,COUNT(*) Cantidad "+
				" FROM Auditorias_Auditores " +
				" WHERE Aud_ID = " +Aud_ID +
				" GROUP BY Aud_Externo " 

	var rsAuditores = AbreTabla(Auditores, 1, 0);

	var ValidaAditores = rsAuditores.RecordCount

	rsAuditores.Close();
	

%>

<style>
	#profileImage {
	  width: 25px;
	  height: 25px;
	  border-radius: 50%;
	  background: #512DA8;
	  font-size: 35px;
	  color: #fff;
	  text-align: center;
	  line-height: 150px;
	  margin: 20px 0;
	}

</style>

<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
<div class="row">
    <div class="col-md-12">
        <div class="ibox float-e-margins">
            <legend class="col-sm-12">
                <h4>Buscar papeleta por c&oacute;digo de barras o LPN</h4>
            </legend>
            <div class="form-horizontal">
                <br />
                <%if((ValidaAditores > 1 && HayConteoExterno == 1) || (ValidaAditores >= 1 && HayConteoExterno == 0)){%>
                    <div class="ibox-content" id="divTipo">
                        <div>
                            <label>Tipo de devoluci&oacute;n:</label>&nbsp;&nbsp;&nbsp;
                            <label><input class="i-checks" type="radio" value="1" id="Completo" name="gpo1"/>&nbsp;Auditor Interno </label>
                            <label>&nbsp;&nbsp;&nbsp;&nbsp;<input class="i-checks" type="radio" value="0" id="Parcial" name="gpo1"/>&nbsp;Auditor Externo </label>
                        </div>
                    </div>
                    <div class="form-group" id="ChooseAuditor">
                        <label class="col-md-2 control-label">Auditor:</label>
                        <div class="col-md-4" id="cboChooseAuditor"></div>
                    </div>
                    
                <%}else{%>
                    <div class="ibox-content" id="divTipo">
                        <h2>Falta seleccionar un auditor externo o interno</h2>
                    </div>
                <%}%>


                <div class="form-group" id="dvBuscador" style="display: none">
                    <label class="col-md-2 control-label">Papeleta/ LPN:</label>
                    <div class="col-md-4">
                        <input type="text" class="form-control" id="PapeletaCB" onkeypress="Papeleta.BuscarCB(event);"
                            autocomplete="off" placeholder="CB">
                    </div>
                    <div class="col-md-3 text-right">
                        <a class="btn btn-success btn-sm" id="btnBuscar" onClick="Papeleta.CargaPapeleta();">
                            <i class="fa fa-search"></i> Buscar
                        </a>
                    </div>
                </div>
                <br />
                <br />
                <br />
                <div id="dvResultadoAudi" style="display: none">
                <legend class="col-sm-12">
                    <h4>Resultado obtenido:</h4>
                </legend>
                <div class="form-group">
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">Cantidad:</label>
                    <div class="col-md-4">
                        <input type="text" id="Cantidad" autocomplete="off" placeholder="Conteo" class="form-control" />
                    </div>
			<% if(EsCiego == 0 ){ %>
                    <label class="col-md-2 control-label" >Cantidad: <span class="CantidadActual">-</span></label>
			<% } %>
                    <div class="col-md-3 text-right">
                        <a class="btn btn-success btn-sm" id="btnGuardar" onClick="Papeleta.Guardar();"><i
                                class="fa fa-save"></i> Guardar</a>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">Comentario:</label>
                    <div class="col-md-10 m-b-xs">
                        <input type="text" id="Comentario" class="form-control" autocomplete="off">
                    </div>
                </div>
                <div class="form-group">
                    <div id="ResultInfo"></div>
                </div>
                
                <div class="ibox-content">
                    <div class="form-group">
                        <div class="col-md-12" id="dvResultado">
                            <table style="font-size: large;" class="table table-condensed table-hover table-striped">
                                <thead>
                                    <tr>
                                        <th>Datos</th>
                                        <th>Informaci&oacute;n</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>N&uacute;mero de conteo</td>
                                        <td id="Vez"></td>
                                    </tr>                                    
                                    <tr>
                                        <td>LPN</td>
                                        <td id="LPN"></td>
                                    </tr>
							<% if(EsCiego == 0 ){ %>
                                    <tr>
                                        <td>Cantidad actual</td>
                                        <td class="CantidadActual"></td>
                                    </tr>
							<% } %>
                                    <tr>
                                        <td>SKU</td>
                                        <td id="SKU"></td>
                                    </tr>
                                    <tr>
                                        <td>Producto</td>
                                        <td id="Producto"></td>
                                    </tr>
                                    <tr>
                                        <td>Ubicaci&oacute;n</td>
                                        <td id="Ubication"></td>
                                    </tr>
<!--Se eliminó código comentado-->
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--Se eliminó código comentado-->

<input type="hidden" id="Pt_ID" value="-1">
<input type="hidden" id="CB" value="-1">

<input type="hidden"  id="AudU_ID1" value="0">
<input type="hidden"  id="AudU_ID2" value="0">


<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script type="application/javascript">


	$('.i-checks').iCheck({ radioClass: 'iradio_square-green' }); 
	
	$('.i-checks').on('ifChanged', function(event) {
		if(event.target.checked) {
			$('#ChooseAuditor').hide('slow',function(){
				$('#cboChooseAuditor').load("/pz/wms/Auditoria/Auditoria_Ajax.asp",{
					Aud_ID:$('#Aud_ID').val(),
					Aud_Externo:$(event.target).val(),
					Tarea:5
				},function(){
					$('#ChooseAuditor').show('slow');
				});
			});
		}
	});



	$('#dvResultadoAudi').hide()
	//$("#dvResultado").hide();
	var TipoAuditor = {}
	
	$(document).ready(function(){
		$('#PapeletaCB').focus()
	   // Cliente.ComboCargar();
	   // Producto.ComboCargar();
		Papeleta.CargaTipoAuditor();
	
		$("#UsuAud_ID").select2();
		$("#selProducto").select2();
		
		$("#Pt_ID").val(-1)
		$("#AudU_ID").val(-1)
	});
	
	$('#Cantidad').keydown(function(event) {
		if(event.which == 13){
			Papeleta.Guardar();
		}
	});


    var Papeleta = {
        AuditorEscogido:function(Audi){
			if(Audi.val() == -1){
				$('.i-checks').prop('disabled',false)
				$('#dvBuscador').hide('slow',function(){
					Avisa("error","Verifica el auditor","No se ha seleccionado a un auditor")
				});
			} else {
				$('#dvBuscador').hide('slow',function(){
					Avisa("success","Cambio de auditor","El cambio se ha realizado de manera correcta")
					$(this).show('slow',function(){
						$('#PapeletaCB').focus();
						$('.i-checks').prop('disabled',true)
					});
				});
			}
		},
        BuscarCB: function(e){
			if (e.keyCode == 13) {
				Papeleta.CargaPapeleta()
				//$('#dvResultado').html("")
				$('#PapeletaCB').val("")
			}  
        }
        
       ,CargaPapeleta: function(){
			//$("#dvResultado").hide('slow');
			var CodigoBarras = $("#PapeletaCB").val()
			var sTipo = "error";
			
			$("#Pt_ID").val(-1)
			$("#AudU_ID").val(-1)
			
			$("#Usu_ID").val(-1);
			$("#Cantidad").val("");
			$("#Comentario").val("");
            
            if(CodigoBarras.length < 1){
                Avisa("warning", "Error", "Escriba o escanee un codigo de barras");
            } else {
                    $.ajax({
						url: "/pz/wms/Auditoria/Auditoria_Ajax.asp"
						, method: "post"
						, cache: false
						, data: {  Tarea: 2
								 , Aud_ID: $("#Aud_ID").val()
								 , CB:CodigoBarras
								 , IDUsu_Auditor:$("#UsuAud_ID").val()
								 , ConteoExterno: $('input[name="gpo1"]:checked').val()						 
						}
						, success: function(data){
							 Respuesta = data
							  var response = JSON.parse(data)
		  						console.log(response)
							  if(response.result == 1){	
								 var arrInfo = response.data.InfoPallet
								 var arrAudi = response.data.DatoAudi
								 sTipo = "success";  
								 $("#Pt_ID").val(arrInfo.Pt_ID)
								 $("#AudU_ID").val(arrInfo.AudU_ID)
								 $("#Usu_ID").val(arrInfo.AsignadoA)
								 if(arrInfo.ConteoTotal > 0){
								 $("#Cantidad").val(arrInfo.ConteoTotal) 
								 }
								 $("#Comentario").val(arrInfo.Comentario)
                                 <% if(EsCiego == 0 ){ %>  
								 $('.CantidadActual').html(arrInfo.CantidadActual)
                                 <% } %>
								 if(arrAudi != null){
									 if(arrAudi[0] != null){
									 $("#AudU_ID1").val(arrAudi[0].AudU_ID)
									 }
									 if(arrAudi[1] != null){
									 $("#AudU_ID2").val(arrAudi[1].AudU_ID)
									 }
								 }
								 $("#CB").val(arrInfo.CB)
								 
								 
								 $('#LPN').html(arrInfo.Pt_LPN)
								 $('#Vez').html(arrInfo.Vez)
								 $('#SKU').html(arrInfo.Pro_SKU)
								 $('#Producto').html(arrInfo.Pro_Nombre)
								 $('#Etiq').html(arrInfo.Etiqueta)
								 $('#Ubication').html(arrInfo.Ubi_Nombre)
	
//                               var sResultado = "LPN: <strong>" + arrInfo.Pt_LPN+"</strong>" 
//                                             + "<br>Vez: <strong>" + arrInfo.Vez +"</strong>"
//                                             + "<br>SKU: <strong>" + arrInfo.Pro_SKU + " " + arrInfo.Pro_Nombre+"</strong>"
//                                             + "<br>Ubicacion: <strong>" + arrInfo.Ubi_Nombre +"</strong>"
//                                             + "<br>Etiqueta: <strong>" + arrInfo.Etiqueta +"</strong>"
//                                      
//                               $("#dvResultado").html(sResultado)
								$("#dvResultadoAudi").show('slow',function(){
									$("#Cantidad").focus();
								});
								$('#ResultInfo').html("")
								
								$('html, body').animate({ scrollTop: $('#Cantidad').offset().top }, 'slow');
							  } else{
								 $("#PapeletaCB").focus();
	
							  }
							  Avisa(sTipo,"Aviso",response.message);	
						 }
					}); 
            }
       }    
       ,Guardar: function(){
            var pCantidad = $("#Cantidad").val()
            $("#Cantidad").prop('disabled',true)
            var sTipo = "error";
            var AudUID = 1;
            var AE = 1;

            if( (pCantidad.length < 1) || (pCantidad = "")){
                Avisa("warning", "Error", "Debe escribir una cantidad");
            } else  {
                
                //valido si el auditor es externo
                AE = 1
                if(AE == 1) {
                    AudUID = $("#AudU_ID1").val()
                } else {
                    AudUID = $("#AudU_ID2").val() 
                }
                      $.ajax({
                            url: "/pz/wms/Auditoria/Auditoria_Ajax.asp"
                            , method: "post"
                            , async: true
                            , cache: false
                            , data: {  
								   Tarea: 3
								 , Aud_ID: $("#Aud_ID").val()
								 , Cantidad:$("#Cantidad").val()
								 , Comentario:$("#Comentario").val()
								 , Pt_ID:$("#Pt_ID").val()
								 , AudU_Veces:<%=Aud_VisitaActual%> 
								 , UsuAud_ID:$("#UsuAud_ID").val()
								 , Hallazgo:$("#Hallazgo").val()
								 , ConteoExterno: $('input[name="gpo1"]:checked').val()
								 , CB:$("#CB").val()
                            }
                            , success: function(data){   
								$("#Cantidad").prop('disabled',false)
								
								var response = JSON.parse(data);
								console.log(response)
								if(response.result == 1){
									sTipo = "success";  
								}
								Avisa(sTipo,"Aviso",response.message);	

								switch(parseInt(response.data.Conclusion.ResultadoAlert)){
									case -1: //Faltante
										sTipo = "danger"
									break;
									case 0: // Coincidencia exacta
										sTipo = "success"
									break;
									case 1: // Sobrante
										sTipo = "warning"
									break;
								}
								
								var alerta = '<div class="col-md-8 col-md-offset-1 alert alert-'+sTipo+'">'+
											   '<h3><i class="fa fa-info-circle"></i>&nbsp;&nbsp;'+response.data.Conclusion.Resultado+'</h3>'+
											 '</div>'
								
								$('#ResultInfo').html(alerta)
								
								$('#PapeletaCB').focus();
								$('#PapeletaCB').val("");
								$("#Cantidad").val("");
								CargaGraficos()
                            }
                        }); 
            }
       } ,
	   CargaTipoAuditor:function(){
		  $.ajax({
				url: "/pz/wms/Auditoria/Auditoria_Ajax.asp"
				, method: "post"
				, async: true
				, cache: false
				, data: {  Tarea: 4
						 , Aud_ID: $("#Aud_ID").val()
				}
				, success: function(data){
					var response = JSON.parse(data)
					  if(response.result == 1){
						 TipoAuditor = response
						 sTipo = "success";  
					  }else{
						 sTipo = "error";  
						  console.log(data)
					  }
					  //Avisa(sTipo,"Aviso",response.message);	
				}
			}); 
	   }
        
    };

</script>


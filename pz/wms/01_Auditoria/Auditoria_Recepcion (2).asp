<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
	var Aud_ID = Parametro("Aud_ID",1)

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
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">




					<div class="row">
                    	<div class="col-md-12">
                        	<div class="ibox float-e-margins">
                                <legend class="col-sm-12"><h4>Buscar papeleta por c&oacute;digo de barras</h4></legend>
                                <div class="form-horizontal">
                                
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">N&uacute;mero de papeleta:</label>
                                        <div class="col-sm-4">
                                        		<input type="text" class="form-control" id="PapeletaCB" onkeypress="Papeleta.BuscarCB(event);" autocomplete="off" placeholder="CB">
                                        </div>
                                        <div class="col-sm-2">
                                            <a class="btn btn-success btn-sm" id="btnBuscar" onClick="Papeleta.CargaPapeleta();">
                                                <i class="fa fa-search"></i> Buscar
                                            </a>
                                        </div>
                                    </div>
                                    
                                    
                                    <div class="ibox-title">
                                        <h5>Resultado</h5>
                                        <div class="ibox-tools">
                                            <a class="btn btn-success btn-sm" id="btnGuardar" onClick="Papeleta.Guardar();"><i class="fa fa-save"></i> Guardar</a>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Auditor:</label>
                                        <div class="col-sm-4">
                                        <%  var sEventos = " class='form-control cbo' "
                                            var sCondicion = " u.Usu_ID = a.Usu_ID and a.Aud_ID = " + Aud_ID
                                            CargaCombo("Usu_ID",sEventos,"u.Usu_ID","u.Usu_Nombre","Usuario u , Auditorias_Auditores a",sCondicion,"u.Usu_Nombre",-1,0,"Seleccione un auditor")
                                        %>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Cantidad:</label>
                                        <div class="col-sm-4">
                                            <input type="text" id="Cantidad" autocomplete="off" placeholder="Conteo" class="form-control" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Comentario:</label>
                                        <div class="col-sm-10 m-b-xs">
                                            <input type="text" id="Comentario" class="form-control"  utocomplete="off">
                                        </div>
                                    </div>
                                    <div class="ibox-content">
                                        <div class="form-group">
                                            <div class="col-sm-12" id="dvResultado">
                                            	<table style="font-size: large;" class="table table-condensed table-hover table-striped">
                                                	<thead>
                                                		<tr>
                                                        	<th>Datos</th>
                                                        	<th>Informaci&oacute;n</th>
                                                        </tr>
                                                	</thead>
                                                    <tbody>
                                                    	<tr>
                                                    		<td>LPN</td>
                                                    		<td id="LPN"></td>
                                                    	</tr>
                                                    	<tr>
                                                    		<td>Vez</td>
                                                    		<td id="Vez"></td>
                                                    	</tr>
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
<!--                                                    	<tr>
                                                    		<td>Etiqueta</td>
                                                    		<td id="Etiq"></td>
                                                    	</tr>
-->                                                    </tbody>
                                                </table>
                                                 
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                            



<%/*%> 

                    <div class="ibox-title">
                        <strong>Nota*: Una vez puesta la cantidad, ya no se puede cambiar, por lo que ser&aacute; necesario generar una nueva papaeleta.</strong>
                    </div> 
                    <div class="ibox-title">
                        <h5>Buscar papeleta por c&oacute;digo de barras</h5>
                    </div> 
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-md-12">        
                                <label class="col-md-3 control-label">N&uacute;mero de papeleta:</label>
                                <div class="col-md-4">
                                    <input type="text" class="form-control" id="PapeletaCB" onkeypress="Papeleta.BuscarCB(event);" autocomplete="off" placeholder="CB">
                                </div>
                                <div class="col-md-2">
                                    <a class="btn btn-success btn-sm" id="btnBuscar" onClick="Papeleta.CargaPapeleta();">
                                        <i class="fa fa-search"></i> Buscar
                                    </a>
                                </div>
                                <label class="col-md-2 control-label" id="lblExiste"></label>
                            </div>
                        </div> 
                    </div>
                    
                    
                    
                   
                    
                    <div class="row"> 
                        <div class="col-md-12">        
                            <div class="ibox-title">
                                <h5>Resultado</h5>
                                <div class="ibox-tools">
                                    <a class="btn btn-success btn-sm" id="btnGuardar" onClick="Papeleta.Guardar();"><i class="fa fa-save"></i> Guardar</a>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-md-12">        
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Auditor:</label>
                                        <div class="col-sm-4">
                                        <%  var sEventos = " class='form-control cbo' "
                                            var sCondicion = " u.Usu_ID = a.Usu_ID and a.Aud_ID = " + Aud_ID
                                            CargaCombo("Usu_ID",sEventos,"u.Usu_ID","u.Usu_Nombre","Usuario u , Auditorias_Auditores a",sCondicion,"u.Usu_Nombre",-1,0,"Seleccione un auditor")
                                        %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Cantidad:</label>
                                        <div class="col-sm-4">
                                            <input type="text" id="Cantidad" autocomplete="off" placeholder="Conteo" class="form-control" />
                                        </div>
                                    </div>
                        </div>
                    </div>
                            
                        <div class="row"> 

<                            <label class="col-sm-2 control-label">Tipo de hallazgo:</label>
                            <div class="col-sm-4 m-b-xs">
<%
       var sEventos = " class='form-control cbo' "  
       ComboSeccion("Hallazgo",sEventos,144,1,0,"Seleccione","","Editar")
   
%>
                            </div>

                        </div>
  
                            
                        <div class="row">
                            <label class="col-sm-2 control-label">Comentario:</label>
                            <div class="col-sm-10 m-b-xs">
                                <input type="text" id="Comentario" class="form-control"  utocomplete="off">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 m-b-xs" id="dvResultado">
                            </div>
                        </div>   
<%*/%>
                    </div>
                </div>

<input type="hidden" id="Pt_ID" value="-1">
<!--<input type="hidden" id="AudU_ID" value="-1">
-->
<input type="hidden"  id="AudU_ID1" value="0">
<input type="hidden"  id="AudU_ID2" value="0">
<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script type="application/javascript">

	//$("#dvResultado").hide();
	var TipoAuditor = {}
	
	$(document).ready(function(){
		$('#PapeletaCB').focus()
	   // Cliente.ComboCargar();
	   // Producto.ComboCargar();
		Papeleta.CargaTipoAuditor();
	
		$("#Usu_ID").select2();
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
						, async: true
						, cache: false
						, data: {  Tarea: 2
								 , Aud_ID: $("#Aud_ID").val()
								 , CB:CodigoBarras
						}
						, success: function(data){
							 Respuesta = data
							  var response = JSON.parse(data)
		  
							  if(response.result == 1){
								 $("#Cantidad").focus();
	
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
								 
								 if(arrAudi != null){
									 if(arrAudi[0] != null){
									 $("#AudU_ID1").val(arrAudi[0].AudU_ID)
									 }
									 if(arrAudi[1] != null){
									 $("#AudU_ID2").val(arrAudi[1].AudU_ID)
									 }
								 }
								 
								 
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
								//$("#dvResultado").show('slow');
								$('html, body').animate({ scrollTop: $('#dvResultado').offset().top }, 'slow');
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
                            , data: {  Tarea: 3
                                     , Aud_ID: $("#Aud_ID").val()
                                     , Cantidad:$("#Cantidad").val()
                                     , Comentario:$("#Comentario").val()
                                     , Pt_ID:$("#Pt_ID").val()
                                     , AudU_ID:AudUID
                                     , Usu_ID:$("#Usu_ID").val()
                                     , Hallazgo:$("#Hallazgo").val()
                            }
                            , success: function(data){   
                                  var response = JSON.parse(data)
                                  if(response.result == 1){
                                     sTipo = "success";  
                                  } 
								  $('#PapeletaCB').focus();
                                  Avisa(sTipo,"Aviso",response.message);	
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


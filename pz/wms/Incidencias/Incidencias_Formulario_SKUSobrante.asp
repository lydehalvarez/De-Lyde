<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var Ins_Proveedor = Parametro("Ins_Proveedor", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
 	var Procedencia = Parametro("Procedencia", "")
	var Ins_ID = Parametro("Ins_ID", -1)
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
				
				if(Ins_ID >-1){
					sSQL = "SELECT * FROM Incidencia WHERE Ins_ID = " + Ins_ID	
					var rsIncidencias = AbreTabla(sSQL,1,0)
					var Ins_Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var InsO_ID =  rsIncidencias.Fields.Item("InsO_ID").Value
					var TA_ID =  rsIncidencias.Fields.Item("TA_ID").Value
					var Recibe = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
		
					sSQL = "SELECT s.*, p.Pro_SKU FROM Incidencia_SKU s LEFT JOIN Producto p ON s.Pro_ID=p.Pro_ID"
				  	+ " WHERE s.Ins_ID=" + Ins_ID + " AND s.TA_ID="+TA_ID
					var rsSKUsel =  AbreTabla(sSQL,1,0)
		Response.Write(sSQL)
            	}

				if(TA_ID >-1){
					sSQL = "SELECT TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = " + TA_ID	
					var rsTA = AbreTabla(sSQL,1,0)
					
				var	TA_Folio = rsTA.Fields.Item("TA_Folio").Value
		
            	}
	sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica     WHERE i.InsO_ID = 2 GROUP BY IDUnica, Usu_Nombre "
							+"UNION "
							+"SELECT IDUnica, Emp_Nombre + ' ' + Emp_ApellidoPaterno AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica    WHERE i.InsO_ID = 2  GROUP BY IDUnica, Emp_Nombre, Emp_ApellidoPaterno"
					   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
 								<div class="form-group" style="display:block; " id="divUsuariosA">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-9 m-b-xs">
                                        <select id="selAsignar" class="form-control selAsignar">
                                            <option value="-1">
                                            <%= "Selecciona" %>
                                            </option>
                                            <%
                                            while( !(rsAsignados.EOF)){
                                            %>
                                            <option value="<%= rsAsignados("IDUnica").Value %>">
                                            <%= rsAsignados("Nombre").Value %>
                                            </option>
                                            <%
                                            rsAsignados.MoveNext()
                                            }
                                            rsAsignados.Close()
                                        
                                            %>

                                        </select>
                                        </div>
                                        </div>
             
 								                  
          
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                      <div class="form-group">
                         <label class="control-label col-md-3"><strong>Descripci&oacute;n</strong></label>
                       <div class="col-md-9">
                          <textarea class="form-control Descripcion" placeholder=""></textarea>
                       </div>
                </div>
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>

                      <div class="form-group" >
                         <label class="control-label col-md-3"><strong>Serie</strong></label>
                       <div class="col-md-3">
                           <input class="form-control SKU1" placeholder="" onkeydown="FunctionInsert.BuscaSKU1(event)"> </input>
                <button type="button" class="btn btn-primary btnSKU" onclick="FunctionInsert.InsertSKU()">+ Agregar serie</button>
					
                       </div> 
                       <div class="col-md-6" id="divModeloSKU1">
							Escribe y presiona enter
						</div>
					</div>

   					<div class="form-group" id="divSKU2e"  style="display:none; ">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                      <div class="form-group" id="divSKU2"  style="display:none; ">
                         <label class="control-label col-md-3"><strong>Serie</strong></label>
                       <div class="col-md-3">
                           <input class="form-control SKU2" placeholder="" onkeydown="FunctionInsert.BuscaSKU2(event)"></input>
							<button type="button" class="btn btn-primary btnSKU2" onclick="FunctionInsert.InsertSKU2()">+ Agregar serie</button>

                       </div> 
                       <div class="col-md-6" id="divModeloSKU2">
							Escribe y presiona enter
						</div>
					</div>

   					<div class="form-group" id="divSKU3e"  style="display:none; ">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                     <div class="form-group" id="divSKU3"  style="display:none; ">
                         <label class="control-label col-md-3"><strong>Serie</strong></label>
                       <div class="col-md-3">
                           <input class="form-control SKU3" placeholder="" onkeydown="FunctionInsert.BuscaSKU3(event)"></input>
							<button type="button" class="btn btn-primary btnSKU3" onclick="FunctionInsert.InsertSKU3()">+ Agregar serie</button>

                       </div> 
				         <div class="col-md-6" id="divModeloSKU3">
							Escribe y presiona enter
						</div>
					</div>

   					<div class="form-group" id="divSKU4e"  style="display:none; ">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                      <div class="form-group" id="divSKU4"  style="display:none; ">
                         <label class="control-label col-md-3"><strong>Serie</strong></label>
                       <div class="col-md-3">
                           <input class="form-control SKU4" placeholder="" onkeydown="FunctionInsert.BuscaSKU4(event)"></input>
							<button type="button" class="btn btn-primary btnSKU4" onclick="FunctionInsert.InsertSKU4()">+ Agregar serie</button>

                       </div> 
                       <div class="col-md-6" id="divModeloSKU4">
							Escribe y presiona enter
						</div>
					</div>
					<div class="form-group" id="divSKU5e"  style="display:none; ">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                      <div class="form-group" id="divSKU5"  style="display:none; ">
                         <label class="control-label col-md-3"><strong>Serie</strong></label>
                       <div class="col-md-3">
                           <input class="form-control SKU5" placeholder="" onkeydown="FunctionInsert.BuscaSKU5(event)"></input>

                       </div> 
                       <div class="col-md-6" id="divModeloSKU5">
							Escribe y presiona enter
						</div>
					</div>
					<div class="form-group" id="divSKU5">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>

	

                      <div class="form-group">

						<label class="control-label col-md-3"><strong>Folio de transferencia</strong></label>
                       <div class="col-md-3">
                           <input class="form-control TA_Folio" value = "" placeholder=""></input>
                       </div>
                </div>
        
               
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
				 <div class="form-group">
					 <div class="col-md-12">
                <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                <button type="button" class="btn btn-primary btnGuardaSKUFal" onclick="FunctionInsert.InsertDatos()">Guardar</button>
				<button type="button" class="btn btn-primary btnActualizaSKUF" style = "display:none;" onclick="FunctionInsert.ActualizaDatos()">Actualizar</button>
					</div>
				</div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                     <div class="form-group" id="divValidaCampos">
                     </div>


<script type="application/javascript">

   $(document).ready(function(){
	 <%
		if(Ins_ID>-1){
	%>
			$('#cboInsO_ID').val(<%=InsO_ID%>)
			$('.TA_Folio').val('<%=TA_Folio%>')
			$('.Descripcion').val('<%=Ins_Descripcion%>')
			$('.selAsignar').val(<%=Recibe%>)
			$('.btnGuardaSKUFal').hide()
			$('.btnActualizaSKUF').show()
			<%
			
				var	i = 1
				while(!(rsSKUsel.EOF)){
%>
				$("#divSKU<%=i%>e").css('display','block')
				$("#divSKU<%=i%>").css('display','block')
				$('.SKU<%=i%>').val(<%=rsSKUsel.Fields.Item("Pro_SKU").Value%>)
<%
				i = i + 1
				rsSKUsel.MoveNext()
				}
				rsSKUsel.Close()
			  }
%>
	
	//	$("#divUsuariosA").hide()

	   var ventana = $("#VentanaIndex").val() 
		if(ventana==2529||ventana==603){
		$('.TA_Folio').val('<%=TA_Folio%>')
		$('.TA_Folio').prop( "disabled", true);
		}
		
	 $('.btnCerrar').click(function(e) {
	  	$("#mdlIncidencias").modal('hide').remove();
	  });
   });
	

   			var FunctionInsert = {
			InsertDatos:function(){
				var Folio = $('.TA_Folio').val()
				var Descripcion = $('.Descripcion').val()
				var Asignar = $('#selAsignar').val()
				var SKU1 = $("#SKU1").val()
			if(SKU1 != '' && Folio != '' && Descripcion != '' && Asignar !=-1){
				$('#divValidaCampos').hide()
				var InsT_ID = $('.InsT_IDPadre').val()
		
					var Titulo = "SKU sobrante" 
			
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	  data: { 
	 						SKUSob:1,
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
		  				   Ins_Titulo: Titulo,
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
		   				   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
		  				   SKU1:$(".SKU1").val(),
   		  				   SKU2:$(".SKU2").val(),
		  				   SKU3:$(".SKU3").val(),
		  				   SKU4:$(".SKU4").val(),
		  				   SKU5:$(".SKU5").val(),
		  					Tarea:21
	 },
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
		var resp = JSON.parse(data)
		console.log("resp:"+resp)
		if(resp.result==1){
			var Tipo = "success"
			var sMensaje = "El registro se ha guardado correctamente "
		
				Avisa(Tipo,"Aviso",sMensaje);
				   $("#divPadre").show()
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
  	    }if(resp.result==0){
		$('#divValidaCampos').show()
		$('#divValidaCampos').html("<font color='#FF0000'>* El folio no existe</font>")
		}
		if(resp.result==2){
		$('#divValidaCampos').show()
		$('#divValidaCampos').html("<font color='#FF0000'>* Los SKU indicados no existen</font>")
		}
	}
		});	
		}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, SKU, descripci&oacute;n y folio son requeridos</font>")	
		}
			},
					ActualizaDatos:function(){
				var Folio = $('.TA_Folio').val()
				var Tienda= $('.Tienda').val()
				var Descripcion = $('.Descripcion').val()
			   	 <%
					 if(Ins_Proveedor>-1){
		  		%>
				var Asignar = $('#selAsignarProv').val()
			<% 
			 }else{
			 	%>
				var Asignar = $('.selAsignar').val()
				<% 
	 		}
	 	%>
			if(Folio != ''  && Descripcion != '' && Asignar !=-1){
				$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
   		   				   SKUSob:1,
	 					   Ins_ID:<%=Ins_ID%>,
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
		   					Ins_Usu_Recibe:Asignar,
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
		   				   SKU1:$(".SKU1").val(),
   		  				   SKU2:$(".SKU2").val(),
		  				   SKU3:$(".SKU3").val(),
		  				   SKU4:$(".SKU4").val(),
		  				   SKU5:$(".SKU5").val(),
		   					//  Prov_ID: $('#cboProv').val(),
						   Tarea:26
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
		var resp = JSON.parse(data)
		console.log("resp:"+resp)
		if(resp==1){
			var Tipo = "success"
			var sMensaje = "El registro se ha actualizado correctamente "
		
				Avisa(Tipo,"Aviso",sMensaje);
				   $("#divPadre").show()
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
  	    }else{
		$('#divValidaCampos').show()
		$('#divValidaCampos').html("<font color='#FF0000'>* El folio no pertenece a la tienda</font>")
		}
	}
		});	
		}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, t&iacute;tulo, asunto, descripci&oacute;n y folio son requeridos</font>")	
		}
					
				},
				InsertSKU:function(){
					$("#divSKU2e").css('display','block')
					$("#divSKU2").css('display','block')
					$(".btnSKU").hide()
				},
				InsertSKU2:function(){
							$("#divSKU3e").css('display','block')
							$("#divSKU3").css('display','block')
							$(".btnSKU2").hide()
				},
				InsertSKU3:function(){
							$("#divSKU4e").css('display','block')
							$("#divSKU4").css('display','block')
							$(".btnSKU3").hide()
				},
				InsertSKU4:function(){
							$("#divSKU5e").css('display','block')
							$("#divSKU5").css('display','block')
							$(".btnSKU4").hide()
				},
	BuscaSKU1: function(event){
 	var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 22
		 sDatos += "&SKU1=" + $(".SKU1").val()

		$("#divModeloSKU1").load("/pz/wms/Incidencias/Incidencias_Ajax.asp?" + sDatos)

		}
	},
			BuscaSKU2:function(event){
 	var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 22
		 sDatos += "&SKU1=" + $(".SKU2").val()

		$("#divModeloSKU2").load("/pz/wms/Incidencias/Incidencias_Ajax.asp?" + sDatos)

		}
	},
		 	BuscaSKU3:function(event){
 	var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 22
		 sDatos += "&SKU1=" + $(".SKU3").val()

		$("#divModeloSKU3").load("/pz/wms/Incidencias/Incidencias_Ajax.asp?" + sDatos)

		}
	},
		BuscaSKU4:function(event){
 		var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 22
		 sDatos += "&SKU1=" + $(".SKU4").val()

		$("#divModeloSKU4").load("/pz/wms/Incidencias/Incidencias_Ajax.asp?" + sDatos)

		}
	},
		BuscaSKU5:function(event){
 	var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 22
		 sDatos += "&SKU1=" + $(".SKU5").val()

		$("#divModeloSKU5").load("/pz/wms/Incidencias/Incidencias_Ajax.asp?" + sDatos)

		}
	}
		}
				
</script>
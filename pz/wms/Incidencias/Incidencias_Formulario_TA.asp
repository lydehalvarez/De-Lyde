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
					var Ins_Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Ins_Asunto= rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Ins_Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var Ins_Problema= rsIncidencias.Fields.Item("Ins_Problema").Value
					var Ins_Causa= rsIncidencias.Fields.Item("Ins_Causa").Value
					var InsO_ID =  rsIncidencias.Fields.Item("InsO_ID").Value
					var TA_ID =  rsIncidencias.Fields.Item("TA_ID").Value
					var Recibe = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
					var FechaAviso = rsIncidencias.Fields.Item("Ins_FechaAvisoCosto").Value
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
                                        <%
                             sSQL = "SELECT Prov_Nombre, Prov_ID FROM Proveedor"
					   	    var rsProveedor = AbreTabla(sSQL,1,0)
%>
 								<div class="form-group"   style="display:none;" id="divProveedores">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-9 m-b-xs">
                                        <select id="selAsignarProv" class="form-control">
                                            <option value="-1">
                                            <%= "Selecciona" %>
                                            </option>
                                            <%
                                            while(!(rsProveedor.EOF)){
                                            %>
                                            <option value="<%= rsProveedor("Prov_ID").Value %>">
                                            <%= rsProveedor("Prov_Nombre").Value %>
                                            </option>
                                            <%
                                            rsProveedor.MoveNext()
                                            }
                                            rsProveedor.Close()
                                        
                                            %>

                                        </select>

                                     </div>
                                </div>                  
                    <label class="control-label col-md-3"><strong>Titulo</strong></label>
                       <div class="col-md-9">
                           <input class="form-control Titulo" placeholder=""></input>
                       </div>
                    </div>
                      <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                    <div class="form-group">
                         <label class="control-label col-md-3"><strong>Asunto</strong></label>
                       <div class="col-md-9">
                           <input class="form-control Asunto" placeholder=""></input>
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
                      <div class="form-group">
                         <label class="control-label col-md-3"><strong>Problema</strong></label>
                       <div class="col-md-9">
                           <input class="form-control Problema" placeholder=""></input>
                       </div>
                </div>
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                <div class="form-group">
                    <label class="control-label col-md-3"><strong>Causa</strong></label>
                       <div class="col-md-9">
		                  <input class="form-control Causa" placeholder=""></input>
                      </div>
                      </div>
                       <div class="form-group">
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
                       <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                <button type="button" class="btn btn-primary btnFor18" onclick="FunctionInsert.InsertDatos()">Guardar</button>
				  <button type="button" class="btn btn-primary btnActualiza" style = "display:none;" onclick="FunctionInsert.ActualizaDatos()">Actualizar</button>

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
			$('.Titulo').val('<%=Ins_Titulo%>')
			$('.Asunto').val('<%=Ins_Asunto%>')
			$('.Descripcion').val('<%=Ins_Descripcion%>')
			$('.Causa').val('<%=Ins_Causa%>')
			$('.Problema').val('<%=Ins_Problema%>')
			$('.selAsignar').val(<%=Recibe%>)
			$('.btnFor18').hide()
			$('.btnActualiza').show()
		<%
		}
	 if(Ins_Proveedor>-1){
		%>
		$("#divProveedores").css('display','block')
		$("#divUsuariosA").hide()
		<% 
	 }
	 	%>

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
				var Titulo=$('.Titulo').val()
				var 	Asunto= $('.Asunto').val()
				var Descripcion = $('.Descripcion').val()
			   	 <%
					 if(Ins_Proveedor>-1){
		  		%>
				var Asignar = $('#selAsignarProv').val()
			<% 
			 }else{
			 	%>
				var Asignar = $('#selAsignar').val()
				<% 
	 		}
	 	%>
			if(Folio != '' && Titulo != '' && Asunto!= '' && Descripcion != '' && Asignar !=-1){
				$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	 
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
	   					   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Titulo: encodeURIComponent($('.Titulo').val()),
						   Ins_Asunto: encodeURIComponent($('.Asunto').val()),
						   Ins_Problema: encodeURIComponent($('.Problema').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Causa:encodeURIComponent($('.Causa').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
   						   Prov_ID: $('#selAsignarProv').val(),
						   Tarea:4
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
		var resp = JSON.parse(data)
		console.log("resp:"+resp)
		if(resp==1){
			var Tipo = "success"
			var sMensaje = "El registro se ha guardado correctamente "
		
				Avisa(Tipo,"Aviso",sMensaje);
				   $("#divPadre").show()
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
  	    }else{
		$('#divValidaCampos').show()
		$('#divValidaCampos').html("<font color='#FF0000'>* El folio no existe</font>")
		}
	}
		});	
		}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, t&iacute;tulo, asunto, descripci&oacute;n y folio son requeridos</font>")	
		}
			}, 
					ActualizaDatos:function(){
				var Folio = $('.TA_Folio').val()
				var FechaAviso= $('#FechaAviso').val()
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
			if(Folio != '' && FechaAviso != "" && Descripcion != '' && Asignar !=-1){
				$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	 					   Ins_ID:<%=Ins_ID%>,
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
		   					Ins_Usu_Recibe:Asignar,
						   Ins_Asunto:encodeURIComponent($('.Asunto').val()),
						   Ins_Titulo:encodeURIComponent($('.Titulo').val()),
						   Ins_Causa:encodeURIComponent($('.Causa').val()),
						   Ins_Problema:encodeURIComponent($('.Problema').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
		   					Ins_Usu_Reporta: $('#IDUsuario').val(),
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
		$('#divValidaCampos').html("<font color='#FF0000'>* Error al guardar! Acudir con el area de sistemas</font>")
		}
	}
		});	
		}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, descripci&oacute;n, fecha y folio son requeridos</font>")	
		}
					
				}			
			
		}
</script>
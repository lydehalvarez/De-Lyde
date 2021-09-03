<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OV_ID = Parametro("OV_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var Ins_Proveedor  = Parametro("Ins_Proveedor", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
 	var Procedencia = Parametro("Procedencia", "")
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
		
					sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica  GROUP BY IDUnica, Usu_Nombre " //    WHERE i.InsO_ID = 8
							+"UNION "
							+"SELECT IDUnica, Emp_Nombre + ' ' + Emp_ApellidoPaterno AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica   GROUP BY IDUnica, Emp_Nombre, Emp_ApellidoPaterno"
					   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
 								<div class="form-group" id="divUsuariosA">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-9 m-b-xs">
                                        <select id="selAsignar" class="form-control">
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
                    <label class="control-label col-md-3"><strong>Ventana</strong></label>
                       <div class="col-md-9">
		                  <input class="form-control Ventana" placeholder=""></input>
                      </div>
                      </div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                    <div class="form-group">
                    <label class="control-label col-md-3"><strong>Mensaje de Error</strong></label>
                       <div class="col-md-9">
		                  <input class="form-control Error" placeholder=""></input>
                      </div>
                      </div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                    <div class="form-group">
                    <label class="control-label col-md-3"><strong>Acci&oacute;n realizada</strong></label>
                       <div class="col-md-9">
		                  <textarea class="form-control Accion" placeholder=""></textarea>
                      </div>
                      </div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                       <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                <button type="button" class="btn btn-primary btnFor19" onclick="FunctionInsert.InsertDatos()">Guardar</button>
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
	 if(Ins_Proveedor>-1){
		%>
		$("#divProveedores").css('display','block')
		$("#divUsuariosA").hide('slow')
		<% 
	 }
	 	%>
		
	 $('.btnCerrar').click(function(e) {
	  	$("#mdlIncidencias").modal('hide').remove();
	  });
   });
   			var FunctionInsert = {
			InsertDatos:function(){
			var Causa=$('.Causa').val()
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
			if(Asunto!= '' && Descripcion != '' && Asignar != -1){
			$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
	   					   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Asunto: encodeURIComponent($('.Asunto').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_MensajeError:encodeURIComponent($('.Error').val()),
						   Ins_Ventana:encodeURIComponent($('.Ventana').val()),
						   Ins_Accion:encodeURIComponent($('.Accion').val()),

						   Ins_Usu_Reporta: $('#IDUsuario').val(),
						   Prov_ID: $('#selAsignarProv').val(),
						   Tarea:4
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
			var Tipo = "success"
			var sMensaje = "El registro se ha guardado correctamente "
			var Tipo = "success"
			var sMensaje = "El registro se ha guardado correctamente "
		
				Avisa(Tipo,"Aviso",sMensaje);
     			   $("#divPadre").show()
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
				}
		});	
			}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, asunto y descripci&oacute;n son requeridos</font>")	
			}
		}
			
		}
</script>
<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var OV_ID = Parametro("OV_ID",-1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
 	var Procedencia = Parametro("Procedencia", "")
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
		
		if(OV_ID >-1){
					sSQL = "SELECT OV_Folio FROM Orden_Venta WHERE OV_ID = " + OV_ID	
					var rsOV = AbreTabla(sSQL,1,0)
					
				var	OV_Folio = rsOV.Fields.Item("OV_Folio").Value
		
            	}
	sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica     WHERE i.InsO_ID = 3 GROUP BY IDUnica, Usu_Nombre "
							+"UNION "
							+"SELECT IDUnica, Emp_Nombre + ' ' + Emp_ApellidoPaterno AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica    WHERE i.InsO_ID = 3  GROUP BY IDUnica, Emp_Nombre, Emp_ApellidoPaterno"
					   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
 								<div class="form-group">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-9 m-b-xs">
                                        <select id="selAsignar" class="form-control">
                                            <option value="Selecciona">
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
                         <label class="control-label col-md-3"><strong>Folio de orden de venta</strong></label>
                       <div class="col-md-4">
                           <input class="form-control OV_Folio" placeholder=""></input>
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
	   $('#divValidaCampos').hide()
			 var ventana = $("#VentanaIndex").val() 
		if(ventana==303){
		$('.OV_Folio').val('<%=OV_Folio%>')
		$('.OV_Folio').prop( "disabled", true);
		}
	 $('.btnCerrar').click(function(e) {
	  	$("#mdlIncidencias").modal('hide').remove();
	  });
   });
   			var FunctionInsert = {
			InsertDatos:function(){
				var Folio = $('.OV_Folio').val()
				var Titulo=$('.Titulo').val()
				var 	Asunto= $('.Asunto').val()
				var Descripcion = $('.Descripcion').val()
				var Asignar = $('#selAsignar').val()
			if(Folio != '' && Titulo != '' && Asunto!= '' && Descripcion != '' && Asignar != "Selecciona"){
				$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   OV_ID:<%=OV_ID%>,
   						   OV_Folio:$('.OV_Folio').val(),
	   					   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Titulo: encodeURIComponent($('.Titulo').val()),
						   Ins_Asunto: encodeURIComponent($('.Asunto').val()),
					//	   Ins_Problema: encodeURIComponent($('.Problema').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
					//   Ins_Causa:encodeURIComponent($('.Causa').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
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
			}
			
		}
</script>
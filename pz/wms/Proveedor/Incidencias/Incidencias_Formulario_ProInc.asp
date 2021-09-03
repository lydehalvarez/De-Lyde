<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OV_ID = Parametro("OV_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
 	var Procedencia = Parametro("Procedencia", "")
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
		
					sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica  GROUP BY IDUnica, Usu_Nombre " //    WHERE i.InsO_ID = 8
							+"UNION "
							+"SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica  GROUP BY IDUnica, Emp_Nombre" //  WHERE i.InsO_ID = 8 
					   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
 								<div class="form-group">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-9 m-b-xs">
                                    <%
										var sCondicion = "Gru_SectorCG60 =3"
										CargaCombo("Gru_ID","class='form-control'","Gru_ID","Gru_Nombre","SeguridadGrupo",sCondicion,"","Editar",0,"--Seleccionar--")
                                     %>
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
     <%
		             Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)
	%>

<script type="application/javascript">

   $(document).ready(function(){
	
		
	 $('.btnCerrar').click(function(e) {
	  	$("#mdlIncidencias").modal('hide').remove();
	  });
   });
   			var FunctionInsert = {
			InsertDatos:function(){
			var Causa=$('.Causa').val()
			var 	Asunto= $('.Asunto').val()
			var Descripcion = $('.Descripcion').val()
			var Asignar = $('#selAsignar').val()
			if(Asunto!= '' && Descripcion != '' && Asignar != "Selecciona"){
			$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Proveedor/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
	   					   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Asunto: encodeURIComponent($('.Asunto').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Causa:encodeURIComponent($('.Causa').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
						   Prov_ID:$('#Prov_ID').val(),
						   Tarea:4
		},

    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
			var Tipo = "success"
			var sMensaje = "El registro se ha guardado correctamente "
				Avisa(Tipo,"Aviso",sMensaje);
					Guardar()
     			   $("#divPadre").show()
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Proveedor/Incidencias/CTL_Incidencias.asp" + Params)
				}
		});	
			}else{
				$('#divValidaCampos').show()
				$('#divValidaCampos').html("<font color='#FF0000'>* Los campos asignar a, asunto y descripci&oacute;n son requeridos</font>")	
			}
		}
			
		}
			    function Guardar(){

		$.post("/pz/wms/Proveedor/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:<%=Ins_ID%>,
		Ins_TipoInvolucradoCG26:4,
		Ins_GrupoID: $('#Gru_ID').val(),
		Tarea:14
		},
		function(data){
});
				}

</script>
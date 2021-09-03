<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
 	var Procedencia = Parametro("Procedencia", "")
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
				
				if(TA_ID >-1){
					sSQL = "SELECT TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = " + TA_ID	
					var rsTA = AbreTabla(sSQL,1,0)
					
				var	TA_Folio = rsTA.Fields.Item("TA_Folio").Value
		
            	}
//	sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
//							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica     WHERE i.InsO_ID = 2 GROUP BY IDUnica, Usu_Nombre "
//							+"UNION "
//							+"SELECT IDUnica, Emp_NombreCompleto  AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
//							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica    WHERE i.InsO_ID = 2 GROUP BY IDUnica, Emp_NombreCompleto"
//					   	    rsAsignados = AbreTabla(sSQL,1,0)
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
					</div>
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
				var Asignar = $('#selAsignar').val()
			if(Folio != '' && Titulo != '' && Asunto!= '' && Descripcion != '' && Asignar != "Selecciona"){
				$('#divValidaCampos').hide()
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Proveedor/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	 
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
						   Ins_Titulo: encodeURIComponent($('.Titulo').val()),
						   Ins_Asunto: encodeURIComponent($('.Asunto').val()),
						   Ins_Problema: encodeURIComponent($('.Problema').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Causa:encodeURIComponent($('.Causa').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
						   Prov_ID:$('#Prov_ID').val(),
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
				Guardar()
				   $("#divPadre").show()
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Proveedor/Incidencias/CTL_Incidencias.asp" + Params)
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
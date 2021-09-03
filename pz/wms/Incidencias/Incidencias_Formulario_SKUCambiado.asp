<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

/* HA ID: 2		2021-AGO-10 Siniestro y Aviso de Devolucion, Productos: Agregado de Evento de Carga de Productos y selección de Artículos 
*/

	var Tarea = Parametro("Tarea",-1)  
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var Ins_Proveedor = Parametro("Ins_Proveedor", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
	var InsT_ID = Parametro("InsT_ID", -1)
	var Ins_ID = Parametro("Ins_ID", -1)
	var Procedencia = Parametro("Procedencia", "")
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
				
				if(Ins_ID >-1){
					sSQL = "SELECT * FROM Incidencia WHERE Ins_ID = " + Ins_ID	
					var rsIncidencias = AbreTabla(sSQL,1,0)
					var Ins_Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var InsO_ID =  rsIncidencias.Fields.Item("InsO_ID").Value
					var TA_ID =  rsIncidencias.Fields.Item("TA_ID").Value
					var Recibe = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
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
        
            			<label class="control-label col-md-3"><strong>Folio de transferencia</strong></label>
                       <div class="col-md-9">
					   		<% /* HA ID: 2 se agrega identificador a input y se quita evento keydown */ %>
                            <input class="form-control TA_Folio" id="inpInsTA_Folio" value = "" placeholder=""   style="width: 120px;float: left;"></input>
            			<label class="control-label col-md-6"><small><strong>Ingresar y presionar enter</strong></small></label>

                       </div>

                                     </div>
                                </div> 
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
               
                     <div class="form-group" id="divSeries">
                     </div>

					<% /* HA ID: 2 INI Se agrega Div de carga de Productos */ %>
					<div class="col-sm-12" id="divTraProLis">

					</div>
					<% /* HA ID: 2 FIN */ %>
  				
                   <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                       <div class="form-group">
                <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                <button type="button" class="btn btn-primary btnFor18" onclick="FunctionInsert.InsertDatos()">Guardar</button>
                <button type="button" class="btn btn-primary btnActualiza" style = "display:none;" onclick="FunctionInsert.ActualizaDatos()">Actualizar</button>

					</div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
						<div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
					<div class="form-group" id="divValidaCampos">
                     </div>
           <input  type="hidden" value="1" class="agenda SKU1"/>
           <input  type="hidden" value="2" class="agenda SKU2"/>
           <input  type="hidden" value="3" class="agenda SKU3"/>
           <input  type="hidden" value="4" class="agenda SKU4"/>
           <input  type="hidden" value="5" class="agenda SKU5"/>


<script type="application/javascript">

   $(document).ready(function(){
	<%
		if(Ins_ID>-1){
	%>
			$('#cboInsO_ID').val(<%=InsO_ID%>)
			$('.TA_Folio').val('<%=TA_Folio%>')
			$('.Descripcion').val('<%=Ins_Descripcion%>')
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
		 function BuscaSKU(event){
 	var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 23
		 sDatos += "&TA_Folio=" + 	$(".TA_Folio").val()
		 sDatos += "&Ins_ID=" + <%=Ins_ID%>
		$("#divSeries").load("/pz/wms/Incidencias/Incidencias_Ajax.asp?" + sDatos)

		}
	}	
   			var FunctionInsert = {
			InsertDatos:function(){
				var Folio = $('.TA_Folio').val()
				var Descripcion = $('.Descripcion').val()
			   	var Asignar = $('#selAsignar').val()
	
			if(Folio != '' && Descripcion != '' && Asignar !=-1){
				$('#divValidaCampos').hide()

				var IntT_ID = $('.InsT_IDPadre').val()

				var Titulo = "";
					
				switch( parseInt(InsT_ID) ){
					case 27: { Titulo = "Diferencias en Remision" } break;
					case 29: { Titulo = "Diferencias en Remision" } break;
					case 30: { Titulo = "Entrega Parcial" } break;
					case 40: { Titulo = "Siniestro Pacial" } break;
					case 39: { Titulo = "Siniestro Total" } break;
				}

				<% /* HA ID: 2 INI se agrega paramentros para inserción */ %>

					if( InsT_ID == 27 /* SKU Cambiado */ || InsT_ID == 29 /* SKU Faltante */ 
						|| InsT_ID == 30 /* Entregas Parciales */ || InsT_ID == 40 /* Siniestros Parciales */ ){

						//Validacion
						if( !( Serie.Listado.Seleccion.Validar() ) ){
							Avisa("warning", "Incidencia ", "Verificar Seleccion de Series");
							return;
						}

					}

				<% /* HA ID: 2 FIN */ %>

		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax2.asp",
 	   data: { 
							Ins_Titulo:Titulo,
		   				   SKUCambiado:1,
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
		   					Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
						   Tarea:17
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
							var resp = JSON.parse(data)
							
							console.log("resp:", resp)

							var intErrorNumero = resp.Error.Numero;
							var strErrorDescripcion = resp.Error.Descripcion;
							var intIns_ID = resp.Registro.Ins_ID;
							var intTA_ID = resp.Registro.TA_ID;

							if(intErrorNumero == 0){

					<% /* HA ID: 2 INI Insertar o Actualizar Series */ %>

								if( InsT_ID == 27 /* SKU Cambiado */ || InsT_ID == 29 /* SKU Faltante */ 
									|| InsT_ID == 30 /* Entregas Parciales */ || InsT_ID == 40 /* Siniestros Parciales */ ){

									Serie.Listado.Seleccion.Guardar({
											Ins_ID: intIns_ID
											, TA_ID: intTA_ID
											, IDUsuario: $("#IDUsuario").val()
										}
										, function(){
											Avisa("success", "Aviso", strErrorDescripcion);
											$("#divPadre").show()
											$("#mdlIncidencias").modal('hide').remove();

											var Params = "?IDUsuario="+$('#IDUsuario').val()
											
											$('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
										}
									);

								} else {
									
									Avisa("success", "Aviso", strErrorDescripcion);
									$("#divPadre").show()
									$("#mdlIncidencias").modal('hide').remove();

									var Params = "?IDUsuario="+$('#IDUsuario').val()
									
									$('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
								}

					<% /* HA ID: 2 FIN */ %>

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
		AgregarSKU:function(proid, taid){
			if($('.ChkSKU'+proid).is(':checked')){
			var ChkSKU =1
			}else{
			var ChkSKU =0  
			}
				  $.ajax({
                  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp"
                , method: "post"
                , async: false
                , data: {
					ChkSKU:ChkSKU,
					Pro_ID:proid, 
					SKUCambiado:$(".SKU"+proid).val(), 
					TA_ID:taid,
					Ins_ID:<%=Ins_ID%>,
                     Tarea: 24
                }
                , success: function(data){
					var resp = JSON.parse(data)
					if(resp.result==1){
					var Tipo = "success"
					var sMensaje = resp.message
					}else{
					var Tipo = "error"
					var sMensaje = resp.message
						
					}
						Avisa(Tipo,"Aviso",sMensaje);
                }
            });
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

				<% /* HA ID: 2 INI se agrega paramentros para inserción */ %>

				var InsT_ID = $('.InsT_IDPadre').val();

				var Titulo = "";
				
				switch( parseInt(InsT_ID) ){
					case 27: { Titulo = "Diferencias en Remision" } break;
					case 29: { Titulo = "Diferencias en Remision" } break;
					case 30: { Titulo = "Entrega Parcial" } break;
					case 40: { Titulo = "Siniestro Pacial" } break;
					case 39: { Titulo = "Siniestro Total" } break; /**/ /**/
				}

				if( InsT_ID == 27 /* SKU Cambiado */ || InsT_ID == 29 /* SKU Faltante */ 
					|| InsT_ID == 30 /* Entregas Parciales */ || InsT_ID == 40 /* Siniestros Parciales */ ){

					//Validacion
					if( !( Serie.Listado.Seleccion.Validar() ) ){
						Avisa("warning", "Incidencia ", "Verificar seleccion de Series");
						return;
					}
				}

				<% /* HA ID: 2 FIN */ %>

		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax2.asp",
 	   data: { 
   		   				   SKUCambiado:1,
	 					   Ins_ID:<%=Ins_ID%>,
	   					   InsT_ID:$('.InsT_IDPadre').val(),
						   InsO_ID:$('#cboInsO_ID').val(),
   	   					   TA_ID:<%=TA_ID%>,
						   TA_Folio:$('.TA_Folio').val(),
		   					Ins_Usu_Recibe:Asignar,
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
		   					//  Prov_ID: $('#cboProv').val(),
						   Tarea:26
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
		var resp = JSON.parse(data)

							console.log("resp:", resp)

							var intErrorNumero = resp.Error.Numero;
							var strErrorDescripcion = resp.Error.Descripcion;
							var intIns_ID = resp.Registro.Ins_ID;
							var intTA_ID = resp.Registro.TA_ID;

							if( intErrorNumero == 0 ){

							<% /* HA ID: 2 INI Insertar o Actualizar Series */ %>

								if( InsT_ID == 27 /* SKU Cambiado */ || InsT_ID == 29 /* SKU Faltante */ 
									|| InsT_ID == 30 /* Entregas Parciales */ || InsT_ID == 40 /* Siniestros Parciales */ ){

									Serie.Listado.Seleccion.Guardar({
											Ins_ID: intIns_ID
											, TA_ID: intTA_ID
											, IDUsuario: $("#IDUsuario").val()
										}
										, function(){
											Avisa("success", "Aviso", strErrorDescripcion);
											$("#divPadre").show()
											$("#mdlIncidencias").modal('hide').remove();

											var Params = "?IDUsuario="+$('#IDUsuario').val()
											
											$('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
										}
									);
								} else {
									
									Avisa("success", "Aviso", strErrorDescripcion);
									$("#divPadre").show()
									$("#mdlIncidencias").modal('hide').remove();

									var Params = "?IDUsuario="+$('#IDUsuario').val()
									
									$('#Contenido').load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)
								}

							<% /* HA ID: 2 FIN */ %>
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
					
				}
			
			
		}
</script>

<% /* HA ID: 2 INI Scripts de carga productos y series */ %>

<script src="/pz/wms/incidencias/js/Incidencia_Producto.js"></script>
<script src="/pz/wms/incidencias/js/Incidencia_Serie.js"></script>

<script type="text/javascript">

	$(document).ready(function(){

		var intInsT_ID = parseInt($('.InsT_IDPadre').val());

		var arrVerPro = [
			  27 /* SKU Cambiado */
			, 29 /* SKU Faltante */
			, 30 /* Entregas Parciales */
			, 40 /* Siniestros Parciales */
		];

		var bolVerPro = ( arrVerPro.indexOf(intInsT_ID) > -1 );

		if( bolVerPro ){

			$("#inpInsTA_Folio").on("keyup", function( evento ){

				var intTecla = (document.all) ? evento.keyCode : evento.which;
				
				if( intTecla == 13 ){
					ProductoListadoCargar();
				}

			});
		}
<%
	if( Ins_ID > -1 ){
%>
		if( bolVerPro ) {
			ProductoListadoCargar();
		}
<%
	}
%>
	});
	
	function ProductoListadoCargar(){

		var intInsT_ID = parseInt($('.InsT_IDPadre').val());
		var strValor = $("#inpInsTA_Folio").val().trim();

		var arrVerSerie = [
			  27 /* SKU Cambiado */
			, 29 /* SKU Faltante */
			, 30 /* Entregas Parciales */
			, 40 /* Siniestros Parciales */
		];

		var arrCambiarSerie = [
			27 /* SKU Cambiado */
		];

		var intVerSeries = ( arrVerSerie.indexOf(intInsT_ID) > -1 ) ? 1 : 0;
		var intCambiarSeries = ( arrCambiarSerie.indexOf(intInsT_ID) > -1 ) ? 1 : 0;

		Producto.Listado.Cargar({
			Contenedor: "divSeries"
			, Tipo: Producto.Listado.TipoListado.Transferencia
			, VerSerie: intVerSeries
			, CambiarSerie: intCambiarSeries
			, Ins_ID: <%= Ins_ID %>
			, Filtros: {
				Folio: strValor
			}
		});

	}

</script>
<% /* HA ID: 2 FIN */ %>
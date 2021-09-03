<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

 var Pro_ID = Parametro("Pro_ID",-1)
 var ProF_ID = Parametro("ProF_ID",-1)

 var sSQL  = " SELECT * " 
	 sSQL += " FROM BPM_Proceso p , BPM_Proceso_Flujo f " 
	 sSQL += " WHERE p.Pro_ID = f.Pro_ID AND p.Pro_ID = " + Pro_ID
	 sSQL += " AND f.ProF_ID = " + ProF_ID
  
	bHayParametros = false
	ParametroCargaDeSQL(sSQL,0) 	
	
%>
	<div class="row">
		<div class="col-md-9">
			<div class="ibox">
				<div class="ibox-title">
					<span class="pull-right"></span>
					<h5>Proceso: <%=Parametro("Pro_Nombre","")%> -
                    Paso no <%=Parametro("ProF_Orden","")%>, <%=Parametro("ProF_Nombre","")%>
                    <br /> <small><%=Parametro("Pro_DescripcionCorta","")%><br /></small>
                    </h5> 
				</div>
				<div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
									<td width="68%" class="desc">
										<h3><a class="text-navy" href="#">N&uacute;mero de paso</a></h3>
										<p>Un proceso es  un flujo de trabajo que esta acotado por pasos y el seguimiento es indicado por lo que sucede en cada paso.</p>
										<p>El n&uacute;mero es &uacute;nico y define un elemento del proceso</p>
										<dl class="m-b-none">
											<dt>Opciones</dt>
											<dd>
                                            <ul>
												<li><strong>N&uacute;mero:</strong> escriba un n&uacute;mero entero</li>
											</ul>
                                            </dd>
										</dl>
									</td>
									<td width="32%" align="left" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
									    <td colspan="2">&nbsp;</td>
								      </tr>
									  <tr>
									    <td width="22%">N&uacute;mero</td>
									    <td width="78%"><label for="textfield"></label>
								        <input type="text" size="10"
                                               value="<%=Parametro("ProF_Orden","")%>" id="ProF_Orden" 
                                               maxlength="10" class="objTxt" >
                                        </td>
								      </tr>
									  <tr>
									    <td>&nbsp;</td>
									    <td>&nbsp;</td>
								      </tr>
                              </table>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
                
                <div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td width="90%" class="desc">
										<h3><a class="text-navy" href="#">Nombre</a></h3>
									<p>El nombre que identifica que ocurre en este paso</p>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td><input type="text" class="objTxt" style="width:100%" value="<%=Parametro("ProF_Nombre","")%>" id="ProF_Nombre" />
                                                </td>
                                            </tr>
                                        </table>
									</td>
									<td width="10%">
								</tr>
						
							</tbody>
						</table>
					</div>
				</div>

                <div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td width="90%" class="desc">
										<h3><a class="text-navy" href="#">Descripci&oacute;n completa</a></h3>
									<p>Escriba que hace este paso del proceso</p>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
        	<td><textarea rows="5" class="objTxt" style="width:100%" id="ProF_Descripcion"><%=Parametro("ProF_Descripcion","")%></textarea>
            </td>
        </tr>
    </table>
									</td>
									<td width="10%">
								</tr>
						
							</tbody>
						</table>
					</div>
				</div>
       
                <div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td width="90%" class="desc">
										<h3><a class="text-navy" href="#">Descripci&oacute;n corta</a></h3>
									<p>Descripci&oacute;n de lo que hace este paso en pocas palabras</p>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td><input type="text" class="objTxt" style="width:100%" value="<%=Parametro("Pro_DescripcionCorta","")%>" id="Pro_DescripcionCorta" />
                                                </td>
                                            </tr>
                                        </table>
									</td>
									<td width="10%">
                                 </tr>
							</tbody>
						</table>
					</div>
				</div>						
                
                <div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td width="90%" class="desc">
										<h3><a class="text-navy" href="#">Grid de carga</a></h3>
									<p>Archivo grid que se carga en la mesa de control</p>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td><input type="text" class="objTxt" style="width:100%" value="<%=Parametro("ProF_ArchivoDelGridDeCarga","")%>" id="ProF_ArchivoDelGridDeCarga" />
                                                </td>
                                            </tr>
                                        </table>
									</td>
									<td width="10%">
                                 </tr>
							</tbody>
						</table>
					</div>
				</div>
  												
				<div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td width="68%" class="desc">
										<h3><a class="text-navy" href="#">Comportamiento de la tarea</a></h3>
									<p>Defina la foma en que la tarea fluye en el proceso </p>
									  <dl class="m-b-none">
										  <dt>Opciones</dt>
										<dd>
                                            <ul>
	<li><strong>Espera resultado:</strong> Este paso no puede continuar hasta que se reciba un resultado</li>
	<li><strong>Simultaneo:</strong> Este proceso inicia, procesa, termina y continua</li>
	<li><strong>Finaliza:</strong> Este paso finaliza el proceso</li>   
</ul>
                                        </dd>
									  </dl>
								  </td>
									<td width="32%" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
									    <td>&nbsp;</td>
								      </tr>
                                      <tr>
									    <td>&nbsp;</td>
								      </tr>
                                      <tr>
									    <td>&nbsp;</td>
								      </tr>
                                      <tr>
									    <td>&nbsp;</td>
								      </tr>
                                      <tr>
									    <td>&nbsp;</td>
								      </tr>
									  <tr>
									    <td width="100%">&nbsp;
<%
var sEventos = " class='objCbo' "
ComboSeccion("ProF_TipoFlujoCG300",sEventos,300,Parametro("ProF_TipoFlujoCG300",1),0,"Seleccione","Cat_Orden","Editar")
%>
                                        </td>
								      </tr>
									  <tr>
									    <td>&nbsp;</td>
								      </tr>
						        </table>	
                           	  </tr>
							</tbody>
						</table>
					</div>
				</div>
                
                <div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td width="68%" class="desc">
										<h3><a class="text-navy" href="#">Formulario</a></h3>
									<p>Si esta tarea necesita una pantalla de captura, ser&aacute; por medio de un formulario y se deber&aacute; seleccionar del cat&aacute;logo de forularios</p>
									  <dl class="m-b-none">
										  <dt>Opciones</dt>
										  <ul>
	<li><strong>Sin formulario:</strong> Cuando este paso no tiene formulario de captura</li>
	<li><strong>Con formulario:</strong> seleccionar uno de los que se ofrecen</li>
</ul>
									  </dl>
								  </td>
									<td width="32%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
									    <td>&nbsp;</td>
								      </tr>
									  <tr>
									    <td>&nbsp;</td>
								      </tr>
									  <tr>
									    <td>&nbsp;</td>
								      </tr>
									  <tr>
									    <td width="100%">&nbsp;</td>
								      </tr>
									  <tr>
									    <td>
<%
var sEventos = " class='objCbo' "
var sCondicion = " For_Habilitado = 1 "
   CargaCombo("For_ID",sEventos,"For_ID","For_Nombre","Formato",sCondicion,""
   ,Parametro("For_ID",-1),0,"Sin formulario","Edicion")                                     
%>                                        
                                        </td>
								      </tr>
						        </table>	
                           	  </tr>
							</tbody>
						</table>
					</div>
				</div>
             

	</div>
		</div>
		<div class="col-md-3">
			<div class="ibox">
				<div class="ibox-title">
					<h5>Estatus Atiende</h5>
				</div>
				<div class="ibox-content">
					<table width="200px" border="0" cellspacing="0" cellpadding="0">
<%                   
	 
var sSQL  = "SELECT ProE_ID, ProE_Nombre, ProE_Descripcion " 
    sSQL += " ,(SELECT ProE_Seleccionado FROM BPM_Proceso_Flujo_Estatus p "
    sSQL += "    WHERE p.ProE_Posibles = 1 AND p.Pro_ID = " + Pro_ID 
	sSQL += "      AND p.ProF_ID = " + ProF_ID 
    sSQL += "      AND p.ProE_ID = e.ProE_ID ) as Seleccionado "	
    sSQL += " FROM BPM_Proceso_Estatus e "
    sSQL += " WHERE e.Pro_ID = " + Pro_ID
    sSQL += " AND e.ProE_Habilitado	= 1 "
    sSQL += " Order by e.ProE_Orden "
	 	 

 var rsEstatus = AbreTabla(sSQL,1,0)
  
	while (!rsEstatus.EOF){
%>                    
                      <tr>
                        <td align="left"><input class="chkEstatus" type="checkbox" 
 <% if (rsEstatus.Fields.Item("Seleccionado").Value == 1) { Response.Write("checked='checked'") } %>   data-posible="0" value="<%=rsEstatus.Fields.Item("ProE_ID").Value%>"></td>
                        <td>&nbsp;&nbsp;<%=rsEstatus.Fields.Item("ProE_Nombre").Value%></td>
                      </tr>
<%                   
		rsEstatus.MoveNext() 
	}
	rsEstatus.Close()   
%>                                                                         
                    </table>
                    <hr>
					<span class="text-muted small">Seleccione los estatus que estar&aacute;n disponibes para este paso</span>
				</div>
			</div>





<div class="ibox">
				<div class="ibox-title">
					<h5>Estatus entrega</h5>
				</div>
				<div class="ibox-content">
					<table width="200px" border="0" cellspacing="0" cellpadding="0">
<%                   
	 
var sSQL  = "SELECT ProE_ID, ProE_Nombre, ProE_Descripcion " 
    sSQL += " ,(SELECT ProE_Seleccionado FROM BPM_Proceso_Flujo_Estatus p "
    sSQL += "    WHERE p.ProE_Controla = 1 AND p.Pro_ID = " + Pro_ID 
	sSQL += "      AND p.ProF_ID = " + ProF_ID 
    sSQL += "      AND p.ProE_ID = e.ProE_ID ) as Seleccionado "	
    sSQL += " FROM BPM_Proceso_Estatus e "
    sSQL += " WHERE e.Pro_ID = " + Pro_ID
    sSQL += " AND e.ProE_Habilitado	= 1 "
    sSQL += " Order by e.ProE_Orden "
	 	 

 var rsEstatus = AbreTabla(sSQL,1,0)
  
	while (!rsEstatus.EOF){
%>                    
                      <tr>
                        <td align="left"><input class="chkEstatus" type="checkbox" 
 <% if (rsEstatus.Fields.Item("Seleccionado").Value == 1) { Response.Write("checked='checked'") } %>
							data-posible="1" value="<%=rsEstatus.Fields.Item("ProE_ID").Value%>"></td>
                        <td>&nbsp;&nbsp;<%=rsEstatus.Fields.Item("ProE_Nombre").Value%></td>
                      </tr>
<%                   
		rsEstatus.MoveNext() 
	}
	rsEstatus.Close()   
%>                                                                         
                    </table>
                    <hr>
					<span class="text-muted small">Seleccione los estatus con los cuales este paso se activa</span>
				</div>
			</div>








			<div class="ibox">
				<div class="ibox-content">
					<p class="font-bold">Par&aacute;metros de control</p>
					<hr>
					<div>
						<a class="product-name" href="#">El paso est&aacute; activo</a>
						<div class="small m-t-xs">
							Indica si este paso se muestra o se oculta del sistema
						</div>
						<div class="m-t text-righ">
                            <input type="checkbox" value="1" class="objChk" 
                            id="ProF_Activo"
                      <% if (Parametro("ProF_Activo",0) == 1) { Response.Write(" checked='checked' ") } %>/>
						Habilitado</div>
					</div>
					<hr>
					<!-- div>
						<a class="product-name" href="#">Param 2</a>
						<div class="small m-t-xs">
							vdf dgdf gd fgdfg.
						</div>
						<div class="m-t text-righ">
							
						</div>
					</div  -->
				</div>
			</div>
		</div>
	</div>

<script type="text/javascript">

	$(document).ready(function() {
		
//		$(".objRdio").change(function() { 
//			var NombreRadio = $(this).attr('name');
//			var Valor = $('input:radio[name=' + NombreRadio + ']:checked').val()
//	
//			//if( $(this).validationEngine('validate') ) {
//				var camid = $(this).data("camid");
//				//alert(NombreRadio + " valor " + Valor + " id " + camid )
//				//alert(" id " + $(this).data("camid") + " valor " + $(this).val()	)
//				$.post( "/pz/fnd/Producto/Producto_Ajax.asp"
//					   , {  Tarea:1
//						   ,Pro_ID:$("#Pro_ID").val()
//						   ,Cam_ID:camid				 
//						   ,Valor:Valor			 		 
//					   }, function() {
//							var sMensaje = "El cambio se registro correctamente "
//							var sTitulo = "Cambio correcto"	
//							Avisa("success",sTitulo,sMensaje)	 			
//						});		 					
//		});
//		
		$(".objChk").change(function() { 
			var iSeleccionado = 0;
			var bChecado = $(this).is(':checked')
			if (bChecado) {
				iSeleccionado = 1
			}
			ValidaYGuardaCampo($(this),$(this).attr('id'), iSeleccionado );			
		});		

		$(".objCbo").change(function(){
			ValidaYGuardaCampo($(this),$(this).attr('name'), "" );			  
   		});			
		
		$(".objTxt").blur(function(){
			ValidaYGuardaCampo($(this),$(this).attr('id'), "" );
   		});	
		
//		$(".chkPeriodo").change(function(){
//			var camid = $(this).val();		
//			var Valor = 0
//			if ( $(this).is(':checked') ) {
//				Valor = 1
//			}
//			$.post( "/pz/fnd/Producto/Producto_Ajax.asp"
//				   , {  Tarea:2
//					   ,Pro_ID:$("#Pro_ID").val()
//					   ,Cat_ID:camid
//					   ,Sec_ID:2
//					   ,Valor:Valor
//			}, function() {
//				var sMensaje = "El cambio se registro correctamente "
//				var sTitulo = "Cambio correcto"	
//				Avisa("success",sTitulo,sMensaje)	 			
//			});		
//   		});	
		
		$(".chkEstatus").change(function(){
			var ProEID = $(this).val();	
			var Posible = $(this).data("posible");
			var Valor = 0
			if ( $(this).is(':checked') ) {
				Valor = 1
			}
			$.post( "/pz/wms/Proceso/Proceso_Ajax.asp"
				   , {  Tarea:2
					   ,Pro_ID:$("#Pro_ID").val()
					   ,ProF_ID:$("#ProF_ID").val()					   
					   ,ProE_ID:ProEID
					   ,ProE_Posibles:Posible
					   ,Valor:Valor
			}, function() {
				var sMensaje = "El cambio se registro correctamente "
				var sTitulo = "Cambio correcto"	
				Avisa("success",sTitulo,sMensaje)	 			
			});				
   		});			
				
	});
	
function ValidaYGuardaCampo(o,NombreCampo,dato){

	//if( o.validationEngine('validate') ) {
		dato = "" + dato;
	    var Valor = o.val();
		if(dato != ""){
			Valor = dato;
		} 
		
		$.post( "/pz/wms/Proceso/Proceso_Ajax.asp"
			   , {  Tarea:1
				   ,Pro_ID:$("#Pro_ID").val()
				   ,ProF_ID:$("#ProF_ID").val()					   
				   ,Campo:NombreCampo				 
				   ,Valor:Valor			 		 
		}, function(result) {
			var Regresa = JSON.parse(result)
			console.log(Regresa)
			if(Regresa.Resultado == "OK"){
				var sMensaje = "El cambio se registro correctamente "
				if (Regresa.Tipo == "Nuevo"){
					$("#ProF_ID").val(Regresa.ProF_ID)
					sMensaje = "El Registro se guardo correctamente "
				} 
				var sTitulo = "Cambio correcto"	
				Avisa("success",sTitulo,sMensaje)						
			} else {
				if(Regresa.Mensaje != ""){
					var sMensaje = "Ocurrio un error, avise al administrador "
					var sTitulo = "Error al guardar " + Regresa.Mensaje	
					Avisa("error",sTitulo,sMensaje)	
				}
			}
		});	 			
	//}


}
	
	
</script>


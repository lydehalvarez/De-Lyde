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
<style type="text/css">
	.esttexto {
		width:500px; 
		float:left;
	}
	.estEtq {
		width:200px; 
		float:left;		
	}
	.stEstatus {
		margin-right: 15px !IMPORTANT;
        margin-left: 15px !IMPORTANT;
        padding-bottom: 15px;
	}


</style>


	<div class="row">
		<div class="col-md-12">
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
									<td  colspan="2" class="desc">
										<h3><a class="text-navy" href="#">Al iniciar </a></h3>
										Funci&oacute;n que se ejecuta al iniciar este paso del proceso.
									</td>
									</tr>
								<tr>
								  <td width="19%" class="desc">&nbsp;</td>
								  <td width="81%" class="desc">&nbsp;</td>
						      </tr>
								<tr>
								  <td class="desc">Nombre de la funci&oacute;n</td>
								  <td class="desc">
                                  <input type="text" class="objTxt" style="width:100%" value="<%=Parametro("ProF_Fn_Al_Iniciar","")%>" id="ProF_Fn_Al_Iniciar" />
                                  </td>
							  </tr>
								<tr>
								  <td class="desc">&nbsp;</td>
								  <td class="desc">&nbsp;</td>
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
									<td colspan="2" class="desc">
										<h3><a class="text-navy" href="#">Al terminar </a></h3>
										Funci&oacute;n que se ejecuta al terminar este paso del proceso.
									
									</td>
									</tr>
								<tr>
								  <td width="19%" class="desc">&nbsp;</td>
								  <td width="81%" class="desc">&nbsp;</td>
						      </tr>
								<tr>
								  <td class="desc">Nombre de la funci&oacute;n</td>
								  <td class="desc">
                                  <input type="text" class="objTxt" style="width:100%" value="<%=Parametro("ProF_Fn_Al_Terminar","")%>" id="ProF_Fn_Al_Terminar" />
                                  </td>
							  </tr>
								<tr>
								  <td class="desc">&nbsp;</td>
								  <td class="desc">&nbsp;</td>
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
									<td  colspan="2"  class="desc">
										<h3><a class="text-navy" href="#">Cuando ocurra un error </a></h3>
                                        Funci&oacute;n que se ejecuta cuando ocurra cualquier error.
									</td>
									</tr>
								<tr>
								  <td width="19%" class="desc">&nbsp;</td>
								  <td width="81%" class="desc">&nbsp;</td>
						      </tr>
								<tr>
								  <td class="desc">Nombre de la funci&oacute;n</td>
								  <td class="desc">
                                  <input type="text" class="objTxt" style="width:100%" value="<%=Parametro("ProF_Fn_Al_Error","")%>" id="ProF_Fn_Al_Error" />
                                  </td>
							  </tr>
								<tr>
								  <td class="desc">&nbsp;</td>
								  <td class="desc">&nbsp;</td>
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
									<td width="87%" class="desc">
										<h3><a class="text-navy" href="#">Al cambio de estatus </a></h3>
										<p>Funci&oacute;n que se ejecutar&aacute; cuando un estatus cambie.</p>
										<dl class="m-b-none">
<%                   
	 
var sSQL  = "SELECT p.ProE_ID, ProE_Nombre, ProE_Descripcion, ProE_Funcion " 	
    sSQL += " FROM BPM_Proceso_Estatus e, BPM_Proceso_Flujo_Estatus p "
    sSQL += " WHERE p.Pro_ID = e.Pro_ID AND e.Pro_ID = " + Pro_ID
	sSQL += " AND p.ProF_ID = " + ProF_ID	
    sSQL += " AND p.ProE_ID = e.ProE_ID "	
	sSQL += " AND e.ProE_Habilitado = 1 AND p.ProE_Seleccionado = 1 "
	sSQL += " AND p.ProE_Posibles = 1 "
    sSQL += " Order by e.ProE_Orden "
	 	 
 var rsEstatus = AbreTabla(sSQL,1,0)
  
	while (!rsEstatus.EOF){
%>     
                      <dd><div class="row stEstatus">
                      <div class="estEtq">
					  <%=rsEstatus.Fields.Item("ProE_Nombre").Value%>&nbsp;&nbsp;</div>
                      <div class="esttexto">
                      <input type="text" class="objEsttTxt" style="width:100%" 
                             value="<%=rsEstatus.Fields.Item("ProE_Funcion").Value%>" 
                             data-proeid="<%=rsEstatus.Fields.Item("ProE_ID").Value%>"
                              /></div> 
                          </div>    
                      </dd>
<%                   
		rsEstatus.MoveNext() 
	}
	rsEstatus.Close()   
%>
										</dl>
									</td>
									</tr>
							</tbody>
						</table>
					</div>
				</div>
	</div>
		</div>

	</div>

<script type="text/javascript">


	$(document).ready(function() {
		
		$(".objTxt").blur(function(){
			ValidaYGuardaCampo($(this),$(this).attr('id') );
   		});	
		$(".objEsttTxt").blur(function(){
			var proeid = $(this).data("proeid")
			var Valor = $(this).val();
			$.post( "/pz/agt/Proceso/Proceso_Ajax.asp"
				   , {  Tarea:4
					   ,Pro_ID:$("#Pro_ID").val()
					   ,ProF_ID:$("#ProF_ID").val()
					   ,ProE_ID:proeid		   			 
					   ,Valor:Valor			 		 
			}, function(Regresa) {
				if(Regresa == -2) {
					var sMensaje = "Ocurrio un error, avise al administrador "
					var sTitulo = "Error al guardar"	
					Avisa("error",sTitulo,sMensaje)		
				} else {
					var sMensaje = "El cambio se registro correctamente "
					var sTitulo = "Cambio correcto"	
					Avisa("success",sTitulo,sMensaje)	
				}
			});	
			
			
   		});			
				
	});
	
function ValidaYGuardaCampo(o,NombreCampo){

	//if( o.validationEngine('validate') ) {
		var Valor = o.val();
			$.post( "/pz/wms/Proceso/Proceso_Ajax.asp"
				   , {  Tarea:1
					   ,Pro_ID:$("#Pro_ID").val()
					   ,ProF_ID:$("#ProF_ID").val()					   
					   ,Campo:NombreCampo				 
					   ,Valor:Valor			 		 
			}, function(Regresa) {
				if(Regresa > 0) {
					$("#ProF_ID").val(Regresa)
				}
				if(Regresa == -2) {
					var sMensaje = "Ocurrio un error, avise al administrador "
					var sTitulo = "Error al guardar"	
					Avisa("error",sTitulo,sMensaje)		
				} else {
					var sMensaje = "El cambio se registro correctamente "
					var sTitulo = "Cambio correcto"	
					Avisa("success",sTitulo,sMensaje)	
				}
			});	 			
	//}


}
		
		
	
</script>

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var Pro_ID = Parametro("Pro_ID",-1)
var ProF_ID = Parametro("ProF_ID",-1)

var Pro_Habilitado = 1

 var sSQL  = " SELECT * " 
	 sSQL += " FROM BPM_Proceso p , BPM_Proceso_Flujo f " 
	 sSQL += " WHERE p.Pro_ID = f.Pro_ID AND p.Pro_ID = " + Pro_ID
	 sSQL += " AND f.ProF_ID = " + ProF_ID
  
 var rsProceso = AbreTabla(sSQL,1,0)

 if (!rsProceso.EOF){

	var NombreProceso = rsProceso.Fields.Item("Pro_Nombre").Value
	var Descripcion = rsProceso.Fields.Item("Pro_DescripcionCorta").Value
    var ProF_Orden = rsProceso.Fields.Item("ProF_Orden").Value
	var ProF_Nombre = rsProceso.Fields.Item("ProF_Nombre").Value
	var ProF_Descripcion = rsProceso.Fields.Item("ProF_Descripcion").Value	
	var ProF_TipoFlujoCG300 = rsProceso.Fields.Item("ProF_TipoFlujoCG300").Value		
	
%>
	<div class="row">
		<div class="col-md-12">
			<div class="ibox">
				<div class="ibox-title">
					<span class="pull-right"></span>
					<h5>Proceso: <%=NombreProceso%> -
                    Paso no <%=ProF_Orden%>, <%=ProF_Nombre%>
                    <br /> <small><%=Descripcion%><br /></small>
                    </h5> 
				</div>
				<div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
									<td width="87%" class="desc">
										<h3><a class="text-navy" href="#">Al iniciar </a></h3>
										<p>Funci&oacute;n que deber&aacute; ejecutarse al iniciar este paso del proceso.										</p>
										<dl class="m-b-none">
											<dt>Opciones</dt>
											<dd>
                                            <ul>
	<li><strong>Ninguna:</strong> No hace nada</li>
	<li><strong>Seleccionada:</strong> ejecuta la accion seleccionada al iniciar</li>    
</ul>
                                            </dd>
										</dl>
									</td>
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
										<h3><a class="text-navy" href="#">Al terminar </a></h3>
										<p>Funci&oacute;n que deber&aacute; ejecutarse al terminar este paso del proceso.										</p>
										<dl class="m-b-none">
											<dt>Opciones</dt>
											<dd>
                                            <ul>
	<li><strong>Ninguna:</strong> No hace nada</li>
	<li><strong>Seleccionada:</strong> ejecuta la accion seleccionada al terminar</li>    
</ul>
                                            </dd>
										</dl>
									</td>
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
										<h3><a class="text-navy" href="#">Cuando ocurra un error </a></h3>
										<p>Funci&oacute;n que deber&aacute; ejecutarse cuando ocurra cualquier error.</p>
										<dl class="m-b-none">
											<dt>Opciones</dt>
											<dd>
                                            <ul>
	<li><strong>Ninguna:</strong> No hace nada</li>
	<li><strong>Seleccionada:</strong> ejecuta la accion seleccionada al ocurrir un error</li>    
</ul>
                                            </dd>
										</dl>
									</td>
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
										<p>Funci&oacute;n que deber&aacute; ejecutarse cuando un estatus cambie.</p>
										<dl class="m-b-none">
											<dt>Opciones</dt>
											<dd>
                                            <ul>
	<li><strong>Ninguna:</strong> No hace nada</li>
	<li><strong>Seleccionada:</strong> ejecuta la accion seleccionada al cambio de estatus</li>    
</ul>
                                            </dd>
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

	
</script>

<%
 } else {
	Response.Write("No se consigieron las llaves correctas") 
	Response.Write("<br> Pro_ID " + Pro_ID)
    Response.Write("<br> ProF_ID " + ProF_ID)
    Response.Write("<br> sSQL " + sSQL) 
 }
 rsProceso.Close() 
 
%>
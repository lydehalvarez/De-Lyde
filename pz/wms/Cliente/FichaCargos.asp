<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/Inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
<div id="wrapper">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox"> 
                   
              <div class="ibox-content"  id="divCargo">
          <div class="m-b-md">
							Resultado
                                </div>
                        <hr>        
                        <div class="row">
                         
                            <div class="col-lg-12">
                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                               	    <dt>Cargo:</dt>
                                    <dd><%=Parametro("CCgo_Titulo","")%></dd>
                                </dl>
                                     <dl class="dl-horizontal">
                                	   	<dt>Folio:</dt>
                                   		<dd><span class="label label-primary"><%=Parametro("CCgo_Folio","")%></span></dd>
                                   </dl>
                            </div>
                                <div class="col-lg-6">
                                   <dl class="dl-horizontal">
                                	<dt>Folio cliente:</dt>
                                    <dd><%=Parametro("CCgo_FolioCliente","")%></dd>
                                    </dl>
                                </div>
                                  <div class="col-lg-12">
                                <!--Datos de la Orden de compra-->
                                		<dl class="dl-horizontal">
                                   		<dt>Guia:</dt>
                                    	<dd><%=Parametro("CCgo_Guia","")%></dd>
                                </dl>
                             	   </div>
                                          <div class="col-lg-12">
                                <!--Datos de la Orden de compra-->
                                		<dl class="dl-horizontal">
                                   		<dt>Motivo:</dt>
                                    	<dd><%=Parametro("CCgo_Motivo","")%></dd>
                                </dl>
                             	   </div>
                                 <div class="col-lg-6">
                                <!--Datos de la Orden de compra-->
                             	    <dl class="dl-horizontal">
                                    <dt>Observaciones:</dt>
                                    <dd><%=Parametro("CCgo_Observaciones","")%></dd>
                                    <dt>Monto:</dt>
                                    <dd><%=Parametro("CCgo_Monto","")%></dd>
                                     <dt>Fecha:</dt>
                                    <dd><%=Parametro("CCgo_Fecha","")%></dd>
                                    <%
                           					sSQL = "SELECT Cat_Nombre FROM Cat_Catalogo t "
						   					+"INNER JOIN Cliente_Cargo a ON a.Cat_ID=t.CCgo_EstatusCG97 WHERE Cat_Seccion=97"									
											var rsEstatus=AbreTabla(sSQL,1,0)
											var Estatus = rsTAFechaS.Fields.Item("Cat_Nombre").Value
									%>
									 <dt>Estatus:</dt>
                                     <dd><%=Estatus%></dd>                            
                                      <dt>Usuario responsable:</dt>
                                    <dd><%=Usuario%></dd>                            
                                    <%  }  %>
											       
                                </dl>
                            </div>
                            <!--Datos del Proveedor-->
                  
                            <div class="col-lg-6" id="cluster_info">
                        	        <dl class="dl-horizontal">
                                    <dt>Cliente:</dt>
                                    <dd><%=Parametro("Cli_Nombre","")%></dd>
                                     <dt>Pallet:</dt>
                                    <dd><%=Parametro("Pt_LPN","")%></dd>
                                    <dt>Disponibles:</dt>
                                    <dd><%=Disponibles%></dd>
                                  
                                    </dl>   
                            </div>
                        </div>
                    </div>
                    <div class="ibox-content"  id="divArticulos">
       
                    </div>
                   
                </div>
            </div>
            <div class="col-sm-4">
                <div id="divHistLineTimeGrid"></div>
                <div id="divSeries"></div>
            </div>
        </div>
    </div>
</div>
                                    
<div class="modal fade" id="modalComentario" tabindex="-1" role="dialog" aria-labelledby="divModalComentario" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalComentario"><%= "Comentarios" %></h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalComentario" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <input type="hidden" id="comNodo" value="" />
            <div class="modal-body">
                <div class="form-group row">
                    <label for="comTitulo" class="col-sm-2 col-form-label">Titulo</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="comTitulo" placeholder="Titulo" maxlength="50">
                    </div>
                </div>
                <div class="form-group row">
					<label for="comComentario" class="col-sm-2 col-form-label">Comentarios</label>
                    <div class="col-sm-10">
                        <textarea id="comComentario" class="form-control" placeholder="Comentario" maxlength="150"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalComentario">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" onclick="Comentarios.Agregar();">
					<i class="fa fa-plus"></i> Agregar
				</button>
            </div>
		</div>
				<input type="hidden" value="" class="agenda" id="SerieOculta"/>

	</div>
</div>                                 
                                    
<!-- iCheck -->
<script src="/Template/Inspina/js/plugins/iCheck/icheck.min.js"></script>                                
<script type="text/javascript">

 $(document).ready(function(){
	  $("#divSerieTRA").hide()
		$("#divSerieOC").hide()
		$("#divSerieOV").hide()
	$('#input_Serie').on('change',function(e) {
	e.preventDefault()
	

			var sDatos = "Tipo=" + 4 
					sDatos += "&Serie=" + $("#input_Serie").val()
	
		$("#divSerie").show()	
		$("#SerieOculta").val($("#input_Serie").val())
		$("#divSerie").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
		 , function(data){
			if($("#DSerOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no se encuentra";
			Avisa(sTipo,"Aviso",sMensaje);
			$("#divSerie").hide()
					}
});

if($("#ckb1").prop('checked')){
	 				sDatos = "Tipo=" + 1 
					sDatos += "&Serie=" + $("#input_Serie").val()
			$("#divSerieTRA").show()
			$("#divSerieTRA").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
			 , function(data){
			$("#input_Serie").val("")
			if($("#TAOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no cuenta con transferencia";
			Avisa(sTipo,"Aviso",sMensaje);
					}
});
}
	if($("#ckb2").prop('checked')){ 
					sDatos = "Tipo=" + 2 
					sDatos += "&Serie=" + $("#input_Serie").val()
				$("#divSerieOC").show()
				$("#divSerieOC").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
				
				 , function(data){
			$("#input_Serie").val("")
			if($("#OCOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no cuenta con orden de compra";
			Avisa(sTipo,"Aviso",sMensaje);
			$("#divSerieOC").hide()
			}
				});
}
	if($("#ckb3").prop('checked')){ 
					sDatos = "Tipo=" + 3
					sDatos += "&Serie=" + $("#input_Serie").val()
				$("#divSerieOV").show()
				$("#divSerieOV").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
				 , function(data){
			$("#input_Serie").val("")
			if($("#OVOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no cuenta con orden de venta";
			Avisa(sTipo,"Aviso",sMensaje);
			$("#divSerieOV").hide()
			}
				});
	}
		
 		$("#input_Serie").val("")
	});
});
	 function CargaSerie(Tipo){
		 		var sDatos = "Tipo=" + Tipo 
			   sDatos += "&Serie=" + $("#SerieOculta").val();	

	if(Tipo==1){
			if($("#ckb1").prop('checked')){
			$("#divSerieTRA").show()
			$("#divSerieTRA").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
			 , function(data){
			$("#input_Serie").val("")
			if($("#TAOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no cuenta con transferencia";
			Avisa(sTipo,"Aviso",sMensaje);
					}
});
					
					
			}
	}
		if(Tipo==2){
				if($("#ckb2").prop('checked')){ 

				$("#divSerieOC").show()
				$("#divSerieOC").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
				
				 , function(data){
			$("#input_Serie").val("")
			if($("#OCOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no cuenta con orden de compra";
			Avisa(sTipo,"Aviso",sMensaje);
			$("#divSerieOC").hide()
					}
});
					
				}
	}
		if(Tipo==3){
			
				if($("#ckb3").prop('checked')){ 

				$("#divSerieOV").show()
				$("#divSerieOV").load("/pz/wms/Inventario/B_Serie_Ajax.asp?" + sDatos
				 , function(data){
			$("#input_Serie").val("")
			if($("#OVOculta").val() == 0){
			sTipo = "error";
			sMensaje = "La serie no cuenta con orden de venta";
			Avisa(sTipo,"Aviso",sMensaje);
			$("#divSerieOV").hide()
					}
});
				}
	}
	
	
	}	
	



    
</script>    

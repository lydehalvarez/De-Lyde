<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/Inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
<div id="wrapper">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox"> 
                <div class="ibox-content">
            <div class="row"> 
                <div class="col-sm-12 m-b-xs">        
                    <div class="row">
                        <label class="col-sm-2 control-label">Serie:</label>
                        <div class="col-sm-4 m-b-xs">
                        <input id="input_Serie" class="input-sm form-control" type="text" value="" style="width:200px">

                        </div>
                        <div class="col-sm-3 m-b-xs">
             	         </div>
             <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                        </div> 
                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                      
                        <div class="col-sm-4 m-b-xs" >
  							<input type="checkbox"  id = "ckb1" value="Transferencias" class="i-checks ChkRel" onclick="javascript:CargaSerie(1)"> </input> 
  						
                        <label >Transferencias</label>
                           <!-- <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 200px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                            -->
                        </div>
                         <div class="col-sm-4 m-b-xs" >
  							<input type="checkbox" id = "ckb2" value="OC" class="i-checks ChkRel" onclick="javascript:CargaSerie(2)">   </input>
  					
 								 <label >Ordenes de compra</label>
                   		     </div>
                          		<div class="col-sm-4 m-b-xs" >
									<input type="checkbox"  id = "ckb3" value="Servicios" class="i-checks ChkRel" onclick="javascript:CargaSerie(3)">  </input> 
                           		
                                	<label>Venta</label>
                        			</div>
                    </div>    
                </div>
            </div>
            <!-- div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">
                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
                        </div>
                        <label class="col-sm-1 control-label"></label>
                        <div class="col-sm-3 m-b-xs">
                            
                        </div>

                    </div>    
                </div>
            </div -->
            

        
          </div>   
              <div class="ibox-content"  id="divSerie">
       
                    </div>
                    <div class="ibox-content"  id="divSerieTRA">
       
                    </div>
                      <div class="ibox-content"  id="divSerieOC">
       
                    </div>
                      <div class="ibox-content"  id="divSerieOV">
       
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

<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var InsO_ID = Parametro("InsO_ID", -1)  
    var Ins_ID = Parametro("Ins_ID", -1)  


%>

<div class="modal inmodal" id="mdlTorreControl" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>
              
                <h4 class="modal-title">Asignar incidencia</h4>
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
                <div class="form-group">
                                    <label class="col-sm-2 control-label">Conclusion:</label>   
								<%
								    var sEventos = "class='col-sm-8 form-control'"
                                     ComboSeccion("CboCG35", sEventos, 35, -1, 0, "", "", "Editar")
 								%>
									<label class="col-sm-2 control-label lblDesc" style="display:none;">Descripcion:</label>    
                                    <div class="col-sm-10 m-b-xs">
           							<textarea class="form-control Descripcion" style="display:none;" ></textarea>
                                    </div>
<!--                                      <label class="col-sm-2 control-label">Comentario de cierre:</label>    
-->                                    <div class="col-sm-12 m-b-xs">
           							<textarea class="form-control NTema" placeholder="Escribe un comentario...." onkeydown= "GuardaTema(event, 0)"></textarea>
                                    </div>
                </div>
   		      </div>
        </div>
    </div>
</div>
                            
<script type="application/javascript">
 
    $(document).ready(function(){
		 	$('#CboCG35').change(function(e) {   
				var combo = $("#CboCG35").val()
				if(combo > 5|| combo==2){
					$(".Descripcion").css('display','block')
					$(".lblDesc").css('display','block')
				}
			});
         });
	 	
	    function GuardaTema(event, inspadre){
        
				var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
			console.log($(".NTema").val())
			var Tema =$(".NTema").val()
			var CboCG35 = $("#CboCG35").val()
			var Descripcion = $(".Descripcion").val()
			
		$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:<%=Ins_ID%>,
		InsCm_Padre:inspadre,
		EstatusCG35:CboCG35,
		Ins_Descripcion:Descripcion,
		InsCm_Observacion:Tema,
		Estatus: 3,
		Usuario:$('#IDUsuario').val(),
		Tarea:2
		},
		function(data){
	$("#divComentarios").load("/pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID="+ $("#Ins_ID").val()+"&Reporta="+$("#Reporta").val()+ "&Recibe="+$("#Recibe").val())
       	$("#mdlTorreControl").modal('hide').remove();
	    });
		}
		
    }
   </script>
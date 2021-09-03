<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var Man_ID = Parametro("Man_ID", -1)  
%>

<div class="modal inmodal" id="mdlTransportista" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>
              
                <h4 class="modal-title">Agregar transportista</h4>
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
                                    <label class="col-sm-2 control-label">Transportista:</label>    
                                    <div class="col-sm-10 m-b-xs">
                                                            <%
                            var sCondicion = "Prov_Habilitado = 1 and Prov_EsPaqueteria = 1"
                            CargaCombo("ProvGuia_ID","class='form-control'","Prov_ID","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"Selecciona")
                        %>

                         </div>
                </div>
               <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar"  data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="Guardar()">Guardar</button>
				</div>

   		      </div>
        </div>
    </div>
</div>
                            
<script type="application/javascript">
 
    $(document).ready(function(){
		 
		$('.btnCerrar').click(function(e) {
		  $("#mdlTransportista").modal('hide');
		});
     });
	 	
	    function Guardar(){
        
		$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
		{Man_ID:<%=Man_ID%>,
		Prov_ID:$('#ProvGuia_ID').val(),
		Tarea:11
		},
		function(data){
       	$("#mdlTransportista").modal('hide').remove();
		ManifiestoFunciones.CargaTerminados();
	    });
		}

    
   </script>
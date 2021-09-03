<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
    var IDUsuario = Parametro("IDUsuario", -1)  

    var InsO_Nombre = ""
    var InsO_Descripcion = ""
    var InsO_Icono = ""
	var InsO_ID = Parametro("InsO_ID",-1)
	var For_ID = Parametro("For_ID",18)
    var InsT_Nombre = ""
	var InsT_Descripcion = ""
    var Asuntos = 0
 	var TA_ID = Parametro("TA_ID",-1)
    var TA_Folio = Parametro("TA_Folio","")
    var CliOC_ID = Parametro("CliOC_ID",-1)
    var OC_ID = Parametro("OC_ID",-1)
    var OV_ID = Parametro("OV_ID",-1)
    var OV_Folio = Parametro("OV_Folio","")
    var Cli_ID = Parametro("Cli_ID",-1)
    var CCgo_ID = Parametro("CCgo_ID",-1)
    var Prov_ID = Parametro("Prov_ID",-1)
    var Pt_ID = Parametro("Pt_ID",-1)
    var Tag_ID = Parametro("Tag_ID",-1)
    var Man_ID = Parametro("Man_ID",-1)
    var ManD_ID = Parametro("ManD_ID",-1)
    var Inv_ID = Parametro("Inv_ID",-1)
    var Lot_ID = Parametro("Lot_ID",-1)


%>

<div class="modal inmodal" id="mdlIncidencias" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>
              
                <h4 class="modal-title">Nueva incidencia</h4>
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
             <%/*%>   <%
				if(InsO_ID==-1){
					%><%*/%>
                <div class="form-group">
                        <label class="control-label col-md-3"><strong>Origen</strong></label>
                         <div class="col-md-9">
                            <%
                            var sCondicion = ""//"InsT_Padre = 0"
                            var campo = "InsO_Nombre"
                            
                            CargaCombo("cboInsO_ID","class='form-control'","InsO_ID",campo,"Incidencia_Originacion",sCondicion,"","Editar",0,"Selecciona")%>
                         </div>
                </div>
<%/*%><%
				}else{
 %>
                              
                <input  type="hidden" value="<%=InsO_ID%>" class="agenda InsO_ID" id="InsO_ID"/>

<%			
				}
%><%*/%>
             <div class="form-group" id="divPadre">
                        <label class="control-label col-md-3" id="lblPadre"><strong>Tipo</strong></label>
                         <div class="col-md-9">
                            <%
                            var sCondicion = "InsT_Padre = 0"
                            var campo = "InsT_Nombre"
                            
                            CargaCombo("InsT_ID","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")%>
                         </div>
             </div>
            
                  <div class="form-group" id="divHijo">
                    
                         </div>

                 <div class="form-group" id="divFormulario1">
                    
                </div>
             </div>
                                                                
           
         
        </div>
    </div>
</div>
                            
<script type="application/javascript">
 
    $(document).ready(function(){
  var ventana = $("#VentanaIndex").val() 
		if(ventana==2529||ventana==603){
		$('#cboInsO_ID').val('2')
		$('#InsT_ID').val('10')
		  
    	   var sDatos    = "InsT_Padre=" +10	 
	      	      sDatos += "&InsO_ID="+$('#cboInsO_ID').val()
			   	  sDatos += "&Tarea="+1
		$("#divHijo").load("/pz/wms/Proveedor/Incidencias/Incidencias_Formulario.asp?" + sDatos)
		 $("#divPadre").hide()
		}
		if(ventana==303){
		$('#cboInsO_ID').val('3')
		$('#InsT_ID').val('12')
		  
    	   var sDatos    = "InsT_Padre=" +12
	    		  sDatos += "&InsO_ID="+$('#cboInsO_ID').val()	 
			   	  sDatos += "&Tarea="+1
		$("#divHijo").load("/pz/wms/Proveedor/Incidencias/Incidencias_Formulario.asp?" + sDatos)
		 $("#divPadre").hide()
		}
		 $('#cboInsO_ID').change(function(e) {
 			$('#InsO_ID').val($('#cboInsO_ID').val())
		 });
		 $('#InsT_ID').change(function(e) {
            e.preventDefault()
	
    	   var sDatos    = "InsT_Padre=" + $(this).val();	 
		     	  sDatos += "&InsO_ID="+$('#cboInsO_ID').val()
			   	  sDatos += "&Tarea="+1
		$("#divHijo").load("/pz/wms/Proveedor/Incidencias/Incidencias_Formulario.asp?" + sDatos)
		 $("#divPadre").hide()
		 
		
         });
		 	
   });
   </script>
<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var IDUsuario = Parametro("IDUsuario", -1)  
    var InsT_ID = Parametro("InsT_ID", -1)  

    var InsO_Nombre = ""
    var InsO_Descripcion = ""
    var InsO_Icono = ""
    var InsO_ID = ""
    var InsT_Nombre = ""
	var InsT_Descripcion = ""
    var Asuntos = 0
	var Procedencia =  Parametro("Procedencia", "") 
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	
	Response.Write(Procedencia)

	sSQL = "SELECT InsT_TipoMedicionCG29 FROM Incidencia_TIpo WHERE InsT_ID="+InsT_ID
	var rsMedida = AbreTabla(sSQL,1,0)
	var Medida = 0
	if(!rsMedida.EOF){
	 Medida = rsMedida.Fields.Item("InsT_TipoMedicionCG29").Value
	}

%>

<div class="modal inmodal" id="mdlIncidencias" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>
                <h4 class="modal-title">  Nuevo tipo de incidencia</h4>
                       <div class="form-group">
                   	   <div class="col-md-12">
                          <br/>
                   	   </div>
                    </div>
                  <div class="form-group">
                    <label class="control-label col-md-3"><strong>Nombre</strong></label>
                       <div class="col-md-9">
                           <input class="form-control Nombre" placeholder=""></input>
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
                  <div class="form-group" id="divHijo">

                        <label class="control-label col-md-3"><strong>Tipo</strong></label>
                         <div class="col-md-9">
<%
							if(Procedencia ==""){

                            var sCondicion = "InsT_Padre = 0"
                            var campo = "InsT_Nombre"
                            
                            CargaCombo("InsT_Padre","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")
						
						}else{
%>
                      <span class="text-left">  <label class="control-label col-md-9"><strong><%=Procedencia%></strong></label> </span>
<%
						}
%>
                         </div>
             </div>
							
                    <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                 <div class="form-group">
                        <label class="control-label col-md-3"><strong>Medida</strong></label>
                         <div class="col-md-9">
                            <%
                         var sEventos = "class='form-control combman'"
                                ComboSeccion("CboCat_ID29", sEventos, 29, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                         </div>
                </div>
                       <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                          <div class="form-group" id="divMedida">
                   		
                           </div>
			<div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
    		        <div class="form-group">
            	       <label  class="control-label col-md-3"><strong>Horas de atenci&oacute;n</strong></label>
                		<div class="col-md-3">
                    	<input class="form-control agenda" id="InsT_SLAAtencion" placeholder="" type="number" min="1" autocomplete="off" value="1" /> <br/>
                 		</div>
                     </div>
                 	<div class="form-group">
                         <label class="control-label col-md-3"><strong>Horas de resoluci&oacute;n</strong></label>
                		<div class="col-md-3">
                    	<input class="form-control agenda" id="InsT_SLAResolucion" placeholder="" type="number" min="1" autocomplete="off" value="1" /> <br/>
                	</div>
               	 	</div>
                      
                        <br />
                       	<div class="form-group">

                    
             
            	 	</div>
                      <div class="form-group">
                        <label class="control-label col-md-3"><strong>Formulario problema</strong></label>
                         <div class="col-md-9">
                            <%
                            var sEventos = "class='form-control combman'"
                            var sCondicion = "For_SoloIncidencias =1 AND For_Nombre NOT LIKE '%Comentarios%'"
                           
                            CargaCombo("For_ID_Problema",sEventos,"For_ID","For_Nombre","Formato",sCondicion,"","Editar",0,"--Seleccionar--")
                       
							%>
                         </div>
              		    </div>
                     <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                      <div class="form-group">
                        <label class="control-label col-md-3"><strong>Formulario comentarios</strong></label>
                         <div class="col-md-9">
                            <%
                            var sEventos = "class='form-control combman'"
                            var sCondicion = "For_SoloIncidencias =1 AND For_Nombre LIKE '%Comentarios%'"
                           
                            CargaCombo("For_ID_Comentarios",sEventos,"For_ID","For_Nombre","Formato",sCondicion,"","Editar",0,"--Seleccionar--")
                       
							%>
                         </div>
              		    </div>
            </div>
                                                                
            <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                <button type="button" class="btn btn-primary btnGuardar">Guardar</button>
            </div>
        </div>
    </div>
</div>

    
<script type="application/javascript">

    $(document).ready(function(){
			
<%
	if(InsT_ID >-1){
		%>
			$("#Padre").val(<%=InsT_ID%>)
			$("#CboCat_ID29").val(<%=Medida%>)
				    var Params = "?Tipo_Medida=" + $('#CboCat_ID29').val()
                   Params += "&Lpp=1"  //este parametro limpia el cache
               
         $("#divMedida").load("/pz/wms/Incidencias/Incidencias_Tipo_Modal_combos.asp" + Params)        
			<%
	}
		%>
		$('#CboCat_ID29').change(function(e) {   
		e.preventDefault()   	  
            var Params = "?Tipo_Medida=" + $('#CboCat_ID29').val()
                   Params += "&Lpp=1"  //este parametro limpia el cache
               
         $("#divMedida").load("/pz/wms/Incidencias/Incidencias_Tipo_Modal_combos.asp" + Params)        
    });
	$('#For_ID_Problema').change(function(e){   
		e.preventDefault()   	  
				$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
			{
					 For_ID:$('#For_ID_Problema').val(),
					Tarea:20
			},function(data){
				var response = JSON.parse(data)
				$('#For_ID_Comentarios').val(response.result)
				});
    });
		 $('#InsT_Padre').change(function(e) {
            e.preventDefault()
    	   var sDatos    = "InsT_Padre=" + $(this).val();	 
			   	  sDatos += "&Tarea="+1
		$("#divHijo").load("/pz/wms/Incidencias/Incidencias_Formulario.asp?" + sDatos)
         });
		
		 $('.btnCerrar').click(function(e) {   
		   $("#mdlIncidencias").modal('hide').remove();
		 });
		
		$('.btnGuardar').click(function(e) {   
			e.preventDefault()   	 
					
		
				$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
//				InsT_TipoMedicionCG29:$('#CboCat_ID29').val()
//			}
				{
		  		   InsT_TipoMedicionCG29:$('#CboCat_ID29').val(),
				   InsT_Padre: $('#Padre').val(),
               	   InsT_Nombre: encodeURIComponent($('.Nombre').val()),
               	   InsT_Descripcion:encodeURIComponent($('.Descripcion').val()),
			   	   InsT_EstrellasCG33: $('.Estrellas').val(),
               	   InsT_MoScoWCG24: $('.MoScoW').val(),
               	   InsT_TipoCG28:$('.Prioridad_Orden').val(),
               	   InsT_SeveridadCG26:$('.Severidad').val(),
               	   InsT_PrioridadCG27:$('.Prioridad').val(),
               	   InsT_PrioridadABC:$('#InsT_PrioridadABC').val(),
               	   InsT_Orden:$('#InsT_Orden').val(),
				   InsT_SLAAtencion:$('#InsT_SLAAtencion').val(),
				   InsT_SLAResolucion:$('#InsT_SLAResolucion').val(),
				   InsT_Problema_For_ID:$('#For_ID_Problema').val(),
				   InsT_Comentarios_For_ID:$('#For_ID_Comentarios').val(),
               	   InsT_TallaCG25:$('.Talla').val(),
               	   Tarea: 3
				}
		   , function(data, Evento){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
		    });
    	   $("#mdlIncidencias").modal('hide').remove();
if( $("#Padre").val()==0){
	   $('#Contenido').load("/pz/wms/Incidencias/B_Incidencias.asp")
	
}else{
			   	   var sDatos  = "?InsT_ID=" + $("#Padre").val();	 
			   	   sDatos  += "&Procedencia=" + $("#Padre").val();
			   	   sDatos += "&Tarea="+1

	   $('#divHijos').load("/pz/wms/Incidencias/B_Incidencias_Hijos.asp"+ sDatos)
}
    });
	
  });
   </script>
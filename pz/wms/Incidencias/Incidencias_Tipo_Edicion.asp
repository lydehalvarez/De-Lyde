<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   

    var InsT_ID = Parametro("InsT_ID", -1)  
	var Procedencia =  Parametro("Procedencia", "") 
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")
	Procedencia = Procedencia.replace("-","/")

var sSQL = "SELECT * FROM Incidencia_Tipo WHERE InsT_ID=" + InsT_ID
var rsIncidencias = AbreTabla(sSQL, 1,0)

var Nombre = rsIncidencias.Fields.Item("InsT_Nombre").Value
var Descripcion = rsIncidencias.Fields.Item("InsT_Descripcion").Value
var Medida = rsIncidencias.Fields.Item("InsT_TipoMedicionCG29").Value
var Atencion =  rsIncidencias.Fields.Item("InsT_SLAAtencion").Value
var Resolucion = rsIncidencias.Fields.Item("InsT_SLAResolucion").Value
var Problema =  rsIncidencias.Fields.Item("InsT_Problema_For_ID").Value
var Comentarios = rsIncidencias.Fields.Item("InsT_Comentarios_For_ID").Value
var Prioridad = rsIncidencias.Fields.Item("InsT_PrioridadCG33").Value
var Severidad = rsIncidencias.Fields.Item("InsT_SeveridadCG32").Value
var Estrellas = rsIncidencias.Fields.Item("InsT_EstrellasCG33").Value
var PrioridadABC = rsIncidencias.Fields.Item("InsT_PrioridadABC").Value
var Orden = rsIncidencias.Fields.Item("InsT_Orden").Value
var MoScoW = rsIncidencias.Fields.Item("InsT_MoScoWCG24").Value
var Prioridad_Orden = rsIncidencias.Fields.Item("InsT_TipoCG28").Value 
var Talla = rsIncidencias.Fields.Item("InsT_TallaCG25").Value 

%>

<div class="form-horizontal" id="toPrint">
        <div class="wrapper wrapper-content  animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>Editar tipo de incidencia</h5>
                            <div class="ibox-tools">
                            </div>
                        </div>
                        <div class="ibox-content">

                            <div class="m-b-lg">

                        <div class="form-group">
                    <label class="control-label col-md-3"><strong>Nombre</strong></label>
                       <div class="col-md-9">
                           <input class="form-control Nombre" value = "" placeholder=""></input>
                       </div>
              		 </div>
                 <div class="form-group">
                    <label class="control-label col-md-3"><strong>Descripci&oacute;n</strong></label>
                       <div class="col-md-9">
                           <textarea class="form-control Descripcion" value = "" placeholder=""></textarea>
                       </div>
                </div>
                <div class="form-group" id="divHijo">

                        <label class="control-label col-md-3"><strong>Pertenece a:</strong></label>
                         <div class="col-md-3">
<%
							if(Procedencia ==""){

                            var sCondicion = "InsT_Padre = 0"
                            var campo = "InsT_Nombre"
                            
                            CargaCombo("InsT_Padre","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Cambiar")
						
						}else{
%>
                      <span class="text-left">  <label class="control-label col-md-9"><strong><%=Procedencia%></strong></label> </span>
<%
						}
%>
                         </div>
             	</div>
                   <div class="form-group">
                        <label class="control-label col-md-3"><strong>Medida</strong></label>
                         <div class="col-md-3">
                            <%
                         var sEventos = "class='form-control combman'"
                                ComboSeccion("CboCat_ID29", sEventos, 29, -1, 0, "--Seleccionar--", "", "Editar")
							%>
                         </div>
                	</div>
               
                 <div class="form-group" id="divMedida">
                   		
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
                 <div class="form-group">
                        <label class="control-label col-md-3"><strong>Formulario problema</strong></label>
                         <div class="col-md-5">
                            <%
                            var sEventos = "class='form-control combman'"
                            var sCondicion = "For_SoloIncidencias =1 AND For_Nombre NOT LIKE '%Comentarios%'"
                           
                            CargaCombo("For_ID_Problema",sEventos,"For_ID","For_Nombre","Formato",sCondicion,"","Editar",0,"--Seleccionar--")
                       
							%>
                         </div>
              	  </div>
                <div class="form-group">
                        <label class="control-label col-md-3"><strong>Formulario comentarios</strong></label>
                         <div class="col-md-5">
                            <%
                            var sEventos = "class='form-control combman'"
                            var sCondicion = "For_SoloIncidencias =1 AND For_Nombre LIKE '%Comentarios%'"
                           
                            CargaCombo("For_ID_Comentarios",sEventos,"For_ID","For_Nombre","Formato",sCondicion,"","Editar",0,"--Seleccionar--")
                       
							%>
                         </div>
              	 </div>
                   <div class="modal-footer">
                        <button type="button" class="btn btn-white btnCerrar">Cerrar</button>
                        <button type="button" class="btn btn-primary btnGuardar">Actualizar</button>
           		  </div>
                                <!--<div class="m-t-md">

                                    <div class="pull-right">
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-comments"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-user"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-list"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-pencil"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-print"></i> </button>
                                        <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-cogs"></i> </button>
                                    </div>

                              <strong> 61 incidencias encontradas.</strong>


                                </div>-->

                            </div>

                            
                        </div>

                    </div>
                </div>
            </div>


        </div>
        

     </div>



              <input  type="hidden" value="<%=InsT_ID%>" class="agenda Padre" id="Padre"/>
    
<script type="application/javascript">

    $(document).ready(function(){

$('.Nombre').val('<%=Nombre%>')
$('.Descripcion').val('<%=Descripcion%>')
$('#CboCat_ID29').val('<%=Medida%>')
$('#InsT_SLAAtencion').val('<%=Atencion%>')
$('#InsT_SLAResolucion').val('<%=Resolucion%>')
$('#For_ID_Problema').val('<%=Problema%>')
$('#For_ID_Comentarios').val('<%=Comentarios%>')
DatosMedida()

$('#CboCat_ID29').change(function(e) {   
		e.preventDefault()   	  
            var Params = "?Tipo_Medida=" + $('#CboCat_ID29').val()
               
         $("#divMedida").load("/pz/wms/Incidencias/Incidencias_Tipo_Modal_combos.asp" + Params)        
    });
		 $('#InsT_Padre').change(function(e) {
            e.preventDefault()
    	   var sDatos    = "InsT_Padre=" + $(this).val();	 
			   	  sDatos += "&Tarea="+1
		$("#divHijo").load("/pz/wms/Incidencias/Incidencias_Formulario.asp?" + sDatos)
         });
		 
			
				$('.btnGuardar').click(function(e) {   
			e.preventDefault()   	 
			
			var T_Incidencia=$('.InsT_IDPadre').val()

			if(T_Incidencia >0){
			}else{
			 T_Incidencia = 0
			}
				
				
		
				$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
//				InsT_TipoMedicionCG29:$('#CboCat_ID29').val()
//			}
				{
				   InsT_ID:<%=InsT_ID%>,
		  		   InsT_TipoMedicionCG29:$('#CboCat_ID29').val(),
				   InsT_Padre: T_Incidencia,
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
               	   Tarea: 12
				}
		   , function(data, Evento){
	
			sTipo = "info";
			sMensaje = "El registro se ha actualizado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
		    });
    	//   $('#Contenido').load("/pz/wms/Incidencias/B_Incidencias.asp")
    }); 
			$('.btnCerrar').click(function(e) {   
			e.preventDefault()   	
			$('#Contenido').load("/pz/wms/Incidencias/B_Incidencias.asp")  
			});
});
	
		
		
	
	function DatosMedida(){
			 var Params = "?Tipo_Medida=" + <%=Medida%>
					Params += "&Estrellas="+<%=Estrellas%>
					Params += "&MoScoW="+<%=MoScoW%>
					Params += "&Prioridad_Orden="+<%=Prioridad_Orden%>
					Params += "&Severidad="+<%=Severidad%>
					Params += "&PrioridadABC="+<%=PrioridadABC%>
					Params += "&Orden="+<%=Orden%>
					Params += "&Prioridad="+<%=Prioridad%>
					Params += "&Talla="+<%=Talla%>
               
         $("#divMedida").load("/pz/wms/Incidencias/Incidencias_Tipo_Edicion_combos.asp" + Params)        	
	}

   </script>
	<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Ins_ID = Parametro("Ins_ID",-1)
var Ins_IDT = Parametro("Ins_IDT",-1)
var IDUsuario = Parametro("IDUsuario",-1)
var SegGrupo = Parametro("SegGrupo",-1)
var Subtarea = Parametro("Subtarea",-1)
%>

    <div class="form-horizontal" id="toPrint">
        <div class="wrapper wrapper-content  animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h3>Lista Tareas Asignadas</h3>
                            <div class="ibox-tools">
                         <span class="pull-left"><a  class="text-muted btnRegresar"  onclick="javascript:CargaInicio();  return false">
                          <h3><i class="fa fa-refresh"></i> &nbsp;  <strong>Inicio</strong></h3></a></span>     

                            <%
									if(Subtarea==1){
										%>
                           <button class="btn btn-primary btn-s btnTarea" data-insid="<%=Ins_ID%>"> + Nueva Subtarea</button>
							<%
								}else{
								%>
                                
                                <button class="btn btn-primary btn-s btnTarea" data-insid="<%=Ins_ID%>"> + Nueva Tarea</button>
	                      	<%
								}
								%>
                            </div>
                        </div>
                        <div class="ibox-content">

                            <div class="m-b-lg">

                                
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
                                <%

						var sSQL = "SELECT *, Cat_Nombre as ESTATUS,"
										+ "  CONVERT(VARCHAR(17), getdate(), 103) AS Hoy,  "
										+ "  CONVERT(VARCHAR(17), Ins_FechaInicio_Tarea, 103) AS FechaInicio_Tarea,  "
										+" CONVERT(VARCHAR(17), Ins_FechaEntrega_Tarea, 103) AS FechaEntrega_Tarea"
										+" FROM Incidencia i, Cat_Catalogo ct WHERE  i.Ins_EstatusCG27 = ct.Cat_ID AND ct.Sec_ID = 27 AND i.Ins_Padre = "+Ins_ID
								// Area Asunto Descripcion Asignados Fecha comienzo Fecha Entrega +Subtarea +Involucrados
		
							var rsIncidencias = AbreTabla(sSQL,1,0)
							if(!rsIncidencias.EOF){
						
								%>
                        
                            <div class="table-responsive" id = "divHijos">
                            <table class="table table-hover issue-tracker">
                                <tbody>
                                  <tr>
              		   <td class="project-title">
                       <strong> <spa>TAREA</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>DESCRIPCION</spa></strong>
                       </td>

              		   <td class="project-title">
                       <strong> <spa>ASIGNADOS</spa></strong>
                       </td>
                        <td class="project-title">
                       <strong> <spa>FECHA INICIO</spa></strong>
                       </td>
                         <td class="project-title">
                       <strong> <spa>FECHA ENTREGA</spa></strong>
                       </td>
                          <td class="project-title">
                       <strong> <spa>ESTATUS</spa></strong>
                       </td>
                            <td class="project-title">
                       <strong> <spa>SUB TAREAS</spa></strong>
                       </td>
                       
                       </tr>
                                <%

							while (!rsIncidencias.EOF){
							var iEstatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value
							var Hoy = rsIncidencias.Fields.Item("Hoy").Value
							var FechaEntrega = rsIncidencias.Fields.Item("FechaEntrega_Tarea").Value

                
        var  ClaseEstatus = "plain"
          switch (parseInt(iEstatus)) {
	 		
	 		case 1:
                 ClaseEstatus = "success"   
            break;    
            case 2:
                ClaseEstatus = "warning"
            break;     
            case 4:
                ClaseEstatus = "primary"
            break;    
            case 3:
                ClaseEstatus = "warning"
            break;   
            case 5:
                ClaseEstatus = "danger"
            break;        
            }   
				if(Hoy>FechaEntrega && iEstatus != 4){
	                ClaseEstatus = "danger"

				}
								
								var Ins_ID = rsIncidencias.Fields.Item("Ins_ID").Value
								var sSQL = "SELECT count(*) as subtareas FROM Incidencia i WHERE i.Ins_Padre = "+Ins_ID
							// Area Asunto Descripcion Asignados Fecha comienzo Fecha Entrega +Subtarea +Involucrados
		
							var rsSubtareas = AbreTabla(sSQL,1,0)

%>


                                <tr>
                                    
                                    <td class="project-title">
                                        <a href="#"  class="btnCargaHijos" onclick="VerSubTareas(<%=Ins_ID%>)">
          								 <%=rsIncidencias.Fields.Item("Ins_Asunto").Value%>
                                        </a>
                                    </td>
                                    <td class="project-title">
                                        <a href="#"  class="btnCargaHijos" onclick="VerSubTareas(<%=Ins_ID%>)">
          								 <%=rsIncidencias.Fields.Item("Ins_Descripcion").Value%>
                                        </a>
                                    </td>

                                     <td>
                                     <a>
                                     <%
									 sSQL=" SELECT   dbo.fn_Usuario_DameNombreUsuario(Ins_Usu_Recibe) as usuario "
									 		+ " FROM Incidencia WHERE Ins_ID= "+ Ins_ID
	 								var rsInvol = AbreTabla(sSQL,1,0)
%>
		 								<%=rsInvol.Fields.Item("usuario").Value%>        <br /> <br />   

<%
									sSQL = "SELECT   *, dbo.fn_Usuario_DameNombreUsuario(Ins_UsuarioID) as usuario "
											+" FROM  Incidencia_Involucrados i "
											+" LEFT JOIN SeguridadGrupo g ON i.Ins_GrupoID=g.Gru_ID"
											+" INNER JOIN Cat_Catalogo c ON c.Cat_ID = i.Ins_TipoInvolucradoCG26 AND c.Sec_ID=26"
											+" WHERE Ins_ID="+Ins_ID
											
										//Response.Write(sSQL)
								var rsInvol = AbreTabla(sSQL,1,0)
								
          while (!rsInvol.EOF){

			 if(rsInvol.Fields.Item("Ins_GrupoID").Value>-1){
				 IDUsuario =-1
				SegGrupo = 1
  		  %>
		 	<%=rsInvol.Fields.Item("Gru_Nombre").Value%>        <br />  <br />  
		<%
             }else{
				 IDUsuario =1
				SegGrupo = -1
		 %>
 	          <%=rsInvol.Fields.Item("usuario").Value%>        <br />  <br />
         <%
			 }
        rsInvol.MoveNext() 
         }
        rsInvol.Close()   
        %>
    </a>
                                    </td>
                                      <td class="project-title">
                                        <a href="#"  class="btnCargaHijos" onclick="VerSubTareas(<%=Ins_ID%>)">
                                        <%
									var FechaInicio = 	rsIncidencias.Fields.Item("FechaInicio_Tarea").Value
										%>
          								 <%=FechaInicio%>
                                        </a>
                                    </td>
                                      <td class="project-title">
                                        <a href="#"  class="btnCargaHijos" onclick="VerSubTareas(<%=Ins_ID%>)">
          								 <%=FechaEntrega%>
                                        </a>

                                    </td>
                                          <td class="project-title">
                                        <a href="#"  class="btnCargaHijos" onclick="VerSubTareas(<%=Ins_ID%>)">
          								  <span class="label label-<%=ClaseEstatus%>"><%=rsIncidencias.Fields.Item("ESTATUS").Value%></span>
                                        </a>
                                    </td>
                                    <td>
                                        <a href="#"  class="btnCargaHijos" onclick="VerSubTareas(<%=Ins_ID%>)">
          								 <%=rsSubtareas.Fields.Item("subtareas").Value%>
                                        </a>
                                    </td>
                                <td class="text-right">
                                       <button class="btn btn-white btn-xs btnSubtarea" data-insid="<%=Ins_ID%>"> + SUBTAREA</button>
                                       <button class="btn btn-white btn-xs btnAsignado" data-insid="<%=Ins_ID%>"> + ASIGNADOS</button>

                                 <!--       <button class="btn btn-white btn-xs"> Mag</button>
                                        <button class="btn btn-white btn-xs"> Rag</button>
-->                                 </td>
                             
                                </tr>
                                <%
								  rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
								%>
                                </tbody>
                            </table>
                            </div>
                            <%
							}
							%>
                               <div id="divNuevaTarea">
                           	</div>
                            <div id="divAsignados">
                           	</div>
                        </div>

                    </div>
                </div>
            </div>


        </div>
        

     </div>
                         <input type="hidden" value="<%=Ins_IDT%>" class="agenda" id="Ins_IDTarea"/>

<script>
   $(document).ready(function(){
        $('.btnAsignado').click(function(e) {
   				e.preventDefault()
				
				var insid=$(this).data('insid')
	          $("#divAsignados").show('slow')
			        var dato = {
					 Ins_ID:insid,
 					 Ins_ID_Asignados:insid,
					 IDUsuario:<%=IDUsuario%>,
					 SegGrupo:<%=SegGrupo%>
            }
            $("#divAsignados").load("/pz/wms/Incidencias/Incidencia_Involucrados.asp"
                               , dato
                               , function(){
            });  
            });
		$('.btnSubtarea').click(function(e) {
   				e.preventDefault()
				 $("#divNuevaTarea").show('slow')
				var insid=$(this).data('insid')
         
			         var dato = {
                     InsO_ID:12,
					 Ins_ID:insid,
					 Subtarea:1,
					 IDUsuario:<%=IDUsuario%>,
					 SegGrupo:<%=SegGrupo%>
            }
            $("#divNuevaTarea").load("/pz/wms/Incidencias/Incidencias_Formulario_Tarea.asp"
                               , dato
                               , function(){
								$('html, body').animate({ scrollTop: $('#divNuevaTarea').offset().top }, 'slow');
            });  
            });
			
			$('.btnTarea').click(function(e) {
   				e.preventDefault()
				   $("#divNuevaTarea").show('slow')
				var insid=$(this).data('insid')
         
			         var dato = {
                     InsO_ID:12,
					 Ins_ID:insid,
					 IDUsuario:<%=IDUsuario%>,
					 SegGrupo:<%=SegGrupo%>
            }
            $("#divNuevaTarea").load("/pz/wms/Incidencias/Incidencias_Formulario_Tarea.asp"
                               , dato
                               , function(){
							$('html, body').animate({ scrollTop: $('#divNuevaTarea').offset().top }, 'slow');
            });  
            });

});



function Involucrados(insid){
                 var dato = {
					 Ins_ID:insid,
					 Ins_ID_Asignados:insid,
					 IDUsuario:<%=IDUsuario%>,
					 SegGrupo:<%=SegGrupo%>
            }
            $("#divAsignados").load("/pz/wms/Incidencias/Incidencia_Involucrados.asp"
                               , dato
                               , function(){
            });  
            }
	</script>
 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
	var SegGrupo = Parametro("SegGrupo",-1)
	var Reporta = Parametro("Reporta",-1)
	var Recibe = Parametro("Recibe",-1)

var sSQL = "SELECT *,   dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Reporta ) as REPORTA "
                +  " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Recibe ) as RECIBE "
				+ "  , dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) Cat_Nombre"
				+ "  , dbo.fn_CatGral_DameDato(33,InsT_PrioridadCG33) Prioridad"
				+ "  , dbo.fn_CatGral_DameDato(32,InsT_SeveridadCG32) Severidad"
				+  " FROM Incidencia i INNER JOIN Incidencia_Tipo t ON i.InsT_ID=t.InsT_ID WHERE i.Ins_ID = " + Ins_ID 
					//Response.Write(sSQL)
				    var rsIncidencias = AbreTabla(sSQL,1,0)

					var InsO_ID = rsIncidencias.Fields.Item("InsO_ID").Value
					var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
					var Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Atendio = rsIncidencias.Fields.Item("RECIBE").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var Problema = rsIncidencias.Fields.Item("Ins_Problema").Value
					var Causa = rsIncidencias.Fields.Item("Ins_Causa").Value
					var Problema = rsIncidencias.Fields.Item("Ins_Problema").Value
					var Causa = rsIncidencias.Fields.Item("Ins_Causa").Value
					var UltimaActualizacion = rsIncidencias.Fields.Item("Ins_FechaUltimaModificacion").Value
					var FechaLiberada = rsIncidencias.Fields.Item("Ins_Tarea_FechaLIberada").Value
					var Estatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value
					var Prioridad = rsIncidencias.Fields.Item("Prioridad").Value
					var Severidad = rsIncidencias.Fields.Item("Severidad").Value

				
		sSQL = "SELECT InsT_Comentarios_For_ID FROM Incidencia_Tipo WHERE InsT_ID = " + InsT_ID
		var rsInsNombre = AbreTabla(sSQL,1,0)

		var For_ID=rsInsNombre("InsT_Comentarios_For_ID").Value
		
			var sSQL= " SELECT For_Archivo FROM Formato  WHERE For_ID=" + For_ID
			rsFormulario = AbreTabla(sSQL,1,0)

		var Formulario=rsFormulario("For_Archivo").Value
		
					var sSQL= " SELECT * FROM Incidencia_Involucrados  WHERE Ins_GrupoID=" + SegGrupo
									+ " OR Ins_UsuarioID = " + IDUsuario
					rsPermiso = AbreTabla(sSQL,1,0)
					if(!rsPermiso.EOF){
				//Response.Write(sSQL)
					var Permiso=rsPermiso("Ins_TipoInvolucradoCG26").Value
					}else{
					var Permiso = 4	
					}
%>


<div class="animated fadeInRight">
            <div class="mail-box-header">
        <!--        <div class="pull-right tooltip-demo">
                    <a href="mail_compose.html" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="Reply"><i class="fa fa-reply"></i> Reply</a>
                    <a href="#" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="Print email"><i class="fa fa-print"></i> </a>
                    <a href="mailbox.html" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="Move to trash"><i class="fa fa-trash-o"></i> </a>
                </div>-->
                <h2>
                   Mensaje
                </h2>
                <div class="mail-tools tooltip-demo m-t-md">


                    <h3>
                        <span class="font-normal">Asunto: </span><%=Asunto%>
                    </h3>
                    <h5>
                        <span class="pull-right font-normal"><%=Fecha%></span>
                        <span class="font-normal">De: </span><%=Emisor%>
                    </h5>
                </div>
            </div>
            </div>
                <div class="mail-box">

			<div class="form-group">

                <div class="mail-body col-md-9" id="divFormulario" >
<%/*%><%
			if(For_ID==18){
%>
    <h3><strong>ASUNTO:</strong></h3> <%=Asunto%><br />
    <h3><strong>DESCRIPCION:</strong></h3> <%=Descripcion%><br />
    <h3><strong>CAUSA:</strong></h3> <%=Causa%><br />
<%
			}	if(For_ID==19){
%>
	<h3><strong> TITULO:</strong></h3> <%=Titulo%> <br />
    <h3><strong>ASUNTO:</strong></h3> <%=Asunto%><br />
    <h3><strong>DESCRIPCION:</strong></h3> <%=Descripcion%><br />
    <h3><strong>PROBLEMA:</strong></h3> <%=Problema%><br />
    <h3><strong>CAUSA:</strong></h3> <%=Causa%><br />
<%
			}	if(For_ID==20){
%>
   	<h3><strong> TITULO:</strong></h3> <%=Titulo%> <br />
    <h3><strong>ASUNTO:</strong></h3> <%=Asunto%><br />
    <h3><strong>DESCRIPCION:</strong></h3> <%=Descripcion%><br />
         
<%	
			}
%><%*/%>
                </div>
                  
                  <div  class="col-md-3">
                  	<h4><strong> Genero:</strong></h4> <%=Emisor%> <br />
                    <h4><strong>Fecha:</strong></h4> <%=Fecha%><br />
                    <h4><strong>Atendiendo:</strong></h4> <%=Atendio%><br />
                    <h4><strong>Ultima actualizacion:</strong></h4> <%=UltimaActualizacion%><br />
                    <h4><strong>Estatus:</strong></h4> 
                         
                            <%
                            var sEventos = "class='form-control'"
                           
                                ComboSeccion("CboEstatus", sEventos, 27, -1, 0, "", "", "Editar")
                       
							%>
                 
					<br />
                    <h4><strong>Prioridad:</strong></h4> <%=Prioridad%><br />
                    <h4><strong>Severidad:</strong></h4> <%=Severidad%><br />
                    <h4><strong>Fecha liberada:</strong></h4> <%=FechaLiberada%><br />
                    <%
					if(Permiso>2){
					%>
					 <button type="button" class="btn btn-sm btn-primary Asignar" onclick="ModalAsigna()">Asignar</button>   
					 <%
                        }
                   	if(Permiso==4){
					%>
   					 <button type="button" class="btn btn-sm btn-primary Involucrados" onclick="Involucrados()">Involucrados</button>   
    				<%
					}
					%>
     <%/*%>             <%
				  		sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
						 + "UNION" 
	    				 + " SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		   	    rsAsignados = AbreTabla(sSQL,1,0)

				%>
  				
    		                <h4><strong>Asignar a:</strong></h4> 
	                                    <div>
                                        <select id="AsignarA" class="form-control">
                                            <option value="">
                                            <%= "TODOS" %>
                                            </option>
                                            <%
                                            while( !(rsAsignados.EOF)){
                                            %>
                                            <option value="<%= rsAsignados("IDUnica").Value %>">
                                            <%= rsAsignados("Nombre").Value %>
                                            </option>
                                            <%
                                            rsAsignados.MoveNext()
                                            }
                                            rsAsignados.Close()
                                        
                                            %>

                                        </select>
                               </div><%*/%>
						</div>
                  </div>
               <div class="ibox-content" id="divInvolucrados">
               </div>

            <div class="ibox-content inspinia-timeline" id="divComentarios">
                  </div>
                      <!--  <div class="mail-body text-right tooltip-demo">
                                <a class="btn btn-sm btn-white" href="mail_compose.html"><i class="fa fa-reply"></i> Reply</a>
                                <a class="btn btn-sm btn-white" href="mail_compose.html"><i class="fa fa-arrow-right"></i> Forward</a>
                                <button title="" data-placement="top" data-toggle="tooltip" type="button" data-original-title="Print" class="btn btn-sm btn-white"><i class="fa fa-print"></i> Print</button>
                                <button title="" data-placement="top" data-toggle="tooltip" data-original-title="Trash" class="btn btn-sm btn-white"><i class="fa fa-trash-o"></i> Remove</button>
                        </div>-->
                        <div class="clearfix"></div>


                </div>
                <div class="ibox-content inspinia-timeline" id = "divTareas">
				<%
				sSQL = "SELECT *,   dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Reporta ) as REPORTA "
                +  " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Recibe ) as RECIBE "
				+ " ,  CONVERT(VARCHAR(20), Ins_FechaRegistro, 103) AS Fecha "
				+ " ,  CONVERT(VARCHAR(10),ISNULL(Ins_FechaRegistro ,dateadd(minute,90,Ins_FechaRegistro)), 108) AS Hora "
				+  " FROM Incidencia i RIGHT OUTER JOIN incidencia_Comentario c ON i.Ins_ID = c.Ins_ID WHERE Ins_Usu_Reporta = " +Reporta+ " AND Ins_Usu_Recibe = " + Recibe
				+ " ORDER BY InsCm_FechaRegistro DESC"
				//Response.Write(sSQL)
		   	    rsIncidencias = AbreTabla(sSQL,1,0)
				
				sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
						 + "UNION" 
	    				 + " SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		   	    rsAsignados = AbreTabla(sSQL,1,0)

%>
  					<div class="media-body">
                     <div class="row">
                                    <label class="col-sm-2 control-label">Asignar a:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selAsignar" class="form-control">
                                            <option value="">
                                            <%= "TODOS" %>
                                            </option>
                                            <%
                                            while( !(rsAsignados.EOF)){
                                            %>
                                            <option value="<%= rsAsignados("IDUnica").Value %>">
                                            <%= rsAsignados("Nombre").Value %>
                                            </option>
                                            <%
                                            rsAsignados.MoveNext()
                                            }
                                            rsAsignados.Close()
                                        
                                            %>

                                        </select>
                                    </div>
                      
                        <textarea class="form-control Respuesta" placeholder="Escribe una respuesta..." onkeydown= "GuardaComentario(event)"></textarea>
                        <input type="hidden" value="<%=Ins_ID%>" class="agenda" id="Ins_ID"/>
                        <input type="hidden" value="<%=Reporta%>" class="agenda" id="Reporta"/>
                        <input type="hidden" value="<%=Recibe%>" class="agenda" id="Recibe"/>

                     </div>
<%
				    while (!rsIncidencias.EOF){
					var Manda = rsIncidencias.Fields.Item("REPORTA").Value
					var Atendio = rsIncidencias.Fields.Item("RECIBE").Value
					var Fecha = rsIncidencias.Fields.Item("Fecha").Value
					var Hora = rsIncidencias.Fields.Item("Hora").Value
					var Descripcion = rsIncidencias.Fields.Item("InsCm_Observacion").Value
					var Titulo = rsIncidencias.Fields.Item("InsCm_Titulo").Value
					var Comenzo = rsIncidencias.Fields.Item("Ins_Tarea_FechaAtendida").Value
					var Termino = rsIncidencias.Fields.Item("Ins_Tarea_FechaLiberada").Value
					var Prioridad = rsIncidencias.Fields.Item("Ins_Prioridad").Value
					var Severidad = rsIncidencias.Fields.Item("Ins_Severidad").Value

%>
			    
                        <div class="timeline-item">
                            <div class="row">
                                <div class="col-xs-3 date">
                                    <i class="fa fa-briefcase"></i>
                                  <%=Fecha%>
                                    <br/>
                                    <%=Hora%>
                                    <br/>
                                    <small class="text-navy"><%=Atendio%></small>
                                </div>
                                <div class="col-xs-2 content no-top-border">
                                    <p class="m-b-xs"><strong>Prioridad:</strong></p>
                 	                  <p><small class="text-navy"><%=Prioridad%></small></p>
                                      <br />
                                    <p class="m-b-xs"><strong>Severidad:</strong></p>
                 	                  <p><small class="text-navy"><%=Severidad%></small></p>
                                       </p>

<!--                           			 <p><span data-diameter="40" class="updating-chart">5,3,9,6,5,9,7,3,5,2,5,3,9,6,5,9,4,7,3,2,9,8,7,4,5,1,2,9,5,4,7,2,7,7,3,5,2</span></p>-->                                </div>
                                <div class="col-xs-7 content no-top-border">
                                    <p class="m-b-xs"><strong><%=Titulo%></strong></p>

                                    <p><%=Descripcion%>
                                    </p>
          <small class="text-navy">De: <%=Manda%> | Desde: <%=Fecha%> <BR />Comenzo: <%=Comenzo%> <BR /> Termino: <%=Termino%> </small>
<!--                           			 <p><span data-diameter="40" class="updating-chart">5,3,9,6,5,9,7,3,5,2,5,3,9,6,5,9,4,7,3,2,9,8,7,4,5,1,2,9,5,4,7,2,7,7,3,5,2</span></p>-->                                </div>
                            </div>
                        </div>
                    <%	
        rsIncidencias.MoveNext() 
        }
    rsIncidencias.Close()  

%>
            </div>
	</div>
    </div>
 
<script type="application/javascript">

   $(document).ready(function(){
	$("#divTareas").hide()
	$("#CboEstatus").val('<%=Estatus%>')
	$("#divFormulario").load("<%=Formulario%>")

	$("#divComentarios").load("/pz/wms/Proveedor/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID="+ <%=Ins_ID%>+"&Reporta="+<%=Reporta%>+"&Recibe="+<%=Recibe%>+"&InsO_ID="+<%=InsO_ID%>+"&Permiso="+ <%=Permiso%>)

	$('#CboEstatus').change(function(e) {   
    $.ajax({
                  url: "/pz/wms/Proveedor/Incidencias/Incidencias_Ajax.asp"
                , method: "post"
                , async: false
                , data: {
                     Estatus: $("#CboEstatus").val(),
					 Ins_ID: <%=Ins_ID%>,
					 Tarea:13
                }
                , success: function(res){
			sTipo = "info";
			sMensaje = "El estatus se ha actualizado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
                }
            });
	});


});
	function Cerrar(){
		$('#divInvolucrados').empty()
		$('#T_Involucrado').val('')
		$('#Involucrado').val('')
	}
		function ModalAsigna(){
              	$("#mdlAsignar").modal('hide').remove();

            $.ajax({
                  url: "/pz/wms/Proveedor/Incidencias/Incidencias_Modal_Asigna.asp"
                , method: "post"
                , async: false
                , data: {
                     InsO_ID: <%=InsO_ID%>,
					 Ins_ID: <%=Ins_ID%>
					  // Modal 
                }
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });
			$("#mdlAsignar").modal('show');
    }
					function Involucrados(){
                 var dato = {
                     InsO_ID:<%=InsO_ID%>,
					 Ins_ID:<%=Ins_ID%>,
					 IDUsuario:<%=IDUsuario%>,
					 SegGrupo:<%=SegGrupo%>
            }
            $("#divInvolucrados").load("/pz/wms/Proveedor/Incidencias/Incidencia_Involucrados.asp"
                               , dato
                               , function(){
            });  
            }


        
	 </script>
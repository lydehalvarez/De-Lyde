<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
    var InsO_ID = Parametro("InsO_ID", -1)  
    var Ins_ID = Parametro("Ins_ID", -1)  
	var IDUsuario = Parametro("IDUsuario",-1)
	var SegGrupo = Parametro("SegGrupo",-1)


sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
		+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica     WHERE i.InsO_ID = "+InsO_ID+" GROUP BY IDUnica, Usu_Nombre "
		+"UNION "
		+"SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica    WHERE i.InsO_ID = "+InsO_ID+" GROUP BY IDUnica, Emp_Nombre"
		   	    rsAsignados = AbreTabla(sSQL,1,0)
%>

<div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>
              
                <h4 class="modal-title">Agregar involucrados</h4>
                 <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
<!--                 	     <input type="checkbox"  class="i-checks ChkGrupos"onclick="javascript:MostrarGrupos()" > Ver grupos </input>
-->                     <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                	<div class="form-group" id="divUsuarios">
                                    <label class="col-sm-2 control-label">Usuario:</label>    
                                    <div class="col-sm-5 m-b-xs">
              							<select id="selInvolucrado" class="form-control">
                                            <option value="">
                                            <%= "--Seleccionar--" %>
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
                         </div>
                            <div class="form-group" id="divGrupos">
                                    <label class="col-sm-2 control-label">Grupo:</label>    
                                    <div class="col-sm-5 m-b-xs">
                                    <%
										var sCondicion = ""
										CargaCombo("Gru_ID","class='form-control'","Gru_ID","Gru_Nombre","SeguridadGrupo",sCondicion,"","Editar",0,"--Seleccionar--")
									%>
                         </div>
                         </div>
                          <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                     <div class="form-group" id="divPermiso">
                            <label class="control-label col-md-2"><strong>Permisos</strong></label>
                   <div class="col-md-5">
                   <%
						var sEventos = "class='form-control combman'"
						ComboSeccion("CboCat_ID26", sEventos, 26, -1, 0, "--Seleccionar--", "", "Editar")
				  	%>
				</div>
               <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar" onclick="Cerrar()">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="Guardar()">Guardar</button>
				</div>

   		      </div>
                 <%
	    	sSQL = "SELECT   *, dbo.fn_Usuario_DameNombreUsuario(Ins_UsuarioID) as usuario "
					+" FROM  Incidencia_Involucrados i "
					+" LEFT JOIN SeguridadGrupo g ON i.Ins_GrupoID=g.Gru_ID"
					+" INNER JOIN Cat_Catalogo c ON c.Cat_ID = i.Ins_TipoInvolucradoCG26 AND c.Sec_ID=26"
					+" WHERE Ins_ID="+Ins_ID
					
				//	+" ORDER BY ProG_ID DESC"
				//Response.Write(sSQL)
        var rsInvol = AbreTabla(sSQL,1,0)
		
	//		var sSQL= " SELECT * FROM Incidencia_Involucrados  WHERE"
//							+" (Ins_GrupoID=" + SegGrupo
//						  + " OR Ins_UsuarioID = " + IDUsuario
//						  + ") AND Ins_ID="+Ins_ID
//					rsPermiso = AbreTabla(sSQL,1,0)
//				//Response.Write(sSQL)
//				if(rsPermiso("Ins_GrupoID").Value>-1){
//			
//				}else{
//			
//				}
		if (!rsInvol.EOF){
			%>
  <div class="project-list">
  <table class="table table-hover">
    <tbody>
    <th>Involucrado</th>
    <th>Permiso</th>
    <th>Desde</th>

     <%
        while (!rsInvol.EOF){
	   var InsI_ID = rsInvol.Fields.Item("InsI_ID").Value

        %>    
      <tr id="tr_<%=InsI_ID%>">
         <td class="project-title">
         <%
			 if(rsInvol.Fields.Item("Ins_GrupoID").Value>-1){
				 IDUsuario =-1
				SegGrupo = 1
  		  %>
		 	<%=rsInvol.Fields.Item("Gru_Nombre").Value%>
		<%
             }else{
				 IDUsuario =1
				SegGrupo = -1
		 %>
 	          <%=rsInvol.Fields.Item("usuario").Value%>
         <%
			 }
		  %>
         	</td>
            <td class="project-title">
 			 <%=rsInvol.Fields.Item("Cat_Nombre").Value%>
        	</td>
        	<td class="project-title">
 			 <%=rsInvol.Fields.Item("Ins_FechaRegistro").Value%>
        	</td>
       <td class="project-title">
       <%
			

	   		if(SegGrupo>-1){
				
	   %>
            <a class="btn btn-white btn-sm" onclick="EditaPermiso(<%=rsInvol.Fields.Item("Ins_GrupoID").Value%>, 1, '<%=InsI_ID%>');  return false">
            <i class="fa fa-eraser"></i> Editar</a>
            <%
			}else{
			 %>
              <a class="btn btn-white btn-sm" onclick="EditaPermiso(<%=rsInvol.Fields.Item("Ins_UsuarioID").Value%>, 2, '<%=InsI_ID%>');  return false">
            <i class="fa fa-eraser"></i> Editar</a>
            <%
			}
			if(SegGrupo>-1){
	   		
			%>
		   	 <a class="btn btn-danger btn-sm" href="#" onclick="EliminaInvolucrado(<%=rsInvol.Fields.Item("Ins_GrupoID").Value%>, 1);  return false">
             <i class="fa fa-trash"></i> Eliminar</a>
             <%
			}else{
			 %>
              	 <a class="btn btn-danger btn-sm" href="#" onclick="EliminaInvolucrado(<%=rsInvol.Fields.Item("Ins_UsuarioID").Value%>, 2);  return false">
             <i class="fa fa-trash"></i> Eliminar</a>
             <%
			}
			%>
       </td>
      </tr>
        <%
            rsInvol.MoveNext() 
            }
        rsInvol.Close()   
        %>       
    </tbody>
  </table>
</div>    
                 	     <input type="hidden" id="T_Involucrado" value="0"></input>
                 	     <input type="hidden" id="Involucrado" value=""></input>

  <%
  		}
    %>
  <script type="application/javascript">
 
    $(document).ready(function(){
		 $('#divUsuarios').hide()
	
     });
	 	 function MostrarGrupos(){
			   if($(".ChkGrupos").is(':checked')){
				 $('#divUsuarios').hide()
				  $('#divGrupos').show()
				  }else{
				  $('#divGrupos').hide()
				  $('#divUsuarios').show()
				 }
		 }
		 
		 	 function EditaPermiso(id, tipo, tr){
				 var tr = tr
			 	$('#divUsuarios').hide()
				$('#divGrupos').hide()
			  	$('#T_Involucrado').val(tipo)
				$('#Involucrado').val(id)
				$('#tr_'+tr+ '').css('background-color', 'lightblue');
		 }		
		 
	    function Guardar(){
        var T_Involucrado = $('#T_Involucrado').val()
		if(T_Involucrado >0){
		var Tarea = 15
		}else{
		var Tarea = 14
		}
		console.log($('#T_Involucrado').val())
		$.post("/pz/wms/Proveedor/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:<%=Ins_ID%>,
		Usuario:$('#selInvolucrado').val(),
		T_Involucrado:$('#T_Involucrado').val(),
		Involucrado:$('#Involucrado').val(),
		Ins_TipoInvolucradoCG26: $('#CboCat_ID26').val(),
		Ins_GrupoID: $('#Gru_ID').val(),
		Tarea:Tarea
		},
		function(data){
       	var response = JSON.parse(data)
				if(response.result>0){
					var Tipo = "success"
					var message = "Guardado correctamente"
				}else{
					var Tipo = "error"	
					var message = "Error al guardar"
				}
				$('#T_Involucrado').val('')
				$('#Involucrado').val('')
				Avisa(Tipo,"Aviso",message);
				var dato = "InsO_ID="+<%=InsO_ID%>
					   dato += "&Ins_ID="+<%=Ins_ID%>
			       $("#divInvolucrados").load("/pz/wms/Proveedor/Incidencias/Incidencia_Involucrados.asp", dato)
	    });
		}
		   function EliminaInvolucrado(id, tipo){
		   	  	$('#T_Involucrado').val(tipo)
				$('#Involucrado').val(id)
        var T_Involucrado = $('#T_Involucrado').val()
		
		$.post("/pz/wms/Proveedor/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:<%=Ins_ID%>,
		T_Involucrado:$('#T_Involucrado').val(),
		Involucrado:$('#Involucrado').val(),
		Tarea:16
		},
		function(data){
       	var response = JSON.parse(data)
				if(response.result>0){
					var Tipo = "success"
					var message = "Involucrado eliminado correctamente"
				}else{
					var Tipo = "error"	
					var message = "Error al eliminar"
				}
				$('#T_Involucrado').val('')
				$('#Involucrado').val('')
				Avisa(Tipo,"Aviso",message);
				var dato = "InsO_ID="+<%=InsO_ID%>
					   dato += "&Ins_ID="+<%=Ins_ID%>
			       $("#divInvolucrados").load("/pz/wms/Proveedor/Incidencias/Incidencia_Involucrados.asp", dato)
	    });
		}

    
   </script>
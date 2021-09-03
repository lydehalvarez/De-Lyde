<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var InsO_ID = Parametro("InsO_ID", -1)  
    var Ins_ID = Parametro("Ins_ID", -1)  

sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
		+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica     WHERE i.InsO_ID = "+InsO_ID+" GROUP BY IDUnica, Usu_Nombre "
		+"UNION "
		+"SELECT IDUnica, Emp_Nombre + ' ' + Emp_ApellidoPaterno AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica    WHERE i.InsO_ID = "+InsO_ID+" GROUP BY IDUnica, Emp_Nombre, Emp_ApellidoPaterno"
		   	    rsAsignados = AbreTabla(sSQL,1,0)

%>

<div class="modal inmodal" id="mdlAsignar" tabindex="-1" role="dialog" aria-hidden="true">
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
                                    <label class="col-sm-2 control-label">Asignar a:</label>    
                                    <div class="col-sm-10 m-b-xs">
                                        <select id="selAsignado" class="form-control">
                                            <option value="">
                                            <%= "Selecciona" %>
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
                                      <label class="col-sm-2 control-label">Nuevo Tema:</label>    
                                    <div class="col-sm-10 m-b-xs">
           							<textarea class="form-control NTema" placeholder="Escribe un comentario...." onkeydown= "GuardaTema(event, 0)"></textarea>
                                    </div>
                </div>
   		      </div>
        </div>
    </div>
</div>
                            
<script type="application/javascript">
 
    $(document).ready(function(){
		 
		
         });
	 	
	    function GuardaTema(event, inspadre){
        
				var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
			console.log($(".NTema").val())
			var Tema =$(".NTema").val()
			var Asignado = $("#selAsignado").val()
			
		$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:<%=Ins_ID%>,
		InsCm_Padre:inspadre,
		Asignado:Asignado,
		InsCm_Observacion:Tema,
		Estatus: 3,
		Usuario:$('#IDUsuario').val(),
		Tarea:2
		},
		function(data){
	$("#divComentarios").load("/pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID="+ $("#Ins_ID").val()+"&Reporta="+$("#Reporta").val()+ "&Recibe="+$("#Recibe").val())
       	$("#mdlAsignar").modal('hide').remove();
	    });
		}
		
    }
   </script>
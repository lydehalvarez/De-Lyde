<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var Man_ID = Parametro("Man_ID", -1)  
%>

<div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>
              
                <h4 class="modal-title">Agregar numero de GPS</h4>
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
                            <label class="control-label col-md-2"><strong>GPS</strong></label>
                   <div class="col-md-3">
                       <input class="form-control agenda" id="Man_GPS" placeholder="No. de GPS" type="text" autocomplete="off" value=""/> 
                   </div>
                </div>
               <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar" data-manid="<%=Man_ID%>">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="Guardar()">Guardar</button>
				</div>

   		      </div>
                 <%
		sSQL = "SELECT   ManG_FechaRegistro, ManG_SerieGPS,  dbo.fn_Usuario_DameNombreUsuario(ManG_Usuario) as usuario "
					+" FROM  Manifiesto_Salida_GPS WHERE Man_ID="+Man_ID
					+" ORDER BY ManG_FechaRegistro DESC"
					//Response.Write(sSQL)
        var rsGPS = AbreTabla(sSQL,1,0)
		if (!rsGPS.EOF){
			%>
  <div class="project-list">
  <table class="table table-hover">
    <tbody>
    <th>Numero GPS</th>
    <th>Fecha asignacion</th>
    <th>Asigno</th>

     <%
        while (!rsGPS.EOF){

        %>    
      <tr>
         <td class="project-title">
 			 <%=rsGPS.Fields.Item("ManG_SerieGPS").Value%>
           
        </td>
        <td class="project-title">
 			 <%=rsGPS.Fields.Item("ManG_FechaRegistro").Value%>
        </td>
        <td class="project-title">
 			 <%=rsGPS.Fields.Item("usuario").Value%>
        </td>
       
      </tr>
        <%
            rsGPS.MoveNext() 
            }
        rsGPS.Close()   
        %>       
    </tbody>
  </table>
</div>    
  <%
  		}
    %>
  <script type="application/javascript">
 
    $(document).ready(function(){
		 
		$('.btnCerrar').click(function(e) {
     e.preventDefault();
            var Man_ID = $(this).data("manid");
            $("#btnCerrar").show("slow");    
            $("#td_gps_" + Man_ID).hide("slow");
            $("#td_gps_" + Man_ID).empty();
            $("#tr_gps_" + Man_ID).empty().remove();		});
     });
	 	
	    function Guardar(){
        
		$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
		{Man_ID:<%=Man_ID%>,
		ManG_GPS: $('#Man_GPS').val(),
		Usu_ID:$('#IDUsuario').val(),
		Tarea:14
		},
		function(data){
       	var response = JSON.parse(data)
				if(response.result>-1){
					var Tipo = "success"
					$('#Man_GPS').val('')
				}else{
					var Tipo = "error"	
				}
				Avisa(Tipo,"Aviso",response.message);
				var dato = "Man_ID="+response.manid
					   dato += "&Tarea=15"
			       $("#ManGPS_"+response.manid).load("/pz/wms/Salidas/Manifiesto_Ajax.asp"
                               , dato
                               , function(){
                                    $("#Man_"+response.manid).show("slow")
									$("#td_gps_" + response.manid).hide("slow");
            						$("#td_gps_" + response.manid).empty();
            						$("#tr_gps_" + response.manid).empty().remove();	
									ManifiestoFunciones.GPS(response.manid)
            });  
	    });
		}

    
   </script>
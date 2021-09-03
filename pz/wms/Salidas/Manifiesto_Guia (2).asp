<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var Man_ID = Parametro("Man_ID", -1)  
%>

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
                                    <div class="col-sm-3 m-b-xs">
                                                            <%
                            var sCondicion = "Prov_Habilitado = 1 and Prov_EsPaqueteria = 1"
                            CargaCombo("ProvGuia_ID","class='form-control'","Prov_ID","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"Selecciona")
                        %>

                         </div>
                         </div>
                          <div class="form-group">
                      <div class="col-md-12">
                          <br/>
                      </div>
                    </div>
                     <div class="form-group">
                            <label class="control-label col-md-2"><strong>Gu&iacute;a</strong></label>
                   <div class="col-md-3">
                       <input class="form-control agenda" id="Man_Guia" placeholder="No. de gu&iacute;a" type="text" autocomplete="off" value=""/> 
                   </div>
                </div>
               <div class="modal-footer">
                <button type="button" class="btn btn-white btnCerrar" data-manid="<%=Man_ID%>">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="Guardar()">Guardar</button>
				</div>

   		      </div>
                 <%
		sSQL = "SELECT   ProG_FechaAsignaGuia, ProG_NumeroGuia,  dbo.fn_Usuario_DameNombreUsuario(ProG_UsuarioAsigno) as usuario "
					+" FROM  Proveedor_Guia WHERE Man_ID="+Man_ID
					+" ORDER BY ProG_ID DESC"
        var rsGuia = AbreTabla(sSQL,1,0)
		if (!rsGuia.EOF){
			%>
  <div class="project-list">
  <table class="table table-hover">
    <tbody>
    <th>Numero Guia</th>
    <th>Fecha asignacion</th>
    <th>Asigno</th>

     <%
        while (!rsGuia.EOF){

        %>    
      <tr>
         <td class="project-title">
 			 <%=rsGuia.Fields.Item("ProG_NumeroGuia").Value%>
           
        </td>
        <td class="project-title">
 			 <%=rsGuia.Fields.Item("ProG_FechaAsignaGuia").Value%>
        </td>
        <td class="project-title">
 			 <%=rsGuia.Fields.Item("usuario").Value%>
        </td>
       
      </tr>
        <%
            rsGuia.MoveNext() 
            }
        rsGuia.Close()   
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
            $("#td_" + Man_ID).hide("slow");
            $("#td_" + Man_ID).empty();
            $("#tr_" + Man_ID).empty().remove();		});
     });
	 	
	    function Guardar(){
        
		$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
		{Man_ID:<%=Man_ID%>,
		Prov_ID:$('#ProvGuia_ID').val(),
		ProG_NumeroGuia: $('#Man_Guia').val(),
		Usu_ID:$('#IDUsuario').val(),
		Tarea:12
		},
		function(data){
       	var response = JSON.parse(data)
				if(response.result>-1){
					var Tipo = "success"
					$('#Man_Guia').val('')
				}else{
					var Tipo = "error"	
				}
				Avisa(Tipo,"Aviso",response.message);
				var dato = "Man_ID="+response.manid
					   dato += "&Tarea=13"
			       $("#ManG_"+response.manid).load("/pz/wms/Salidas/Manifiesto_Ajax.asp"
                               , dato
                               , function(){
                                    $("#Man_"+response.manid).show("slow")
									ManifiestoFunciones.Guia(response.manid)
            });  
	    });
		}

    
   </script>
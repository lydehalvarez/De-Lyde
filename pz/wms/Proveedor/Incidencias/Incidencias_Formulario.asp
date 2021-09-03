<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Tarea = Parametro("Tarea",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID", -1)
	var Cli_ID = Parametro("Cli_ID", -1)
	var InsT_Padre = Parametro("InsT_Padre", -1)
	var InsO_ID = Parametro("InsO_ID", -1)
 	var Procedencia = Parametro("Procedencia", "")
	var sResultado = ""
	Procedencia = Procedencia.replace("-",",")
	
		sSQL = "SELECT InsT_Problema_For_ID FROM Incidencia_Tipo WHERE InsT_ID = " + InsT_Padre
		var rsInsNombre = AbreTabla(sSQL,1,0)

		var For_ID=rsInsNombre("InsT_Problema_For_ID").Value
		
		var sSQL= " SELECT For_Archivo FROM Formato  WHERE For_ID=" + For_ID
			rsFormulario = AbreTabla(sSQL,1,0)

		var Formulario=rsFormulario("For_Archivo").Value

   
	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
	sSQL = "SELECT InsT_ID, InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID = " + InsT_Padre
			var rsInsNombre = AbreTabla(sSQL,1,0)
			if (Procedencia != ""){
				
			Procedencia = Procedencia + "," + rsInsNombre.Fields.Item("InsT_ID").Value 
			sSQL = "SELECT InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID in (" + Procedencia + ") ORDER BY InsT_ID" 
			var rsInsProcede = AbreTabla(sSQL,1,0)
			var Proviene = ""
			while(!rsInsProcede.EOF){
			 Proviene = Proviene + " / " + rsInsProcede.Fields.Item("InsT_Nombre").Value
			rsInsProcede.MoveNext() 
			}
			rsInsProcede.Close()  
			}else{
			 Proviene = rsInsNombre.Fields.Item("InsT_Nombre").Value
 			Procedencia = rsInsNombre.Fields.Item("InsT_ID").Value 
			}

	
				%>
                                
            <div class="col-md-12">

            <input type="hidden" class="form-control col-md-3 InsT_IDPadre" value="<%=InsT_Padre%>"></input>
				</div>
            </div>
               <div class="form-group">
                	<label class="control-label col-md-3"><strong>Tipo </strong></label>
                    <div class="col-md-9">
            		  <span class="text-left">
                   	<label class="col-md-9 Procede" id="Procede"><%=Proviene%></label>
				 	   </span>
                    </div>
             </div>
               <div class="form-group">
       
                <%
				sSQL = "SELECT * FROM Incidencia_TIpo WHERE InsT_Padre="+InsT_Padre
				var rsInsTipo= AbreTabla(sSQL,1,0)
				
				if(!rsInsTipo.EOF){
					%>
                         <label class="control-label col-md-3"><strong>Subtipo</strong></label>
			             <div class="col-md-9">
				<%
                var sCondicion = "InsT_Padre = "+ InsT_Padre
                var campo = "InsT_Nombre"
                
                CargaCombo("InsT_IDHijos","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")%>
             </div>
 						
			
	<%
				}
		break;  
		
		case 2:	
			sSQL = "SELECT InsT_ID, InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID = " + InsT_Padre
			var rsInsNombre = AbreTabla(sSQL,1,0)
			if (Procedencia != ""){
				
			Procedencia = Procedencia + "," + rsInsNombre.Fields.Item("InsT_ID").Value 
			sSQL = "SELECT InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID in (" + Procedencia + ") ORDER BY InsT_ID" 
			var rsInsProcede = AbreTabla(sSQL,1,0)
			var Proviene = ""
			while(!rsInsProcede.EOF){
			 Proviene = Proviene + " / " + rsInsProcede.Fields.Item("InsT_Nombre").Value
			rsInsProcede.MoveNext() 
			}
			rsInsProcede.Close()  
			}else{
			 Proviene = rsInsNombre.Fields.Item("InsT_Nombre").Value
 			Procedencia = rsInsNombre.Fields.Item("InsT_ID").Value 
			}

		
					sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							+	"inner join Incidencia_Usuario i  ON i.InU_IDUnico = s.IDUnica     WHERE i.InsO_ID = "+InsO_ID+" GROUP BY IDUnica, Usu_Nombre "
							+"UNION "
							+"SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
							+"inner join Incidencia_Usuario i ON i.InU_IDUnico = s.IDUnica    WHERE i.InsO_ID = "+InsO_ID+" GROUP BY IDUnica, Emp_Nombre"
					   	    rsAsignados = AbreTabla(sSQL,1,0)
%>
 						                                
            <div class="col-md-12">

            <input type="hidden" class="form-control col-md-3 InsT_IDPadre" value="<%=InsT_Padre%>"></input>
				</div>
            </div>
               <div class="form-group">
                	<label class="control-label col-md-3"><strong>Tipo </strong></label>
                    <div class="col-md-9">
            		  <span class="text-left">
                   	<label class="col-md-9 Procedencia" id="Procedencia"><%=Proviene%></label>
				 	   </span>
                    </div>
             </div>
               <div class="form-group">
       
                <%
				sSQL = "SELECT * FROM Incidencia_TIpo WHERE InsT_Padre="+InsT_Padre
				var rsInsTipo= AbreTabla(sSQL,1,0)
				
				if(!rsInsTipo.EOF){
					%>
                         <label class="control-label col-md-3"><strong>Subtipo</strong></label>
			             <div class="col-md-9">
				<%
                var sCondicion = "InsT_Padre = "+ InsT_Padre
                var campo = "InsT_Nombre"
                
                CargaCombo("InsT_IDH","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")%>
             </div>
						 <div class="form-group">
  								 <label class="col-sm-3 control-label">Asignar a:</label>    
                                    <div class="col-sm-9 m-b-xs">
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
                                </div>
			
	<%
				}
		break; 
	case 3:	

%>
            <label class="control-label col-md-3"><strong>Tipo</strong></label>
             <div class="col-md-9">
                <%
                var sCondicion = "InsT_Padre = "+ InsT_Padre
                var campo = "InsT_Nombre"
                
                CargaCombo("InsT_IDP","class='form-control'","InsT_ID",campo,"Incidencia_TIpo",sCondicion,"","Editar",0,"Selecciona")%>
             </div>

<%
		
		break; 
	}
%>

<script type="application/javascript">

   $(document).ready(function(){
	   var ventana = $("#VentanaIndex").val() 
	   var params = ""
		if(ventana==2529||ventana==603){
		 params += "?TA_ID=" + $('#TA_ID').val()
		}
	  		if(ventana==303){
				params += "?OV_ID=" +$('#OV_ID').val()
			}
  					if(ventana==1560){
		 				params += "?Pro_ID=" + $('#Pro_ID').val()
					}
					 	if(ventana==2510){
	 							params += "?Pt_ID=" + $('#Pt_ID').val()
						}
									if(ventana==2630){
		 							params += "?Man_ID=" +  $('#Man_ID').val()
									}
											if(ventana==2544){
		 										params += "?ManD_ID=" +  $('#ManD_ID').val()
											}
												if(ventana==331){
								 				params += "?CliOC_ID=" +   $('#CliOC_ID').val()
 												}
												<%
												Formulario=Formulario.replace("wms/Incidencias","wms/Proveedor/Incidencias")
												%>
	$("#divFormulario1").load("<%=Formulario%>"+params)


		 $('#InsT_IDH').change(function(e) {
             e.preventDefault()
			 console.log($(this).val())
			 var procede = "<%=Procedencia%>"
			if(procede != "1"){
				procede = procede.replace(",","-")
			}
			 $('#Procedencia').val(<%=Procedencia%>)
    	   var sDatos    = "InsT_Padre=" + $(this).val();	 
    	   		  sDatos += "&Procedencia=" + procede
			   	  sDatos += "&Tarea="+2
		$("#divHijos").load("/pz/wms/Proveedor/Incidencias/Incidencias_Formulario.asp?" + sDatos)
		//$('#InsT_IDP').val($(this).text())

    //		   var sDatos    = "InsT_Padre=" + $(this).val();	 
//				   	  sDatos += "&Tarea="+2
//		$("#divHijos").load("/pz/wms/Incidencias/Incidencias_Formulario.asp?" + sDatos)
    	});
		
		 $('#InsT_IDHijos').change(function(e) {
             e.preventDefault()
			 console.log($(this).val())
			 var procede = "<%=Procedencia%>"
			if(procede != "1"){
				procede = procede.replace(",","-")
			}
			 $('#Procede').val(<%=Procedencia%>)
    	   var sDatos    = "InsT_Padre=" + $(this).val();	 
    	   		  sDatos += "&Procedencia=" + procede
			   	  sDatos += "&Tarea="+1
		$("#divHijo").load("/pz/wms/Proveedor/Incidencias/Incidencias_Formulario.asp?" + sDatos)
		//$('#InsT_IDP').val($(this).text())

    //		   var sDatos    = "InsT_Padre=" + $(this).val();	 
//				   	  sDatos += "&Tarea="+2
//		$("#divHijos").load("/pz/wms/Incidencias/Incidencias_Formulario.asp?" + sDatos)
    	});
		
	 $('.btnCerrar').click(function(e) {
	  	$("#mdlIncidencias").modal('hide').remove();
	  });
   });
   			var FunctionInsert = {
			InsertDatos:function(){
				
		$.ajax({
   				 method: "POST",
  				  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp",
 	   data: { 
	   					   InsT_ID:<%=InsT_Padre%>,
						   InsO_ID:$('#InsO_ID').val(),
	   					   Ins_Usu_Recibe:$('#selAsignar').val(),
						   Ins_Titulo: encodeURIComponent($('.Titulo').val()),
						   Ins_Asunto: encodeURIComponent($('.Asunto').val()),
						   Ins_Problema: encodeURIComponent($('.Problema').val()),
						   Ins_Descripcion:encodeURIComponent($('.Descripcion').val()),
						   Ins_Causa:encodeURIComponent($('.Causa').val()),
						   Ins_Usu_Reporta: $('#IDUsuario').val(),
						   Tarea:4
		},
    cache: false,
	//async: false    SE OCUPA PARA EVITAR REPETICIONES DE INSERCIONES 
    success: function(data){
	
			var Tipo = "success"
			var sMensaje = "El registro se ha guardado correctamente "
		
				Avisa(Tipo,"Aviso",sMensaje);
				   $("#mdlIncidencias").modal('hide').remove();
				  var Params = "?IDUsuario="+$('#IDUsuario').val()
				  $('#Contenido').load("/pz/wms/Proveedor/Incidencias/CTL_Incidencias.asp" + Params)
	}
		});	
			}
			
		}
</script>
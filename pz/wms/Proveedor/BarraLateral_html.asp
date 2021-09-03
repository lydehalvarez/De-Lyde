<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var Tarea = Parametro("Tarea",-1)
    var TA_ID = Parametro("TA_ID",-1)
    var OV_ID = Parametro("OV_ID",-1)
    var Tag_ID = Parametro("Tag_ID",-1)
    var Alm_ID = Parametro("Alm_ID",-1)
    var Inv_ID = Parametro("Inv_ID",-1)
    var IDUsuario = Parametro("Usuario", -1)  
	var SegGrupo = Parametro("SegGrupo",-1)



  switch (parseInt(Tarea)) {
         case 1:
	var sHTMLTags = "   <label class='font-normal'>Agregar TAG:</label>"
						+  "<select  style='padding: 0' data-placeholder='Selecciona...' class='chosen-select2'  id='SelTag2' onchange= 'Tags()' multiple style='width:350px;' tabindex='4'>"
						+	" <option value=''>Selecciona</option>"

							var sSQL = "select * from TAG "
							var rsTAG = AbreTabla(sSQL,1,0)
							while (!rsTAG.EOF){
								sHTMLTags+= " <option value='"+rsTAG.Fields.Item("Tag_ID").Value+"'>"+rsTAG.Fields.Item("Tag_Nombre").Value+"</option>"
				
							     rsTAG.MoveNext() 
							}
							rsTAG.Close()  
							sHTMLTags+="</select>"
							Response.Write(sHTMLTags)
			
			break;
			
			case 2: 
			
			var sHTMLTagsU = "   <label class='font-normal'>Agregar Involucrados:</label>"
   		   					 +  "<select data-placeholder='Selecciona...' class='chosen-select3'  id= 'SelUsuarios2'  onchange= 'Usuarios()' multiple style='width:350px;'>"
    						 +  " <option value=''>Selecciona</option>"
						
					sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
							 + "UNION" 
							 + " SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		   	  				var  rsAsignados = AbreTabla(sSQL,1,0)
							while (!rsAsignados.EOF){
								sHTMLTagsU+= " <option value='"+rsAsignados.Fields.Item("IDUnica").Value+"'>"+rsAsignados.Fields.Item("Nombre").Value+"</option>"
				
							     rsAsignados.MoveNext() 
							}
							rsAsignados.Close()  
							sHTMLTagsU+="</select>"
							Response.Write(sHTMLTagsU)

			
			break;
			
			case 3: 
			if(TA_ID>-1||OV_ID > -1||Alm_ID>-1||Inv_ID>-1){
			  var sSQL = "select m.*, Tag_Nombre, Tag_Descripcion "
			  						 +", (select count(*)"
                                     + " from TAG t "
									 + " INNER JOIN TAG_Marcados m ON m.Tag_ID=t.Tag_ID"
                                     + " WHERE (Tag_Publica = 1 "
                                     + " or Tag_UsuarioPropietario = " + IDUsuario
                                     + ") and Tag_Habilitado = 1 "
									 if(TA_ID > -1){
									 sSQL += " and TA_ID="+ TA_ID
									 }
									 if(OV_ID > -1){
									 sSQL += " and OV_ID="+OV_ID 
									 }
									 if(Alm_ID>-1){
									 sSQL +=" and Alm_ID="+Alm_ID
									 }
									 if(Inv_ID>-1){
									 sSQL +=" and Inv_ID="+Inv_ID
									 }	
									 sSQL += ") AS Tags"
                                    sSQL += " from TAG t "
									 sSQL += " INNER JOIN TAG_Marcados m ON m.Tag_ID=t.Tag_ID"
                                     sSQL += " WHERE (Tag_Publica = 1 "
                                     sSQL += " or Tag_UsuarioPropietario = " + IDUsuario
                                     sSQL += ") and Tag_Habilitado = 1 "
									 if(TA_ID > -1){
									 sSQL += " and TA_ID="+ TA_ID
									 }
									 if(OV_ID > -1){
									sSQL += " and OV_ID="+OV_ID 
									 }
									 if(Alm_ID>-1){
									 sSQL +=" and Alm_ID="+Alm_ID
									 }
									 if(Inv_ID>-1){
									 sSQL +=" and Inv_ID="+Inv_ID
									 }
							var rsTAG = AbreTabla(sSQL,1,0)
							if(!rsTAG.EOF){
								
							
							%>
                            
   <h5 class="tag-title">Tags (<%=rsTAG.Fields.Item("Tags").Value%>):
                </h5>
             
                   <ul class="tag-list"  style="padding: 0">   
               
                <%
							while (!rsTAG.EOF){
			
			%>
           <li style="padding: 0">
       <a class="tTag"> <i class="fa fa-tag"></i>  <%=rsTAG.Fields.Item("Tag_Nombre").Value %> <i class="fa fa-remove" onclick="EliminaTag(<%=rsTAG.Fields.Item("Tag_ID").Value%>,<%=rsTAG.Fields.Item("TA_ID").Value%>,<%=rsTAG.Fields.Item("OV_ID").Value%>,<%=rsTAG.Fields.Item("Alm_ID").Value%>,<%=rsTAG.Fields.Item("Pro_ID").Value%>)"></i></a> </li>
		<%
						  rsTAG.MoveNext() 
							}
							rsTAG.Close()
								%>
                   
                            </ul>

                            <% 
							}
			}
			break;
			
						case 4: 
		
			  var sSQL = "select m.Tag_ID, m.Usu_ID, dbo.fn_Usuario_DameNombreUsuario( Usu_ID ) as Involucrado "
			   						 +", (select COUNT(*) "
                                     + " from TAG t "
									 + " INNER JOIN TAG_Usuarios m ON m.Tag_ID=t.Tag_ID"
									 + " INNER JOIN Usuario u ON u.Usu_ID=m.Usu_ID"
                                     + " WHERE Tag_Publica = 1 "
                                     //+ " or Tag_UsuarioPropietario = " + IDUsuario
                                     + " and Tag_Habilitado = 1 and m.Tag_ID = "+Tag_ID+") AS usuarios "
                                     + " from TAG t "
									 + " INNER JOIN TAG_Usuarios m ON m.Tag_ID=t.Tag_ID"
                                     + " WHERE Tag_Publica = 1 "
                                     //+ " or Tag_UsuarioPropietario = " + IDUsuario
                                     + " and Tag_Habilitado = 1 and m.Tag_ID = "+ Tag_ID

							var rsTAG = AbreTabla(sSQL,1,0)
						
							if(!rsTAG.EOF){
		
			%>
			<div><strong>
				Usuarios<%/*%>(<%=rsTAG.Fields.Item("usuarios").Value%>)<%*/%>:
                </strong></div>
            
                     <ul class="tag-list" style="padding: 0"> 
                <%
						while (!rsTAG.EOF){

				%>
                             <span class="label label-secondary">

			 						<a ><%=rsTAG.Fields.Item("Involucrado").Value%><i class="fa fa-remove" onclick="EliminaUsuario(<%=rsTAG.Fields.Item("Tag_ID").Value%>,<%=rsTAG.Fields.Item("Usu_ID").Value%>)"></i></a></span>
		<%
						  rsTAG.MoveNext() 
							}
							rsTAG.Close()
								%>
                            </ul>
               

                            <%
							}
							
			break;
			
			case 5:
			var sSQL = "SELECT  i.Ins_ID "
							+ " FROM INCIDENCIA i  INNER JOIN Incidencia_Tipo t ON i.InsT_ID=t.InsT_ID "
			     			+ " LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID"
							+" WHERE (Ins_Usu_Recibe =" + IDUsuario+" OR Ins_Usu_Reporta = " + IDUsuario
    	        			+ " OR Ins_Usu_Escalado = " + IDUsuario + "OR p.Ins_GrupoID= "+SegGrupo
		 					+ " OR p.Ins_UsuarioID=" + IDUsuario+ ")  and (InsT_PrioridadCG33 > 3 or InsT_SeveridadCG32 > 3 or InsT_TallaCG25 >4  "
				   		    + "  or InsT_SeveridadCG32 > 4 or InsT_EstrellasCG33 > 3) AND i.Ins_EstatusCG27 <> 4  GROUP BY  i.Ins_ID " 
							var rsIncidencias = AbreTabla(sSQL,1,0)
			
				var total = rsIncidencias.RecordCount
				if(total>0){
			%>
			<i class="fa fa-tasks"></i><span class="label label-danger"><%=total%></span>
<%
				}
			break;
			case 6:
			var sSQL = "SELECT  i.Ins_ID "
							 + " FROM INCIDENCIA i  INNER JOIN Incidencia_Tipo t ON i.InsT_ID=t.InsT_ID "
 			     			 + " LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID"
							+" WHERE (Ins_Usu_Recibe =" + IDUsuario+" OR Ins_Usu_Reporta = " + IDUsuario
    	        			+ " OR Ins_Usu_Escalado = " + IDUsuario + "OR p.Ins_GrupoID= "+SegGrupo
		 					+ " OR p.Ins_UsuarioID=" + IDUsuario+ ") AND i.Ins_EstatusCG27 <> 4 GROUP BY  i.Ins_ID" 
							var rsIncidencias = AbreTabla(sSQL,1,0)
			
				var total = rsIncidencias.RecordCount
				if(total>0){
%>

			
			   <i class="fa fa-envelope"></i>  <span class="label label-warning"><%=total%></span>
<%
				}
			break;

  }
 
%>
<script src="/Template/inspina/js/plugins/chosen/chosen.jquery.js"></script>

<script type="application/javascript">
var ventana = $("#VentanaIndex").val() 
if(ventana != 2570||ventana != 2600){
		$('.chosen-select2').chosen({width: "100%"});
		$('.chosen-select3').chosen({width: "100%"});
}

</script>
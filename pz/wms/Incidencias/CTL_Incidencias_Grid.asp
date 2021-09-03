 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var InsO_ID = Parametro("InsO_ID",-1)
	var InsT_ID = Parametro("InsT_ID",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
	var SegGrupo = Parametro("SegGrupo",-1)
	var Tag_ID = Parametro("Tag_ID",-1)
	var Estatus = Parametro("Estatus",-1)
	var Prioridad = Parametro("Prioridad",-1)
	var Busqueda = Parametro("Busqueda",-1)
	var Buscar = Parametro("Buscar", "")

    var Ins_Nombre = ""
    var Ins_UsuReporta = ""
    var Ins_UsuRecibe = ""
    var Ins_FechaRegistro = ""

%>
    <table class="table table-hover table-mail">
        <tbody>
<%
    var condicion = ""
    var sTop = " TOP 50 "

    if(Tag_ID >-1){
         sTop = ""
    } 
    	sSQL = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+IDUsuario+" OR Emp_ID="+IDUsuario
		var rsGruID = AbreTabla(sSQL,1,0)
		//  Response.Write(sSQL)
    var sSQL = "SELECT " + sTop + "  i.Ins_ID, Ins_Titulo, Ins_Asunto, CONVERT(VARCHAR, CONVERT(DATETIME, i.Ins_FechaRegistro), 103) + ' ' +" 
				 + " CONVERT(VARCHAR, CONVERT(DATETIME, i.Ins_FechaRegistro), 108) + ' hrs.' as Ins_FechaRegistro, Ins_Usu_Reporta, "
				 + " Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, i.InsT_ID " 
                 + " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Reporta ) as REPORTA "
                 +  " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Recibe ) as RECIBE "
				 + ", Ins_EstatusCG27, dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) Cat_Nombre"
            	 +  " FROM Incidencia i inner join Incidencia_Usuario u on  i.InsO_ID = u.InsO_ID"
			     +	  " inner join  Incidencia_Tipo t on i.InsT_ID = t.InsT_ID"
				 +	  " left join Incidencia_Involucrados p on  i.Ins_ID = p.Ins_ID "       
             	 + " WHERE u.InU_IDUnico = " + IDUsuario
               		 + " AND (( i.Ins_Usu_Reporta = " + IDUsuario 
                     + " OR i.Ins_Usu_Recibe = " + IDUsuario
                     + " OR i.Ins_Usu_Escalado = " + IDUsuario
					 sSQL += " OR p.Ins_GrupoID= "+rsGruID.Fields.Item("IncG_ID").Value
				     sSQL += " OR p.Ins_UsuarioID=" + IDUsuario+ "))"
        			// + " OR Ins_PuedeVer_ProveedorID >-1) "
    if(Tag_ID >-1){
         sSQL += " AND i.Tag_ID = " + Tag_ID
    } else if(InsO_ID == -1 && InsT_ID == -1){
         sSQL += " AND i.Ins_FechaRegistro >= DATEADD(day,-100,getdate()) and i.Ins_FechaRegistro <= getdate() "
    } else if(InsO_ID > 0 ){
         sSQL += " AND i.InsO_ID = " + InsO_ID + "  AND i.Ins_EstatusCG27 <>4"
    }
	 if(InsT_ID > 0){
         sSQL += " AND i.InsT_ID = " + InsT_ID
    }
	 if(Estatus > -1){
         sSQL += " AND i.Ins_EstatusCG27 = " + Estatus
    }
	if(Prioridad > -1){
		sSQL +=" and (InsT_PrioridadCG33 > 3 or InsT_SeveridadCG32 > 3 or InsT_TallaCG25 >4 or "
		sSQL += " InsT_SeveridadCG32 > 4 or InsT_EstrellasCG33 > 3) AND i.Ins_EstatusCG27 <> 4 " 
	}
	if(Busqueda ==1){
		//sSQL += " AND (i.Ins_Asunto LIKE '%"+Buscar+"%' or i.Ins_Descripcion LIKE '%"+Buscar+"%' or i.Ins_FechaRegistro LIKE '%"+Buscar+"%' )"
	sSQL  += " AND i.Ins_ID = " + Buscar
	}
	sSQL += "  GROUP BY i.Ins_ID, i.InsT_ID, Ins_Titulo, Ins_Asunto, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, Ins_EstatusCG27"
     sSQL += " ORDER BY i.Ins_FechaRegistro Desc "

 //Response.Write(sSQL)
   
    var rsIncidencias = AbreTabla(sSQL,1,0)
    while (!rsIncidencias.EOF){
		
		sSQL = "SELECT * FROM Incidencia_HistoriaLectura"
		   	     + " WHERE InsH_Leyo_UID="+IDUsuario+" and Ins_ID="	+ rsIncidencias.Fields.Item("Ins_ID").Value
	 	
			    var rsLectura = AbreTabla(sSQL,1,0)

			  var leido = "unread"
			
			  if(!rsLectura.EOF){
				     leido = "read"
			  }
//         Ins_UsuReporta = rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value
//         Ins_UsuRecibe = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
//         Ins_FechaRegistro = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
//         sSQL = "SELECT  dbo.fn_Usuario_DameUsuario("+Ins_UsuReporta+")"
//         var rsReporta = AbreTabla(sSQL,1,0)
//         Ins_UsuReporta = rsReporta.Fields.Item(0).Value
//         sSQL = "SELECT  dbo.fn_Usuario_DameUsuario("+Ins_UsuRecibe+")"
//         var rsRecibe = AbreTabla(sSQL,1,0)
//         Ins_UsuRecibe = rsRecibe.Fields.Item(0).Value
         var iEstatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value
    	var ClaseEstatus = "plain"
          switch (parseInt(iEstatus)) {
	 		
	 		case 1:
                 ClaseEstatus = "plain"   
            break;    
            case 3:
                ClaseEstatus = "warning"
            break;     
            case 4:
                ClaseEstatus = "success"
            break;    
            case 2:
                ClaseEstatus = "warning"
            break;   
            case 5:
                ClaseEstatus = "danger"
            break;        
            }   

           if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 && rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value != IDUsuario){
			   
			   sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
			   			    var rsProveedor = AbreTabla(sSQL,1,0)
							
				sSQL = "SELECT Ins_GrupoID FROM Incidencia_Involucrados WHERE Ins_ID = " +  rsIncidencias.Fields.Item("Ins_ID").Value
							var rsGrupo = AbreTabla(sSQL,1,0)
				
				sSQL = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+IDUsuario+" OR Emp_ID = "+IDUsuario
							var rsGruID = AbreTabla(sSQL,1,0)
							
				if(rsGrupo.Fields.Item("Ins_GrupoID").Value==rsGruID.Fields.Item("IncG_ID").Value){
				
				sSQL = "SELECT IncG_Nombre FROM Incidencia_Grupo WHERE IncG_ID=" +rsGrupo.Fields.Item("Ins_GrupoID").Value
							 rsGrupo = AbreTabla(sSQL,1,0)
			   %>
               		
            <tr class="<%=leido%>" onclick="javascript:CargaDescripcion(<%=rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value%> , <%=rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value%> , <%=rsIncidencias.Fields.Item("Ins_ID").Value%>)">
                <td class="mail-contact">
                   <!-- <input type="checkbox" class="i-checks">-->
                   		<a>
	                  Ticket: <strong><%=rsIncidencias.Fields.Item("Ins_ID").Value%> </strong> </br>
        		   		<span class="label label-<%=ClaseEstatus%>"><%=rsIncidencias.Fields.Item("Cat_Nombre").Value%> </span>
                       </a>

                </td>
                <td class="mail-contact">
					<a>
	                  Reporta: <strong><%=rsProveedor.Fields.Item("Prov_Nombre").Value%> </strong>
                       </a>
                   <br/>

                      Recibe: <%=rsGrupo.Fields.Item("IncG_Nombre").Value%> 
   </td>
                <td class="mail-subject"><a class="btnCorreo"><%=rsIncidencias.Fields.Item("Ins_Asunto").Value%></a></td>
<!--                    <td class=""><i class="fa fa-paperclip"></i></td>-->  
                <td class="text-right mail-date" ><%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%></td>
            </tr>
		  <% 
				}
           }else{
			   		
		   %>
          	<tr class="<%=leido%>" onclick="javascript:CargaDescripcion(<%=rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value%> , <%=rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value%> , <%=rsIncidencias.Fields.Item("Ins_ID").Value%>)">
                <td class="mail-contact">
                   <!-- <input type="checkbox" class="i-checks">-->
                  Ticket: <strong><%=rsIncidencias.Fields.Item("Ins_ID").Value%> </strong> </br>
      		   		<span class="label label-<%=ClaseEstatus%>"><%=rsIncidencias.Fields.Item("Cat_Nombre").Value%> </span>
                </td>
                <td>

           			<a>
                    Reporta: <strong><%=rsIncidencias.Fields.Item("REPORTA").Value%></strong>
                    </a>
                   <br/>
<%
                if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 && rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value == IDUsuario){
	
				   sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
	   			    var rsProveedor = AbreTabla(sSQL,1,0)
	%>
                  Recibe: <%=rsProveedor.Fields.Item("Prov_Nombre").Value%> 
			<%
				}else{
					var Recibe= rsIncidencias.Fields.Item("RECIBE").Value
		 sSQL = "SELECT Ins_GrupoID FROM Incidencia_Involucrados WHERE Ins_ID = " +  rsIncidencias.Fields.Item("Ins_ID").Value
							var rsGrupo = AbreTabla(sSQL,1,0)
				if(!rsGrupo.EOF){
				sSQL = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+IDUsuario+" OR Emp_ID = "+IDUsuario
							var rsGruID = AbreTabla(sSQL,1,0)
				
				
				if(rsGrupo.Fields.Item("Ins_GrupoID").Value==rsGruID.Fields.Item("IncG_ID").Value){
				
				sSQL = "SELECT IncG_Nombre FROM Incidencia_Grupo WHERE IncG_ID=" +rsGrupo.Fields.Item("Ins_GrupoID").Value
							 rsGrupo = AbreTabla(sSQL,1,0)
				Recibe=rsGrupo.Fields.Item("IncG_Nombre").Value
					if(!rsGrupo.EOF){
					%>
						  Recibe: <%=Recibe%> 
					<%
					}
						}else{
							%>
						  Recibe: <%=Recibe%> 
						<%
						}
					}else{
					%>
						Recibe: <%=Recibe%> 
					<%
					}
				}
			
				
			%>
                </td>
                <td class="mail-subject"><a class="btnCorreo"><%=rsIncidencias.Fields.Item("Ins_Asunto").Value%></a></td>
<!--                    <td class=""><i class="fa fa-paperclip"></i></td>-->  
                <td class="text-right mail-date" ><%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%></td>
                <td class="text-right mail-date" >   <span class="pull-right"> <a  class="text-muted btnEditar" onclick="ModalEditar(<%=rsIncidencias.Fields.Item("Ins_ID").Value%>, <%=rsIncidencias.Fields.Item("InsT_ID").Value%>)"><i class="fa fa-pencil fa-fw"></i>&nbsp;<strong></strong></a></span></td>
            </tr>
<%	
  }
        rsIncidencias.MoveNext() 
        }
    rsIncidencias.Close()  

%>
            </tbody>
     </table>
<script>
//    function CargaDescripcion(reporta, recibe, insid){
//        
//            var Params = "?Ins_ID=" + insid
//                Params += "&Reporta=" + reporta
//                Params += "&Recibe=" + recibe
//               Params += "&Lpp=1"  //este parametro limpia el cache
//               
//            $("#divAsuntos").load("/pz/wms/Incidencias/CTL_Incidencias_Descripcion.asp" + Params)        
//        
//    }
</script>
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0
	var Ins_ID = Parametro("Ins_ID",-1)
	var InsO_ID = Parametro("InsO_ID",-1)
	var InsT_ID = Parametro("InsT_ID",-1)
	var Recibe = Parametro("Atiende",-1)
	var SegGrupo = Parametro("SegGrupo",-1)
	var Tag_ID = Parametro("Tag_ID",-1)
	var Estatus = Parametro("Estatus",-1)
	var Prioridad = Parametro("Prioridad",-1)
	var Busqueda = Parametro("Busqueda",-1)
	var Buscar = Parametro("Buscar", "")
	var Reporta = Parametro("Reporta",-1)
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
	var InsT_Padre = Parametro("InsT_Padre",-1)
	var Gru_Atiende = Parametro("Gru_Atiende",-1)
	var Gru_Todos = Parametro("Gru_Todos",-1)
	var Prov_Reporta = Parametro("Prov_Reporta",-1)
	var Prov_Atiende = Parametro("Prov_Atiende",-1)
    var TA_Folio = Parametro("TA_Folio","")
	
	//esta booleana se usa para saber si no entra nada de filtros y solo entregar las de hoy
    var bHayParams = false  
		  	sSQL1 = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+Recibe+" OR Emp_ID="+Recibe
		var rsGruID = AbreTabla(sSQL1,1,0)
		
    var sSQL = "SELECT  i.Ins_ID, Ins_Titulo, Ins_Asunto,CONVERT(VARCHAR(17), i.Ins_FechaRegistro, 103) AS Ins_FechaRegistro, Ins_Usu_Reporta,  Ins_FechaEntrega_Tarea"
				 + ", Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID,Ins_EstatusCG27, Ins_ReportaProv, "
				 + " CONVERT(VARCHAR, CONVERT(DATETIME,Ins_FechaUltimaModificacion), 103) + ' '+" 
				 + " CONVERT(VARCHAR, CONVERT(DATETIME,Ins_FechaUltimaModificacion), 108) + ' hrs.' AS Ins_FechaUltimaModificacion " 
                 + " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Reporta ) as REPORTA "
                 +  " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Recibe ) as RECIBE "
				 + ", dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) Cat_Nombre"
  				 + ", CAST(DATEADD(HOUR, t.InsT_SLAAtencion + t.InsT_SLAResolucion, i.Ins_FechaRegistro) AS NVARCHAR(25)) as fecha"
            	 +  " FROM Incidencia i "
			     +	  " inner join  Incidencia_Tipo t on i.InsT_ID = t.InsT_ID"
			if(TA_Folio != ""){
				sSQL += " INNER JOIN TransferenciaAlmacen tr ON i.TA_ID=tr.TA_ID"
			}
	    	if(Gru_Todos >-1){
					sSQL += " INNER JOIN Incidencia_Grupo_Usuario g ON"
				    sSQL +=	" (i.Ins_Usu_Reporta = g.Emp_ID OR i.Ins_Usu_Reporta = g.Usu_ID) and "
					sSQL +=	"(i.Ins_Usu_Recibe = g.Emp_ID OR i.Ins_Usu_Recibe = g.Usu_ID) and"
					sSQL +=	" (i.Ins_Usu_Escalado = g.Emp_ID OR  i.Ins_Usu_Escalado = g.Usu_ID) "
			}
				 	sSQL +=  " left join Incidencia_Involucrados p on  i.Ins_ID = p.Ins_ID "       
		    if(Gru_Todos >-1){
					sSQL += " AND (p.Ins_UsuarioID =g.Emp_ID OR  p.Ins_UsuarioID = g.Usu_ID) "
			}
             	  	sSQL +=" WHERE i.Ins_ID >-1"
		   if(Gru_Todos >-1){
					sSQL += " AND g.IncG_ID="+Gru_Todos
			} 
	if(TA_Folio != ""){
				sSQL += " AND tr.TA_Folio='"+TA_Folio+"'"
			}
	    if(Reporta >-1){

				   sSQL +=	" AND u.InU_IDUnico = " + Reporta
               	   sSQL += " AND (( i.Ins_Usu_Reporta = " + Reporta + "))"
		}
        if(Recibe >-1){
				   sSQL +=	" AND u.InU_IDUnico = " + Recibe
               	   sSQL += " AND (( i.Ins_Usu_Recibe = " + Recibe 
                   sSQL += " OR i.Ins_Usu_Escalado = " + Recibe
				   sSQL += " OR p.Ins_GrupoID= "+rsGruID.Fields.Item("IncG_ID").Value
				   sSQL += " OR p.Ins_UsuarioID=" + Recibe+ "))"
		}

	    if(Prov_Reporta >-1){
               	   sSQL += " AND (i.Ins_PuedeVer_ProveedorID= "+Prov_Reporta+" AND i.Ins_ReportaProv = 1)"
		}
	    if(Gru_Atiende >-1){
               	   sSQL += " AND (( p.Ins_GrupoID= "+Gru_Atiende+"))"
		}

		if(Prov_Atiende >-1){
               	   sSQL += " AND (i.Ins_PuedeVer_ProveedorID= "+Prov_Atiende+" AND i.Ins_ReportaProv = 0)"
		}
        			// + " OR Ins_PuedeVer_ProveedorID >-1) "
    if(Tag_ID >-1){
         sSQL += " AND i.Tag_ID = " + Tag_ID
    }
// else if (Fecha != ""){
//         sSQL += " AND i.Ins_FechaRegistro >= DATEADD(day,-100,getdate()) and i.Ins_FechaRegistro <= getdate() "
//    }
 else if(InsO_ID > 0 ){
         sSQL += " AND i.InsO_ID = " + InsO_ID + "  AND i.Ins_EstatusCG27 <>4"
    }
	 if(Ins_ID > 0){
         sSQL += " AND i.Ins_ID = " + Ins_ID
    }
	 if(InsT_ID > 0){
         sSQL += " AND (i.InsT_ID = " + InsT_ID
		 
		 sSQL1 = "SELECT InsT_Nombre FROM Incidencia_Tipo WHERE InsT_ID=" +InsT_ID
		   var rsTipo = AbreTabla(sSQL1,1,0)

		   sSQL += " OR i.Ins_Titulo ='"+ rsTipo.Fields.Item("InsT_Nombre").Value +"')"
		   
	}

	if(Estatus > -1){
         sSQL += " AND i.Ins_EstatusCG27 = " + Estatus
    }
	    if (FechaInicio == "" && FechaFin == "") {    
//        FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//        sSQL += " AND CAST( i.Ins_FechaRegistro as date)  >= DATEADD(month,-1,getdate()) "
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST( i.Ins_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST( i.Ins_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST( i.Ins_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
	if(Prioridad > -1){
		sSQL +=" and (InsT_PrioridadCG33 > 3 or InsT_SeveridadCG32 > 3 or InsT_TallaCG25 >4 or "
		sSQL += " InsT_SeveridadCG32 > 4 or InsT_EstrellasCG33 > 3) AND i.Ins_EstatusCG27 <> 4 " 
	}
	if(Busqueda ==1){
		//sSQL += " AND (i.Ins_Asunto LIKE '%"+Buscar+"%' or i.Ins_Descripcion LIKE '%"+Buscar+"%' or i.Ins_FechaRegistro LIKE '%"+Buscar+"%' )"
	sSQL  += " AND i.Ins_ID = " + Buscar
	}
	sSQL += "  GROUP BY i.Ins_ID, Ins_Titulo, Ins_Asunto, i.Ins_FechaRegistro, Ins_Usu_Reporta,  Ins_FechaEntrega_Tarea"
	sSQL += ", Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, Ins_EstatusCG27, Ins_ReportaProv, Ins_FechaUltimaModificacion, t.InsT_SLAAtencion, t.InsT_SLAResolucion,  i.InsT_ID"
     sSQL += " ORDER BY  i.Ins_FechaRegistro Desc "

  //Response.Write(sSQL)
   %>
    
        <div class="ibox-title">
    <h5>Incidencias</h5>
 <div class="ibox-tools">
         <a href="#" class="btn btn-primary btnExcel">Exportar a excel</a>
         </div>
</div>    
<div class="project-list">
    
		      <table class="table table-hover">
        		<tbody>

   <%
    var rsIncidencias = AbreTabla(sSQL,1,0)
    while (!rsIncidencias.EOF){
		  var Llaves = rsIncidencias.Fields.Item("Ins_ID").Value
          var iEstatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value
        
                
          ClaseEstatus = "plain"
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


           if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 && rsIncidencias.Fields.Item("Ins_ReportaProv").Value == 1){
			   
			   sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
			   			    var rsProveedor = AbreTabla(sSQL,1,0)
							
				sSQL = "SELECT Ins_GrupoID FROM Incidencia_Involucrados WHERE Ins_ID = " +  rsIncidencias.Fields.Item("Ins_ID").Value
							var rsGrupo = AbreTabla(sSQL,1,0)
			//Response.Write(sSQL)
			   //var IDUnica = -1
//				   IDUnica = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
//				sSQL = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Prov_ID="+IDUnica
//							var rsGruID = AbreTabla(sSQL,1,0)
					//Response.Write(sSQL)
							
				if(!rsGrupo.EOF){
				
				sSQL = "SELECT IncG_Nombre FROM Incidencia_Grupo WHERE IncG_ID=" +rsGrupo.Fields.Item("Ins_GrupoID").Value
							 rsGrupo = AbreTabla(sSQL,1,0)
				
			   %>
               		
            <tr  onclick="javascript:CargaDescripcion(<%=rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value%> , <%=rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value%> , <%=rsIncidencias.Fields.Item("Ins_ID").Value%>)">
          
                <td>
                   <!-- <input type="checkbox" class="i-checks">-->
                 
	                  Ticket: <strong><%=rsIncidencias.Fields.Item("Ins_ID").Value%> </strong>
                </td>
               	<td>
         		   		<span class="label label-<%=ClaseEstatus%>"><%=rsIncidencias.Fields.Item("Cat_Nombre").Value%> </span>
               	</td>
                <td>
				
	                  Reporta: <strong><%=rsProveedor.Fields.Item("Prov_Nombre").Value%> </strong>
                     
                   <br/>

                      Recibe: <%=rsGrupo.Fields.Item("IncG_Nombre").Value%> 
   </td>
                <td ><%=rsIncidencias.Fields.Item("Ins_Asunto").Value%></td>
                <td  >Vencimiento: <%=rsIncidencias.Fields.Item("Ins_FechaEntrega_Tarea").Value%><br />
               			  Ultima actualizaci&oacute;n: <%=rsIncidencias.Fields.Item("Ins_FechaUltimaModificacion").Value%>
                </td>
<!--                    <td class=""><i class="fa fa-paperclip"></i></td>-->  
                <td ><%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%></td>
            </tr>
		  <% 
				}
           }else{
		   %>
          	<tr onclick="javascript:CargaDescripcion(<%=rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value%> , <%=rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value%> , <%=rsIncidencias.Fields.Item("Ins_ID").Value%>)">
            
                <td >
                   <!-- <input type="checkbox" class="i-checks">-->
                  
                 Ticket: <strong><%=rsIncidencias.Fields.Item("Ins_ID").Value%> </strong>
                </td>
                	<td >
         		   		<span class="label label-<%=ClaseEstatus%>"><%=rsIncidencias.Fields.Item("Cat_Nombre").Value%> </span>
               	</td>

                <td >
       				Reporta: <strong><%=rsIncidencias.Fields.Item("REPORTA").Value%></strong>
              
                   <br/>
<%
                if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 &&  rsIncidencias.Fields.Item("Ins_ReportaProv").Value == 0){
	
				   sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
	   			//Response.Write(sSQL)
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
                <td><%=rsIncidencias.Fields.Item("Ins_Asunto").Value%></td>
				
                <td>
							<%
		//			 var sSQL = "SELECT  DATEDIFF (Hour, GETDATE(), '"+rsIncidencias.Fields.Item("Fecha").Value+"') As Horas "
//					 var rsHoras = AbreTabla(sSQL,1,0)
//
//					 var Horas = rsHoras.Fields.Item("Horas").Value	
						if(rsIncidencias.Fields.Item("Fecha").Value != null){
					var sSQL = "SELECT  CONVERT(VARCHAR, CONVERT(DATETIME,'"+rsIncidencias.Fields.Item("Fecha").Value+"'), 103) + ' ' +" 
									 + " CONVERT(VARCHAR, CONVERT(DATETIME,'"+rsIncidencias.Fields.Item("Fecha").Value+"'), 108)  AS Fecha_Venc"

					 var rsFechaV = AbreTabla(sSQL,1,0)
					%>
						Vencimiento: <%=rsFechaV.Fields.Item("Fecha_Venc").Value%><br />
						<%
						}
						%>
               			  Ultima actualizaci&oacute;n: <%=rsIncidencias.Fields.Item("Ins_FechaUltimaModificacion").Value%>
                </td>
<!--                    <td class=""><i class="fa fa-paperclip"></i></td>-->  
                <td><%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%></td>
            </tr>
<%	
  }
        rsIncidencias.MoveNext() 
        }
    rsIncidencias.Close()  

%>
            </tbody>
     </table>

</div>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    
 
	$('.btnExcel').click(function(e) { 
		var ip = new Date()
		var d = ip.toLocaleDateString();
		$.post("/pz/wms/Incidencias/CTRLGRAL_Incidencias_Excel.asp"
               , { 
			Ins_ID:$('#Ins_ID').val(),
		    InsO_ID: $('#InsO_ID').val(),
			FechaInicio:$('#inicio').val(),
		    FechaFin: $('#fin').val(),
			Estatus:$('#Ins_EstatusCG27').val(),
		    Atiende: $('#Atiende').val(),
			Reporta:$('#Reporta').val(),
		    InsT_ID: $('.InsT_IDPadre').val()
		}
               , function(data){
                  
                    var response = JSON.parse(data)
                    var ws = XLSX.utils.json_to_sheet(response);
					var wb = XLSX.utils.book_new(); 
                    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
                    XLSX.writeFile(wb, d +"Incidencias.xlsx");
                });
	});
});
    
    
function CargaIncidencia(c,t){

    $("#Ins_ID").val(c);
    $("#TA_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
     function CargaDescripcion(reporta, recibe, insid){
        
		            $.ajax({
                  url: "/pz/wms/Incidencias/Incidencias_Ajax.asp"
                , method: "post"
                , async: false
                , data: {
					   Ins_ID:insid,
					  Usuario: $("#IDUsuario").val(),
                      Tarea: 11 // Modal 
                }
                , success: function(res){
                }
            });
		
            var	Params = "?Ins_ID=" + insid
					Params += "&SegGrupo=" + $("#SegGrupo").val()
					Params += "&IDUsuario=" + $("#IDUsuario").val()
					Params += "&Reporta=" + reporta
					Params += "&Recibe=" + recibe
					Params += "&Lpp=1"  //este parametro limpia el cache
               
            $("#dvTablaIncidencias").load("/pz/wms/Incidencias/CTL_Incidencias_Descripcion.asp" + Params)        
        
		
    }        

</script>    
    
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var InsO_ID = Parametro("InsO_ID",-1)
	var InsT_ID = Parametro("InsT_ID",-1)
	var Recibe = Parametro("Recibe",-1)
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
    //esta booleana se usa para saber si no entra nada de filtros y solo entregar las de hoy
    var bHayParams = false  
    
    var sSQL = "SELECT  i.Ins_ID, Ins_Titulo, Ins_Asunto, i.InsT_ID, TA_ID, Ins_Usu_Reporta,  Ins_FechaEntrega_Tarea"
					+ ", Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID,Ins_EstatusCG27, Ins_ReportaProv, "
					 + " CONVERT(VARCHAR, CONVERT(DATETIME,Ins_FechaUltimaModificacion), 103) + ' '+" 
				 + " CONVERT(VARCHAR, CONVERT(DATETIME,Ins_FechaUltimaModificacion), 108) + ' hrs.' AS Ins_FechaUltimaModificacion " 
                 + " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Reporta ) as REPORTA "
                 +  " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Recibe ) as RECIBE "
				 + ", dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) Cat_Nombre"
  				 + ", CONVERT(VARCHAR(17), i.Ins_FechaRegistro, 103) AS Ins_FechaRegistro"
				+  " FROM Incidencia i"
			     +	  " inner join  Incidencia_Tipo t on i.InsT_ID = t.InsT_ID"
				 +	  " left join Incidencia_Involucrados p on  i.Ins_ID = p.Ins_ID "       
             	 + " WHERE i.Ins_ID >-1"
				 
	    if(Reporta >-1){
				   sSQL +=	" AND u.InU_IDUnico = " + Reporta
               	   sSQL += " AND (( i.Ins_Usu_Reporta = " + Reporta + "))"
		}
        if(Recibe >-1){
				   sSQL +=	" AND u.InU_IDUnico = " + Recibe
               	   sSQL += " AND (( i.Ins_Usu_Recibe = " + Recibe 
                   sSQL += " OR i.Ins_Usu_Escalado = " + Recibe
				   sSQL += " OR p.Ins_GrupoID= "+SegGrupo
				   sSQL += " OR p.Ins_UsuarioID=" + Recibe+ "))"
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
	sSQL += "  GROUP BY i.Ins_ID, i.InsT_ID, Ins_Titulo, Ins_Asunto, TA_ID, i.Ins_FechaRegistro, Ins_Usu_Reporta,  Ins_FechaEntrega_Tarea"
	sSQL += ", Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID, Ins_EstatusCG27, Ins_ReportaProv, Ins_FechaUltimaModificacion"
     sSQL += " ORDER BY i.Ins_FechaRegistro Desc "
//Response.Write(sSQL)
	
var rsIncidencias = AbreTabla(sSQL,1,0)
var i = 0
while (!rsIncidencias.EOF){
	%>
	<%=(i > 0 ) ? "," : ""  %>

	<%
	if( rsIncidencias.Fields.Item("TA_ID").Value > -1){
	   var sSQL  = " SELECT *,  dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) Cat_Nombre, e.TA_FolioRemision "
       sSQL += " FROM TransferenciaAlmacen t,  cliente c, TransferenciaAlmacen_FoliosEKT e, Almacen a "
       sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID  AND e.TA_ID=t.TA_ID"   
 	   sSQL += " AND t.TA_ID = " + rsIncidencias.Fields.Item("TA_ID").Value
        var rsTransferencia = AbreTabla(sSQL,1,0)
	
				sSQL = "SELECT p.Pro_SKU AS SKU, p.Pro_Nombre AS Producto, pc.Pro_SKU AS SKUC, pc.Pro_Nombre AS ProductoC "
					  + " FROM Incidencia_SKU i"
					  + " LEFT JOIN Producto p ON p.Pro_ID=i.Pro_ID"
					  + " LEFT JOIN Producto pc ON pc.Pro_ID=i.Pro_ID_Cambio"
					  + " WHERE  i.Ins_ID="+rsIncidencias.Fields.Item("Ins_ID").Value
					  + " GROUP BY p.Pro_SKU, p.Pro_Nombre,  pc.Pro_SKU, pc.Pro_Nombre "
//	if(rsIncidencias.Fields.Item("InsT_ID").Value == 27){
//	Response.Write(sSQL)
//	}
		        var rsSKU= AbreTabla(sSQL,1,0)
		
			sSQL = "SELECT p.Pro_SKU, p.Pro_Nombre, p.Pro_ID  FROM TransferenciaAlmacen_Articulo_Picking a "
					  + " INNER JOIN TransferenciaAlmacen t ON a.TA_ID=t.TA_ID "
					  + " INNER JOIN Producto p ON p.Pro_ID=a.Pro_ID"
					  + " WHERE a.TA_ID = "+rsIncidencias.Fields.Item("TA_ID").Value+ " AND Ins_ID="+rsIncidencias.Fields.Item("Ins_ID").Value
					  + "GROUP BY p.Pro_SKU, p.Pro_Nombre, p.Pro_ID "
//Response.Write(sSQL)
		        var rsSKUFal = AbreTabla(sSQL,1,0)
	
	}
           if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 && rsIncidencias.Fields.Item("Ins_ReportaProv").Value == 1){
			   
			   sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
			   			    var rsProveedor = AbreTabla(sSQL,1,0)
							
				sSQL = "SELECT Ins_GrupoID FROM Incidencia_Involucrados WHERE Ins_ID = " +  rsIncidencias.Fields.Item("Ins_ID").Value
							var rsGrupo = AbreTabla(sSQL,1,0)
			//Response.Write(sSQL)
			   var IDUnica = -1
				   IDUnica = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
				sSQL = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+IDUnica+" OR Emp_ID="+IDUnica
							var rsGruID = AbreTabla(sSQL,1,0)
			//Response.Write(sSQL)
							
				if(rsGrupo.Fields.Item("Ins_GrupoID").Value==rsGruID.Fields.Item("IncG_ID").Value){
				
				sSQL = "SELECT Gru_Nombre FROM SeguridadGrupo WHERE Gru_ID=" +rsGrupo.Fields.Item("Ins_GrupoID").Value
							 rsGrupo = AbreTabla(sSQL,1,0)
			 
               		
         %>
	{
    "Ticket":"<%=rsIncidencias.Fields.Item("Ins_ID").Value%>",
    "Estatus":"<%=rsIncidencias.Fields.Item("Cat_Nombre").Value%>",   
    "Reporta":"<%=rsProveedor.Fields.Item("Prov_Nombre").Value%>",   
    "Recibe":"<%=rsGrupo.Fields.Item("Gru_Nombre").Value%>",   
    "Asunto":"<%=rsIncidencias.Fields.Item("Ins_Asunto").Value%>",  
    "Ultima actualizaci&oacute;n":"<%=rsIncidencias.Fields.Item("Ins_FechaUltimaModificacion").Value%>",   
    "Registro":"<%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%>"
             
	}
		  <% 

		i++;
				}
           }else{
		         if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 &&  rsIncidencias.Fields.Item("Ins_ReportaProv").Value == 0){
	
				   sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
	   			//Response.Write(sSQL)
				    var rsProveedor = AbreTabla(sSQL,1,0)
	%>
	{
    "Ticket":"<%=rsIncidencias.Fields.Item("Ins_ID").Value%>",
    "Estatus":"<%=rsIncidencias.Fields.Item("Cat_Nombre").Value%>",   
    "Reporta":"<%=rsIncidencias.Fields.Item("REPORTA").Value%>",   
	"Recibe":"<%=rsProveedor.Fields.Item("Prov_Nombre").Value%>",   
    "Asunto":"<%=rsIncidencias.Fields.Item("Ins_Asunto").Value%>",   
    "Ultima actualizaci&oacute;n":"<%=rsIncidencias.Fields.Item("Ins_FechaUltimaModificacion").Value%>",   
    "Registro":"<%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%>"
	}
	<%
				}else{
		   	%>
	{
    "Ticket":"<%=rsIncidencias.Fields.Item("Ins_ID").Value%>",
    "Estatus":"<%=rsIncidencias.Fields.Item("Cat_Nombre").Value%>",   
    "Reporta":"<%=rsIncidencias.Fields.Item("REPORTA").Value%>",   
	"Recibe":"<%=rsIncidencias.Fields.Item("RECIBE").Value%>",   
    "Asunto":"<%=rsIncidencias.Fields.Item("Ins_Asunto").Value%>",   
	<%
		if (!rsTransferencia.EOF){
    %>
	"Cliente":"<%=rsTransferencia.Fields.Item("Cli_Nombre").Value%>",   
    "Transportista":"<%=rsTransferencia.Fields.Item("TA_Transportista").Value%>",   
    "Fecha Entrega":"<%=rsTransferencia.Fields.Item("TA_FechaEntrega").Value%>",   
	"Transferencia":"<%=rsTransferencia.Fields.Item("TA_Folio").Value%>",  
	"Fecha Elaboracion":"<%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%>",  
     "Remision":"<%=rsTransferencia.Fields.Item("TA_FolioRemision").Value%>",   
	"No. Tienda":"<%=rsTransferencia.Fields.Item("Alm_Numero").Value%>",   
	"Tienda":"<%=rsTransferencia.Fields.Item("Alm_Nombre").Value%>",   
    "Estado":"<%=rsTransferencia.Fields.Item("Alm_Estado").Value%>",   
    "Ciudad":"<%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%>",   
    "Estatus":"<%=rsTransferencia.Fields.Item("Cat_Nombre").Value%>",   
<%
	
		}
		if(!rsSKU.EOF){
		
				if(rsIncidencias.Fields.Item("InsT_ID").Value == 27){
	%>
	    		"SKU Correcto":"<%=rsSKU.Fields.Item("SKU").Value%>",   
	    		"SKU Cambiado":"<%=rsSKU.Fields.Item("SKUC").Value%>",   
	<%
	}
				if(rsIncidencias.Fields.Item("InsT_ID").Value == 28){
	%>    
				"SKU Sobrante":"<%=rsSKU.Fields.Item("SKU").Value%>",   
	<%
	
				}
		
		}
			if (!rsSKUFal.EOF){
		

				if(rsIncidencias.Fields.Item("InsT_ID").Value == 29||rsIncidencias.Fields.Item("InsT_ID").Value == 30){
	%>
	    		"SKU Faltante":"<%=rsSKUFal.Fields.Item("Pro_SKU").Value%>",   
		   		"SKU Correcto":"",   
	    		"SKU Cambiado":"",   
				"SKU Sobrante":"",   

	<%
				}

	
			}	
    %>
    "Ultima actualizaci&oacute;n":"<%=rsIncidencias.Fields.Item("Ins_FechaUltimaModificacion").Value%>",   
    "Registro":"<%=rsIncidencias.Fields.Item("Ins_FechaRegistro").Value%>"
	}
           <%
				}
			
		i++;
  }

        rsIncidencias.MoveNext() 
        }
    rsIncidencias.Close()  


%>]


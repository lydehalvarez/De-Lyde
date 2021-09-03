<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var ManD_Folio = Parametro("ManD_Folio","") 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var ManD_FolioCliente = Parametro("ManD_FolioCliente","")
	var ManD_Vehiculo = Parametro("ManD_Vehiculo","")
    var ManD_Placas = Parametro("ManD_Placas","")
    var ManD_Operador = Parametro("ManD_Operador","")
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var ManD_Ruta = Parametro("ManD_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
    var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")


    var sSQL  = " SELECT ManD_ID,ManD_Folio, ManD_Operador,(SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](ManD_Usuario)) as Usuario  " 
        sSQL += " , ManD_Transferencias as Total_TRA "
        sSQL += " , ManD_OrdenesDeVenta as Total_SO "
        sSQL += " , Prov_Nombre "
        sSQL += " , CONVERT(NVARCHAR(10),ManD_FechaRegistro,103)+' '+CONVERT(NVARCHAR(10),ManD_FechaRegistro,108)+' hrs' as FechaRegistro  "
        sSQL += " FROM Manifiesto_Devolucion d, Proveedor p "
        sSQL += " WHERE d.Prov_ID = p.Prov_ID  "
        sSQL += " AND ManD_Borrador = 1 "

    if (ManD_Folio !="") {   
        sSQL += " AND d.ManD_Folio LIKE '%"+ManD_Folio+"%'"
    }   
	//Response.Write(sSQL)
  
    if (ManD_Ruta > -1) {
        sSQL += " AND ManD_TipoDeRutaCG94 = "+ ManD_Ruta    
    }

    if ((FechaInicio == "" && FechaFin == "")) {
		 sSQL += " AND d.ManD_FechaRegistro  >= getdate() - 7 " 
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(ManD_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(ManD_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(ManD_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
	sSQL += " ORDER BY ManD_ID desc"


%>



<div class="ibox-title">
    <h3>Manifiestos en borrador <small>En esta secci&oacute;n podr&aacute;s quitar, agregar y cancelar de ser necesario</small></h3>
</div>  
  
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var rsManifiesto = AbreTabla(sSQL,1,0)
		if(!rsManifiesto.EOF){
			var ManD_ID = -1
			while (!rsManifiesto.EOF){
				ManD_ID = rsManifiesto.Fields.Item("ManD_ID").Value
	
        %>    
              <tr>
                 <td class="project-title">
                      <a href="#"><%=rsManifiesto.Fields.Item("ManD_Folio").Value%></a>
                    <br/>
                    <small><strong>Fecha Registro:</strong> <%=rsManifiesto.Fields.Item("FechaRegistro").Value%></small>
                    <br />
                    <small><strong>Hecho por:</strong> <%=rsManifiesto.Fields.Item("Usuario").Value%></small>
                </td>
                <td class="project-title">
                    <small>Transportista:</small>
                    <br />
                    <a><%=rsManifiesto.Fields.Item("Prov_Nombre").Value%></a>
                </td>
                <td class="project-title">
                    <small>Devoluci&oacute;n por:</small>
                    <br />
                    <a><%=rsManifiesto.Fields.Item("ManD_Operador").Value%></a>
                </td>
               <td class="project-title">
                    <a>Transferencias: <%=rsManifiesto.Fields.Item("Total_TRA").Value%></a>
                    <br />
                    <br />
                    <a>Orden de venta: <%=rsManifiesto.Fields.Item("Total_SO").Value%></a>
                </td>
                <td class="project-actions" width="31">
                    <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Borrador(<%=ManD_ID%>);  return false">
                    <i class="fa fa-plus"></i> Modificar</a>
                </td>
              </tr>
        <%
				rsManifiesto.MoveNext() 
				}
			rsManifiesto.Close()  
		}
		else
		{%>
        
        <td colspan="5">
			<i class="fa fa-info"></i> Sin informaci&oacute;n
        </td>
        <%       
		}
        %>       
    </tbody>
  </table>
</div>    

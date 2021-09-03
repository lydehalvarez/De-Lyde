<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var TA_Folio = Parametro("TA_Folio","") 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var Man_FolioCliente = Parametro("Man_FolioCliente","")
	var Man_Vehiculo = Parametro("Man_Vehiculo","")
    var Man_Placas = Parametro("Man_Placas","")
    var Man_Operador = Parametro("Man_Operador","")
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var Man_Ruta = Parametro("Man_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
    var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")


    var sSQL  = " SELECT TOP (100) *,(SELECT Nombre FROM dbo.tuf_Usuario_Informacion(Man_Usuario)) as Usuario "
		sSQL += ", (SELECT count(*) FROM TransferenciaAlmacen d  WHERE d.Man_ID = m.Man_ID) as Total_TRA"
		sSQL += ", (SELECT count(*)  FROM Orden_Venta v  WHERE v.Man_ID = m.Man_ID)  as Total_SO "
		sSQL += ",CONVERT(NVARCHAR(10),Man_FechaRegistro,103) + ' - ' + CONVERT(NVARCHAR(10),Man_FechaRegistro,108) as FechaReg "
		sSQL += " FROM Manifiesto_Salida m INNER JOIN Proveedor p ON m.Prov_ID=p.Prov_ID"
					+ " LEFT JOIN Cat_Catalogo c ON c.Cat_ID=Man_TipoDeRutaCG94 AND  c.Sec_ID =94 "
					+ " LEFT JOIN Cat_Estado e ON e.Edo_ID=m.Edo_ID"
        			+ " LEFT JOIN Cat_Aeropuerto a ON a.Aer_ID=m.Aer_ID  "
        sSQL += " WHERE  Man_Borrador = 1 "

    if (TA_Folio !="") {  
        sSQL += " AND t.TA_Folio LIKE '%"+ TA_Folio + "'"
    }       
    if (Aer_ID > 0) {  
        sSQL += " AND Aer_ID = "+ Aer_ID
    }   
    
    if (Transporte != "") {
        sSQL += "  AND (TA_Transportista ='"+ Transporte + "' OR TA_Transportista2 ='"+ Transporte + "')"
    }   
    if (Man_Ruta > -1) {
        sSQL += " AND a.Alm_Ruta = "+ Man_Ruta    
    }

	if (Ciudad != "") {
        sSQL += " AND a.Alm_Ciudad = '"+ Ciudad + "'"    
    }
    if ((FechaInicio == "" && FechaFin == "")) {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sSQL += " AND CAST(Man_FechaRegistro as date)  >= dateadd(day,-7,getdate()) "
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Man_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(Man_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Man_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " ORDER BY Man_ID desc"

%>



<div class="ibox-title">
    <h3>Manifiestos en borrador <small>En esta secci&oacute;n podr&aacute;s quitar, agregar y cancelar de ser necesario</small></h3>
</div>  
  
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var rsManifiesto = AbreTabla(sSQL,1,0)
        while (!rsManifiesto.EOF){
		var Man_ID = rsManifiesto.Fields.Item("Man_ID").Value

        %>    
      <tr>
         <td class="project-title">
              <a data-clipboard-target="#copyMan<%=Man_ID%>" id="copyMan<%=Man_ID%>"  class="textCopy"><%=rsManifiesto.Fields.Item("Man_Folio").Value%></a>
            <br/>
            <small>Fecha Registro: <%=rsManifiesto.Fields.Item("FechaReg").Value%></small>
            <br/>
            <small><strong>Hecho por: <%=rsManifiesto.Fields.Item("Usuario").Value%></strong></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Cat_Nombre").Value%></a>
            <br/>
          Ruta: R <%=rsManifiesto.Fields.Item("Man_Ruta").Value%> 
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Prov_Nombre").Value%></a>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Edo_Nombre").Value%></a>
            <br/>
          Aeropuerto: <%=rsManifiesto.Fields.Item("Aer_Nombre").Value%>
        </td>
       <td class="project-title">
            <a href="#">Transferencias (TRA): <%=rsManifiesto.Fields.Item("Total_TRA").Value%></a>
            <br />
            <br />
            <a href="#">Orden de venta (SO): <%=rsManifiesto.Fields.Item("Total_SO").Value%></a>
        </td>
        <td class="project-actions" width="31">
            <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Borrador(<%=Man_ID%>);  return false">
            <i class="fa fa-plus"></i> Modificar</a>
        </td>
      </tr>
        <%
            rsManifiesto.MoveNext() 
            }
        rsManifiesto.Close()   
        %>       
    </tbody>
  </table>
</div>    

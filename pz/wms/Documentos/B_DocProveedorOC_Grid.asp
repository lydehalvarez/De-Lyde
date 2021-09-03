<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Prov_ID = Parametro("Prov_ID",-1) 
    var OC_Folio = Parametro("OC_Folio","")
    var OC_FolioProveedor = Parametro("OC_FolioProveedor","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")

    var bHayParams = false  
   
    var sSQL  = " SELECT o.OC_ID, o.Prov_ID,  c.Prov_Nombre, OC_FolioProveedor, o.OC_Folio, o.OC_FechaRegistro,  o.OC_FechaElaboracion "
        sSQL += " , (SELECT count(*) "
        sSQL +=      " FROM Proveedor_OrdenCompra_Documento d "
        sSQL +=     " WHERE d.OC_ID = o.OC_ID AND d.Prov_ID=o.Prov_ID) as CANTIDAD"
        sSQL += " FROM Proveedor_OrdenCompra o, proveedor c, Almacen a"
        sSQL += " WHERE o.Prov_ID=c.Prov_ID  "   

    if (Prov_ID > -1) { 
    
        sSQL += "AND o.Prov_ID = "+ Prov_ID
    }   
    
    if (OC_Folio != "") {
        bHayParams = true
        sSQL += "  AND OC_Folio like '%"+ OC_Folio + "%'"
    }   
    
 if (OC_FolioProveedor != "") {
        bHayParams = true
        sSQL += " AND OC_FolioProveedor like '%"+ OC_FolioProveedor + "%'"   
    }
    if (FechaInicio == "" && FechaFin == "") {
        if(!bHayParams){
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sSQL += " AND CAST(OC_FechaRegistro as date)  >= dateadd(day,-30,getdate()) "
        }
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(OC_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(OC_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(OC_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " GROUP BY o.OC_ID, o.Prov_ID, c.Prov_Nombre, OC_FolioProveedor, o.OC_Folio, o.OC_FechaRegistro,  o.OC_FechaElaboracion ORDER BY o.OC_ID desc"
    

    //1	En proceso     | Warning
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
    
%>
<div class="ibox-title">
    <h5>Ordenes de Compra</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
	
        var rsOC = AbreTabla(sSQL,1,0)
        while (!rsOC.EOF){
		var Llaves = rsOC.Fields.Item("Prov_ID").Value
		 Llaves += ", " + rsOC.Fields.Item("OC_ID").Value
        %>    
      <tr>
         <td class="project-title">
            <a href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><%=rsOC.Fields.Item("Prov_Nombre").Value%></a>
            <br/>
            <small></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOC.Fields.Item("OC_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsOC.Fields.Item("OC_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOC.Fields.Item("OC_FolioProveedor").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsOC.Fields.Item("OC_FechaElaboracion").Value%></small>
        </td>

         <td class="project-title">
            <a href="#">Documentos   </a>
            <br/>
            <small><%=rsOC.Fields.Item("CANTIDAD").Value%> </small>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaProveedor(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsOC.MoveNext() 
            }
        rsOC.Close()   
        %>       
    </tbody>
  </table>


</div>

<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    

});
    
    
function CargaProveedor(p,o){

    $("#Prov_ID").val(p);
    $("#OC_ID").val(o);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    
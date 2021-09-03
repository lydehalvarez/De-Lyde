<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Cli_ID = Parametro("Cli_ID",-1) 
    var TA_Folio = Parametro("TA_Folio","")
    var TA_FolioCliente = Parametro("TA_FolioCliente","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")

    var bHayParams = false  
    
    var sSQL  = " SELECT * "
        sSQL += " , (SELECT count(*) "
        sSQL +=      " FROM TransferenciaAlmacen_Documentos d "
        sSQL +=     " WHERE d.TA_ID = t.TA_ID ) as CANTIDAD "
        sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID  "   
   
    if (Cli_ID > -1) {  
        sSQL += " AND t.Cli_ID = "+ Cli_ID
        bHayParams = true
    }   
    
    if (TA_Folio != "") {
        bHayParams = true
        sSQL += "  AND TA_Folio like '%"+ TA_Folio + "%'"
    }   
    
    if (TA_FolioCliente != "") {
        bHayParams = true
        sSQL += " AND TA_FolioCliente like '%"+ TA_FolioCliente + "%'"   
    }

    if (FechaInicio == "" && FechaFin == "") {
        if(!bHayParams){
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sSQL += " AND CAST(TA_FechaRegistro as date)  >= dateadd(day,-7,getdate()) "
        }
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(TA_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(TA_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(TA_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " ORDER BY t.TA_ID desc"

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
    <h5>Transferencias</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var rsTransferencia = AbreTabla(sSQL,1,0)
        while (!rsTransferencia.EOF){
		var Llaves = rsTransferencia.Fields.Item("Cli_ID").Value
		 Llaves += ", " + rsTransferencia.Fields.Item("TA_ID").Value

        %>    
      <tr>
         <td class="project-title">
            <a href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_FolioCliente").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
            <br/>
            <small> <%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%></small>
        </td>
         <td class="project-title">
            <a href="#">Documentos   </a>
            <br/>
            <small><%=rsTransferencia.Fields.Item("CANTIDAD").Value%> </small>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsTransferencia.MoveNext() 
            }
        rsTransferencia.Close()   
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
    
    
function CargaCliente(c,t){

    $("#Cli_ID").val(c);
    $("#TA_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    
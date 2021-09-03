<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    LimpiaValores()
   
    var Cli_ID = Parametro("Cli_ID",-1) 
    var CliOC_Folio = Parametro("CliOC_Folio","")
    var CliOC_NumeroOrdenCompra = Parametro("CliOC_NumeroOrdenCompra","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")

    var bHayParams = false  
   
    var sSQL  = " SELECT o.*, a.Alm_Estado, a.Alm_Ciudad, c.Cli_Nombre "
        sSQL += " , (SELECT count(*) "
        sSQL +=      " FROM Cliente_OrdenCompra_Documento d "
        sSQL +=     " WHERE d.CliOC_ID = o.CliOC_ID AND d.Cli_ID=o.Cli_ID) as CANTIDAD"
        sSQL += " FROM Cliente_OrdenCompra o, cliente c, Almacen a"
        sSQL += " WHERE o.Cli_ID=c.Cli_ID AND o.CliOC_EnviarAlmacen = a.Alm_ID "   
   
    if (Cli_ID > -1) {  
        bHayParams = true
        sSQL += "AND o.Cli_ID = "+ Cli_ID
    }   
    
    if (CliOC_Folio != "") {
        bHayParams = true
        sSQL += "  AND CliOC_Folio like '%"+ CliOC_Folio + "%'"
    }   
    
    if (CliOC_NumeroOrdenCompra != "") {
        bHayParams = true
        sSQL += " AND CliOC_NumeroOrdenCompra like '%"+ CliOC_NumeroOrdenCompra + "%'"   
    }

    if (FechaInicio == "" && FechaFin == "") {
        if(!bHayParams){
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sSQL += " AND CAST(CliOC_FechaRegistro as date)  >= dateadd(day,-30,getdate()) "
        }
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(CliOC_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(CliOC_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(CliOC_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " ORDER BY o.CliOC_ID desc"
    

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
	
        var rsCliOC = AbreTabla(sSQL,1,0)
        while (!rsCliOC.EOF){
		var Llaves = rsCliOC.Fields.Item("Cli_ID").Value
		 Llaves += ", " + rsCliOC.Fields.Item("CliOC_ID").Value
	
        %>    
      <tr>
         <td class="project-title">
            <a href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><%=rsCliOC.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliOC_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsCliOC.Fields.Item("CliOC_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliOC_NumeroOrdenCompra").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsCliOC.Fields.Item("CliOC_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("Alm_Estado").Value%></a>

            <br/>
            <small> <%=rsCliOC.Fields.Item("Alm_Ciudad").Value%></small>
        </td>
         <td class="project-title">
            <a href="#">Documentos   </a>
            <br/>
            <small><%=rsCliOC.Fields.Item("CANTIDAD").Value%> </small>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsCliOC.MoveNext() 
            }
        rsCliOC.Close()   
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
    $("#CliOC_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    
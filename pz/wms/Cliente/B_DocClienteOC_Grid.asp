<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var Cli_ID = Parametro("Cli_ID",-1) 
    var CliOC_Folio = Parametro("CliOC_Folio","")
    var CliOC_NumeroOrdenCompra = Parametro("CliOC_NumeroOrdenCompra","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
    var Estatus = Parametro("Estatus",-1) 
    var ASN = Parametro("ASN","") 
    var SKU = Parametro("SKU","") 
    var Cita = Parametro("Cita","") 

    var bHayParams = false  

	var sSQL  = " SELECT o.CliOC_Folio, o.Cli_ID,o.CliOC_ID,o.CliOC_FechaRegistro,o.CliOC_NumeroOrdenCompra,o.CliOC_FechaElaboracion, CliOC_EstaCompleta, "
					+ " CliOC_TotalArticulos, CliOC_ArticulosRecibidos, a.Alm_Estado, a.Alm_Ciudad, c.Cli_Nombre, Cat_Nombre AS Estatus "
         			+ " FROM Cliente_OrdenCompra o INNER JOIN cliente c "
					+ " ON o.Cli_ID=c.Cli_ID LEFT OUTER JOIN Almacen a ON o.CliOC_EnviarAlmacen=a.Alm_ID "
					+ " INNER JOIN Cliente_OrdenCompra_Articulos at ON  o.CliOC_ID = at.CliOC_ID "
					+ " LEFT OUTER JOIN Cliente_OrdenCompra_Entrega e ON o.CliOC_ID=e.CliOC_ID "
					+ " INNER JOIN Cliente_OrdenCompra_EntregaProducto ep ON  o.CliOC_ID = ep.CliOC_ID "
					+ " INNER JOIN Inventario_Recepcion i ON i.IR_ID=e.IR_ID "
					+ " INNER JOIN Cat_Catalogo ct ON ct.Cat_ID=o.CliOC_EstatusCG52 AND ct.Sec_ID = 52"
					+ " LEFT OUTER JOIN ASN s ON ep.ASN_ID=s.ASN_ID WHERE o.CliOC_ID > -1 "

   if (FechaInicio == "" && FechaFin == "" && Cli_ID == -1 && CliOC_Folio == "" && CliOC_NumeroOrdenCompra == "" && Estatus == -1 && ASN == "" && SKU == "" && Cita == "")  {
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
	  if (Cli_ID > -1) {  
        bHayParams = true
        sSQL += " AND o.Cli_ID = "+ Cli_ID
    }   
    
    if (CliOC_Folio != "") {
        bHayParams = true
        sSQL += "  AND CliOC_Folio like '%"+ CliOC_Folio + "%'"
    }   
    
    if (CliOC_NumeroOrdenCompra != "") {
        bHayParams = true
        sSQL += " AND CliOC_NumeroOrdenCompra like '%"+ CliOC_NumeroOrdenCompra + "%'"   
    }
     if (Estatus > -1) {
        bHayParams = true
        sSQL += "  AND CliOC_EstatusCG52 ="+ Estatus 
    }   

    if (ASN != "") {
        bHayParams = true
        sSQL += "  AND ASN_FolioCliente like '%"+ ASN + "%'"
    }   

    if (SKU != "") {
        bHayParams = true
        sSQL += "  AND CliOCP_SKU = '"+SKU+"'"
    }   

    if (Cita != "") {
        bHayParams = true
        sSQL += "  AND IR_Folio = '"+ Cita + "'"
    }   


	sSQL += " GROUP BY o.CliOC_Folio, o.Cli_ID,o.CliOC_ID,o.CliOC_FechaRegistro,o.CliOC_NumeroOrdenCompra,o.CliOC_FechaElaboracion, a.Alm_Estado, a.Alm_Ciudad, c.Cli_Nombre, Cat_Nombre, CliOC_EstaCompleta, CliOC_TotalArticulos, CliOC_ArticulosRecibidos ORDER BY o.CliOC_ID desc"
    

    //1	En proceso     | Warning
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
    //Response.Write(sSQL)
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
            <a href="#"><% 
			var Completa = rsCliOC.Fields.Item("CliOC_EstaCompleta").Value
			if(Completa == 1){ %>Completa <%} else { %> Incompleta <% } %></a>
            <br/>
            <small> Total articulos: <%=rsCliOC.Fields.Item("CliOC_TotalArticulos").Value%> Articulos recibidos: <%=rsCliOC.Fields.Item("CliOC_ArticulosRecibidos").Value%></small>
        </td>
         <td class="project-title">
            <a href="#">Estatus   </a>
            <br/>
            <small><%=rsCliOC.Fields.Item("Estatus").Value%> </small>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:OCFunciones.CargaOC(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
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
    
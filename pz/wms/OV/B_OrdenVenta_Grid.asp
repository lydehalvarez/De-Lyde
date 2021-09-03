<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0
    /* Folio,Guia,OV_CUSTOMER_SO,OV_CUSTOMER_NAME*/
   
    var Cli_ID = Parametro("Cli_ID",-1)
    
    var Folio = Parametro("Folio","")
    var Guia = Parametro("Guia","")

    var OV_CUSTOMER_SO = Parametro("OV_CUSTOMER_SO","")
    var OV_CUSTOMER_NAME = Parametro("OV_CUSTOMER_NAME","")
      
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")

    //esta booleana se usa para saber si no entra nada de filtros y solo entregar las de hoy
    var bHayParams = false
   
    //Response.Write("Cli_ID: " + Cli_ID + "<br>")
   
   // var sSQL  = " SELECT * FROM dbo.ufn_Cte_OrdenesDeVentaXCte("+ Parametro("IDUsuario",-1) +", 2)"
    var sSQL  = "EXEC dbo.SP_Cte_OrdenesDeVentaXCte "
        sSQL += " @Cli_ID = "+ Cli_ID

        sSQL += ", @SysID = 19 "
   
    if (Folio != "") {
        bHayParams = true
        sSQL += " , @FolioLYDE= '"+ Folio + "'"
    }   
    
    if (Guia != "") {
        bHayParams = true
        sSQL += ", @Guia = '"+ Guia + "'"
    }       

    if (OV_CUSTOMER_SO != "") {
        bHayParams = true
        sSQL += ", @FolioCTE = '"+ OV_CUSTOMER_SO + "'"
    }     
    
    if (OV_CUSTOMER_NAME != "") {
        bHayParams = true
        sSQL += " , @Nombre = '"+ OV_CUSTOMER_NAME + "'"
    }         

    if (FechaInicio != "") {    
        bHayParams = true
        FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
        sSQL += " , @dateFechaInicio = '"+ FechaInicio + "'"
    }

    if (FechaFin != "") {    
        bHayParams = true
        FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
        sSQL += " , @dateFechaFin = '"+ FechaFin + "'"
    } 
   
       
   
//    if (FechaInicio == "" && FechaFin == "") {
//    
//        FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//        sSQL += " AND CAST(OV_FechaRegistro as date)  >= DATEADD(month,-1,getdate()) "
//    
//    } else {   
//    
//        if(FechaInicio == "" ) {
//            if(FechaFin != "" ) {
//                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//                sSQL += " AND CAST(OV_FechaRegistro as date)  <= '" + FechaFin + "'"
//            }
//        } else {
//            
//            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//            if(FechaFin == "" ) {
//                sSQL += " AND CAST(OV_FechaRegistro as date)  >= '" + FechaFin + "'"
//            } else {
//                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
//                sSQL += " AND CAST(OV_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
//            }
//        }
//    
//    }
        
    //Response.Write("FechaInicio: " + FechaInicio + " | FechaFin: " + FechaFin)
    
    //Response.Write("<br>"+sSQL)
    //Response.End()
   
    //1	En proceso     | Warning 
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
    
%>
<hr>    
<div class="ibox-title">
    <h5>Ordenes de Venta</h5>
</div>    
<div class="project-list">
  <table class="table table-hover" width="100%">
    <tbody>
<%
    var iRenglon = 0
    var Llaves = ""
    var ClaseEstatus = ""
    var iEstatus = 0

    var rsOrdenVenta = AbreTabla(sSQL,1,0)

    while (!rsOrdenVenta.EOF){

    Llaves = rsOrdenVenta.Fields.Item("Cli_ID").Value
    Llaves += ", " + rsOrdenVenta.Fields.Item("OV_ID").Value

    iEstatus = rsOrdenVenta.Fields.Item("Estatus").Value
    iRenglon++

    ClaseEstatus = "plain"

    switch (parseInt(iEstatus)) {

        case 4:
             ClaseEstatus = "info"   
        break;    
        case 5:
            ClaseEstatus = "primary"
        break;     
        case 10:
            ClaseEstatus = "success"
        break;    
        case 11:
            ClaseEstatus = "warning"
        break;   
        case 16:
            ClaseEstatus = "danger"
        break;

    }   
%>  
        <!--onDblClick="javascript:CargaTransferencia(<%=Llaves%>);"-->
      <tr >
         <td width="17" class="project-title" style="width: 10px;">
             <div style="font-size: 20px;text-align: right;"><%=iRenglon%></div>
        </td>      
         <td width="284" class="project-title">
            <a><%=rsOrdenVenta.Fields.Item("Folio").Value%></a>
            <br/>
            <span class="label label-<%=ClaseEstatus%>"><%=rsOrdenVenta.Fields.Item("Estatus").Value%></span>
            <br/> 
            <small>Transportista: <%=rsOrdenVenta.Fields.Item("Transportista").Value%></small>
        </td>
        <td width="171" class="project-title">
            <a><%//=rsOrdenVenta.Fields.Item("OV_Folio").Value%></a>
            <br/>
            <small>Gu&iacute;a: <%=rsOrdenVenta.Fields.Item("Guia").Value%></small>
        </td>
        <td width="218" class="project-title">
            <a ><%=rsOrdenVenta.Fields.Item("OV_CUSTOMER_SO").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsOrdenVenta.Fields.Item("FechaElaboracion").Value%></small>
        </td>
        <td width="296" class="project-title">
            <a>Cliente: <%=rsOrdenVenta.Fields.Item("Destinatario").Value%></a>
            <br/>
            <small>Tel&eacute;fono: <%=rsOrdenVenta.Fields.Item("Telefono").Value%></small>
        </td>
         <td width="6" class="project-title">
            
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaOrdenVenta(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsOrdenVenta.MoveNext() 
            }
        rsOrdenVenta.Close()   
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
    
    
function CargaOrdenVenta(c,o){

    $("#Cli_ID").val(c);
    $("#OV_ID").val(o);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    
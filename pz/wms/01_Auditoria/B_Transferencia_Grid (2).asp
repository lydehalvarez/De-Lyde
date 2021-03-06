<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Cli_ID = Parametro("Cli_ID",-1) 
    var TA_Folio = Parametro("TA_Folio","")
    var TA_FolioCliente = Parametro("TA_FolioCliente","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
    var TA_EstatusCG51 = Parametro("TA_EstatusCG51",4)
    var Remision = Parametro("Remision","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")


    //esta booleana se usa para saber si no entra nada de filtros y solo entregar las de hoy
    var bHayParams = false  
    
    var sSQL  = " SELECT * "
        sSQL += " , Cat_Nombre as ESTATUS "
        sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Cat_Catalogo ct "
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID  "  
        sSQL += " AND t.TA_EstatusCG51 = ct.Cat_ID AND ct.Sec_ID = 51 "
   
    if (Cli_ID > -1) {  
        sSQL += " AND t.Cli_ID = " + Cli_ID
    }   
 
    if (TA_EstatusCG51 > 0) { 
        bHayParams = true
        sSQL += " AND t.TA_EstatusCG51 = " + TA_EstatusCG51
    }      
 
    if (TA_Folio != "") {
        bHayParams = true
        sSQL += "  AND TA_Folio like '%"+ TA_Folio + "%'"
    }   
    
    if (Remision != "") {
        bHayParams = true
        sSQL += " AND TA_ID in ( SELECT DISTINCT TA_ID FROM TransferenciaAlmacen_FoliosEKT "
        sSQL += " WHERE TA_FolioRemision like '%"+ Remision + "%' )"   
    }
        
    if (TA_FolioCliente != "") {
        bHayParams = true
        sSQL += " AND TA_FolioCliente like '%"+ TA_FolioCliente + "%'"   
    }   
        

    if (FechaInicio == "" && FechaFin == "") {    
        FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
        sSQL += " AND CAST(TA_FechaRegistro as date)  >= DATEADD(month,-1,getdate()) "
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
Response.Write(sSQL)
    //1	En proceso     | Warning 
    //2	Terminada      | Default
    //3	Revisi??n       | Primary
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
        var iRenglon = 0
        var Llaves = ""
        var ClaseEstatus = ""
        var iEstatus = 0
        var rsTransferencia = AbreTabla(sSQL,1,0)
        while (!rsTransferencia.EOF){
		  Llaves = rsTransferencia.Fields.Item("Cli_ID").Value
		  Llaves += ", " + rsTransferencia.Fields.Item("TA_ID").Value
          iEstatus = rsTransferencia.Fields.Item("TA_EstatusCG51").Value
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
        
      <tr onDblClick="javascript:CargaTransferencia(<%=Llaves%>);">
         <td class="project-title" style="width: 10px;">
             <div style="font-size: 20px;text-align: right;"><%= iRenglon %></div>
        </td>      
         <td class="project-title">
            <a><%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <span class="label label-<%=ClaseEstatus%>"><%=rsTransferencia.Fields.Item("ESTATUS").Value%></span>
            <br/> 
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <a ><%=rsTransferencia.Fields.Item("TA_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a ><%=rsTransferencia.Fields.Item("TA_FolioCliente").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a ><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
            <br/>
            <small> <%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%></small>
        </td>
         <td class="project-title">
            
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaTransferencia(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
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
    
    
function CargaTransferencia(c,t){

    $("#Cli_ID").val(c);
    $("#TA_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var IR_ID = Parametro("IR_ID",-1)
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var IDUsuario = Parametro("IDUsuario",-1)	
	var BPM_Pro_ID = Parametro("BPM_Pro_ID",-1)	
	var CliEnt_ID = Parametro("CliEnt_ID",-1)	
	var OV_ID = Parametro("OV_ID",-1)	
	var TA_ID = Parametro("TA_ID",-1)	
	
	var keys = '{IR_ID:'+IR_ID
				+',TA_ID:'+TA_ID
				+',OV_ID:'+OV_ID
				+',Cli_ID:'+Cli_ID
				+',CliOC_ID:'+CliOC_ID
				+',Prov_ID:'+Prov_ID
				+',BPM_Pro_ID:'+BPM_Pro_ID
				+',IDUsuario:'+IDUsuario
				+'}'
				
	//Response.Write(keys)
	var Pendiente = ""		
	if(IR_ID > -1){
        Pendiente = "SELECT e.Pro_ID, a.CliOCP_SKU, CliEnt_ArticulosRecibidos as articulos ,ISNULL(SUM(Pt_Cantidad),0) Por_escanear "
					+" FROM Cliente_OrdenCompra c  "
					+" INNER JOIN Cliente_OrdenCompra_Articulos a  "
						+" ON c.CliOC_ID = a.CliOC_ID  "
						+" and c.Cli_ID=a.Cli_ID  "
					+" INNER JOIN cliente cl  "
						+" ON cl.Cli_ID=c.Cli_ID  "
					+" INNER JOIN Cliente_OrdenCompra_EntregaProducto e  "
						+" ON a.CliOC_ID = e.CliOC_ID  "
						+" AND a.Cli_ID=e.Cli_ID  "
						+" and a.Pro_ID = e.Pro_ID  "
					+" INNER JOIN Cliente_OrdenCompra_Entrega en  "
						+" ON en.CliOC_ID = e.CliOC_ID  "
						+" AND en.Cli_ID=e.Cli_ID  "
						+" and en.CliEnt_ID = e.CliEnt_ID  "
					+" LEFT JOIN Recepcion_Pallet rp "
						+" ON en.IR_ID = rp.IR_ID "
						+" AND e.Pro_ID = rp.Pro_ID " 
					+" WHERE en.IR_ID = "+IR_ID
					+" GROUP BY c.Cli_ID, e.Pro_ID, a.CliOCP_SKU, CliEnt_ArticulosRecibidos"
	}


%>

<div class="ibox">
    <div class="row">
        <div class="col-md-12">
            <table class="table table-condensed table-hover" style="background: white;">
            <tr>
                <th>SKU</th>
                <th><small>Piezas en cita</small></th>
                <th><small>Piezas por clasificar</small></th>
                <th><small>Piezas ya clasificadas</small></th>
            </tr>
                <%
                var rsPendiente = AbreTabla(Pendiente,1,0)
				//Response.Write(Pendiente)
                if(!rsPendiente.EOF){
                    var CliOCP_SKU = ""
                    var articulos = ""
                    var Por_escanear = ""
                    var Total = 0
                    var Total_Por_escanear = 0
                    var TotalPendiente = 0
                    var TotalRestante = 0
                    while(!rsPendiente.EOF){
                        CliOCP_SKU = rsPendiente.Fields.Item("CliOCP_SKU").Value
                        articulos = rsPendiente.Fields.Item("articulos").Value
                        Por_escanear = rsPendiente.Fields.Item("Por_escanear").Value
						
                        Total = Total + articulos
                        Total_Por_escanear = Total_Por_escanear + Por_escanear
                        TotalRestante = articulos - Por_escanear
                        TotalPendiente = TotalPendiente + TotalRestante
						
                        var bgEs = ""
                        if(articulos > Por_escanear){
                            bgEs = "bg-warning"
                        }
						if(articulos == Por_escanear){
                            bgEs = "bg-primary"
                        }
                %>	
                        <tr>
                            <td class="textCopy"><%=CliOCP_SKU%></td>
                            <td class="textCopy"><%=articulos%></td>
                            <td class="<%=bgEs%> textCopy"><%=TotalRestante%></td>
                            <td class="textCopy"><%=Por_escanear%></td>
                        </tr>
                <%		
                        rsPendiente.MoveNext() 
                    }
                    rsPendiente.Close()
                    
                    var bg = "bg-primary"
                    if(TotalPendiente != 0){
                        bg = "bg-danger"
                    }
                %>
                    <tr>
                        <td><strong>Total:</strong></td>
                        <td><%=Total%></td>
                        <td class="<%=bg%>"><%=TotalPendiente%></td>
                        <td><%=Total_Por_escanear%></td>
                    </tr>
                <%		
                    }else{
                %>		
                    <tr>
                        <td colspan="3"><i class="fa fa-info-circle"></i>&nbsp;No se encontraron datos</td>
                    </tr>
                <%
                }
                %>
            
            
            </table>
        </div>
    </div>
</div>
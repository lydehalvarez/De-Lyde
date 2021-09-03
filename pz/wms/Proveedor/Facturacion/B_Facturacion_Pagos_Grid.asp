<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
 
    var Prov_ID = Parametro("Prov_ID",-1) 

    var Pag_Monto = Parametro("Pag_Monto",-1) 
    var Pag_ReferenciaBancaria = Parametro("Pag_ReferenciaBancaria","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
    var Pag_AplicadoCG150 = Parametro("Pag_AplicadoCG150",1)


    //esta booleana se usa para saber si no entra nada de filtros y solo entregar las de hoy
    var bHayParams = false  
    
    var sSQL  = " SELECT p.*, pv.Prov_Nombre, ct.Cat_Nombre AS estatus "
        sSQL += " FROM Proveedor_Pago p, Cat_Catalogo ct , Proveedor pv"
        sSQL += " WHERE  p.Pag_AplicadoCG150 = ct.Cat_ID AND ct.Sec_ID = 150 AND pv.Prov_ID=p.Prov_ID "
        sSQL += " AND p.Prov_ID = " + Prov_ID
   // Response.Write(sSQL)
    if (Pag_Monto > -1) {  
        sSQL += " AND Pag_Monto = " + Pag_Monto
    }   
 
    if (Pag_AplicadoCG150 > 0) { 
        bHayParams = true
        sSQL += " AND Pag_AplicadoCG150 = " + Pag_AplicadoCG150
    }      
 
    if (Pag_ReferenciaBancaria != "") {
        bHayParams = true
        sSQL += "  AND Pag_ReferenciaBancaria like '%"+ Pag_ReferenciaBancaria + "%'"
    }   
    
 
        

    if (FechaInicio == "" && FechaFin == "") {    
        FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
        sSQL += " AND CAST(Pag_FechaPago as date)  >= DATEADD(month,-1,getdate()) "
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Pag_FechaPago as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(Pag_FechaPago as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Pag_FechaPago as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " ORDER BY Pag_FechaRegistro DESC"
//Response.Write(sSQL)
    //1	En proceso     | Warning 
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
    
%>
    <h5>Pagos de proveedor</h5>
  <table class="table table-hover">
    <tbody>
<%
        var iRenglon = 0
        var Llaves = ""
        var ClaseEstatus = ""
        var iEstatus = 0
        var rsPagos = AbreTabla(sSQL,1,0)
        while (!rsPagos.EOF){
		  Llaves = rsPagos.Fields.Item("Pag_ID").Value
          iRenglon++
                
          ClaseEstatus = "plain"
          switch (parseInt(iEstatus)) {
	 		
	 		case 1:
                 ClaseEstatus = "info"   
            break;    
            case 5:
                ClaseEstatus = "primary"
            break;     
            case 4:
                ClaseEstatus = "success"
            break;    
            case 2:
                ClaseEstatus = "warning"
            break;   
            case 3:
                ClaseEstatus = "danger"
            break;        
            }   
        %>  
  
      <tr onDblClick="javascript:CargaPago(<%=Llaves%>);">
         <td class="project-title" style="width: 10px;">
             <div style="font-size: 20px;text-align: right;"><%= iRenglon %></div>
        </td>      
         <td class="project-title">
            <a><%=rsPagos.Fields.Item("Prov_Nombre").Value%></a>
        </td>
         <td class="project-title">
            <a >Fecha Pago: <br /><small><%=rsPagos.Fields.Item("Pag_FechaPago").Value%></small></a>
        </td>
        <td class="project-title">
            <span class="label label-<%=ClaseEstatus%>"><%=rsPagos.Fields.Item("ESTATUS").Value%></span>
            <br/>
            <small>Referencia bancaria: <%=rsPagos.Fields.Item("Pag_ReferenciaBancaria").Value%></small>
        </td>
        
        <td class="project-title">
             <a >Monto: $<%=rsPagos.Fields.Item("Pag_Monto").Value%>.00</a>
             <br />
           <a > <small>Monto aplicado: $<%=rsPagos.Fields.Item("Pag_MontoAplicado").Value%>.00</small></a>
            <br/>
            <small> Aplicaci&oacute;n: <%=rsPagos.Fields.Item("Pag_FechaAplicacion").Value%></small>
        </td>
        <td class="project-title">
            <a >Pago parcial: $<%=rsPagos.Fields.Item("Pag_Parcial").Value%>.00</a>
        </td>
        <td class="project-title">
            <a >Fecha Registro: </a><br /><small> <%=rsPagos.Fields.Item("Pag_FechaRegistro").Value%></small>
        </td>

         <td class="project-title">
            
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaPago(<%=Llaves%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsPagos.MoveNext() 
            }
        rsPagos.Close()   
        %>       
    </tbody>
  </table>



<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    

});
    
    
function CargaPago(c){

    $("#Pag_ID").val(c);
	//console.log()
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    
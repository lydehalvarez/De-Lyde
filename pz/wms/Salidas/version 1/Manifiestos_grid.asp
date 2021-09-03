<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Transporte = Parametro("Transporte","")
    var Estado = Parametro("Estado","")
    var Ciudad = Parametro("Ciudad","")
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
	var Tarea =  Parametro("Tarea",-1)	

    var bHayParams = false  
 if(Tarea == -1){
    var sSQL  = " SELECT * "
/*%>sSQL += " , (SELECT count(*) "
        sSQL += " FROM TransferenciaAlmacen_Documentos d "
        sSQL += " WHERE d.TA_ID = t.TA_ID ) as CANTIDAD "<%*/ 
		sSQL += " FROM Orden_Venta v, cliente c,"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID  AND dbo.fn_CatGral_DameDato(51,OV_EstatusCG51)  = 'Shipping' "   
    
    if (Transporte != "") {
        bHayParams = true
        sSQL += "  AND (OV_TRACKING_COM ='"+ Transportista + "' OR OV_TRACKING_COM2 ='"+ Transportista + "')"
    }   
/*%>    if (Transporte != "" && Tarea == 2) {
        bHayParams = true
    }   
<%*/    
    if (Estado != "") {
        bHayParams = true
        sSQL += " AND OV_Estado = "+ Estado    
    }
	
  if (Ciudad != "") {
        bHayParams = true
        sSQL += " AND OV_Ciudad = "+ Ciudad    
    }


    if ((FechaInicio == "" && FechaFin == "")) {
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
        
	sSQL += " ORDER BY OV_ID desc"

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
    <h5>Ordenes de venta</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var rsOV = AbreTabla(sSQL,1,0)
        while (!rsOV.EOF){
	     %>    
      <tr>
         <td class="project-title">
       <%=rsOV.Fields.Item("Cli_Nombre").Value%>
            <br/>
            <small>Transportista: 
			<%
			if(rsOV.Fields.Item("OV_TRACKING_COM").Value)==""){
			%><%=rsOV.Fields.Item("OV_TRACKING_COM2").Value%></small>
			<%
			}
			if(rsOV.Fields.Item("OV_TRACKING_COM2").Value==""){
			%><%=rsOV.Fields.Item("OV_TRACKING_COM").Value%></small>
			<%
			}
		%>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsOV.Fields.Item("OV_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_CUSTOMER_SO").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsOV.Fields.Item("OV_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_Estado").Value%></a>
            <br/>
            <small> <%=rsOV.Fields.Item("OV_Ciudad").Value%></small>
        </td>

        <td class="project-actions" width="31">
     <input type="checkbox"  id = "ckb1" value="" class="i-checks ChkRel" onclick="javascript:CargaSerie(<%=rsOV.Fields.Item("OV_ID").Value%>)"> </input> 
        </td>
      </tr>
        <%
            rsOV.MoveNext() 
            }
        rsOV.Close()   
        %>       
    </tbody>
  </table>


</div>
<%
 }else{
	 
	 	sSQLTr = "INSERT INTO Manifiesto_Salida(OV_ID)  "
			sSQLTr  += " VALUES("+OV_ID+")"
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Orden de venta añadida al manifiesto"

			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
	 
%>
<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    

});
    
    
function CargaCliente(c,t){

    $("#Cli_ID").val(c);
    $("#OV_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
  
	

</script>    
    
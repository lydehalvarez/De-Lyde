<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var iRegistros = 0

    var Aer_ID = Parametro("Aer_ID",-1) 
    var Transporte = Parametro("Transporte","")
    var Ruta = Parametro("Ruta","")
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
		sSQL += " FROM Manifiesto_Salida m, TransferenciaAlmacen t, cliente c, Almacen a"
        sSQL += " WHERE m.TA_ID=t.TA_ID, t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID AND dbo.fn_CatGral_DameDato(51,TA_EstatusCG51)  = 'Shipping' "   

    if (Aer_ID > -1) {  
        sSQL += " AND a.Aer_ID = "+ Aer_ID
        bHayParams = true
    }   
    
    if (Transporte != "") {
        bHayParams = true
        sSQL += "  AND (TA_Transportista ='"+ Transportista + "' OR TA_Transportista2 ='"+ Transportista + "')"
    }   
/*%>    if (Transporte != "" && Tarea == 2) {
        bHayParams = true
        sSQL += "  AND (OV_TRACKING_COM ='"+ Transportista + "' OR OV_TRACKING_COM2 ='"+ Transportista + "')"
    }   
<%*/    
    if (Ruta != "") {
        bHayParams = true
        sSQL += " AND a.Alm_Ruta = "+ Ruta    
    }

  if (Ciudad != "") {
        bHayParams = true
        sSQL += " AND a.Alm_Ciudad = "+ Ciudad    
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

        <td class="project-actions" width="31">
     <input type="checkbox"  id = "ckb1" value="" class="i-checks ChkRel" onclick="javascript:CargaSerie(<%=rsOV.Fields.Item("OV_ID").Value%>)"> </input> 
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
<%
 }else{
	 
	 	sSQLTr = "INSERT INTO Manifiesto_Salida(TA_ID)  "
			sSQLTr  += " VALUES("+TA_ID+")"
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Transferencia añadida al manifiesto"

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
    
    
    

            

</script>    
    
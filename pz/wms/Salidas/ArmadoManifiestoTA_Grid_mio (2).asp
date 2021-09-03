<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 

    var Usu_ID = Parametro("Usu_ID",-1) 
    var Man_ID = Parametro("Man_ID",-1) 
    var TA_ID = Parametro("TA_ID",-1) 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var Man_FolioCliente = Parametro("Man_FolioCliente","")
	var Man_Vehiculo = Parametro("Man_Vehiculo","")
    var Man_Placas = Parametro("Man_Placas","")
    var Man_Operador = Parametro("Man_Operador","")
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var Man_Ruta = Parametro("Man_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
    var FechaInicio = Parametro("FechaInicio","")
      var FechaFin = Parametro("FechaFin","")
	var Tarea =  Parametro("Tarea",-1)	
    var bHayParams = false  

 if(Tarea == 0){
 
    var sSQL  = " SELECT top(100) * "
/*%>sSQL += " , (SELECT count(*) "
        sSQL += " FROM TransferenciaAlmacen_Documentos d "
        sSQL += " WHERE d.TA_ID = t.TA_ID ) as CANTIDAD "<%*/ 
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID AND dbo.fn_CatGral_DameDato(51,TA_EstatusCG51)  = 'Shipping'"

 
    
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
    if (Man_Ruta > -1) {
        bHayParams = true
        sSQL += " AND a.Alm_Ruta = "+ Man_Ruta    
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
           <%=rsTransferencia.Fields.Item("Cli_Nombre").Value%>
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
     <input type="checkbox"  id = "ckb1" value="" class="i-checks ChkRel" onclick="javascript:CargaTA(<%=rsTransferencia.Fields.Item("TA_ID").Value%>)"> </input> 
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
 }
 	if(Tarea == 1){
		var Man_ID = BuscaSoloUnDato("ISNULL((MAX(Man_ID)),0)","Manifiesto_Salida","",-1,0)
 
	 	sSQLTr = "INSERT INTO Manifiesto_Salida_Contenido(Man_ID, TA_ID,ManS_Usuario)  "
			sSQLTr  += " VALUES("+Man_ID+", "+TA_ID+", "+	Usu_ID+")"
	
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Transferencia añadida al manifiesto"
%>
                               <input type="hidden" id="Manif_ID" value="<%=Man_ID%>" />

<%
			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
				Respuesta = '{"result":'+result+',"message":"'+message+'"}'
 	}
	if(Tarea == 2){
	var Man_ID = BuscaSoloUnDato("ISNULL((MAX(Man_ID)),0)+1","Manifiesto_Salida","",-1,0)

	 	sSQLTr = "INSERT INTO Manifiesto_Salida(Man_ID, Man_FolioCliente, Man_Operador, Man_Vehiculo, "
					+	"Man_Placas, Prov_ID, Man_TipoDeRutaCG94, Aer_ID, Man_Ruta, Edo_ID, Man_Usuario)  "
					+ "VALUES("+Man_ID+", '"+ Man_FolioCliente+"', '"+Man_Operador+"', '"+Man_Vehiculo+"', '"
					+Man_Placas+"', "+Prov_ID+", "+Cat_ID+", "+Aer_ID+", "+ Man_Ruta+", "+		Edo_ID+", "+Usu_ID+")"

		if(Ejecuta(sSQLTr,0)){
				result = Man_ID
				message = "Transferencia añadida al manifiesto"

			}else{
				result = -1
				message = "Error al colocar el dato en la base de datos"
			}
				Respuesta = '{"result":'+result+',"message":"'+message+'"}'
				
				Response.Write(Respuesta)
				%>
<%
 	}
%>
<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    

});
      function CargaTA(taid){
		  
		  
  $.post("/pz/wms/Salidas/ArmadoManifiestoTA_grid.asp",
					{Man_ID: $("#lblManifiesto").text(),
					TA_ID:taid,
					Tarea:1,
					Usu_ID:$("#IDUsuario").val()
					}
					,	 function(data){
						
					
					});
	}	
  
    
            
            

</script>    
    s
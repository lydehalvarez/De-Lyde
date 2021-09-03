<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 

    var Usu_ID = Parametro("Usu_ID",-1) 
    var Man_ID = Parametro("Man_ID",-1) 
    var TA_ID = Parametro("TA_ID",-1) 
	var TA_Folio = Parametro("TA_Folio","") 
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
    var Cajas = 1

 	switch (parseInt(Tarea)) {
			case 1:
    var sSQL  = " SELECT  * "
        sSQL += ", CONVERT(NVARCHAR, TA_FechaRegistro,103) AS frFECHA "
        sSQL += ", CONVERT(NVARCHAR, TA_FechaRegistro,108) AS frHORA "
				  + " ,CONVERT(VARCHAR,DATEADD(HOUR, a.Alm_TiempoEntregaHrs,  m.Man_FechaConfirmado), 103) as FechaEntrega,"
//      sSQL += " , (SELECT count(*) FROM TransferenciaAlmacen_Documentos d WHERE d.TA_ID = t.TA_ID ) as CANTIDAD "
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Manifiesto_Salida m "
        sSQL += " WHERE t.Cli_ID = c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID AND m.Man_ID=t.Man_ID AND TA_EstatusCG51 = 4 "
//  dbo.fn_CatGral_DameDato(51,TA_EstatusCG51)  =  Shipping 

    if (TA_Folio !="") {  
        sSQL += " AND t.TA_Folio = '"+ TA_Folio + "'"
        bHayParams = true
    }   
    if (Aer_ID > 0) {  
        sSQL += " AND a.Aer_ID = "+ Aer_ID
        bHayParams = true
    }   
	 if (Edo_ID > 0) {  
        sSQL += " AND a.Edo_ID = "+ Edo_ID
        bHayParams = true
    }   
    
    if (Transporte != "") {
        bHayParams = true
        sSQL += "  AND (TA_Transportista ='"+ Transporte + "' OR TA_Transportista2 ='"+ Transporte + "')"
    }   
//  if (Transporte != "" && Tarea == 2) {
//        bHayParams = true
//       sSQL += "  AND (OV_TRACKING_COM ='"+ Transportista + "' OR OV_TRACKING_COM2 ='"+ Transportista + "')"
//  }   
    
    if (Man_Ruta > -1) {
        bHayParams = true
        sSQL += " AND a.Alm_Ruta = "+ Man_Ruta    
    }

    if (Ciudad != "") {
        bHayParams = true
        sSQL += " AND a.Alm_Ciudad = '"+ Ciudad + "'"    
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
            <small>Registro: <%=rsTransferencia.Fields.Item("frFECHA").Value%> <%=rsTransferencia.Fields.Item("frHORA").Value%>  </small>
        </td>
        <td class="project-title">
            <a href="#"><%
                Cajas = rsTransferencia.Fields.Item("TA_CantidadCaja").Value
                if(Cajas <2) {
                    Response.Write("1 Caja")  
                    } else {
                      Response.Write(Cajas +" Cajas")    
                    }
            %></a>
            <% if (rsTransferencia.Fields.Item("TA_Peso").Value > 0) {  %>
            <br/>
            <small>Peso: <%=rsTransferencia.Fields.Item("TA_Peso").Value%> Kg</small>
            <% }  %>
        </td>    
        <td class="project-title">
            <a href="#">C.P. <%=rsTransferencia.Fields.Item("Alm_CP").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
            <br />
             <small> Entrega en tienda: <%=rsTransferencia.Fields.Item("FechaEntrega").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
            <br/>
          <%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%>
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
<%
break;
	case 2: 
    var sSQL  = " SELECT  * "
        sSQL += ",    (SELECT count(*) FROM TransferenciaAlmacen d WHERE d.Man_ID = m.Man_ID) "
        sSQL += "  +  (SELECT count(*) FROM Orden_Venta v WHERE v.Man_ID = m.Man_ID) as CANTIDAD "
        sSQL += ", CONVERT(NVARCHAR, Man_FechaRegistro,103) AS frFECHA "
        sSQL += ", CONVERT(NVARCHAR, Man_FechaRegistro,108) AS frHORA "        
		sSQL += " FROM Manifiesto_Salida m "
        sSQL += " INNER JOIN Proveedor p ON m.Prov_ID = p.Prov_ID "
		sSQL += " LEFT OUTER JOIN Cat_Catalogo c ON c.Cat_ID = Man_TipoDeRutaCG94 "
		sSQL += " LEFT OUTER JOIN Cat_Estado e ON e.Edo_ID = m.Edo_ID"
        sSQL += " LEFT OUTER JOIN Cat_Aeropuerto a ON a.Aer_ID = m.Aer_ID "
        sSQL += " WHERE c.Sec_ID =94 "

    if (TA_Folio !="") {  
        sSQL += " AND t.TA_Folio = '"+ TA_Folio + "'"
        bHayParams = true
    }   
    
    if (Aer_ID > 0) {  
        sSQL += " AND Aer_ID = "+ Aer_ID
        bHayParams = true
    }   
    if (Man_ID > 0) {  
        sSQL += " AND Man_ID = "+ Man_ID
    }   
    
    if (Transporte != "") {
        bHayParams = true
        sSQL += "  AND (TA_Transportista ='"+ Transporte + "' OR TA_Transportista2 ='"+ Transporte + "')"
    }   
//    if (Transporte != "" && Tarea == 2) {
//        bHayParams = true
//        sSQL += "  AND (OV_TRACKING_COM ='"+ Transportista + "' OR OV_TRACKING_COM2 ='"+ Transportista + "')"
//    }   
     
    if (Man_Ruta > -1) {
        bHayParams = true
        sSQL += " AND a.Alm_Ruta = "+ Man_Ruta    
    }

  if (Ciudad != "") {
        bHayParams = true
        sSQL += " AND a.Alm_Ciudad = '"+ Ciudad + "'"    
    }

    if ((FechaInicio == "" && FechaFin == "")) {
        if(!bHayParams){
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sSQL += " AND CAST(Man_FechaRegistro as date)  >= dateadd(day,-7,getdate()) "
        }
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Man_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(Man_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Man_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " ORDER BY Man_ID desc"


%>
<div class="ibox-title">
    <h5>Manifiestos</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var rsManifiesto = AbreTabla(sSQL,1,0)
        while (!rsManifiesto.EOF){
		var Man_ID = rsManifiesto.Fields.Item("Man_ID").Value

        %>    
      <tr>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Man_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsManifiesto.Fields.Item("frFECHA").Value%> - <%=rsManifiesto.Fields.Item("frHORA").Value%>  </small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Cat_Nombre").Value%></a>
            <br/>
          Ruta: R <%=rsManifiesto.Fields.Item("Man_Ruta").Value%> 
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Prov_Nombre").Value%></a>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Edo_Nombre").Value%></a>
            <br/>
          Aeropuerto: <%=rsManifiesto.Fields.Item("Aer_Nombre").Value%>
        </td>
   <td class="project-title">
            <a href="#">Transferencias: <%=rsManifiesto.Fields.Item("CANTIDAD").Value%></a>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaManif(<%=Man_ID%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsManifiesto.MoveNext() 
            }
        rsManifiesto.Close()   
        %>       
    </tbody>
  </table>
  
<%
break;

case 4:
    
    var SOS = 0
    var TRAS = 0
    var TOTAL = 0
    var FolCli = "0"
    var ManD_Vehiculo = ""
    var ManD_Operador = ""
    var ManD_Placas =  "0"
    
    var sSQL  = " SELECT  *,(SELECT Nombre FROM dbo.tuf_Usuario_Informacion(t.Man_Usuario)) Usuario "
        sSQL += ", (SELECT count(*) FROM TransferenciaAlmacen d WHERE d.Man_ID = t.Man_ID) as CANTIDAD "
				  + " ,CONVERT(VARCHAR,DATEADD(HOUR, a.Alm_TiempoEntregaHrs,  e.Man_FechaConfirmado), 103) as FechaEntrega"
        sSQL += ", CONVERT(NVARCHAR, t.Man_FechaRegistro,103) AS frFECHA "
        sSQL += ", CONVERT(NVARCHAR, t.Man_FechaRegistro,108) AS frHORA "    
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Manifiesto_Salida e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID"
		sSQL += " AND t.Man_ID=e.Man_ID AND t.Man_ID=" + Man_ID
	    sSQL += " ORDER BY t.Man_FechaRegistro desc"
 
    var rsTransferencia = AbreTabla(sSQL,1,0)
	  
	var sSQL  = " SELECT *,  (SELECT count(*) "
        sSQL +=      " FROM Orden_Venta d "
        sSQL +=     " WHERE d.Man_ID = e.Man_ID) as CANTIDAD "
		sSQL += " FROM Orden_Venta t, cliente c, Manifiesto_Salida e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID "
		sSQL += " AND t.Man_ID=e.Man_ID AND t.Man_ID=" + Man_ID
	    sSQL += " ORDER BY t.Man_FechaRegistro desc"

 
    var rsOV = AbreTabla(sSQL,1,0)
        if (!rsTransferencia.EOF || !rsOV.EOF){
			
			if(!rsTransferencia.EOF){
			     TRAS = rsTransferencia.Fields.Item("CANTIDAD").Value
			}
                
			if(!rsOV.EOF){
			     SOS = rsOV.Fields.Item("CANTIDAD").Value
			}
    TOTAL = TRAS + SOS
	  
%>
<DIV>        <button type="button" class="btn btn-success btnImprimir" onclick="ManifiestoFunciones.Contenido_Reporte(<%=Man_ID%>)">Imprimir</button>
</DIV>
<input type="hidden" name="Man_ID" id="Man_ID" value="<%=Man_ID%>">  
<input type="hidden" name="Total" id="Total" value="<%=TOTAL%>">  
<div class="row">
    <div class="col-sm-12 m-b-xs">
        <input class="form-control Folio pull-right" style="width:30%" 
        placeholder="Escanea el folio" type="text" autocomplete="off" value="" />
    </div>
</div>
<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
        <%  if (!rsTransferencia.EOF){ %>
 		       <h1>Transferencias de manifiesto:  <span id="TotalAcumulado"><%=TOTAL%></span> <br/> <%=rsTransferencia.Fields.Item("Man_Folio").Value%> </h1>
        <%  }
            if( !rsOV.EOF){   %>
			   <h1>Ordenes de venta de manifiesto:  <%=TOTAL%> <br/> <%=rsOV.Fields.Item("Man_Folio").Value%> </h1>
        <%  } %>
        </div>
        <div class="col-md-4 text-right">
            <div class="btn-group" role="group" aria-label="Basic example">
				 <button type="button" class="btn btn-warning" onclick="ManifiestoFunciones.EditaManifiesto(<%=Man_ID%>);  return false">Editar manifiesto</button>
                 <button type="button" class="btn btn-success btnConfirma">Finalizar manifiesto</button>    
            </div>
        </div>
	</div>
</div>    

<div class="project-list">
  <table class="table table-hover">
    <tbody id="addManifiesto">
<%
    if(!rsTransferencia.EOF){
        while (!rsTransferencia.EOF){
			var TA_ID = rsTransferencia.Fields.Item("TA_ID").Value
%>    
      <tr id="Entrante_<%=TA_ID%>">
         <td class="project-title">
           <a href="#"> <%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <a data-clipboard-target="#copytext<%=TA_ID%>" id="copytext<%=TA_ID%>" class="textCopy"><%=rsTransferencia.Fields.Item("TA_Folio").Value%></a>
            <br/>
            <small><strong>Registro:</strong> <%=rsTransferencia.Fields.Item("frFECHA").Value%>&nbsp;-&nbsp;<%=rsTransferencia.Fields.Item("frHORA").Value%>  </small>
            <br/>
            <small><strong>Escaneado por:</strong> <%=rsTransferencia.Fields.Item("Usuario").Value%> </small>
        </td>
        <td class="project-title">
            <a href="#">No. Tienda: <%=rsTransferencia.Fields.Item("Alm_Numero").Value%></a>
            <br/>
            <small>Nombre: <%=rsTransferencia.Fields.Item("Alm_Nombre").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%
                Cajas = rsTransferencia.Fields.Item("TA_CantidadCaja").Value
                if(Cajas <2) {
                    Response.Write("1 Caja")  
                    } else {
                      Response.Write(Cajas +" Cajas")    
                    }
            %></a>
            <% if (rsTransferencia.Fields.Item("TA_Peso").Value > 0) {  %>
            <br/>
            <small>Peso: <%=rsTransferencia.Fields.Item("TA_Peso").Value%> Kg</small>
            <% }  %>
        </td>    
        <td class="project-title">
            <a href="#">C.P. <%=rsTransferencia.Fields.Item("Alm_CP").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
                        <br />
             <small> Entrega en tienda: <%=rsTransferencia.Fields.Item("FechaEntrega").Value%></small>

        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
            <br/>
          <%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%>
        </td>
    <td class="project-actions" width="31">
         	 <a class="btn btn-danger btn-sm" href="#" onclick="ManifiestoFunciones.EliminaPedido(<%=rsTransferencia.Fields.Item("TA_ID").Value%>);  return false">
             <i class="fa fa-trash"></i> Eliminar</a>
        </td>
      </tr>
    <%
        rsTransferencia.MoveNext() 
        }
    rsTransferencia.Close()     
    }
    if(!rsOV.EOF){
       while (!rsOV.EOF){

    %>    
      <tr>
         <td class="project-title">
           <a href="#"> <%=rsOV.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Transportista: <%=rsOV.Fields.Item("OV_TRACKING_COM").Value%> Guia: <%=rsOV.Fields.Item("OV_TRACKING_NUMBER").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsOV.Fields.Item("OV_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#">C.P. <%=rsOV.Fields.Item("OV_CP").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsOV.Fields.Item("OV_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_Estado").Value%></a>
            <br/>
          <%=rsOV.Fields.Item("OV_Ciudad").Value%>
        </td>
    <td class="project-actions" width="31">
         	 <a class="btn btn-danger btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_EliminarSO(<%=rsOV.Fields.Item("OV_ID").Value%>);  return false">
             <i class="fa fa-trash"></i> Eliminar</a>
        </td>
      </tr>
        <%
            rsOV.MoveNext() 
            }
        rsOV.Close()   
	  }
        %>       
    </tbody>
  </table>

         
    
<%
} else {
	var Man_Folio =  BuscaSoloUnDato("Man_Folio","Manifiesto_Salida","Man_ID = "+Man_ID,-1,0) 
%>
<input type="hidden" name="Total" id="Total" value="0"> 

<div class="row">
    <div class="col-sm-12 m-b-xs">
        <input class="form-control Folio pull-right" style="width:30%" 
        placeholder="Escanea el folio" type="text" autocomplete="off" value="" />
    </div>
</div>
<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>Transferencias de manifiesto: <%=Man_Folio%>: <span id="TotalAcumulado">0</span></h1>
        </div>
        <div  class="col-md-4" id="botonesHidden" style="display:none;">
             <button type="button" class="btn btn-warning btnEdita" onclick="ManifiestoFunciones.EditaManifiesto(<%=Man_ID%>);  return false">Editar manifiesto </button>
             <button type="button" class="btn btn-success btnConfirma">Finalizar manifiesto</button>    
        </div>
     </div>
</div>
<table class="table">
    <tbody id="addManifiesto">
        <tr>
            <td colspan="6" align = "center"><h3>Ingresa tu primer folio</h3></td>
        </tr>
    </tbody>
</table>
<%	
}
break;

case 9:

    var sSQL  = " SELECT  * "
        sSQL += ", (SELECT count(*) FROM TransferenciaAlmacen d WHERE d.Man_ID = t.Man_ID AND Man_CargaTransportista = 1) as ESCANEADOS "
        sSQL += ", (SELECT count(*) FROM TransferenciaAlmacen d  WHERE d.Man_ID = t.Man_ID) as CANTIDAD "
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Manifiesto_Salida e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID "
		sSQL += " AND t.TA_End_Warehouse_ID = a.Alm_ID"
		//sSQL += " AND Man_CargaTransportista = 1 "
		sSQL += " AND t.Man_ID = e.Man_ID "
		sSQL += " AND t.Man_ID= " + Man_ID
		sSQL += " ORDER BY t.Man_FechaRegistro desc"
 
 
 	//Response.Write(sSQL)
 
      var rsTransferencia = AbreTabla(sSQL,1,0)
        if (!rsTransferencia.EOF){
			
		
%>
<div>     
    <button type="button" class="btn btn-success btnImprimir" onclick="ManifiestoFunciones.Contenido_Reporte(<%=Man_ID%>)">Imprimir</button>
</div>
<div>     
	<input type="text" class="form-control ValidaPedido" placeholder="Ingresa el pedido"/>

</div>
<input type="hidden" name="Man_ID" id="Man_ID" value="<%=Man_ID%>">     

<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>Transferencias de manifiesto: <span id="Validados"><%=rsTransferencia.Fields.Item("ESCANEADOS").Value%></span>/<%=rsTransferencia.Fields.Item("CANTIDAD").Value%> <br/> <%=rsTransferencia.Fields.Item("Man_Folio").Value%> </h1>
        </div>
        <div class="col-md-4 text-right">
            <div class="btn-group" role="group" aria-label="Basic example">

			   <%
			   	   if(rsTransferencia.Fields.Item("Man_FolioCliente").Value != ""){
				      FolCli = rsTransferencia.Fields.Item("Man_FolioCliente").Value
				   }
				   if(rsTransferencia.Fields.Item("Man_Vehiculo").Value != ""){
				      Man_Vehiculo = rsTransferencia.Fields.Item("Man_Vehiculo").Value
				   }
				   if(rsTransferencia.Fields.Item("Man_Operador").Value != ""){
				      Man_Operador = rsTransferencia.Fields.Item("Man_Operador").Value
				   }
				   if(rsTransferencia.Fields.Item("Man_Placas").Value != ""){
				      Man_Placas = rsTransferencia.Fields.Item("Man_Placas").Value
				   }
				   %>
			
            </div>
        </div>
	</div>
</div>    
  <table class="table table-hover">
    <tbody>
        <%
		var Folio = ""
		var TA_ID = -1
        while (!rsTransferencia.EOF){
			TA_ID = rsTransferencia.Fields.Item("TA_ID").Value
			Folio = rsTransferencia.Fields.Item("TA_Folio").Value
        %>    
      <tr id="Renglon_<%=TA_ID%>">
         <td class="project-title">
           <p><%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></p>
            <br/>
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <p><%=Folio%></p>
            <br/>
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <p>C.P. <%=rsTransferencia.Fields.Item("Alm_CP").Value%></p>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <p><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></p>
            <br/>
          <%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%>
        </td>
    <td class="project-actions" width="31">
         	 <a class="btn btn-danger btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Eliminar(<%=rsTransferencia.Fields.Item("TA_ID").Value%>);  return false">
             <i class="fa fa-trash"></i> Eliminar</a>
        </td>
      </tr>
        <%
            rsTransferencia.MoveNext() 
            }
        rsTransferencia.Close()   
        %>       
    </tbody>
  </table>
<%
		}
break;

	}
%>
<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    

});
	$('.Folio').on('keypress',function(e) {
		if(e.which == 13) {
			var DatoIngreso = $(this).val();
			DatoIngreso = DatoIngreso.replace("'","-")
			 var dato = {
					 Folio:DatoIngreso,
					 Man_ID:$('#Man_ID').val(),
					 IDUsuario:$("#IDUsuario").val()
			 }
			console.log(dato)
			ManifiestoFunciones.EscaneaFolioApi(dato,$(this))
		}
	});
	$('.ValidaPedido').on('keypress',function(e) {
		if(e.which == 13) {
			var DatoIngreso = $(this).val();
			DatoIngreso = DatoIngreso.replace("'","-")
			 var dato = {
					 Folio:DatoIngreso,
					 Man_ID:$('#Man_ID').val(),
					 IDUsuario:$("#IDUsuario").val()
			 }
			ManifiestoFunciones.ValidaFolioAPI(dato,$(this))
		}
	});
   
	$('.btnConfirma').click(function(e){
		swal({
		  title: "Terminar manifiesto",
		  text: "Al terminar el manifiesto ya no se podr&aacute; hacer modificaciones",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		},
		function(data){
			if(data){
				ManifiestoFunciones.Confirma();
			}
		});		
	});
</script>    


    
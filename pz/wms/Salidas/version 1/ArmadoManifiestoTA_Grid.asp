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

 	switch (parseInt(Tarea)) {
			case 1:
    var sSQL  = " SELECT  * "
/*%>sSQL += " , (SELECT count(*) "
        sSQL += " FROM TransferenciaAlmacen_Documentos d "
        sSQL += " WHERE d.TA_ID = t.TA_ID ) as CANTIDAD "<%*/ 
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID AND dbo.fn_CatGral_DameDato(51,TA_EstatusCG51)  = 'Shipping'"

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
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#">C.P. <%=rsTransferencia.Fields.Item("Alm_CP").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
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
    var sSQL  = " SELECT  *,  (SELECT count(*) "
        sSQL +=      " FROM TransferenciaAlmacen d "
        sSQL +=     " WHERE d.Man_ID = m.Man_ID) +  (SELECT count(*) "
        sSQL +=      " FROM Orden_Venta v "
        sSQL +=     " WHERE v.Man_ID = m.Man_ID) as CANTIDAD "
		sSQL += " FROM Manifiesto_Salida m INNER JOIN Proveedor p ON m.Prov_ID=p.Prov_ID"
					+ " LEFT OUTER JOIN Cat_Catalogo c ON c.Cat_ID=Man_TipoDeRutaCG94"
					+ " LEFT OUTER JOIN Cat_Estado e ON e.Edo_ID=m.Edo_ID"
        			+ " LEFT OUTER JOIN Cat_Aeropuerto a ON a.Aer_ID=m.Aer_ID  WHERE c.Sec_ID =94"

    if (TA_Folio !="") {  
        sSQL += " AND t.TA_Folio = '"+ TA_Folio + "'"
        bHayParams = true
    }   
    
    if (Aer_ID > 0) {  
        sSQL += " AND Aer_ID = "+ Aer_ID
        bHayParams = true
    }   
    
    if (Transporte != "") {
        bHayParams = true
        sSQL += "  AND (TA_Transportista ='"+ Transporte + "' OR TA_Transportista2 ='"+ Transporte + "')"
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
            <small>Fecha Registro: <%=rsManifiesto.Fields.Item("Man_FechaRegistro").Value%></small>
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

    var sSQL  = " SELECT  *,  (SELECT count(*) "
        sSQL +=      " FROM TransferenciaAlmacen d "
        sSQL +=     " WHERE d.Man_ID = t.Man_ID) as CANTIDAD "
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Manifiesto_Salida e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID"
		sSQL += " AND t.Man_ID=e.Man_ID AND t.Man_ID=" + Man_ID
	sSQL += " ORDER BY t.Man_FechaRegistro desc"
 
      var rsTransferencia = AbreTabla(sSQL,1,0)
	  
	       var sSQL  = " SELECT top(100) *,  (SELECT count(*) "
        sSQL +=      " FROM Orden_Venta d "
        sSQL +=     " WHERE d.Man_ID = e.Man_ID) as CANTIDAD "
		sSQL += " FROM Orden_Venta t, cliente c, Manifiesto_Salida e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID "
		sSQL += " AND t.Man_ID=e.Man_ID AND t.Man_ID=" + Man_ID
	sSQL += " ORDER BY t.Man_FechaRegistro desc"
 
      var rsOV = AbreTabla(sSQL,1,0)
        if (!rsTransferencia.EOF || !rsOV.EOF){
			
			if(!rsTransferencia.EOF){
			var TRAS = rsTransferencia.Fields.Item("CANTIDAD").Value
			var SOS = 0
			}
			if(!rsOV.EOF){
			var SOS = rsOV.Fields.Item("CANTIDAD").Value
			var TRAS = 0
			}
			var TOTAL = TRAS + SOS
	  
%>
<DIV>        <button type="button" class="btn btn-success btnImprimir" onclick="ManifiestoFunciones.Contenido_Reporte(<%=Man_ID%>)">Imprimir</button>
</DIV>
<input type="hidden" name="Man_ID" id="Man_ID" value="<%=Man_ID%>">     

<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>Transferencias de manifiesto:  <%=TOTAL%> <br/> <%=rsTransferencia.Fields.Item("Man_Folio").Value%> </h1>
        </div>
        <div class="col-md-4 text-right">
            <div class="btn-group" role="group" aria-label="Basic example">
            
			   
			   <%
			   	   if(rsTransferencia.Fields.Item("Man_FolioCliente").Value == ""){
				   var FolCli =   "0"
				   }else{ 
				   var FolCli = rsTransferencia.Fields.Item("Man_FolioCliente").Value
				   }
				      if(rsTransferencia.Fields.Item("Man_Vehiculo").Value == ""){
				     var Man_Vehiculo = "0"
				   }else{ 
				   var Man_Vehiculo = rsTransferencia.Fields.Item("Man_Vehiculo").Value
				   }
				      if(rsTransferencia.Fields.Item("Man_Operador").Value == ""){
				     var Man_Operador = "0"
				   }else{ 
				   var Man_Operador = rsTransferencia.Fields.Item("Man_Operador").Value
				   }
				      if(rsTransferencia.Fields.Item("Man_Placas").Value == ""){
				    var Man_Placas =  "0"
				   }else{ 
				   var Man_Placas = rsTransferencia.Fields.Item("Man_Placas").Value
				   }
				   %>
				 <button type="button" class="btn btn-warning btnEdita" onclick="ManifiestoFunciones.EditaManifiesto('<%=FolCli%>','<%=Man_Vehiculo%>','<%=Man_Operador%>','<%=Man_Placas%>', <%=rsTransferencia.Fields.Item("Prov_ID").Value%>,<%=rsTransferencia.Fields.Item("Man_TipoDeRutaCG94").Value%>,<%=rsTransferencia.Fields.Item("Aer_ID").Value%>,<%=rsTransferencia.Fields.Item("Man_Ruta").Value%>,<%=rsTransferencia.Fields.Item("Edo_ID").Value%>);  return false">Editar manifiesto</button>

              <button type="button" class="btn btn-success btnConfirma">Finalizar manifiesto</button>
              <%
			   if(!rsOV.EOF){
			   
			   	   if(rsOV.Fields.Item("Man_FolioCliente").Value == ""){
				   var FolCli =   "0"
				   }else{ 
				   var FolCli = rsOV.Fields.Item("Man_FolioCliente").Value
				   }
				      if(rsOV.Fields.Item("Man_Vehiculo").Value == ""){
				     var ManD_Vehiculo = "0"
				   }else{ 
				   var ManD_Vehiculo = rsOV.Fields.Item("Man_Vehiculo").Value
				   }
				      if(rsOV.Fields.Item("Man_Operador").Value == ""){
				     var ManD_Operador = "0"
				   }else{ 
				   var ManD_Operador = rsOV.Fields.Item("Man_Operador").Value
				   }
				      if(rsOV.Fields.Item("Man_Placas").Value == ""){
				    var ManD_Placas =  "0"
				   }else{ 
				   var ManD_Placas = rsOV.Fields.Item("Man_Placas").Value
				   }
				  
				   %>
				 <button type="button" class="btn btn-warning btnEdita" onclick="ManifiestoFunciones.EditaManifiesto('<%=FolCli%>','<%=ManD_Vehiculo%>','<%=ManD_Operador%>','<%=ManD_Placas%>', <%=rsOV.Fields.Item("Prov_ID").Value%>,<%=rsOV.Fields.Item("Man_TipoDeRutaCG94").Value%>,<%=rsOV.Fields.Item("Aer_ID").Value%>,<%=rsOV.Fields.Item("Man_Ruta").Value%>,<%=rsOV.Fields.Item("Edo_ID").Value%>);  return false">Editar manifiesto</button>
<%
}
%>
            </div>
        </div>
	</div>
</div>    

<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
		 if(!rsTransferencia.EOF){
        while (!rsTransferencia.EOF){

        %>    
      <tr>
         <td class="project-title">
           <a href="#"> <%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#">C.P. <%=rsTransferencia.Fields.Item("Alm_CP").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
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
}else{
	var Man_Folio =  BuscaSoloUnDato("Man_Folio","Manifiesto_Salida","Man_ID = "+Man_ID,-1,0) 
%>
<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>Transferencias de manifiesto: <%=Man_Folio%> </h1>
        </div>
     </div>
</div>
<table class="table">
<tr>
<td align = "center">
<h3>Ingresa tu primer folio
</h3></td>
</tr>
</table>
<%	
}
break;


case 5:

   					    var campo = "Aer_Nombre"
                        var condicion = "Edo_ID = "+ Edo_ID
                        CargaCombo("Aer_ID","class='form-control combman'","Aer_ID",campo,"Cat_Aeropuerto",condicion,"","Editar",0,"Selecciona")
						
break;
case 6:

   						CargaCombo("Prov_ID","class='form-control combman'","Prov_ID","Prov_Nombre","Proveedor","Prov_TipoDeRutaCG94 = "+Cat_ID+"","","Editar",0,"Selecciona")
						
break;
case 7:
   					    var campo = "Ciu_Nombre"
                        var condicion = "Edo_ID = "+ Edo_ID
                        CargaCombo("Ciu_ID","class='form-control combman'","Ciu_Nombre",campo,"Cat_Ciudad",condicion,"","Editar",0,"Selecciona")
						
break;
case 8:

   			CargaCombo("CboProv_ID","class='form-control combman'","Prov_Nombre","Prov_Nombre","Proveedor","Prov_TipoDeRutaCG94 = "+Cat_ID+"","","Editar",0,"Selecciona")
						
break;
case 9:

    var sSQL  = " SELECT  *,  (SELECT count(*) "
        sSQL +=      " FROM TransferenciaAlmacen d "
        sSQL +=     " WHERE d.Man_ID = t.Man_ID AND Man_CargaTransportista = 1) as ESCANEADOS , (SELECT count(*) "
        sSQL +=      " FROM TransferenciaAlmacen d "
        sSQL +=     " WHERE d.Man_ID = t.Man_ID) as CANTIDAD "
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Manifiesto_Salida e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID"
		sSQL += " AND Man_CargaTransportista = 1 AND t.Man_ID=e.Man_ID AND t.Man_ID=" + Man_ID
	sSQL += " ORDER BY t.Man_FechaRegistro desc"
 
      var rsTransferencia = AbreTabla(sSQL,1,0)
        if (!rsTransferencia.EOF){
			
		
%>
<DIV>        <button type="button" class="btn btn-success btnImprimir" onclick="ManifiestoFunciones.Contenido_Reporte(<%=Man_ID%>)">Imprimir</button>
</DIV>
<input type="hidden" name="Man_ID" id="Man_ID" value="<%=Man_ID%>">     

<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>Transferencias de manifiesto: <%=rsTransferencia.Fields.Item("ESCANEADOS").Value%>/<%=rsTransferencia.Fields.Item("CANTIDAD").Value%> <br/> <%=rsTransferencia.Fields.Item("Man_Folio").Value%> </h1>
        </div>
        <div class="col-md-4 text-right">
            <div class="btn-group" role="group" aria-label="Basic example">
            
			   
			   <%
			   	   if(rsTransferencia.Fields.Item("Man_FolioCliente").Value == ""){
				   var FolCli =   "0"
				   }else{ 
				   var FolCli = rsTransferencia.Fields.Item("Man_FolioCliente").Value
				   }
				      if(rsTransferencia.Fields.Item("Man_Vehiculo").Value == ""){
				     var Man_Vehiculo = "0"
				   }else{ 
				   var Man_Vehiculo = rsTransferencia.Fields.Item("Man_Vehiculo").Value
				   }
				      if(rsTransferencia.Fields.Item("Man_Operador").Value == ""){
				     var Man_Operador = "0"
				   }else{ 
				   var Man_Operador = rsTransferencia.Fields.Item("Man_Operador").Value
				   }
				      if(rsTransferencia.Fields.Item("Man_Placas").Value == ""){
				    var Man_Placas =  "0"
				   }else{ 
				   var Man_Placas = rsTransferencia.Fields.Item("Man_Placas").Value
				   }
				   %>
			
            </div>
        </div>
	</div>
</div>    

<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%

        while (!rsTransferencia.EOF){

        %>    
      <tr>
         <td class="project-title">
           <a href="#"> <%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#">C.P. <%=rsTransferencia.Fields.Item("Alm_CP").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
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
}else{
	var Man_Folio =  BuscaSoloUnDato("Man_Folio","Manifiesto_Salida","Man_ID = "+Man_ID,-1,0) 
%>
<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>Transferencias de manifiesto: <%=Man_Folio%> </h1>
        </div>
     </div>
</div>
<table class="table">
<tr>
<td align = "center">
<h3>Ingresa tu primer folio
</h3></td>
</tr>
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


    
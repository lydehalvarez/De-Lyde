<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 

    var Usu_ID = Parametro("Usu_ID",-1) 
    var ManD_ID = Parametro("ManD_ID",-1) 
    var TA_ID = Parametro("TA_ID",-1) 
	var TA_Folio = Parametro("TA_Folio","") 
	var OV_Folio = Parametro("OV_Folio","") 
    var Aer_ID = Parametro("Aer_ID",-1) 
    var Edo_ID = Parametro("Edo_ID",-1) 
	var Cat_ID = Parametro("Cat_ID",-1) 
    var ManD_FolioCliente = Parametro("ManD_FolioCliente","")
	var ManD_Vehiculo = Parametro("ManD_Vehiculo","")
    var ManD_Placas = Parametro("ManD_Placas","")
    var ManD_Operador = Parametro("ManD_Operador","")
    var Transporte = Parametro("Transporte","")
    var Prov_ID = Parametro("Prov_ID",-1) 
    var ManD_Ruta = Parametro("ManD_Ruta",-1)
    var Ciudad = Parametro("Ciudad","")
    var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")
	var Tarea =  Parametro("Tarea",-1)	
    var bHayParams = false  

 	switch (parseInt(Tarea)) {
			case 1:
    var sSQL  = " SELECT top(100) * "
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
    if (ManD_Ruta > -1) {
        bHayParams = true
        sSQL += " AND a.Alm_Ruta = "+ ManD_Ruta    
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
    var sSQL  = " SELECT TOP (100) *,  (SELECT count(*) "
        sSQL +=      " FROM TransferenciaAlmacen d "
        sSQL +=     " WHERE d.ManD_ID = m.ManD_ID) + (SELECT count(*) "
        sSQL +=      " FROM Orden_Venta v "
        sSQL +=     " WHERE v.ManD_ID = m.ManD_ID) as CANTIDAD "
		sSQL += " FROM Manifiesto_Devolucion m INNER JOIN Proveedor p ON m.Prov_ID=p.Prov_ID"
					+ " LEFT OUTER JOIN Cat_Catalogo c ON c.Cat_ID=ManD_TipoDeRutaCG94"
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
    if (ManD_Ruta > -1) {
        bHayParams = true
        sSQL += " AND a.Alm_Ruta = "+ ManD_Ruta    
    }

  if (Ciudad != "") {
        bHayParams = true
        sSQL += " AND a.Alm_Ciudad = '"+ Ciudad + "'"    
    }

    if ((FechaInicio == "" && FechaFin == "")) {
        if(!bHayParams){
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sSQL += " AND CAST(ManD_FechaRegistro as date)  >= dateadd(day,-7,getdate()) "
        }
    } else {   
        if(FechaInicio == "" ) {
            if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(ManD_FechaRegistro as date)  <= '" + FechaFin + "'"
            }
        } else {
            FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            if(FechaFin == "" ) {
                sSQL += " AND CAST(ManD_FechaRegistro as date)  >= '" + FechaFin + "'"
            } else {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(ManD_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' "  
            }
        }
    }
        
	sSQL += " ORDER BY ManD_ID desc"



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
		var ManD_ID = rsManifiesto.Fields.Item("ManD_ID").Value

        %>    
      <tr>
         <td class="project-title">
              <a href="#"><%=rsManifiesto.Fields.Item("ManD_Folio").Value%></a>
            <br/>
            <small>Fecha Registro: <%=rsManifiesto.Fields.Item("ManD_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Cat_Nombre").Value%></a>
            <br/>
          Ruta: R <%=rsManifiesto.Fields.Item("ManD_Ruta").Value%> 
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
            <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Borrador(<%=ManD_ID%>);  return false">
            <i class="fa fa-plus"></i> Modificar</a>
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

    var sSQL  = " SELECT top(100) *,  (SELECT count(*)  FROM TransferenciaAlmacen d  WHERE d.ManD_ID = e.ManD_ID) as Total_TRA "
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a, Manifiesto_Devolucion e"
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID"
		sSQL += " AND t.ManD_ID=e.ManD_ID AND t.ManD_ID=" + ManD_ID
		sSQL += " ORDER BY t.ManD_FechaRegistro desc"
 
      var rsTransferencia = AbreTabla(sSQL,1,0)
	  
	var sSQL  = " SELECT top(100) *,  (SELECT count(*) FROM Orden_Venta d WHERE d.ManD_ID = e.ManD_ID) as Total_SO "
		sSQL += " FROM Orden_Venta t, cliente c, Manifiesto_Devolucion e"
		sSQL += " WHERE t.Cli_ID=c.Cli_ID "
		sSQL += " AND t.ManD_ID=e.ManD_ID AND t.ManD_ID=" + ManD_ID
		sSQL += " ORDER BY t.ManD_FechaRegistro desc"
 
      var ManD_Folio =  BuscaSoloUnDato("ManD_Folio","Manifiesto_Devolucion","ManD_ID = "+ManD_ID,-1,0) 

      var rsOV = AbreTabla(sSQL,1,0)
	  var Total_TRA = 0
	  var Total_SO = 0
        if (!rsTransferencia.EOF){
			Total_TRA = rsTransferencia.Fields.Item("Total_TRA").Value
		}
        if (!rsOV.EOF){
			Total_SO = rsOV.Fields.Item("Total_SO").Value
		}
	  
        if (!rsTransferencia.EOF || !rsOV.EOF){
		
%>
<div class="row"> 
    <div class="col-sm-12 m-b-xs">
        <input class="form-control Folio pull-right" style="width:30%"   placeholder="Escanea el folio de la transferencia" type="text" autocomplete="off" value="" />
        <button type="button" class="btn btn-success btnImprimir pull-right" onclick="ManifiestoDFunciones.Contenido_Reporte(<%=ManD_ID%>)">Imprimir</button>
    </div>
</div>
<input type="hidden" name="ManD_ID" id="ManD_ID" value="<%=ManD_ID%>">     

<div class="ibox-title">
    <div class= "row">
        <div  class="col-md-8">
 		   <h1>TRA <small>(Cantidad Transferencia)</small>:  <span id="total_tra"><%=Total_TRA%></span></h1><br />
 		   <h1>SO <small>(Cantidad Orden venta)</small>: <span id="total_so"><%=Total_SO%></span></h1><br />
           <h1>Manifiesto: <%=ManD_Folio%></h1>
        </div>
        <div class="col-md-4 text-right">
            <div class="btn-group" role="group" aria-label="Basic example">
            
			      <%  if(!rsTransferencia.EOF){
			   
			   	   if(rsTransferencia.Fields.Item("ManD_FolioCliente").Value == ""){
				   var FolCli =   "0"
				   }else{ 
				   var FolCli = rsTransferencia.Fields.Item("ManD_FolioCliente").Value
				   }
				      if(rsTransferencia.Fields.Item("ManD_Vehiculo").Value == ""){
				     var ManD_Vehiculo = "0"
				   }else{ 
				   var ManD_Vehiculo = rsTransferencia.Fields.Item("ManD_Vehiculo").Value
				   }
				      if(rsTransferencia.Fields.Item("ManD_Operador").Value == ""){
				     var ManD_Operador = "0"
				   }else{ 
				   var ManD_Operador = rsTransferencia.Fields.Item("ManD_Operador").Value
				   }
				      if(rsTransferencia.Fields.Item("ManD_Placas").Value == ""){
				    var ManD_Placas =  "0"
				   }else{ 
				   var ManD_Placas = rsTransferencia.Fields.Item("ManD_Placas").Value
				   }
				  
				   %>
				 <button type="button" class="btn btn-warning btnEdita" onclick="ManifiestoFunciones.EditaManifiesto('<%=FolCli%>','<%=ManD_Vehiculo%>','<%=ManD_Operador%>','<%=ManD_Placas%>', <%=rsTransferencia.Fields.Item("Prov_ID").Value%>,<%=rsTransferencia.Fields.Item("ManD_TipoDeRutaCG94").Value%>,<%=rsTransferencia.Fields.Item("Aer_ID").Value%>,<%=rsTransferencia.Fields.Item("ManD_Ruta").Value%>,<%=rsTransferencia.Fields.Item("Edo_ID").Value%>);  return false">Editar manifiesto</button>
<%
}
 if(!rsOV.EOF){
			   
			   	   if(rsOV.Fields.Item("ManD_FolioCliente").Value == ""){
				   var FolCli =   "0"
				   }else{ 
				   var FolCli = rsOV.Fields.Item("ManD_FolioCliente").Value
				   }
				      if(rsOV.Fields.Item("ManD_Vehiculo").Value == ""){
				     var ManD_Vehiculo = "0"
				   }else{ 
				   var ManD_Vehiculo = rsOV.Fields.Item("ManD_Vehiculo").Value
				   }
				      if(rsOV.Fields.Item("ManD_Operador").Value == ""){
				     var ManD_Operador = "0"
				   }else{ 
				   var ManD_Operador = rsOV.Fields.Item("ManD_Operador").Value
				   }
				      if(rsOV.Fields.Item("ManD_Placas").Value == ""){
				    var ManD_Placas =  "0"
				   }else{ 
				   var ManD_Placas = rsOV.Fields.Item("ManD_Placas").Value
				   }
				  
				   %>
				 <button type="button" class="btn btn-warning btnEdita" onclick="ManifiestoFunciones.EditaManifiesto('<%=FolCli%>','<%=ManD_Vehiculo%>','<%=ManD_Operador%>','<%=ManD_Placas%>', <%=rsOV.Fields.Item("Prov_ID").Value%>,<%=rsOV.Fields.Item("ManD_TipoDeRutaCG94").Value%>,<%=rsOV.Fields.Item("Aer_ID").Value%>,<%=rsOV.Fields.Item("ManD_Ruta").Value%>,<%=rsOV.Fields.Item("Edo_ID").Value%>);  return false">Editar manifiesto</button>
<%
}
%>
<!--              <button type="button" class="btn btn-success btnConfirma">Finalizar manifiesto</button>
-->            </div>
        </div>
	</div>
</div>    

<div class="project-list">
  <table class="table table-hover">
    <tbody id="NuevoPedido">
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
         	 <a class="btn btn-danger btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Eliminar(<%=rsOV.Fields.Item("OV_ID").Value%>);  return false">
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
  
    <input type="hidden" id="Total_TRA" value="<%=Total_TRA%>"/>
    <input type="hidden" id="Total_SO" value="<%=Total_SO%>"/>
    
	<%
    }else{
        var ManD_Folio =  BuscaSoloUnDato("ManD_Folio","Manifiesto_Devolucion","ManD_ID = "+ManD_ID,-1,0) 
    %>
    <div class="row"> 
        <div class="col-sm-12 m-b-xs">
            <input class="form-control Folio pull-right" style="width:30%"   placeholder="Escanea el folio de la transferencia" type="text" autocomplete="off" value="" />
            <button type="button" class="btn btn-success btnImprimir pull-right" onclick="ManifiestoFunciones.Contenido_Reporte(<%=ManD_ID%>)">Imprimir</button>
        </div>
    </div>
    <div class="ibox-title">
        <div class= "row">
            <div  class="col-md-8">
               <h1>TRA <small>(Cantidad Transferencia)</small>:  <span id="total_tra">0</span></h1><br />
               <h1>SO <small>(Cantidad Orden venta)</small>: <span id="total_so">0</span></h1><br />
               <h1>Manifiesto: <%=ManD_Folio%></h1>
            </div>
         </div>
    </div>
    <table class="table">
    	<tbody id="NuevoPedido">
            <tr>
                <td align = "center"><h3>Ingresa tu primer folio</h3></td>
            </tr>
        </tbody>
    </table>
    <input type="hidden" id="Total_TRA" value="0"/>
    <input type="hidden" id="Total_SO" value="0"/>
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
			var DatoIngreso = $(this).val().trim().toUpperCase();
			
			DatoIngreso = DatoIngreso.replace("'","-");
			var EsOV = -1
			if(DatoIngreso.slice(0,3) == "TRA"){
				EsOV = 0
			}
			if(DatoIngreso.slice(0,2) == "SO"){
				EsOV = 1
			}
			 var dato = {
					 Folio:DatoIngreso,
					 EsOV:EsOV,
					 ManD_ID:$('#ManD_ID').val(),
					 IDUsuario:$("#IDUsuario").val(),
					 Test:true
			}
			//console.log(dato)
			ManifiestoFunciones.EscaneaFolio(dato,$(this))
		}
	});
   
	$('.btnConfirma').click(function(e){
		e.preventDefault();
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


    
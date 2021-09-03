<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir
    //HA ID: 3  2020-SEP-07 Agregado de Boton de Liberacion de Recepcion

   	var Serie = Parametro("Serie","")
	var Tipo = Parametro("Tipo",-1)
	var Respuesta = ""
	var result = 0
	var message = ""
 switch (parseInt(Tipo)) {

case 4:
   Serie=Serie.replace(" ","+")
	var sSQL  = "SELECT * FROM  Pallet AS pt INNER JOIN"
                     +" Inventario_Lote AS l INNER JOIN"
                     +" Inventario AS i INNER JOIN"
                     +"  Producto AS p ON i.Pro_ID = p.Pro_ID INNER JOIN"
                     +"  Cliente AS c ON c.Cli_ID = i.Cli_ID ON l.Lot_ID = i.Inv_LoteIngreso INNER JOIN"
                     +"    Cat_Catalogo AS ct ON ct.Cat_ID = i.Inv_EstatusCG20 INNER JOIN"
                     +"   Almacen AS a ON a.Alm_ID = i.Alm_ID INNER JOIN"
                     +"  Ubicacion AS u ON i.Ubi_ID = u.Ubi_ID ON pt.Pt_ID = i.Pt_ID"
  					 +" WHERE  (i.Inv_Serie LIKE '"+Serie +"') AND (ct.Sec_ID = 20)"
						Response.Write(sSQL)
   Response.End()
	    bHayParametros = false
	    ParametroCargaDeSQL(sSQL,0) 
		var rsSerie = AbreTabla(sSQL, 1,0)
   	
	if(!rsSerie.EOF){
	result = 1
	%>
				<input type="hidden" value="1" class="agenda" id="DSerOculta"/>
<%
	}else{
		%>
				<input type="hidden" value="0" class="agenda" id="DSerOculta"/>
<%
	message = "Serie no encontrada"
	}
		Respuesta = 0

	
   sSQL = "SELECT count(*) AS Disponibles FROM Inventario WHERE  Inv_EstatusCG20 = 1 AND Pro_ID =" + Parametro("Pro_ID",-1)
   var rsDisp = AbreTabla(sSQL, 1,0)
   
   var Disponibles = rsDisp.Fields.Item("Disponibles").Value
%>
<link href="/Template/Inspina/css/plugins/iCheck/custom.css" rel="stylesheet">

                       <div class="m-b-md">
							Resultado
                                </div>
                        <hr>        
                        <div class="row">
                         
                            <div class="col-lg-12">
                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                               	    <dt>Serie:</dt>
                                    <dd><%=Parametro("Inv_Serie","")%></dd>
                                </dl>
                                     <dl class="dl-horizontal">
                                	   	<dt>Estatus:</dt>
                                   		<dd><span class="label label-primary"><%=Parametro("Cat_Nombre","")%></span></dd>
                                   </dl>
                            </div>
                                <div class="col-lg-6">
                                   <dl class="dl-horizontal">
                                	<dt>SKU:</dt>
                                    <dd><%=Parametro("Pro_SKU","")%></dd>
                                    </dl>
                                </div>
                                  <div class="col-lg-12">
                                <!--Datos de la Orden de compra-->
                                		<dl class="dl-horizontal">
                                   		<dt>Producto:</dt>
                                    	<dd><%=Parametro("Pro_Nombre","")%></dd>
                                </dl>
                             	   </div>
                                          <div class="col-lg-12">
                                <!--Datos de la Orden de compra-->
                                		<dl class="dl-horizontal">
                                   		<dt>Almacen:</dt>
                                    	<dd><%=Parametro("Alm_Nombre","")%></dd>
                                </dl>
                             	   </div>
                                 <div class="col-lg-6">
                                <!--Datos de la Orden de compra-->
                             	    <dl class="dl-horizontal">
                                    <dt>Ubicacion:</dt>
                                    <dd><%=Parametro("Ubi_Nombre","")%></dd>
                                    <dt>Lote Ingreso:</dt>
                                    <dd><%=Parametro("Lot_Folio","")%></dd>
                                     <dt>Fecha Ingreso:</dt>
                                    <dd><%=Parametro("Lot_Fecha","")%></dd>
                                    <%if(Parametro("Inv_EstatusCG20","")==13){
                           					sSQL = "SELECT TA_FechaRegistro FROM TransferenciaAlmacen t "
						   					+"INNER JOIN TransferenciaAlmacen_Articulo_Picking a ON a.TA_ID=t.TA_ID WHERE TAS_Serie='"+ Serie +"'"									
											var rsTAFechaS=AbreTabla(sSQL,1,0)
											var FechaSalida = rsTAFechaS.Fields.Item("TA_FechaRegistro").Value
									%>
									 <dt>Fecha salida:</dt>
                                     <dd><%=FechaSalida%></dd>                            
                                         <% }
										 if(Parametro("Inv_EstatusCG20","")==5){
											 sSQL = "SELECT OV_FechaVenta FROM Orden_Venta v "
						   					+"INNER JOIN Orden_Venta_Picking p ON p.OV_ID=v.OV_ID WHERE OVP_Serie='"+ Serie +"'"									
											var rsOVFechaS=AbreTabla(sSQL,1,0)
											var FechaSalida = rsOVFechaS.Fields.Item("OV_FechaVenta").Value
											%>
                                              <dt>Fecha salida:</dt>
                                    <dd><%=FechaSalida%></dd>                            
                                    <%  }  %>
											       
                                </dl>
                            </div>
                            <!--Datos del Proveedor-->
                  
                            <div class="col-lg-6" id="cluster_info">
                        	        <dl class="dl-horizontal">
                                    <dt>Cliente:</dt>
                                    <dd><%=Parametro("Cli_Nombre","")%></dd>
                                     <dt>Pallet:</dt>
                                    <dd><%=Parametro("Pt_LPN","")%></dd>
                                    <dt>Disponibles:</dt>
                                    <dd><%=Disponibles%></dd>
                                  
                                    </dl>   
                            </div>
                        </div>
<% 
break;

case 1:
			sSQL = " SELECT *, (SELECT Alm_Nombre FROM TransferenciaAlmacen t "
						+" INNER JOIN Almacen a ON a.Alm_ID=t.TA_Start_Warehouse_ID "
    					+"INNER JOIN TransferenciaAlmacen_Articulo_Picking pk ON pk.TA_ID=t.TA_ID  WHERE TAS_Serie = '"+ Serie +"') as origen, "
						+" (SELECT Alm_Nombre FROM TransferenciaAlmacen tr INNER JOIN Almacen a ON a.Alm_ID=tr.TA_End_Warehouse_ID "
						+ "INNER JOIN TransferenciaAlmacen_Articulo_Picking pk2 ON pk2.TA_ID=tr.TA_ID WHERE TAS_Serie = '"+ Serie +"' ) as destino "
						+"FROM TransferenciaAlmacen_Articulo_Picking p INNER JOIN TransferenciaAlmacen t ON p.TA_ID=t.TA_ID "
						+" INNER JOIN Cat_Catalogo AS ct ON ct.Cat_ID = t.TA_EstatusCG51 "
						+" WHERE TAS_Serie = '"+ Serie +"' AND (ct.Sec_ID = 51)"
	
        var rsTRA= AbreTabla(sSQL,1,0)
	
	if(!rsTRA.EOF){
	result = 1
	%>
				<input type="hidden" value="1" class="agenda" id="TAOculta"/>
<%
	}else{
		%>
				<input type="hidden" value="0" class="agenda" id="TAOculta"/>
<%
	message = "La serie no contiene transferencia"
	}
		Respuesta = 0

        while (!rsTRA.EOF){
	var Folio = rsTRA.Fields.Item("TA_Folio").Value
	var Origen = rsTRA.Fields.Item("origen").Value
	var Destino = rsTRA.Fields.Item("destino").Value
	var Fecha = rsTRA.Fields.Item("TA_FechaRegistro").Value
	var Estatus = rsTRA.Fields.Item("Cat_Nombre").Value
	
        %>    
 

<h5>Transferencias</h5>

<div class="project-list">
  <table class="table table-hover">
   	 <tbody>
      <th>Folio</th>
      <th>Origen</th>
      <th>Destino</th>
      <th>Fecha</th>
      <th>Estatus</th>

      <tr>
        <td class="project-title">
        <%=Folio%>
        </td>
            <td class="project-title">
        <%=Origen%>
        </td>
        <td class="project-title">
         <%=Destino%>
        </td>
        <td class="project-title">
         <%=Fecha%>
        </td>
             <td class="project-title">
         <%=Estatus%>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargarTRA(<%=rsTRA.Fields.Item("TA_ID").Value%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsTRA.MoveNext() 
            }
        rsTRA.Close()   
		break;
 
 		case 2:
			%>
            
      

<h5>Ordenes de Compra</h5>
 
<div class="project-list">
  	  <table class="table table-hover">
      <tbody>
      <th>Folio</th>  
      <th>ASN</th>
      <th>Folio Cliente</th>
      <th>Fecha</th>
      
      <%
			sSQL = "SELECT * FROM Cliente_OrdenCompra_Entrega e INNER JOIN Inventario i ON e.Lot_ID=i.Inv_LoteIngreso INNER JOIN Cliente_OrdenCompra o ON e.Cli_ID=o.Cli_ID "
					 +"AND e.CliOC_ID = o.CliOC_ID INNER JOIN ASN a ON a.ASN_ID=e.ASN_ID WHERE Inv_Serie = '"+ Serie +"'"
				
    var rsCliOC= AbreTabla(sSQL,1,0)
	
	if(!rsCliOC.EOF){
	result = 1
	%>
				<input type="hidden" value="1" class="agenda" id="OCOculta"/>
<%
	}else{
		%>
				<input type="hidden" value="0" class="agenda" id="OCOculta"/>
<%
		message = "La serie no contiene orden de compra"
	}
		Respuesta = 0
		
    while (!rsCliOC.EOF){
	var Folio = rsCliOC.Fields.Item("CliOC_Folio").Value
	var ASN = rsCliOC.Fields.Item("ASN_FolioCliente").Value
	var FolioCliente = rsCliOC.Fields.Item("CliOC_NumeroOrdenCompra").Value
	var Fecha = rsCliOC.Fields.Item("CliOC_FechaRegistro").Value
		
        %>  

      <tr>
      
        <td class="project-title">
		<%=Folio%>
        </td>
        <td class="project-title">
  		<%=ASN%>
        </td>
        <td class="project-title">
		<%=FolioCliente%>
        </td>
         <td class="project-title">
          	<%=Fecha%>
             </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargarOC(<%=rsCliOC.Fields.Item("CliOC_ID").Value%>, <%=rsCliOC.Fields.Item("Cli_ID").Value%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsCliOC.MoveNext() 
            }
        rsCliOC.Close()   
		
		break; 
		
      case 3:
			%>
     <h5>Ordenes de Venta</h5>
<div class="project-list">
  <table class="table table-hover">
    <tbody>
      <th>Folio</th>
      <th>Folio Cliente</th>
      <th>Fecha</th>
      <th>Estatus</th>
      <%
			sSQL = "SELECT * FROM Orden_Venta_Picking a INNER JOIN Orden_Venta v ON a.OV_ID=v.OV_ID"
					+" INNER JOIN Cat_Catalogo AS ct ON ct.Cat_ID = v.OV_EstatusCG51 "
					+" WHERE OVP_Serie = '"+ Serie +"' AND (ct.Sec_ID = 51)"
        var rsOV= AbreTabla(sSQL,1,0)
	
	if(!rsOV.EOF){
	result = 1
			%>
				<input type="hidden" value="1" class="agenda" id="OVOculta"/>
<%
	}else{
	%>
				<input type="hidden" value="0" class="agenda" id="OVOculta"/>
<%
		message = "La serie no contiene orden de venta"
	}
		Respuesta = 0
		
        while (!rsOV.EOF){
	var Folio = rsOV.Fields.Item("OV_Folio").Value
	var OV_FolioCliente = rsOV.Fields.Item("OV_CUSTOMER_SO").Value
	var Fecha = rsOV.Fields.Item("OV_FechaRegistro").Value
	var Estatus = rsOV.Fields.Item("Cat_Nombre").Value
				
	

        %>    
 
      <tr>
          <td class="project-title">
     	<%=Folio%>
        </td>
        <td class="project-title">
    	<%=OV_FolioCliente%>
        </td>
        <td class="project-title">
         	<%=Fecha%>
        </td>
          <td class="project-title">
         	<%=Estatus%>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargarOV(<%=rsOV.Fields.Item("OV_ID").Value%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsOV.MoveNext() 
            }
        rsOV.Close()   
	break;
	 }
        %>        
    </tbody>
  </table>


</div>
      <script src="/Template/Inspina/js/plugins/iCheck/icheck.min.js"></script>                                
<script type="text/javascript">

 $(document).ready(function(){
	  

	});
	 function CargarTRA(TRA){

		var sDatos = "TA_ID=" + TRA 
			  
	
	$("#Contenido").load("/pz/wms/TA/TA_Ficha.asp?" + sDatos)
	
	}	
	
	 function CargarOV(OV){

		var sDatos = "OV_ID=" + OV 
			  	
		$("#Contenido").load("/pz/wms/OV/OV_Ficha.asp?" + sDatos)
	
	}	
	 function CargarOC(OC, Cli){

		var sDatos = "CliOC_ID=" + OC
		  	   sDatos += "&Cli_ID=" + Cli
			  	
		$("#Contenido").load("/pz/wms/OC/Cli_OrdenCompra.asp?" + sDatos)
	
	}	
    
</script>    

                   

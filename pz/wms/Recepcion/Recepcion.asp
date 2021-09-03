<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var TA_ID = 0
    var Folio = ""
    var BPM_Pro_ID = ""
    var sTipo= ""
    var Llaves = ""
    var Tarea = Parametro("Tarea", -1)	
    var FechaEntrega = Parametro("IR_FechaEntrega","")	
    var IDUsuario = Parametro("IDUsuario",-1) 
    var Cita = Parametro("IR_Folio","")	
    var ASN_Folio = Parametro("ASN_Folio","")	
    var SKU = Parametro("SKU","")	
    var Cliente = Parametro("Cli_ID",-1)	
    var CliOC_Folio = Parametro("CliOC_Folio","")	
    var IR_EstatusCG52 = Parametro("Estatus",-1)	
    var Busqueda = Parametro("Busqueda",-1)	
	var IR_Puerta = Parametro("IR_Puerta", -1)	
	
	
    var UsuarioRol = -1
    var FiltroCantidad = false
	
	
	/*============================== Valida usuario del proceso  ======================================*/
    var sSQLRol = "SELECT dbo.fn_BPM_DameRolUsuario(" + IDUsuario + ",3)"
    var rsRol = AbreTabla(sSQLRol,1,0)
	if(!rsRol.EOF){
		UsuarioRol = rsRol.Fields.Item(0).Value
	}    
    rsRol.Close()
    
    var date = new Date();			
    var dia = date.getDate()
    var mes = date.getMonth()
   
    if(dia < 10){
        //dia = dia +1
        dia = "0" + dia	
    }
    mes = mes + 1
    if(mes < 10){   
        mes = "0" + mes	
    }
                
    date = date.getFullYear() + "-" + mes + "-" + dia; 
    
			
	var condicion = ""
	
	if(Busqueda == 1 ){
		date = FechaEntrega
		condicion = "WHERE 1 = 1 "
	}else{
		condicion= "WHERE IR_FechaEntrega = '"+date+"'"
	}
	if(FechaEntrega != "") {
		condicion = condicion + " AND CAST(IR_FechaEntrega as date)  = '"+ FechaEntrega + "'"
	}
	if(IR_Puerta != -1){
	   condicion= condicion + " AND IR_Puerta = '"+ IR_Puerta+ "'"
	}
	
	if (ASN_Folio != ""){
		condicion = condicion + " AND ASN_FolioCliente = '" + ASN_Folio + "'"	
	}
	
	if (SKU != ""){
		condicion = condicion + " AND CliEnt_SKU = '" + SKU + "'"
	}
	
	if (Cliente != -1){
		condicion = condicion + " AND i.Cli_ID = " + Cliente
	}
	
	if (IR_EstatusCG52 != -1){
		condicion = condicion + " AND IR_EstatusCG52 = " + IR_EstatusCG52
	}
	if (Cita != ""){
		condicion = condicion + " AND IR_Folio LIKE '%" + Cita + "'"	
	}
	if (CliOC_Folio != ""){
		condicion = condicion + " AND CliOC_NumeroOrdenCompra = '" + CliOC_Folio + "'"	
	}
		
		
	/*============================== Cita mas proxima ======================================*/
	var sSQLRece = "SELECT TOP 1 * "
		sSQLRece += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRece += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntrega, 113) AS IRFechaEntrega "
		sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntregaTermina, 113) AS IRFechaEntregaTermina "
		sSQLRece += "FROM Inventario_Recepcion "
		sSQLRece += " WHERE CAST(IR_FechaEntrega as DATE) = CAST(getdate() as DATE) "
		sSQLRece += " ORDER BY IR_FechaEntrega ASC "	
			
		var rsRece = AbreTabla(sSQLRece,1,0)
		if(!rsRece.EOF){
			var Fol = rsRece.Fields.Item("IR_Folio").Value
			var IRFechaEntrega = rsRece.Fields.Item("IRFechaEntrega").Value
			var IRFechaEntregaTermina = rsRece.Fields.Item("IRFechaEntregaTermina").Value
			var PuertaMasProx = rsRece.Fields.Item("IR_Puerta").Value
	 
		}
		rsRece.Close()
	/*============================== Cita mas proxima ======================================*/
	/*============================== Numero de citas de la fecha escogida ======================================*/
//		var sSQLRec = "SELECT COUNT(*) as Citas "
//			sSQLRec += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
//			sSQLRec += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
//			sSQLRec += " FROM Inventario_Recepcion i "
//			sSQLRec += " "+condicion
//			
//        //sSQLRec += " AND cast(IR_FechaEntrega as date)  = '"  + date + "'"
//                
//		var rsRec = AbreTabla(sSQLRec,1,0)
		var NumCitas = 0
//		if(!rsRec.EOF){
//			var Hoy = rsRec.Fields.Item("Hoy").Value
//			var Maniana = rsRec.Fields.Item("Maniana").Value
//			NumCitas = rsRec.Fields.Item("Citas").Value
//		}	
//		rsRec.Close()
	/*============================== Numero de citas de la fecha escogida ======================================*/
%>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<style type="text/css">
    
    .opciones{
        margin-left: 20px;	
    }
 
	.Caja-Flotando {
		position: fixed;
		top: 10px;
        right: 20px;
        width: 260px;
	  }
    .Cita-Datos {
        font-size: 14px;
        font-weight: 600;
    }
 
</style>


	<div class="row">
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
				<% if(UsuarioRol == 3){%>
                <span class="pull-right"> <a   class="text-muted btnSupervisor"><i class="fa fa-inbox"></i>&nbsp;<strong>Supervisor </strong></a> </span>
				<%}%>
                <span class="pull-right"> <a   class="text-muted btnMovimiento"><i class="fa fa-inbox"></i>&nbsp;<strong> Movimiento </strong></a> &nbsp;|&nbsp;</span>
                    <span class="pull-right"><a data-toggle="modal" data-target="#ModalImprimir" class="text-muted"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir</strong></a>&nbsp;|&nbsp;(<strong id="NumCitas"><%=NumCitas%></strong>) Citas | </span>
                    <h5>Citas en agenda</h5>  
                </div>
                <div style="width: auto;">
<%
		if (Tarea == 1){
			
	  	  var sSQLRe = "SELECT * FROM (SELECT IR_Folio, IR_EstatusCG52, i.IR_ID, TA_ID, OV_ID, IR_Puerta , IR_FechaEntrega, i.Cli_ID, i.CliOC_ID, i.Prov_ID, i.OC_ID , c.CliOC_ID AS clioc"
				+ " , IR_DescripcionVehiculo, IR_Conductor, IR_Placas, IR_Color"
                +  ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
                +  ", CONVERT(VARCHAR(20), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 103) AS IRFechaEntregaTermina "
                +  ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
                +  ", CONVERT(VARCHAR(10), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 108) AS IRHoraEntregaTermina "
                +  ", Case IR_EsPorASN "
                +  " WHEN 1 THEN (SELECT COUNT(*) FROM ASN a where a.IR_ID = i.IR_ID)  " 
                +  "       ELSE 1 " 
                +  " END as Documentos " 
                +  " FROM Inventario_Recepcion i "
            	+ " LEFT JOIN ASN asn ON asn.IR_ID = i.IR_ID"
                + " LEFT JOIN Cliente_OrdenCompra_Entrega c ON c.IR_ID= i.IR_ID"
                + " LEFT JOIN Cliente_OrdenCompra_EntregaProducto p ON  p.CliEnt_ID = c.CliEnt_ID AND p.Cli_ID=c.Cli_ID"
				+ " LEFT JOIN Proveedor_OrdenCompra_Entrega e ON e.IR_ID = i.IR_ID"
				+ " LEFT JOIN Proveedor_OrdenCompra_EntregaProducto pp ON pp.ProvEnt_ID = e.ProvEnt_ID AND pp.Prov_ID=e.Prov_ID"
      			+ " LEFT JOIN Cliente_OrdenCompra o ON o.CliOC_ID = c.CliOC_ID AND o.Cli_ID = c.Cli_ID"
				+ " "+condicion
				+" AND IR_Habilitado = 1 "
                +  " GROUP BY IR_Folio, IR_EstatusCG52, i.IR_ID, TA_ID, OV_ID, IR_Puerta , IR_FechaEntrega, i.Cli_ID, i.CliOC_ID,  c.CliOC_ID, i.Prov_ID, i.OC_ID, IR_DescripcionVehiculo "
				+ " , IR_Conductor, IR_Placas, IR_Color, IR_FechaEntrega,  IR_FechaEntregaTermina, IR_EsPorASN) as t1  "
                +  " where Documentos > 0 "
                +  " ORDER BY IR_FechaEntrega DESC "
        } else {
                var sSQLRe = "SELECT * FROM (SELECT * "
                +  ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
                +  ", CONVERT(VARCHAR(20), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 103) AS IRFechaEntregaTermina "
                +  ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
                +  ", CONVERT(VARCHAR(10), ISNULL(IR_FechaEntregaTermina,dateadd(minute,90,IR_FechaEntrega)), 108) AS IRHoraEntregaTermina "
                +  ", Case IR_EsPorASN "
                +  " WHEN 1 THEN (SELECT COUNT(*) FROM ASN a where a.IR_ID = ir.IR_ID)  " 
                +  "       ELSE 1 " 
                +  " END as Documentos " 
                +  " ,CliOC_ID as clioc " 
                +  " FROM Inventario_Recepcion ir "
                +  "  WHERE  IR_Habilitado = 1 AND cast (IR_FechaEntrega as date)  = '"+date+"'"
                +  " ) as t1  "
                +  " where Documentos > 0 "
                +  " ORDER BY IR_FechaEntrega DESC "
        }
                
                
        //Response.Write(sSQLRe)
        var rsRe = AbreTabla(sSQLRe,1,0)
		if(!rsRe.EOF){
			while (!rsRe.EOF){
				NumCitas++
				var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
				var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
				var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
				var Estatus = rsRe.Fields.Item("IR_EstatusCG52").Value
				var IR_Puerta = rsRe.Fields.Item("IR_Puerta").Value
				var IR_ID = rsRe.Fields.Item("IR_ID").Value
				var TA_ID = rsRe.Fields.Item("TA_ID").Value
				var OV_ID = rsRe.Fields.Item("OV_ID").Value
				var CliOC_ID = rsRe.Fields.Item("clioc").Value
				var Prov_ID =  rsRe.Fields.Item("Prov_ID").Value
				var Cli_ID = rsRe.Fields.Item("Cli_ID").Value
				var BPM_Pro_ID = -1
				
				
				sTipo= ""
				Folio = ""
				if(TA_ID > 0){
					var sSQLTA = "SELECT TA_Folio, BPM_Pro_ID "
						sSQLTA += " FROM TransferenciaAlmacen WHERE TA_ID = " + TA_ID
					var rsTA = AbreTabla(sSQLTA,1,0)
					if (!rsTA.EOF){
						Folio = rsTA.Fields.Item("TA_Folio").Value
						BPM_Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
					}
					rsTA.Close()
					sTipo= "Transferencia"
				} 
					
				if(CliOC_ID>0){
					var sSQLTA = "SELECT CliOC_Folio, BPM_Pro_ID "
						sSQLTA += " FROM Cliente_OrdenCompra "
						sSQLTA += " WHERE Cli_ID = " + Cli_ID
						sSQLTA += " AND CliOC_ID = " + CliOC_ID
					
					var rsTA = AbreTabla(sSQLTA,1,0)
					if (!rsTA.EOF){
						Folio = rsTA.Fields.Item("CliOC_Folio").Value
						BPM_Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
					}
					rsTA.Close()
					sTipo = "Cliente Orden de compra"
				} 
			   
				   
			   var Prov_ID = rsRe.Fields.Item("Prov_ID").Value
			   var OC_ID = rsRe.Fields.Item("OC_ID").Value
			   if(Prov_ID>0){
					var sSQLTA = "SELECT OC_Folio, BPM_Pro_ID "
						sSQLTA += " FROM Proveedor_OrdenCompra "
						sSQLTA += " WHERE Prov_ID = " + Prov_ID
						sSQLTA += " AND OC_ID = " + OC_ID
		
					var rsTA = AbreTabla(sSQLTA,1,0)
					if (!rsTA.EOF){
						Folio = rsTA.Fields.Item("OC_Folio").Value
						BPM_Pro_ID = rsTA.Fields.Item("BPM_Pro_ID").Value
					}
					rsTA.Close()
					sTipo= "Proveedor Orden de compra"
				} 
				var keys = '{IR_ID:'+IR_ID
				+',TA_ID:'+TA_ID
				+',Cli_ID:'+Cli_ID
				+',OV_ID:'+OV_ID
				+',CliOC_ID:'+CliOC_ID
				+',Prov_ID:'+Prov_ID
				+',Folio:"'+Folio+'",BPM_Pro_ID:'+BPM_Pro_ID
				+',IDUsuario:'+IDUsuario
				+'}'
							
//			Response.Write("<br>")
//			Response.Write("<br>")
//			Response.Write("<br>")
			Response.Write(keys)
			   
			   
				Llaves = "data-irid='" + IR_ID +"' data-taid='" + TA_ID +"' " 
				Llaves += " data-cliid='" + Cli_ID + "' data-cliocid='" + CliOC_ID + "' " 
				Llaves += " data-provid='" + Prov_ID + "' data-ocid='" + OC_ID + "' data-ovid='" + OV_ID + "' "
				Llaves += " data-proid='" + BPM_Pro_ID + "' "
	
	
				var IR_DescripcionVehiculo = rsRe.Fields.Item("IR_DescripcionVehiculo").Value 
				var IR_Conductor = rsRe.Fields.Item("IR_Conductor").Value
				var IR_Placas = rsRe.Fields.Item("IR_Placas").Value
				var IR_Color = rsRe.Fields.Item("IR_Color").Value
				if(IR_Color == "") { IR_Color = "#337ab7"} 
           
%>
                    <div class="ibox-content" id="<%=IR_Folio%>">
                        <div class="table-responsive">
                            <table  class="table">
                                <tbody>
                                  <tr>
                                  <td nowrap="nowrap" >
                                  	  <dl class="small m-b-none">
                                            <dt>Folio cita</dt>
                                            <dd>
                                                <h3 style="color:<%=IR_Color%>;">
                                                    <a data-irid="<%=IR_ID%>" class="btnCita textCopy" 
                                                       style="color:<%=IR_Color%>;" ><%=IR_Folio%></a>
                                                </h3>
                                            </dd>
                                      </dl>
                                  </td>
                                  <td colspan="2" class="desc" style="width: 30%;">
                                      <div class="m-t pull-right" > 
                                            <a onclick='Recibo.Recibir(<%Response.Write(keys)%>)'
                                               title="Iniciar el proceso de recepci&oacute;n"
											   class="text-muted btnRecibir"><i class="fa fa-inbox"></i>
                                               <strong>&nbsp;Recibir</strong></a> 
                                               &nbsp;&nbsp;&nbsp;
                                            <a title="Reportar alg&uacute;n problema" class="text-muted btnHuella">
                                            <i class="fa fa-inbox"></i>&nbsp;<strong>Incidencias</strong></a>
                                               &nbsp;&nbsp;&nbsp;
                                            <a title="Imprime lista de art&iacute;culos"  
                                               class="text-muted btnImprimeRecep"><i class="fa fa-print">
                                            </i>&nbsp;<strong>Imprimir</strong></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="261">
                                    <% if(Prov_ID == 32){%>	
									<a  style="color:Red" >ARNOKV</a>
                                            <!-- img src="/Img/wms/Logo_Izzi_2.jpg" title="Izzi" style="width:inherit;"/  -->
                                            
                                   <% }    
                                        if(Cli_ID == 2){%>	
									<a  style="color:Red" >IZZI</a>
                                            <!-- img src="/Img/wms/Logo_Izzi_2.jpg" title="Izzi" style="width:inherit;"/  -->
                                            
                                   <% }
								      if(Cli_ID == 6) { %>
                                        <h3 style="color:Red;">
                           		  		<a  style="color:Red" >Elektra</a>
                                  </h3>
								  <%  }  %>
                                    </td>
                                    <td width="82" class="desc" style="width: 30%;">
                                        <dl class="small m-b-none">
                                            <dt>Folio <%=sTipo%>:</dt>
                                            <dd>
                                                <h3 class="text-navy">
                                                    <a data-irid="<%=IR_ID%>" class="text-navy btnTransf textCopy" ><%=Folio%></a>
                                                </h3>
                                            </dd>
   <%                                         
            var sSQLASN = "SELECT ASN_ID, ASN_FolioCliente, ASN_FolioCita, ASN_Folio "
                sSQLASN += ",(Select CliPrv_Nombre from Cliente_Proveedor clP "
                sSQLASN += " where clP.CLi_ID = ASN.Cli_ID   AND clP.CliPrv_ID = ASN.CProv_ID) as Provedor"
                sSQLASN += " FROM ASN "
                sSQLASN += " WHERE IR_ID = " + IR_ID

            var rsASN = AbreTabla(sSQLASN,1,0)
            while (!rsASN.EOF){
%>          
                <dt>ASN: <%=rsASN.Fields.Item("ASN_Folio").Value%></dt>
                <dd>
                    <h3 class="text-navy">
                        <a data-asnid="<%=rsASN.Fields.Item("ASN_ID").Value%>" class="text-navy btnTransf textCopy" ><%=rsASN.Fields.Item("ASN_FolioCliente").Value%></a>
                    </h3>
                    <small><%=rsASN.Fields.Item("Provedor").Value%></small>
   <%                                         
                    var sSQLASNf = "select CliOC_NumeroOrdenCompra "
                                 + " from Cliente_OrdenCompra o, Cliente_OrdenCompra_Entrega e, asn a "
                                 + " where e.IR_ID = a.IR_ID  AND e.ASN_ID = a.ASN_ID "
                                 + " AND o.Cli_ID = e.Cli_ID and o.CliOC_ID = e.CliOC_ID "
                                 + " AND a.ASN_ID = " + rsASN.Fields.Item("ASN_ID").Value

                    var rsASNf = AbreTabla(sSQLASNf,1,0)
                    while (!rsASNf.EOF){
                        Response.Write("<br>OC: <span class='textCopy'>" + rsASNf.Fields.Item("CliOC_NumeroOrdenCompra").Value+"</span>")
                        rsASNf.MoveNext()  
                    } 
                    rsASNf.Close()   
%>
                </dd>              
 <%                                           
                        rsASN.MoveNext() 
                    }
                    rsASN.Close()  
%>
                                            <br>
                                            <dt>Cortina</dt>
                                            <dd>
                                                 <spam style="font-size: 41px;">
                                                <%=IR_Puerta%> 
                                                </spam>
                                            </dd>         
                                        </dl>
                                        
                                    </td>
                                    <td width="216" >
                                          <table width="400px" border="0" style="t  ">
                                    <tbody>
                                        
                                      <tr>
                                        <td width="27%">
                                            <strong>Conductor</strong>
                                        </td>
                                        <td width="73%">
										<%if(IR_Conductor !=""){ %>          
                                            <div class="Cita-Datos"><%=IR_Conductor%></div>
                                        <%}else{%>
                                            <div class="Cita-Datos">Sin datos</div>
                                        <%}%>             
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                            <strong>Placas</strong>
                                        </td>
                                        <td>
										  <%if(IR_Placas !=""){ %>               
                                            <div class="Cita-Datos"><%=IR_Placas%></div>
										  <%}else{%>
                                            <div class="Cita-Datos">Sin datos</div>
                                          <%}%>               
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                            <strong>Veh&iacute;culo</strong>
                                        </td>
                                        <td>
									  <%if(IR_DescripcionVehiculo !=""){ %>               
                                            <div class="Cita-Datos"><%=IR_DescripcionVehiculo%></div>
									  <%}else{%> 
                                            <div class="Cita-Datos">Sin datos</div>
									  <%}%>  
                                        </td>
                                      </tr> 
                                      <tr>
                                        <td colspan="2">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td>
                                            <strong>Inicia</strong>
                                        </td>
                                        <td>
                                            <div class="Cita-Datos"><%=IR_FechaEntrega%></div>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                            <strong>Termina <small>(Estimado)</small></strong>
                                        </td>
                                        <td>
                                            <div class="Cita-Datos"><%=IR_FechaEntregaTermina%></div>
                                        </td>
                                        </tr>
                                   
                                    </tbody>
                                  </table>
                                    </td>
                                  </tr>
                                       <tr>
                                        <td>
                                          <a class="btn btn-white btn-sm btnDespliegaProductos" data-irid="<%=rsRe.Fields.Item("IR_ID").Value%>" href="#" >
                                          <i class="fa fa-cube"></i> Productos</a>
                                          <a class="btn btn-white btn-sm btnDespliegaPallets" data-irid="<%=rsRe.Fields.Item("IR_ID").Value%>"  href="#">
                                          <i class="fa fa-cubes"></i> Pallets</a>
                                            <button class="btn btn-danger btnCierra btn-xs" id="btnC<%=rsRe.Fields.Item("IR_ID").Value%>" 
                                            data-irid="<%=rsRe.Fields.Item("IR_ID").Value%>" >Cierra</button>
                                            

                                        </td>
                                      </tr>  
                                </tbody>
                            </table>
                        </div>
                    </div>
					<%	
                        rsRe.MoveNext() 
                    }
					 rsRe.Close() 
			 
					
		}else{%>
            <div class="row">
                <div class="col-md-12">
                    <div class="ibox-content">
                        <h4><strong>No se encontr&oacute; alguna cita</strong></h4>
                    </div>
                </div>
            </div>
        
		<%}%>
                </div>
            </div>
        </div>
        <div class="col-md-3" > 
            <div class="ibox" id="dvFiltros">
                <div class="ibox-title">
                    <h5 class="text-danger">Cita m&aacute;s pr&oacute;xima </h5>
                </div>
                <div class="ibox-content">
                    <h4 class="font-bold text-success">
                        <a  onclick="javascript:Enfasis($(this))"><%=Fol%></a>
                    </h4>
                    <h4 class="font-bold text-navy">
                        <%=IRFechaEntrega%>
                    </h4>
                     <%CargaCombo("IR_Puerta",'class="form-control"',"InmP_ID","InmP_Nombre","Ubicacion_Inmueble_Posicion","Inm_ID = 1","InmP_ID","Editar",0,"Puerta")%>
                     <input class="form-control Cita"
                        id="InputCita" type="text" autocomplete="off"
                        value="" placeholder="Folio de Cita"> 
                    <input class="form-control"
                        id="InputASN" type="text" autocomplete="off"
                        value="" placeholder="Folio ASN"> 
                        <div class="btn-group">
                    <input class="form-control"
                        id="InputSKU" type="text" autocomplete="off"
                        value="" placeholder="SKU">
                    <input class="form-control"
                        id="CliOC_Folio" type="text" autocomplete="off"
                        value="" placeholder="Orden de compra"> 
					<%  //Combo clientes
                        CargaCombo("cbCli_ID","class='form-control cboCli_ID'" 
                        ,"Cli_ID","Cli_Nombre","Cliente","","Cli_Nombre",-1,0,"Cliente")
						//Combo estatus
						var sEventos = "class='form-control CboEstatus'"
						ComboSeccion("CboEstatus", sEventos, 52, -1, 0, "Estatus", "", "Editar")
					%>
                    <h4 class="font-bold text-warning">
                        Buscar Fecha:
                    </h4>
                    <input class="form-control Fecha" id="InputBuscarFecha" 
                        placeholder="dd/mm/aaaa" type="text" autocomplete="off" value=""> 
                        
                    <a class="btn btn-danger btn-sm BuscarFecha"><i class="fa fa-calendar"></i>&nbsp;&nbsp;Buscar</a>
                </div>
            </div>
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Ayuda</h5>
                    </div>
                    <div class="ibox-content text-center">
                        <h3><i class="fa fa-phone"></i> +55 12 34 56 78</h3>
                        <span class="small">
                            Gerente de recepci&oacute;n
                        </span>
                    </div>
                </div>
            </div> 
                
        </div>
    </div>


<div class="modal fade" id="ModalImprimir" tabindex="-1" role="dialog" aria-labelledby="ModalImprimir" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Imprimir</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-md-3">D&iacute;a requerido:</label>
                <div class="i-checks">
                    <label class="control-label opciones"><input type="radio" value="" checked="checked" name="gpo1"/>&nbsp;Hoy ()</label>
                    <label class="control-label opciones"><input type="radio" value="" name="gpo1"/>&nbsp;Ma&ntilde;ana ()</label>
                </div>
                
            </div>     
            <div class="form-group">
                <label class="control-label col-md-3">Dirigido a:</label>
                <div class="i-checks" data-radios="opciones">
                    <label class="control-label opciones"><input type="radio" value="1" checked="checked" name="gpo2"/>&nbsp;Ambos</label>
                    <label class="control-label opciones"><input type="radio" value="2" name="gpo2"/>&nbsp;Seguridad</label>
                    <label class="control-label opciones"><input type="radio" value="3" name="gpo2"/>&nbsp;Recepci&oacute;n</label>
                </div>
            </div>     
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary btnImprimeConfig">Imprimir</button>
      </div>
    </div>
  </div>
</div>

<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script type="application/javascript" >

//	$(document).scroll(function (e) {
//		if ($(document).scrollTop() > 200) {
//			$("#dvFiltros").addClass("Caja-Flotando");
//		} else {
//			$("#dvFiltros").removeClass("Caja-Flotando");
//		}
//	});

	var loading = Global_loading
	$(document).ready(function () {
        $('.i-checks').iCheck({radioClass: 'iradio_square-green'});
        $('.btnCierra').hide()
        $('#loading').hide()
        $("#InputASN").val('<%=ASN_Folio%>')
        $("#InputCita").val('<%=Cita%>')
        $("#InputSKU").val('<%=SKU%>')
        $("#CliOC_Folio").val('<%=CliOC_Folio%>')
        $("#cbCli_ID").val('<%=Cliente%>')
        $("#CboEstatus").val('<%=IR_EstatusCG52%>')
		$("#NumCitas").html('<%=NumCitas%>')
        //$("#InputBuscarFecha").val('<%=FechaEntrega%>')


        $('.btnCierra').hide()
        $('.btnCierra').click(function (e) {
            e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            $('.btnDespliegaProductos').show('slow')
            $('.btnDespliegaPallets').show('slow')
            $('#tr_prod' + IR_ID).hide('slow')
            $('#tr_pt' + IR_ID).hide('slow')

            setTimeout(function () {
                $('#tr_prod' + IR_ID).remove()
                $('#tr_pt' + IR_ID).remove()
            }, 800)
        });

        $('.btnDespliegaProductos').click(function (e) {
            e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            $('#btnC' + IR_ID).show('slow')

            $('<tr id="tr_prod' + IR_ID + '"><td colspan="12" id="td_prod' + IR_ID + '">' + loading + '</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                IR_ID: IR_ID
            }
            $("#td_prod" + IR_ID).load("/pz/wms/Recepcion/ASN_ClienteOC_EntregasProductos.asp", dato);
        });

        $('.btnDespliegaPallets').click(function (e) {
            e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            $('#btnC' + IR_ID).show('slow')
            $('<tr id="tr_pt' + IR_ID + '"><td colspan="12" id="td_pt' + IR_ID + '">' + loading + '</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                IR_ID: IR_ID
            }
            $("#td_pt" + IR_ID).load("/pz/wms/Recepcion/ASN_Pallets.asp", dato);
        });


        $('.btnRecibir').click(function (e) {
            e.preventDefault()
        });

        $('.BuscarFecha').click(function (e) {
            e.preventDefault()
            var Fecha = $('#InputBuscarFecha').val();
            if (Fecha != "") {
                var Fch = Fecha.split("/")
                Fecha = Fch[2] + "-" + Fch[1] + "-" + Fch[0]
            }

            var Parametros = {
                Tarea: 1,
                IR_FechaEntrega: Fecha,
                IR_Puerta: $('#IR_Puerta').val(),
                IR_Folio: $("#InputCita").val(),
                ASN_Folio: $("#InputASN").val(),
                SKU: $("#InputSKU").val(),
                Cli_ID: $("#cbCli_ID").val(),
                Estatus: $("#CboEstatus").val(),
                CliOC_Folio: $("#CliOC_Folio").val(),
                Busqueda: 1,
                IDUsuario: $("#IDUsuario").val()
            }

            $("#Contenido").html(Global_loading)
            $("#Contenido").load("/pz/wms/Recepcion/Recepcion.asp", Parametros)
            $('#loading').hide()

        });

        $('.btnHuella').click(function (e) {
            e.preventDefault()

            var Parametros = {
                CliOC_ID: $(this).data("cliocid"),
                Cli_ID: $(this).data("cliid"),
                TA_ID: $(this).data("taid")
            }

            $("#Contenido").html(Global_loading)
            $("#Contenido").load("/pz/wms/Recepcion/RecepcionIncidencias.asp", Parametros)
        });

        $('.btnSupervisor').click(function (e) {
            e.preventDefault()
            var Parametros = {
                CliOC_ID: $(this).data("cliocid"),
                IDUsuario: $("#IDUsuario").val()
            }

            $("#Contenido").html(Global_loading)
            $("#Contenido").load("/pz/wms/Recepcion/RecepcionSupervisor.asp", Parametros)
        });

        $('.btnMovimiento').click(function (e) {
            e.preventDefault()
            $("#Contenido").html(Global_loading)
            $("#Contenido").load("/pz/wms/Insumos/RecepcionMovimiento.asp")
        });

        $('.btnImprimeRecep').click(function (e) {
            e.preventDefault()
            RecepImprime($(this).data("irid"), $(this).data("cliocid"), $(this).data("cliid"), 3)
        });

        $('.btnImprimeConfig').click(function (e) {
            e.preventDefault()
            RecepImprimeTodos($("input[name='gpo1']:checked").val(), $("input[name='gpo2']:checked").val())
        });


        $('#btnPruebaRapida').click(function (e) {
            e.preventDefault()
            MandaSO()
        });



    });
	
	$('.Fecha').datepicker({
		format: "dd/mm/yyyy",
		todayBtn: "linked", 
		language: "es",
		todayHighlight: true,
		autoclose: true
	});
	
	
	var Recibo = {
		Recibir:function(Parametros){
			console.log(Parametros)
            if (Parametros.IDUsuario > -1) {
				$("#Contenido").html(Global_loading)
                $("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp",Parametros)
            }
			
		}
		
	}


	function Enfasis(Folio) {
		var Fol = Folio.attr('id');
		$('#' + Fol).addClass('bg-warning')
	
		setTimeout(function () {
			$('#' + Fol).removeClass('bg-warning')
		}, 5000)
	}

	function RecepImprime(f, o, c, t) {
	
		var newWin = window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?Tipo=" + t + "&IR_ID=" + f + "&CliOC_ID=" + o + "&Cli_ID=" + c);
	}
	
	function RecepImprimeTodos(d, v) {
		var newWin = window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?IR_ID=-1&Dia=" + d + "&Tipo=" + v);
	}

</script>
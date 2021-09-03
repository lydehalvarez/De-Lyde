<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var OV_ID = Parametro("OV_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
    var IR_ID = Parametro("IR_ID",-1)
	var BPM_Pro_ID = Parametro("BPM_Pro_ID",-1)
	var IDUsuario = Parametro("IDUsuario",Parametro("IDUsuario",-1))	

    var sSQL1  = ""

    var IR_Folio = ""
    var IR_EsPorASN = 0
    var CliEnt_ID = -1
    var CLIENTE = ""
    var Prov_Nombre = ""
    var IR_FechaEntrega = ""	
    var CONDUCTOR = ""
    var VEHICULO = ""
    var PLACAS = ""
    var Pro_Nombre = ""
    var Cantidad = ""
    var Pro_SKU = ""

	var keys = '{Tarea:-1'
				+',IR_ID:'+IR_ID
				+',TA_ID:'+TA_ID
				+',Cli_ID:'+Cli_ID
				+',OV_ID:'+OV_ID
				+',CliOC_ID:'+CliOC_ID
				+',Prov_ID:'+Prov_ID
				+',BPM_Pro_ID:'+BPM_Pro_ID
				+',IDUsuario:'+IDUsuario
			+'}'

	var sSQLRecep = "SELECT CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
                  +      ", ISNULL(CONVERT(VARCHAR(20), IR_FechaEntregaTermina, 103),'') AS IRFechaEntregaTermina "
                  +      ", ISNULL(CONVERT(VARCHAR(8), IR_FechaEntrega, 108),'') AS IRHoraEntrega "
                  +      ", ISNULL(CONVERT(VARCHAR(10), IR_FechaEntregaTermina, 108),'') AS IRHoraEntregaTermina "
                  +      ", ISNULL(IR_Conductor,'') AS CONDUCTOR "
                  +      ", ISNULL(IR_Placas,'') AS PLACAS "
                  +      ", ISNULL(IR_DescripcionVehiculo,'') AS VEHICULO "
                  +      ", ISNULL(IR_Color,'') AS COLOR"
                  +      ", (Select Cli_Nombre From Cliente ct where ct.Cli_ID = ir.Cli_ID ) as CLIENTE "
                  +      ", IR_EsPorASN, IR_Folio"

                  +  " FROM Inventario_Recepcion ir "
                  + " WHERE IR_ID = " + IR_ID

    var rsRe = AbreTabla(sSQLRecep,1,0)

    if (!rsRe.EOF){
        IR_Folio = rsRe.Fields.Item("IR_Folio").Value
        IR_EsPorASN = rsRe.Fields.Item("IR_EsPorASN").Value
        CLIENTE = rsRe.Fields.Item("CLIENTE").Value
        CONDUCTOR = rsRe.Fields.Item("CONDUCTOR").Value        
        PLACAS = rsRe.Fields.Item("PLACAS").Value        
        VEHICULO = rsRe.Fields.Item("VEHICULO").Value        
        IR_FechaEntrega  = rsRe.Fields.Item("IRFechaEntrega").Value
    }
    rsRe.Close()
        
    if(PLACAS == "0"){
        PLACAS = ""
	}


    if(IR_EsPorASN == 1) {
        
            var sCondicion = "IR_ID = " + IR_ID
            var  CliEnt_ID = BuscaSoloUnDato("CliEnt_ID","Cliente_OrdenCompra_Entrega",sCondicion,-1,0) 
			//Response.Write(CliEnt_ID)
		
        var sSQL1  = "SELECT IR_ID, IR_FechaEntrega, IR_Folio, t1.Cli_ID, CProv_ID, CliEnt_SKU, pr.Pro_ID "
                   + ", CliEnt_CORID, Recibidos, Solicitados, Pro_Nombre, Pro_SKU, CliOC_NumeroOrdenCompra"
                   + ", (select CliPrv_Nombre from Cliente_Proveedor cp "
                   +    " where cp.CLi_ID = t1.Cli_ID and cp.CliPrv_ID = t1.CProv_ID) as Proveedor "
                   + " FROM ( select ir.IR_ID, ir.IR_FechaEntrega, IR_Folio, asn.Cli_ID, CProv_ID "
                   +             " , CliEnt_SKU, ep.Pro_ID, CliEnt_CORID, e.CliOC_ID "
                   +             " , SUM(ep.CliEnt_CantidadPallet) as Recibidos "
                   +             " , SUM(CliEnt_ArticulosRecibidos) as Solicitados "
                   +          " from Inventario_Recepcion ir, ASN, Cliente_OrdenCompra_Entrega e "
                   +              ", Cliente_OrdenCompra_EntregaProducto ep "
                   +         " where ir.IR_ID  = " + IR_ID
                   +         " and ir.IR_ID = ASN.IR_ID "
                   +         " and e.IR_ID = ir.IR_ID AND e.ASN_ID = ASN.ASN_ID "
                   +         " and e.Cli_ID = ep.Cli_ID and e.CliOC_ID = ep.CliOC_ID "
                   +         " AND e.CliEnt_ID = ep.CliEnt_ID "
                   +         " group by ir.IR_ID, ir.IR_FechaEntrega, IR_Folio, asn.Cli_ID, CProv_ID "
                   +         " , CliEnt_SKU, ep.Pro_ID, CliEnt_CORID, e.CliOC_ID "
                   +         "     ) AS T1,  Producto pr,  Cliente_OrdenCompra o "
                   +         " WHERE T1.Pro_ID = pr.Pro_ID  "
                   +         " and o.Cli_ID = T1.Cli_ID and o.CliOC_ID = T1.CliOC_ID "
  
			sSQL = "SELECT ASN_FolioCliente FROM ASN WHERE IR_ID = "+ IR_ID
			
		var rsASN = AbreTabla(sSQL,1,0)

    } else {
        

        if(CliOC_ID > -1){

            var sCondicion = "IR_ID = " + IR_ID
             var  CliEnt_ID = BuscaSoloUnDato("CliEnt_ID","Cliente_OrdenCompra_Entrega",sCondicion,-1,0) 

            var sSQL1  = "SELECT Inventario_Recepcion.IR_ID, IR_FechaEntrega "
                       + ", IR_FechaEntregaTermina, IR_FechaElaboracion, IR_AlmacenRecepcion, IR_ZonaRecepcionCG88 "
                       + ", IR_Folio, IR_FolioCliente, Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta "
                       + ", IR_Conductor, IR_Placas, IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre "
                       + ", Producto.Pro_SKU, SUM(Cliente_OrdenCompra_EntregaProducto.CliEnt_ArticulosRecibidos) AS Solicitados  "
                       +  " FROM Producto "
                       + " INNER JOIN Cliente_OrdenCompra_EntregaProducto "
                       +         " ON Producto.Pro_ID = Cliente_OrdenCompra_EntregaProducto.Pro_ID "
                       + " INNER JOIN Cliente_OrdenCompra "
                       +         " ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra.Cli_ID "
                       +        " AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra.CliOC_ID "
                       + " INNER JOIN Cliente_OrdenCompra_Entrega "
                       +         " ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra_Entrega.Cli_ID "
                       +         " AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra_Entrega.CliOC_ID "
                       +         " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = Cliente_OrdenCompra_Entrega.CliEnt_ID "
                       + " INNER JOIN Inventario_Recepcion "
                       +         " ON Cliente_OrdenCompra_Entrega.IR_ID = Inventario_Recepcion.IR_ID "
            if(IR_EsPorASN == 0){
                 sSQL1 +=       " AND Cliente_OrdenCompra_Entrega.CliOC_ID = Inventario_Recepcion.CliOC_ID "  
            }
                 sSQL1 += "INNER JOIN Cliente c "
                       +         " ON Inventario_Recepcion.Cli_ID = c.Cli_ID "
                       + " WHERE Inventario_Recepcion.IR_ID = " + IR_ID 
                       +   " AND Inventario_Recepcion.Cli_ID = " + Cli_ID  
            if(IR_EsPorASN == 0){
                 sSQL1 +=  " AND Inventario_Recepcion.CliOC_ID = " + CliOC_ID 
                       +  " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = " + CliEnt_ID
					   
            }
                 sSQL1 += " GROUP BY "
                       +            "  Producto.Pro_SKU, Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina "
                       +            ", IR_FechaElaboracion, IR_AlmacenRecepcion, IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente "
                       +            ", Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta, IR_Conductor, IR_Placas "
                       +            ", IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre, Producto.Pro_SKU, CliOC_NumeroOrdenCompra "

            }
            if(TA_ID > -1){ 
                 var sSQL1  = "select r.*, c.Cli_Nombre, p.Pro_Nombre, p.Pro_SKU, a.TAA_Cantidad as Solicitados, t.TA_Folio from inventario_recepcion r "
                     sSQL1 += " inner join cliente c on r.Cli_ID=c.Cli_ID "
                     sSQL1 += " inner join TransferenciaAlmacen t  on  t.TA_ID = r.TA_ID "
                     sSQL1 += " inner join TransferenciaAlmacen_Articulos a  on t.TA_ID = a.TA_ID "
                     sSQL1 += " inner join Producto p  on a.Pro_ID = p.Pro_ID where r.TA_ID = " + TA_ID 
                     sSQL1 += " and r.IR_ID = " + IR_ID

             }
             if(OC_ID > -1){
                 var sSQL1  = "select  IR_Folio, IR_FechaEntrega, IR_Conductor, IR_DescripcionVehiculo, IR_Placas, c.Prov_Nombre "
                     sSQL1 += " , p.Pro_Nombre, p.Pro_SKU, a.OCP_Cantidad as Solicitados, OC_Folio from inventario_recepcion r "
                     sSQL1 += " inner join proveedor c on r.Prov_ID=c.Prov_ID "
                     sSQL1 += " inner join Proveedor_OrdenCompra o  on  o.OC_ID = r.OC_ID "
                     sSQL1 += " inner join  Proveedor_OrdenCompra_Articulos a  on o.OC_ID = a.OC_ID "
                     sSQL1 += " inner join  Producto p  on a.Pro_ID = p.Pro_ID  where  a.OC_ID = " + OC_ID + " and a.Prov_ID = " + Prov_ID
                  	 sSQL1 += " AND r.IR_ID = " + IR_ID 
				     sSQL1 += " GROUP BY IR_Folio, IR_FechaEntrega, IR_Conductor, IR_DescripcionVehiculo"
                     sSQL1 += " , IR_Placas, c.Prov_Nombre,  p.Pro_Nombre, p.Pro_SKU, a.OCP_Cantidad, OC_Folio "

					 //Response.Write(sSQL1)
             }        
        
    }
	var rsArt = AbreTabla(sSQL1,1,0)
	Response.Write(sSQL1)

			 
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">


<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-12">
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Cita en agenda</h5>  
                </div>

                <div style="overflow-y: auto; min-height:655px; width: auto;">
           
                    <div class="ibox-content" id="<%=IR_Folio%>">
                         <h4>
                            <% if(CLIENTE == "" ){ %>
                                  Proveedor: <%=Prov_Nombre%>
                            <% } else { %>
                                  Cliente: <%=CLIENTE%>
                            <% } %>
                         </h4>
                         <%
						     if(IR_EsPorASN == 1) {
						  %>
                  		<h4>
                          ASN: <%=rsASN.Fields.Item("ASN_FolioCliente").Value%>
                          </h4>
						<h4>
                          O.C.: <%=rsArt.Fields.Item("CliOC_NumeroOrdenCompra").Value%>

                        </h4>
                          	<%
							 }
						     if(TA_ID > -1) {
						  %>
                          <h4>
                          Transferencia: <%=rsArt.Fields.Item("TA_Folio").Value%>
                          </h4>
                          	<%
							 }
						   if(OC_ID > -1) {
						  %>
                        <h4>
                          Orden de compra: <%=rsArt.Fields.Item("OC_Folio").Value%>
                          </h4>	
							<%
							 }
							 %>
                         <h4  title="IR_ID = <%=IR_ID%>">
                            Folio: <%=IR_Folio%>
                         </h4>
                         <h4>
                            Fecha de recepci&oacute;n: <%=IR_FechaEntrega%>
                         </h4>
                         <h4>
                           Conductor: <%=CONDUCTOR%>
                         </h4>
                         <h4>
                           Veh&iacute;culo: <%=VEHICULO%>
                         </h4>
                         <h4>
                           Placas: <%=PLACAS%>
                         </h4>
                        <div >
                            <table class="table shoping-cart-table table-striped table-hover">
                                <tbody style="padding: 0px !Important;">
                                    <tr>
                                        <th width="5%"><h3>Num</h3></th>
                                        <th width="15%"><h3>SKU</h3></th>
                                        <th width="10%"><h3>Cantidad</h3></th>
                                        <th width="40%"><h3>Producto</h3></th>
                                       <th width="10%"><h3>Pallets</h3></th>
                                        <th width="10%"><h3>Escaneados</h3></th>
                                        <th width="10%"><h3>Esperados</h3></th>
            
                                    </tr>
<%                                     
                                    var Cuenta = 0
                                    var Suma = 0

                                    var rsArt = AbreTabla(sSQL1,1,0)
                                    while(!rsArt.EOF){
						             sSQL = "SELECT count(*)  AS Pallets, Pt_Cantidad FROM Recepcion_Pallet WHERE IR_ID =" + IR_ID + " AND Pt_SKU = '"+rsArt.Fields.Item("Pro_SKU").Value+"'"
                               			+	" group by Pt_Cantidad"
							        var rsPallets = AbreTabla(sSQL,1,0)
						             sSQL = "SELECT count(*)  AS Series FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p "
									 			+ " ON s.Pt_ID=p.Pt_ID WHERE p.IR_ID =" + IR_ID + " AND p.Pt_SKU = '"+rsArt.Fields.Item("Pro_SKU").Value+"'"
                                    var rsSeries = AbreTabla(sSQL,1,0)
										
                                        Cantidad = rsArt.Fields.Item("Solicitados").Value 
                                        Cuenta++
                                        Suma = Suma + Cantidad
%>
                                    <tr>
                                        <td class= "desc">	
                                            <%=Cuenta%>
                                        </td>
                                        <td class= "desc">	
                                            <%=rsArt.Fields.Item("Pro_SKU").Value%>
                                        </td>
                                        <td class= "desc">
                                            <%=formato(Cantidad,0)%>
                                        </td>                                        
                                        <td class= "desc">
                                            <%=rsArt.Fields.Item("Pro_Nombre").Value%>
                                        </td>
                                        <td class= "desc">
                                        <%
										if(!rsPallets.EOF){
										%>
                                            <%=rsPallets.Fields.Item("Pallets").Value%>
                                        <%
										}else{
										%>
                                        0
                                        <%
										}
										%>
                                        </td>
                                        <td class= "desc">
                                             <%
										if(!rsSeries.EOF){
										%>
                                            <%=rsSeries.Fields.Item("Series").Value%>
                                        </td>
                                        <%
										}else{
										%>
                                        0
                                        <%
										}
										%>
                                        <td class= "desc">
                                             <%
										if(!rsPallets.EOF){
										%>
                                            <%=rsPallets.Fields.Item("Pt_Cantidad").Value%>
                                       <%
										}
										%>
                                        </td>

                                    </tr>
<%	
                                        rsArt.MoveNext() 
                                    }
                                    rsArt.Close()   
%>
                                    <tr>
                                        <td class= "desc">	
                                            Art&iacute;culos
                                        </td>
                                        <td class= "desc">
                                            <%=formato(Suma,0)%>
                                        </td>                                        
                                        <td class= "desc">&nbsp;</td>
                                        <td class= "desc">&nbsp;</td>   
                                        
                                    </tr>
                                    
                                </tbody>
                            </table>
                        </div>
                        <div class="ibox-content">
                            <div class="form-group">
                                <div style="width:auto">
                                      <input class="form-control agenda" id="Observaciones" placeholder="Observaciones" 
                                             type="text" autocomplete="off" value=""></input>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    
                                    <div class="col-md-12 ">
                                        <button type="button" class="btn btn-primary" id="BtnDCompleta">Descarga Completa</button>
                                        <button type="button" class="btn btn-danger" id="BtnDIncompleta">Descarga Incompleta</button>
                                        <button type="button" class="btn btn-danger" id="BtnMDanada">Mercancia da&ntilde;ada</button>
                                    </div>
                                    <p>&nbsp;</p>
                                    <div class="ibox-content">
                                        <div class="form-group">
                                            <div class="col-md-10">
                                                <a class="text-muted btnClasificar"><i class="fa fa-inbox"></i>&nbsp;<strong>Clasificar pallets</strong></a>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <a class="text-muted btnEscanear"><i class="fa fa-inbox"></i>&nbsp;<strong>Escanear</strong></a>  
                                            </div>
                                            <div id = "dvCita"></div>
                                        </div>    
                                    </div> 
                              </div>                
                          </div>
                        </div>
                    </div>
				</div>
            </div>
        </div>
    </div>
</div>

        
<script type="text/javascript">
    var Params = <%=keys%>
		Params['CliEnt_ID'] = <%=CliEnt_ID%>

	
$(document).ready(function () {


	$('.btnClasificar').click(function (e) {
		e.preventDefault()
		if (Params.IDUsuario == 36) {
			$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp", Params)
		} else {
			$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp", Params)
		}
	});


	$('#BtnDCompleta').click(function (e) {
		Params.Tarea = 1
		Params['Observaciones'] = $('#Observaciones').val()

		$("#dvCita").load("/pz/wms/OC/ROC_Recepciones_Ajax.asp", Params, function (data) {
			sTipo = "info";
			sMensaje = "El estatus se ha actualizado correctamente ";
			Avisa(sTipo, "Aviso", sMensaje);
			//$("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp")
		});
	});


	$('.btnEscanear').click(function (e) {
		e.preventDefault()
		Params['VI'] = $("#VentanaIndex").val()
		console.log(Params)

//		var Params = "?TA_ID=" + $(this).data("taid")
//			Params += "&IR_ID=" + $(this).data("irid")
//			Params += "&CliOC_ID=" + $(this).data("cliocid")
//			Params += "&Cli_ID=" + $(this).data("cliid") 
//			Params += "&OC_ID=" + $(this).data("ocid")
//			Params += "&Prov_ID=" + $(this).data("provid") 
//			Params += "&Pro_ID=" + $(this).data("proid")
//			Params += "&Usu_ID=" + $("#IDUsuario").val()
//			Params += "&VI=" + $("#VentanaIndex").val()

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp", Params)

	});


	$('#BtnDIncompleta').click(function (e) {
		Params.Tarea = 2
		Params['Observaciones'] = $('#Observaciones').val()

//		var datos = {
//			Tarea: 2,
//			CliOC_ID: $(this).data("cliocid"),
//			Cli_ID: $(this).data("cliid"),
//			Prov_ID: $(this).data("provid"),
//			OC_ID: $(this).data("ocid"),
//			TA_ID: $(this).data("taid"),
//			IR_ID: $(this).data("irid"),
//			CliEnt_ID: <%=CliEnt_ID%> ,
//			Usu_ID: <%=IDUsuario %> ,
//			Observaciones: $('#Observaciones').val()
//		}

		$("#dvCita").load("/pz/wms/OC/ROC_Recepciones_Ajax.asp", Params, function (data) {
			sTipo = "info";
			sMensaje = "El estatus se ha actualizado correctamente ";
			Avisa(sTipo, "Aviso", sMensaje);
		});
	});

	$('#BtnMDanada').click(function (e) {
		Params.Tarea = 3
		Params['Observaciones'] = $('#Observaciones').val()
//		var datos = {
//			Tarea: 3,
//			CliOC_ID: $(this).data("cliocid"),
//			Cli_ID: $(this).data("cliid"),
//			Prov_ID: $(this).data("provid"),
//			OC_ID: $(this).data("ocid"),
//			TA_ID: $(this).data("taid"),
//			IR_ID: $(this).data("irid"),
//			CliEnt_ID: < %= CliEnt_ID % > ,
//			Usu_ID: < %= IDUsuario % > ,
//			Observaciones: $('#Observaciones').val()
//		}
		$("#dvCita").load("/pz/wms/OC/ROC_Recepciones_Ajax.asp", datos, function (data) {
			sTipo = "info";
			sMensaje = "El estatus se ha actualizado correctamente ";
			Avisa(sTipo, "Aviso", sMensaje);
		});
	});


});
		  
</script>
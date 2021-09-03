<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
    var IR_ID = Parametro("IR_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var IDUsuario =  Parametro("Usu_ID",-1)	

    var sSQL1  = ""
    var IR_Folio = ""
    var Cli_Nombre = ""
    var Prov_Nombre = ""
    var IR_FechaEntrega = ""	
    var IR_Conductor = ""
    var IR_DescripcionVehiculo = ""
    var IR_Placas = ""
    var Pro_Nombre = ""
    var Cantidad = ""
    var Pro_SKU = ""


	//Response.Write(CliEnt_ID)
    var sCondicion = "IR_ID = " + IR_ID
    var CliEnt_ID = BuscaSoloUnDato("CliEnt_ID","Cliente_OrdenCompra_Entrega",sCondicion,-1,0) 
    var IR_EsPorASN = BuscaSoloUnDato("IR_EsPorASN","Inventario_Recepcion",sCondicion,-1,0) 

    if(CliOC_ID > -1){
        sSQL1  = "select * "
        sSQL1 += " from Cliente_OrdenCompra "
        sSQL1 += " where Cli_ID = " + Cli_ID
        sSQL1 += " AND CliOC_ID = " + CliOC_ID

    } 
//        
//    if(TA_ID > -1){
//        sSQL1  = "select * "
//        sSQL1 += " from TransferenciaAlmacen "
//        sSQL1 += " where TA_ID = " + TA_ID
//    }
//        
//    if(OC_ID > -1){
//        sSQL1  = "select * "
//        sSQL1 += " from TransferenciaAlmacen "
//        sSQL1 += " where TA_ID = " + TA_ID
//    }
//   
		
	//if(CliOC_ID > -1){
   	    var sSQL1  = "SELECT "
                   + "  Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina, IR_FechaElaboracion, IR_AlmacenRecepcion "
                   + ", IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente, Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta "
                   + ", IR_Conductor, IR_Placas, IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre "
                   + ", Producto.Pro_SKU, SUM(Cliente_OrdenCompra_EntregaProducto.CliEnt_ArticulosRecibidos) AS CliEnt_ArticulosRecibidos  "
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
        if(IR_EsPorASN = 0){
             sSQL1 +=       " AND Cliente_OrdenCompra_Entrega.CliOC_ID = Inventario_Recepcion.CliOC_ID "  
        }
             sSQL1 += "INNER JOIN Cliente c "
                   +         " ON Inventario_Recepcion.Cli_ID = c.Cli_ID "
                   + " WHERE Inventario_Recepcion.IR_ID = " + IR_ID 
                   +   " AND Inventario_Recepcion.Cli_ID = " + Cli_ID  
        if(IR_EsPorASN = 0){
             sSQL1 +=  " AND Inventario_Recepcion.CliOC_ID = " + CliOC_ID 
                   +  " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = " + CliEnt_ID
        }
             sSQL1 += " GROUP BY "
                   +            "  Producto.Pro_SKU, Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina "
                   +            ", IR_FechaElaboracion, IR_AlmacenRecepcion, IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente "
                   +            ", Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta, IR_Conductor, IR_Placas "
                   +            ", IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre, Producto.Pro_SKU "

	//	}
		 if(TA_ID > -1){
             var sSQL1  = "select r.*, c.Cli_Nombre, p.Pro_Nombre, p.Pro_SKU, a.TAA_Cantidad from inventario_recepcion r "
                 sSQL1 += " inner join cliente c on r.Cli_ID=c.Cli_ID "
                 sSQL1 += " inner join TransferenciaAlmacen t  on  t.TA_ID = r.TA_ID "
                 sSQL1 += " inner join TransferenciaAlmacen_Articulos a  on t.TA_ID = a.TA_ID "
                 sSQL1 += " inner join Producto p  on a.Pro_ID = p.Pro_ID where r.TA_ID = " + TA_ID 
                 sSQL1 += " and r.IR_ID = " + IR_ID
		 
		 }
		 if(OC_ID > -1){
             var sSQL1  = "select  IR_Folio, IR_FechaEntrega, IR_Conductor, IR_DescripcionVehiculo, IR_Placas, c.Prov_Nombre "
                 sSQL1 += " , p.Pro_Nombre, p.Pro_SKU, a.OCP_Cantidad from inventario_recepcion r "
                 sSQL1 += " inner join proveedor c on r.Prov_ID=c.Prov_ID "
                 sSQL1 += " inner join Proveedor_OrdenCompra o  on  o.OC_ID = r.OC_ID "
                 sSQL1 += " inner join  Proveedor_OrdenCompra_Articulos a  on o.OC_ID = a.OC_ID "
                 sSQL1 += " inner join  Producto p  on a.Pro_ID = p.Pro_ID  where  a.OC_ID = " + OC_ID + " and a.Prov_ID = " + Prov_ID
                 sSQL1 += " GROUP BY IR_Folio, IR_FechaEntrega, IR_Conductor, IR_DescripcionVehiculo"
                 sSQL1 +=        " , IR_Placas, c.Prov_Nombre,  p.Pro_Nombre, p.Pro_SKU, a.OCP_Cantidad "
		 
 
         }
         
   //  Response.Write(sSQL1)
   //	 Response.End()
    var rsTP = AbreTabla(sSQL1,1,0)
	if (!rsTP.EOF){
         IR_Folio  = rsTP.Fields.Item("IR_Folio").Value
		 if(OC_ID>-1){
		      Prov_Nombre  = rsTP.Fields.Item("Prov_Nombre").Value
		 } else {
		      Cli_Nombre  = rsTP.Fields.Item("Cli_Nombre").Value
		 }
         IR_FechaEntrega = rsTP.Fields.Item("IR_FechaEntrega").Value
		 IR_Conductor =  rsTP.Fields.Item("IR_Conductor").Value
		 IR_DescripcionVehiculo =  rsTP.Fields.Item("IR_DescripcionVehiculo").Value
		 IR_Placas = rsTP.Fields.Item("IR_Placas").Value
   }             
             
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<style>
    
    .opciones{
        margin-left: 20px;	
    }
    
</style>

<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Cita en agenda</h5>  
                </div>
                <div style="overflow-y: auto; min-height:655px; width: auto;">
           
                    <div class="ibox-content" id="<%=IR_Folio%>">
                         <h4>
                            <% if(OC_ID>-1){ %>
                                  Proveedor: <%=Prov_Nombre%>
                            <% } else { %>
                                  Cliente: <%=Cli_Nombre%>
                            <% } %>
                         </h4>
                         <h4>
                            Folio: <%=IR_Folio%>
                         </h4>
                         <h4>
                            Fecha de recepci&oacute;n: <%=IR_FechaEntrega%>
                         </h4>
                         <h4>
                           Conductor: <%=IR_Conductor%>
                         </h4>
                         <h4>
                           Vehiculo: <%=IR_DescripcionVehiculo%>
                         </h4>
                         <h4>
                           Placas: <%=IR_Placas%>
                         </h4>
                        <div >
                            <table class="table shoping-cart-table table-striped table-hover">
                                <tbody style="padding: 0px !Important;">
                                    <tr>
                                        <th width="5%"><h3>Num</h3></th>
                                        <th width="15%"><h3>SKU</h3></th>
                                        <th width="10%"><h3>Cantidad</h3></th>
                                        <th width="70%"><h3>Producto</h3></th>
                                        
                                    </tr>
<%                                     
                                    var Cuenta = 0
                                    var Suma = 0
                                    var rsArt = AbreTabla(sSQL1,1,0)
                                    while(!rsArt.EOF){
                                         if(CliOC_ID > -1){
                                            Cantidad = rsArt.Fields.Item("CliEnt_ArticulosRecibidos").Value 
                                         } else if(TA_ID > -1){
                                            Cantidad = rsArt.Fields.Item("TAA_Cantidad").Value 
                                         } else if(OC_ID > -1){
                                            Cantidad = rsArt.Fields.Item("OCP_Cantidad").Value 
                                         }
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
                                        <td class= "desc">&nbsp;
                                           
                                        </td>
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
                                        <button type="button" class="btn btn-primary" id="BtnDCompleta" data-cliid= "<%=Cli_ID%>"  
                                                data-provid= "<%=Prov_ID%>" data-irid="<%=IR_ID%>" data-ocid= "<%=OC_ID%>" 
                                                data-cliocid= "<%=CliOC_ID%>" data-taid= "<%=TA_ID%>">Descarga Completa</button>
                                        <button type="button" class="btn btn-danger" id="BtnDIncompleta" data-cliid= "<%=Cli_ID%>"  
                                                data-provid= "<%=Prov_ID%>" data-irid="<%=IR_ID%>" data-ocid= "<%=OC_ID%>" 
                                                data-cliocid= "<%=CliOC_ID%>" data-taid= "<%=TA_ID%>">Descarga Incompleta</button>
                                        <button type="button" class="btn btn-danger" id="BtnMDañada" data-cliid= "<%=Cli_ID%>"  
                                                data-provid= "<%=Prov_ID%>" data-irid="<%=IR_ID%>" data-ocid= "<%=OC_ID%>" 
                                                data-cliocid= "<%=CliOC_ID%>" data-taid= "<%=TA_ID%>">Mercancia da&ntilde;ada</button>

                                    </div>
                                    <p>&nbsp;</p>
                                    <div class="ibox-content">
                                        <div class="form-group">
                                            <div class="col-md-10">
                                                <a data-taid="<%=TA_ID%>"  data-ocid= "<%=OC_ID%>"  data-provid= "<%=Prov_ID%>" 
                                                   data-cliocid= "<%=CliOC_ID%>" data-cliid= "<%=Cli_ID%>"   data-irid= "<%=IR_ID%>" 
                                                   class="text-muted btnClasificar">
                                                <i class="fa fa-inbox"></i>&nbsp;<strong>Clasificar pallets</strong></a>          
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
    
    $(document).ready(function() {
        
        
        $('.btnClasificar').click(function(e) {
		    e.preventDefault()
		
		    var Params = "?CliOC_ID=" + $(this).data("cliocid")
                Params += "&TA_ID=" + $(this).data("taid")   
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + <%=Prov_ID%>
                Params += "&Cli_ID=" + <%=Cli_ID%>
                Params += "&IR_ID=" + $(this).data("irid") 
                Params += "&CliEnt_ID=" +<%=CliEnt_ID%>
                Params += "&IDUsuario="+<%=IDUsuario%>
                    
		    $("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp" + Params)
        });
        

        $('#BtnDCompleta').click(function(e) {
            var datos = {   Tarea:1,
                            CliOC_ID:$(this).data("cliocid"),
                            Cli_ID:$(this).data("cliid"),
                            Prov_ID:$(this).data("provid"),
                            OC_ID:$(this).data("ocid"),
                            TA_ID:$(this).data("taid"),
                            IR_ID:$(this).data("irid"),
                            CliEnt_ID:<%=CliEnt_ID%>,
                            Usu_ID:<%=IDUsuario%>,
                            Observaciones:$('#Observaciones').val()
                       }

            $("#dvCita").load("/pz/wms/OC/ROC_Recepciones_Ajax.asp",datos
                            , function(data){
                                    sTipo = "info";
                                    sMensaje = "El estatus se ha actualizado correctamente ";
                                    Avisa(sTipo,"Aviso",sMensaje);
                                    $("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp")
                            });
         });
 

          $('#BtnDIncompleta').click(function(e) {
                var datos = {   Tarea:2,
                                CliOC_ID:$(this).data("cliocid"),
                                Cli_ID:$(this).data("cliid"),
                                Prov_ID:$(this).data("provid"),
                                OC_ID:$(this).data("ocid"),
                                TA_ID:$(this).data("taid"),
                                IR_ID:$(this).data("irid"),
                                CliEnt_ID:<%=CliEnt_ID%>,
                                Usu_ID:<%=IDUsuario%>,
                                Observaciones:$('#Observaciones').val()
                            }
               $("#dvCita").load("/pz/wms/OC/ROC_Recepciones_Ajax.asp",datos
                            , function(data){
                                    sTipo = "info";
                                    sMensaje = "El estatus se ha actualizado correctamente ";
                                    Avisa(sTipo,"Aviso",sMensaje);	
                            });
          });

        $('#BtnMDañada').click(function(e) {
            var datos = {   Tarea:3,
                            CliOC_ID:$(this).data("cliocid"),
                            Cli_ID:$(this).data("cliid"),
                            Prov_ID:$(this).data("provid"),
                            OC_ID:$(this).data("ocid"),
                            TA_ID:$(this).data("taid"),
                            IR_ID:$(this).data("irid"),
                            CliEnt_ID:<%=CliEnt_ID%>,
                            Usu_ID:<%=IDUsuario%>,
                            Observaciones:$('#Observaciones').val()
                        }
        $("#dvCita").load("/pz/wms/OC/ROC_Recepciones_Ajax.asp",datos
                        , function(data){
                                sTipo = "info";
                                sMensaje = "El estatus se ha actualizado correctamente ";
                                Avisa(sTipo,"Aviso",sMensaje);
                        });
      });  
        
        
     });
    

    
	<%/*%>	var Paramts = "IDUnica=" + $("#IDUsuario").val()
	    Paramts += "&<%=For_Parametros%>"

$(document).ready(function() {
		
		
      $('.collapse-link').on('click', function () {
            var ibox = $(this).closest('div.ibox-title');
            var button = $(this).find('i');

            var content = ibox.children('.ibox-content');
            content.slideToggle(200);
            button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
            ibox.toggleClass('').toggleClass('border-bottom');
            setTimeout(function () {
                ibox.resize();
                ibox.find('[id^=map-]').resize();
            }, 50);
        });


        $('.help-link').on('click', function () {
            console.log("help")
        });

        $('.Coments-link').on('click', function () {
            console.log("Comentarios")
        });	
		
		
		
<%	if(For_Archivo != ""){ %>

		$('#dvFor_Archivo').load('<%=For_Archivo%>?' + Paramts);
<%	} %>
		
		BPM_CargaBotonesYEstatus()
	});
	
	function EstadoBoton(Visible) {
		if( Visible == 1 ) {
			$("#btnGuardar").show("slow") 
		} else {
			$("#btnGuardar").hide("slow")		
		}
	}
	
	function BPM_CargaBotonesYEstatus(){
		$("#BPMBotones").load("/pz/wms/BPM/BPM_Botones_TA.asp?" + Paramts);
	}<%*/%>

</script>

<%/*%><%	if(For_ArchivoJS != ""){  
		Response.Write("<script src='" + For_ArchivoJS + "'></script>")
 	}
%><%*/%>
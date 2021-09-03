<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-9">
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="modal-body">
                            <div class="form-horizontal">
                 
                <div style="overflow-y: scroll; height:655px; width: 200;" >
                <%
var Pt_ID = Parametro("Pt_ID",-1)
var MB = Parametro("MB", -1)
var Tarea =  Parametro("Tarea",-1)	
var IR_ID = -1
var IR_Folio =  Parametro("IR_Folio","")	
var ASN_Folio =  Parametro("ASN_Folio","")	
var Pt_SKU =  Parametro("Pt_SKU","")	
var Cli_ID =  Parametro("Cli_ID",-1)	
var FechaEntrega =  Parametro("Fecha","")	
var Estatus =  Parametro("Estatus",-1)	

   var f = new Date();			
    var dia=f.getDate()
    var mes=f.getMonth()
   
    if(dia<10){
        //dia = dia +1
        dia = "0" + dia	
    }
    mes = mes + 1
    if(mes<10){   
        mes = "0" + mes	
    }
                
    f2 = f.getFullYear() + "-" + mes + "-" + dia           
    f =( f.getFullYear() + "-" + mes + "-" + dia  ); 

     

var sSQL = "SELECT top(40) s.IR_ID, s.IR_Folio, s.CliOC_ID, s.Cli_ID, s.OC_ID, s.Prov_ID "
         + " FROM Inventario_Recepcion s  "
         + " INNER JOIN Recepcion_Pallet p "
         + " ON p.IR_ID= s.IR_ID "
		 + " INNER JOIN Cliente_OrdenCompra_Entrega e "
		 + " ON e.IR_ID=s.IR_ID"
		 + " LEFT JOIN ASN a"
		 + " ON a.ASN_ID=e.ASN_ID"		 
         + " LEFT JOIN Recepcion_Series r "
         + " ON r.Pt_ID=p.Pt_ID "
         + " WHERE IR_EstatusCG52 <> 18 "
                   
    if(IR_Folio != ""){
        sSQL += " AND IR_Folio like '%" + IR_Folio +"'"	
    }
    if(Cli_ID >-1){
        sSQL += " AND s.Cli_ID =" + Cli_ID 
    }

    if(ASN_Folio != ""){
        sSQL += " AND a.ASN_Folio like '%" + ASN_Folio +"'"	
    }
	 if(Pt_SKU != ""){
        sSQL += " AND p.Pt_SKU ='" + Pt_SKU +"'"	
    }
  	if(FechaEntrega != ""){
         sSQL += "AND cast (IR_FechaEntrega as date)  = '"+ FechaEntrega + "'"
    }
	if(Estatus>-1){
         sSQL += "OR IR_EstatusCG52  = "+  Estatus
    }
	    sSQL += " group by s.IR_ID,  s.IR_Folio, s.CliOC_ID, s.Cli_ID, s.OC_ID, s.Prov_ID "
    		     +  " order by s.IR_ID DESC"
                   
    Response.Write(sSQL)
    var rsOrdenes = AbreTabla(sSQL,1,0)

    while (!rsOrdenes.EOF){
                 IR_ID = rsOrdenes.Fields.Item("IR_ID").Value
                 Cli_ID = rsOrdenes.Fields.Item("Cli_ID").Value
                 CliOC_ID = rsOrdenes.Fields.Item("CliOC_ID").Value
                 OC_ID = rsOrdenes.Fields.Item("OC_ID").Value
                 Prov_ID = rsOrdenes.Fields.Item("Prov_ID").Value

 var Serializado = 0
					 
 sSQL = "SELECT s.Pt_ID, p.Pt_LPN, p.Pro_ID, p.Pt_Incidencia "
      +  " FROM Recepcion_Series s "
      + " INNER JOIN Recepcion_Pallet p "
         + " ON p.Pt_ID=s.Pt_ID "
      + " WHERE s.Ser_SerieEscaneada = 1 "
      +   " AND p.IR_ID = " + IR_ID 
      + " group by s.Pt_ID, p.Pt_LPN, p.Pro_ID, p.Pt_Incidencia "
                
 var rsLinea1 = AbreTabla(sSQL,1,0)
 if(!rsLinea1.EOF){
	  Serializado = 1
 } else {
	  Serializado = 0
	  sSQL = "SELECT p.Pt_ID, p.Pt_LPN, p.Pro_ID, p.Pt_Incidencia FROM Recepcion_Pallet p WHERE  p.IR_ID = "+ IR_ID 
      rsLinea1 = AbreTabla(sSQL,1,0)
 }
     
//sSQL = "SELECT s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 2 AND Pt_PalletEscaneado = 1 AND s.Ser_SerieEscaneada = 1 AND p.IR_ID = "+ IR_ID +" group by  s.Pt_ID, s.Ser_Pallet, p.Pt_Incidencia"
// var rsLinea2 = AbreTabla(sSQL,1,0)
// sSQL = "SELECT s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 3 AND Pt_PalletEscaneado = 1 AND s.Ser_SerieEscaneada = 1 AND p.IR_ID = "+ IR_ID +" group by  s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia "
// var rsLinea3 = AbreTabla(sSQL,1,0)
// sSQL = "SELECT s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 4 AND Pt_PalletEscaneado = 1 AND s.Ser_SerieEscaneada = 1 AND p.IR_ID = "+ IR_ID +" group by  s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia "
// var rsLinea4 = AbreTabla(sSQL,1,0)
// sSQL = "SELECT s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 5 AND Pt_PalletEscaneado = 1 AND s.Ser_SerieEscaneada = 1 AND p.IR_ID = "+ IR_ID +" group by  s.Pt_ID, s.Ser_Pallet,  p.Pt_Incidencia "
// var rsLinea5 = AbreTabla(sSQL,1,0)
 
			
                %>
                    <div class="ibox-content">
                        <div class="table-responsive">
                         <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td class="desc">
                                       
                                      <h3>Folio</h3>
   										<h3 class="text-navy">  
                                      
                                             <%=rsOrdenes.Fields.Item("IR_Folio").Value%>
                                         
                                        </h3>
                          
                                        <%
if(OC_ID > -1){
    var sSQL = "SELECT  sum(r.OCP_Cantidad) as ArticulosRecibidos FROM  Producto_Proveedor c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Proveedor_OrdenCompra_Articulos r ON p.Pro_ID = r.Pro_ID   "
    sSQL += "WHERE  r.Prov_ID = "+Prov_ID+" AND r.OC_ID = "+OC_ID

        sSQLTr = "SELECT COUNT(*) as escaneadas FROM Recepcion_Series WHERE Ser_SerieEscaneada = 1 AND Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID
        var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
        if(!rsEscaneadas.EOF){
                var escaneadas =  rsEscaneadas.Fields.Item("escaneadas").Value
        }else{
        var escaneadas = 0	
        }
} else {
    var sSQL = "SELECT   sum(r.CliEnt_ArticulosRecibidos) as ArticulosRecibidos FROM Cliente_OrdenCompra_EntregaProducto r  "
    sSQL += " INNER JOIN Producto p ON p.Pro_ID = r.Pro_ID INNER JOIN  Cliente_OrdenCompra_Entrega e ON  e.CliOC_ID=r.CliOC_ID AND e.Cli_ID = r.Cli_ID AND e.CliEnt_ID = r.CliEnt_ID WHERE e.IR_ID = "+IR_ID

        sSQLTr = "SELECT COUNT(*) as escaneadas FROM Recepcion_Series  s, Recepcion_Pallet p WHERE s.Pt_ID=p.Pt_ID AND p.IR_ID = "+IR_ID

        var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
        if(!rsEscaneadas.EOF){
                var escaneadas =  rsEscaneadas.Fields.Item("escaneadas").Value
        } else {
        var escaneadas = 0	
        }
}


var rsActivos = AbreTabla(sSQL,1,0)

  	var sSQLTr  = "SELECT count(*) as pallet FROM Recepcion_Pallet WHERE IR_ID = "+IR_ID
/*%>if(CliOC_ID > -1){
	 sSQLTr += "Cli_ID = "+Cli_ID+" AND CliOC_ID = "+CliOC_ID
}if(OC_ID > -1){
	sSQLTr += "Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID
}<%*/
	 var rsPallet = AbreTabla(sSQLTr,1,0)
	 
	var sSQLTr  = "SELECT count(*) as pallet FROM Recepcion_Pallet WHERE Pt_PalletEscaneado = 1 AND IR_ID = "+IR_ID
/*%>if(CliOC_ID > -1){
	 sSQLTr += "Pt_PalletEscaneado = 1 AND Cli_ID = "+Cli_ID+" AND CliOC_ID = "+CliOC_ID
}if(OC_ID > -1){
	 sSQLTr += "Pt_PalletEscaneado = 1 AND Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID
}<%*/
 var rsPalletE = AbreTabla(sSQLTr,1,0)

 sSQLTr  = "SELECT Cat_Nombre FROM Inventario_Recepcion r INNER JOIN Cat_Catalogo c ON c.Sec_ID=52 WHERE Cat_ID = IR_EstatusCG52 AND  IR_ID = "+IR_ID
/*%>}if(OC_ID > -1){
		 sSQLTr += " Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID+" AND  IR_ID = "+IR_ID
}<%*/
var rsEstatus =  AbreTabla(sSQLTr,1,0)
 if (rsPallet.EOF==false){
				    var PalletsTotales= rsPallet.Fields.Item("pallet").Value
					 }else{
	 				 var PalletsTotales=0
					 }
 				 if (rsPalletE.EOF==false){
					   	 var PalletsEscaneados= rsPalletE.Fields.Item("pallet").Value
				 }else{
					 	 var PalletsEscaneados=""
				 }
					  if(rsActivos.EOF==false){
						  if(rsEscaneadas.EOF==false){
					var Cantidad_Art=rsActivos.Fields.Item("ArticulosRecibidos").Value	- escaneadas
						  }else{
						var Cantidad_Art=rsActivos.Fields.Item("ArticulosRecibidos").Value	
 					}
					  }else{
						var Cantidad_Art=0
					}
					  if (rsEscaneadas.EOF==false){
					var Art_Escan=rsEscaneadas.Fields.Item("escaneadas").Value
						  }else{
						var rsEscaneadas=""
					}
					  if (rsEstatus.EOF==false){
					var Estatus=rsEstatus.Fields.Item("Cat_Nombre").Value
					  }else{
						var rsEstatus=""
					}
						%> 
								   </td>
                                    <td class="desc">
                                    Estatus actual <br />
                                    <strong><%=Estatus%></strong>	
                                    </td>
                                    <td class="desc">
                                 	Articulos pendientes<br />
                                     <%=Cantidad_Art%>
                                        
                                    </td>
                                      <td class="desc">
                                 Articulos escaneados<br />
                                     <%=Art_Escan%>
                                         
                                    </td>
                                      <td class="desc">
                                 Pallets clasificados<br />
                                  
									<%=PalletsTotales%>
                                         
                                    </td>
                                    <td class="desc">
                                  Pallets escaneados<br />
                                  <%=PalletsEscaneados%>
                                         
                                    </td>
                                    <td>
                                    
                                 <input type="button" value="Ingresar"  id="btnIngresar"  data-irid="<%=IR_ID%>" class="btn btn-info btnIngresar"/>
<!--                                <button type="button"  class="btn btn-success"  onclick="javascript:ExportaExcel(<%=IR_ID%>)" data-folio="<%=rsOrdenes.Fields.Item("IR_Folio").Value%>">Reporte series</button><br /><br />
-->
                                    </td>
                                    <input type="hidden" id="Limiteishon" value=""/>
                                   
                                </tr>
                                </tbody>
                            </table>
                           
                            <table class="table shoping-cart-table">
                               <thead>
    <th>Pallet</th>

  
    	    </thead>
                                <tbody>
                                <tr>
                                    <td class="desc">
                                        <%
										 var Ser_Pallet = 0
							 while (!rsLinea1.EOF){     
							var Pt_ID = rsLinea1.Fields.Item("Pt_ID").Value
							var Pt_LPN = rsLinea1.Fields.Item("Pt_LPN").Value
							var Pt_Incidencia = rsLinea1.Fields.Item("Pt_Incidencia").Value
                        	 var Pro_ID =  rsLinea1.Fields.Item("Pro_ID").Value
							if(Serializado == 1){
//								sSQL = "UPDATE Producto SET Pro_EsSerializado = 1 WHERE Pro_ID="+ Pro_ID
//					//			Response.Write(sSQL)
//								
//								Ejecuta(sSQL, 0)
//								
							} else {
//								sSQL = "UPDATE Producto SET Pro_EsSerializado = 0 WHERE Pro_ID="+ Pro_ID
//							//	Response.Write(sSQL)
//								Ejecuta(sSQL, 0)
							}
							if(Pt_Incidencia == 0){
									%>		
                                    
    <button type="button"  class="btn btn-primary" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-irid= "<%=IR_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=IR_ID%>)"><%=Pt_LPN%></button>
                                    <%	}else{
										%>
<button type="button"  class="btn btn-danger" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>" data-irid= "<%=IR_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=IR_ID%>)"><%=Pt_LPN%></button>
		
                                        <%
									}
                                    rsLinea1.MoveNext() 
                                    }
                                    rsLinea1.Close()   
                                    %>
                                 </td>
                               <%/*%>     <td class="desc">
                                
                                    <%
							 while (!rsLinea2.EOF){   
 							var Pt_ID = rsLinea2.Fields.Item("Pt_ID").Value
							var Ser_Pallet = rsLinea2.Fields.Item("Ser_Pallet").Value
							var Pt_Incidencia = rsLinea2.Fields.Item("Pt_Incidencia").Value
							
                    	 if(Pt_Incidencia == 0){
									%>		
                                    
    <button type="button"  class="btn btn-primary" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-cliocid= "<%=CliOC_ID%>" data-ocid= "<%=OC_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=CliOC_ID%>, <%=OC_ID%>)"><%=Ser_Pallet%></button>
                                    <%	}else{
										%>
<button type="button"  class="btn btn-danger" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-cliocid= "<%=CliOC_ID%>" data-ocid= "<%=OC_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=CliOC_ID%>, <%=OC_ID%>)"><%=Ser_Pallet%></button>
		
                                        <%
									}
                                    rsLinea2.MoveNext() 
                                    }
                                    rsLinea2.Close()   
                                    %>
                                    </td>
                                <td class="desc">
                                
                                    <%
							 while (!rsLinea3.EOF){   
							var Pt_ID = rsLinea3.Fields.Item("Pt_ID").Value
							var Ser_Pallet = rsLinea3.Fields.Item("Ser_Pallet").Value
  							var Pt_Incidencia = rsLinea3.Fields.Item("Pt_Incidencia").Value
							 if(Pt_Incidencia == 0){
									%>		
                                    
    <button type="button"  class="btn btn-primary" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-cliocid= "<%=CliOC_ID%>" data-ocid= "<%=OC_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=CliOC_ID%>, <%=OC_ID%>)"><%=Ser_Pallet%></button>
                                    <%	}else{
										%>
<button type="button"  class="btn btn-danger" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-cliocid= "<%=CliOC_ID%>" data-ocid= "<%=OC_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=CliOC_ID%>, <%=OC_ID%>)"><%=Ser_Pallet%></button>
		
                                        <%
									}
                                        rsLinea3.MoveNext() 
                                    }
                                    rsLinea3.Close()   
                                    %>
                                    </td>
                                    <td class="desc">
                                
                                    <%
							 while (!rsLinea4.EOF){     
							var Pt_ID = rsLinea4.Fields.Item("Pt_ID").Value
							var Ser_Pallet = rsLinea4.Fields.Item("Ser_Pallet").Value
							var Pt_Incidencia = rsLinea4.Fields.Item("Pt_Incidencia").Value
							
                          	 if(Pt_Incidencia == 0){
									%>		
                                    
    <button type="button"  class="btn btn-primary" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-cliocid= "<%=CliOC_ID%>" data-ocid= "<%=OC_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=CliOC_ID%>, <%=OC_ID%>)"><%=Ser_Pallet%></button>
                                    <%	}else{
										%>
<button type="button"  class="btn btn-danger" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-cliocid= "<%=CliOC_ID%>" data-ocid= "<%=OC_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=CliOC_ID%>, <%=OC_ID%>)"><%=Ser_Pallet%></button>
		
                                        <%
									}
                                    rsLinea4.MoveNext() 
                                    }
                                    rsLinea4.Close()   
                                    %>
                                    </td>
					     <td class="desc">
                                <%
							 while (!rsLinea5.EOF){     
 							var Pt_ID = rsLinea5.Fields.Item("Pt_ID").Value
							var Ser_Pallet = rsLinea5.Fields.Item("Ser_Pallet").Value
							var Pt_Incidencia = rsLinea5.Fields.Item("Pt_Incidencia").Value
								
								 if(Pt_Incidencia == 0){
									%>		
                                    
    <button type="button"  class="btn btn-primary" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>"  data-irid= "<%=IR_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=IR_ID%>)"><%=Ser_Pallet%></button>
                                    <%	}else{
										%>
<button type="button"  class="btn btn-danger" id="BtnPallet<%=Pt_ID%>"  data-ptid="<%=Pt_ID%>" data-irid= "<%=IR_ID%>" onclick="javascript:CargarMB(<%=Pt_ID%>,<%=IR_ID%>)"><%=Ser_Pallet%></button>
		
                                        <%
									}
                                        rsLinea5.MoveNext() 
                                    }
                                    rsLinea5.Close()   
                                    %>
                                    </td>    
                                </tr><%*/%>
                                <tr>
                             
                                </tr>
                                </tbody>
                            </table>
                            
                        </div>
                    </div>
                    <% if(CliOC_ID > -1){ %>
                       <div id="divMB<%=IR_ID%>"></div>
<% 
}else{
	%>
                           <div id="divMB<%=IR_ID%>"></div>
<%
}
%>
                    <%
                    rsOrdenes.MoveNext() 
                    }
                    rsOrdenes.Close()   
                    %>
                </div>
     
            </div>
          
        </div>
          
    </div>    
</div>
</div>
 <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title" id="divSeries">
                 Reportar incidencias con: <br /> Karla Ortega <br />
                 Tel: 55-25-69-60-62
                <br />

                     <div class="input-group date">
                        <input class="form-control Cita agenda"
                        id="InputCita" type="text" autocomplete="off"
                        value="" data-esfecha="1" placeholder="Folio de Cita"> 
                        <input class="form-control ASN agenda"
                        id="InputASN" type="text" autocomplete="off"
                        value="" data-esfecha="1" placeholder="Folio ASN"> 
                        <input class="form-control Cita agenda"
                        id="InputSKU" type="text" autocomplete="off"
                        value="" data-esfecha="1" placeholder="SKU"> 
                        <input class="form-control Fecha agenda"
                        id="InputFecha" placeholder="dd/mm/aaaa" type="text" autocomplete="off"
                        value="" data-esfecha="1"> 
						<%
                            CargaCombo("cbCli_ID","class='form-control cboCli_ID'" 
                            ,"Cli_ID","Cli_Nombre","Cliente","","Cli_Nombre",-1,0,"--Cliente--")
                     
					 		var sEventos = "class='form-control CboEstatus'"
                             ComboSeccion("CboEstatus", sEventos, 52, -1, 0, "--Estatus--", "", "Editar")
                            %>

                        <a href="#" class="btn btn-danger btn-sm Buscar"><i class="fa fa-calendar"></i>&nbsp;&nbsp;Buscar</a>
                
                      </div>
				</div>
                </div>
				</div>
</div>
</div>
</div>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script type="text/javascript">
    
    
    $(document).ready(function(e) {
		
		     $('.Fecha').datepicker({
            todayBtn: "linked", 

            dateFormat: 'dd/mm/yyyy',
            language: "es",
            todayHighlight: true,
            autoclose: true
        });

		
        $('.btnIngresar').click(function(e) {
            e.preventDefault()

            var Params = "?IR_ID=" + $(this).data("irid")
                Params +="&Tarea=" +3

            $("#Contenido").load("/pz/wms/Recepcion/RecepcionSupervisor_Ajax.asp" + Params)
		
		});
        
	});
    
         $('.Buscar').click(function(e) {
            e.preventDefault()

           
            var Params = "?IR_Folio=" + $("#InputCita").val()
             Params += "&ASN_Folio=" + $("#InputASN").val()
             Params += "&Pt_SKU=" + $("#InputSKU").val()
             Params += "&Cli_ID=" + $("#cbCli_ID").val()
             Params += "&Fecha=" + $("#InputFecha").val()
             Params += "&Estatus=" + $("#CboEstatus").val()
            $("#Contenido").load("/pz/wms/Recepcion/RecepcionSupervisor.asp" + Params)
        });

	 function ExportaExcel(irid){

        var IR_ID = irid
        var cita = $(this).data('folio')
        $.post("/pz/wms/Recepcion/RecepcionExcelSeries.asp",{IR_ID:IR_ID}
        , function(data){
            var response = JSON.parse(data)
            var ws = XLSX.utils.json_to_sheet(response);
            var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
            XLSX.writeFile(wb, "Series "+cita+".xlsx");
        });
    }

    function CargarMB(ptid,irid){
	
		var sDatos = "Pt_ID=" + ptid;	 
			   sDatos += "&Tarea=" +1;

		$("#divMB"+irid).load("/pz/wms/Recepcion/RecepcionSupervisor_Ajax.asp?" + sDatos)
	//	$("#divMB"+$(this).data("ocid")).load("/pz/wms/Articulos/Productos/Relacionados_Ajax.asp?" + sDatos)
		
	}
    

</script>            
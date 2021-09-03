<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var TA_ID = Parametro("TA_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Tarea = Parametro("Tarea", -1)
var Pro_PesoBruto = 0
var Pro_PesoBrutoMB = 0
var Pro_PesoBrutoPt = 0
var Pro_PesoNeto = 0
var Pro_PesoNetoMB = 0
var Pro_PesoNetoPt = 0

		if(CliOC_ID > -1){
            var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
                 sSQL1 += " inner join cliente c on p.Cli_ID=c.Cli_ID "
                 sSQL1 += " inner join  Cliente_OrdenCompra_Articulos a  on p.Pro_ID = a.Pro_ID "
                 sSQL1 += " where a.CliOC_ID = " + CliOC_ID 
                 sSQL1 += " GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
            
		    var rsPro = AbreTabla(sSQL1,1,0)
            var rsPro2 = AbreTabla(sSQL1,1,0)

		}
		if(OC_ID > -1){
   	       var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Proveedor p "
               sSQL1 += " inner join proveedor c on p.Prov_ID=c.Prov_ID "
			   sSQL1 += " inner join  Proveedor_OrdenCompra_Articulos a on p.Pro_ID = a.Pro_ID  "
	           sSQL1 += " where a.OC_ID = " + OC_ID 
		       sSQL1 += " GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
            
		    var rsPro = AbreTabla(sSQL1,1,0)
			var rsPro2 = AbreTabla(sSQL1,1,0)
		}
		 if(TA_ID > -1){
		    var sSQL1  = "select p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
                sSQL1 += " inner join cliente c on p.Cli_ID=c.Cli_ID "
		        sSQL1 += " inner join  TransferenciaAlmacen_Articulos a  on p.Pro_ID = a.Pro_ID  "
	            sSQL1 += " where a.TA_ID = " + TA_ID 
		        sSQL1 += " GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		 
            var rsPro = AbreTabla(sSQL1,1,0)
            var rsPro2 = AbreTabla(sSQL1,1,0)
		 }

     var Cli_ID = Parametro("Cli_ID",1)
   	 var sSQL  = "SELECT Pro_ID, Pro_Cantidad, Pro_Nombre, Pro_DimAlto, Pro_DimLargo, Pro_DimAncho"
         sSQL += ", Pro_PesoBruto, Pro_PesoNeto "
	     sSQL += " FROM Producto WHERE TPro_ID = 4 "
	 var rsMB = AbreTabla(sSQL,1,0)
	
		 	%>


<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="modal-body">
                            <div class="form-horizontal">

<div class="modal-body">
    <div class="form-horizontal">
        <div class="form-group">
            <div class="col-md-3"></div>
        </div>
        <div class="ibox-content" id="dvActivos"></div>
                     
        <input type="text" value="<%=CliOC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="CliOC_ID">
        <input type="text" value="<%=OC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="OC_ID">
         <input type="text" value="<%=Prov_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Prov_ID">
         <input type="text" value="<%=Pro_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Pro_ID">
         <input type="text" value="<%=TA_ID%>"  style="display:none;width:150%"  class="objAco agenda"  id="TA_ID">
         <input type="text" value="<%=Cli_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Cli_ID">
                   
         <div class="ibox-content">
            <div class="form-group">
                <label class="control-label col-md-2"><strong>Cantidad productos</strong></label>
                <div class="col-md-3">
                    <input class="form-control Pro_CantidadMaster agenda" id="Pro_CantidadMaster" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2"><strong>Cantidad pallets</strong></label>
                <div class="col-md-3">
                    <input class="form-controPro_CantidadPall agenda" id="Pro_CantidadPal" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-2">Producto  </label>
                <div class="col-md-3">
                  <select id="cboPro_ID" class="form-control agenda">
                      <option value="--Seleccionar--" >--Seleccionar--</option>
<%
     while (!rsPro.EOF){
	     var Pro_ID =  rsPro.Fields.Item("Pro_ID").Value 
	     var Pro_Nombre =  rsPro.Fields.Item("ProC_Nombre").Value 
%>
         <option value="<%=Pro_ID%>"><%=Pro_Nombre%></option>
<%	
          rsPro.MoveNext() 
    }
    rsPro.Close()  
		 
%>
                  </select>
                </div>
                <label class="control-label col-md-1" id = "lblMB" style="display:none">Masterbox</label>
                <div class="col-md-3">
                    <select id="cboMB" class="form-control agenda" style="display:none">
                        <option value="-1" >--Seleccionar--</option>
<%
   while (!rsMB.EOF){
	      var Pro_ID =  rsMB.Fields.Item("Pro_ID").Value 
		  Pro_Cantidad =  rsMB.Fields.Item("Pro_Cantidad").Value 
	      Pro_Nombre =  rsMB.Fields.Item("Pro_Nombre").Value 
		  Pro_DimAlto =  rsMB.Fields.Item("Pro_DimAlto").Value
		  Pro_DimLargo =  rsMB.Fields.Item("Pro_DimLargo").Value
		  Pro_DimAncho =  rsMB.Fields.Item("Pro_DimAncho").Value
		  Pro_PesoNeto =  rsMB.Fields.Item("Pro_PesoNeto").Value
				 
%>
            <option value="<%=Pro_ID%>"><%=Pro_Nombre%> (cantidad cajas: <%=Pro_Cantidad%>, alto: <%=Pro_DimAlto%> cm, largo:<%=Pro_DimLargo%> cm, ancho:<%=Pro_DimAncho%> cm, peso: <%=Pro_PesoNeto%> kg)</option>
<%	
          rsMB.MoveNext() 
	}
    rsMB.Close()  
		 
%>
                    </select>
                </div>
                <div class="col-md-3">
                   <div class='external-event navy-bg' id="NvoMB"  style="display:none;width:40%">+ Nuevo</div>
                </div>
            </div>
                      
            <div class="form-group">
                <div class="col-md-3"></div>
                    <label class="control-label col-md-3" id="lblPallet"  style="display:none">Pallet</label>
                    <div class="col-md-3">
                	    <select id="cboPallet" class="form-control agenda"  style="display:none">
                            <option value="-1"  >--Seleccionar--</option>
<%
	var sSQL1  = "SELECT Pro_ID, Pro_Cantidad, Pro_Nombre, Pro_DimAlto, Pro_DimLargo, Pro_DimAncho, "
	    sSQL1 += "Pro_PesoBruto,Pro_PesoNeto FROM Producto WHERE TPro_ID = 5"
	 var rsPt = AbreTabla(sSQL1,1,0)
     while (!rsPt.EOF){
          var Pro_ID =  rsPt.Fields.Item("Pro_ID").Value 
    	  Pro_Cantidad =  rsPt.Fields.Item("Pro_Cantidad").Value 
	      Pro_Nombre =  rsPt.Fields.Item("Pro_Nombre").Value 
		  Pro_DimAlto =  rsPt.Fields.Item("Pro_DimAlto").Value
		  Pro_DimLargo =  rsPt.Fields.Item("Pro_DimLargo").Value
		  Pro_DimAncho =  rsPt.Fields.Item("Pro_DimAncho").Value
		  Pro_PesoNeto =  rsPt.Fields.Item("Pro_PesoNeto").Value
				 
%>

          <option value="<%=Pro_ID%>"><%=Pro_Nombre%> (cantidad cajas: <%=Pro_Cantidad%>, alto: <%=Pro_DimAlto%> cm, largo:<%=Pro_DimLargo%> cm, ancho:<%=Pro_DimAncho%> cm, peso: <%=Pro_PesoNeto%> kg)</option>
<%	
                rsPt.MoveNext() 
            }
        rsPt.Close()  
		 
%>
                        </select> 
                    </div>
                    <div class="col-md-3">
                        <div class='external-event navy-bg' id="NvoPallet" style="display:none;width:40%">
                            + Nuevo
                        </div>
                    </div>
            </div>
            <div class="form-group" id="dvGuardar" style="display:none;">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <div class='external-event navy-bg' id="BtnGuardarP"  style="width:87%">
                        Guardar configuracion 
                    </div>
                </div>
<%
		if(TA_ID > -1){
			var ssql = "SELECT * FROM inventario_Recepcion r "
                     + " INNER JOIN TransferenciaAlmacen t ON r.TA_ID = t.TA_ID " 
		             + " INNER JOIN Cliente c ON c.Cli_ID = t.Cli_ID "
                     + " WHERE t.TA_ID=" + TA_ID
			} 

        if(OC_ID > -1){ 
           var ssql = "SELECT * FROM inventario_Recepcion r "
                    + " INNER JOIN  Proveedor_OrdenCompra o ON r.OC_ID = o.OC_ID "
                    + " INNER JOIN Proveedor p ON p.Prov_ID = o.Prov_ID "
                    + " WHERE o.OC_ID= " + OC_ID
				
        }

        if(CliOC_ID > -1){ 
			var ssql = "SELECT * FROM  inventario_Recepcion r  "
                     + " INNER JOIN Cliente_OrdenCompra o ON r.CliOC_ID = o.CliOC_ID "
                     + " INNER JOIN Cliente c ON c.Cli_ID = o.Cli_ID "
                     + " WHERE o.CliOC_ID = " + CliOC_ID
						
				}
			
			var rsCita = AbreTabla(ssql,1,0)
		       
/*					 	if (rsCita.RecordCount > 0){							  
					 %>

                                    <label class="control-label col-md-2">Cita</label>
                            <div class="col-md-3">
                	<select id="cboCita" class="form-control agenda">
                      <option value="-1" >--Seleccionar--</option>
                  <%
                     while(!rsCita.EOF){
			 var IR_ID =  rsCita.Fields.Item("IR_ID").Value
			 var IR_FechaEntrega =  rsCita.Fields.Item("IR_FechaEntrega").Value
		
			
					   	 IR_FechaEntrega = new Date(IR_FechaEntrega);
							var day = IR_FechaEntrega.getDate()
							var month = IR_FechaEntrega.getMonth()
							var year =  IR_FechaEntrega.getYear()		
								if( day < 10){
							day = 	"0"+ day
								}
							if( month < 10){
							month = 	"0"+ month
								}
							var IR_Fecha =  month + "/" +day + "/" + year		
							var Fecha = day + "/" + month + "/" + year	 + " "
							var horas = IR_FechaEntrega.getHours()
							var minutos = IR_FechaEntrega.getMinutes()
							var segundos =  IR_FechaEntrega.getSeconds()
							if( minutos < 10){
							minutos = 	"0"+ minutos
								}
							if( horas< 10){
							horas = 	"0"+ horas
								}
							if( segundos < 10){
							segundos = 	"0"+ segundos 
								}
							 var IR_Horario =  horas + ":" +minutos + ":" + segundos
							var Horario = horas + ":" +minutos + " horas"
				 
%>
            <option value="<%=IR_ID%>"><%=Fecha%> <%=Horario%></option>
                  <%	
						rsCita.MoveNext() 
					}
                rsCita.Close()  
		 
                %>
                  </select>
                  <% */ %>
                   </div>
                   
                     
         <div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
            
                         <div class="col-md-3"></div>

     <div class="row" id= "divMB" style="display:none;">

            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
            <div class="form-group">
                   <label class="control-label col-md-3"><strong>Nuevo Masterbox</strong></label>
                <div class="col-md-3">
				</div>
                <label class="control-label col-md-1"><strong>Tipo</strong></label>
                <div class="col-md-3">
					<select id="Pro_TipoMB" class="form-control agenda">
                  <option value="Extra chica">Extra chica</option>
                  <option value="Chica">Chica</option>
                  <option value="Mediana">Mediana</option>
                  <option value="Grande">Grande</option>
                </select>	
                			</div>
                </div>
                 <div class="form-group">
                   <label class="control-label col-md-2"><strong>Cantidad Productos</strong></label>
                <div class="col-md-3">
                <input class="form-control Pro_CantidadMB agenda" id="Pro_CantidadMB" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAlto2" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo2" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
                <label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho2" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Peso bruto por caja (kg)</strong></label>
                <div class="col-md-3">
              <label class="control-label col-md-2"  value="" id="Pro_PesoBruto2"><strong></strong> </label>
                       </div>
                <label class="control-label col-md-2"><strong>Peso neto por caja (kg)</strong></label>
                <div class="col-md-3">
                <label class="control-label col-md-2"  value="" id="Pro_PesoNeto2"><strong></strong> </label>
				</div>
                     </div>
                           <div class="form-group">
                            <div class="col-md-3">
                                    </div>
                              <div class="col-md-3">
                                    <div class='external-event navy-bg' id="BtnGuardar"  style="width:45%">Guardar</div>
                                    </div>
                                    <div class="col-md-3">
                         			 <div class='external-event navy-bg' id="BtnCancelarMB"  style="width:45%">Cancelar</div>
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
     
       <div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                  
                
                  
                     <div class="row" id="divPallet" style="display:none;">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                    <div class="form-group">
                   <label class="control-label col-md-2"><strong>Nuevo Pallet</strong></label>
                <div class="col-md-3">
				</div>
                <label class="control-label col-md-2"><strong>Tipo</strong></label>
                <div class="col-md-3">
					<select id="Pro_TipoPt" class="form-control agenda">
                  <option value="Madera">Madera</option>
                  <option value="Plastico">Plastico</option>
                  <option value="x">x</option>
                  </select>	
                			</div>
                </div>
                       <div class="form-group">
               <label class="control-label col-md-2" ><strong>Cantidad cajas</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_CantidadPt" placeholder="" type="text" autocomplete="off" value=""></input>
                 </div>
               <label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo3" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
               </div>
             <div class="form-group">
               <label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho3" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control Pro_DimAlto3 agenda" id="Pro_DimAlto3" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                   </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Peso bruto por caja (kg)</strong></label>
                <div class="col-md-3">
              <label class="control-label col-md-2"  value="" id="Pro_PesoBruto3"><strong></strong></label>
                       </div>
                <label class="control-label col-md-2"><strong>Peso neto por caja (kg)</strong></label>
                <div class="col-md-3">
                <label class="control-label col-md-2"  value="" id="Pro_PesoNeto3"><strong></strong></label>
				</div>
                  
        </div>   
      </div>
     </div>
        <div class="form-group">
         <div class="col-md-3">
                                    </div>
                              <div class="col-md-3">
                                    <div class='external-event navy-bg' id="BtnGuardar"  style="width:45%">Guardar</div>
                                     </div>
                                 <div class="col-md-3">
                         			 <div class='external-event navy-bg' id="BtnCancelarPt"  style="width:45%">Cancelar</div>
 								
                                    </div>
  </div>
      </div>
    </div>

      
     <div class="row" id= "divScan" style="display:none;">

                
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
     
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
       
</div>

  


<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">


$(document).ready(function() {

	$('#InputScan+<%=Pro_ID%>').focus()
	var Transfer = {}
	
	$(".btnRetry").click(function(e) {
		e.preventDefault()
	});


    $('#cboPro_ID').on('change',function(e) {
	       e.preventDefault()
	   var  div = document.getElementById('cboPallet');
        div.style.display = '';
		 var  div = document.getElementById('cboMB');
        div.style.display = '';
		 var  div = document.getElementById('NvoMB');
        div.style.display = '';
		 var  div = document.getElementById('NvoPallet');
        div.style.display = '';
		 var  div = document.getElementById('lblMB');
        div.style.display = '';
		 var  div = document.getElementById('lblPallet');
        div.style.display = '';
        
	//		 var  div = document.getElementById('dvNvoScan');
//        div.style.display = '';
			 var  div = document.getElementById('dvGuardar');
        div.style.display = '';
		
   });

	
//	$('#dvNvoScan').click(function(e) {
//        e.preventDefault()
//            CargaEscaneo()
//        });
    
    $('#NvoMB').click(function(e) {
        
        var  div = document.getElementById('divMB');
        div.style.display = '';

    });
		
    $('#NvoPallet').click(function(e) {
      
        var  div = document.getElementById('divPallet');
        div.style.display = '';
    });


$('.Pro_DimAlto3').on('change',function(e) {
	e.preventDefault()
	var Alto = $('#Pro_DimAlto3').val() / $('#Pro_DimAlto2').val()
	var Largo = $('#Pro_DimLargo3').val() / $('#Pro_DimLargo2').val()
	var Ancho = $('#Pro_DimAncho3').val() / $('#Pro_DimAncho2').val()
	var Cantidad = (Alto * Ancho) * Largo
	Cantidad = Math.floor(Cantidad)
	$('#Pro_CantidadPt').val(Cantidad)
	var PesoPt = Cantidad * $('#Pro_PesoNeto2').text()
	var PesoPt2 = Cantidad * $('#Pro_PesoBruto2').text()
	$('#Pro_PesoBruto3').text(PesoPt2)
	$('#Pro_PesoNeto3').text(PesoPt)
});
    
$('.Pro_CantidadMB').on('change',function(e) {
	e.preventDefault()
	var PesoMB = $('#Pro_CantidadMB').val() * $('#Pro_PesoNeto').val()
	var PesoMB2 = $('#Pro_CantidadMB').val() * $('#Pro_PesoBruto').val()
	
	$('#Pro_PesoBruto2').text(PesoMB2)
	$('#Pro_PesoNeto2').text(PesoMB)
});
    
 $('#BtnCancelarMB').click(function(e) {
	  
        var  div = document.getElementById('divMB');
        div.style.display = 'none';
	 });
	  $('#BtnCancelarPt').click(function(e) {
	  
        var  div = document.getElementById('divPallet');
        div.style.display = 'none';
	 });
    
    $('#BtnGuardarP').click(function(e) {
        $.post("/pz/wms/Recepcion/Ajax.asp"
               ,{Tarea:1
                ,Cli_ID:$('#Cli_ID').val()
                ,CliOC_ID:$('#CliOC_ID').val()
                ,CliEnt_ID:$('#CliEnt_ID').val()
                ,PalID:$('#cboPallet').val()
                ,Pro_ID:$('#cboPro_ID').val()
                ,MBID:$('#cboMB').val()
                ,IDUsuario:$("#IDUsuario").val()
	            }
            , function(data){
                if (data == 1) {
                    sTipo = "info";
                    sMensaje = "El registro fue guardado exitosamente";
                    CargaEscaneo();
                    $('#BtnGuardarP').hide("")
                } else {
                    sTipo = "warning";
                    sMensaje = "Ocurrio un error al guardar el registro";
                }
                Avisa(sTipo,"Aviso",sMensaje);
            }); 
    });
    
	 $('#BtnGuardar').click(function(e) {
        e.preventDefault()
		$("#BtnGuardar").hide();
		var datosActivo = {}
		$('.agenda').each(function(index, element) {
            datosActivo[$(this).attr('id')] = $(this).val()
        });
		datosActivo['Tarea'] = 2
        datosActivo['Cli_ID'] = $('#Cli_ID').val()
		datosActivo['cboPro_ID'] = $('#cboPro_ID').val()
	   	
		datosActivo['cboMB'] = $('#cboMB').val()
	   	datosActivo['Pro_CantidadMB'] = $('#Pro_CantidadMB').val()
		datosActivo['Pro_TipoMB'] = $('#Pro_TipoMB').val()
	    datosActivo['Pro_PesoBruto2'] = $('#Pro_PesoBruto2').text()
		datosActivo['Pro_PesoNeto2'] = $('#Pro_PesoNeto2').text()
		datosActivo['Pro_DimAlto2'] = $('#Pro_DimAlto2').val()
		datosActivo['Pro_DimLargo2'] = $('#Pro_DimLargo2').val()
		datosActivo['Pro_DimAncho2'] = $('#Pro_DimAncho2').val()
		
		datosActivo['cboPallet'] = $('#cboPallet').val()
		datosActivo['Pro_CantidadPt'] = $('#Pro_CantidadPt').val()
		datosActivo['Pro_TipoPt'] = $('#Pro_TipoPt').val()
	    datosActivo['Pro_PesoBruto3'] = $('#Pro_PesoBruto3').text()
		datosActivo['Pro_PesoNeto3'] = $('#Pro_PesoNeto3').text()
		datosActivo['Pro_DimAlto3'] = $('#Pro_DimAlto3').val()
		datosActivo['Pro_DimLargo3'] = $('#Pro_DimLargo3').val()
		datosActivo['Pro_DimAncho3'] = $('#Pro_DimAncho3').val()
				
		Guardar(datosActivo)
	
	    });
    
    });
	function Guardar(Evento){
        $("#dvActivos").load("/pz/wms/Cliente/ProductoCliente_Ajax.asp",Evento
                            , function(data){

                                    sTipo = "info";
                                    sMensaje = "El registro se ha guardado correctamente ";

                                        Avisa(sTipo,"Aviso",sMensaje);
                            });
    }

    function  CargaEscaneo(){
        
        var dato = {}
	
		dato['Cli_ID'] = $('#Cli_ID').val()
		dato['CliOC_ID'] = $('#CliOC_ID').val()
        dato['CliEnt_ID'] = $('#CliEnt_ID').val()
		dato['OC_ID'] = $('#OC_ID').val()
		dato['Prov_ID'] = $('#Prov_ID').val()
		dato['Pro_ID'] = $('#cboPro_ID').val()

        $("#divMB").load("/pz/wms/Recepcion/RecepcionCargaEscaneo.asp",dato);
        $("#divMB").show("");

    }


</script>
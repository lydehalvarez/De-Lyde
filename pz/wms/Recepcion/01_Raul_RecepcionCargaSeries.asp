<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var TA_ID = Parametro("TA_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Tarea = Parametro("Tarea", -1)
var Cli_ID = Parametro("Cli_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var CliEnt_ID = Parametro("CliEnt_ID",-1)
var IDUsuario = Parametro("IDUsuario",-1)
var Pro_PesoBruto = 0
var Pro_PesoBrutoMB = 0
var Pro_PesoBrutoPt = 0
var Pro_PesoNeto = 0
var Pro_PesoNetoMB = 0
var Pro_PesoNetoPt = 0

   
   if( CliEnt_ID == -1){
        var sCondicion = "Cli_ID = " + Cli_ID + " AND CliOC_ID = " + CliOC_ID
        CliEnt_ID = SiguienteID("CliEnt_ID","Cliente_OrdenCompra_Entrega",sCondicion,0)

        var sSQL = "INSERT INTO Cliente_OrdenCompra_Entrega(Cli_ID, CliOC_ID, CliEnt_ID"
                 + " , CliEnt_UsuarioGeneroRecepcion) "
                 + " VALUES (" + Cli_ID + "," + CliOC_ID 
                 + "," + CliEnt_ID + "," + IDUsuario + ")"

         Ejecuta(sSQL,0)                    
   }
					 if(CliOC_ID>-1){
			var sSQL1 = "SELECT * FROM Producto_Cliente a "
sSQL1+=	"INNER JOIN Cliente_OrdenCompra_EntregaProducto p ON p.Pro_ID=a.Pro_ID  WHERE  p.CliOC_ID = "+CliOC_ID+" AND p.CliEnt_ID = "+CliEnt_ID
	
		    var rsPro = AbreTabla(sSQL1,1,0)
            var rsPro2 = AbreTabla(sSQL1,1,0)

					 }else{
var sSQL1 = "SELECT * FROM Producto_Proveedor a "
sSQL1+=	"INNER JOIN Proveedor_OrdenCompra_EntregaProducto p ON p.Pro_ID=a.Pro_ID  WHERE  p.OC_ID = "+OC_ID+" AND p.CliEnt_ID = "+CliEnt_ID
		    var rsPro = AbreTabla(sSQL1,1,0)
            var rsPro2 = AbreTabla(sSQL1,1,0)

					 }
	

     var Cli_ID = Parametro("Cli_ID",1)
	

		 	%>


<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-9">
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="modal-body">
                            <div class="form-horizontal">

<div class="modal-body">
    <div class="form-horizontal">
        <div class="form-group">
            <div class="col-md-3"></div>
        </div>
        <div class="ibox-content" id="dvActivos"></div>

            <div class="form-group">
                <label class="control-label col-md-2">Producto  </label>
                <div class="col-md-7">
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
               
            </div>
                      
            <div id= "divRelaciones">
          
                   

              
              
               
                
            </div>
            <div class="form-group" id="dvGuardar" style="display:none;">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <div class='external-event navy-bg' id="BtnGuardarP"  style="width:110%">
                        Escanear series 
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
%>
            </div>
                            
            <div class="wrapper wrapper-content animated fadeInRight">
            <div class="form-horizontal">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="ibox">
                            <div class="ibox-content">
                                <div class="col-md-3"></div>
                                <div class="row" id="divMB" style="display:none;">
                                    <div class="col-lg-12">
                                        <div class="ibox">
            <div class="ibox-content">
                <div class="form-group">
                    <label class="control-label col-md-3"><strong>Nuevo Masterbox</strong></label>
                    <div class="col-md-3"></div><label class="control-label col-md-1"><strong>Tipo</strong></label>
                    <div class="col-md-3">
                        <select class="form-control agenda" id="Pro_TipoMB">
                            <option value="Extra chica">
                                Extra chica
                            </option>
                            <option value="Chica">
                                Chica
                            </option>
                            <option value="Mediana">
                                Mediana
                            </option>
                            <option value="Grande">
                                Grande
                            </option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2"><strong>Cantidad Productos</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control Pro_CantidadMB agenda" id="Pro_CantidadMB" placeholder="" type="text" value="">
                    </div><label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control agenda" id="Pro_DimAlto2" placeholder="cm" type="text" value="">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control agenda" id="Pro_DimLargo2" placeholder="cm" type="text" value="">
                    </div><label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control agenda" id="Pro_DimAncho2" placeholder="cm" type="text" value="">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2"><strong>Peso bruto por caja (kg)</strong></label>
                    <div class="col-md-3">
                        <label class="control-label col-md-2" id="Pro_PesoBruto2"><strong></strong></label>
                    </div><label class="control-label col-md-2"><strong>Peso neto por caja (kg)</strong></label>
                    <div class="col-md-3">
                        <label class="control-label col-md-2" id="Pro_PesoNeto2"><strong></strong></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-3"></div>
                    <div class="col-md-3">
                        <div class='external-event navy-bg' id="BtnGuardar" style="width:45%">
                            Guardar
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class='external-event navy-bg' id="BtnCancelarMB" style="width:45%">
                            Cancelar
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
                                    <div class="col-md-3"></div><label class="control-label col-md-2"><strong>Tipo</strong></label>
                                    <div class="col-md-3">
                                        <select class="form-control agenda" id="Pro_TipoPt">
                                            <option value="Madera">
                                                Madera
                                            </option>
                                            <option value="Plastico">
                                                Plastico
                                            </option>
                                            <option value="x">
                                                x
                                            </option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><strong>Cantidad cajas</strong></label>
                                    <div class="col-md-3">
                                        <input autocomplete="off" class="form-control agenda" id="Pro_CantidadPt" placeholder="" type="text" value="">
                                    </div><label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
                                    <div class="col-md-3">
                                        <input autocomplete="off" class="form-control agenda" id="Pro_DimLargo3" placeholder="cm" type="text" value="">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                                    <div class="col-md-3">
                                        <input autocomplete="off" class="form-control agenda" id="Pro_DimAncho3" placeholder="cm" type="text" value="">
                                    </div><label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                                    <div class="col-md-3">
                                 <input autocomplete="off" class="form-control Pro_DimAlto3 agenda" id="Pro_DimAlto3" placeholder="cm" type="text" value="">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><strong>Peso bruto por caja (kg)</strong></label>
                                    <div class="col-md-3">
                                        <label class="control-label col-md-2" id="Pro_PesoBruto3"><strong></strong></label>
                                    </div><label class="control-label col-md-2"><strong>Peso neto por caja (kg)</strong></label>
                                    <div class="col-md-3">
                                        <label class="control-label col-md-2" id="Pro_PesoNeto3"><strong></strong></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-md-3"></div>
                            <div class="col-md-3">
                                <div class='external-event navy-bg' id="BtnGuardar" style="width:45%">
                                    Guardar
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class='external-event navy-bg' id="BtnCancelarPt" style="width:45%">
                                    Cancelar
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" id="divScan" style="display:none;">
                    <div class="col-lg-12">
                        <div class="ibox">
                            <div class="ibox-content"></div>
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
                  <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title" id="divCantidades">
                 
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

	  $('#cboPallet').on('change',function(e) {
		  	 var dato = {}
		  	dato['Tarea'] = 2
			dato['Pro_ID'] =$('#cboPro_ID').val()
            dato['MBID'] = $('#cboMB').val()
		  	dato['PalID'] = $('#cboPallet').val()
		  	$("#divCantidades").load("/pz/wms/Recepcion/Ajax.asp",dato);

	});
    $('#cboPro_ID').on('change',function(e) {
	       e.preventDefault()
		   	 var  div = document.getElementById('dvGuardar');
        div.style.display = '';
		
		 $("#BtnGuardarP").show("");
		     	 var dato = {}
		  	dato['Tarea'] = 3
			dato['Pro_ID'] =$('#cboPro_ID').val()
            
		  	$("#divRelaciones").load("/pz/wms/Recepcion/Ajax.asp",dato);

	
        
	//		 var  div = document.getElementById('dvNvoScan');
//        div.style.display = '';
		
		 		

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
				,Cantidad_MB:$('#cboMB').val()
		  		,Cantidad_Pallet:$('#cboPallet').val()
                ,IDUsuario:$("#IDUsuario").val()
	            }
            , function(data){
              
                    sTipo = "info";
                    sMensaje = "El registro fue guardado exitosamente";
                    CargaEscaneo();
                    $('#BtnGuardarP').hide("")
             
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
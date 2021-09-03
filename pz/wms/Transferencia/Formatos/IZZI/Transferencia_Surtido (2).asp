<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	
	var Transfer = "SELECT * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " ,(SELECT  Alm_TipoDeRutaCG94 FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) TipoTienda "
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE TA_ArchivoID = "+TA_ArchivoID
     var rsTran = AbreTabla(Transfer,1,0)
	 if(!rsTran.EOF){
		 var TA_TipoTransferenciaCG65 = rsTran.Fields.Item("TA_TipoTransferenciaCG65").Value 
	 }
	
%>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-12">
        	<div class="form-group">
              <div class="btn-group" role="group" aria-label="Basic example">
                <input type="button" value="Imprimir etiquetas" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnEtiquetas"/>
                <input type="button" value="Imprimir consolidado" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnConsolidado"/>
                <input type="button" value="Obtener series" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnSeries"/>
                <input type="button" value="Direcciones" data-archid="<%=TA_ArchivoID%>" data-tipo="<%=TA_TipoTransferenciaCG65%>" class="btn btn-success btnDirecciones"/>
                </div>
            </div>
            <div class="ibox">
                <div style="overflow-y: scroll; height:500px; width: auto;">
                <%
                    var rsTran = AbreTabla(Transfer,1,0)
    				var sig = 0
                    while (!rsTran.EOF){
						
							var TablaClass = ""
                            var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                            var TipoTienda = rsTran.Fields.Item("TipoTienda").Value 
							var TA_EstatusCG51 = rsTran.Fields.Item("TA_EstatusCG51").Value
							
							if((TA_EstatusCG51 == 11) || (TA_EstatusCG51 == 16) || (TA_EstatusCG51 == 19)){
									TablaClass = "bg-danger"
							}else{
								if(TA_EstatusCG51 > 2 ){
									TablaClass = "bg-success"
								}
							}
						
						
                        var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                        var TipoTienda = rsTran.Fields.Item("TipoTienda").Value 
						sig++
               %>
                    <div class="ibox-content <%=TablaClass%>" id="<%=TA_ID%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td class="desc" width="45%">                                    
                                        <div class="widget style1 navy-bg">
                                             <div class="row vertical-align">
                                                <div class="col-xs-3">
                                                    <i class="fa fa-dropbox fa-2x"></i>
                                                </div>
                                                <div class="col-xs-9 text-right">
                                                    <h3 class="font-bold"><%=rsTran.Fields.Item("TA_Folio").Value%></h3>
                                                </div>
                                            </div>
                                        </div> 
                                 		<p> 
                                            <span class="label label-primary">Origen <%=rsTran.Fields.Item("Sucursal_Origen").Value%></span>
                                        </p>
                                        <p> 
                                            <span class="label label-warning">Destino <%=rsTran.Fields.Item("Sucursal_Destino").Value%></span>
                                        </p>
                                        <p>
                                            <span class="label label-success">Folio Cliente <%=rsTran.Fields.Item("TA_FolioCliente").Value%></span>
                                        </p>
                                        <input type="text" value="" style="display:none;width:50%" data-num="<%=sig%>" data-taid="<%=TA_ID%>" class="form-control InputStartPick sig<%=sig%>" id="InputStartPick<%=TA_ID%>"/>
                                        <p class="small" id="Mensaje<%=TA_ID%>" style="font-size:inherit"></p>
                                            <div class="btn-group" role="group" aria-label="Basic example">
                                                <input type="button" value="Empezar pick" data-taid="<%=TA_ID%>" id="btnStartPick<%=TA_ID%>" class="btn btn-info btnStartPick"/>
                                                <input type="button" value="Cancelar pick" data-taid="<%=TA_ID%>"  id="btnCancelPick<%=TA_ID%>" class="btn btn-danger btnCancelPick"/>
                                                <input type="button" value="Imprimir Etiqueta"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirEtiqueta"/>
                                                <input type="button" value="Imprimir salida"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirSalida"/>
                                                
                                                <input onclick="$('#Autoriza_TA').val($(this).data('taid'));$('#ModalAutorizacion').modal('show');" type="button" value="Autorizaci&oacute;n" data-taid="<%=TA_ID%>" 
                                                       class="btn btn-success btnAutoriza"/>
                                            </div>                                        
                                   </td>
                                    <td class="desc" width="55%">
                                            <table style="color:#000" class="table table-hover table_<%=TA_ID%>">
                                                <thead>
                                                    <tr>  
                                                        <th>Ubicaci&oacute;n</th>
                                                        <th>SKU</th> 
                                                        <th>Nombre</th>
                                                        <th>Solicitado</th>
                                                        <th>Pickeado</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    var Data = " SELECT * "
                                                        Data += " ,[dbo].[fn_Ubica_rack_SKU] (6,8,TAA_SKU) as Ubicacion "
                                                        Data += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = a.Pro_ID) Producto "
                                                        Data += " ,(SELECT Pro_EsSerializado FROM Producto WHERE Pro_ID = a.Pro_ID) Serializado "
                                                        Data += " ,TAA_Cantidad "
                                                        Data += " ,(SELECT COUNT(*) FROM TransferenciaAlmacen_Articulo_Picking WHERE TA_ID = a.TA_ID AND TAA_ID = a.TAA_ID) Pickeados "
                                                        Data += " FROM TransferenciaAlmacen_Articulos a "
                                                        Data += " WHERE TA_ID = " + TA_ID
                                                    
                                                    var Total = 0
                                                    var TotalPickeados = 0
                                                    var rsArt = AbreTabla(Data,1,0)
                                                        while(!rsArt.EOF){
                                                            var TAA_SKU = rsArt.Fields.Item("TAA_SKU").Value 
                                                            var TAA_ID = rsArt.Fields.Item("TAA_ID").Value 
                                                            var Producto = rsArt.Fields.Item("Producto").Value 
                                                            var Ubicacion = rsArt.Fields.Item("Ubicacion").Value 
                                                            var TAA_Cantidad = rsArt.Fields.Item("TAA_Cantidad").Value 
                                                            var Pickeados = rsArt.Fields.Item("Pickeados").Value 
															var Serializado = rsArt.Fields.Item("Serializado").Value
															var Pro_ID = rsArt.Fields.Item("Pro_ID").Value
															var Color = ""
                                                            if(Ubicacion == ""){
                                                                Ubicacion = "Sin ubicaci&oacute;n"
                                                            }
															if(Pickeados < TAA_Cantidad){
																Color = 'style="color:#F00"'
															}
                                                            Total = Total + TAA_Cantidad
                                                            TotalPickeados = TotalPickeados + Pickeados
                                                    %>		
                                                        <tr>
                                                            <td><%=Ubicacion%></td>
                                                            <td><%=TAA_SKU%></td>
                                                            <td style="text-align: left;"><%=Producto%></td>
                                                            <td><%=TAA_Cantidad%></td>
                                                            <td <%=Color%>><span id="Cont_<%=TA_ID%>_<%=TAA_ID%>"><%=Pickeados%></span></td>
															<%if(Serializado == 0){
																var TotalPosible = TAA_Cantidad-Pickeados
																%>
                                                            <td><input type="number" value="<%=TotalPosible%>" max="<%=TotalPosible%>" min="1" id="<%=TA_ID%>_<%=Pro_ID%>_<%=TAA_ID%>" /><button type="button" data-proid="<%=Pro_ID%>" data-taid="<%=TA_ID%>" data-taaid="<%=TAA_ID%>" class="btn btn-sm btn-info addNoSerializado"><i class="fa fa-plus"></i> </button></td>
															<%}%>
                                                        </tr>
                                                    <%	
                                                        Response.Flush()
                                                        rsArt.MoveNext() 
                                                    }
                                                    rsArt.Close()  
                                                     
                                                    %>
                                                        <tr>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td style="text-align: right; color:#000">Total:</td>
                                                            <td><%=Total%></td>
                                                            <td><span id="Cont_final_<%=TA_ID%>"><%=TotalPickeados%></span></td>
                                                        </tr>
                                                </tbody>
                                            </table>
                                            <br />
                                            <br />
                                            <br />
                                            <table style="color:#000" class="table table-hover table_<%=TA_ID%>">
                                                <thead>
                                                    <tr>  
                                                        <th width="10%">ID</th>
                                                        <th width="15%">Articulos</th>
                                                        <th width="40%">Picking by</th> 
                                                        <th width="45%">&Uacute;ltimo picking</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                    var DataU = " SELECT TAS_Usuario ID,COUNT(*) Articulos,(SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](TAS_Usuario)) Usuario,MAX(TAS_FechaRegistro) UltimoRegistro "
														DataU += " FROM [dbo].[TransferenciaAlmacen_Articulo_Picking] "
														DataU += " WHERE TA_ID = " + TA_ID
														DataU += " GROUP BY TAS_Usuario "
                                                    
                                                    var rsUsua = AbreTabla(DataU,1,0)
                                                        while(!rsUsua.EOF){
                                                            var ID = rsUsua.Fields.Item("ID").Value 
                                                            var Articulos = rsUsua.Fields.Item("Articulos").Value 
                                                            var Usuario = rsUsua.Fields.Item("Usuario").Value 
                                                            var UltimoRegistro = rsUsua.Fields.Item("UltimoRegistro").Value 
                                                    %>		
                                                        <tr>
                                                            <td style="text-align:left"><%=ID%></td>
                                                            <td style="text-align:left"><%=Articulos%></td>
                                                            <td style="text-align:left"><%=Usuario%></td>
                                                            <td style="text-align:left"><%=UltimoRegistro%></td>
                                                        </tr>
                                                    <%	
                                                        Response.Flush()
                                                        rsUsua.MoveNext() 
                                                    }
                                                    rsUsua.Close()  
                                                    %>
                                                </tbody>
                                            </table>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <%	
                        rsTran.MoveNext() 
                    }
                    rsTran.Close()   
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="ModalAutorizacion" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Autorizaci&oacute;n de supervisor</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-3"><strong>C&oacute;digo del supervisor</strong></label>
            <div class="col-md-6">
                <input type="password" class="form-control" id="Pass" value=""/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAutorizaSuper">Autorizar</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ModalCajas" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Cantidad de cajas</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label class="control-label col-md-4"><strong>Cantidad de cajas</strong></label>
            <div class="col-md-4">
                <input type="number" min="1" max="99" onkeydown="return false" class="form-control" id="NumeroCajas" value="1"/>
            </div> 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnConfirmaCaja">Continuar</button>
      </div>
    </div>
  </div>
</div>


<input type="hidden" id="Autoriza_TA"/>
<input type="hidden" id="Caja_TA"/>
<input type="hidden" id="NumCaja_TA"/>

<script src="/pz/wms/Transferencia/Transferencia_Surtido.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="application/javascript">



$('.addNoSerializado').click(function(e) {
    e.preventDefault();
	var TA_ID = $(this).data('taid')
	var TAA_ID = $(this).data('taaid')
	var Pro_ID = $(this).data('proid')
	var request = {
		Tarea:9,
		TA_ID:TA_ID,
		TAA_ID:TAA_ID,
		Pro_ID:Pro_ID,
		Cantidad:$("#"+TA_ID+"_"+Pro_ID+"_"+TAA_ID).val(),
		IDUsuario:$('#IDUsuario').val()
	}
	
	NoSeriarializado.Inserta(request)
	$("#"+TA_ID+"_"+Pro_ID+"_"+TAA_ID).val(0)
});


$('.btnAutoriza').click(function(e) {
    e.preventDefault();
	$('#Autoriza_TA').val($(this).data('taid'));
	
});

$('.btnCaja').click(function(e) {
    e.preventDefault();
	$('#ModalCajas').modal('show');
	$('#Caja_TA').val($(this).data('taid'))
});
$('#ModalCajas').on('shown.bs.modal', function () {
	$('#NumeroCajas').val(1)

	$('#NumeroCajas').focus()
});

//$(document).keydown(function(event) {
//	console.log(event.which)
//	if(event.which == 66){
//		$('#ModalCajas').modal('show'); 
//	}
//});

$( "#NumeroCajas" ).keydown(function(event) {
	var Tota = parseInt($(this).val())
	console.log(event.which)
	if(Tota > 0){
		if(event.which == 38){
			Tota++
			$(this).val(Tota)
		}else if(event.which == 40){
			if(Tota != 1){
				Tota--
			$(this).val(Tota)
			}
		}
	}
	if(event.which == 32){
		$('#ModalCajas').modal('hide');
		$('#NumCaja_TA').val(Tota)
		NoSeriarializado.CantidadCaja()
	}
});

$('.btnConfirmaCaja').click(function(e) {
    e.preventDefault();
	$('#ModalCajas').modal('hide');
	var Tota = parseInt($('#NumeroCajas').val())
	$('#NumCaja_TA').val(Tota)
	NoSeriarializado.CantidadCaja()
});

$('.btnAutorizaSuper').click(function(e) {
    e.preventDefault();
	var TA_ID = $('#Autoriza_TA').val();
	var request = {
		Tarea:10,
		TA_ID:TA_ID,
		Batman:$('#Pass').val(),
		IDUsuario:$('#IDUsuario').val()
	}
	NoSeriarializado.AutorizaImpresion(request)
});

$('#Pass').on('keypress',function(e) {
	if(e.which == 13) {
		var TA_ID = $('#Autoriza_TA').val();
		var request = {
			Tarea:10,
			TA_ID:TA_ID,
			Batman:$('#Pass').val(),
			IDUsuario:$('#IDUsuario').val()
		}
	NoSeriarializado.AutorizaImpresion(request)
	}
});



var NoSeriarializado ={
	Inserta:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				Avisa("success","Avisa","Datos colocados exitosamente")	
				$('#Cont_'+request.TA_ID+'_'+request.TAA_ID).html(response.Escaneados)
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	},
	AutorizaImpresion:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				Avisa("success","Avisa","Impresi&oacute;n autorizada")	
				$('#ModalAutorizacion').modal('hide');
				$('#Pass').val("")
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	},
	CantidadCaja:function(){
		var request = {
			Tarea:11,
			TA_ID:$('#Caja_TA').val(),
			CantidadCaja:$('#NumCaja_TA').val()
		}
			
			
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request, function(data){
			var response = JSON.parse(data)
			if(response.result ==1){
				window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/EtiquetasTransferenciaV2.asp?TA_ID="+request.TA_ID+"&Cajas="+request.CantidadCaja);

				Avisa("success","Avisa","Cajas asignadas")	
			}else{
				Avisa("error","Error",response.message)	
			}
		});
	}
}

</script>

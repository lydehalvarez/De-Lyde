<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var IR_ID = Parametro("IR_ID",-1)
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var IDUsuario = Parametro("IDUsuario",-1)	
	var BPM_Pro_ID = Parametro("BPM_Pro_ID",-1)	
	var CliEnt_ID = Parametro("CliEnt_ID",-1)	
	var OV_ID = Parametro("OV_ID",-1)	
	var TA_ID = Parametro("TA_ID",-1)	
	
	var keys = '{IR_ID:'+IR_ID
				+',TA_ID:'+TA_ID
				+',OV_ID:'+OV_ID
				+',Cli_ID:'+Cli_ID
				+',CliOC_ID:'+CliOC_ID
				+',Prov_ID:'+Prov_ID
				+',BPM_Pro_ID:'+BPM_Pro_ID
				+',IDUsuario:'+IDUsuario
				+'}'
				
	
	var Cita = "SELECT IR_Folio, [dbo].[fn_CatGral_DameDato](52,IR_EstatusCG52) "
				+", ASN_FolioCliente "
				+", CONVERT(NVARCHAR(10),IR_FechaRegistro,103)+' - '+CONVERT(NVARCHAR(10),IR_FechaRegistro,108) +' hrs' as IRFechaRegistro "
				+", CONVERT(NVARCHAR(10),IR_FechaEntrega,103)+' - '+CONVERT(NVARCHAR(10),IR_FechaEntrega,108) +' hrs' as IRFechaEntrega "
				+" FROM Inventario_Recepcion a "
				+" LEFT JOIN ASN b "
				+" ON a.IR_ID = b.IR_ID "
				+" WHERE a.IR_ID = "+IR_ID
				
	bHayParametros = false
	ParametroCargaDeSQL(Cita,0)
				
				
%>

<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-md-9" id="dvHead">
            <div class="ibox">
                <div class="ibox-title">
                    <span class="pull-right">
                    <a class="btn btn-md btn-primary" data-toggle="modal" onclick='PalletFunctions.MultiplesPallet(true)' data-target="#newPalletModal"><i class="fa fa-plus"></i> Multiples pallets</a>
                    <a class="btn btn-md btn-primary" data-toggle="modal" onclick='PalletFunctions.MultiplesPallet(false)' data-target="#newPalletModal"><i class="fa fa-plus"></i> Nuevo pallet</a>
                    </span>
                    <strong><h4>Casificaci&oacute;n de pallet</h4></strong>
                    <br />
                    <br />
                </div>
                <div id="gridPallets"></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Resumen de pallets</h5>
                </div>
                <div class="ibox-content">
                    <span>Total de pallets</span>
                    <h2 class="font-bold" id="TotalPalets">0</h2>
                    <hr>
                    <span>Piezas por escanear</span>
                    <h2 class="font-bold" id="TotalPiezas">0</h2>
                    <hr>
                    <span>Piezas escaneadas</span>
                    <h2 class="font-bold" id="TotalEscaneadas">0</h2>
                    <hr>
                    <span>Piezas faltantes por escanear</span>
                    <h2 class="font-bold text-danger" id="TotalRestante">0</h2>
                    <hr>
                    <span class="text-muted small"><i class="fa fa-info-circle"></i> Total de pallets creados</span>
                </div>
            </div>
            <div class="ibox">
                <div class="ibox-title">
                    <h3>Producto pendiente de clasificar</h3>
                </div>
                <div id="dvFaltante"></div>
            </div>
            <div class="ibox">
                <div class="ibox-title">
                    <h3>Datos de la cita</h3>
                </div>
                <div class="ibox-content">
                    <h4><strong>Cita:</strong> <%=Parametro("IR_Folio","Sin folio")%></h4>
                    <h4><strong>ASN:</strong> <%=Parametro("ASN_FolioCliente","Sin ASN")%></h4>
                    <h4><strong>Fecha entrega:</strong> <%=Parametro("IRFechaEntrega","Sin ASN")%></h4>
                    <h4><strong>Fecha registro:</strong> <%=Parametro("IRFechaRegistro","Sin ASN")%></h4>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="newPalletModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close"  data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalPalletTitle">Nuevo pallet</h4>
          </div>
        <div class="modal-body">
            <div class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-md-3"><strong>Modelo</strong></label>
                    <div class="col-md-4">
                            <%  
                            var Escogido = 'onchange="PalletFunctions.ConfiguraPallet($(this).val())"'
                            if(IR_ID > -1){
                                var sTabla = "Producto a"
                                            + " INNER JOIN Cliente_OrdenCompra_EntregaProducto p ON p.Pro_ID=a.Pro_ID " 
                                            + " INNER JOIN  Cliente_OrdenCompra_Entrega en "
                                            + " ON en.CliOC_ID = p.CliOC_ID "
                                            + " AND en.Cli_ID=p.Cli_ID "
                                            + " AND en.CliEnt_ID = p.CliEnt_ID "
                                            + " WHERE  en.IR_ID = "+ IR_ID
                                            
                                CargaCombo("Pro_ID","class='form-control'"+Escogido,"a.Pro_ID","Pro_SKU +' - '+Pro_Nombre",sTabla,"","","Editar",0,"Selecciona el producto")
                            }
                            if(OC_ID > -1){
                    
                                var sTabla = "Producto a "
                                      + "INNER JOIN Proveedor_OrdenCompra_Articulos p "
                                      + " ON p.Pro_ID=a.Pro_ID  "
                                      + " WHERE  p.OC_ID = "+OC_ID
                                      +" AND p.Prov_ID = "+Prov_ID
                    
                                CargaCombo("Pro_ID","class='form-control'"+Escogido,"a.Pro_ID","Pro_SKU + ' - ' + Pro_Nombre",sTabla,"","",-1,0,"Selecciona el producto")
                            }%>	
                    </div>
                </div>
                <div id="dvPalletProd">
                    <div id="dvProdInfo"></div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <a class="btn btn-danger" data-dismiss="modal">Cancelar</a>
            <a class="btn btn-primary" id="btnSavePallet" onclick="PalletFunctions.SaveConfig();">Guardar</a>
        </div>
		</div>
	</div>
</div>

<input type="hidden" value="" id="MultiplesPallets"/>
<input type="hidden" value="0" id="EditarPallet"/>
<input type="hidden" value="-1" id="Pt_ID"/>

<script type="application/javascript">

var Params = <%=keys%>

$(document).ready(function(e) {
    PalletFunctions.Grid();
});

$('.modal').css('overflow-y', 'auto');
$('#newPalletModal').on('show.bs.modal', function (e) {
	if($("#MultiplesPallets").val() == 1){
		$("#myModalPalletTitle").html("Multiples pallets")
	}else{
		$("#myModalPalletTitle").html("Nuevo pallet")
	}
	$("#btnSavePallet").html("Guardar")
	$("#Pro_ID").val(-1)
	$("#dvPalletProd").hide()
})
var PalletFunctions = {
	MultiplesPallet:function(EsMultiple){
		if(EsMultiple){
			$("#MultiplesPallets").val(1);
		}else{
			$("#MultiplesPallets").val(0);
		}
		$('#Pt_ID').val(-1)
		$("#EditarPallet").val(0);
		$("#Pro_ID").prop("disabled",false);
	},
	CargaGrid_Generico:function(view,url,params){
		$(view).show('slow',function(){
			$(this).html(Global_loading)
			$(this).load(url,params,function(data){
				$(this).html(data)
				$(this).show('slow');
				$("html, body").animate({ scrollTop: $("#Contenido").offset().top }, 200);	
			})
		});
	},
	Grid:function(){
		PalletFunctions.CargaGrid_Generico('#gridPallets',"/pz/wms/Recepcion/RecepcionPallet_Grid.asp",Params)
		PalletFunctions.Grid_Faltante()
	},
	Grid_Faltante:function(){
		PalletFunctions.CargaGrid_Generico('#dvFaltante',"/pz/wms/Recepcion/RecepcionPallet_Grid_Faltante.asp",Params)
	},
	ConfiguraPallet:function(Pro_ID,Pt_ID){
		if(Pro_ID > -1){
			$('#dvPalletProd').hide('slow',function(){
				$('#dvProdInfo').hide('slow',function(){
					$(this).load("/pz/wms/Recepcion/RecepcionPallet_ProductoConfig.asp",
					{Pro_ID:Pro_ID
					,MultiplesPallets:$("#MultiplesPallets").val()
					,Pt_ID:Pt_ID
					},function(data){
						if($('#EditarPallet').val() == 1){
							$('#Pro_ID').val(Pro_ID).prop('disabled',true)
						}
						$(this).html(data)
						$(this).hide('slow',function(){
							$(this).show();
							$('#dvPalletProd').show('slow');
						});
						
					});
				});
			});
		}else{
			$('#dvPalletProd').hide('slow')
			Avisa("error","Selecciona un producto","No se seleccion&oacute; ning&uacute;n producto")	
		}
		
	},
	SaveConfig:function(){
		Params['Tarea'] = -1
		if($("#EditarPallet").val() == 1){//Edita pallet
			Params.Tarea = 12
			
			Params['Pt_ID']  = $('#Pt_ID').val()
		}else{ //Guarda pallet
			Params.Tarea = 10
		}
		Params['Pro_ID'] = $("#Pro_ID").val()
		Params['Pt_LPNCliente'] = $("#Pt_LPNCliente").val()
		Params['Pt_Color'] = $("#Pt_Color").val()
		Params['Pt_MB'] = $("#Pt_MB").val()
		Params['Pt_PiezaXMB'] = $("#Pt_PiezaXMB").val()
		Params['Pt_CantidadEsperada'] =  parseInt($("#Pt_CantidadEsperada").val())
		Params['Pt_Cantidad'] = parseInt($("#Pt_Cantidad").val())
		Params['Pro_RFIDCG160'] = $('input[name="Pro_RFIDCG160"]:checked').val()
		Params['Serializar'] = $('input[name="Serializar"]:checked').val()
		Params['Pro_SerieDigitos'] = $("#Pro_SerieDigitos").val()
		Params['Ubi_Nombre'] = $("#lblUbiNombre").val()
		Params['Ubi_ID'] = $("#Ubi_ID").val()
		Params['Pro_ID_RFID'] = $("#Pro_ID_RFID").val()
		Params['Pt_EsCuarentena'] = $('input[name="Pt_EsCuarentena"]:checked').val()
		
		if($("#Pt_CantidadPallets").val() != null){
			Params['CantidadPallets'] = parseInt($("#Pt_CantidadPallets").val())
		}

		if(Params.Pt_Cantidad > 0 && Params.Pt_CantidadEsperada > 0){
			 $.ajax({
				url: "/pz/wms/Recepcion/RecepcionPallet_Ajax.asp"
				, method: "post"
				, async: true
				, cache: false
				, data: Params
				, success: function(data){
					console.log(data)
					var response = JSON.parse(data)
					if(response.result == 1){
						response.data = "success"
						PalletFunctions.Grid();
					 	$('#newPalletModal').modal('hide')
					}else{
						response.data = "error"
					}
					Avisa(response.data,"Verifica los datos",response.message)	
				}
			});
		}else{
			Avisa("error","Verifica los datos","Verifica el formulario")	
		}
	},
	EscaneoPallet:function(Pt_ID){
		Params['Pt_ID'] = Pt_ID
		
		console.log(Params);
		
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionRayosX.asp",Params)
		
	},
	DeletePallet:function(Pt_ID,Pt_LPN){
		swal({
				title: "Desea eliminar el Pallet <br>"+Pt_LPN,
				text: "<strong><h3>Al confirmar el borrado todo contenido del pallet se eliminar&aacute;, excepto si el contenido del pallet ya se encuentra en inventario</h3></strong>",
				type: "warning",
				showCancelButton: true,
				confirmButtonText: "Si, borrar!",
				closeOnConfirm: true,
				html:true
			},function (data) {
				if(data){
					$('#Pt_dv_'+Pt_ID).show('slow',function(){
						$(this).html(Global_loading)
						 $.ajax({
							url: "/pz/wms/Recepcion/RecepcionPallet_Ajax.asp"
							, method: "post"
							, async: true
							, cache: false
							, data: {
								Tarea:11,
								Pt_ID:Pt_ID
							}
							, success: function(data){
								console.log(data)
								var response = JSON.parse(data)
								if(response.result == 1){
									response.data = "success"
									PalletFunctions.Grid();
								}else{
									response.data = "error"
								}
								Avisa(response.data,"Aviso",response.message)	
							}
						});
					});
				}
			});		
			
	},
	EditarPallet:function(Pt_ID,Pro_ID){
		$("#MultiplesPallets").val(0)
		$("#EditarPallet").val(1)
		$("#btnSavePallet").html("Guardar cambios")
		$('#newPalletModal').modal('show')
		$('#Pt_ID').val(Pt_ID)
		PalletFunctions.ConfiguraPallet(Pro_ID,Pt_ID)
	},
	Print:function(Pt_LPN){
		window.open("/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+Pt_LPN);
	},
	PrintEtiquetas:function(Pt_ID){
		window.open("/pz/wms/Recepcion/RecepcionPallet_EtiquetaCaja.asp?Pt_ID="+Pt_ID);
	}
}

</script>
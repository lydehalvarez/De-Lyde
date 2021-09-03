<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var IR_ID = Parametro("IR_ID",986)
	var Renglon = 0
	
	var sSQLRecp = "SELECT * "+
				   " FROM Inventario_Recepcion "+
				   " WHERE IR_ID = "+IR_ID
				   
    var rsIR = AbreTabla(sSQLRecp,1,0)	
	if(!rsIR.EOF){
		var Cli_ID = rsIR.Fields.Item("Cli_ID").Value 
		var CliOC_ID = rsIR.Fields.Item("CliOC_ID").Value 
		
		var sSQLKit = "SELECT b.CliEnt_SKU,b.Pro_ID,c.Pro_Nombre  "+
						" FROM Cliente_OrdenCompra_Entrega a, Cliente_OrdenCompra_EntregaProducto b,Producto c "+
						" WHERE a.CliOC_ID = "+CliOC_ID+
						" AND a.Cli_ID =  "+Cli_ID+
						" AND a.Cli_ID = b.Cli_ID "+
						" AND a.CliOC_ID = b.CliOC_ID  "+
						" AND a.CliEnt_ID = b.CliEnt_ID  "+
						" AND b.Pro_ID = c.Pro_ID "+
						" AND a.CliEnt_EstatusCG68 = 1 "
			
		var rsKit = AbreTabla(sSQLKit,1,0)	
		
		//Response.Write(sSQLKit)
	}
	 
%>
<div class="wrapper wrapper-content">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Recepcion de Kit</h5>
                    <div class="ibox-tools">
                        <!--<a onClick="Kit.NuevoKit()" class="btn btn-primary btn-xs"><i class="fa fa-plus"></i>&nbsp;Nuevo kit</a>-->
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="m-b-lg">
                        <div class="input-group">
                            <input type="text" value="" placeholder="Ingresa el UPC" class="UPC form-control">
                            <span class="input-group-btn">
                                    <button type="button" class="btn btn btn-primary"> <i class="fa fa-search"></i> Buscar</button>
                            </span>
                        </div>
                    </div>
                    <div class="table-responsive">
                    <table class="table">
                    	<thead>
                        	<tr>
                            	<th width="20%">Kit</th>
                            	<th width="60%">Pallet</th>
                            	<th width="20%">Acciones&nbsp;&nbsp;<a class="btn btn-success btnResumen" id="btnResumen"><i class="fa fa-file"></i> Resumen</a></th>
                            </tr>
                        </thead>
                        <tbody>
						<%
						var Pro_ID = -1
						var Pro_Nombre = ""
						while(!rsKit.EOF){ 
						     
                              Pro_ID = rsKit.Fields.Item("Pro_ID").Value       
							  Pro_Nombre = rsKit.Fields.Item("Pro_Nombre").Value
                        %>
                            <tr id="Pro_<%=Pro_ID%>" class="Renglones">
                                <td>
                                    <h3><span class="text-primary">Posici&oacute;n <%=++Renglon%></span>
                                    <br>
                                    <span class="text-primary"><%=rsKit.Fields.Item("CliEnt_SKU").Value%></span>
                                    <br>
                                    <span class="text-primary"><%=Pro_Nombre%></span>
                                    
                                    </h3>
                                    <input type="hidden" id="Pro<%=Pro_ID%>" value="<%=Pro_Nombre%>" data-renglon="<%=Renglon%>"/>
                                </td>
                                <td id="Pallet_<%=Pro_ID%>">
									<%
									var sSQLPT = "SELECT PT_ID,PT_Cantidad_Actual,Ubi_ID FROM Pallet WHERE Pro_ID = "+Pro_ID
									var PT_ID = -1
									var Ubi_ID = -1
									var Fondo = ""
									var accion = ""
									var rsPt = AbreTabla(sSQLPT,1,0)	
									if(!rsPt.EOF){
                                    while(!rsPt.EOF){      
                                         PT_ID = rsPt.Fields.Item("PT_ID").Value
										 Ubi_ID = rsPt.Fields.Item("Ubi_ID").Value 
										 if(Ubi_ID > -1){
											 Fondo = "btn-danger"
											 accion = 'Kit.ImprimeModal('+PT_ID+',"'+Pro_Nombre+'",'+Renglon+')'
										 }else{
											 Fondo = "btn-primary"
											 accion = 'Kit.Modal('+PT_ID+',"'+Pro_Nombre+'",'+Renglon+',$(this))'
										 }
										%>
										<a class="btn <%=Fondo%> btn-md btnPallet" data-ubicado="0" id="PT_<%=PT_ID%>" onclick='<%=accion%>'><%=rsPt.Fields.Item("PT_Cantidad_Actual").Value%></a>
										<%	
												rsPt.MoveNext() 
											}
										rsPt.Close() 
									}else{
									//Response.Write('<a onClick="Kit.NuevoPallet('+Pro_ID+')" class="btn btn-outline btn-default"><i class="fa fa-plus"></i></a>')	
									}
										%> 
                                    
                                </td>
                                <td>
                                    <a class="btn btn-white btn-sm" onclick="Kit.PalletCategory(<%=Pro_ID%>,<%=Cli_ID%>)" style="color:#000"><i class="fa fa-print"></i>&nbsp;Imprime</a>
                                </td>
                            </tr>
						<%	
								rsKit.MoveNext() 
							}
                        rsKit.Close()   
						%>                        
                        </tbody>
                    </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<div class="modal inmodal" id="ModalPallet" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h1 class="modal-title" id="myModalLabel"></h1>
      </div>
      <div class="modal-body">
       	<p><strong>Instrucciones:</strong></p><br />
      	<p>Una vez colocada la ubicaci&oacute;n el pallet se pondr&aacute; de color rojo</p><br />
      	<input type="text" autocomplete="off" placeholder="Coloca la ubicaci&oacute;n del nuevo pallet" id="NewUbication" class="form-control" />
        <br />

        <div class="row"> 
        <table class="table">
        	<thead>
            	<tr>
                	<th>Nombre</th>
                	<th>UPC</th>
                	<th>Cantidad</th>
                	<th>Acci&oacute;n <a class="btn btn-sm btn-danger btnBorraTodo"><i class="fa fa-trash"></i> Borra todo</a></th>
                </tr>
            
            </thead>
            <tbody id="divModificar">
            
            
            </tbody>
        </table>
       </div>
        
      </div>
      <div class="modal-footer">
        <input type="button" class="btn btn-danger" data-dismiss="modal" value="Cancelar"/>
        <input type="button" class="btn btn-primary" id="btnGuardaUbicacion" onclick="Kit.Ubicacion($('#NewUbication').val(),$('#Pt_ID').val())" disabled value="Guardar"/>
      </div>
    </div>
  </div>
</div>
<div class="modal inmodal" id="ModalPalletLPN" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h1 class="modal-title" id="myModalLabelLPN"></h1>
      </div>
      <div class="modal-body">
      	<p><strong>Instrucciones:</strong></p><br />
      	<p>En esta ventana puedes imprimir la papeleta del LPN</p><br />
      	<input type="button" class="btn btn-success btnImprimeLPN" value="Imprimir LPN" />
      	<a class="btn btn-danger" onclick="Kit.EliminaUbicacion();"><i class='fa fa-trash'></i> Eliminar Ubicacion</a>
        <div class="row"> 
        <table class="table">
        	<thead>
            	<tr>
                	<th>Nombre</th>
                	<th>UPC</th>
                	<th>Cantidad</th>
                </tr>
            </thead>
            <tbody id="divContenido">
            </tbody>
        </table>
       </div>
        
        
      </div>
      <div class="modal-footer">
        <input type="button" class="btn btn-default" data-dismiss="modal" value="Cerrar"/>
      </div>
    </div>
  </div>
</div>

<input type="hidden" value="" id="Pt_ID"/>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">


//$(document).keydown(function(e) {
//	if(e.which == 27){
//		Kit.focusON($('.UPC'))
//		$('.UPC').val("") 
//	}
//});
//
$('.btnModificar').click(function(e) {
    e.preventDefault()
	$('#divModificar').show('slow')
});

$('.btnResumen').click(function(e) {
    e.preventDefault()
	Kit.Exportar();
});

$('#ModalPallet').on('hidden.bs.modal', function () {
	$('#NewUbication').val("")
	$('#Pt_ID').val("")
	$('#btnGuardaUbicacion').prop('disabled',true);
})
$('#ModalPalletLPN').on('hidden.bs.modal', function () {
	$('#Pt_ID').val("")
})
$('#NewUbication').on('keypress',function(e) {
    if(e.which == 13){
		e.preventDefault();
	}else{
		var datoIngresa = $(this).val()
		datoIngresa = datoIngresa.replace(/[\']/g, "-");
	
		$("#NewUbication").val(datoIngresa);
		
		if($(this).val() != ""){
			$('#btnGuardaUbicacion').prop('disabled',false);
		}
		else{
			$('#btnGuardaUbicacion').prop('disabled',true);
		}
	}
});


$('.btnImprimeLPN').click(function(e) {
    e.preventDefault();
	Kit.ImprimeLPN($('#Pt_ID').val())
});

$('.btnBorraTodo').click(function(e) {
    e.preventDefault();
	Kit.DeleteAll()
});


//
//$('.UPC').keypress(function(e) {
//	e.preventDefault();
//    if(e.which == 13){
//		var dato = $(this).val()
//		console.log($(this).val().substring(1,100))
//		//Kit.Escaneo(dato);	
//	}
//});

$('.UPC').on('keypress',function(e) {
    if(e.which == 13){
		var dato = $(this).val()
		dato.toString();
		var Verifica = dato.substring(0,1)
		if(Verifica == "0"){
			dato = dato.substring(1,100)
		}
		console.log(dato)
		Kit.Escaneo(dato);	
		e.preventDefault();
		
	}
});



var Kit = {
	Modal:function(Pt_ID,Nombre,Renglon,o){
		var dato = parseInt(o.data('ubicado'))
		
		if(dato == 0){
			$('#Pt_ID').val(Pt_ID);
			$('#myModalLabel').html(Nombre+" - Tarima "+Renglon)
			$('#ModalPallet').modal('show')
			Kit.PalletProduct(Pt_ID,1);
		}else{
			Kit.ImprimeModal(Pt_ID,Nombre,Renglon)
		}
	},
	NuevoPallet:function(Pro_ID,Pt_ID){
		var Pro_Nombre = '"'+$("#Pro"+Pro_ID).val()+'"'
		var Renglon = $('#Pro'+Pro_ID).data('renglon')
		//var PalletNuevo = '<a onclick="Kit.Modal('+Pt_ID+','+Pro_Nombre+','+Renglon+')" class="btn btn-primary btn-md" id="PT_'+Pt_ID+'">0</a>'
		
		var PalletNuevo = "<a data-ubicado='0' onclick='Kit.Modal("+Pt_ID+","+Pro_Nombre+","+Renglon+",$(this))' class='btn btn-primary btn-md' id='PT_"+Pt_ID+"'>0</a>"
		$('#Pallet_'+Pro_ID).append(PalletNuevo)
	},
	Escaneo:function(upc){
		$('.UPC').val("")
		$('.Renglones').removeClass('bg-success');
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "http://192.168.254.11:8081/api/s2012/Recepecion/RecepcionKit/UPC/Test?UPC="+upc+"&IDUsuario="+$('#IDUsuario').val()+"&IR_ID="+<%=IR_ID%>,
			success: function(response){
				console.log(response) 
				if(response.result == 1){
					var Pro = response.data.Producto
					var Pallet = response.data.Pallet
					$('#Pro_'+Pro.Pro_ID).addClass('bg-success');
					Kit.focusON($('#Pro_'+Pro.Pro_ID))
					if(response.data.PalletNuevo == 1){
						Kit.NuevoPallet(Pro.Pro_ID,Pallet.Pt_ID)
					}
					$('#PT_'+Pallet.Pt_ID).html(Pallet.PT_Cantidad_Actual);
					
				}else{
					Avisa("error","Error",response.message)
				}
				
			}
		})		
	},
	Ubicacion:function(Ubicacion,Pt_ID){
		$.ajax({
			type: 'GET',
			contentType:'application/json', 
			url: "http://192.168.254.11:8081/api/s2012/Recepecion/RecepcionKit/Ubicacion/Test?Ubicacion="+Ubicacion+"&Pt_ID="+Pt_ID,
			success: function(response){
				if(response.result == 1){
					$('#ModalPallet').modal('hide')
					$('#PT_'+Pt_ID).addClass('btn-danger')
					$('#PT_'+Pt_ID).data('ubicado','1')
					Avisa("success","Pallet ubicado correctamente",response.message)
				}else if(response.result == 10){
					$('#ModalPallet').modal('hide')
					$('#PT_'+Pt_ID).addClass('btn-danger')
					$('#PT_'+Pt_ID).data('ubicado','1')
					Avisa("warning","Lo sentimos pallet ya ubicado",response.message)
				}
				else{
					Avisa("error","Error",response.message);
				}
				//console.log(response) 
			}
		})		
	},
	focusON:function(view){
		$('html, body').animate({ scrollTop: view.offset().top }, 'slow');
	},
	ImprimeModal:function(Pt_ID,Nombre,Renglon){
		$('#Pt_ID').val(Pt_ID);
		$('#myModalLabelLPN').html(Nombre+" - Tarima "+Renglon)
		$('#ModalPalletLPN').modal('show')
		Kit.PalletProduct(Pt_ID,2);
	},
	ImprimeLPN:function(Pt_ID){
		var url = "/pz/wms/Recepcion/RecepcionKit/HojaLPN.asp?Pt_ID="+Pt_ID;
		window.open(url, "Impresion Papeleta" );
	},
	PalletProduct:function(Pt_ID,Tipo){
		$.ajax({
			type: 'GET',
			contentType:'application/json', 
			url: "http://192.168.254.11:8081/api/s2012/Recepecion/RecepcionKit/Products/Test?Pt_ID="+Pt_ID,
			success: function(response){
				if(response.result == 1){
					if(Tipo == 1){
						$('#divModificar').html(Kit.CreateTable(response.data))
					}else{
						$('#divContenido').html(Kit.TableContenido(response.data))
					}
				}else{
					Avisa("error","Error",response.message);
				}
				console.log(response) 
			}
		})		
	},
	CreateTable:function(arr){
		 var Table = ''	
		 var Accion = ''
		 //console.log(arr)
		 var contador = 0
		 for(var i = 0;i<arr.length;i++){ 
		 Accion = '<div class="input-group">'+
						'<input type="number" class="form-control" value="0" min="0" max="'+arr[i].Cantidad+'" id="Cantidad_'+arr[i].Pro_ID+'_'+arr[i].Pt_ID+'"/>'+
							'<span class="input-group-btn">'+
								'<a class="btn btn-danger btnQuita" onclick="Kit.Delete('+arr[i].Pro_ID+','+arr[i].Pt_ID+')"><i class="fa fa-trash"></a>'+
							'</span>'+
						'</div>'
			 Table = Table + '<tr><td>'+arr[i].Pro_Nombre+'</td><td>'+arr[i].Pro_UPC+'</td><td>'+arr[i].Cantidad+'</td><td>'+Accion+'</td></tr>'
			 contador = contador + arr[i].Cantidad
		 }
		 Table = Table + '<tr><th>Total</th><td>&nbsp;</td><th>'+contador+'</th><td>&nbsp;</td></tr>'
		 return Table
	},
	TableContenido:function(arr){
		 var Table = ''	
		 //console.log(arr)
		 var contador = 0
		 for(var i = 0;i<arr.length;i++){ 
			 Table = Table + '<tr><td>'+arr[i].Pro_Nombre+'</td><td>'+arr[i].Pro_UPC+'</td><td>'+arr[i].Cantidad+'</td></tr>'
			 contador = contador + arr[i].Cantidad
		 }
		 Table = Table + '<tr><th>Total</th><td>&nbsp;</td><th>'+contador+'</th><td>&nbsp;</td></tr>'
		 return Table
	},
	Delete:function(Pro_ID,Pt_ID){
		var Cantidad = $('#Cantidad_'+Pro_ID+'_'+Pt_ID).val()
		if(Cantidad > 0){
			swal({
			  title: 'Desea borrar '+ Cantidad, 
			  text: '',
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonClass: "btn-success",
			  confirmButtonText: "Ok" ,
			  closeOnConfirm: true,
			  html: true  
			},
			function(data){
				if(data){
					$.ajax({
						type: 'GET',
						contentType:'application/json', 
						url: "http://192.168.254.11:8081/api/s2012/Recepecion/RecepcionKit/Delete/Test?Pro_ID="+Pro_ID+"&Pt_ID="+Pt_ID+"&Cantidad="+Cantidad,
						success: function(response){
							if(response.result == 1){
								$('#PT_'+Pt_ID).html(response.data.Pt_CantidadActual);
								$('#ModalPallet').modal('hide')
								Avisa("success","Borrado exitoso","El borrado se hizo de manera exitosa");
							}else{
								Avisa("error","Error",response.message);
							}
							console.log(response) 
						}
					})	
				}
			});		
		
		}else{
			Avisa("error","Ocurri&oacute; un error","No se puede eliminar 0 items")	
		}
		
	},
	DeleteAll:function(){
		var Pt_ID = $('#Pt_ID').val()
		swal({
		  title: 'De seas borrar todo el pallet', 
		  text: 'Al borrar todo el pallet no se podr&aacute; recuperar la informaci&oacute;n',
		  type: "warning",
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  showCancelButton: true,
		  closeOnConfirm: true,
		  html: true  
		},
		function(data){
			if(data){
				$.ajax({
					type: 'GET',
					contentType:'application/json', 
					url: "http://192.168.254.11:8081/api/s2012/Recepecion/RecepcionKit/DeleteAll/Test?Pt_ID="+Pt_ID,
					success: function(response){
						if(response.result == 1){
							$('#PT_'+Pt_ID).html(0);
							$('#ModalPallet').modal('hide')
							Avisa("success","Borrado exitoso","El borrado se hizo de manera exitosa");
						}else{
							Avisa("error","Error",response.message);
						}
						console.log(response) 
					}
				})	
			}
		});		
	},
	Exportar:function(){
		$('#btnResumen').addClass('disabled')
		$.get("https://wms.lydeapi.com/api/Recepcion/RecepcionKit/DataReport",
		 function(response){
			$('#btnResumen').removeClass('disabled')

			 if(response.result==1){
				console.log(response)
				var ws = XLSX.utils.json_to_sheet(response.data);
				var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
				XLSX.writeFile(wb, "Reporte sort.xlsx");
			 }else{
				 
				Avisa("error","No hay datos",response.message) 
			 }
		});  
	},
	PalletCategory:function(Pro_ID,Cli_ID){
		$.get("/pz/wms/Recepcion/RecepcionKit/DataReporteCategory.asp?Pro_ID="+Pro_ID+"&Cli_ID="+Cli_ID,
		 function(response){
			 var ob = JSON.parse(response)
			 console.log(ob)
			 if(ob.data != null){
				var ws = XLSX.utils.json_to_sheet(ob.data);
				var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
				XLSX.writeFile(wb, "Reporte sort.xlsx");
			 }
		});  
	},
	EliminaUbicacion:function(){
		swal({
		  title: 'De seas eliminar la ubicaci&oacute;n del pallet?', 
		  type: "warning",
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  showCancelButton: true,
		  closeOnConfirm: true,
		  html: true  
		},
		function(data){
			var Pt_ID = $("#Pt_ID").val()
			if(data){
				$.ajax({
					method: "POST",
					url: "/pz/wms/Recepcion/RecepcionKit/RecepcionKit_Ajax.asp?",
					data: {Pt_ID:Pt_ID,
						Tarea:1
						},
					cache: false,
					success: function (data) {
							$('#ModalPallet').modal('hide');
							$('#ModalPalletLPN').modal('hide');
				
							var response = JSON.parse(data)
							var Tipo = ""
							if(response.result == 1){
								
								$('#PT_'+Pt_ID).removeClass('bg-danger')
								$('#PT_'+Pt_ID).addClass('bg-primary')
								$('#PT_'+Pt_ID).data('ubicado','0')
								$('#ModalPallet').modal('hide');
								$('#ModalPalletLPN').modal('hide');
							}else{
								Tipo = "error"
								Avisa(Tipo,"Aviso",response.message);
							}
							
					}
				});	
			}
		});		
	}
	
}

</script>

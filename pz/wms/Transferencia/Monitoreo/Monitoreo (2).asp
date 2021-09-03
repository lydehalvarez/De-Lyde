<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet"> 
<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>


<div class="row">
	<div class="col-md-12">
    	<div class="ibox">
            <div class="ibox-title">
                <h5>Seguimiento de transferencias</h5>
            </div>
            <div class="ibox-content">
                <div class="form-horizontal">
                    <div class="form-group">
                     <label class="control-label col-md-2" ><strong>Cliente</strong></label>
                        <div class="col-md-6">
                            <%var sCampo = "Cli_Nombre"
                              var sCond = ""
                                CargaCombo("Cli_ID","class='form-control'","Cli_ID",sCampo,
                                "Cliente",sCond,sCampo,6,0,"Selecciona","Editar")%>
                        </div> 
                    </div>
                </div>
            </div>
            <div class="ibox-content">
                <table id="example" class="table">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Pendiente</th>
                            <th>Packing</th>
                            <th>Shipping</th>
                            <th>Transito</th>
                            <th>Entregado</th>
                            <th>Devuelto</th>
                            <th>Pendiente NE</th>
                            <th>Cancelado</th>
                            <th>Total</th>
                        </tr>
                    </thead> 
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th>Total</th>
                            <th><span class="ToPend">0</span></th>
                            <th><span class="ToPack">0</span></th>
                            <th><span class="ToShip">0</span></th>
                            <th><span class="ToTran">0</span></th>
                            <th><span class="ToEntre">0</span></th>
                            <th><span class="ToDevue">0</span></th>
                            <th><span class="ToPendNE">0</span></th>
                            <th><span class="ToCancelado">0</span></th>
                            <th><span class="ToTotal">0</span></th>
                        </tr>
                    </tfoot>               
                </table>
            </div> 
        </div>
    </div>
</div> 


<div class="modal fade" id="myModalGetFolio" tabindex="0" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel"></h4>
      </div>
      <div class="modal-body">
        <div class="form-horizontal" id="modalBodyFolio">
        
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-cierre btn btn-danger" data-toggle="modal" data-target="#myModalGetFolio">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="ModalFicha" tabindex="1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">Ficha de la transferencia</h4>
      </div>
      <div class="modal-body" id="modalBodyFicha">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#ModalFicha">Cerrar</button>
      </div>
    </div>
  </div>
</div>


<input id="TA_ID" type="hidden" value="" />
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">
 var table = ""
 

$('#Cli_ID').change(function(e) {
    Monitoreo.CargaTabla();
	table.destroy();
});

	
var Monitoreo = {
	CargaTabla:function(){
		table = $('#example').DataTable({
				responsive: true,
				autoWidth: true,
				processing: true,
				scrollY: "550px", 
				scrollCollapse: true,
				paging:false,
				ajax:{
				url: "https://wms.lydeapi.com/api/Transferencia/Monitoreo/Data?Cli_ID="+$("#Cli_ID").val(),
				dataSrc: function (json) {
						var Dato = json.data
						console.log(json)
						$('.ToPend').html(Monitoreo.CalculaSuma(Dato,"Pendiente"))
						$('.ToPack').html(Monitoreo.CalculaSuma(Dato,"Packing"))
						$('.ToShip').html(Monitoreo.CalculaSuma(Dato,"Shipping"))
						$('.ToTran').html(Monitoreo.CalculaSuma(Dato,"Transito"))
						$('.ToEntre').html(Monitoreo.CalculaSuma(Dato,"Entregado"))
						$('.ToDevue').html(Monitoreo.CalculaSuma(Dato,"Devuelto"))
						$('.ToPendNE').html(Monitoreo.CalculaSuma(Dato,"PendienteNE"))
						$('.ToCancelado').html(Monitoreo.CalculaSuma(Dato,"Cancelado"))
						$('.ToTotal').html(Monitoreo.CalculaSuma(Dato,"Total"))
						
					  return json.data;
					}
				},
				columns: [
					{ "data": "Fecha" }, 
					{ "data": "Pendiente" },
					{ "data": "Packing"},
					{ "data": "Shipping"},
					{ "data": "Transito" },
					{ "data": "Entregado" },
					{ "data": "Devuelto" },
					{ "data": "PendienteNE" },
					{ "data": "Cancelado" },
					{ "data": "Total" }
				],
				rowCallback: function(row, data, index) {
				  //console.log(row)
					if(data.Pendiente > 0){
							  $('td:eq(1)', row).addClass("bg-primary")
					}
					if(data.Packing > 0){
							  $('td:eq(2)', row).addClass("bg-warning")
					}
					if(data.Shipping > 0){
							  $('td:eq(3)', row).addClass("bg-danger")
					}
					if(data.Transito > 0){
							  $('td:eq(4)', row).addClass("bg-success")
					}
					if(data.PendienteNE > 0){
							  $('td:eq(7)', row).addClass("bg-warning")
					}
					
		//			if(data.TercerIntento.Class != ""){
		//					  $('td:eq(6)', row).addClass(data.TercerIntento.Class)
		//			}
		
				},
				select: {
					style: 'single'
				},
				responsive: {
				details: {
					type: 'column',
					target: '#myModalGetFolio'
				}	
			}
		}); 
		
		
		
		table.on( 'select', function ( e, dt, type, indexes ) {
			var rowData = table.rows(indexes).data();
			$('#modalBodyFolio').html("")
			console.log(rowData[0]);
			$(".selected").attr("data-toggle", "modal");
			$(".selected").attr("data-target", "#myModalGetFolio");
			var loading = '<div class="text-center"><div class="spiner-example"><div class="sk-spinner sk-spinner-rotating-plane"></div><br><br><br><div>Espere un momento por favor</div></div></div>'
			$('#modalBodyFolio').html(loading)
			$('#myModalLabel').html("Resumen de d&iacute;a <strong>"+rowData[0].Fecha+"</strong>" )
			rowData[0]["Cli_ID"] = $('#Cli_ID').val();
			$.post("/pz/wms/Transferencia/Monitoreo/Monitoreo_Folios.asp"
			  ,rowData[0], function(data){
				$('#modalBodyFolio').html(data)
			});  
		
			
		});	
	},
	Ficha:function(TA_ID,Cli_ID){
		$('#modalBodyFicha').html("");
		$("#TA_ID").val(TA_ID)

		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "/pz/wms/TA/TA_Ficha.asp?TA_ID="+TA_ID+"&Cli_ID="+Cli_ID,
			success: function(response){
				console.log(response) 
				$('#modalBodyFicha').html(response);
			},
			error: function(){
				swal({
				  title: 'Ups!', 
				  text: '<strong>Ocurri&oacute; un error al cargar, intenta de nuevo, por favor</strong>',
				  type: "error",
				  confirmButtonClass: "btn-success",
				  confirmButtonText: "Ok" ,
				  closeOnConfirm: true,
				  html: true  
				});
			}
		});		
		
		
//		$.post("/pz/wms/TA/TA_Ficha.asp"
//		  ,{
//			 TA_ID:TA_ID,
//		  	 Cli_ID:Cli_ID
//		  }
//		  , function(data){
//			$('#modalBodyFicha').html(data);
//		});  
	},
	Exportar:function(Estatus,Fecha){
		$.get("https://wms.lydeapi.com/api/Transferencia/Monitoreo/Resumen?TA_EstatusCG51="+Estatus+"&Fecha="+Fecha+"&Cli_ID="+$("#Cli_ID").val(),
		 function(response){
			 console.log(response)
			if(response.result == 1){
				var ws = XLSX.utils.json_to_sheet(response.data);
				var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
				XLSX.writeFile(wb, "Estatus_"+Estatus+"_"+Fecha+".xlsx");
			}else{
				Avisa("error","Ups","Ocurri&oacute; un error: "+response.message)	
			}
		});  
	},
	CalculaSuma:function(arr,Pos){
		var Total = 0
		for(var i = 0; i<arr.length;i++){
			Total = Total + arr[i][Pos]	
		}		
		return Total;
	}
	
}

$(document).ready(function(e) {
    Monitoreo.CargaTabla();
});



</script>

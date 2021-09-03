<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

		
	var sSQLRTI = "SELECT TOP 1 (SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 1 AND OV_Cancelada = 0 AND OV_Test = 0) as Recibidos "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 3 AND OV_Cancelada = 0 AND OV_Test = 0) as Packing "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 5 AND OV_Cancelada = 0 AND OV_Test = 0) as Transito "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 6 AND OV_Cancelada = 0 AND OV_Test = 0) as PrimerIntento "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 7 AND OV_Cancelada = 0 AND OV_Test = 0) as SegundoIntento "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 8 AND OV_Cancelada = 0 AND OV_Test = 0) TercerIntento "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 9 AND OV_Cancelada = 0 AND OV_Test = 0) as Fallido "
		sSQLRTI += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 10 AND OV_Cancelada = 0 AND OV_Test = 0) as Entregado "
		sSQLRTI += " FROM Orden_Venta p "
		sSQLRTI += " WHERE OV_Cancelada = 0 "
		sSQLRTI += " AND OV_Test = 0 "
		
		 
	var rsRTI = AbreTabla(sSQLRTI,1,0)
     if(!rsRTI.EOF){
		var Recibidos = rsRTI.Fields.Item("Recibidos").Value 
		var Packing = rsRTI.Fields.Item("Packing").Value 
		var Transito = rsRTI.Fields.Item("Transito").Value 
		var PrimerIntento = rsRTI.Fields.Item("PrimerIntento").Value 
		var SegundoIntento = rsRTI.Fields.Item("SegundoIntento").Value 
		var TercerIntento = rsRTI.Fields.Item("TercerIntento").Value 
		var Fallido = rsRTI.Fields.Item("Fallido").Value  
		var Entregado = rsRTI.Fields.Item("Entregado").Value
		
		var Total =  Recibidos+Packing+Transito+PrimerIntento+SegundoIntento+TercerIntento+Fallido+Entregado
		//var Total = rsRTI.Fields.Item("Total").Value  
	 }
	


%>

<style>
#example td:hover { 
   background-color: #ccc;
}
.modal {
  overflow-y:auto;
}
</style>
<link href="/Template/inspina/css/plugins/iCheck/blue.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet"> 
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">


<div class="form-horizontal">
    <div class="ibox-content">
        <div class="form-group">
        <%if(SistemaActual == 19){%>
            <div class="btn-group" role="group" aria-label="Basic example">
              <input class="btn btn-info btnEntregaDia" type="button" value="Entrega por dia">
              <input class="btn btn-success btnGenerarReporte"  data-toggle="modal" data-target="#myModalReportePaqueteria" type="button" value="Reporte a paqueteria">
            </div>           
        <%}%>
            <table id="example" class="table table-striped">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Recibidos</th>
                        <th>Packing</th>
                        <th>Transito</th>
                        <th>Primer Intento</th>
                        <th>Segundo Intento</th>
                        <th>Tercer Intento</th>
                        <th>Fallido</th>
                        <th>Entregado</th>
                        <th>Total</th>
                    </tr>
                </thead> 
                <tfoot>
                    <tr>
                        <th>Total</th>
                        <th><%=Recibidos%></th>
                        <th><%=Packing%></th>
                        <th><%=Transito%></th>
                        <th><%=PrimerIntento%></th>
                        <th><%=SegundoIntento%></th>
                        <th><%=TercerIntento%></th>
                        <th><%=Fallido%></th>
                        <th><%=Entregado%></th>
                        <th><%=Total%></th>
                    </tr>
                </tfoot>               
            </table>
        </div>
    </div>
</div>


<div class="modal fade" id="myModalGetFolio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
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
<div class="modal fade modal1" id="myModalVerFolio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-toggle="modal" data-target="#myModalVerFolio" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Vista de folio</h4>
      </div>
      <div class="modal-body" id="modalBodySO">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModalVerFolio">Cerrar</button>
      </div>
    </div>
  </div>
</div>


<div class="modal fade modal1" id="myModalReportePaqueteria" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-md" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">Reporte a paqueter&iacute;a</h4>
      </div>
      <div class="modal-body" id="modalBodyPaqueteria">
            <div class="form-horizontal">
                    <div class="form-group">
                     <label class="control-label col-xs-4" ><strong>Proveedor log&iacute;stico</strong></label>
                        <div class="col-xs-6">
                            <%var sCampo = "Prov_Nombre"
                              var sCond = "Prov_EsPaqueteria = 1 AND Prov_Habilitado = 1"
                                CargaCombo("Prov_ID"," class='form-control col-xs-6' ","Prov_ID",sCampo,
                                "Proveedor",sCond,sCampo,Parametro("Prov_ID",-1),0,"Selecciona","Editar")%>
                        </div> 
                    </div> 
                    <div class="form-group">
                     <label class="control-label col-xs-4" ><strong>Rango</strong></label>
                        <div class="col-md-8">
                          <label class="control-lable col-md-6"><input type="radio" value="1" class="i-checks" name="gpo1" checked>&nbsp;10 AM a 4 PM</label>
                          <label class="control-lable col-md-6"><input type="radio" value="0" class="i-checks" name="gpo1">&nbsp;4 PM a 10 AM</label>
                        </div>
                    </div> 
                    <div class="form-group">
                     <label class="control-label col-xs-4" ><strong>Fecha</strong></label>
                       <div class="input-group col-xs-6">
                         <input class="form-control date-picker Fecha col-xs-6"  placeholder="yyyy-mm-dd" type="text" autocomplete="off" value=""> 
                         <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                       </div> 
                    </div> 
                    <div class="form-group FechaFinal">
                     <label class="control-label col-xs-4" ><strong>Fecha</strong></label>
                       <div class="input-group col-xs-6">
                         <input class="form-control date-picker FechaFinalInput col-xs-6" disabled="disabled"  placeholder="yyyy-mm-dd" type="text" autocomplete="off" value=""> 
                         <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                       </div> 
                    </div> 
            </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModalReportePaqueteria">Cerrar</button>
        <input class="btn btn-info btnGenerar" type="button" value="Reporte">
      </div>
    </div>
  </div>
</div>

<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script type="application/javascript">

$('.FechaFinal').hide()
var jsonMaestro = []
var date = new Date()
var Dia = date.getDate()
if(Dia < 10){
	Dia = "0"+Dia	
}
var Mes = ["01","02","03","04","05","06","07","08","09","10","11","12"]
var Fecha = Dia+""+Mes[date.getMonth()]+""+date.getFullYear()+" "+date.getHours()+"."+date.getMinutes()+" hrs"

$(document).ready(function() {
	
	$('.i-checks').iCheck({ radioClass: 'iradio_square-blue' }); 
	
	$('.i-checks').on('ifChanged', function(event) {	
			if(event.target.checked) {
				console.log(event.target.value)
				$('.FechaFinalInput').val("")
				$('.Fecha').val("")
			} 
	});
	
	
	$('.Fecha').datepicker({
		format: "yyyy-mm-dd",
		language: "es",
		todayHighlight: true,
		autoclose: true
	});
	$('.FechaFinalInput').datepicker({
		format: "yyyy-mm-dd"
	});
	$('.Fecha').change(function(e) {
        $('.FechaFinal').show('slow')
		var fecha = $(this).val()
		var date = new Date(fecha);
		console.log(fecha)
		
		var rango = $('input:radio[name=gpo1]:checked').val()
		if(rango == 0){
			date.setDate(date.getDate() + 2);
			$('.FechaFinalInput').datepicker("setDate" , new Date(date));
		}else{
			date.setDate(date.getDate() + 1);
			$('.FechaFinalInput').datepicker("setDate" , new Date(date));
		}
    });
	
	
	
	
	$(".btn-cierre").on("click", function(){ $(".modal-backdrop").removeClass("modal-backdrop"); });
	
	$(".btnGenerar").click(function(e) {
		var FechaInicio = $('.Fecha').val()
		if(FechaInicio != ""){
			var btn = $(this)
			btn.prop('disabled',true)
			$.post("/pz/wms/OV/DataReportePaqueteria.asp",
			{
				Prov_ID:$('#Prov_ID').val(),
				Rango:$('input:radio[name=gpo1]:checked').val(),
				FechaInicio:$('.Fecha').val(),
				FechaFinal:$('.FechaFinalInput').val()
			}
			  , function(data){
				var response = JSON.parse(data)
				var ws = XLSX.utils.json_to_sheet(response);
				var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
				XLSX.writeFile(wb, "Direcciones Validadas "+$("#Prov_ID option:selected").text()+" "+Fecha+".xlsx");
				btn.prop('disabled',false)
			});  
		}
    });
	
	$(".btnEntregaDia").click(function(e) {
		var btn = $(this)
		btn.prop('disabled',true)
		$.post("/pz/wms/OV/DataEntregaPorDia.asp"
		  , function(data){
			var response = JSON.parse(data)
			var ws = XLSX.utils.json_to_sheet(response);
			var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
			XLSX.writeFile(wb, "Entrega por dia.xlsx");
			btn.prop('disabled',false)
		});  
    });
	
    var table = $('#example').DataTable({
		responsive: true,
		"autoWidth": true,
		"processing": true,
		"scrollY": "350px", 
        "scrollCollapse": true,
        "paging":         false,
		ajax:{
			url: "/pz/wms/OV/DataReporteIzzi.asp",
			 "dataSrc": function ( json ) {
					jsonMaestro = json.data
//					console.log(jsonMaestro)
//				$(".TransitoClass").each(function(index) {
//					
//				});

				  return jsonMaestro;
				}
			},
		columns: [
            { "data": "Fecha" }, 
            { "data": "Recibidos" },
            { "data": "Packing.Num"},
            { "data": "Transito.Num"},
            { "data": "PrimerIntento.Num" },
            { "data": "SegundoIntento.Num" },
            { "data": "TercerIntento.Num" },
            { "data": "Fallido" },
            { "data": "Entregado" },
            { "data": "Total" }
        ],
		rowCallback: function(row, data, index) {
		  //console.log(row)
			if(data.Packing.Class != ""){
					  $('td:eq(2)', row).addClass(data.Packing.Class)
			}
			if(data.Transito.Class != ""){
					  $('td:eq(3)', row).addClass(data.Transito.Class)
			}
			if(data.PrimerIntento.Class != ""){
					  $('td:eq(4)', row).addClass(data.PrimerIntento.Class)
			}
			if(data.SegundoIntento.Class != ""){
					  $('td:eq(5)', row).addClass(data.SegundoIntento.Class)
			}
			if(data.TercerIntento.Class != ""){
					  $('td:eq(6)', row).addClass(data.TercerIntento.Class)
			}

//		  $(row).find('td.TransitoClass').each(function() {
//			  
//				var dato = parseInt($(this).text())
//				var Fechas = Date.parse(data.Fecha)
//				var fecha = $(this).attr('data-fecha',Fechas)
//				
//				console.log($(this))
//								
//				if(dato > 0)
//					$(this).addClass('warning')
//			}); 
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
		console.log(rowData[0]);
		$(".selected").attr("data-toggle", "modal");
		$(".selected").attr("data-target", "#myModalGetFolio");
		var loading = '<div class="spiner-example"><div class="sk-spinner sk-spinner-rotating-plane"></div></div>'
		$('#modalBodyFolio').html(loading)
		$('#myModalLabel').html("Resumen de d&iacute;a <strong>"+rowData[0].Fecha+"</strong>" )
		$.post("/pz/wms/OV/ReporteTipoIzzi_Folios.asp"
		  ,{Fecha:rowData[0].Fecha,
		  Recibidos:rowData[0].Recibidos,
		  Packing:rowData[0].Packing.Num,
		  Transito:rowData[0].Transito.Num,
		  PrimerIntento:rowData[0].PrimerIntento.Num,
		  SegundoIntento:rowData[0].SegundoIntento.Num,
		  TercerIntento:rowData[0].TercerIntento.Num,
		  Fallido:rowData[0].Fallido,
		  Entregado:rowData[0].Entregado
		  	}
		  , function(data){
			$('#modalBodyFolio').html(data)
		});  

		
	});	
	
		
});




</script>

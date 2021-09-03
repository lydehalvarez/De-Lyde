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
</style>
<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet"> 
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
<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
<script type="application/javascript">

var loading = '<div class="spiner-example"><div class="sk-spinner sk-spinner-rotating-plane"></div></div>'

$(document).ready(function() {
	$(".btn-cierre").on("click", function(){ $(".modal-backdrop").removeClass("modal-backdrop"); });
	
    var table = $('#example').DataTable({
		responsive: true,
		"autoWidth": true,
		"processing": true,
		"scrollY": "350px", 
        "scrollCollapse": true,
        "paging":         false,
		ajax:{
			url: "/pz/wms/OV/DataReporteIzzi.asp"
			},
		columns: [
            { "data": "Fecha" }, 
            { "data": "Recibidos" },
            { "data": "Packing"},
            { "data": "Transito.Num"},
            { "data": "PrimerIntento.Num" },
            { "data": "SegundoIntento.Num" },
            { "data": "TercerIntento.Num" },
            { "data": "Fallido" },
            { "data": "Entregado" },
            { "data": "Total" }
        ],
		rowCallback: function(row, data, index) {
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
		$(".selected").attr("data-backdrop", "static");
		$('#modalBodyFolio').html(loading)
		$('#myModalLabel').html("Resumen de d&iacute;a <strong>"+rowData[0].Fecha+"</strong>" )
		$.post("/pz/wms/OV/ReporteTipoIzzi_Folios.asp"
		  ,{Fecha:rowData[0].Fecha,
		  Recibidos:rowData[0].Recibidos,
		  Packing:rowData[0].Packing,
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

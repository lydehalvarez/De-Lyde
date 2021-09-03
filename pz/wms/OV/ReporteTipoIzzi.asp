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
<link href="/Template/inspina/css/plugins/dataTables/datatables.min.css" rel="stylesheet"> 
<div class="form-horizontal">

    <div class="row" id="Boxes"></div>
    <div class="ibox-content" id="GridTipoIzzi"></div>
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


<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">


var loading = '<div class="spiner-example"><div class="sk-spinner sk-spinner-rotating-plane"></div></div>'
var jsonMaestro = []
$(document).ready(function() {
	
	ReporteTipoIzzi.Boxes()
	ReporteTipoIzzi.CargaGridTipoIzzi(0)
		
});

var ReporteTipoIzzi = {
		Boxes:function(){
			$('#Boxes').html(loading)
			$.post("/pz/wms/OV/ReporteTipoIzzi_Boxes.asp",function(data){
				$('#Boxes').html(data)
			});  
		},
		CargaGridTipoIzzi:function(Estatus){
			$('#GridTipoIzzi').html(loading)
			$.post("/pz/wms/OV/ReporteTipoIzzi_Grid.asp",function(data){
				$('#GridTipoIzzi').html(data)
			});  
		}
	}




</script>

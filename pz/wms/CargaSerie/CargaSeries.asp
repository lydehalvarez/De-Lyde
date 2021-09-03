<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<div class="form-horizontal" id="frmFicha">
    <div class="ibox">
        <div class="ibox-content">
            <div class="form-group">
            <input class="fileinput fileinput-new" type="file" id="fileUploader" name="fileUploader" accept=".xls, .xlsx"/>
            </div>
            <div class="form-group">
            <label class="from-control col-md-3" id="jsonObject">Revisi&oacute;n general</label>
                <div class="col-md-6" id="Botones">
                    <button class="btn btn-danger btnRetry">Intentar de nuevo</button>
                    <button class="btn btn-success btnAceptar">Confirmar carga</button>
                </div>
            </div>
               <table class="table table-striped table-bordered table-hover" id="Actividades" >
                <thead>
                    <tr>
                        <th>CodigoIdentificador</th>   
                        <th>AlmacenOrigen</th>
                        <th>AlmacenDestino</th>
                        <th>UbicacionTienda</th>
                        <th>HorarioAtencion</th>
                        <th>TipoAcceso</th>
                        <th>Responsable</th>
                        <th>Celular</th>
                        <th>Email</th>
                     </tr>
                </thead>
                <tbody id="bodySucur">
                </tbody>
            </table>
               <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>CodigoIdentificador</th>
                        <th>Sku</th>
                        <th>Cantidad</th>   
                     </tr>
                </thead>
                <tbody id="bodyProd">
                </tbody>
            </table>
         </div>
    </div>
</div>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="application/javascript">


$(document).ready(function(e) {
	
});

$("#fileUploader").change(function(evt){
	//$('#bodyTransferencias').html('<tr id="CargandoDatos"><td align="center" colspan="8"><img src="/Img/ajaxLoader.gif"/></td></tr>')
	var selectedFile = evt.target.files[0];
	var reader = new FileReader();
	reader.onload = function(event) {
	  var data = event.target.result;
	  var workbook = XLSX.read(data, {
		  type: 'binary',
		  cellDates: true
	  });
	  var Hoja1 = workbook.SheetNames[0];
	  
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  
	  
	  console.log(json_object1)
	  //console.log(json_object2)
	  //console.log(json_object2)
	  
		$.each(json_object1, function(i, item) {
			item['Tarea'] = 1
			var $tr = $('<tr>').append(
				$('<td>').text(item.CodigoIdentificador),
				$('<td>').text(item.AlmacenOrigen),
				$('<td>').text(item.AlmacenDestino),
				$('<td>').text(item.UbicacionTienda),
				$('<td>').text(item.HorarioAtencion),
				$('<td>').text(item.TipoAcceso),
				$('<td>').text(item.Responsable),
				$('<td>').text(item.Celular),
				$('<td>').text(item.Email)
			).appendTo('#bodySucur');		
			EncabezadoTransferencia(item)
			console.log(item)
			
		});
			  
		
	  
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});

 var NumeroE = 0
 var NumeroF = 0
 
 

</script>





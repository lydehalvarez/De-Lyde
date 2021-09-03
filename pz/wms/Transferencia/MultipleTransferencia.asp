<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	TA_ArchivoID = BuscaSoloUnDato("ISNULL((MAX(TA_ArchivoID)),0)+1","TransferenciaAlmacen_Archivo","",-1,0)
%>


<div class="form-horizontal" id="frmFicha">
    <div class="ibox">
        <div class="ibox-content">
            <div class="form-group">
            <input class="fileinput fileinput-new" type="file" id="fileUploader" name="fileUploader" accept=".xls, .xlsx"/>
            <div id="Elementos_repetidos"></div>
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
	
	$(".btnRetry").click(function(e) {
		e.preventDefault()
	});
	$(".btnAceptar").click(function(e) {
		e.preventDefault()
		CargaVentanaPicking(<%=TA_ArchivoID%>)
	});
});



var Transfer = {}
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
	  var Hoja2 = workbook.SheetNames[1];
	  
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  var worksheet2 = workbook.Sheets[Hoja2];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  var json_object2 =  XLSX.utils.sheet_to_json(worksheet2);
	  
	  Transfer["Sucursal"] = json_object1
	  Transfer["Articulos"] = json_object2
	  
	  //console.log(json_object1)
	  //console.log(json_object2)
	  //console.log(json_object2)
	  
		$.each(json_object1, function(i, item) {
			item['TA_ArchivoID'] = <%=TA_ArchivoID%>
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
			  
		$.each(json_object2, function(i, item) {
			item['Tarea'] = 2
			item['TA_ArchivoID'] = <%=TA_ArchivoID%>
			var $tr = $('<tr>').append(
				$('<td>').text(item.CodigoIdentificador),
				$('<td>').text(item.SKU),
				$('<td>').text(item.Cantidad)
			).appendTo('#bodyProd');
			ArticulosTransferencia(item)
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
 
 
function EncabezadoTransferencia(datos){
	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",datos
    , function(data){
			console.log(data)
	});
}
function ArticulosTransferencia(datos){
	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",datos
    , function(data){
			console.log(data)
	});
}

function CargaVentanaPicking(ArchID){
	$.post("/pz/wms/Transferencia/PickingTransferencia.asp",{
		TA_ArchivoID:ArchID
	}
    , function(data){
		if(data != ""){
			$('#Transferencia').html(data)
		}
	});
}

function removeDuplicates(originalArray, prop) {
     var newArray = [];
     var lookupObject  = {};

     for(var i in originalArray) {
        lookupObject[originalArray[i][prop]] = originalArray[i];
		NumeroE = NumeroE + 1
     }

     for(i in lookupObject) {
         newArray.push(lookupObject[i]);
		 NumeroF = NumeroF + 1
     }
	 NumeroF = NumeroE - NumeroF 
      return newArray;
}

</script>


<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
var TA_ID = Parametro("TA_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Cli_ID = Parametro("Cli_ID",1)
	if(CliOC_ID > -1){
   	var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
         sSQL1 += "inner join cliente c on p.Cli_ID=c.Cli_ID "
	   	 sSQL1 += "inner join  Cliente_OrdenCompra_Articulos a  on p.Pro_ID = a.Pro_ID "
	     sSQL1 += " where a.CliOC_ID = " + CliOC_ID 
		 sSQL1 += " GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		    var rsPro = AbreTabla(sSQL1,1,0)
		}
		if(OC_ID > -1){
   	       var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Proveedor p "
               sSQL1 += "inner join proveedor c on p.Prov_ID=c.Prov_ID "
			   sSQL1 += "inner join  Proveedor_OrdenCompra_Articulos a on p.Pro_ID = a.Pro_ID  "
	           sSQL1 += " where a.OC_ID = " + OC_ID 
		       sSQL1 += " GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
            
		    var rsPro = AbreTabla(sSQL1,1,0)
		}
		 if(TA_ID > -1){
		    var sSQL1  = "select p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
                sSQL1 += "inner join cliente c on p.Cli_ID=c.Cli_ID "
		        sSQL1 += "inner join  TransferenciaAlmacen_Articulos a  on p.Pro_ID = a.Pro_ID  "
	            sSQL1 += " where a.TA_ID = " + TA_ID 
		        sSQL1 += " GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		 
            var rsPro = AbreTabla(sSQL1,1,0)
		 }


%>
   <div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">

                                               <div class="form-group">
                            <label class="control-label col-md-2">Producto  </label>
                            <div class="col-md-3">
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
<div class="form-group">
            <input class="fileinput fileinput-new" type="file" id="fileUploader" name="fileUploader" accept=".xls, .xlsx"/>
            <div id="Elementos_repetidos"></div>
            </div>
            <div class="form-group">
            <label class="from-control col-md-3" id="jsonObject">Revisi&oacute;n general</label>
                <div class="col-md-6" id="Botones">
           
                      <input type="text" value="<%=CliOC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="CliOC_ID">
                     <input type="text" value="<%=OC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="OC_ID">
                        <input type="text" value="<%=Prov_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Prov_ID">
                        <input type="text" value="<%=Pro_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Pro_ID">
                                <input type="text" value="<%=TA_ID%>"  style="display:none;width:150%"  class="objAco agenda"  id="TA_ID">
                               <input type="text" value="<%=Cli_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Cli_ID">
                </div>
                <table class="table" id="Actividades" >
                <thead>
                    <tr>
                        <th>Numero</th>   
                        <th>Serie</th>
 
                     </tr>
                </thead>
                <tbody id="bodySeries">
                </tbody>
            </table>
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
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
		  
		  Transfer["Articulos"] = json_object1
	  
	  //console.log(json_object1)
	  //console.log(json_object2)
	  //console.log(json_object2)

	  
		$.each(json_object1, function(i, item) {

			item['CliOC_ID'] = $('#CliOC_ID').val()
			item['OC_ID'] = $('#OC_ID').val()
			item['Prov_ID'] = $('#Prov_ID').val()
			item['Cli_ID'] = $('#Cli_ID').val()
			item['TA_ID'] = $('#TA_ID').val()
			item['Pro_ID'] = $('#cboPro_ID').val()
			
			var $tr = $('<tr>').append(
				$('<td>').text(item.Numero),
				$('<td>').text(item.Serie)
		
			).appendTo('#bodySeries');		
			EncabezadoSeries(item)
			//console.log(item)
			
		});
			  
			  
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});

 var NumeroE = 0
 var NumeroF = 0
 
 
function EncabezadoSeries(datos){

	//$.post("/pz/wms/Recepcion/RecepcionCargaSeries_Ajax.asp",datos);
    
    $.ajax({
      type: 'POST',
      url: "/pz/wms/Recepcion/RecepcionCargaSeries_Ajax.asp",
      data: datos,
//      success: success,
//      dataType: dataType,
      async:false
    });
}

});




       

// Function to download data to a file



</script>
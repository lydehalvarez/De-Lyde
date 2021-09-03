<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

var Cli_ID = Parametro("Cli_ID",1)
var Pro_PesoBruto = 0
var Pro_PesoBrutoMB = 0
var Pro_PesoBrutoPt = 0
var Pro_PesoNeto = 0
var Pro_PesoNetoMB = 0
var Pro_PesoNetoPt = 0

   	 var sSQL1  = "SELECT Pro_ID, Pro_Cantidad, Pro_Nombre, Pro_DimAlto, Pro_DimLargo, Pro_DimAncho, Pro_PesoBruto, "
	 sSQL1 += "Pro_PesoNeto FROM Producto WHERE TPro_ID = 4"
	 var rsMB = AbreTabla(sSQL1,1,0)
	
		 	%>


<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                    <div class="modal-body">
         <div class="form-horizontal">

<div class="modal-body">
         <div class="form-horizontal">
          <div class="form-group">
               <div class="col-md-3">
               <div class='external-event navy-bg' id="BtnGuardar"  style="width:35%">Guardar</div>
               </div>
               </div>
               <div class="ibox-content" id="dvActivos">
                    
                       </div>
          <div class="form-group">
                <label class="control-label col-md-2"><strong>SKU</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_SKU" placeholder="" type="text" autocomplete="off" value=""/> 
               </div>
               <label class="control-label col-md-2"><strong>Nombre</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_Nombre" placeholder="Producto" type="text" autocomplete="off" value=""></input>
				</div>
               </div>
 		<div class="form-group">
                <label class="control-label col-md-2"><strong>Descripcion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_Descripcion" placeholder="" type="text" autocomplete="off" value=""/> 
               </div>
               <label class="control-label col-md-2"><strong>Tipo ABC</strong></label>
                <div class="col-md-3">
					<select id="Pro_Tipo_ABC" class="form-control agenda">
                  <option value="A">A</option>
                  <option value="B">B</option>
                  <option value="C">C</option>
                   </select>	
                       </div>
                </div>
               <div class="form-group">
               <label class="control-label col-md-2"><strong>Clave</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="ProC_Clave" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2" ><strong>Foto</strong></label>
                <div class="col-md-3">
				<input class="fileinput fileinput-new" type="file" id="Ruta_Foto" name="fileUploader" accept=".jpg, .png"/>
               </div>
               
               </div>
               <div class="form-group">
             <label class="control-label col-md-2" ><strong>Seleccion a granel</strong></label>
                <div class="col-md-3">
                <input id="ProC_PermitirSeleccionAGranel"  type="checkbox" value ="0"></input>
               </div>
             <label class="control-label col-md-2"><strong>Materia prima</strong></label>
                <div class="col-md-3">
                <input id="ProC_EsMateriaPrima"  type="checkbox"  value ="0"></input>
				</div>
               </div>
               <div class="form-group">
               <label class="control-label col-md-2" ><strong>Kit</strong></label>
                <div class="col-md-3">
                <input id="ProC_EsKit"  type="checkbox"  value ="0"></input>
               </div>
             <label class="control-label col-md-2"><strong>Producido</strong></label>
                <div class="col-md-3">
                <input id="ProC_EsProducido"  type="checkbox"  value ="0"></input>
				</div>
               </div>
               <div class="form-group">
               <label class="control-label col-md-2" ><strong>FIFO</strong></label>
                <div class="col-md-3">
                <input id="ProC_FIFO"  type="checkbox"  value ="0"></input>
               </div>
             <label class="control-label col-md-2"><strong>LIFO</strong></label>
                <div class="col-md-3">
                <input name="ProC_LIFO"  id="ProC_LIFO" type="checkbox"  value ="0"></input>
				</div>
               </div>
                 <div class="form-group">
               <label class="control-label col-md-2" ><strong>Stock minimo</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="ProC_StockMinimo" placeholder="" type="text" autocomplete="off" value=""></input>
               </div>
               <label class="control-label col-md-2" ><strong>Habilitado</strong></label>
                <div class="col-md-3">
                <input name="ckbHabilitado" id="Pro_Habilitado"  type="checkbox" value ="0"></input>
               </div>
               </div>
               <div class="form-group">
                <label class="control-label col-md-2"><strong>Stock maximo</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="ProC_StockMaximo" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
             <label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAlto" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
               </div>
             <div class="form-group">
                <label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
               <label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
               
                </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Peso bruto caja</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_PesoBruto" placeholder="kg" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2"><strong>Peso neto caja</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_PesoNeto" placeholder="kg" type="text" autocomplete="off" value=""></input>
				</div>
            </div>
                     
         <div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
           <div class="form-group" >
                            <label class="control-label col-md-2">Masterbox</label>
                            <div class="col-md-3">
                	<select id="cboMB" class="form-control agenda">
                      <option value="-1" >--Seleccionar--</option>
                  <%
                    while (!rsMB.EOF){
	      var Pro_ID =  rsMB.Fields.Item("Pro_ID").Value 
		  Pro_Cantidad =  rsMB.Fields.Item("Pro_Cantidad").Value 
	      Pro_Nombre =  rsMB.Fields.Item("Pro_Nombre").Value 
		  Pro_DimAlto =  rsMB.Fields.Item("Pro_DimAlto").Value
		  Pro_DimLargo =  rsMB.Fields.Item("Pro_DimLargo").Value
		  Pro_DimAncho =  rsMB.Fields.Item("Pro_DimAncho").Value
		  Pro_PesoNeto =  rsMB.Fields.Item("Pro_PesoNeto").Value
				 
%>
            <option value="<%=Pro_ID%>"><%=Pro_Nombre%> (cantidad cajas: <%=Pro_Cantidad%>, alto: <%=Pro_DimAlto%> cm, largo:<%=Pro_DimLargo%> cm, ancho:<%=Pro_DimAncho%> cm, peso: <%=Pro_PesoNeto%> kg)</option>
                  <%	
						rsMB.MoveNext() 
					}
                rsMB.Close()  
		 
                %>
                  </select>
                   </div>
                         <div class="col-md-3">
                   <div class='external-event navy-bg' id="NvoMB"  style="width:40%">+ Nuevo</div>
</div>
   <div class="row" id= "divMB" style="display:none;">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
            <div class="form-group">
                   <label class="control-label col-md-3"><strong>Nuevo Masterbox</strong></label>
                <div class="col-md-3">
				</div>
                <label class="control-label col-md-1"><strong>Tipo</strong></label>
                <div class="col-md-3">
					<select id="Pro_TipoMB" class="form-control agenda">
                  <option value="Extra chica">Extra chica</option>
                  <option value="Chica">Chica</option>
                  <option value="Mediana">Mediana</option>
                  <option value="Grande">Grande</option>
                </select>	
                			</div>
                </div>
                 <div class="form-group">
                   <label class="control-label col-md-2"><strong>Cantidad Productos</strong></label>
                <div class="col-md-3">
                <input class="form-control Pro_CantidadMB agenda" id="Pro_CantidadMB" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAlto2" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo2" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
                <label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho2" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Peso bruto por caja (kg)</strong></label>
                <div class="col-md-3">
              <label class="control-label col-md-2"  value="" id="Pro_PesoBruto2"><strong></strong> </label>
                       </div>
                <label class="control-label col-md-2"><strong>Peso neto por caja (kg)</strong></label>
                <div class="col-md-3">
                <label class="control-label col-md-2"  value="" id="Pro_PesoNeto2"><strong></strong> </label>
				</div>
                     </div>
                    </div>
                 </div>
             </div>
       </div>
       </div>
                    </div>
                 </div>
             </div>
       </div>
       </div>
       <div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                     <div class="form-group">
                            <label class="control-label col-md-2">Pallet</label>
                            <div class="col-md-3">
                	<select id="cboPallet" class="form-control agenda">
                      <option value="-1"  >--Seleccionar--</option>
                  <%
				     	 var sSQL1  = "SELECT Pro_ID, Pro_Cantidad, Pro_Nombre, Pro_DimAlto, Pro_DimLargo, Pro_DimAncho, Pro_PesoBruto, "
	 sSQL1 += "Pro_PesoNeto FROM Producto WHERE TPro_ID = 5"
	 var rsPt = AbreTabla(sSQL1,1,0)
                    while (!rsPt.EOF){
          var Pro_ID =  rsPt.Fields.Item("Pro_ID").Value 
    	  Pro_Cantidad =  rsPt.Fields.Item("Pro_Cantidad").Value 
	      Pro_Nombre =  rsPt.Fields.Item("Pro_Nombre").Value 
		  Pro_DimAlto =  rsPt.Fields.Item("Pro_DimAlto").Value
		  Pro_DimLargo =  rsPt.Fields.Item("Pro_DimLargo").Value
		  Pro_DimAncho =  rsPt.Fields.Item("Pro_DimAncho").Value
		  Pro_PesoNeto =  rsPt.Fields.Item("Pro_PesoNeto").Value
				 
%>

                  <option value="<%=Pro_ID%>"><%=Pro_Nombre%> (cantidad cajas: <%=Pro_Cantidad%>, alto: <%=Pro_DimAlto%> cm, largo:<%=Pro_DimLargo%> cm, ancho:<%=Pro_DimAncho%> cm, peso: <%=Pro_PesoNeto%> kg)</option>
                  <%	
						rsPt.MoveNext() 
					}
                rsPt.Close()  
		 
                %>
                  </select>
                        
                  </div>
                    <div class="col-md-3">
                                         <div class='external-event navy-bg' id="NvoPallet"  style="width:40%">+ Nuevo</div>
</div>
                  </div>
                
                  
                     <div class="row" id="divPallet" style="display:none;">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-content">
                    <div class="form-group">
                   <label class="control-label col-md-2"><strong>Nuevo Pallet</strong></label>
                <div class="col-md-3">
				</div>
                <label class="control-label col-md-2"><strong>Tipo</strong></label>
                <div class="col-md-3">
					<select id="Pro_TipoPt" class="form-control agenda">
                  <option value="Madera">Madera</option>
                  <option value="Plastico">Plastico</option>
                  <option value="x">x</option>
                  </select>	
                			</div>
                </div>
                       <div class="form-group">
               <label class="control-label col-md-2" ><strong>Cantidad cajas</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_CantidadPt" placeholder="" type="text" autocomplete="off" value=""></input>
                 </div>
               <label class="control-label col-md-2"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo3" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
               </div>
             <div class="form-group">
               <label class="control-label col-md-2"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho3" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-2"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control Pro_DimAlto3 agenda" id="Pro_DimAlto3" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                   </div>
                   <div class="form-group">
               <label class="control-label col-md-2"><strong>Peso bruto por caja (kg)</strong></label>
                <div class="col-md-3">
              <label class="control-label col-md-2"  value="" id="Pro_PesoBruto3"><strong></strong></label>
                       </div>
                <label class="control-label col-md-2"><strong>Peso neto por caja (kg)</strong></label>
                <div class="col-md-3">
                <label class="control-label col-md-2"  value="" id="Pro_PesoNeto3"><strong></strong></label>
				</div>
                  
        </div>   
      </div>
     </div>
      
      </div>
    </div>
    </div>
     </div>
      
      </div>
    </div>      
    
  </div>
 </div>     
				
</div>
</div>
 </div>
    </div>      
    
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
	
	$('#NvoMB').click(function(e) {
	$('.Robin').attr('disabled',false)
	var  div = document.getElementById('divMB');
    div.style.display = '';

});
		$('#NvoPallet').click(function(e) {
	$('.Robin').attr('disabled',false)
	var  div = document.getElementById('divPallet');
    div.style.display = '';

});
	
$('.Pro_DimAlto3').on('change',function(e) {
	e.preventDefault()
	var Alto = $('#Pro_DimAlto3').val() / $('#Pro_DimAlto2').val()
	var Largo = $('#Pro_DimLargo3').val() / $('#Pro_DimLargo2').val()
	var Ancho = $('#Pro_DimAncho3').val() / $('#Pro_DimAncho2').val()
	var Cantidad = (Alto * Ancho) * Largo
	Cantidad = Math.floor(Cantidad)
	$('#Pro_CantidadPt').val(Cantidad)
	var PesoPt = Cantidad * $('#Pro_PesoNeto2').text()
	var PesoPt2 = Cantidad * $('#Pro_PesoBruto2').text()
	$('#Pro_PesoBruto3').text(PesoPt2)
	$('#Pro_PesoNeto3').text(PesoPt)
});
$('.Pro_CantidadMB').on('change',function(e) {
	e.preventDefault()
	var PesoMB = $('#Pro_CantidadMB').val() * $('#Pro_PesoNeto').val()
	var PesoMB2 = $('#Pro_CantidadMB').val() * $('#Pro_PesoBruto').val()
	
	$('#Pro_PesoBruto2').text(PesoMB2)
	$('#Pro_PesoNeto2').text(PesoMB)
});

	 $('#BtnGuardar').click(function(e) {
        e.preventDefault()
			 $("#BtnGuardar").hide();
		var datosActivo = {}
		$('.agenda').each(function(index, element) {
            datosActivo[$(this).attr('id')] = $(this).val()
        });
		datosActivo['Tarea'] = 1
        datosActivo['Cli_ID'] = $('#Cli_ID').val()
		datosActivo['Pro_SKU'] = $('#Pro_SKU').val()
		datosActivo['Pro_Nombre'] = $('#Pro_Nombre').val()
		datosActivo['Pro_Descripcion'] = $('#Pro_Descripcion').val()
		datosActivo['ProC_Clave'] = $('#ProC_Clave').val()
		 var ProC_PermitirSeleccionAGranel = 0
		if( $('#ProC_PermitirSeleccionAGranel').prop('checked') ) {
     ProC_PermitirSeleccionAGranel = 1
	}
		datosActivo['ProC_PermitirSeleccionAGranel'] = $('#ProC_PermitirSeleccionAGranel').val()
		
		  var ProC_EsMateriaPrima = 0
		if( $('#ProC_EsMateriaPrima').prop('checked') ) {
     ProC_EsMateriaPrima = 1
	}
		datosActivo['ProC_EsMateriaPrima'] =ProC_EsMateriaPrima
		  var ProC_EsKit = 0
		if( $('#ProC_EsKit').prop('checked') ) {
     ProC_EsKit = 1
	}
		datosActivo['ProC_EsKit'] = ProC_EsKit
		  var ProC_EsProducido = 0
		if( $('#ProC_EsProducido').prop('checked') ) {
     ProC_EsProducido = 1
	}
		datosActivo['ProC_EsProducido'] = ProC_EsProducido
		  var ProC_FIFO = 0
		if( $('#ProC_FIFO').prop('checked') ) {
     ProC_FIFO = 1
	}
		datosActivo['ProC_FIFO'] =ProC_FIFO
		  var ProC_LIFO = 0
		if( $('#ProC_LIFO').prop('checked') ) {
     ProC_LIFO = 1
	}
		datosActivo['ProC_LIFO'] =ProC_LIFO
		datosActivo['ProC_StockMinimo'] = $('#ProC_StockMinimo').val()
		datosActivo['ProC_StockMaximo'] = $('#ProC_StockMaximo').val()
		  var Pro_Habilitado = 0
		if( $('#Pro_Habilitado').prop('checked') ) {
     Pro_Habilitado = 1
	}
		datosActivo['Pro_Habilitado'] = Pro_Habilitado
		
			var input = document.getElementById("Ruta_Foto");
		var file = input.value.split("\\");
		var fileName = file[file.length-1];
		 datosActivo['ProC_RutaFoto'] =fileName
		 datosActivo['ProC_StockMinimo'] =$('#ProC_StockMinimo').val(); 
		 datosActivo['ProC_StockMaximo'] =$('#ProC_StockMaximo').val(); 
		    datosActivo['Pro_PesoBruto'] = $('#Pro_PesoBruto').val()
		datosActivo['Pro_PesoNeto'] = $('#Pro_PesoNeto').val()
		datosActivo['Pro_DimAlto'] = $('#Pro_DimAlto').val()
		datosActivo['Pro_DimLargo'] = $('#Pro_DimLargo').val()
		datosActivo['Pro_DimAncho'] = $('#Pro_DimAncho').val()
		
		datosActivo['cboMB'] = $('#cboMB').val()
	   	datosActivo['Pro_CantidadMB'] = $('#Pro_CantidadMB').val()
		datosActivo['Pro_TipoMB'] = $('#Pro_TipoMB').val()
	    datosActivo['Pro_PesoBruto2'] = $('#Pro_PesoBruto2').text()
		datosActivo['Pro_PesoNeto2'] = $('#Pro_PesoNeto2').text()
		datosActivo['Pro_DimAlto2'] = $('#Pro_DimAlto2').val()
		datosActivo['Pro_DimLargo2'] = $('#Pro_DimLargo2').val()
		datosActivo['Pro_DimAncho2'] = $('#Pro_DimAncho2').val()
		
		datosActivo['cboPallet'] = $('#cboPallet').val()
		datosActivo['Pro_CantidadPt'] = $('#Pro_CantidadPt').val()
		datosActivo['Pro_TipoPt'] = $('#Pro_TipoPt').val()
	    datosActivo['Pro_PesoBruto3'] = $('#Pro_PesoBruto3').text()
		datosActivo['Pro_PesoNeto3'] = $('#Pro_PesoNeto3').text()
		datosActivo['Pro_DimAlto3'] = $('#Pro_DimAlto3').val()
		datosActivo['Pro_DimLargo3'] = $('#Pro_DimLargo3').val()
		datosActivo['Pro_DimAncho3'] = $('#Pro_DimAncho3').val()
				
		Guardar(datosActivo)
	
	    });
	function Guardar(Evento){
			$("#dvActivos").load("/pz/wms/Cliente/ProductoCliente_Ajax.asp",Evento
    , function(data){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
	});
}
		

});




       

// Function to download data to a file



</script>
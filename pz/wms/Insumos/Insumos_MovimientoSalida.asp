<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<div class="form-horizontal" id="toPrint">
	<div class="row">
        
        
        <!--<div class="ibox">
            <div class="ibox-content">
                <div class="form-group">
                    <div class="col-md-10">
                        <a  class="text-muted btnRegresar">
                        <i class="fa fa-inbox"></i>&nbsp;<strong>Regresar</strong></a>          
                    </div>
                </div>    
            </div> 
        </div>-->
        
        
		<div class="col-lg-9">
			<div class="ibox float-e-margins">
				<div class="ibox-content">
					<div class="form-group">
						<legend class="control-label col-md-12" style=
						"text-align: left;"></legend>
						<h1><legend class="control-label col-md-12" style=
						"text-align: left;">Movimiento de insumos</legend></h1>
					</div>
					<div style="overflow-y: scroll; height:655px; width: auto;">
					
						<div class="ibox-content" id="dvMovimiento">
							<div class="table-responsive">
								<input id="Limiteishon" type="hidden" value="">
								<table class="table shoping-cart-table">
									<tbody>
										<tr>
											<td class="desc">
												<input class="btn btn-info btnIngresar" id="btnIngresar" type="button" value="+ Nueva Salida">
											</td>
											</tr>
									</tbody>
								</table>
							</div>
						</div>
                        
						<table class="table">
							<thead>
								<tr>
									<th>Folio</th>
									<th>Producto</th>
									<th>Movimiento</th>
									<th>Cantidad</th>
								</tr>
							</thead>
							<tbody>
<%

sSQL =" SELECT m.*, c.Cat_Nombre, p.Pro_Nombre FROM Producto_Movimiento m "
		+	" INNER JOIN Producto p ON p.Pro_ID = m.Pro_ID INNER JOIN Cat_Catalogo c ON c.Cat_ID=m.ProM_TipoCG170"
sSQL += " WHERE CAST(ProM_FechaRegistro as DATE) = CAST(getdate() as DATE)  AND c.Sec_ID  = 170 AND ProM_TipoCG170 <>1"
var rsMovimiento = AbreTabla(sSQL, 1, 0)


            while(!rsMovimiento.EOF){ 
			  var Folio = rsMovimiento.Fields.Item("ProM_ID").Value
			  var Pro_ID = rsMovimiento.Fields.Item("Pro_ID").Value
			  var Producto = rsMovimiento.Fields.Item("Pro_Nombre").Value 
			  var Cantidad = rsMovimiento.Fields.Item("ProM_Cantidad").Value 
			  var Movimiento = rsMovimiento.Fields.Item("Cat_Nombre").Value 
		
		
        %>	
    
            <tr>
           		 <td><%=Folio%></td>
                <td><%=Producto%></td>
                <td><%=Movimiento%></td>
               <td><%=Cantidad%></td>
                <td>
                
                  <span class="pull-right"> <a  data-folio="<%=Folio%>"  class="text-muted btnEliminar"><i class="fa fa-trash-o"></i>&nbsp;<strong>|</strong></a></span>
                  <span class="pull-right"> <a   data-folio="<%=Folio%>" class="text-muted btnImprime"><i class="fa fa-print"></i>&nbsp;<strong>|&nbsp;</strong></a></span>
<!--                <a data-folio="<%=Folio%>"  data-proid="<%=Pro_ID%>"  class="text-muted btnEscaneo"><i class="fa fa-inbox"></i>&nbsp;<strong>Escanear </strong></a>
-->                
                </td>
            </tr>
        <%	
            rsMovimiento.MoveNext() 
        }
        rsMovimiento.Close()
	
   		%>
           
    </tbody>
</table>

                </div>

            </div>
            
        </div>
        
    </div>    
           
                
           


  <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
               
         <table class="table">
    <thead>
        <tr>
            <th class="text-center">Folios</th>
            <th></th>
           
            
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="text-center">-</td>
            <td>Pendiente</td>
           
          </td>
        </tr>
		 </tbody>
</table>
                     </div>
                    </div>
                   </div>
                </div>
                </div>
</div>


<div class="modal inmodal fade in" tabindex="-1" id="MovimientoModal" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success">
        <div class="col-md-3">
            <h5 class="modal-title" style="color:#FFF">Nuevo Movimiento</h5>
        </div>
        <div class="col-md-9">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i style="color:#FFF" class="fa fa-times"></i></button>
        </div>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
             <div class="form-group">

               <label class="control-label col-md-3"><strong>Producto</strong></label>
<!--                
                Arreglar cambiar por combo
-->                
                <div class="col-md-4">
                <select id="cboProducto" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
		<%
				
					var sSQL = "SELECT * FROM Producto  WHERE Pro_EsInsumo=1  AND Pro_Habilitado =1 "
           // Response.Write(sSQL)
			rsArt = AbreTabla(sSQL,1,0)
			while (!rsArt.EOF){
				var Pro_ID =  rsArt.Fields.Item("Pro_ID").Value 
				Pro_Nombre =  rsArt.Fields.Item("Pro_Nombre").Value 
			%>
                  <option value="<%=Pro_ID%>" ><%=Pro_Nombre%></option>
		  <%	
			 rsArt.MoveNext() 
				}
			rsArt.Close()   	
			%>
                    </select>
                    </div>
<!--                
                Arreglar
-->                
                    
            </div>
                      
            <div class="form-group">
                <label class="control-label col-md-3"><strong>SKU</strong></label>
                <div class="col-md-9" id="divSKU"></div>
            </div> 
             <div class="form-group">
                <label class="control-label col-md-3"><strong>Movimiento</strong></label>
                <div class="col-md-3">
            
	   <%
	   
	      					   var sEventos = "class='form-control combman'"
                                var sCondicion = "Cat_ID <> 1 AND Sec_ID = 170"
                                CargaCombo("CboEstatus", sEventos, "Cat_ID","Cat_Nombre","Cat_Catalogo",sCondicion,"","Editar",0,"--Seleccionar--")
                       
                      
							%>
                </div>
                <label class="control-label col-md-3"><strong>Cantidad producto</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="ProM_Cantidad" placeholder="" type="number" min="1" autocomplete="off" value="1"/> 
                </div>
            </div>
                    
             
        </div>   
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="BtnGuardar">Guardar</button>
        <button type="button" class="btn btn-danger" id="BtnQuitar">Limpiar</button>
       <!-- <button type="button" class="btn btn-secondary"  id="BtnImprimir" onclick="location.href='http://qawms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Tipo=3&IR_ID=41';">Imprimir</button>-->
      </div>
    </div>
  </div>


</div>
</div>


<!--<input type="hidden" value="" class="objAco"  id="CliOC_ID">
-->

<script type="application/javascript">


$(document).ready(function() {

	$('.btnEscaneo').click(function(e) {
		e.preventDefault()
		var Params = "?ProM_ID=" + $(this).data("folio") 
		//	Params += "&Cli_ID=" + $(this).data("cliid") 
			Params += "&Pro_ID=" + $(this).data("proid") 
	
		$("#Contenido").load("/pz/wms/Insumos/Insumos_Escaneo_RFID.asp" + Params)
	});
//	
//        $('.btnRegresar').click(function(e) {
//            e.preventDefault()
//
//                $("#Contenido").load("/pz/wms/Recepcion/Recepcion.asp")
//        });

		$('#BtnGuardar').click(function(e) {
        e.preventDefault()

		var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
		datoAgenda['Tarea'] = 1
		datoAgenda['Cli_ID'] = 6//$('#CliOC_ID').val()
		datoAgenda['Pro_ID'] = $('#Pro_ID').val()
		datoAgenda['ProM_Cantidad'] = $('#ProM_Cantidad').val()
		datoAgenda['Movimiento'] = $('#CboEstatus').val()	
		datoAgenda['IDUsuario'] = $('#IDUsuario').val()	


		$('#MovimientoModal').modal('hide')  
		GuardaMovimiento(datoAgenda)
	//var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionMovImpreso.asp?Folio="+ $('#Folio').val());
    });
	
	$('#btnIngresar').click(function(e) {
		$('.Robin').attr('disabled',false)
		$('#MovimientoModal').modal('show')  
	});
	$('.btnImprime').click(function(e) {
		e.preventDefault()
		RecepImprime($(this).data("folio"))
	});

	$('#BtnQuitar').click(function(e) {
        e.preventDefault()
		$('#MovimientoModal').modal('hide') 
//		BorraEvento($('#Event_ID').val())
//		$('#calendar').fullCalendar('removeEvents', $('#Event_ID').val());
    });
 			
});

function RecepImprime(folio){
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Insumos/Insumos_MovImpreso.asp?Folio="+folio);
}

	$('.btnEliminar').click(function(e) {
     	e.preventDefault()
        var datoAgenda = {}
		datoAgenda['Pt_ID'] = $(this).data("ptid")
		datoAgenda['Tarea'] = 3
		$("#dvMovimiento").load("/pz/wms/Insumos/Insumos_MovimientoSalida_Ajax.asp",datoAgenda)
			

		$("#Contenido").load("/pz/wms/Insumos/Insumos_MovimientoSalida.asp")
			sTipo = "info";
			sMensaje = "El pallet se ha eliminado correctamente ";
			
			Avisa(sTipo,"Aviso",sMensaje);
	
	});
	
	
function GuardaMovimiento(Evento){
			$("#dvMovimiento").load("/pz/wms/Insumos/Insumos_MovimientoSalida_Ajax.asp",Evento
		
		
    , function(data, Evento){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
			

		$("#Contenido").load("/pz/wms/Insumos/Insumos_MovimientoSalida.asp")

});
}
function CargarVentana(Params){
	$("#Contenido").load("/pz/wms/Insumos/Insumos_MovimientoSalida.asp")
}

function UpdateCita(id){
	$.post("/pz/wms/Insumos/Insumos_MovimientoSalida_Ajax.asp",{
		Tarea:3
		,IR_ID:id
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
	
		Avisa(sTipo,"Aviso",sMensaje);
	});
}
function BorraEvento(id){
	$.post("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:4
		,IR_ID:id
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		if (data == 1) {
			sTipo = "info";
			sMensaje = "El registro borrado exitosamente";
			$('#Event_ID').val("")
			
		} else {
			sTipo = "warning";
			sMensaje = "Ocurrio un error al realizar el guardado";
			
		}
		Avisa(sTipo,"Aviso",sMensaje);
	});
}
$('#cboProducto').change(function(e) {
        e.preventDefault()
		$.get("/pz/wms/Insumos/Insumos_MovimientoSalida_Ajax.asp",{
			Tarea:2
			,Pro_ID:$(this).val()
		}, function(data){
			if (data != "") {
				$('#divSKU').html(data)
				$("#Pt_Modelo").hide();
			} else {
				sTipo = "warning";
				sMensaje = "Ocurrio un error al realizar el guardado";
				Avisa(sTipo,"Aviso",sMensaje);
			}
		});

});

</script>
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
var TA_ID = Parametro("TA_ID",-1)
var CliOC_ID = Parametro("OC_ID",1)
var Pro_PesoBruto = 0
var Pro_PesoBrutoMB = 0
var Pro_PesoBrutoPt = 0
var Pro_PesoNeto = 0
var Pro_PesoNetoMB = 0
var Pro_PesoNetoPt = 0
		if(CliOC_ID > -1){
   	var sSQL1  = "select  p.Pro_ID, p.Pro_Nombre from inventario_recepcion r "
         sSQL1 += "inner join cliente c on r.Cli_ID=c.Cli_ID "
	     sSQL1 += "inner join Cliente_OrdenCompra t  on  t.CliOC_ID = r.CliOC_ID "
		 sSQL1 += "inner join  Cliente_OrdenCompra_Articulos a  on t.CliOC_ID = a.CliOC_ID "
	     sSQL1 += "inner join  Producto p  on a.Pro_ID = p.Pro_ID where r.CliOC_ID = " + CliOC_ID 
		    var rsPro = AbreTabla(sSQL1,1,0)
		}
		 if(TA_ID > -1){
		 var sSQL1  = "select p.Pro_ID, p.Pro_Nombre from inventario_recepcion r "
         sSQL1 += "inner join cliente c on r.Cli_ID=c.Cli_ID "
	     sSQL1 += "inner join TransferenciaAlmacen t  on  t.TA_ID = r.TA_ID "
		 sSQL1 += "inner join  TransferenciaAlmacen_Articulos a  on t.TA_ID = a.TA_ID "
	     sSQL1 += "inner join  Producto p  on a.Pro_ID = p.Pro_ID where r.TA_ID = " + TA_ID 
		 
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
                            <label class="control-label col-md-2">Producto</label>
                            <div class="col-md-3">
                	<select id="cboPro_ID" class="form-control agenda">
                      <option value="--Seleccionar--" >--Seleccionar--</option>
                  <%
                    while (!rsPro.EOF){
			 Pro_ID =  rsPro.Fields.Item("Pro_ID").Value 
	         Pro_Nombre =  rsPro.Fields.Item("Pro_Nombre").Value 
%>
                  <option value="<%=Pro_ID%>" id="Pro"<%=Pro_ID%>><%=Pro_Nombre%></option>
                  <%	
						rsPro.MoveNext() 
					}
                rsPro.Close()  
		 
                %>
                  </select>
                </div>
                <div class='external-event navy-bg' id="btIncidencias">Ver incidencias</div>
                         </div>
                    </div>    
                </div>    
            </div>    
        </div>    
    
        <div class="row">
            <div class="col-lg-8">
                <div class="ibox">
                    <div class="ibox-content">
                        <h2>Alta de activos <h2 id=""></h2></h2>
                        <div class="form-group"  style="text-align:end;">
                            <div class="btn-group" role="group" aria-label="Basic example">
                            <div class='external-event navy-bg' id="btnActivos">+ Nuevo</div>
                            </div>                    
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <input class="btn btn-danger btnCancelarCarga" type="button" value="Cancelar Carga">
                              <input class="btn btn-success btnFinalizar" type="button" value="Finalizar carga">
                            </div>                    
                        </div>
                        <div class="form-group divCarga">
                            <label class="control-label col-md-3">Folio</label>
                            <div class="col-md-3">
                                <input class="form-control Folio" placeholder="Ingrese el folio" type="text" value="">
                            </div>
                            <label class="control-label col-md-3">Buscar por Gu&iacute;a</label>
                            <div class="col-md-3">
                                <input class="form-control Guia" placeholder="Ingrese la gu&iacute;a" type="text" value="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        
  <div class="row">
            <div class="col-lg-8">
                <div class="ibox">
                    <div class="ibox-content" id="dvActivos">
                    
                       </div>
                </div>
            </div>
        </div>
        </div>
    </div>
</div>
<div class="modal inmodal fade in" tabindex="-1" id="ActivosModal" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success">
        <div class="col-md-3">
            <h5 class="modal-title" style="color:#FFF">Activos</h5>
        </div>
        <div class="col-md-9">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i style="color:#FFF" class="fa fa-times"></i></button>
        </div>
</div>
<div class="modal-body">
         <div class="form-horizontal">
         

               <div class="form-group">
               <label class="control-label col-md-3" ><strong>Tipo de activo</strong></label>
                <div class="col-md-3">
           <label class="control-label col-md-3"  value="Box" id="Box"><strong>Box</strong></label>
               </div>
               <label class="control-label col-md-3"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
               </div>
             <div class="form-group">
               <label class="control-label col-md-3"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-3"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAlto" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                </div>
                   <div class="form-group">
               <label class="control-label col-md-3"><strong>Peso bruto por caja</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_PesoBruto" placeholder="kg" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-3"><strong>Peso neto por caja</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_PesoNeto" placeholder="kg" type="text" autocomplete="off" value=""></input>
				</div>
                     </div>
                        <div class="form-group">
                       <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="BtnGuardar1">Guardar</button>
        <button type="button" class="btn btn-danger" id="BtnQuitar1">Limpiar</button>
      </div>
      </div>
       <div class="form-group">
               <label class="control-label col-md-3" ><strong>Tipo de activo</strong></label>
                <div class="col-md-3">
           <label class="control-label col-md-3"  value="Masterbox" id="Masterbox"><strong>Masterbox</strong></label>
               </div>
               <label class="control-label col-md-3"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo2" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
               </div>
             <div class="form-group">
               <label class="control-label col-md-3"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho2" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-3"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAlto2" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                   <div class="form-group">
               <label class="control-label col-md-3"><strong>Peso bruto por caja</strong></label>
                <div class="col-md-3">
              <label class="control-label col-md-3"  value="<%=Pro_PesoBrutoMB%>" id="Pro_PesoBruto2"><strong><%=Pro_PesoBrutoMB%></strong> kg</label>
                       </div>
                <label class="control-label col-md-3"><strong>Peso neto por caja</strong></label>
                <div class="col-md-3">
                <label class="control-label col-md-3"  value="<%=Pro_PesoNetoMB%>" id="Pro_PesoNeto2"><strong><%=Pro_PesoNetoMB%></strong> kg</label>
				</div>
                     </div>
                       <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="BtnGuardar2">Guardar</button>
        <button type="button" class="btn btn-danger" id="BtnQuitar2">Limpiar</button>
      </div>
                            <div class="form-group">
               <label class="control-label col-md-3" ><strong>Tipo de activo</strong></label>
                <div class="col-md-3">
           <label class="control-label col-md-3"  value="Pallet" id="Pallet"><strong>Pallet</strong></label>
               </div>
               <label class="control-label col-md-3"><strong>Largo Anidacion</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="Pro_DimLargo3" placeholder="cm" type="text" autocomplete="off" value=""/> 
               </div>
               </div>
             <div class="form-group">
               <label class="control-label col-md-3"><strong>Ancho Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAncho3" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                <label class="control-label col-md-3"><strong>Altura Anidacion</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="Pro_DimAlto3" placeholder="cm" type="text" autocomplete="off" value=""></input>
				</div>
                   <div class="form-group">
               <label class="control-label col-md-3"><strong>Peso bruto por caja</strong></label>
                <div class="col-md-3">
              <label class="control-label col-md-3"  value="<%=Pro_PesoBrutoPt%>" id="Pro_PesoBruto3"><strong><%=Pro_PesoBrutoPt%></strong> kg</label>
                       </div>
                <label class="control-label col-md-3"><strong>Peso neto por caja</strong></label>
                <div class="col-md-3">
                <label class="control-label col-md-3"  value="<%=Pro_PesoNetoPt%>" id="Pro_PesoNeto3"><strong><%=Pro_PesoNetoPt%></strong> kg</label>
				</div>
                     </div>
        </div>   
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="BtnGuardar3">Guardar</button>
        <button type="button" class="btn btn-danger" id="BtnQuitar3">Limpiar</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
      
      <div id = "dvActivo">
        
      </div>
      </div>
    </div>
  </div>
 </div>
 </div>
 </div>


<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">
$('.divCarga').hide()
$('.btnCancelarCarga').hide()
$('.btnFinalizar').hide()
$('.btnDescargaFolios').hide()


$(document).ready(function() {
	
	$('#btnActivos').click(function(e) {
	$('.Robin').attr('disabled',false)
				$('#ActivosModal').modal('show')  
});
			
		$('.Folio').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
			console.log(Mayus)
				if(res != ""){
					CargaDevolucion(Mayus.trim(),$(this))	
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
		});
		$('.Guia').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso = $(this).val()
			var res =DatoIngreso.replace("'", "-");
			var Mayus = res.toUpperCase()
			console.log(Mayus)
				if(res != ""){
					BuscaFolio(Mayus.trim(),$(this))	
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
		});
		

});


function BuscaFolio(Folio,r){
	r.val("")	
	$.post("/pz/wms/Devolucion/Devolucion_Ajax.asp",
		{
		Tarea:5,
		Guia:Folio
		},function(data){ 
		var response = JSON.parse(data)
			if(response.result == 1){
				CargaDevolucion(response.Folio,r)		
				var sTipo = "success"; 
			}else{
				var sTipo = "error";   
			}
			Avisa(sTipo,"Aviso",response.message);		
	});
}


        $('#BtnGuardar1').click(function(e) {
        e.preventDefault()
		var datosActivo = {}
		$('.agenda').each(function(index, element) {
            datosActivo[$(this).attr('id')] = $(this).val()
        });
		datosActivo['Tarea'] = 1
        datosActivo['Cli_ID'] = $('#Cli_ID').val()
		datosActivo['Pro_Nombre'] = $('#Pro_Nombre').val()
	    datosActivo['Pro_PesoBruto'] = $('#Pro_PesoBruto').val()
		datosActivo['Pro_PesoNeto'] = $('#Pro_PesoNeto').val()
		datosActivo['Pro_DimAlto'] = $('#Pro_DimAlto').val()
		datosActivo['Pro_DimLargo'] = $('#Pro_DimLargo').val()
		datosActivo['Pro_DimAncho'] = $('#Pro_DimAncho').val()
				
		Guardar(datosActivo)
		$('#BtnGuardar1').atrr('hide') 
	    });
		
        $('#BtnGuardar2').click(function(e) {
        e.preventDefault()
		var datosActivo = {}
		$('.agenda').each(function(index, element) {
            datosActivo[$(this).attr('id')] = $(this).val()
        });
		datosActivo['Tarea'] = 1
        datosActivo['Cli_ID'] = $('#Cli_ID').val()
		datosActivo['Pro_Nombre'] = $('#Pro_Nombre2').val()
	    datosActivo['Pro_PesoBruto'] = $('#Pro_PesoBruto2').val()
		datosActivo['Pro_PesoNeto'] = $('#Pro_PesoNeto2').val()
		datosActivo['Pro_DimAlto'] = $('#Pro_DimAlto2').val()
		datosActivo['Pro_DimLargo'] = $('#Pro_DimLargo2').val()
		datosActivo['Pro_DimAncho'] = $('#Pro_DimAncho2').val()
				
		Guardar(datosActivo)
		$('#BtnGuardar2').atrr('hide') 
	    });
		
		$('#BtnGuardar3').click(function(e) {
        e.preventDefault()
		var datosActivo = {}
		$('.agenda').each(function(index, element) {
            datosActivo[$(this).attr('id')] = $(this).val()
        });
		datosActivo['Tarea'] = 1
        datosActivo['Cli_ID'] = $('#Cli_ID').val()
		datosActivo['Pro_Nombre'] = $('#Pro_Nombre3').val()
	    datosActivo['Pro_PesoBruto'] = $('#Pro_PesoBruto3').val()
		datosActivo['Pro_PesoNeto'] = $('#Pro_PesoNeto3').val()
		datosActivo['Pro_DimAlto'] = $('#Pro_DimAlto3').val()
		datosActivo['Pro_DimLargo'] = $('#Pro_DimLargo3').val()
		datosActivo['Pro_DimAncho'] = $('#Pro_DimAncho3').val()
				
		Guardar(datosActivo)
		$('#MyBatmanModal').modal('hide') 
	    });
	function Guardar(Evento){
			$("#dvActivo").load("/pz/wms/Recepcion/RecepcionHuella_Ajax.asp",Evento
    , function(data){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
	});
}
$('#cboPro_ID').change(function(e) {
        e.preventDefault()
		Producto($(this).val())
    });
	function Producto(id){
	$.get("/pz/wms/Recepcion/RecepcionHuella_Ajax.asp",{
		Tarea:2
		,Pro_ID:id
	}
    , function(data){
		if (data != "") {
			$('#dvActivos').html(data)
		} else {
			sTipo = "warning";
			sMensaje = "Ocurrio un error al realizar el guardado";
			Avisa(sTipo,"Aviso",sMensaje);
		}
	});
}

// Function to download data to a file



</script>


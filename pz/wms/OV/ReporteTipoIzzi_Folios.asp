<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Fecha = Parametro("Fecha",-1)
	var Recibidos = Parametro("Recibidos",-1)
	var Packing = Parametro("Packing",-1)
	var Transito = new Array(Parametro("Transito",""))
	var PrimerIntento = Parametro("PrimerIntento",-1)
	var SegundoIntento = Parametro("SegundoIntento",-1)
	var TercerIntento = Parametro("TercerIntento",-1)
	var Fallido = Parametro("Fallido",-1)
	var Entregado = Parametro("Entregado",-1)	
		
	var Datos = new Array("Recibidos","Packing","Transito","Primer Intento","Segundo Intento","Tercer Intento","Fallido","Entregado")
	var DatosNum = new Array(1,3,5,6,7,8,9,10)
	var DatosActuales = new Array(Recibidos,Packing,Transito,PrimerIntento,SegundoIntento,TercerIntento,Fallido,Entregado)


%>
<link href="/Template/inspina/css/plugins/iCheck/blue.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/red.css" rel="stylesheet">
<style>
.bg-completado{
	background:#3F9	
}


</style>

<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
<%	
var leng = Datos.length
for(var i = 0; i < leng; i++){
	if(DatosActuales[i] != 0){
%>

  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse<%=i%>" aria-controls="collapseOne">
          <h4 class="panel-title">
            <div class="form-group">
            <label class="text-left col-md-6" ><h3><%=Datos[i]%>&nbsp;<small>Cantidad Actual: <%=DatosActuales[i]%></small></h3></label>
<!--             <label class="text-left col-md-6"><%=Datos[i]%></label>
             <label class="text-right col-md-6">Cantidad Actual: <%=DatosActuales[i]%></label>
-->             </div>
          </h4>
        </a>
    </div>
    <div id="collapse<%=i%>" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
      	<div class="table-responsive">
           <%if(DatosNum[i]<9 && DatosNum[i]>5  && SistemaActual != 29){%>
                <input type="button" value="Mover a <%=Datos[i]%>" class="btn btn-info btnMover"/>
		  <%}%>
                        <table class="table table-striped table-hover">
                          <thead> 
                            <tr>
                              <th scope="col">#</th>
                              <th scope="col">Folio</th>
                              <th scope="col">Numero Pedido</th>
                              <th scope="col">Estatus</th>
                               <%if(DatosNum[i] != 3){%>
                              <th scope="col">Transportista</th>
                              <th scope="col">Guia</th>
                               <%}else{%>
                              <th scope="col">Error direcci&oacute;n</th>
                               <%}%>
                              <th scope="col">Tel&eacute;fono</th>
                              <%if(DatosNum[i]<9 && DatosNum[i]>5 && SistemaActual != 29 ){%>
                              <th scope="col">Mover</th>
                              <%}%>
                              <th scope="col">Ver</th>
                            </tr>
                          </thead>
                          <tbody>
					<%
                        var sSQLRTI = "SELECT  *,(SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 51 AND Cat_ID = p.OV_EstatusCG51) Estatus,ISNULL(OV_CP,'') CP "
                            sSQLRTI += " FROM Orden_Venta p "
                            sSQLRTI += " WHERE OV_Cancelada = 0 "
                            sSQLRTI += " AND OV_Test = 0 "
                            sSQLRTI += " AND OV_EstatusCG51 = "+DatosNum[i]
                            sSQLRTI += " AND CONVERT(date, OV_FechaRegistro, 120) = '"+Fecha+"'"
                            
                        var rsRTI = AbreTabla(sSQLRTI,1,0)

                    var Renglon = 0
                     while(!rsRTI.EOF){
					 Renglon++
                      var OV_ID = rsRTI.Fields.Item("OV_ID").Value 
                      var OV_Folio = rsRTI.Fields.Item("OV_Folio").Value 
                      var Estatus = rsRTI.Fields.Item("Estatus").Value 
                      var OV_TRACKING_COM = rsRTI.Fields.Item("OV_TRACKING_COM").Value 
                      var OV_TRACKING_NUMBER = rsRTI.Fields.Item("OV_TRACKING_NUMBER").Value 
                      var OV_CUSTOMER_SO = rsRTI.Fields.Item("OV_CUSTOMER_SO").Value 
                      var OV_Telefono = rsRTI.Fields.Item("OV_Telefono").Value 
                      var OV_UsuarioCambioDireccion = rsRTI.Fields.Item("OV_UsuarioCambioDireccion").Value 
                      var CP = rsRTI.Fields.Item("CP").Value 
					  var Hecho = ""
					  var Checkedo = ""
					  var URL_Pacqueteria = ""
					  if(OV_UsuarioCambioDireccion > 0){
						  Hecho = "bg-completado"
						  Checkedo = "checked='checked'"
					  }
					  if(OV_TRACKING_COM == "UPS"){
						  URL_Pacqueteria = "https://www.ups.com/WebTracking?loc=es_MX&requester="+OV_TRACKING_NUMBER+"/trackdetails"
					  }
                        %>
                            <tr class="<%=Hecho%>" id="trOV_<%=OV_ID%>">
                              <th scope="row"><%=Renglon%></th>
                              <td><%=OV_Folio%></td>
                              <td><%=OV_CUSTOMER_SO%></td>
                              <td><%=Estatus%></td>
                               <%if(DatosNum[i] != 3){%>
                              <td><%=OV_TRACKING_COM%></td>
                              <td><%=OV_TRACKING_NUMBER%></td>
                               <%}else{
								   if(CP == ""){%>
                                  <td align="center"><input class="checkboxred" type="checkbox" checked="checked"/></td>
                               <%}else{%>
                                  <td align="center"><input class="checkboxred disabled" type="checkbox"/></td>
								  <%}
							   }%>
                              <td><%=OV_Telefono%></td>
                              <%if(DatosNum[i]<9  && DatosNum[i]>5 && SistemaActual != 29){%>
                              <td><input class="checkbox22" type="checkbox" data-status="<%=DatosNum[i]%>" data-ovid="<%=OV_ID%>" value=""/></td>
                              <%}%>
                              <td><a class="btn btn-xs btn-green VerSO" data-placement="top" data-ovid="<%=OV_ID%>" data-toggle="modal" data-target="#myModalVerFolio" data-original-title="Seleccionar"><i class="fa fa-eye"></i></a></td>
                            </tr>
                        <%
                        rsRTI.MoveNext() 
                    }
                    rsRTI.Close()   
                    %>
                    	</tbody>
                    </table>     
         </div>                              
      </div>
    </div>
</div>
<%
	}	
}
%>

<input name="OV_ID" id="OV_ID" type="hidden" value="" />
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="application/javascript">

var CambioEstatus = []
var indexEstatus = []
$(document).ready(function() {
	$('.checkbox22').iCheck({ checkboxClass: 'icheckbox_square-blue' }); 
	$('.checkboxred').iCheck({ checkboxClass: 'icheckbox_square-red'});
	$('.VerSO').click(function(e) {
		var OV_ID = $(this).data("ovid")
		$('#OV_ID').val(OV_ID)
		$.post("/pz/wms/OV/OV_Ficha.asp"
		  ,{OV_ID:OV_ID}
		  , function(data){
			$('#modalBodySO').html(data)
			$("#SeAbrePorModal").val(1);
		});  
    });
	
	$('.btnMover').click(function(e) {
        CambioEstatus.forEach(function (dato, index, array) {
			console.log(dato.EstatusActual +" "+ dato.OV_ID)
		});
    });
	
	$('.btnMover')

	$('.checkbox22').on('ifChanged', function(event) {
		if(event.target.checked) {
			var OV_ID = $(this).data("ovid")
			var EstatusActual = $(this).data("status")
			var datos = {"EstatusActual":EstatusActual,"OV_ID":OV_ID}
			CambioEstatus.push(datos);
			var index = CambioEstatus.indexOf(datos);
			$(this).val(index)
			console.log(CambioEstatus)
		}
	});
	$('.checkbox22').on('ifUnchecked', function(event) {			
		var OV_ID = $(this).data("ovid")
		var EstatusActual = $(this).data("status")
		var datos = {"EstatusActual":EstatusActual,"OV_ID":OV_ID}
		removeItemFromArr(CambioEstatus,datos)
		console.log(CambioEstatus)
	});
});

function removeItemFromArr ( arr,item ) {
	var i = arr.map(function(e) { return e.OV_ID; }).indexOf(item.OV_ID);    
	console.log(i)
    if ( i !== -1 ) {
		arr.splice( i, 1 );
    }
}

</script>







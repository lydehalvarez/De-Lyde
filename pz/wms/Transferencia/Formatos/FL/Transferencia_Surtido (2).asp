 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	
	var Transfer = "SELECT * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " ,(SELECT Alm_Numero FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Numero "
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE TA_ArchivoID = "+TA_ArchivoID
		
	var Lot_ID = BuscaSoloUnDato("Lot_ID","TransferenciaAlmacen_Archivo","TA_ArchivoID ="+TA_ArchivoID,-1,0)
		
			
%>

<div class="form-horizontal">
    <%
		var rsTran = AbreTabla(Transfer,1,0)
	
	while (!rsTran.EOF){ 
	var TA_ID = rsTran.Fields.Item("TA_ID").Value
	var Mov_ID = rsTran.Fields.Item("Mov_ID").Value
	var TA_FacturaCliente = rsTran.Fields.Item("TA_FacturaCliente").Value
	var Alm_Numero = rsTran.Fields.Item("Numero").Value
	
	var sSQLSku = "SELECT * FROM TransferenciaAlmacen_Articulos WHERE TA_ID = "+TA_ID
	var rsSku = AbreTabla(sSQLSku,1,0)
	%>
        <div class="row">
            <div class="col-md-12">
                <div class="ibox">
                    <div class="ibox-content">
                    <div class="widget style1 navy-bg">
                        <div class="row vertical-align">
                            <div class="col-xs-3">
                                <i class="fa fa-dropbox fa-2x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                                <h3 class="font-bold"><%=rsTran.Fields.Item("TA_Folio").Value%></h3>
                            </div>
                        </div>
                    </div>
                    <p>
                        <span class="label label-primary">Origen <%=rsTran.Fields.Item("Sucursal_Origen").Value%></span>
                    </p>
                    <p>
                        <span class="label label-warning">Destino <%=rsTran.Fields.Item("Sucursal_Destino").Value%></span>
                    </p>
                    <%
                    while(!rsSku.EOF){  
                        var SKU = rsSku.Fields.Item("TAA_SKU").Value
						%>
                            <input type="button" value="Ingresar pallet SKU <%=SKU%>" data-sku="<%=SKU%>" data-taid="<%=TA_ID%>"  class="btn btn-info btnIngresarPallet"/>
                            <br />
                            <br />
						<%
						rsSku.MoveNext()  
						}
					rsSku.Close()  
					
					%>
                    

                    <div class="col-md-12 Pallets" id="Pallets<%=TA_ID%>"></div>
                    <input type="hidden" id="Mov<%=TA_ID%>" value=""/>
                    <input type="hidden" id="MovP<%=TA_ID%>" value=""/>
                    
                    <div class="form-group" style="text-align:right">
                        <div class="btn-group" role="group" aria-label="Basic example">
                            <input type="button" value="Archivo DAT" data-mov="<%=Mov_ID%>" data-fac="<%=TA_FacturaCliente%>" class="btn btn-info btnFormatoTelcel_DAT"/>
                            <input type="button" value="Archivo BAN" data-mov="<%=Mov_ID%>" data-fac="<%=TA_FacturaCliente%>" data-clave="<%=Alm_Numero%>" data-sku="<%=SKU%>" class="btn btn-success btnFormatoTelcel_BAN"/>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </div>
      <%
			i++;
				rsTran.MoveNext()
			}
		rsTran.Close() 
		%>
        
</div>   


<div class="modal fade" id="AgregaPalletModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
             <div class="form-group">
               <label class="control-label col-md-2" ><strong>Cajas</strong></label>
                <div class="col-md-4">
                   <input class="form-control" id="numCajas" placeholder="Cantidad de cajas" type="number" min="1" value=""/> 
                    <input type="hidden" id="ModalTA_ID" value=""/>
                    <input type="hidden" id="SKU_ID" value=""/>
               </div>
            </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAddPallet">Genera Pallet</button>
      </div>
    </div>
  </div>
</div>
 
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="application/javascript">

var date = new Date ()
var Meses = ["01","02","03","04","05","06","07","08","09","10","11","12"]
var Dia = date.getDate()
if(Dia < 10){
Dia = "0" + Dia;	
}
var Fecha = date.getFullYear()+""+Meses[date.getMonth()]+""+Dia

$(".btnFormatoTelcel_DAT").click(function(){
	var Mov_ID = $(this).data('mov')
	var Fac = $(this).data('fac')
	var url = "/pz/wms/Transferencia/Formatos/FL/FormatoTelcel_Dat.asp?Mov_ID="+Mov_ID
	downloadURI(url,"MF_SER_LB_"+Fac+"_"+Fecha+".DAT")
});

$(".btnFormatoTelcel_BAN").click(function(){
	var Mov_ID = $(this).data('mov')
	var Fac = $(this).data('fac')
	var Hora = date.getHours()
	var Clave =  $(this).data('clave')
	var SKU =  $(this).data('sku')
	var Minutes = date.getMinutes()
	if (Minutes < 10) {
		Minutes = "0" + Minutes;
	}	
	var url = "/pz/wms/Transferencia/Formatos/FL/FormatoTelcel_Ban.asp?Mov_ID="+Mov_ID+"&Hora="+Hora+"&Minutes="+Minutes+"&Fecha="+Fecha+"&Factura="+Fac+"&Clave="+Clave+"&SKU="+SKU
	downloadURI(url,"MF_CON_LB_"+Fac+"_"+Fecha+".BAN")
});

function downloadURI(uri, name) {
  var link = document.createElement("a");
  link.download = name;
  link.href = uri;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  delete link;
}

$(".btnIngresarPallet").click(function(e) {
	var TA_ID = $(this).data('taid')
	var SKU = $(this).data('sku')
	$('#ModalTA_ID').val(TA_ID)
	$('#SKU_ID').val(SKU)
	$('#AgregaPalletModal').modal('show')
});	

$(".btnAddPallet").click(function(e) {
	var numCajas =  $('#numCajas').val() 
	FunctionPallet.AddPallet($('#ModalTA_ID').val(),numCajas);
	$('#AgregaPalletModal').modal('hide')
	$('#ModalTA_ID').val("")
	$('#numCajas').val("")
});	

var Renglon = 0
var FunctionPallet = {
	AddPallet:function(TA_ID,Cajas){
		$.post("/pz/wms/Transferencia/Formatos/FL/Palletizado_Ajax.asp",
		{
			Tarea:2,
			IDUsuario:$('#IDUsuario').val(), 
			Mov_ID:$('#Mov'+TA_ID).val()    
			}
		, function(data){
			var response = JSON.parse(data)
			if(response.result == 1){
				if(response.data[0] > 0){
					$('#Mov'+TA_ID).val(response.data[0].Mov_ID)
					$('#MovP'+TA_ID).val(response.data[0].MovP_ID)
				}
				FunctionPallet.AddBoxes(TA_ID,Cajas,response.data[0].Mov_ID,response.data[0].MovP_ID)
			}
			console.log(response)
		});
	},
	AddBoxes:function(TA_ID,numCajas,h,j){
		$.post("/pz/wms/Transferencia/Formatos/FL/Palletizado_Ajax.asp",
		{
			Tarea:3,
			numCajas:numCajas,
			Mov_ID:h,
			MovP_ID:j,
			IDUsuario:$('#IDUsuario').val()
			}
		, function(data){
			var response = JSON.parse(data)
			if(response.result == 1){
				FunctionPallet.GetTabla(TA_ID,h)
			}
			console.log(response)
		});
	},
	PutSerie:function(h,f,g,s,k,e){
		var request = {
			Tarea:4,
			Serie:s,
			IDUsuario:$('#IDUsuario').val(),
			Mov_ID:h,
			MovP_ID:f,
			MovM_ID:g,
			Limite:$('#Mov_'+h+'_'+f+'_'+g).val()
		}
		if (e.keyCode == 13) {
			$.post("/pz/wms/Transferencia/Formatos/FL/Palletizado_Ajax.asp",request
			, function(data){
				var response = JSON.parse(data)
				k.prop('disabled',false)
				k.val("")
				k.focus()
				Avisa(response.data[0],"Aviso",response.message)
			});
			console.log(request)
		}
	},
	GetTabla:function(TA_ID,h){
		Renglon++
		$.post("/pz/wms/Transferencia/Formatos/FL/Pallet.asp",
		{Mov_ID:h,
		Renglon:Renglon
		}
		, function(data){ 
			$('#Pallets'+TA_ID).prepend(data)
		});
	},
	PrintLabel:function(Mov_ID,MovP_ID,MovM_ID){
		var Datos = "Mov_ID="+Mov_ID
			Datos +="&MovP_ID="+MovP_ID
			Datos +="&MovM_ID="+MovM_ID
		window.open("http://qawms.lyde.com.mx/pz/wms/Transferencia/Formatos/FL/EtiquetaM4.asp?"+Datos)
	}
}



</script>
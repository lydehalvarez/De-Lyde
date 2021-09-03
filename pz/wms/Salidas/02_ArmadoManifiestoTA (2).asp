<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
   

<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
 
<div id="wrapper">
    <div class="wrapper wrapper-content">   
          <div class="row">
            <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-content text-right">
                        <div class="btn-group" role="group" aria-label="Basic example">
                          <button type="button" class="btn btn-primary btnNuevo"><i class="fa fa-plus"></i>&nbsp;&nbsp;Nuevo Manifiesto</button>  
                          <button type="button" class="btn btn-warning btnBorrador"><i class="fa fa-list-alt"></i>&nbsp;&nbsp;Borradores</button>  
                          <button type="button" class="btn btn-success btnTerminado"><i class="fa fa-location-arrow"></i>&nbsp;&nbsp;Terminados</button>  
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-content" id="GridManifiesto">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<div class="modal inmodal fade in" tabindex="-1" id="newManifiesto" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success">
        <div class="col-md-6">
            <h5 class="modal-title" style="color:#FFF">Nuevo manifiesto</h5>
        </div>
        <div class="col-md-6">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i style="color:#FFF" class="fa fa-times"></i></button>
        </div>
      </div>
      <div class="modal-body">
            <div class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-md-3"><strong>Nombre operador</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control man" id="Man_Operador" placeholder="Nombre completo" type="text" value="">
                    </div><label class="control-label col-md-3"><strong>Placas del veh&iacute;culo</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control man" id="Man_Placas" placeholder="Placas" type="text" value="">
                    </div>
                </div>
        
                <div class="form-group">
                    <label class="control-label col-md-3"><strong>Tipo del veh&iacute;culo</strong></label>
                    <div class="col-md-3">
                        <input autocomplete="off" class="form-control man" id="Man_Vehiculo" placeholder="Descripci&oacute;n de veh&iacute;culo" type="text" value="">
                    </div>
                    <label class="control-label col-md-3"><strong>Transportista</strong></label>
                    <div class="col-md-3">
                        <%CargaCombo("Prov_ID","class='form-control combman'","Prov_ID","Prov_Nombre","Proveedor","Prov_EsPaqueteria = 1","","Editar",0,"Selecciona")%>
                    </div>
                </div>
                
                <div class="form-group">
                   <label class="control-label col-md-3"><strong>Folio Cliente</strong></label>
                    <div class="col-md-3">
                        <input class="form-control man" id="Man_FolioCliente" placeholder="Folio" type="text" autocomplete="off" value=""/>
                    </div>
                    <label class="control-label col-md-3"><strong>Ruta</strong></label>
                    <div class="col-md-3">
                    
                        <%
                        var condicion = "Alm_Ruta IS NOT NULL  GROUP BY Alm_Ruta Order by Alm_Ruta"
                        var campo = "('R ' + CONVERT(NVARCHAR,Alm_Ruta) ) as Ruta"
                        
                        CargaCombo("Man_Ruta","class='form-control combman'","Alm_Ruta",campo,"Almacen",condicion,"","Editar",0,"Selecciona")%>
                    </div>
                </div>
                <div class="form-group">
                   <label class="control-label col-md-3"><strong>Tipo de Ruta</strong></label>
                    <div class="col-md-3">
                        <%
                        var condicion = "Sec_ID = 94"
                        var campo = "Cat_Nombre"
                        
                        CargaCombo("Cat_ID","class='form-control combman'","Cat_ID",campo,"Cat_Catalogo",condicion,"","Editar",0,"Selecciona")%>
                    </div>
                    <label class="control-label col-md-3"><strong>Estado</strong></label>
                    <div class="col-md-3">
                        <%
                        var condicion = ""
                        var campo = "Edo_Nombre"
                        
                        CargaCombo("Edo_ID","class='form-control combman'","Edo_ID",campo,"Cat_Estado",condicion,"","Editar",0,"Selecciona")%>
                    </div>
                </div>
                <div class="form-group">
                   <label class="control-label col-md-3"><strong>Aeropuerto</strong></label>
                    <div class="col-md-3 escoger">
                        <%
                        var condicion = ""
                        var campo = "Aer_Nombre"
                        
                        CargaCombo("Aer_ID","class='form-control combman'","Aer_ID",campo,"Cat_Aeropuerto",condicion,"","Editar",0,"Selecciona")%>
                    </div>
                </div>
            </div>	
        </div>   
          <div class="modal-footer">
            <button type="button"  class="btn btn-primary btnSaveManifiesto">Guardar</button>
            <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
          </div>
      </div>
    </div> 
</div> 


<input type = "hidden"  value=""  id="Man_ID"/>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script type="application/javascript">

$('.btnNuevo').click(function(e) {
    e.preventDefault();
	$('#newManifiesto').modal('show')
});

$('.btnSaveManifiesto').click(function(e) {
    e.preventDefault();
	ManifiestoFunciones.CreaManifiesto();
});


var ManifiestoFunciones = {
	CreaManifiesto:function(){
		$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
		{
			Prov_ID:$("#Prov_ID").val(),
			Man_Operador:$("#Man_Operador").val(),
			Man_Placas:$("#Man_Placas").val(),
			Man_Vehiculo:$("#Man_Vehiculo").val(),
			Man_FolioCliente:$("#Man_FolioCliente").val(),
			Cat_ID:$("#Cat_ID").val(),
			Aer_ID:$("#Aer_ID").val(),
			Man_Ruta:$("#Man_Ruta").val(),
			Edo_ID:$("#Edo_ID").val(),
			IDUsuario:$("#IDUsuario").val(),
			Tarea:2
		}
		,	 function(data){
			var response = JSON.parse(data)
			if(response.result>-1){
				$("#Man_ID").val(response.result);
				$(".man").val("");
				$(".combman").val(-1);
				$('#newManifiesto').modal('hide');
				ManifiestoFunciones.CargaPendiente($("#Man_ID").val())
				$('#GridManifiesto').html()
			}
		});
	},
	CargaPendiente:function(Man_ID){
		$.post("/pz/wms/Salidas/Manifiestos_Grid.asp",
		{
			Man_ID:$("#Man_ID").val()
		}
		,	 function(data){
			if(data != ""){
				$('#GridManifiesto').html(data)
			}
		});
	},
	GuardaData:function(ID,EsOV){
		$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
		{
			Man_ID:$("#Man_ID").val(),
			ID:ID,
			EsOV:EsOV,
			Tarea:3
		}
		,	 function(data){
			var response = JSON.parse(data)
			var Tipo = ""
			if(response.result>-1){
				Tipo = "success"
			}else{
				Tipo = "warning"
			}
			Avisa(Tipo,"Aviso",response.message)
		});
	},
	BorraData:function(ID,EsOV){
		$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
		{
			Man_ID:$("#Man_ID").val(),
			ID:ID,
			EsOV:EsOV,
			Tarea:4
		}
		,	 function(data){
			var response = JSON.parse(data)
			var Tipo = ""
			if(response.result>-1){
				Tipo = "success"
			}else{
				Tipo = "warning"
			}
			Avisa(Tipo,"Aviso",response.message)
		});
	}
	
	
}

</script>     
              


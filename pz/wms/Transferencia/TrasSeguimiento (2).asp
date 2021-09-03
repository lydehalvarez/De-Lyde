<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

var IDUsuario = Parametro("IDUsuario",-1)


	Response.CacheControl="no-cache"
    Response.AddHeader("Pragma", "no-cache")
    Response.Expires=-1   
  
   var Llaves = ""
   var EstatusEstilo = ""
   var OC_Folio  = ""
   var OC_Descripcion  = ""
   var Proveedor = ""
   var FechaElaboracion   = ""
   var FechaRequerida   = ""
   var FechaRevision1   = ""
   var OC_Total = ""
   var PA_Cantidad = 0
   var PA_Monto = 0
   var PA_Porcentaje = 0
   var A_Cantidad = 0
   var A_Monto = 0
   var A_Porcentaje = 0
   var AB_Cantidad = 0
   var AB_Monto = 0
   var AB_Porcentaje = 0
   var Total = 0
   
   
   var sSQLOC  = "SELECT PA_Cantidad, PA_Monto, PA_Porcentaje, A_Cantidad"
       sSQLOC += ", A_Monto, A_Porcentaje, AB_Cantidad, AB_Monto, AB_Porcentaje, Total "
	   sSQLOC += " FROM tuf_OrdenCompra_Dashboard(0,0) "
   var rsOC = AbreTabla(sSQLOC,1,0)
   if (!rsOC.EOF){
	   PA_Cantidad = rsOC.Fields.Item("PA_Cantidad").Value
	   PA_Monto = formato(rsOC.Fields.Item("PA_Monto").Value,2)
	   PA_Porcentaje = formato(rsOC.Fields.Item("PA_Porcentaje").Value,2)
	   A_Cantidad = rsOC.Fields.Item("A_Cantidad").Value
	   A_Monto = formato(rsOC.Fields.Item("A_Monto").Value,2)
	   A_Porcentaje = formato(rsOC.Fields.Item("A_Porcentaje").Value,2)
	   AB_Cantidad = rsOC.Fields.Item("AB_Cantidad").Value
	   AB_Monto = formato(rsOC.Fields.Item("AB_Monto").Value,2)
	   AB_Porcentaje = formato(rsOC.Fields.Item("AB_Porcentaje").Value,2)
	   Total = rsOC.Fields.Item("Total").Value
   }
   rsOC.Close()
   
%>
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
    
<div id="wrapper">
	<div class="wrapper wrapper-content">
        <div class="row">
            <div class="tabs-container">
                <ul class="nav nav-tabs">
                    <li class="active btnPorEstatus"><a data-toggle="tab" href="#tab-1">Por estatus</a></li>
                    <li class="btnPorFiltros"><a data-toggle="tab" href="#tab-2">Por filtros</a></li>
                </ul>
                <div class="tab-content">

                <div id="tab-1" class="tab-pane active">
                    <div class="panel-body">
                        <div style="background-color:#e7eaec;;padding: 11px 6px 11px 6px;height: 157px;">

                        <div class="col-lg-4">
                            <div class="ibox float-e-margins" id="Caja1">
                                <div class="ibox-title">
                                    <span class="label label-info pull-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                    <h5>Por autorizar</h5>
                                </div>
                                <div class="ibox-content">
                                    <h1 class="no-margins"><%=PA_Cantidad%> / $<%=PA_Monto%></h1>
                                    <div class="stat-percent font-bold text-navy"><%=PA_Porcentaje%>%</i></div>
                                    <small></small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4">
                            <div class="ibox float-e-margins" id="Caja2">
                                <div class="ibox-title">
                                    <span class="label label-primary pull-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                    <h5>Autorizadas para pago</h5>
                                </div>
                                <div class="ibox-content">
                                    <h1 class="no-margins"><%=A_Cantidad%> / $<%=A_Monto%></h1>
                                    <div class="stat-percent font-bold text-info"><%=A_Porcentaje%>%</i></div>
                                    <small></small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4">
                            <div class="ibox float-e-margins" id="Caja3">
                                <div class="ibox-title">
                                    <span class="label label-warning pull-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                    <h5>Abiertas - Pagos concurrentes</h5>
                                </div>
                                <div class="ibox-content">
                                    <h1 class="no-margins"> <%=AB_Cantidad%> / $<%=AB_Monto%></h1>
                                    <div class="stat-percent font-bold text-warning"><%=AB_Porcentaje%>%</div>
                                    <small></small>
                                </div>
                            </div>
                        </div>
                         
                        </div>
                    </div>
                </div>
                    
                <div id="tab-2" class="tab-pane">
                    <div class="panel-body">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Filtros</h5>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                    <div class="col-sm-12 m-b-xs">
                                        <div class="row">
                                            <label class="col-sm-1 control-label">Proveedor:</label>
                                            <div class="col-sm-4 m-b-xs">
                                                <input id="BusProv_Nombre" class="input-sm form-control" placeholder="Nombre del proveedor" type="text" value="">
                                            </div>
                                            <label class="col-sm-2 control-label">Folio de O.C.:</label>
                                            <div class="col-sm-3 m-b-xs">
                                                <input id="BusOC_Folio" class="input-sm form-control" placeholder="Folio de Orden de Compra" type="text" value="">
                                            </div> 
                                            <div class="col-sm-2 m-b-xs text-rigth">
                                                <button class="btn btn-success btn-sm btnBuscar" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                                            </div>  
                                        </div>    
                                    </div>
                                </div>                                        
                                <div class="row">
                                    <div class="col-sm-12 m-b-xs">
                                        <label class="col-sm-1 control-label">R.F.C.:</label>
                                        <div class="col-sm-3 m-b-xs">
                                             <input class="input-sm form-control" id="BusProv_RFC" placeholder="R.F.C." type="text" value="">
                                        </div> 
                                        <label class="col-sm-1 control-label">Estatus:</label>
                                        <div class="col-sm-3">
     <% ComboSeccion("BusOC_EstatusCG51","class='form-control input-sm'",51,Parametro("BusOC_EstatusCG51",-1),0,"Cualquiera","Cat_Orden","Editar")%>
                                        </div> 
                                    </div>    	
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                    
            </div>
        </div>
		<div class="row">
            <div id="dvTablaClientes"></div>
        </div>
	</div>
</div> 

<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>    
   

<script type="text/javascript">
        
$(document).ready(function(){

	Carga(1,1);
    
    $(".BusOC_EstatusCG51").select2({
        /*placeholder: "Selecciona un equipo de ventas",
        allowClear: false*/
    });       
    
	
	$("#Caja1").click(function(e) {
        Carga(1,1);
    });
	
	$("#Caja2").click(function(e) {
        Carga(1,2);
    });
	
	$("#Caja3").click(function(e) {
        Carga(1,3);
    });
	
	$("#btnBuscar").click(function(e) {
        Carga(2,0);
    });	
	
	
    
});
        
    
function Carga(TB,TE) {
    //var sLlaves = "&BusEqp_ID="+$("#BusEqp_ID").val();
	var sDatos = "?TB=" + TB
	    sDatos += "&TE=" + TE
		
	if(TB==2){
		sDatos += "&BusProv_Nombre=" + $("#BusProv_Nombre").val()
		sDatos += "&BusOC_Folio=" + $("#BusOC_Folio").val()
		sDatos += "&BusProv_RFC=" + $("#BusProv_RFC").val()
		sDatos += "&BusOC_EstatusCG51=" + $("#BusOC_EstatusCG51").val()
	}
		
    $("#dvTablaClientes").load("/pz/fnd/Tesoreria/OrdenCompraGrid.asp" + sDatos).show();

}	        

$(".btnPorFiltros").click(function(event) {    
    
   $("#dvTablaClientes").hide();
    
});

$(".btnPorEstatus").click(function(event) {    
    
   $("#dvTablaClientes").hide();
       
});
 
    
</script>

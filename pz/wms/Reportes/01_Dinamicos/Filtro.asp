<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var Cli_ID = Parametro("Cli_ID",-1)
	var Deu_ID = Parametro("Deu_ID",-1)
	var Fac_ID = Parametro("Fac_ID",-1)
	var Rep_ID = Parametro("Rep_ID",-1)
	var iRegistros = 0
	var Clase = ""
	var Clasein = "in"
	var Rep_ClienteVisible = 0	
	var Rep_AdminVisible = 0
	var Rep_ProvVisible = 0			
	var iRepCliente = 0
	var iRepDeudor = 0
	var Estatus = 0
	var Fecha = 0
	var Fecha2 = 0
	var FechaDateTime = 0
	var Archivo = ""
	var Ayuda = ""
	
	var sSQL = "SELECT *  "
		sSQL += " FROM Reportes "
		sSQL += "  WHERE Rep_ID = " + Rep_ID

	var rsReporte = AbreTabla(sSQL,1,0)
		
	if (!rsReporte.EOF) {
			
			iRepCliente 		= rsReporte.Fields.Item("Rep_Cliente").Value
			iRepDeudor          = rsReporte.Fields.Item("Rep_Deudor").Value
			Estatus  			= rsReporte.Fields.Item("Rep_Estatus").Value
			Fecha    			= rsReporte.Fields.Item("Rep_Fecha").Value
			Fecha2   			= rsReporte.Fields.Item("Rep_Fecha2").Value
			FechaDateTime 		= rsReporte.Fields.Item("Rep_FechaDateTime").Value
			Rep_AdminVisible    = rsReporte.Fields.Item("Rep_AdminVisible").Value
			Rep_ClienteVisible  = rsReporte.Fields.Item("Rep_ClienteVisible").Value
	        Rep_ProvVisible     = rsReporte.Fields.Item("Rep_ProvVisible").Value
			Ayuda    			= rsReporte.Fields.Item("Rep_SQLAyuda").Value			
			if (!EsVacio(rsReporte.Fields.Item("Rep_Archivo").Value)) {
				Archivo = rsReporte.Fields.Item("Rep_Archivo").Value 
			} else {
				Archivo = "ReporteComun.asp"
			}
			


	}
	rsReporte.Close()		

%>
<script type="text/javascript" src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>

<div class="form-group">
      <label class="col-md-offset-1 control-label"><h3><%=Parametro("Rep_Nombre","")%></h3></label>
</div>
<hr />
<div class="form-group">
	<div class="col-md-9">

<div class="form-horizontal" id="frmFiltroRep">
<% if (iRepCliente == 1) { %>
<div class="form-group">
    <label class="col-xs-2 control-label" id="lblCliente">Cliente(s)</label>
    <div class="col-xs-5">
      <%  var sCond = ""
        //CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo)onChange='javascript:RecargaEnSiMismo();'
		
	  if(Deu_ID>-1){
		if( iRepDeudor == 1 && iRepCliente != 1) {
			   //pendiente. colocar solo los clientes que contienen este proveedor
			//sCond = "Deu_ID in (Select Deu_ID from Cliente_Proveedor where Cli_ID = " + Cli_ID + ")"
		}	  
	  }
	  
	  if(Cli_ID>-1){
		if( iRepCliente == 1) {
			sCond = "Cli_ID = " + Cli_ID
		}
	  }
		
        CargaCombo("RepCli_ID"," class='form-control' id='form-field-select-2' ","Cli_ID","Cli_RazonSocial","Cliente",sCond,"Cli_RazonSocial",Parametro("RepCli_ID",-1),0,"Todas",0)
      %>
    </div>
</div>
<% } else { %>
  	<input type="hidden" name="RepCli_ID" value="<%=Parametro("RepCli_ID",-1)%>">    
<% } if (iRepDeudor == 1) { %>
<div class="form-group">
    <label class="col-xs-2 control-label" id="lblCliente">Proveedor(es)</label>
    <div class="col-xs-5">
      <%  var sCond = ""
	  //CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo)onChange='javascript:RecargaEnSiMismo();'

	  if(Deu_ID>-1){
			sCond = "Prov_ID = " + Deu_ID   
	  }
	  
	  /*if(Cli_ID>-1){
			sCond = "Deu_ID in (Select Deu_ID from Cliente_Proveedor where Cli_ID = " + Cli_ID + ")"
	  }*/

        CargaCombo("RepDeu_ID"," class='form-control' id='form-field-select-2' ","Prov_ID","Prov_RazonSocial","Proveedor",sCond,"Prov_RazonSocial",Parametro("RepDeu_ID",-1),0,"Todas",0)
      %>
    </div>
</div>
<% } else { %>
	<input type="hidden" name="RepDeu_ID" value="<%=Parametro("RepDeu_ID",-1)%>">
<% } if (Fecha == 1) { %>
<div class="form-group">
	<label class="col-xs-4 control-label"><h4>Fecha(s)</h4></label>
</div>
<div class="form-group">
	<label for="lblDesdeD" class="col-xs-1 control-label">Desde</label>
	<div class="col-xs-4">
    	<div class="input-group" id="FchaCal0">
        <input type="text" class="form-control" id="txtFechaDesde" name="txtFechaDesde" size="25" placeholder="dd/mm/yyyy">
        <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
    	</div>  
	</div>
    <label for="lblDesdeH" class="col-xs-1 control-label">Hasta</label>
    <div class="col-xs-4">
        <div class="input-group" id="FchaCal1"> 
        <input type="text" class="form-control" id="txtFechaHasta" name="txtFechaHasta" size="25" placeholder="dd/mm/yyyy">
        <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
        </div>  
    </div>
</div>
<% } else { %>
    <input type="hidden" name="txtFechaDesde" value="">
    <input type="hidden" name="txtFechaHasta" value="">
<% } if ( Fecha2 == 1 ) { %>
<div class="form-group">
	<label class="col-xs-4 control-label"><h4>Fecha(s)</h4></label>
</div>
<div class="form-group">
	<label for="lblDesdeD2" class="col-xs-1 control-label">Desde</label>
	<div class="col-xs-4"  id="FchaCal2">
    	<div class="input-group">
        <input type="text" class="form-control" id="txtFechaDesde2" name="txtFechaDesde2" size="25" placeholder="dd/mm/yyyy">
        <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
    	</div>  
	</div>
    <label for="lblDesdeH2" class="col-xs-1 control-label">Hasta</label>
    <div class="col-xs-4">
        <div class="input-group"  id="FchaCal3">
        <input type="text" class="form-control" id="txtFechaHasta2" name="txtFechaHasta2" size="25" placeholder="dd/mm/yyyy">
        <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
        </div>  
    </div>
</div>
<% } else { %>
    <input type="hidden" name="txtFechaDesde2" value="">
    <input type="hidden" name="txtFechaHasta2" value="">
<% } if ( FechaDateTime == 1 ) { %>
<div class="form-group">
	<label class="col-xs-4 control-label"><h4>Fecha(s)</h4></label>
</div>
<div class="form-group">
	<label for="lblDesdeD3" class="col-xs-1 control-label">Desde</label>
	<div class="col-xs-4">
    	<div class="input-group"  id="FchaCal4">
        <input type="text" class="form-control" id="txtFechaDesdeDateTime" name="txtFechaDesdeDateTime" size="25" placeholder="dd/mm/yyyy">
        <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
    	</div>  
	</div>
    <label for="lblDesdeH3" class="col-xs-1 control-label">Hasta</label>
    <div class="col-xs-4">
        <div class="input-group" id="FchaCal5">
        <input type="text" class="form-control" id="txtFechaHastaDateTime" name="txtFechaHastaDateTime" size="25" placeholder="dd/mm/yyyy">
        <span class="input-group-addon"> <i class="fa fa-calendar"></i> </span>
        </div>  
    </div>
</div>
<% } else { %> 
    <input type="hidden" name="txtFechaDesdeDateTime" value="">
    <input type="hidden" name="txtFechaHastaDateTime" value="">
<% } if (Ayuda != "") { %>
<div class="alert alert-block alert-info fade in">
    <!--button class="close" data-dismiss="alert" type="button">??</button-->
    <h4 class="alert-heading">
    	<i class="fa fa-info-circle"></i> Ayuda!
    </h4>
    <p><%=Ayuda%></p>
</div>	 
<% } %>
</div>

    </div>
</div>

<div class="form-group">
<div class="col-md-12">

        <div id="VerReporte" class="col-md-offset-10 ">
             <a class="btn btn-primary col-md-12" href="javascript:Imprime(<%=Rep_ID%>,1,0);">
             <i class="fa fa-eye"></i>&nbsp;Ver Reporte</a>
        </div>
           <div class="clearfix"></div> 
           <br />
           
        <div id="ExportarAExcel" class="col-md-offset-10 ">
             <a class="btn btn-primary col-md-12" title="Exportar a excel" 
                href="javascript:Imprime(<%=Rep_ID%>,1,1);">
             <i class="clip-download-3"></i>&nbsp;Exportar</a>
        </div>	
      </div>     
    </div>  
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
		var date = $('#date').val();
		//txtFechaDesde - txtFechaHasta

		$('#txtFechaDesde').datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});
		$('#txtFechaHasta').datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});		
		$('#FchaCal0').click(function(){
			$('#txtFechaDesde').data("datepicker").show();
		});
		$('#FchaCal1').click(function(){
			$('#txtFechaHasta').data("datepicker").show();
		});		
		// FchaCal0 txtFechaDesde FchaCal1 txtFechaHasta

		// disabling dates
//		var nowTemp = new Date();
//		var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
	
		//Fecha de la factura
//		var checkin = $('#txtFechaDesde').datepicker({
//		  onRender: function(date) {
//			return date.valueOf() < now.valueOf() ? 'disabled' : '';
//		  }
//		}).on('changeDate', function(ev) {
//		  if (ev.date.valueOf() > checkout.date.valueOf()) {
//			var newDate = new Date(ev.date)
//			newDate.setDate(newDate.getDate() + 1);
//			checkout.setValue(newDate);
//		  }
//		  checkin.hide();
//		  $('#txtFechaHasta')[0].focus();
//		}).data('datepicker');
		
//		var checkout = $('#txtFechaHasta').datepicker({
//		  onRender: function(date) {
//			return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
//		  }
//		}).on('changeDate', function(ev) {
//		  checkout.hide();
//		}).data('datepicker');

//===================================================================================

		//txtFechaDesde2 - txtFechaHasta2
		$('#txtFechaDesde2').datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});	
		$('#txtFechaHasta2').datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});			
		$('#FchaCal2').click(function(){
			$('#txtFechaDesde2').data("datepicker").show();
		});
		$('#FchaCal3').click(function(){
			$('#txtFechaHasta2').data("datepicker").show();
		});	
		// disabling dates
//		var nowTemp = new Date();
//		var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
//	
//		//Fecha de la factura
//		var checkin = $('#txtFechaDesde2').datepicker({
//		  onRender: function(date) {
//			return date.valueOf() < now.valueOf() ? 'disabled' : '';
//		  }
//		}).on('changeDate', function(ev) {
//		  if (ev.date.valueOf() > checkout.date.valueOf()) {
//			var newDate = new Date(ev.date)
//			newDate.setDate(newDate.getDate() + 1);
//			checkout.setValue(newDate);
//		  }
//		  checkin.hide();
//		  $('#txtFechaHasta2')[0].focus();
//		}).data('datepicker');
		
//		var checkout = $('#txtFechaHasta2').datepicker({
//		  onRender: function(date) {
//			return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
//		  }
//		}).on('changeDate', function(ev) {
//		  checkout.hide();
//		}).data('datepicker');

//===========================================================================================
		
		//txtFechaDesdeDateTime - txtFechaHastaDateTime
		$('#txtFechaDesdeDateTime').datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});

		
		$('#txtFechaHastaDateTime').datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});
		$('#FchaCal4').click(function(){
			$('#txtFechaDesdeDateTime').data("datepicker").show();
		});
		$('#FchaCal5').click(function(){
			$('#txtFechaHastaDateTime').data("datepicker").show();
		});	
		// disabling dates
//		var nowTemp = new Date();
//		var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
//	
		//Fecha de la factura
//		var checkin = $('#txtFechaDesdeDateTime').datepicker({
//		  onRender: function(date) {
//			return date.valueOf() < now.valueOf() ? 'disabled' : '';
//		  }
//		}).on('changeDate', function(ev) {
//		  if (ev.date.valueOf() > checkout.date.valueOf()) {
//			var newDate = new Date(ev.date)
//			newDate.setDate(newDate.getDate() + 1);
//			checkout.setValue(newDate);
//		  }
//		  checkin.hide();
//		  $('#txtFechaHastaDateTime')[0].focus();
//		}).data('datepicker');
//		
//		var checkout = $('#txtFechaHastaDateTime').datepicker({
//		  onRender: function(date) {
//			return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
//		  }
//		}).on('changeDate', function(ev) {
//		  checkout.hide();
//		}).data('datepicker');



});
		
</script>


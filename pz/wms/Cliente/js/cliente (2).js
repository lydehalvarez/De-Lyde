var ClienteContratoCorte = {
	CargarCortesCombo: function(){
		
		var intCli_ID = $("#Clientes").val();
		
		$.ajax({
			url: urlBase + "ClienteContratoCorte_ajax.asp"
			, method: "POST"
			, async: false
			, data: {
				Tarea: 1
				, Cli_ID: intCli_ID
			}
			, success: function(res){
				$("#Cortes").html(res);
			}
		});
	
	}
	, CargarEstadosCuenta: function(){
		
		var intCli_ID = $("#Clientes").val();
		var intCliCto_ID = $("#Contratos").val();
		var intCliCr_ID = $("#Cortes").val();
		
		$.ajax({
			url: urlBase + "ClienteContratoCorte_ajax.asp"
			, method: "POST"
			, async: false
			, data: {
				Tarea: 1000
				, Cli_ID: intCli_ID
				, CliCto_ID: intCliCto_ID
				, CliCr_ID: intCliCr_ID
			}
			, success: function(res){
				$("#divContenedorEstadoCuenta").html(res)
			}
		});
		
	}
	, CargarEstadoCuentaDocumentosTotal: function( prmIntSerP_ID, prmIntSer_ID ){
		
		var intCli_ID = $("#Clientes").val();
		var intCliCr_ID = $("#Cortes").val();
		
		$.ajax({
			url: urlBase + "ClienteContratoCorte_ajax.asp"
			, method: "POST"
			, async: false
			, data: {
				Tarea: 1100
				, SerP_ID: prmIntSerP_ID
				, Ser_ID: prmIntSer_ID
				, Cli_ID: intCli_ID
				, CliCr_ID: intCliCr_ID
			}
			, success: function(res){
				$("#divContenedorEstadoCuentaDocumentos").html(res);
			}
		});
	}
	, LimpiarEstadoCuentaDocumentosTotal: function(){
		$("#divContenedorEstadoCuentaDocumentos").html("");
	}
	, ExportarEstadoCuentaDocumentos: function( prmIntSerP_ID, prmIntSer_ID ){
		var intCli_ID = $("#Clientes").val();
		var intCliCr_ID = $("#Cortes").val();
		
		$.ajax({
			url: urlBase + "ClienteContratoCorte_ajax.asp"
			, method: "POST"
			, dataType: "json"
			, async: false
			, data: {
				Tarea: 11000
				, SerP_ID: prmIntSerP_ID
				, Ser_ID: prmIntSer_ID
				, Cli_ID: intCli_ID
				, CliCr_ID: intCliCr_ID
			}
			, success: function(res){
				
				var ws = XLSX.utils.json_to_sheet(res);
				var wb = XLSX.utils.book_new(); 
				
				XLSX.utils.book_append_sheet(wb, ws, "Hoja 1");
				XLSX.writeFile(wb, "EstadoCuenta.xlsx");
				
			}
		});
	}
}

var ClienteContrato = {
	CargarContratosCombo: function(){
		
		var intCli_ID = $("#Clientes").val();
		
		$.ajax({
			url: urlBase + "ClienteContrato_ajax.asp"
			, method: "POST"
			, async: false
			, data: {
				Tarea: 1
				, Cli_ID: intCli_ID
			}
			, success: function(res){
				$("#Contratos").html(res);
			}
		});

	}
}
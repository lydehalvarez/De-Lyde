// JavaScript Document
var Carga = {
	Ver: function( prmIntCli_Id, prmIntCliOC_Id, prmIntCliOCP_Id ){
		$.ajax({
			url: urlBase + "Cli_OrdenCompra_ajax.asp"	
			, method: "post"
			, async: false
			, data: {
				Tarea: 1
				, Cli_Id: prmIntCli_Id
				, CliOC_Id: prmIntCliOC_Id
				, CliOCP_Id: prmIntCliOCP_Id
			}
			, success: function( res ){
				$("#divOCArtCar").html( res );
			}
		});				
	}
}

var Serie = {
	Ver: function( prmIntLot_Id ){
		$.ajax({
			url: urlBase + "Cli_OrdenCompra_ajax.asp"	
			, method: "post"
			, async: false
			, data: {
				Tarea: 2
				, Lot_Id: prmIntLot_Id
			}
			, success: function( res ){
				$("#divOCNumSer").html( res );
			}
		});						
	}
}
var Log = {
	Visualizar: function( prmIntCli_Id, prmIntCliOC_Id, prmIntCliOCP_Id, prmIntCliCC_Id ){
		
		$.ajax({
			url: urlBase + "Cli_OrdenCompra_ajax.asp"	
			, method: "post"
			, async: false
			, data: {
				Tarea: 3
				, Cli_Id: prmIntCli_Id
				, CliOC_Id: prmIntCliOC_Id
				, CliOCP_Id: prmIntCliOCP_Id
				, CliCC_Id: prmIntCliCC_Id
			}
			, success: function( res ){
				$("#divCargaLog").html( res );
			}
		});						
		
	}
}

// JavaScript Document
/* HA ID: 3 2020-SEP-11 Se agrega identificador de producto a ver Numeros de Series.
*/
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

//HA ID: 3 Se agrega Identificador de Producto
var Serie = {
	Ver: function( prmIntLot_ID ){
		
		var prmIntPro_ID = (arguments[1] == undefined) ? -2 : arguments[1];

		$.ajax({
			url: urlBase + "Cli_OrdenCompra_ajax.asp"	
			, method: "post"
			, async: false
			, data: {
				Tarea: 2
				, Lot_ID: prmIntLot_ID
				, Pro_ID: prmIntPro_ID
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

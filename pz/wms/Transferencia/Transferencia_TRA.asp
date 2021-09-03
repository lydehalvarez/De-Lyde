<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Cli_ID = Parametro("Cli_ID",-1)

%>

<table id="example" class="table table-striped table-bordered" style="width: 100%;">
        <thead>
            <tr>
                <th>Folio</th>
                <th>Estatus</th>
                <th>Fecha registro</th>
            </tr>
        </thead>
</table>

<script src="/Template/inspina/js/plugins/dataTables/datatables.min.js"></script>
<script type="application/javascript">

var Datos = {}
$(document).ready(function() {

    $('#example').DataTable( {
		order: [[ 0, 'desc' ]],
		ajax:{
			complete: function (datos) {
				Datos = datos.responseJSON.data
				//console.log(Datos)
				$( ".btnCortePicking" ).prop( "disabled", false );	
			},
			type: "GET",
			url: "/pz/wms/Transferencia/DataTransferencia.asp?Cli_ID="+<%=Cli_ID%>,
		},
		columns: [
            { "data": "Folio" },
            { "data": "Estatus" },
            { "data": "Fecha" }
        ]    
	});
	
	
});
</script>
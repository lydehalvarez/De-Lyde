<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	
	var sSQLCli = "SELECT * FROM Cliente WHERE Cli_ID in ( "+Cli_ID+") "
	
var rsCli = AbreTabla(sSQLCli,1,0)

if(!rsCli.EOF){  
	var Cli_Nombre = rsCli.Fields.Item("Cli_Nombre").Value
}	
%>
<div id="TransferenciaFormato">
</div>
 

<script type="application/javascript">


$(document).ready(function(e) {
    CargaFormatoTransferencia($('#Cli_ID').val())
});

function CargaFormatoTransferencia(Cli_ID){
	$.post("/pz/wms/Transferencia/Formatos/<%=Cli_Nombre%>/Transferencia_Surtido.asp",
	{
		Cli_ID:Cli_ID,
		TA_ArchivoID:<%=TA_ArchivoID%>
	}
    , function(data){
		$('#TransferenciaFormato').html(data)
	});
}


</script>
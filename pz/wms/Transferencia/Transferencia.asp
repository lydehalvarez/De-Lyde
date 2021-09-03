<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ID = Parametro("TA_ID",-1)
   
   var TA_EstatusCG89 = 0
   var sRuta = ""

   	var sSQL = "SELECT TA_EstatusCG89 "
		sSQL += " FROM TransferenciaAlmacen "
   		sSQL += " WHERE TA_ID = " + TA_ID
   
	var rsTA = AbreTabla(sSQL,1,0)
    if (!rsTA.EOF){
		TA_EstatusCG89 = rsTA.Fields.Item("TA_EstatusCG89").Value
	}

//	1	Recibiendo
//	2	Fin recepcion
//	3	Picking
   if(TA_EstatusCG89 < 4){
		sRuta = "/pz/wms/Transferencia/TipoTransferencia.asp"
	}
   
//	4	Packing
   if(TA_EstatusCG89 < 4){
		sRuta = "/pz/wms/Transferencia/TipoTransferencia.asp"
	}
//	5	Shipping
//	6	Deliver
//	7	Facturado 

 
%>
<div id="Transferencia"></div>

<script type="application/javascript">

$(document).ready(function(e) {
    TipoTransferencia()
});

function TipoTransferencia(){
	$('#Transferencia').load("/pz/wms/Transferencia/TipoTransferencia.asp")
}

</script>


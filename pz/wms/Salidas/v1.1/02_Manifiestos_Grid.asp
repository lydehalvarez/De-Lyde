<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
<%
	var Man_ID = Parametro("Man_ID",-1)
	
	var sSQLM = "SELECT * FROM Manifiesto_Salida WHERE Man_ID = "+Man_ID
	
    var sSQL  = " SELECT top(100) * "
		sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a"
        sSQL += " WHERE t.Cli_ID = c.Cli_ID "
		sSQL += " AND t.TA_End_Warehouse_ID = a.Alm_ID "
		sSQL += " AND t.TA_EstatusCG51  = 5 "
	

	bHayParametros = false
	ParametroCargaDeSQL(sSQLM,0)  
%>
<div class="ibox-title">
    <h4>Manifiesto <%=Parametro("Man_Folio","")%></h4>
</div>    
<div class="project-list">
    <table class="table">
        <thead>
            <tr>
                <th>Cliente</th>
                <th>Transportista</th>
                <th>Folio</th>
                <th>Folio Cliente</th>
                <th>Selecciona</th>
            </tr>
        </thead>
        <tbody>
        <%
            var rsTransferencia = AbreTabla(sSQL,1,0)
            while (!rsTransferencia.EOF){
				var TA_ID = rsTransferencia.Fields.Item("TA_ID").Value
				var Cli_Nombre = rsTransferencia.Fields.Item("Cli_Nombre").Value
				var TA_Transportista = rsTransferencia.Fields.Item("TA_Transportista").Value
				var TA_Folio = rsTransferencia.Fields.Item("TA_Folio").Value
				var TA_FolioCliente = rsTransferencia.Fields.Item("TA_FolioCliente").Value
				if(TA_FolioCliente == ""){
					TA_FolioCliente = "N/A"	
				}
				
		%>
            <tr>
                <td class="project-title"><%=Cli_Nombre%></td>
                <td class="project-title"><%=TA_Transportista%></td>
                <td class="project-title"><%=TA_Folio%></td>
                <td class="project-title">
                 <a href="#"><%=TA_FolioCliente%></a>
                <br/>
                <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small></td>
                <td class="project-title"><input type="checkbox" data-esov="0" id="check_<%=TA_ID%>" value="<%=TA_ID%>" class="i-checks ChkRel"></input></td>
            </tr>
        <%
            rsTransferencia.MoveNext() 
            }
        rsTransferencia.Close()   
        %>       
        </tbody>
    </table>
</div>
    <script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){    
		$('.i-checks').iCheck({  checkboxClass: 'icheckbox_square-green' }); 

});

$('.ChkRel').on('ifChecked', function(event){
	console.log($(this).val())
	ManifiestoFunciones.GuardaData($(this).val(),$(this).data('esov'))
});
$('.ChkRel').on('ifUnchecked', function(event){
	console.log($(this).val())
	ManifiestoFunciones.BorraData($(this).val(),$(this).data('esov'))
});

</script>    

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
var bIQ4Web = false 

var iProid = Parametro("bsproid",-1)
var iProFid = Parametro("bsprofid",-1)
var iCliid = -1

	if(bIQ4Web) {
		Response.Write("iProid: " + iProid + "<br>")
		Response.Write("iProFid: " + iProFid + "<br>")
		Response.Write("iCliid: " + iCliid + "<br>")
	}

%>
<div class="form-group">
    <table class="table table-striped table-hover">
        <thead>
            <tr> 
                <th class="text-center" width="5%">N&uacute;m.</th>
                <th class="text-center">Status</th>
                <th class="text-center">For&aacute;neo</th>
                <th class="text-center">Tipo de servicio</th>
                <th class="text-center">Detalle del servicio</th>
                <th class="text-left">Cliente</th>
                <th class="text-left">Fecha de solicitud</th>
                <th class="text-center"></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>Pendiente</td>
                <td>Si</td>
                <td>Volado</td>
                <td>Detalle</td>
                <td>Cliente</td>
                <td>10/08/2018</td>
                <td class="text-center">
                    <a href="javascript:Selecciona(<%=iProid%>, <%=iProFid%>, <%=iCliid%>)" class="btn btn-white btn-sm"><i class="fa fa-share"></i> Ver </a>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td>En transito</td>
                <td>Si</td>
                <td>Rodado</td>
                <td>Detalle</td>
                <td>Cliente</td>
                <td>09/06/2018</td>
                <td class="text-center">
                    <a href="javascript:Selecciona(<%=iProid%>, <%=iProFid%>, <%=iCliid%>)" class="btn btn-white btn-sm"><i class="fa fa-share"></i> Ver </a>
                </td>
            </tr>
            <tr>
                <td>3</td>
                <td>Validacion</td>
                <td>Si</td>
                <td>Aeropuerto</td>
                <td>Detalle</td>
                <td>Cliente</td>
                <td>21/06/2018</td>
                <td class="text-center">
                    <a href="javascript:Selecciona(<%=iProid%>, <%=iProFid%>, <%=iCliid%>)" class="btn btn-white btn-sm"><i class="fa fa-share"></i> Ver </a>
                </td>
            </tr>
        </tbody>
    </table>
</div>


				
<script type="text/javascript">

	function Selecciona(ijsProID, ijsProFID, ijsCliID) {
		$("#Pro_ID").val(ijsProID);
		$("#ProF_ID").val(ijsProFID);
		$("#Cli_ID").val(ijsCliID);
		CambiaVentana(18,5100);
	}

</script>

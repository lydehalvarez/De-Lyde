<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
var bIQ4Web = false 

var iProid = Parametro("bsproid",-1)
var iProFid = Parametro("bsprofid",-1)

	if(bIQ4Web) {
		Response.Write("iProid: " + iProid + "<br>")
		Response.Write("iProFid: " + iProFid + "<br>")
	}

%>
<div class="col-lg-12">	
	<div class="ibox-content">
		<table class="table table-hover">
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th class="text-center">Folio interno</th>
					<th class="text-left">Cliente</th>
					<th class="text-left">Tipo de servicio</th>
					<th class="text-center">For&aacute;neo</th>
					<th class="text-left">Estatus</th>
					<th class="text-left">Tipo de unidad</th>
					<th class="text-center">Placas</th>
					<th class="text-center">Fecha carga</th>
					<th class="text-left">Operador</th>
					<th class="text-center"></th>
				</tr>
			</thead>
			<tbody>
			<%
			var sSQL_OS = " SELECT Ser_ID, Ser_FolioInterno"
				sSQL_OS += ", (SELECT C.Cli_Nombre FROM Cliente C WHERE C.Cli_ID = Orden_Servicio.Cli_ID) AS CLIENTE"
				sSQL_OS += ", (SELECT C.ProE_Nombre FROM BPM_Proceso_Estatus C"
				sSQL_OS += " WHERE C.Pro_ID = Orden_Servicio.Ser_BPM_Pro_ID AND C.ProE_ID = Orden_Servicio.Ser_BPM_Estatus) AS ESTATUS"
				sSQL_OS += ", (SELECT TU. TUni_Nombre FROM Cat_TipoUnidad  TU WHERE TU.TUni_ID = Orden_Servicio.TUni_ID) AS TUNIDAD"
				sSQL_OS += ", CONVERT(VARCHAR(10),Ser_FechaCarga, 103) AS FECHACARGA"
				sSQL_OS += ", (SELECT Ope_Nombre FROM Operador O WHERE O.Ope_ID= Orden_Servicio.Ope_ID) AS OPERADOR"
				sSQL_OS += ", (SELECT C.Tsv_Nombre FROM TipoServicio C WHERE C.Tsv_ID = Orden_Servicio.Tsv_ID) AS TIPOSERVICIO"
				sSQL_OS += ", (SELECT C.Veh_Placas FROM Vehiculo C WHERE C.Veh_ID = Orden_Servicio.Veh_ID) AS PLACAS"
				sSQL_OS += ", CASE ISNULL(Ser_ServicioForaneo, 0) WHEN 1 THEN 'Sí' ELSE 'No' END AS FORANEO"
				sSQL_OS += " FROM Orden_Servicio"
				sSQL_OS += " WHERE Ser_BPM_Pro_ID = "+iProid+" AND Ser_BPM_Flujo = "+iProFid

				if(bIQ4Web) { Response.Write(sSQL_OS) }
			    var iRegOS = 0
			    var iSerID = -1
				var rsOrdenServ = AbreTabla(sSQL_OS,1,0)

					while (!rsOrdenServ.EOF){
			   		iSerID = rsOrdenServ.Fields.Item("Ser_ID").Value
			   		iRegOS++
			%>				
				<tr>
					<td class="text-center"><%=iRegOS%></td>
					<td class="text-center"><%=rsOrdenServ.Fields.Item("Ser_FolioInterno").Value%></td>
					<td class="text-left"><%=rsOrdenServ.Fields.Item("CLIENTE").Value%></td>
					<td class="text-left"><%=rsOrdenServ.Fields.Item("TIPOSERVICIO").Value%></td>
					<td class="text-center"><%=rsOrdenServ.Fields.Item("FORANEO").Value%></td>	
					<td class="text-left"><%=rsOrdenServ.Fields.Item("ESTATUS").Value%></td>
					<td class="text-left"><%=rsOrdenServ.Fields.Item("TUNIDAD").Value%></td>
					<td class="text-center"><%=rsOrdenServ.Fields.Item("PLACAS").Value%></td>	
					<td class="text-center"><%=rsOrdenServ.Fields.Item("FECHACARGA").Value%></td>
					<td class="text-left"><%=rsOrdenServ.Fields.Item("OPERADOR").Value%></td>
					<td class="text-center"><a href="javascript:SeleccionaOS(<%=iSerID%>)" class="btn btn-white btn-sm"><i class="fa fa-share"></i> Ver </a></td>
				</tr>
			<%
					rsOrdenServ.MoveNext() 
				}
				rsOrdenServ.Close()   
			%>	
				<!--tr>
					<td>2</td>
					<td>
						<span class="pie" style="display: none;">226,134</span><svg class="peity" height="16" width="16">
						<path d="M 8 8 L 8 0 A 8 8 0 1 1 2.2452815972907922 13.55726696367198 Z" fill="#1ab394"></path>
						<path d="M 8 8 L 2.2452815972907922 13.55726696367198 A 8 8 0 0 1 7.999999999999998 0 Z" fill="#d7d7d7"></path></svg>
					</td>
					<td>Jacob</td>
					<td class="text-warning"><i class="fa fa-level-down"></i> -20%</td>
				</tr-->
				<input type="hidden" name="Ser_ID" id="Ser_ID" value="-1">
			</tbody>
		</table>
	</div>
</div>
	
<script type="text/javascript" language="javascript">

	function SeleccionaOS(ijsSerID) {
		$("#Ser_ID").val(ijsSerID);
		CambiaVentana(18,10852);
	}

</script>	
	
	

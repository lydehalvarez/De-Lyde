<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 2		2021-JUL-26 Ajustes generales de visualizacion, boton de despliegue de series
// HA ID: 3		2021-AGO-03 Siniestro: Ajustes de cierre de siniestro
// HA ID: 4 	2021-AGO-24 Entrega Parcial: Agregado de proceso y cierre de Entrega Parcial

var TA_ID = Parametro("TA_ID",-1)

/* HA ID: 3 INI extracción de información del Inforamcion de la Trasnferencia */

var cxnTipo = 0;

var intTA_EstatusCG51 = -1;
var intTA_SiniestroSeleccionCerrado = 0;

/* HA ID: 4 Variable de Entrega Parcial Cerrada */
var intTA_EntregaParcialSeleccionCerrado = 0

var sqlTA = "SELECT TA.* "
		+ ", ISNULL(TA_SiniestroSeleccionCerrado, 0) AS TA_SiniestroSeleccionCerrado "
		+ ", ISNULL(TA_EntregaParcialSeleccionCerrado, 0) AS TA_EntregaParcialSeleccionCerrado "
	+ "FROM TransferenciaAlmacen TA "
	+ "WHERE TA.TA_ID = " + TA_ID + " "

var rsTA = AbreTabla(sqlTA, 1, cxnTipo)

if( !(rsTA.EOF) ){
	intTA_EstatusCG51 = rsTA("TA_EstatusCG51").Value
	intTA_SiniestroSeleccionCerrado = rsTA("TA_SiniestroSeleccionCerrado").Value

	/* HA ID: 4 Variable de EntregaParcial Cerrada */
	intTA_EntregaParcialSeleccionCerrado = rsTA("TA_EntregaParcialSeleccionCerrado").Value
}

rsTA.Close();

/* HA ID: 4 Estatus de EntregaParcial */
var Transferencia = {
		Estatus: {
			  SiniestroTotal: 18
			, SiniestroParcial: 24
			, EntregaParcial: 20
		}
	}

var arrEsSin = [
		Transferencia.Estatus.SiniestroTotal
		, Transferencia.Estatus.SiniestroParcial
	];

var bolBtnSinCieVisualiza = ( arrEsSin.indexOf( parseInt(intTA_EstatusCG51) ) > -1 && parseInt(intTA_SiniestroSeleccionCerrado) == 0 );

/* HA ID: 4 Estatus de EntregaParcial */
var bolBtnEPaCieVisualiza = ( parseInt(intTA_EstatusCG51) == Transferencia.Estatus.EntregaParcial && parseInt(intTA_EntregaParcialSeleccionCerrado) == 0 )

/* HA ID: 3 FIN */
%>
<table class="table">
    <thead>
		<th width="199">
			<input type="checkbox" id="CheckAll" onchange="$('.Series').prop('checked', $(this).is(':checked'));"/>
		</th>
    	<th width="143">SKU</th>    	
    	<th width="723">Producto</th>
    	<th width="237">Cantidad Solicitada</th>
    	<th width="213">Cantidad Enviada</th>
    	
		<% /* HA: ID: 2 Agregado de Columna */ %>
		<th></th>

    </thead>
    <tbody>
<%
    var TotalSol = 0
    var TotalEnv = 0

	var sSQLTr  = "SELECT t.TA_ID, TAA_ID, Ta_Folio , Pro_Nombre, TAA_SKU, TAA_Cantidad "
        sSQLTr += " ,(SELECT COUNT(*)  FROM TransferenciaAlmacen_Articulo_Picking p1 "
        sSQLTr += " WHERE p1.TA_ID = t.TA_ID  AND p1.TAA_ID = a.TAA_ID) as  Enviada "
        sSQLTr += " FROM TransferenciaAlmacen t, TransferenciaAlmacen_Articulos a, Producto p "
        sSQLTr += " WHERE t.TA_ID = " + TA_ID
        sSQLTr += " AND t.TA_ID = a.TA_ID "
        sSQLTr += " and a.Pro_ID = P.Pro_ID "
 
    var rsPicked = AbreTabla(sSQLTr,1,0)

	while(!rsPicked.EOF){ 
         var Total_Enviado = rsPicked.Fields.Item("Enviada").Value 
         var TAA_ID = rsPicked.Fields.Item("TAA_ID").Value 
         var TAA_Cantidad = rsPicked.Fields.Item("TAA_Cantidad").Value

         var TotalSol = TotalSol + TAA_Cantidad
         var TotalEnv = TotalEnv + Total_Enviado
%>		
			<% /* HA: ID: 2 INI Agregado de data */ %>
            <tr class="cssTrProReg"
			 data-ta_id="<%= rsPicked("TA_ID").Value %>"
			 data-taa_id="<%= rsPicked("TAA_ID").Value %>">
                <td align="center">
					<input class="Series" type="checkbox" value="<%=TAA_ID%>"/>
				</td>
				<td><%=rsPicked.Fields.Item("TAA_SKU").Value%></td>                
                <td class="project-title">

						<i class="fa fa-tag"></i> <%=rsPicked.Fields.Item("Pro_Nombre").Value%>

				</td>
                <td><%=TAA_Cantidad%></td>
                <td id="CantidadEnviada"><%=Total_Enviado%></td>
                
				<% /* HA: ID: 2 INI Agregado de Columna */ %>
				<td>

					<a class="btn btn-white btn-sm" id="btnSeriesVer"
					onclick='Serie.Listado.Visualizar({Objeto: $(this)})'>
						<i class="fa fa-files-o"></i> Ver Series
					</a>
					<a class="btn btn-white btn-sm" id="btnSeriesOcultar" style="display: none;"
					onclick='Serie.Listado.Ocultar({Objeto: $(this)})'>
						<i class="fa fa-files-o"></i> Ocultar Series
					</a>
					
				</td>
				<% /* HA: ID: 2 FIN */ %>

            </tr>
        <%	
            rsPicked.MoveNext() 
        }
        rsPicked.Close()   
		%>
            <tr>
                <td>&nbsp;</td>
				<td>&nbsp;</td>
                <td>Total</td>
                <td><%=TotalSol%></td>
                <td><%=TotalEnv%></td>
                <td class="text-nowrap">
					
				</td>
			</tr>
			<tr>
				<td colspan="6" class="text-nowrap text-right" >
					<a class="btn btn-success" onclick="Exportar()" title="Exportar">
						<i class="fa fa-file-excel-o"></i> Exportar
					</a>
<% 	/* HA ID: 3 INI Agregado de Boton de Cierre de Siniestro */ 
	if( bolBtnSinCieVisualiza ){
%>
					<a class="btn btn-warning" onclick="Transferencia.Siniestro.Cerrar({TA_ID: <%= TA_ID %>})">
						<i class="fa fa-lock"></i> Cerrar Siniestro
					</a>
<%
	}

	/* HA ID: 3 FIN */

	/* HA ID: 4 INI Agregado de Boton de Cierre de EntregaParcial */ 
	if( bolBtnEPaCieVisualiza ){
%>
					<a class="btn btn-warning" onclick="Transferencia.EntregaParcial.Cerrar({TA_ID: <%= TA_ID %>})">
						<i class="fa fa-lock"></i> Cerrar Entrega Parcial
					</a>
<%
	}
	/* HA ID: 4 FIN */
%>
				</td>
			</tr>
    </tbody>
</table>
<br />
<br />
<br />
<br />


<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">

var verSerie = {}


$(document).ready(function(e) {
	
    $('.btnVerSerie').click(function(e) {
        //CargaSeries()
//		console.log($('#chkSeries').val())
//		console.log($("input[class='Series']:checked").val())
		verSerie["TA_ID"] = <%=TA_ID%>
		var Seleccionados = []
		$("input[class='Series']:checked").each(function(index, element) {
			Seleccionados.push($(this).val())
		});
		verSerie["chkSeries"] = Seleccionados.toString()
        VerSeries = 1
        $("#dvHistoria").removeClass("Caja-Flotando");
		console.log(verSerie)
		CargaSeries(verSerie)
		$('#divHistLineTimeGrid').focus()
		
    });
	
});



function CargaSeries(verSerie){	
	$('#loading').show('slow')
	
	$.post("/pz/wms/TA/TA_VerSeries.asp",verSerie,function(data){
		$('#divSeries').html(data)
		$('#loading').hide('slow')
	});
}    

function Exportar(){

	var intTA_ID = $("#TA_ID").val();
	var arrTAA_IDs = [];
	$(".Series:checked").each(function(){ arrTAA_IDs.push( $(this).val() ) })

	if( arrTAA_IDs.length == 0 ){
		Avisa("warning", "Exportacion", "Seleccionar el producto a exportar");
	} else {

		$.ajax({
			url: "/pz/wms/TA/TA_ajax.asp"
			, method: "post"
			, async: false
			, dataType: "json"
			, data: {
				Tarea: 16
				, TA_ID: intTA_ID
				, TAA_IDs: arrTAA_IDs.join(",")
			}
			, success: function( res ){
 
                var NombreArchivo = "" 
                NombreArchivo = res[0].Folio + "_" + res[0].Destino + ".xlsx";
				var xlsData = XLSX.utils.json_to_sheet( res );
				var xlsBook = XLSX.utils.book_new(); 

                XLSX.utils.book_append_sheet(xlsBook, xlsData, "SeriesTransferidas");
                XLSX.writeFile(xlsBook, NombreArchivo);
                
			}
		});
	}
}

</script>



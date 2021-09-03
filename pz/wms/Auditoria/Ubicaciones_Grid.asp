<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<!--#include file="./utils-js.asp" -->

<%

// HA ID: 2 Se agrega validacion si se requiere en otra página

    var rqbolEnPagAud = Parametro("EnPagAud", 0)

    var Aud_ID = Parametro("Aud_ID", -1);
    var enProceso = Parametro("enProgreso", -1)    

    var iRegistro = 0
    var SKU = ""
    var Pt_ID = ""
    var sEtiqueta = ""
    var strArea = ""
    var Pro_ID = -1

	var sSQL = "SELECT pt.Pt_ID, Pro_SKU, Pro_Nombre, Pro.Pro_ID, Pro_Descripcion ";
    sSQL += ", pt.Pt_LPN ";
    sSQL += ", PT_Cantidad_Actual ";
    sSQL += ", Ubi.Ubi_Nombre ";
    sSQL += ", CONVERT(NVARCHAR(12),Pt_FechaIngreso,103) as FECHAINGRESO ";
    sSQL += ", Lot.Lot_Folio ";
    sSQL += ", Are.Are_Nombre ";
    sSQL += ", ISNULL(Ubi.Ubi_Etiqueta, '') AS Ubi_Etiqueta ";
    sSQL += ", dbo.fn_CatGral_DameDato(146, pt.Pt_EstatusCG146) as Estatus ";
    sSQL += ", dbo.fn_CatGral_DameDato(147, pt.Pt_ResultadoCG147) as Resultado ";
    sSQL += ", pt.Aud_ID ";
    sSQL += ", (SELECT Usu_Nombre ";
	sSQL += "   FROM dbo.Usuario ";
	sSQL += "   WHERE Usu_ID = aub.AudU_AsignadoA "
	sSQL += " ) as Auditor ";
    sSQL += " FROM Auditorias_Pallet PT ";
    sSQL += "   LEFT JOIN Producto Pro ";
    sSQL += "       ON PT.Pro_ID = Pro.Pro_ID ";
    sSQL += "   LEFT JOIN Ubicacion Ubi ";
    sSQL += "       ON PT.Ubi_ID = Ubi.Ubi_ID ";
    sSQL += "   LEFT JOIN Ubicacion_Area Are ";
    sSQL += "       ON Ubi.Are_ID = Are.Are_ID ";
    sSQL += "   LEFT JOIN Inventario_Lote Lot ";
    sSQL += "       ON PT.Lot_ID = Lot.Lot_ID ";
    sSQL += "   LEFT JOIN Auditorias_Ubicacion aub";
	sSQL += "	    ON pt.Aud_ID = aub.Aud_ID";
    sSQL += "       AND pt.Pt_ID = aub.Pt_ID";
    sSQL += " WHERE pt.Aud_ID = " + Aud_ID;
    sSQL += autocompletarfiltrosQuery();

	
	function autocompletarfiltrosQuery() {
        var sku = Parametro("Sku", "");
        var ubicacion = Parametro("Ubicacion", "");
        var lpn = Parametro("Lpn", "");
        var estatus = Parametro("Estatus", -1);
        var resultado = Parametro("Resultado", -1);
        var idAuditor = Parametro("Auditor", -1);
		
        var sqlQuery = "";

		if((sku !== "")
		|| (ubicacion !== "")
		|| (lpn !== "")
		|| (estatus > -1)
		|| (resultado > -1)
        || (idAuditor > -1)
        || (enProceso > -1)
		) {
			if(sku !== "") {
				sqlQuery += " AND Pro_SKU like '%" + sku + "%'";
			}
			if(ubicacion !== "") {
				sqlQuery += " AND Ubi.Ubi_Nombre like '%" + ubicacion + "%'";
			}
			if(lpn !== "") {
				sqlQuery += " AND pt.Pt_LPN like '%" + lpn + "%'";
			}
            if(estatus > -1) {
                sqlQuery += " AND pt.Pt_EstatusCG146 = " + estatus;
            }
            if(resultado > -1) {
                sqlQuery += " AND pt.Pt_ResultadoCG147 = " + resultado;
            }
            if(idAuditor > -1) {
                sqlQuery += " AND aub.AudU_AsignadoA = " + idAuditor;
            }
            if(enProceso !== -1) {
                sqlQuery += " AND aub.AudU_EnProceso = " + enProceso;
            }
		}

		return sqlQuery;
	}

    function cargarEnProceso(Registro, aud_id, pt_id, closest) {
        $("<tr id=\'tr_" + Registro + "\'><td id=\'" + Registro + "\'></tr>").insertAfter(closest);
        
        var dato = {
            aud_id: aud_id,
            pt_id: pt_id,
            enProceso: enProceso
        }

        $("#td_"+Registro).load("/pz/wms/Auditoria/Ubicacion_Detalle.asp", dato);
    }
%>

<table class="table table-striped table-bordered">
	<thead>
    	<tr>
            <th width="4%">Num</th>
        	<th width="13%">Producto</th>
        	<th width="4%">LPN</th>
        	<th width="11%">Cantidad</th>
        	<th width="11%">Auditor asignado</th>
        	<th width="7%">Estatus</th>
        	<th width="8%">Resultado</th>
<%
    if (enProceso === -1) {
%>
        	<th width="10%">&nbsp;</th>
<%
    }
%>
        </tr>
    </thead>
    <tbody>
<%    
	var rsInv = AbreTabla(sSQL,1,0)

	if(!rsInv.EOF) {
		while(!rsInv.EOF){ 
        var aud_id = rsInv.Fields.Item("Aud_ID").Value
		var Pt_ID = rsInv.Fields.Item("Pt_ID").Value
        var sEtiqueta = rsInv.Fields.Item("Ubi_Etiqueta").Value
		var strArea = rsInv.Fields.Item("Are_Nombre").Value
		SKU = rsInv.Fields.Item("Pro_SKU").Value 
        Pro_ID = rsInv.Fields.Item("Pro_ID").Value
        var ptEstatus = rsInv.Fields.Item("Estatus").Value
        var ptResultado = rsInv.Fields.Item("Resultado").Value;
        var auditor = rsInv.Fields.Item("Auditor");

        if(sEtiqueta != "") {
            sEtiqueta = "<br><small>" + sEtiqueta + "</small>"
        }
        iRegistro++
	%>
	<tr class="articulos" id="Renglon<%=iRegistro%>">
        <td nowrap="nowrap"><%=iRegistro%></td>
        <td class="project-title">
          <a class="actualiza" data-sku="<%=SKU%>" data-skuid="<%=Pro_ID%>">
            <%=SKU%>
            </a>
            <br>
            <small title="<%=Pro_ID%>">
                <%=rsInv.Fields.Item("Pro_Nombre").Value%>    
            </small>
	    </td>
    	<td nowrap="nowrap">
            <a>
                <%= rsInv.Fields.Item("Pt_LPN").Value %>
            </a>
            <small>
                <%=rsInv.Fields.Item("Ubi_Nombre").Value%>
                <br>(<%= strArea %> - <%=sEtiqueta%>)
            </small>
        </td>
    	<td align="center"><% Response.Write(formato(rsInv.Fields.Item("PT_Cantidad_Actual").Value,0)) %></td>
    	<td><small><%=auditor%></small></td>
        <td><%=ptEstatus%></td>
        <td><%=ptResultado%></td>
<%
    if (enProceso === -1) {
        if( rqbolEnPagAud == 0 ){
%>
    	<td>
            <button
                class="btn btn-danger btnCierra btn-xs"
                id="btnC<%=iRegistro%>" 
                data-reg="<%=iRegistro%>"
                style="display:none"
                data-proid="<%=Pro_ID%>">Cerrar</button>
            <button class="btn btn-info btnDespliega btn-xs" id="btnV<%=iRegistro%>"
                    data-audid="<%=aud_id%>"
                    data-ptid="<%=Pt_ID%>"
                    data-reg="<%=iRegistro%>">Ver resultados</button>
		</td>
    </tr>
<%
        }
    } else if (enProceso !== -1) {
%>
    <tr id="tr_<%=iRegistro%>">
        <td colspan="10" id="td_<%=iRegistro%>">
            <div class="wrapper wrapper-content">
                <div class="row animated fadeInRight">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Resultado de las visitas a la ubicaci&oacute;n</h5>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </td>
    </tr>
<%
    }
%>
<%
            rsInv.MoveNext()
        } 
        rsInv.Close()
	} else {
%>
	<tr>
    	<td colspan="10">No tiene ubicaciones registradas</td>
    </tr>
<%
	}
%>
    </tbody>
</table>
            <br><br><br><br><br><br><br><br><br><br><br><br>
<script type="application/javascript">
    
var loading = '<div class="spiner-example">'
					+'<div class="sk-spinner sk-spinner-three-bounce">'
						+'<div class="sk-bounce1"></div>'
						+'<div class="sk-bounce2"></div>'
						+'<div class="sk-bounce3"></div>'
					+'</div>'
				+'</div>'
    
    $(document).ready(function(){
        $('.btnDespliega').click(function(e) {
            e.preventDefault(); 
            $(this).hide('slow')
            var Registro = $(this).data('reg')
            var aud_id = $(this).data('audid')
            var pt_id = $(this).data('ptid');
            $('#btnC'+Registro).show('slow')

            $('<tr id="tr_'+Registro+'"><td colspan="10" id="td_'+Registro+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            
            var dato = {
                aud_id: aud_id,
                pt_id: pt_id
            }

            $("#td_"+Registro).load("/pz/wms/Auditoria/Ubicacion_Detalle.asp", dato);
        });
    
        $('.btnCierra').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var Registro = $(this).data('reg')
            $('#btnV'+Registro).show('slow')
            $('#tr_'+Registro).hide('slow')
            setTimeout(function(){
                $('#tr_'+Registro).remove()
            },800)
        });
    });

    function cargarEnProceso(Registro, aud_id, pt_id) {
        $('<tr id="tr_'+Registro+'"><td colspan="10" id="td_'+Registro+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
        
        var dato = {
            aud_id: aud_id,
            pt_id: pt_id,
            enProceso: enProceso
        }

        $("#td_"+Registro).load("/pz/wms/Auditoria/Ubicacion_Detalle.asp", dato);
    }
    
</script>





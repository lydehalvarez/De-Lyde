<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	var Tipo = Parametro("Tipo",-1)
	
	var SQL = ""
	var Titulo = ""
	var Regla = " AND a.TA_ArchivoID =  "+TA_ArchivoID
		Regla += " AND a.Cli_ID = 6 "
		Regla += " AND a.TA_Orden = 0 "

	switch(parseInt(Tipo)){
		case -1:
			SQL = "SELECT COUNT(*) Cantidad, TA_Orden Dato, TA_Orden ID "
			SQL += " FROM TransferenciaAlmacen a "
			SQL += " WHERE a.TA_ArchivoID =  "+TA_ArchivoID
			SQL += " AND a.Cli_ID = 6 "
			SQL += " AND a.TA_Orden = 0 "
			SQL += " GROUP BY TA_Orden "
			
			Titulo = "Orden asigado"
		break;
		case 1:
			SQL = "SELECT COUNT(*) Cantidad,[dbo].[fn_DameEstado] (c.Edo_ID) Dato,c.Edo_ID ID "
			SQL += " FROM TransferenciaAlmacen a,Almacen b,Cat_Aeropuerto c "
			SQL += " WHERE b.Alm_ID = a.TA_End_Warehouse_ID "
			SQL += " AND b.Aer_ID = c.Aer_ID "
			SQL += Regla
			SQL += " GROUP BY c.Edo_ID "
			
			Titulo = "Aeropuerto"
		break;
		case 2:
			SQL = "SELECT COUNT(*) Cantidad,Alm_Ruta as Dato,Alm_Ruta as ID  "
			SQL += " FROM TransferenciaAlmacen a,Almacen b "
			SQL += " WHERE b.Alm_ID = a.TA_End_Warehouse_ID "
			SQL += Regla
			SQL += " GROUP BY Alm_Ruta "
			
			Titulo = "Ruta"
		break;
		case 3:
			SQL = "SELECT COUNT(*) Cantidad,Alm_Region as Dato,Alm_Region as ID "
			SQL += " FROM TransferenciaAlmacen a,Almacen b "
			SQL += " WHERE b.Alm_ID = a.TA_End_Warehouse_ID "
			SQL += Regla
			SQL += " GROUP BY Alm_Region "
			
			Titulo = "Regi&oacute;n"
		break;
		case 4:
			SQL = "SELECT COUNT(*) Cantidad,[dbo].[fn_CatGral_DameDato](94,b.Alm_TipoDeRutaCG94) as Dato,Alm_TipoDeRutaCG94 ID "
			SQL += " FROM TransferenciaAlmacen a,Almacen b "
			SQL += " WHERE b.Alm_ID = a.TA_End_Warehouse_ID "
			SQL += Regla
			SQL += " GROUP BY b.Alm_TipoDeRutaCG94 "
			
			Titulo = "Paqueteria"
		break;
		case 5:
			SQL = "SELECT COUNT(*) Cantidad,Tda_ID  Dato,Tda_ID ID"
			SQL += " FROM TransferenciaAlmacen a,Almacen b "
			SQL += " WHERE b.Alm_ID = a.TA_End_Warehouse_ID "
			SQL += Regla
			SQL += " GROUP BY b.Tda_ID "
			
			Titulo = "Tienda"
		break;
	}
	

%>
<div class="text-right">
<div class="btn-group" role="group" aria-label="Basic example">
    <button type="button" value="<%=Tipo%>" class="btn btn-danger btnQuitaOrden">Restablecer</button>
    <button type="button" class="btn btn-success btnGuardaPlan">Guardar planificaci&oacute;n</button>
</div>
</div>
<table class="table">
	<thead>
        <tr>
            <th>Prioridad/ Orden</th>
            <th>Cantidad</th>
            <th><%=Titulo%></th>
        </tr>
    </thead>
	<tbody>
    <%
		var rsDatos = AbreTabla(SQL,1,0)

		while (!rsDatos.EOF){
			 var Cantidad = rsDatos.Fields.Item("Cantidad").Value 
			 var Dato = rsDatos.Fields.Item("Dato").Value 
			 var ID = rsDatos.Fields.Item("ID").Value 

	
	%>
        <tr>
        	<td width="33%"><input type="number" min="1" data-dato="<%=ID%>" data-tipo="<%=Tipo%>" class="form-control inValor"/></td>
        	<td width="33%"><%=Cantidad%></td>
        	<td width="33%"><%=Dato%></td>
        </tr>
    <%
		rsDatos.MoveNext() 
		}
		rsDatos.Close()  
	
	%>
    </tbody>
</table>

<script type="application/javascript">


$('.btnGuardaPlan').click(function(e) {
    e.preventDefault();
	Planificacion.GuardaPlan();
});

$('.btnQuitaOrden').click(function(e) {
    e.preventDefault();
	Planificacion.RestableceOrden($(this).val());
});

</script>
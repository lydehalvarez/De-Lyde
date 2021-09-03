<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT * "
		sSQLOV += "FROM Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)
		
	var sSQLGrid = "SELECT count(OV_ID) as OVID,OVA_PART_NUMBER "
		sSQLGrid += " ,(SELECT TOP 1 Pro_Nombre FROM Producto p WHERE p.Pro_ID = O.Pro_ID ) as Nombre "
		sSQLGrid += " ,(SELECT TOP 1 Pro_Descripcion FROM Producto p WHERE p.Pro_ID = O.Pro_ID ) as Descripcion "
		sSQLGrid += " ,(SELECT TOP 1 Pro_PesoBruto FROM Producto p WHERE p.Pro_ID = O.Pro_ID ) as PesoBruto "
		sSQLGrid += " , Pro_ID "
		sSQLGrid += " ,(SELECT Top 1 Pro_DimLargo* [Pro_DimAncho]*[Pro_DimAlto] FROM Producto p WHERE p.Pro_ID = O.Pro_ID ) as cm3 "
		sSQLGrid += " FROM Orden_Venta_Articulo O "
		sSQLGrid += " WHERE OV_ID = " +OV_ID 
		sSQLGrid += " GROUP BY  OV_ID, Pro_ID,OVA_PART_NUMBER "
%>
<style>
.Consulta{
		border-bottom-color: #0da8e4f2; 
		border-bottom-style: dashed;
		border-bottom-width: 1px;
		line-height: 30px;
        min-height: 30px;
}
#PickingTabla td{
text-align:center;	
}
#PickingTabla th{
text-align:center;	
}
</style>

<div class="form-horizontal" id="toPrint">
    <div class="ibox-content">
        <div class="form-group">
            <legend class="control-label col-md-12" style="text-align: right;" id="OVName"><h1>Orden de venta <strong><%=Parametro("OV_Folio",-1)%></strong></i></h1></legend>
         </div>
        <table class="table table-striped table-hover" id="PickingTabla">     
        <thead>
            <tr>
                <th scope="col">Nombre</th>
                <th scope="col">Cantidad</th>
                <th scope="col">Dimensiones cm&sup3;</th>
                <th scope="col">Tama&ntilde;o total cm&sup3;</th>
                <th scope="col">Peso total kg</th>
            </tr>
        </thead>
        <tbody>
		<%
			   var rsProductos = AbreTabla(sSQLGrid,1,0)
				while (!rsProductos.EOF){
					var TotalDim = 0
					var TotalPeso = 0
					var Nombre = rsProductos.Fields.Item("Nombre").Value	
					var Cantidad = rsProductos.Fields.Item("OVID").Value
					var Dimen = rsProductos.Fields.Item("cm3").Value
					var Peso = rsProductos.Fields.Item("PesoBruto").Value
					
					TotalDim = Dimen * Cantidad
					TotalPeso = Peso * Cantidad
			%>			
				<tr>
					<td><%=Nombre%></td>
					<td><%=Cantidad%></td>
					<td><%=Dimen%> cm&sup3;</td>
					<td><%=TotalDim%> cm&sup3;</td>
					<td><%=TotalPeso%> kg</td>
				</tr>
				
		  <%
				rsProductos.MoveNext() 
			}
			rsProductos.Close()   
		%>
         </tbody>
        </table>
    </div>
    <div class="row text-center">
    <img src="images/ajax-engranes.gif"/>
    <p>Trabajando en el c&aacute;lculo para conseguir el mejor embalaje dependiendo del pedido</p>
    </div>
</div>

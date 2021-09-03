<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT * "
		sSQLOV += "FROM Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)
		
	var sSQLPro = "SELECT * "
		sSQLPro += "FROM Producto WHERE Pro_SKU = '"+Parametro("OV_PART_NUMBER","")+"'"
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLPro,0)
		
		
	var sSQLPro = "SELECT count(OC_Folio) Cantidad, "
		sSQLPro += " OC_Folio, PART_NUMBER "
		sSQLPro += " , (SELECT TOP 1 Pro_Nombre FROM Producto WHERE Pro_SKU = PART_NUMBER ) as Nombre "
		sSQLPro += " , Pro_ID "
		sSQLPro += " FROM Izzi_Orden_Venta "
		sSQLPro += " WHERE OC_Folio is not null "
		sSQLPro += " AND PART_NUMBER is not null  "
		sSQLPro += " AND Pro_ID != -1 " 
		sSQLPro += " GROUP BY OC_Folio,PART_NUMBER,Pro_ID "
		
		
	
	Response.Write(OV_ID)
%>
<style>
.Consulta{
		border-bottom-color: #0da8e4f2; 
		border-bottom-style: dashed;
		border-bottom-width: 1px;
		line-height: 30px;
        min-height: 30px;
}
</style>


<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-3">Orden de venta&nbsp;&nbsp;<i class="fa fa-pencil"></i></legend>
                     </div>
				<%
				   var rsProductos = AbreTabla(sSQLPro,1,0)

					while (!rsProductos.EOF){
						var Nombre = rsDestino.Fields.Item("Nombre").Value	
						var Cantidad = rsDestino.Fields.Item("Cantidad").Value
				%>			
					<div class="form-group">
						<label class="control-label col-md-2">Nombre</label>		
						<div class=" col-md-3 Consulta"><%=Nombre%></div>
						<label class="control-label col-md-2">Cantidas</label>		
						<div class=" col-md-3 Consulta"><%=Nombre%></div>
					</div>	
				<%
						rsProductos.MoveNext() 
					}
					rsProductos.Close()   
				%>
                     
                     
                     
                    <div class="form-group">
                        <label class="control-label col-md-2">SKU</label>
                        <div class="col-lg-3 Consulta"><%=Parametro("Pro_SKU",-1)%></div>
                     </div>
                    <div class="form-group">
                        <label class="control-label col-md-2">Producto</label>
                        <div class="col-md-3 Consulta"><%=Parametro("Pro_Nombre","")%></div>
                        <label class="control-label col-md-2">Descripci&oacute;n</label>
                        <div class="col-md-3 Consulta"><%=Parametro("Pro_Descripcion","")%></div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-2">Ubicaci&oacute;n</label>
                        <div class="col-md-3 Consulta"><%=Parametro("Pro_Descripcion","")%></div>
                    </div>
                    
                    
                </div>
            </div>
        </div>
    </div>    
</div>

<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var Valor = Parametro("Valor",-1)  
	var Prov_ID = Parametro("Prov_ID",-1)  
	var ArregloItem = Parametro("ArregloItem","")
   
 	var sResultado = ""
	var result = -1
	var message = ""
	var data = ""
	
   
	switch (parseInt(Tarea)) {
		case 1:	
		var TPro_ID = Parametro("TPro_ID",-1)  
		var ProC_ID = Parametro("ProC_ID",-1)  
		var ProSC_ID = Parametro("ProSC_ID",-1)  
		var sCondicion = "TPro_ID = "+TPro_ID+" AND ProC_ID = "+ProC_ID+" AND ProSC_ID = "+ProSC_ID
		%>
		<tr class="renglon<%=Valor%>">
			<td width="25%"><%CargaCombo("Prod_ID"+Valor," class='form-control combo DataArticulo datos"+Valor+"'","Pro_ID","Pro_Nombre","Producto",sCondicion,"Pro_Nombre",-1,0,"Selecciona","Editar")%></td>
			<td width="25%"><input type="number" min="0" id="Cantidad<%=Valor%>" autocomplete="off" name="Cantidad" class="form-control col-md-3 DataArticulo datos<%=Valor%> Cantidad" placeholder="Cantidad"/></td>
			<td width="25%"><input type="number" min="0" id="Precio<%=Valor%>" autocomplete="off" name="Precio" class="form-control col-md-3 DataArticulo datos<%=Valor%> Precio" placeholder="Precio por unidad"/></td>
			<td width="25%"><button type="button" value="<%=Valor%>" class="btn btn-success btnConfirma">Listo</button><button type="button" value="<%=Valor%>" class="btn btn-danger btnBorrarRenglon">Borrar</button></td>
		</tr>
		<%
		break;   
		case 2:	
		%>
        <script type="application/javascript">
			var sResultado = ""
			var dato = JSON.parse(<%=ArregloItem%>)
			var len = dato.length
			for(var i = 0; i< len; i++){
				Carga(dato[i].name,dato[i].id,dato[i].cantidad) 	
			}
		function Carga(name,id,cantidad){
			sResultado = name +" "+id+" "+cantidad
		}
		</script>
		<%
		break;  
		case 3:
		var TPro_ID = Parametro("TPro_ID",-1)  
		var valida = BuscaSoloUnDato("ProC_ID","Cat_TipoProducto_Categoria","TPro_ID = "+TPro_ID,-1,0)
		if(valida != -1){
		 %>
            <div class="form-group">
                <label class="control-label col-md-3 required">Categoria</label>
                <div class="col-lg-8 cmbCategoria">
                    <%CargaCombo("ProC_ID","class='form-control ProC_ID'","ProC_ID","ProC_Nombre","Cat_TipoProducto_Categoria","TPro_ID = "+TPro_ID,"ProC_ID",-1,0,"Selecciona","Editar")%>					   
                </div>
            </div>
        <%}
		break; 
		case 4:
		var TPro_ID = Parametro("TPro_ID",-1)  
		var ProC_ID = Parametro("ProC_ID",-1)  
		var valida = BuscaSoloUnDato("ProSC_ID","Cat_TipoProducto_SubCategoria","TPro_ID = "+TPro_ID+" AND ProC_ID = "+ProC_ID,-1,0)
		if(valida != -1){
		 %>
            <div class="form-group">
                <label class="control-label col-md-3 required">Sub-Categoria</label>
                <div class="col-lg-8 cmbCategoria">
                    <%CargaCombo("ProSC_ID","class='form-control ProSC_ID'","ProSC_ID","ProSC_Nombre","Cat_TipoProducto_SubCategoria","TPro_ID = "+TPro_ID+" AND ProC_ID = "+ProC_ID,"ProSC_ID",-1,0,"Selecciona","Editar")%>					   
                </div>
            </div>
        <%}
		break; 
		case 5:
		var Prov_ID = Parametro("Prov_ID",-1)  
		try{
			var OC_ID = SiguienteID("OC_ID","Proveedor_OrdenCompra","Prov_ID = "+Prov_ID,0)
			var insert = "INSERT INTO Proveedor_OrdenCompra(Prov_ID,OC_ID) "
				insert += "VALUES("+Prov_ID+","+OC_ID+") "
				
				Ejecuta(insert,0)
				result = OC_ID
				message = "Orden de compra colocada"
		}catch(err){
				result = -1
				message = "Error en el insert"
		}
				sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'
		break; 
		case 6:
		try{
			var Prov_ID = Parametro("Prov_ID",-1)  
			var Pro_ID = Parametro("Pro_ID",-1)  
			var Cantidad = Parametro("Cantidad",-1)  
			var Precio = Parametro("Precio",-1)  
			var OC_ID = Parametro("OC_ID",-1)  
			
			var OCP_ID = SiguienteID("OCP_ID","Proveedor_OrdenCompra_Articulos","Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID,0)
			var Pro_SKU = BuscaSoloUnDato("Pro_SKU","Producto","Pro_ID = "+Pro_ID,-1,0)
			
			var insert = "INSERT INTO Proveedor_OrdenCompra_Articulos(Prov_ID,OC_ID,OCP_ID,OCP_SKU,Pro_ID,OCP_Cantidad,OCP_PrecioUnitario) "
				insert += " VALUES("+Prov_ID+","+OC_ID+","+OCP_ID+",'"+Pro_SKU+"',"+Pro_ID+",'"+Cantidad+"','"+Precio+"') "
				
				Ejecuta(insert,0)

				result = 1
				message = "Articulo colocado"
		}catch(err){
				result = -1
				message = "Error en el insert"
				data  = insert
		}
				sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'
		break; 
	}
Response.Write(sResultado)
%>

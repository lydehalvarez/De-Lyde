<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var Valor = Parametro("Valor",-1)  
	var ArregloItem = Parametro("ArregloItem","")
   
 	var sResultado = ""
	
	
   
	switch (parseInt(Tarea)) {
		case 1:	
		%>
		<tr class="renglon<%=Valor%>">
			<td width="33%"><%CargaCombo("Prod_ID"+Valor," class='form-control combo' name='Cantidad"+Valor+"'","Pro_ID","Pro_Nombre","Producto","","Pro_Nombre","",0,"Selecciona","Editar")%></td>
			<td width="33%"><input type="text" autocmplete="off" id="Cantidad<%=Valor%>" class="form-control col-md-3 Cantidad" placeholder="Cantidad"/></td>
			<td width="33%"><button type="button" value="<%=Valor%>" class="btn btn-danger btnBorrarRenglon">Borrar</button></td>'
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
	}
Response.Write(sResultado)
%>

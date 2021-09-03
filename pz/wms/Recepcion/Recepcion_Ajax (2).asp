<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var Hora = Parametro("IR_Horario","")
	var IR_Folio = Parametro("IR_Folio",-1)
	var IR_FechaEntrega = Parametro("IR_FechaEntrega", "")
	var IR_Almacen = Parametro("Alm_ID", -1)
	var IR_Conductor =  utf8_decode(Parametro("IR_Conductor",""))
	var IR_DescripcionVehiculo =  utf8_decode(Parametro("IR_DescripcionVehiculo",""))
	var IR_Placas =  utf8_decode(Parametro("IR_Placas",""))
	var IR_Color =  utf8_decode(Parametro("IR_Color",""))
	var IR_Puerta = Parametro("IR_Puerta","")
	var IR_Usuario = Parametro("IDUsuario",-1)

	var IR_ID = Parametro("IR_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID", -1)
	var TiempoPallet =  Parametro("TiempoPallet", -1)
	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
		IR_ID=-1
			if(IR_ID == -1){
			try {
										
					IR_ID = BuscaSoloUnDato("ISNULL((MAX(IR_ID)),0)+1","Inventario_Recepcion","",-1,0)
					
				
Date.prototype.addMins = function(m) {     
   this.setTime(this.getTime() + (m*60*1000));  // minutos * seg * milisegundos
   return this;    
} 

// asignacion de valores de tiempo y suma de minutos en metodo addMins()
	var IR_FechaTermina = IR_FechaEntrega + " " + Hora
					 IR_FechaTermina = new Date(IR_FechaTermina);
					

IR_FechaTermina = IR_FechaTermina.addMins(TiempoPallet);
var horas =  IR_FechaTermina.getHours()
var minutos = IR_FechaTermina.getMinutes()
var segundos =  IR_FechaTermina.getSeconds()
if( minutos < 10){
minutos = 	"0"+ minutos
}
if( horas< 10){
horas = 	"0"+ horas
}
if( segundos < 10){
segundos = 	"0"+ segundos
}
var HoraEntrega =  horas + ":" +minutos + ":" + segundos


				var sSQL = " INSERT INTO Inventario_Recepcion (IR_ID,IR_Folio, IR_FechaEntrega,  IR_FechaEntregaTermina, IR_AlmacenRecepcion, IR_Usuario,Prov_ID,OC_ID,Lot_ID,Cli_ID,CliOS_ID,CliOC_ID,TA_ID, IR_Conductor,IR_Placas,IR_DescripcionVehiculo,IR_Puerta,IR_Color) "
						sSQL += " VALUES (" +IR_ID +",'" +IR_Folio+"','" +IR_FechaEntrega+" "+Hora+"','"+IR_FechaEntrega+ " "+HoraEntrega+"'," +IR_Almacen+", "+IR_Usuario+","+Prov_ID+","+OC_ID+",-1,"+Cli_ID+",-1,"+CliOC_ID+","+TA_ID+",'"+IR_Conductor+"','"+IR_Placas+"','"+IR_DescripcionVehiculo+"','"+IR_Puerta+"','"+IR_Color+"')"

						Ejecuta(sSQL, 0)
                    if (OC_ID > -1){
	 		        sSQL = " UPDATE Cliente_OrdenCompra "
					sSQL +=" SET CliOC_EstatusCG52 = 4"
					sSQL +=" WHERE CliOC_ID = "+ CliOC_ID
	                 Ejecuta(sSQL, 0)
					 }
					 if (TA_ID > -1){
			        sSQL = " UPDATE TransferenciaAlmacen "
					sSQL +=" SET TA_EstatusCG52 = 4"
					sSQL +=" WHERE TA_ID = "+ TA_ID
	                 Ejecuta(sSQL, 0)
					 }
				} catch (err) {
					sResultado = Prov_ID
				}
			}
		break;  
		//Update cita 
		case 2:	
			if(IR_ID > -1){
				try {
	Date.prototype.addMins = function(m) {     
   this.setTime(this.getTime() + (m*60*1000));  // minutos * seg * milisegundos
   return this;    
} 

// asignacion de valores de tiempo y suma de minutos en metodo addMins()
	var IR_FechaTermina = IR_FechaEntrega + " " + Hora
					 IR_FechaTermina = new Date(IR_FechaTermina);
					

IR_FechaTermina = IR_FechaTermina.addMins(TiempoPallet);
var horas =  IR_FechaTermina.getHours()
var minutos = IR_FechaTermina.getMinutes()
var segundos =  IR_FechaTermina.getSeconds()
if( minutos < 10){
minutos = 	"0"+ minutos
}
if( horas< 10){
horas = 	"0"+ horas
}
if( segundos < 10){
segundos = 	"0"+ segundos
}
var HoraEntrega =  horas + ":" +minutos + ":" + segundos

					var sSQL = " UPDATE Inventario_Recepcion "
						sSQL +=" SET IR_Folio = '" +IR_Folio+"', IR_FechaEntrega='" +IR_FechaEntrega+" "+Hora+"' ,"
						sSQL +=  "IR_FechaEntregaTermina='"+IR_FechaEntrega+ " "+ HoraEntrega+"' , IR_AlmacenRecepcion=" +IR_Almacen+", "
						sSQL += "IR_Usuario= "+IR_Usuario+",Prov_ID="+Prov_ID+","
						sSQL +="	OC_ID="+OC_ID+",Lot_ID=-1,Cli_ID="+Cli_ID+",CliOS_ID=-1,CliOC_ID="+CliOC_ID+",TA_ID="+TA_ID +", "
						sSQL +="IR_Conductor='"+IR_Conductor+"',IR_Placas='"+IR_Placas+"',IR_DescripcionVehiculo='"+IR_DescripcionVehiculo+"',"
						sSQL +=" IR_Puerta='"+IR_Puerta+"',IR_Color='"+IR_Color+"' WHERE IR_ID = "+ IR_ID
						
				
						Ejecuta(sSQL, 0)
						
						sResultado = 1
						
				} catch (err) {
					sResultado = -1
				}
			}
		break;   
case 3:
	var Pro_ID = Parametro("Pro_ID",-1)
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var ProvEnt_ID = Parametro("ProvEnt_ID", -1)
	var CliEnt_ArticulosRecibidos = Parametro("CliEnt_ArticulosRecibidos",-1)
	if(CliOC_ID>-1){
					var sSQL = "IF NOT EXISTS(SELECT 1 FROM Cliente_OrdenCompra_EntregaProducto "
                         + " WHERE CliOC_ID = " + CliOC_ID
                         + "  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID + ")"
                         + "INSERT INTO Cliente_OrdenCompra_EntregaProducto(Cli_ID, CliOC_ID"
                         + ", CliEnt_ID, Pro_ID, CliEnt_ArticulosRecibidos) "
                         + " VALUES (" + Cli_ID + "," + CliOC_ID 
                         + "," + CliEnt_ID + "," + Pro_ID + ", "+CliEnt_ArticulosRecibidos+")"
   
				 Ejecuta(sSQL,0)
				 					IR_ID = BuscaSoloUnDato("ISNULL((MAX(IR_ID)),0)+1","Inventario_Recepcion","",-1,0)

				 				 sSQL = "UPDATE Cliente_OrdenCompra_Entrega SET IR_ID="+IR_ID+" WHERE  CliEnt_ID = "+CliEnt_ID+" AND CliOC_ID="+CliOC_ID 
								 Ejecuta(sSQL,0)

				  sSQL = "UPDATE Cliente_OrdenCompra SET BPM_Pro_ID = 3, BPM_Flujo = 1 WHERE CliOC_ID ="+CliOC_ID
				 Ejecuta(sSQL,0)
		     ssql = "Select * FROM Cliente_OrdenCompra_EntregaProducto a INNER JOIN Producto_Cliente p ON p.Pro_ID=a.Pro_ID where  a.CliEnt_ID = "+CliEnt_ID+" AND a.CliOC_ID=" + CliOC_ID+" "
		var rsEntrega =  AbreTabla(ssql,1,0)
			
					 %>
           <table class="table">
    <thead>
        <tr>
            <th class="text-center">Producto</th>
          <th class="text-center">Cantidad</th>
        </tr>
    </thead>
    <tbody>
     <% while (!rsEntrega.EOF){
			 var CliEnt_ArticulosRecibidos = rsEntrega.Fields.Item("CliEnt_ArticulosRecibidos").Value
			var ProC_Nombre = rsEntrega.Fields.Item("ProC_Nombre").Value
		 %>
     <tr>
       <td class="text-center"><%=ProC_Nombre%> </td>
       <td class="text-center"><%=CliEnt_ArticulosRecibidos%></td>
</tr>
<%
		 rsEntrega.MoveNext() 
					}
                rsEntrega.Close()  
				%>
		 </tbody>
</table>   

<%
	}else{
							var sSQL = "IF NOT EXISTS(SELECT 1 FROM Proveedor_OrdenCompra_EntregaProducto "
                         + " WHERE OC_ID = " + OC_ID
                         + "  AND ProvEnt_ID = " + ProvEnt_ID + " AND Pro_ID = " + Pro_ID + ")"
                         + "INSERT INTO Proveedor_OrdenCompra_EntregaProducto(Prov_ID, OC_ID"
                         + ", ProvEnt_ID, Pro_ID, ProvEnt_ArticulosRecibidos) "
                         + " VALUES (" + Prov_ID + "," + OC_ID 
                         + "," + ProvEnt_ID + "," + Pro_ID + ", "+CliEnt_ArticulosRecibidos+")"
   
				 Ejecuta(sSQL,0)
				 		sSQL = "UPDATE Proveedor_OrdenCompra_Entrega SET IR_ID="+IR_ID+" WHERE  ProvEnt_ID = "+ProvEnt_ID+" AND OC_ID="+OC_ID 
								 Ejecuta(sSQL,0)

				 sSQL = "UPDATE Proveedor_OrdenCompra_Entrega SET IR_ID="+IR_ID+" WHERE OC_ID="+OC_ID 
								 Ejecuta(sSQL,0)
 
				  sSQL = "UPDATE Proveedor_OrdenCompra SET BPM_Pro_ID = 3, BPM_Flujo = 1 WHERE OC_ID ="+OC_ID
				 Ejecuta(sSQL,0)
	     ssql = "Select * FROM Proveedor_OrdenCompra_EntregaProducto a INNER JOIN Producto_Proveedor p ON p.Pro_ID=a.Pro_ID where ProvEnt_ID = "+ProvEnt_ID+" AND  OC_ID=" + OC_ID+" "
		 var rsEntrega =  AbreTabla(ssql,1,0)
		 
				 %>
           <table class="table">
    <thead>
    
        <tr>
            <th class="text-center">Producto</th>
          <th class="text-center">Cantidad</th>
        </tr>
    </thead>
    <tbody>
    <% while (!rsEntrega.EOF){
			 var ProvEnt_ArticulosRecibidos = rsEntrega.Fields.Item("ProvEnt_ArticulosRecibidos").Value
			var ProC_Nombre = rsEntrega.Fields.Item("ProC_Nombre").Value
		 %>
     <tr>
       <td class="text-center"><%=ProC_Nombre%> </td>
       <td class="text-center"><%=ProvEnt_ArticulosRecibidos%></td>
</tr>
<%
		 rsEntrega.MoveNext() 
					}
                rsEntrega.Close()  
				%>
		 </tbody>
</table>   

<%
		}
	
		%>
   
<%
break;
		//DELETE Cita
		case 4:	
			if(IR_ID > -1){
				try {
	
					var sSQL = " DELETE FROM Inventario_Recepcion "
						sSQL +=" WHERE IR_ID = "+ IR_ID
	
						Ejecuta(sSQL, 0)
						
						sResultado = 1
						
				} catch (err) {
					sResultado = -1
				}
			}
		break;  
		
		case 5:	
		
	var hrs = 7
	 var hours = 0
	 var horas = 0
	 var minutos = 0
	 var segundos = 0
	 var HoraTermina = ""
	 var IR_FechaTermina  = ""
	 var rsRec = ""
	 var sSQL = ""
		%>
        <select id="IR_Horario" class="form-control agenda">
        <%
		for (var i = 0; i < 13; i++) {	
		
		IR_FechaEntrega =  Parametro("IR_FechaEntrega", "")
	

Date.prototype.addMins = function(m) {     
   this.setTime(this.getTime() + (m*60*1000));  // minutos * seg * milisegundos
   return this;    
} 
hrs += 1
if( hrs < 10){
 hours = 	"0"+ hrs
 Hora = hours + ":00:"+"00"
}else{
Hora = hrs + ":00:"+"00"
}
// asignacion de valores de tiempo y suma de minutos en metodo addMins()

	 IR_FechaTermina = IR_FechaEntrega + " " + Hora
	 IR_FechaTermina = new Date(IR_FechaTermina);
					

IR_FechaTermina = IR_FechaTermina.addMins(TiempoPallet);
horas = IR_FechaTermina.getHours()
minutos = IR_FechaTermina.getMinutes()
 segundos =  IR_FechaTermina.getSeconds()
if( minutos < 10){
minutos = 	"0"+ minutos
}
if( horas< 10){
horas = 	"0"+ horas
}
if( segundos < 10){
segundos = 	"0"+ segundos 
}
 HoraTermina =  horas + ":" +minutos + ":" + segundos

 IR_FechaTermina = IR_FechaEntrega + " " + HoraTermina
 IR_FechaEntrega = IR_FechaEntrega + " " + Hora

							
				 sSQL = "SELECT * FROM inventario_recepcion where "
				 sSQL += "(ir_fechaentrega between '"+IR_FechaEntrega+"' and '"+IR_FechaTermina+"' "
				 sSQL += "OR ir_fechaentregaTermina between '"+IR_FechaEntrega+"' and '"+IR_FechaTermina+"') AND IR_Puerta = '" + IR_Puerta + "'"
				
					 rsRec =  AbreTabla(sSQL,1,0)
			
							if(!rsRec.EOF){
							}else{
								%>
                                <%=sSQL%>
								  <option value="<%=Hora%>"><%=Hora%></option>
                                  <%
							}
							if(Hora == "21:00:00"){
							i=13	
							}
		}
		break; 
		 
  
	}

%>

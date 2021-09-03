       <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
  
<%
 	var Tarea = Parametro("Tarea", -1)
    var IDUsuario = Parametro("IDUsuario",-1) 
	var Pt_ID = Parametro("Pt_ID", -1)
 	var Pt_Digitos = Parametro("Pt_Digitos", -1)
 	var Pro_ID = Parametro("Pro_ID", -1)
 	var Serie = Parametro("Serie", -1)
	var Respuesta = ""
	

 switch (parseInt(Tarea)) {

	case 1:
%>	
<table class="table">
    <thead>
        <th>Pallet</th>
        <th>SKU</th>
        <th>Modelo</th>
        <th>LPN</th>
         <th>Masterbox escaneados</th>
        <th>Acciones</th>
    </thead>
    <tbody>
<%    
	 var sSQLTr  = "SELECT *, "
		sSQLTr  += " p.Pro_SKU  SKU"
		sSQLTr  += " , a.Pt_Modelo  as Modelo"
		sSQLTr  += " , (SELECT Col_nombre FROM Cat_Color WHERE Col_ID = p.Col_ID) Color"
		sSQLTr  += " FROM Recepcion_Pallet a, Producto p "
		sSQLTr  += " WHERE Pt_ID = "+Pt_ID
		sSQLTr  += " AND a.Pro_ID = p.Pro_ID "
	 
	 var rsPt = AbreTabla(sSQLTr,1,0) 
	
	if(!rsPt.EOF){
	  var Pt_Pallet = rsPt.Fields.Item("Pt_Pallet").Value
	  var SKU = rsPt.Fields.Item("SKU").Value
	  var Pt_LPN = rsPt.Fields.Item("Pt_LPN").Value
	  var Pt_Cantidad = rsPt.Fields.Item("Pt_Cantidad").Value
	  var Modelo = rsPt.Fields.Item("Modelo").Value
	  var Color = rsPt.Fields.Item("Color").Value
	  
		var Cantidad  = "SELECT COUNT(*) Cantidad "
			Cantidad  += " FROM Recepcion_RayosX  "
			Cantidad  += " WHERE Ray_Serie is not NULL and Pt_ID = "+Pt_ID
		
		var rsCan = AbreTabla(Cantidad,1,0) 
		if(!rsCan.EOF){
			var Cantidad = rsCan.Fields.Item("Cantidad").Value
		}
	

		%>

	
        <tr>
            <td><%=Pt_Pallet%></td>
            <td><%=SKU%></td>
            <td><%=Modelo%></td>
            <td><%=Pt_LPN%></td>
                <input type="hidden" id="Pt_LPN" value="<%=Pt_LPN%>"/>
            <input type="hidden" id="total" value="<%=Pt_Cantidad%>"/>
            <td id="escaneadasValor"><%=Cantidad%></td>
            <input type="hidden" id="escaneadas" value="<%=Cantidad%>"/>
         
              <td><input class="form-control Digitos"  id= "Digitos" style="width:40%"  placeholder="digitos" type="text" autocomplete="off" value=""/>
			<button type="button" class="btn btn-primary BtnDigitos" id= "BtnDigitos" onclick="FunctionSerie.InsertDigitos()">
			Configurar serie</button>	
         	<input class="form-control Serie"  id= "Serie" style="display:none;width:100%" placeholder="" type="text" autocomplete="off" value="" onkeydown="FunctionRecepcion.InsertSerie(event);"/>
			<button type="button" class="btn btn-primary BtnMB" id= "BtnMB"  style="display:none;width:100%" onclick="FunctionMB.InsertMB()">
			A&ntilde;adir masterbox</button>
              
            </td>
		</tr>
    <%		  
		  }
%>    
    
    
    
    </tbody>
</table>  
    	
<%		
	break;
	case 2:
	
	//	caracteres
//		cambio de masterbox
//		terminacion de escaneo de pallet para ubicar en rack
	var sSQLTr  = "SELECT TPro_ID FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		   var rsTPro = AbreTabla(sSQLTr,1,0) 
		   
		   	var sSQLTr  = "SELECT Pt_Digitos FROM Recepcion_Pallet"
        sSQLTr += " WHERE Pt_ID = " + Pt_ID

		   var rsDig = AbreTabla(sSQLTr,1,0) 
		   var Digitos = rsDig.Fields.Item("Pt_Digitos").Value
		  
		   var Tipo = rsTPro.Fields.Item("TPro_ID").Value
		if(Tipo != 2){
			var NoCar = Digitos
		}
		if(Tipo == 2){
			var NoCar = Digitos
		}
		var caracteres = Serie.length
	if(caracteres == NoCar){
		var Existencia = BuscaSoloUnDato("Ray_ID","Recepcion_RayosX","Ray_Serie = '"+Serie+"'",-1,0) 
		if(Existencia > -1){
			result = 0
			message = "Lo sentimos la serie "+Serie+" ya existe"
			
		}else{
			if(Serie != ""){
				var sSQLTr = "INSERT INTO Recepcion_RayosX(Pt_ID, Ray_Serie) "
				sSQLTr  += " VALUES("+Pt_ID+", '"+Serie+"')"
			
				if(Ejecuta(sSQLTr,0)){

				result = 1
				message = "Masterbox escaneado"
		
				}else{
						Response.Write(sSQL)
				result = 0
				message = "Error al colocar el dato en la base de datos"
				}
			}else{
			result = 0
			message = "Serie mal escaneada, vuelva a intentarlo"
			}
		}
	}else{
	message = "La serie "+Serie+" no cumple con el largo establecido de caracteres."
	result = 0
	}
		
	Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	
	break;
	case 3:
	
		//		var sSQLTr = "INSERT INTO Recepcion_RayosX(Pt_ID, Ray_Serie) "
//				sSQLTr  += " VALUES("+Pt_ID+", "+Serie+")"
//			
//		if(Ejecuta(sSQLTr,0)){
//				result = 1
//				message = "Masterbox a&ntilde;adido"
//
//			}else{
//				result = 0
//				message = "Error al colocar el dato en la base de datos"
//			}
//				Respuesta = '{"result":'+result+',"message":"'+message+'"}'

	

break;
	case 4:
		%>

   			<table class="table">
  			  <thead>
   		    	<th>Masterbox</th>
    			<th>No. de Serie escaneado</th>
    			<th>Registro</th>
    	
    	  	  </thead>
   				 <tbody>
	<%
		var MB = 0
		 var sSQL = "SELECT Ray_Serie,  CONVERT(VARCHAR(20), Ray_FechaRegistro, 103) as Ray_FechaRegistro, CONVERT(VARCHAR(20), Ray_FechaRegistro, 108) as Ray_HoraRegistro FROM Recepcion_RayosX WHERE Ray_Serie is not NULL AND Pt_ID = "+Pt_ID

			 var rsSerie = AbreTabla(sSQL,1,0)
			
	     while(!rsSerie.EOF){ 
			MB += 1	
	%>
            <tr>
                <td><%=MB%></td>
                <td><%=rsSerie.Fields.Item("Ray_Serie").Value%></td>
                <td><%=rsSerie.Fields.Item("Ray_FechaRegistro").Value + " " + rsSerie.Fields.Item("Ray_HoraRegistro").Value%></td>
            </tr>
             
        <%	
		
            rsSerie.MoveNext() 
        }
        rsSerie.Close()   
		%>
           
  			  </tbody>
		</table>
<%
			
break;
case 5:
	
				var sSQLTr = "UPDATE Recepcion_Pallet SET Pt_Digitos= "+Pt_Digitos+" WHERE Pt_ID = "+Pt_ID
				
		if(Ejecuta(sSQLTr,0)){
				result = 1
				message = "Serie configurada correctamente"

			}else{
				result = 0
				message = "Error al colocar el dato en la base de datos"
			}
				Respuesta = '{"result":'+result+',"message":"'+message+'"}'

	

break;
 }
Response.Write(Respuesta)
%>

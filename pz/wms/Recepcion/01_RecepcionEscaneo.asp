<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea", -1)
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)  
	var Cli_ID = Parametro("Cli_ID",-1)  
	var Ser_Serie = Parametro("Ser_Serie",1)
	var Pt_ID = Parametro("Pt_ID",-1)
	var IR_ID = Parametro("IR_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var Pt_SKU = Parametro("Pt_SKU","")
	var Pt_LPN = Parametro("Pt_LPN","")
	var Articulos =  parseInt(Parametro("Articulos",1))
	var MB =  parseInt(Parametro("MB",-1))
	var Pallet =  parseInt(Parametro("Pallets",-1))
	var Cantidad_MB =  parseInt(Parametro("Cantidad_MB",-1))
	var Cantidad_Pallet =  parseInt(Parametro("Cantidad_Pallet",-1))
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var error = Parametro("error", "")
	var Pal = 1
	var inputMB = ""
	if(MB == 111111){
		MB = -1
	}
	if (Tarea==-1){
			  var inputEscan =  'style="display:none;width:150%"'

			var Pro_ID = Parametro("Pro_ID",-1)
			
	var sSQLTr  = "SELECT MAX(Ser_MB) AS MB, MAX(Ser_Pallet) as pallet FROM Recepcion_Series  WHERE Pro_ID = "+ Pro_ID+" AND "
if(CliOC_ID > -1){
	 sSQLTr += "CliOC_ID = "+CliOC_ID
}if(OC_ID > -1){
		 sSQLTr += "OC_ID = "+OC_ID
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
	}
			 var rsSer = AbreTabla(sSQLTr,1,0)
			  if(rsSer.RecordCount > 0){
			MB = rsSer.Fields.Item("MB").Value 
			Pallet = rsSer.Fields.Item("pallet").Value
			  }if(MB<1){
				MB = -1  
			  }
var sSQLTr  = "SELECT COUNT(*) AS Articulos FROM Recepcion_Series  WHERE Ser_MB = "+MB+"  AND Ser_Pallet = "+Pallet+" and Pro_ID = "+ Pro_ID+" AND "
if(CliOC_ID > -1){
	 sSQLTr += "CliOC_ID = "+CliOC_ID
}if(OC_ID > -1){
		 sSQLTr += "OC_ID = "+OC_ID
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
	}
			rsSer = AbreTabla(sSQLTr,1,0)
			Articulos = rsSer.Fields.Item("Articulos").Value 
	
			
				   if(OC_ID > -1){
sSQL = "SELECT  r.CliEnt_CantidadArticulos as Pro_CantidadMB, r.CliEnt_CantidadPallet as Pro_CantidadPt FROM  Producto_Cliente c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Proveedor_OrdenCompra_EntregaProducto r ON  p.Pro_ID = r.Pro_ID  WHERE  r.OC_ID = "+OC_ID+" AND r.ProvEnt_ID = "+CliEnt_ID
				   }else{
sSQL = "SELECT  r.CliEnt_CantidadArticulos as Pro_CantidadMB, r.CliEnt_CantidadPallet as Pro_CantidadPt FROM  Producto_Cliente c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Cliente_OrdenCompra_EntregaProducto r ON  p.Pro_ID = r.Pro_ID  WHERE  r.CliOC_ID = "+CliOC_ID+" AND r.CliEnt_ID = "+CliEnt_ID
				   }
				 var rsActivos = AbreTabla(sSQL,1,0)
				 if (rsActivos.RecordCount > 0){
					 MB = 1
				     Cantidad_MB= rsActivos.Fields.Item("Pro_CantidadMB").Value
				 while (!rsActivos.EOF){
					 Cantidad_Pallet= rsActivos.Fields.Item("Pro_CantidadPt").Value
					 Pallet = 1
		  rsActivos.MoveNext() 
                                    }
                                    rsActivos.Close()   	
				 }
	} 
	
	if(CliOC_ID > -1){
   	var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
         sSQL1 += "inner join cliente c on p.Cli_ID=c.Cli_ID "
	   	 sSQL1 += "inner join  Cliente_OrdenCompra_Articulos a  on p.Pro_ID = a.Pro_ID "
	     sSQL1 += " where a.CliOC_ID = " + CliOC_ID 
		 sSQL1 += " AND p.Pro_ID = "+Pro_ID+" GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		    var rsPro = AbreTabla(sSQL1,1,0)
			    var rsPro2 = AbreTabla(sSQL1,1,0)
		}
		if(OC_ID > -1){
   	var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Proveedor p "
         sSQL1 += "inner join proveedor c on p.Prov_ID=c.Prov_ID "
			 sSQL1 += "inner join  Proveedor_OrdenCompra_Articulos a on p.Pro_ID = a.Pro_ID  "
	     sSQL1 += " where a.OC_ID = " + OC_ID 
		 sSQL1 += " AND p.Pro_ID = "+Pro_ID+" GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		    var rsPro = AbreTabla(sSQL1,1,0)
			    var rsPro2 = AbreTabla(sSQL1,1,0)
		}
		 if(TA_ID > -1){
		 var sSQL1  = "select p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
         sSQL1 += "inner join cliente c on p.Cli_ID=c.Cli_ID "
		 sSQL1 += "inner join  TransferenciaAlmacen_Articulos a  on p.Pro_ID = a.Pro_ID  "
	     sSQL1 += " where a.TA_ID = " + TA_ID 
		  sSQL1 += " AND p.Pro_ID = "+Pro_ID+" GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		 
   var rsPro = AbreTabla(sSQL1,1,0)
       var rsPro2 = AbreTabla(sSQL1,1,0)
		 }
		 
if(CliOC_ID > -1){
	var sSQL = "SELECT CliOC_Folio FROM Cliente_OrdenCompra WHERE CliOC_ID = "+CliOC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("CliOC_Folio").Value
	}if(OC_ID > -1){
		var sSQL = "SELECT OC_Folio FROM Proveedor_OrdenCompra WHERE OC_ID = "+OC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("OC_Folio").Value
	}if(TA_ID > -1){
	var sSQL = "SELECT TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = "+TA_ID
			   var rsArt = AbreTabla(sSQL,1,0)
				var Folio =  rsArt.Fields.Item("TA_Folio").Value
	}
%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Folio:&nbsp;<%=Folio%></h1></legend>
                       
                     
                     </div>
                 
                <div style="overflow-y: scroll; height:655px; width: 200;">
                  <input type="text" value="<%=CliOC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="CliOC_ID">
                     <input type="text" value="<%=OC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="OC_ID">
                        <input type="text" value="<%=Prov_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Prov_ID">
                                <input type="text" value="<%=TA_ID%>"  style="display:none;width:150%"  class="objAco agenda"  id="TA_ID">
                               <input type="text" value="<%=Cli_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Cli_ID">
                        <input type="text" value="<%=Pro_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Pro_ID">
                              <input type="text" value="<%=CliEnt_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="CliEnt_ID">

                   <div class="ibox-content">
                        <div class="table" id= "dvEscaneos">
                     
                               <table class="table">
    <thead>
    <th>Pallet</th>
    	<th>SKU</th>
    	<th>Modelo</th>
    	<th>Color</th>
    	<th>LPN</th>
    	<th>Cantidad</th>
    	    </thead>
    <tbody>	
		<%
			if(CliOC_ID > -1){
	sSQLTr = "SELECT * FROM Cliente_OrdenCompra_Articulos t INNER JOIN Producto p ON p.Pro_ID= t.Pro_ID  "
    sSQLTr += "WHERE CliOCP_SKU = '"+ rsPro2.Fields.Item("ProC_SKU").Value+"' AND CliOC_ID = "+CliOC_ID
 	 rsPro = AbreTabla(sSQLTr,1,0) 
	 var condicion = "FROM Cliente_Inventario WHERE  CliOC_ID = '"+ CliOC_ID +"'"
	 var condicion2 = "FROM Cliente_Inventario WHERE CInv_NumeroSerie = '"+Ser_Serie+"' "
	 var condicion3 = "FROM Recepcion_Series WHERE  CliOC_ID = '"+ CliOC_ID +"'"
}

if(OC_ID > -1){
		sSQLTr = "SELECT * FROM Proveedor_OrdenCompra_Articulos t INNER JOIN Producto p ON p.Pro_ID= t.Pro_ID WHERE "
		 sSQLTr += "OCP_SKU = '"+ rsPro2.Fields.Item("ProC_SKU").Value+"' AND  OC_ID = "+OC_ID
	 var condicion = "FROM Cliente_Inventario WHERE  OC_ID = '"+ OC_ID +"'"
	 var condicion2 = "FROM Cliente_Inventario WHERE CInv_NumeroSerie = '"+Ser_Serie+"' "
	 var condicion3 = "FROM Recepcion_Series WHERE  OC_ID = '"+ OC_ID +"'"

	 rsPro = AbreTabla(sSQLTr,1,0) 
	}
	
	if(TA_ID > -1){
	sSQLTr = "SELECT * FROM TransferenciaAlmacen_Articulos t INNER JOIN Producto p ON p.Pro_ID= t.Pro_ID  "
	 sSQLTr += "WHERE TA_SKU = '"+ rsPro2.Fields.Item("ProC_SKU").Value+"' AND TA_ID = "+TA_ID
	 var condicion = "FROM Cliente_Inventario WHERE  CliOC_ID = '"+ CliOC_ID +"'"
	 var condicion2 = "FROM Cliente_Inventario WHERE CInv_NumeroSerie = '"+Ser_Serie+"' "
	 var condicion3 = "FROM Recepcion_Series WHERE  TA_ID = '"+ TA_ID +"'"

		 rsPro = AbreTabla(sSQLTr,1,0) 
	}
			  
			  var totalMB = 0
		 var sSQLTr  = "SELECT * FROM Recepcion_Pallet"
        sSQLTr += " WHERE Pt_ID = " + Pt_ID

		   var rsPallet = AbreTabla(sSQLTr,1,0) 
			 switch (parseInt(Tarea)) {
			 case 1:
			 		 var inputEscan = ""
			  var sSQLTr  = "SELECT * FROM Recepcion_Series where Ser_Serie = '"+Ser_Serie+"'"
				 var rsSer = AbreTabla(sSQLTr,1,0) 
						
			if(rsSer.RecordCount > 0){
		error = "  <tr>  <td class='text-center'>  <FONT COLOR='red'> "+Ser_Serie+" (Ya existe) </FONT></td></tr>" + error

			}else{
			
			
		 var sSQLTr  = "SELECT * FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		   var rsTPro = AbreTabla(sSQLTr,1,0) 
		  
		   var Tipo = rsTPro.Fields.Item("TPro_ID").Value
if(Tipo != 2){
var NoCar = 15
}if(Tipo == 2){
var NoCar = 20
}
	var caracteres = Ser_Serie.length
								  
	if(caracteres == NoCar){
				 Articulos += 1
				 if(MB > -1){
					 	if(Articulos == Cantidad_MB){
				var inputEscan =  'style="display:none;width:150%"'
						}
			  	if(Articulos > Cantidad_MB){
									MB +=1
										Articulos = 1
										if(OC_ID > "-1"){
										Cli_ID = 1	
										}
//	sSQLTr = "INSERT INTO Ubic_Pall_MB (Cli_ID, Pt_ID, Ser_MB, Pro_ID)  "
//					sSQLTr  += "values("+Cli_ID+", "+Pt_ID+","+MB+", "+Pro_ID+")"
//						Ejecuta(sSQLTr, 0)
									}
									if(MB == Cantidad_Pallet && Articulos == Cantidad_MB){
												  var inputEscan = 'style="display:none;width:150%"'
													   inputMB = 'style="display:none;width:150%"'
	//sSQLTr = "INSERT INTO Ubic_Pallet (Cli_ID, Pt_ID, Ser_MB, Pro_ID, Pt_LPN, Pt_SKU)  "
//					sSQLTr  += "values("+Cli_ID+", "+Pt_ID+","+MB+", "+Pro_ID+", '"+Pt_LPN+"', '"+Pt_SKU+"' )"
//						Ejecuta(sSQLTr, 0)
	sSQLTr = "UPDATE Recepcion_Pallet SET Pt_PalletEscaneado = 1"
sSQLTr  += " WHERE Pt_ID = "+Pt_ID
				Ejecuta(sSQLTr, 0)
Response.Write("Escaneo de pallet finalizado. Se han escaneado todos los masterbox posibles.")%>
        <a data-taid="<%=TA_ID%>"  data-ocid= "<%=OC_ID%>"  data-provid= "<%=Prov_ID%>" data-cliocid= "<%=CliOC_ID%>" data-irid= "<%=IR_ID%>" data-client="<%=CliEnt_ID%>"  class="text-muted btnClasificar"><i class="fa fa-inbox"></i>&nbsp;<strong>Regresar a clasificacion de Pallets</strong></a>          </div>
						<%			} 
				 }
				     
						    	
									if(Pallet<= Cantidad_Pallet){
								
 	  var sSQLTr  = "SELECT * "+ condicion
	  var rsSer = AbreTabla(sSQLTr,1,0) 
	
	  	 var sSQLTr  = "SELECT * "+ condicion2
	  var rsSer2 = AbreTabla(sSQLTr,1,0) 

	 var sSQLTr  = "SELECT * "+ condicion3
	  var rsSer3 = AbreTabla(sSQLTr,1,0) 
	
		  if( !(rsSer.EOF) ){
			  if( !(rsSer2.BOF) ){
				  					var Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","Recepcion_Series","",-1,0)
sSQLTr = "INSERT INTO Recepcion_Series (Ser_ID, OC_ID, Prov_ID,CliOC_ID,  Cli_ID,  Ser_Serie, Pro_ID,"
sSQLTr  += "Ser_MB, Ser_Pallet, Ser_SerieEscaneada,Pt_ID, CliEnt_ID)  "
sSQLTr  += "values("+Ser_ID+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +", " +Cli_ID+", '"+Ser_Serie+"', "+Pro_ID+",  "+MB+","+Pallet+",1,"+Pt_ID+","+CliEnt_ID+")"				
		Ejecuta(sSQLTr, 0)
						 	
		}else{
			  if( !(rsSer3.EOF) ){
sSQLTr = "UPDATE Recepcion_Series SET Ser_SerieEscaneada = 1, Pt_ID = "+Pt_ID+", IR_ID = "+IR_ID+", Ser_MB= "+MB+", Ser_Pallet="+Pallet
sSQLTr  += "WHERE Ser_Serie = '"+Ser_Serie+"'"
				Ejecuta(sSQLTr, 0)
			}else{
	var Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","Recepcion_Series","",-1,0)
sSQLTr = "INSERT INTO Recepcion_Series  (Ser_ID, OC_ID, Prov_ID,CliOC_ID,  Cli_ID,  Ser_Serie, Pro_ID,Ser_MB, Ser_Pallet, Ser_SerieEscaneada,Pt_ID, CliEnt_ID)  "
sSQLTr  += "values("+Ser_ID+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +", " +Cli_ID+", '"+Ser_Serie+"', "+Pro_ID+",  "+MB+","+Pallet+",1,"+Pt_ID+","+CliEnt_ID+")"
				Ejecuta(sSQLTr, 0)
			}
			}
		}else	{
	 
		var Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","Recepcion_Series","",-1,0)
sSQLTr = "INSERT INTO Recepcion_Series  (Ser_ID, OC_ID, Prov_ID,CliOC_ID,  Cli_ID,  Ser_Serie, Pro_ID,Ser_MB, Ser_Pallet, Ser_SerieEscaneada,Pt_ID, CliEnt_ID)  "
sSQLTr  += "values("+Ser_ID+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +", " +Cli_ID+", '"+Ser_Serie+"', "+Pro_ID+",  "+MB+","+Pallet+",1,"+Pt_ID+","+CliEnt_ID+")"			
			Ejecuta(sSQLTr, 0)
		
		}
	
				//sSQLTr = "INSERT INTO Ubic_Pall_MB_ser (Cli_ID, Pt_ID, Ser_MB, Pro_ID,Ser_Serie)  "
//					sSQLTr  += "values("+Cli_ID+", "+Pt_ID+","+MB+", "+Pro_ID+", '"+Ser_Serie+"')"
//						Ejecuta(sSQLTr, 0)
			
									}
	}
			}
			 break;
			  case 2:
			  
			 	sSQLTr = "UPDATE Recepcion_Pallet SET Pt_MBRechazados = Pt_MBRechazados + 1 "
				sSQLTr += " WHERE Pt_ID = '"+Pt_ID+"'"
						Ejecuta(sSQLTr, 0)
						break;
	 			 }
		var sSQLTr  = "SELECT * FROM Recepcion_Series"
        sSQLTr += " WHERE Ser_SerieEscaneada = 1 AND  Pt_ID = "+Pt_ID 
		if(CliOC_ID > -1){
			sSQLTr += " AND  CliOC_ID= "+CliOC_ID + " ORDER BY Ser_ID Desc"

var cons = "SELECT CliEnt_CantidadPallet, CliEnt_CantidadArticulos AS Pro_Cantidad, CliEnt_TipoMasterBox FROM Cliente_OrdenCompra_EntregaProducto "
			var cond ="WHERE CliOC_ID= "+CliOC_ID+" and  Pro_ID = "+rsPro.Fields.Item("Pro_ID").Value+" AND CliEnt_ID = "+CliEnt_ID
			}
				if(OC_ID > -1){
		 sSQLTr += "  AND  OC_ID= "+OC_ID + " ORDER BY Ser_ID Desc"
var cons = "SELECT ProvEnt_CantidadPallet, ProvEnt_CantidadArticulos AS Pro_Cantidad, ProvEnt_TipoMasterBox FROM Proveedor_OrdenCompra_EntregaProducto "
	var cond = "WHERE OC_ID= "+OC_ID+" and  Pro_ID = "+rsPro.Fields.Item("Pro_ID").Value+" AND ProvEnt_ID = "+CliEnt_ID

			}
			if(TA_ID > -1){
			sSQLTr += " AND  TA_ID= "+TA_ID + " ORDER BY Ser_ID Desc"
				}
				 	sSQL = "SELECT *  FROM  Recepcion_Pallet WHERE  Pt_ID= "+Pt_ID+ " " 	/*%>	and ID_UsuarioLinea =  "+Id_Usuario<%*/
					      var rsPallets = AbreTabla(sSQL,1,0)
						
		 	  var rsSerie = AbreTabla(sSQLTr,1,0) 
			 var Pallet = 0
            while(!rsPallets.EOF){ 
			 var Pt_ID = rsPallets.Fields.Item("Pt_ID").Value 		
			 var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
             var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
             var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
             var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
			  var Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value 
			 Pallet = Pallet +1
			 sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '"+Pt_SKU+"'"
			 var rsProID = AbreTabla(sSQL,1,0)
			 sSQL = cons
			sSQL += cond

			var rsMB = AbreTabla(sSQL,1,0)
			var CantidadMB = rsMB.Fields.Item("Pro_Cantidad").Value
			var MB_ID =  rsMB.Fields.Item("CliEnt_TipoMasterBox").Value
			while(!rsMB.EOF){ 
	sSQL = "SELECT Pro_PesoNeto FROM Producto p " 
	sSQL +="WHERE p.Pro_ID = "+MB_ID+" AND Pro_Nombre LIKE 'MasterBox%'"
			var rsPeso =  AbreTabla(sSQL,1,0)
			
			if(!rsPeso.EOF){
			var Peso = rsPeso.Fields.Item("Pro_PesoNeto").Value
			}
			rsMB.MoveNext() 
        }
        rsMB.Close()   
		sSQLTr = "SELECT * FROM"
						if(CliOC_ID > -1){
	 sSQLTr += " Cliente_OrdenCompra_Articulos WHERE CliOCP_SKU = '"+ rsPallet.Fields.Item("Pt_SKU").Value+"' AND CliOC_ID = "+CliOC_ID
 	var rsPro = AbreTabla(sSQLTr,1,0) 
}
if(OC_ID > -1){
		 sSQLTr += " Proveedor_OrdenCompra_Articulos WHERE OCP_SKU = '"+ rsPallet.Fields.Item("Pt_SKU").Value+"' AND OC_ID = "+OC_ID
	var rsPro = AbreTabla(sSQLTr,1,0) 
	}
	if(TA_ID > -1){
	 sSQLTr += " Cliente_OrdenCompra_Articulos WHERE CliOCP_SKU = '"+ rsPallet.Fields.Item("Pt_SKU").Value+"' AND TA_ID = "+TA_ID
		var rsPro = AbreTabla(sSQLTr,1,0) 
	}
			
			sSQLTr = "SELECT COUNT(*) as escaneadas FROM Recepcion_Series WHERE Pro_ID = "+rsPro.Fields.Item("Pro_ID").Value+" AND "
			 sSQLTr += "Ser_SerieEscaneada = 1 AND Pt_ID = "+Pt_ID+ " AND "
			if(CliOC_ID > -1){
	 sSQLTr += "CliOC_ID = "+CliOC_ID
 	var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
}if(OC_ID > -1){
		 sSQLTr += "OC_ID = "+OC_ID
	var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
		var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
	}
	var escaneadas =  rsPallet.Fields.Item("Pt_Cantidad").Value - rsEscaneadas.Fields.Item("escaneadas").Value 
			
        %>	
   <input type="text" value="<%=Pt_SKU%>" style="display:none;width:150%"  class="objAco agenda"  id="Pt_SKU">
    <input type="text" value="<%=Pt_LPN%>" style="display:none;width:150%"  class="objAco agenda"  id="Pt_LPN">
            <tr>
           		 <td><%=Pallet%></td>
                <td><%=Pt_SKU%></td>
                <td><%=Pt_Modelo%></td>
                <td><%=Pt_Color%></td>
                <td><%=Pt_LPN%></td>
                <td><%=escaneadas%></td>
           

                                     <td class="desc">
 <label class="control-label col-md-3" id="InputPeso<%=Pt_ID%>" style="display:none;width:200%"><strong>Peso Aprox. <%=Peso%> kg</strong></label>   <input type="button"  data-ptid="<%=Pt_ID%>" id="BtnAprobado<%=Pt_ID%>" class="btn btn-primary BtnAprobado"  value= "Aprobar" style="display:none;width:70%"> </input>
                                      <input type="button"  data-ptid="<%=Pt_ID%>"  id="BtnRechazado<%=Pt_ID%>" class="btn btn-danger BtnRechazado" value= "Rechazar"  style="display:none;width:70%"> </input>
                                   <%/*%><input type="text" value=""  data-ovid="<%=OV_ID%>" placeholder="Peso de masterbox" class="form-control InputPeso" id="InputPeso<%=OV_ID%>"/><%*/ if(Pt_Cantidad == 0){ 
							%>
                           <strong> El pallet ya ha sido terminado de escanear </strong>
							<%
							  } else {
								  if(MB>0){
								  %>
                                   
                                        <input type="text" value="" <%=inputEscan%>  placeholder="Numero de serie" class="form-control InputScan agenda" id="InputScan" data-ptid="<%=Pt_ID%>" data-proid="<%=Pro_ID%>" data-artic= "<%=Articulos%>" data-totalmb="<%=MB%>" data-pallets="<%=Pallet%>" data-cantmb="<%=Cantidad_MB%>" data-cantpallet="<%=Cantidad_Pallet%>"/>
             
                                        <input type="button" value="Escanear masterbox"  <%=inputMB%> data-ptid="<%=Pt_ID%>" id="btnEscanear<%=Pt_ID%>" class="btn btn-info btnEscanear"/><%
								  }
										  } %>
   </td>
                                </tr>
                                  <%
                        rsPallets.MoveNext() 
                    }
                    rsPallets.Close()   
                    %>
                
                                </tbody>
                            </table>
                              
                      <table class="table">
    <thead>
    	<th>No. de Serie escaneado</th>
    	<th>Masterbox</th>
     	<th>Pallet</th>
   	
    	    </thead>
    <tbody>
	<%
	if(caracteres != NoCar){
				error = "  <tr>  <td class='text-center'>  <FONT COLOR='red'> "+Ser_Serie+" </FONT></td></tr>" + error
				%>
        <% }%>
     
	<%
	if(CliOC_ID > -1){
		var sSQLTr  = "SELECT * FROM Recepcion_Series  WHERE Ser_SerieEscaneada = 1 AND Pt_ID = "+Pt_ID+" AND Pro_ID = "+Pro_ID
					var SSQL = sSQLTr + "  AND  CliOC_ID= "+CliOC_ID+"  AND Ser_MB= "+MB+" AND Ser_Pallet = "+Pal+"  ORDER BY Ser_ID Desc "
			sSQLTr += " AND  CliOC_ID= "+CliOC_ID+" AND CliEnt_ID = "+CliEnt_ID+" ORDER BY Ser_ID Desc"
			}	if(OC_ID > -1){
			var SSQL = sSQLTr + "  AND  CliOC_ID= "+CliOC_ID+"  AND Ser_MB= "+MB+" AND Ser_Pallet = "+Pal+"  ORDER BY Ser_ID Desc "
		 sSQLTr += "  AND  OC_ID= "+OC_ID+ "  AND CliEnt_ID = "+CliEnt_ID+" ORDER BY Ser_ID Desc"
			}if(TA_ID > -1){
			sSQLTr += " AND  TA_ID= "+TA_ID+ "  AND CliEnt_ID = "+CliEnt_ID+"  ORDER BY Ser_ID Desc"
				}
		   var rsSerie = AbreTabla(sSQLTr,1,0) 
		   var rsMBActual =  AbreTabla(SSQL,1,0) 
	
		   if(rsSerie.RecordCount>0){
		    Pal = rsSerie.Fields.Item("Ser_Pallet").Value
			MB = rsSerie.Fields.Item("Ser_MB").Value
	
	     while(!rsMBActual.EOF){ 
	  
	%>
              <tr>
                   <td><%=rsMBActual.Fields.Item("Ser_Serie").Value%></td>
                 <%if (MB>-1){%>
                <td><%=rsMBActual.Fields.Item("Ser_MB").Value%></td>
                <td><%=rsMBActual.Fields.Item("Ser_Pallet").Value%></td>
                <%
				
					 }
					 	if(rsMBActual.Fields.Item("Ser_Incidencia").Value == 1){
				%>
               <td><input type="button" value="Incidencia" class="btn btn-danger btnIncidencia"/></td> <!--data-serid="%=Ser_ID%>" id="btnIncidencia%=TAA_ID%>"-->
                    <td><input type="text" value=""  style="display:none;width:350%;color:black;" placeholder="Escribe la incidencia" class="form-control InputIncidencia"/></td><!-- data-serid="%=Ser_ID%> id="InputIncidencia %=Ser_ID%>-->
            
        <%	
						}
						%>
                        </tr>
						<%
            rsMBActual.MoveNext() 
        }
        rsMBActual.Close()   
		   }
		%>
                           
    </tbody>
</table>
                        </div>
                    </div>
                  
                </div>

            </div>
       
        </div>
    </div>    

       <div class="col-md-3">
            <div class="ibox">
                <div class="col-md-10">
             <a data-taid="<%=TA_ID%>"  data-ocid= "<%=OC_ID%>"  data-provid= "<%=Prov_ID%>" data-cliocid= "<%=CliOC_ID%>" data-irid= "<%=IR_ID%>" data-client="<%=CliEnt_ID%>" class="text-muted btnClasificar"><i class="fa fa-inbox"></i>&nbsp;<strong>Ver pallets pendientes</strong></a>          </div>
                <div class="ibox-title">
               <br /> <th>SKU: <%=Pt_SKU%></th><br />
                     <%
					var MBescan =MB -1
		
			if(CliOC_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad FROM  Recepcion_Series WHERE   Pt_ID = "+Pt_ID+" AND CliOC_ID= "+CliOC_ID
			sSQL += " AND Pro_ID = "+Pro_ID+" AND Ser_MB= "+MB+" AND Ser_Pallet = "+Pal
			}
				  if(OC_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad  FROM  Recepcion_Series WHERE  Pt_ID = "+Pt_ID+" AND  OC_ID= "+OC_ID
			sSQL += " AND Pro_ID = "+Pro_ID+" AND Ser_MB = "+MB+"  AND Ser_Pallet ="+Pal
			}  if(TA_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad FROM  Recepcion_Series WHERE  TA_ID= "+TA_ID
			sSQL += " AND Pro_ID = "+Pro_ID+" AND Ser_MB = "+MB+" AND Ser_Pallet = "+Pal
				}
	         var rsMasterbox = AbreTabla(sSQL,1,0)
		if(rsMasterbox.RecordCount>0){
			 var Articulos = rsMasterbox.Fields.Item("Cantidad").Value 			
		}
				var masterbox = MB
				Pallet = Pal 	
				if(MB==Cantidad_Pallet){
				if(Articulos==Cantidad_MB){
				MB=0		
				}
	
				}
		
					%>
                  <td>Articulos masterbox: <%=Articulos%>/<%=Cantidad_MB%> <BR />Masterbox:  <%=MB%>/<%=Cantidad_Pallet%>  <br />Pallet: <%=Pal%></td>
              
                          <table class="table">
    <thead>
        <tr>
            <th class="text-center">Series mal escaneadas</th>
                    
            
        </tr>
    </thead>
    <tbody>
       <%=error%>

		 </tbody>
</table>
                   
                   
                   
                   
                </div>
                </div>
				</div>
                       <%   if(MB==-1){ MB = 111111 } %>
                                     <input type="text" value="<%=Pallet%>" style="display:none;width:150%"  class="objAco agenda"  id="Pallet">
                                     <input type="text" value="<%=MB%>" style="display:none;width:150%"  class="objAco agenda"  id="MB">
                                     <input type="text" value="<%=Articulos%>" style="display:none;width:150%"  class="objAco agenda"  id="Articulos">

                                     <input type="text" value="<%=error%>" style="display:none;width:150%"  class="objAco agenda"  id="error">
</div>
</div>
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	$('.btnClasificar').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
		Params += "&TA_ID=" + $(this).data("taid")   
	    Params += "&OC_ID=" + $(this).data("ocid")
		Params += "&Prov_ID=" + $(this).data("provid") 
        Params += "&IR_ID=" + $(this).data("irid") 
 		Params += "&CliEnt_ID=" +$(this).data("client") 

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp" + Params)
		});
	$('#InputScan').focus()
$('.btnEscanear').click(function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	$('#InputPeso'+Pt_ID).css('display','block')
	$('#BtnAprobado'+Pt_ID).css('display','block')
	$('#BtnRechazado'+Pt_ID).css('display','block')
		$('#InputScan').hide();
<%/*%>	$('#InputPeso'+OV_ID).focus()<%*/%>

});


$('.BtnAprobado').click(function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	$('#InputScan').css('display','block')
    $("#InputPeso"+Pt_ID).hide();
	$("#BtnAprobado"+Pt_ID).hide();
    $("#BtnRechazado"+Pt_ID).hide();
});
$('.BtnRechazado').click(function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	    $("#InputPeso"+Pt_ID).hide();
	$("#BtnAprobado"+Pt_ID).hide();
    $("#BtnRechazado"+Pt_ID).hide();
	var datoAgenda = {}
	
		var Pt_ID = $(this).data("ptid")
		datoAgenda['Pt_ID'] = Pt_ID
		datoAgenda['Tarea'] =2
	$("#dvEscaneos").load("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",datoAgenda
	 , function(data){
	
			sTipo = "info";
			sMensaje = "Ha sido reportado como incidencia ";
			
				Avisa(sTipo,"Aviso",sMensaje);
});
});
$('.InputPeso').on('change',function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	$('#InputScan'+Pt_ID).css('display','block')
	
});


$('.InputScan').on('change',function(e) {
	e.preventDefault()
	var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
	var Pro_ID = $(this).data("proid")
	var Pt_ID = $(this).data("ptid")
	var Articulos = $(this).data("artic")
	var Pallets = $(this).data("pallets")
	var totalMB = $(this).data("totalmb")
	var Cantidad_Pallet = $(this).data("cantpallet")
	var Cantidad_MB = $(this).data("cantmb")
		datoAgenda['Tarea'] =1
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
        datoAgenda['CliEnt_ID'] = $('#CliEnt_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
		datoAgenda['Pro_ID'] =Pro_ID
		datoAgenda['Pt_ID'] =Pt_ID
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		datoAgenda['Pt_SKU'] = $('#Pt_SKU').val()
		datoAgenda['Pt_LPN'] = $('#Pt_LPN').val()
		datoAgenda['Pallets'] = $('#Pallet').val()
		datoAgenda['Articulos'] = $('#Articulos').val()
		datoAgenda['MB'] =  $('#MB').val()
		datoAgenda['Cantidad_Pallet'] = Cantidad_Pallet
		datoAgenda['Cantidad_MB'] = Cantidad_MB
		datoAgenda['Ser_Serie'] = $('#InputScan').val()
		datoAgenda['error'] =  $('#error').val()

		$('#InputScan').hide();

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp",datoAgenda

    , function(data){
	
			sTipo = "info";
			sMensaje = "La serie se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
	});
	
});




 

				
	});
		

</script>            
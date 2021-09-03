<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1) 
	 
	var Pro_ID = Parametro("Pro_ID",-1)   
    var ProE_ID = Parametro("ProE_ID",-1)
    var IDUsuario = Parametro("IDUsuario",-1)
    var Pro_Usuario = Parametro("Pro_Usuario",-1)
    var ProE_Nombre = utf8_decode(Parametro("ProE_Nombre",""))
    var ProE_Valor = utf8_decode(Parametro("ProE_Valor",""))
	


 	var sResultado = ""
 	var result = 0
 	var message = ""
   
	switch (parseInt(Tarea)) {

		//Insert Servicio_Folio
   		case 1:
		try {
   				var sCondSer = "Pro_ID = " + Pro_ID
   				var iExisteFol = BuscaSoloUnDato("COUNT(*)","Producto_Extras",sCondSer + " AND ProE_ID = "+ProE_ID,-1,0)
   

				if(iExisteFol == 0) {
					
					if(ProE_ID == -1) {
						ProE_ID = BuscaSoloUnDato("ISNULL((MAX(ProE_ID)),0)+1","Producto_Extras",sCondSer,-1,0)				
					}
					
					var sINS  = " INSERT INTO Producto_Extras (Pro_ID, ProE_ID, ProE_Nombre, ProE_Valor,ProE_Usuario)"
						sINS += " VALUES ("+Pro_ID+","+ProE_ID+",'"+ProE_Nombre+"','"+ProE_Valor+"','"+IDUsuario+"')"

						Ejecuta(sINS,0)

						sResultado = 1 + "|" + ProE_ID		
					
				}
   
				// Existe el registro
				if(ProE_ID > -1 && iExisteFol > 0) {
				
					var sUPD  = " UPDATE Producto_Extras"
						sUPD += " SET ProE_Nombre = '" + ProE_Nombre + "'"
						sUPD += " , ProE_Valor = '" + ProE_Valor + "'"
						sUPD += " , ProE_Usuario = " + IDUsuario
						sUPD += " WHERE Pro_ID = " + Pro_ID
						sUPD += " AND ProE_ID = " + ProE_ID
						
						Ejecuta(sUPD,0)

						sResultado = 1 + "|" + ProE_ID					
				
				}				
				
		} 
		catch(err) {
			sResultado = 0 + "|" + -1
		}		
   		break;
	
		//Delete extra
   		case 2: 
	
			try {
			
				var sDELETE = " DELETE FROM Producto_Extras"
					sDELETE += " WHERE Pro_ID = " + Pro_ID
					sDELETE += " AND ProE_ID = " + ProE_ID

					Ejecuta(sDELETE,0)
	
					sResultado = 1 + "|" + -1
			} 
			catch(err) {
				sResultado = 0 + "|" + -1	
			
			}
		break;
		case 3:
		var TPro_ID = Parametro("TPro_ID",-1)  
		var valida = BuscaSoloUnDato("ProC_ID","Cat_TipoProducto_Categoria","TPro_ID = "+TPro_ID,-1,0)
		if(valida != -1){
		 %>
            <div class="form-group">
                <label class="control-label col-md-3 required">Categoria</label>
                <div class="col-lg-8">
                    <%CargaCombo("ProC_ID","class='form-control ProC_ID getdatos'","ProC_ID","ProC_Nombre","Cat_TipoProducto_Categoria","TPro_ID = "+TPro_ID,"ProC_ID",-1,0,"Selecciona","Editar")%>					   
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
                <div class="col-lg-8">
                    <%CargaCombo("ProSC_ID","class='form-control ProSC_ID getdatos'","ProSC_ID","ProSC_Nombre","Cat_TipoProducto_SubCategoria","TPro_ID = "+TPro_ID+" AND ProC_ID = "+ProC_ID,"ProSC_ID",-1,0,"Selecciona","Editar")%>					   
                </div>
            </div>
        <%}
		break; 
		case 5: //Cliente producto
			var Cli_ID = Parametro("Cli_ID",-1)   
			var Pro_ID = Parametro("Pro_ID",-1)   
			var SKU = Parametro("SKU",-1)   
			var Nombre = utf8_decode(Parametro("Nombre",""))   
			var Descripcion = utf8_decode(Parametro("Descripcion",""))  
			
				result = 1
				message = "INSERT INTO Producto_Cliente(Pro_ID,Cli_ID,ProC_SKU,ProC_Nombre,ProC_Descripcion) "
				message += " VALUES("+Pro_ID+","+Cli_ID+",'"+SKU+"','"+Nombre+"','"+Descripcion+"') "
				
			
			 
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
		break;
		case 6: //Proveedor producto
			var Prov_ID = Parametro("Prov_ID",-1)   
			var Pro_ID = Parametro("Pro_ID",-1)   
			var SKU = Parametro("SKU",-1)   
			var Nombre = utf8_decode(Parametro("Nombre",""))   
			var Descripcion = utf8_decode(Parametro("Descripcion",""))  
			
				result = 1
				message = "INSERT INTO Producto_Proveedor(Pro_ID,Cli_ID,ProC_SKU,ProC_Nombre,ProC_Descripcion) "
				message += " VALUES("+Pro_ID+","+Cli_ID+",'"+SKU+"','"+Nombre+"','"+Descripcion+"') "
				
			
			 
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
		break;
   		case 15: 
			var TPro_ID = Parametro("TPro_ID",-1)   
			var ProC_ID = Parametro("ProC_ID",-1)   
			var ProSC_ID = Parametro("ProSC_ID",-1)   
			var Mar_ID = Parametro("Mar_ID",-1)   
			var Col_ID = Parametro("Col_ID",-1)   
			var Mon_ID = Parametro("Mon_ID",-1)   
			var UdM_ID = Parametro("UdM_ID",-1)   
			var Edo_ID = Parametro("Edo_ID",-1)   
			var Tam_ID = Parametro("Tam_ID",-1)  
			var Pro_EsDesbloqueado = Parametro("Pro_EsDesbloqueado",0) 
			 
			
			var Pro_Nombre = utf8_decode(Parametro("Pro_Nombre",""))
			var Pro_SKU = utf8_decode(Parametro("Pro_SKU",""))
			var Pro_ClaveAlterna = utf8_decode(Parametro("Pro_ClaveAlterna",""))
			var Pro_FechaCaducidad = utf8_decode(Parametro("Pro_FechaCaducidad",""))
			var Pro_UPC = utf8_decode(Parametro("Pro_UPC",""))
			var Pro_EAN = utf8_decode(Parametro("Pro_EAN",""))
			var Pro_CodigoMarca = utf8_decode(Parametro("Pro_CodigoMarca",""))
			var Pro_DesbloqueoCodigo = utf8_decode(Parametro("Pro_DesbloqueoCodigo",""))
			var Pro_DimLargo = utf8_decode(Parametro("Pro_DimLargo",0))
			var Pro_DimAncho = utf8_decode(Parametro("Pro_DimAncho",0))
			var Pro_DimAlto = utf8_decode(Parametro("Pro_DimAlto",0))
			var Pro_Peso = utf8_decode(Parametro("Pro_Peso",0))
			var Pro_Volumen = utf8_decode(Parametro("Pro_Volumen",0))
			var Pro_PesoNeto = utf8_decode(Parametro("Pro_PesoNeto",0))
			var Pro_PesoBruto = utf8_decode(Parametro("Pro_PesoBruto",0))
		
		
		try {
			
   				var sCondSer = "Pro_ID = " + Pro_ID
   				var iExisteFol = BuscaSoloUnDato("COUNT(*)","Producto",sCondSer + " AND Pro_ID = "+Pro_ID,-1,0)
   

				if(iExisteFol == 0) {
					
					if(Pro_ID == -1) {
						Pro_ID = SiguienteID("Pro_ID","Producto","",0)				
					}
					try{
						var sINS  = " INSERT INTO Producto (Pro_ID, Pro_Usuario)"
							sINS += " VALUES ("+Pro_ID+","+Pro_Usuario+")"
	
							Ejecuta(sINS,0)
					}catch(err){
						sResultado = -1
					}
					try{	
						var sUPD  = " UPDATE Producto "
							sUPD += " SET TPro_ID = " +TPro_ID
							sUPD += " , ProC_ID = " + ProC_ID
							sUPD += " , ProSC_ID = " + ProSC_ID
							sUPD += " , Mar_ID = " + Mar_ID
							sUPD += " , Col_ID = " + Col_ID
							sUPD += " , Mon_ID = " + Mon_ID
							sUPD += " , UdM_ID = " + UdM_ID
							sUPD += " , Edo_ID = " + Edo_ID
							sUPD += " , Tam_ID = " + Tam_ID
							sUPD += " , Pro_EsDesbloqueado = " + Pro_EsDesbloqueado
							sUPD += " , Pro_Nombre = '" + Pro_Nombre + "'"
							sUPD += " , Pro_SKU = '" + Pro_SKU + "'"
							sUPD += " , Pro_ClaveAlterna = '" + Pro_ClaveAlterna + "'"
							sUPD += " , Pro_FechaCaducidad = '" + Pro_FechaCaducidad + "'"
							sUPD += " , Pro_UPC = '" + Pro_UPC + "'"
							sUPD += " , Pro_EAN = '" + Pro_EAN + "'"
							sUPD += " , Pro_CodigoMarca = '" + Pro_CodigoMarca + "'"
							sUPD += " , Pro_DesbloqueoCodigo = '" + Pro_DesbloqueoCodigo + "'"
							sUPD += " , Pro_DimLargo = '" + Pro_DimLargo + "'"
							sUPD += " , Pro_DimAncho = '" + Pro_DimAncho + "'"
							sUPD += " , Pro_DimAlto = '" + Pro_DimAlto + "'"
							sUPD += " , Pro_Volumen = '" + Pro_Volumen + "'"
							sUPD += " , Pro_PesoNeto = '" + Pro_PesoNeto + "'"
							sUPD += " , Pro_PesoBruto = '" + Pro_PesoBruto + "'"
							sUPD += " WHERE Pro_ID = " + Pro_ID
							
							Ejecuta(sUPD,0)
							
							sResultado = Pro_ID

					}catch(err){
						sResultado = -1
					}
				}
   
//				 Existe el registro
				if(Pro_ID > -1 && iExisteFol > 0) {
				
					var sUPD  = " UPDATE Producto"
						sUPD += " SET TPro_ID = " +TPro_ID
						sUPD += " , ProC_ID = " + ProC_ID
						sUPD += " , ProSC_ID = " + ProSC_ID
						sUPD += " , Mar_ID = " + Mar_ID
						sUPD += " , Col_ID = " + Col_ID
						sUPD += " , Mon_ID = " + Mon_ID
						sUPD += " , UdM_ID = " + UdM_ID
						sUPD += " , Edo_ID = " + Edo_ID
						sUPD += " , Tam_ID = " + Tam_ID
						sUPD += " , Pro_Nombre = '" + Pro_Nombre + "'"
						sUPD += " , Pro_SKU = '" + Pro_SKU + "'"
						sUPD += " , Pro_ClaveAlterna = '" + Pro_ClaveAlterna + "'"
						sUPD += " , Pro_FechaCaducidad = '" + Pro_FechaCaducidad + "'"
						sUPD += " , Pro_UPC = '" + Pro_UPC + "'"
						sUPD += " , Pro_EAN = '" + Pro_EAN + "'"
						sUPD += " , Pro_CodigoMarca = '" + Pro_CodigoMarca + "'"
						sUPD += " , Pro_DesbloqueoCodigo = '" + Pro_DesbloqueoCodigo + "'"
						sUPD += " , Pro_DimLargo = '" + Pro_DimLargo + "'"
						sUPD += " , Pro_DimAncho = '" + Pro_DimAncho + "'"
						sUPD += " , Pro_DimAlto = '" + Pro_DimAlto + "'"
						sUPD += " , Pro_Volumen = '" + Pro_Volumen + "'"
						sUPD += " , Pro_PesoNeto = '" + Pro_PesoNeto + "'"
						sUPD += " , Pro_PesoBruto = '" + Pro_PesoBruto + "'"
						sUPD += " WHERE Pro_ID = " + Pro_ID
						
						Ejecuta(sUPD,0)

						sResultado = Pro_ID			
				
				}				
				
		} 
		catch(err) {
			sResultado = -1
		}		
		break;
	}
	Response.Write(sResultado)
   
%>


<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1)  
	var Cli_ID =  Parametro("Cli_ID",-1)
	var Pro_Nombre = Parametro("Pro_Nombre","")
	var Pro_PesoBruto = Parametro("Pro_PesoBruto",-1)
	var Pro_PesoNeto = Parametro("Pro_PesoNeto",-1)
	var Pro_DimAlto = Parametro("Pro_DimAlto", -1)
	var Pro_DimLargo =  utf8_decode(Parametro("Pro_DimLargo",""))
	var Pro_DimAncho =  utf8_decode(Parametro("Pro_DimAncho",""))
	var Pro_SKU = Parametro("Pro_SKU","")
	var Pro_Descripcion = Parametro("Pro_Descripcion","")
	var Pro_Tipo_ABC = Parametro("Pro_Tipo_ABC","")
	var Pro_Habilitado = Parametro("Pro_Habilitado",0)
	var ProC_Clave = Parametro("ProC_Clave","")
	var ProC_PermitirSeleccionAGranel = Parametro("ProC_PermitirSeleccionAGranel",0)
	var ProC_RutaFoto = Parametro("ProC_RutaFoto","")
	var ProC_EsMateriaPrima = Parametro("ProC_EsMateriaPrima",0)
	var ProC_EsKit = Parametro("ProC_EsKit",0)
	var ProC_EsProducido = Parametro("ProC_EsProducido",0)
	var ProC_FIFO = Parametro("ProC_FIFO",0)
	var ProC_LIFO = Parametro("ProC_LIFO",0)
	var ProC_StockMinimo = Parametro("ProC_StockMinimo",0)
	var ProC_StockMaximo = Parametro("ProC_StockMaximo",0)
	var Pro_CantidadMB = Parametro("Pro_CantidadMB",0)
	var Pro_TipoMB = Parametro("Pro_TipoMB","")
	var Pro_PesoBruto2 = Parametro("Pro_PesoBruto2",-1)
	var Pro_PesoNeto2 = Parametro("Pro_PesoNeto2",-1)
	var Pro_DimAlto2 = Parametro("Pro_DimAlto2",-1)
	var Pro_DimLargo2 = Parametro("Pro_DimLargo2",-1)
	var Pro_DimAncho2 = Parametro("Pro_DimAncho2",-1)
	var Pro_CantidadPt = Parametro("Pro_CantidadPt",0)
	var Pro_TipoPt = Parametro("Pro_TipoPt","")
	var Pro_PesoBruto3 = Parametro("Pro_PesoBruto3",-1)
	var Pro_PesoNeto3 = Parametro("Pro_PesoNeto3",-1)
	var Pro_DimAlto3 = Parametro("Pro_DimAlto3",-1)
	var Pro_DimLargo3 = Parametro("Pro_DimLargo3",-1)
	var Pro_DimAncho3 = Parametro("Pro_DimAncho3",-1)
	
	var cboPallet = Parametro("cboPallet",-1)
	var cboMB = Parametro("cboMB",-1)

	var sResultado = ""
		
  
	
				var Pro_IDP = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto","",-1,0)
				var sSQL = " INSERT INTO Producto (Pro_ID, Pro_SKU, Pro_Tipo_ABC, Pro_Habilitado,  Pro_Nombre, Pro_Descripcion, Pro_PesoBruto, "
				sSQL += "  Pro_PesoNeto,Pro_DimAlto,Pro_DimLargo,Pro_DimAncho, Pro_SoloCliente) "
				sSQL += " VALUES (" +Pro_IDP +",'" +Pro_SKU +"','" +Pro_Tipo_ABC +"'," +Pro_Habilitado +",'" +Pro_Nombre+"',"
				sSQL += "'" +Pro_Descripcion+"', "+Pro_PesoBruto+"," +Pro_PesoNeto+", "+Pro_DimAlto+","+Pro_DimLargo+","+Pro_DimAncho+", 1)"
				
				Ejecuta(sSQL, 0)
				
		        var ProC_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto_Cliente","",-1,0)
				sSQL = " INSERT INTO Producto_Cliente (Pro_ID, ProC_SKU,  ProC_Nombre, ProC_Descripcion, ProC_Tipo_ABC, ProC_Clave,ProC_PermitirSeleccionAGranel, "
				sSQL += " ProC_RutaFoto,  ProC_EsMateriaPrima, ProC_EsKit, ProC_EsProducido, ProC_FIFO, ProC_LIFO,ProC_StockMinimo, ProC_StockMaximo, Cli_ID, "
				sSQL += "ProC_Habilitado) VALUES ("+ProC_ID+",'"+Pro_SKU+"','"+Pro_Nombre+"','" +Pro_Descripcion+"', '"+Pro_Tipo_ABC+"','"+ProC_Clave+"',"
				sSQL += +ProC_PermitirSeleccionAGranel+",'"+ProC_RutaFoto+"',"+ProC_EsMateriaPrima+","+ProC_EsKit+","+ProC_EsProducido+","+ProC_FIFO+","
				sSQL += +ProC_LIFO+","+ProC_StockMinimo+","+ProC_StockMaximo+","+Cli_ID+"," +Pro_Habilitado +")"
				Ejecuta(sSQL, 0)
				
				  var Pro_IDR = cboMB
					if(cboMB == -1){
		
				Pro_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto","",-1,0)
			    var Pro_CantidadMB2 = Pro_CantidadMB.toString(); 
				var Pro_ID2 = Pro_ID.toString(); 
				Pro_SKU = "MSTRBX"+Pro_CantidadMB2+Pro_ID2
				var Pro_Modelo = "MB" + Pro_CantidadMB2
				Pro_Nombre = "Masterbox "+ Pro_CantidadMB2
				Pro_TipoMB = "Masterbox " + Pro_TipoMB
				sSQL = " INSERT INTO Producto (Pro_ID, Pro_SKU,  Pro_Habilitado, Pro_Cantidad, TPro_ID, Pro_Modelo, Pro_Nombre, Pro_Descripcion, Pro_PesoBruto, "
				sSQL += "  Pro_PesoNeto,Pro_DimAlto,Pro_DimLargo,Pro_DimAncho, Pro_SoloCliente) "
				sSQL += " VALUES (" +Pro_ID +",'" +Pro_SKU +"'," +Pro_Habilitado +"," +Pro_CantidadMB +",4,'" +Pro_Modelo+"','" +Pro_Nombre+"','"
				sSQL += +Pro_TipoMB+"',"+Pro_PesoBruto2+"," +Pro_PesoNeto2+","+Pro_DimAlto2+","+Pro_DimLargo2+","+Pro_DimAncho2+", 1)"
				
				Ejecuta(sSQL, 0)
		        Pro_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto_Cliente","",-1,0)
				sSQL = " INSERT INTO Producto_Cliente (Pro_ID, ProC_SKU,  ProC_Nombre, ProC_Descripcion, Cli_ID) "
				sSQL += " VALUES ("+Pro_ID+",'"+Pro_SKU+"','"+Pro_Nombre+"','" +Pro_TipoMB+"',"+Cli_ID+")"
				Ejecuta(sSQL, 0)
				Pro_IDR = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)","Producto","",-1,0)
				}
	          
				  sSQL = " INSERT INTO Producto_Relacion (Pro_ID, Pro_ProdRelacionado,Pro_Cantidad) "
				sSQL += " VALUES (" +Pro_IDP +","+Pro_IDR+"," +Pro_CantidadMB +")"
		
				Ejecuta(sSQL, 0)
					 var Pro_IDR = cboPallet
					 
					if(cboPallet == -1){
			
				Pro_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto","",-1,0)
			    var Pro_CantidadPt2 = Pro_CantidadPt.toString(); 
			    Pro_ID2 = Pro_ID.toString(); 
	            Pro_SKU = "PLT"+Pro_CantidadPt2+Pro_ID2
			    Pro_Modelo = "Pt" + Pro_CantidadPt2
				Pro_Nombre = "Pallet "+ Pro_CantidadPt2
				Pro_TipoPt = "Pallet de " + Pro_TipoPt
				sSQL = " INSERT INTO Producto (Pro_ID, Pro_SKU,  Pro_Habilitado, Pro_Cantidad, TPro_ID, Pro_Modelo, Pro_Nombre, Pro_Descripcion, Pro_PesoBruto, "
				sSQL += "  Pro_PesoNeto,Pro_DimAlto,Pro_DimLargo,Pro_DimAncho, Pro_SoloCliente) "
				sSQL += " VALUES (" +Pro_ID +",'" +Pro_SKU +"'," +Pro_Habilitado +"," +Pro_CantidadPt +",5,'" +Pro_Modelo+"','" +Pro_Nombre+"','"
				sSQL += +Pro_TipoPt+"',"+Pro_PesoBruto3+"," +Pro_PesoNeto3+","+Pro_DimAlto3+","+Pro_DimLargo3+","+Pro_DimAncho3+", 1)"
				Ejecuta(sSQL, 0)
	
		        Pro_ID = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)+1","Producto_Cliente","",-1,0)
							sSQL = " INSERT INTO Producto_Cliente (Pro_ID, ProC_SKU,  ProC_Nombre, ProC_Descripcion, Cli_ID) "
				sSQL += " VALUES ("+Pro_ID+",'"+Pro_SKU+"','"+Pro_Nombre+"','" +Pro_TipoPt+"',"+Cli_ID+")"
				Ejecuta(sSQL, 0)
		        Pro_IDR = BuscaSoloUnDato("ISNULL((MAX(Pro_ID)),0)","Producto","",-1,0)

					}
		        sSQL = " INSERT INTO Producto_Relacion (Pro_ID, Pro_ProdRelacionado,Pro_Cantidad) "
				sSQL += " VALUES (" +Pro_IDP +","+Pro_IDR+"," +Pro_CantidadPt +")"
				Ejecuta(sSQL, 0)
				
					sResultado = 1
					
				
Response.Write(sResultado)
%>

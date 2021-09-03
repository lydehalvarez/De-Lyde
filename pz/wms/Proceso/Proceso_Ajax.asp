<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Tarea  = Parametro("Tarea",0)
	var Pro_ID  = Parametro("Pro_ID",-1)
    var ProF_ID = Parametro("ProF_ID",-1)
    var ProE_ID = Parametro("ProE_ID",-1)	

	var Cam_ID  = Parametro("Cam_ID",-1)
	var Campo  = Parametro("Campo","")		
	var Sec_ID  = Parametro("Sec_ID",-1)
	var Cat_ID  = Parametro("Cat_ID",-1)
	var ProE_Posibles  = Parametro("ProE_Posibles",0)
	var ProE_Controla  = Parametro("ProE_Controla",0)				
	var Valor  = utf8_decode(Parametro("Valor",""))
	
	
	var sResultado = ""
	switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
		    bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		case 1:  //guardando los datos de Datos Generales
			sResultado = ProF_ID
			var Tipo = "Edicion"
			try {	

				if(ProF_ID == -1 ) {
					var sSQLCont  = " SELECT ISNULL(Max(ProF_ID),0)+1 FROM BPM_Proceso_Flujo WHERE Pro_ID = " + Pro_ID 

					var rsSQLCont = AbreTabla(sSQLCont,1,0)
					if (!rsSQLCont.EOF) {
						ProF_ID = rsSQLCont.Fields.Item(0).Value
					}
					rsSQLCont.Close()	
					
					var sSQL = "IF NOT EXISTS (SELECT 1 FROM BPM_Proceso_Flujo "
						sSQL += " WHERE Pro_ID = " + Pro_ID + " AND ProF_ID = " + ProF_ID + ") "
						sSQL += " INSERT INTO BPM_Proceso_Flujo (Pro_ID, ProF_ID) VALUES (" + Pro_ID + "," + ProF_ID + ")"
					
					Ejecuta(sSQL,0)						
					Tipo = "Nuevo"
				}

				var sSQL = "UPDATE BPM_Proceso_Flujo "
					sSQL += " SET " + Campo + " = '" + Valor + "' "
					sSQL += " WHERE Pro_ID = " + Pro_ID 
					sSQL += " AND ProF_ID = " + ProF_ID 					
			 	
				Ejecuta(sSQL,0)	
				
				sResultado = '{"Resultado":"OK","ProF_ID":' + ProF_ID + ',"Tipo":"' + Tipo + '"}'
	
			} catch(err) {
				sResultado = '{"Resultado":"Error","Mensaje": "' + err.message + '"}'
			}
			Response.Write(sResultado)
		break;
		case 2:  //guardando los estatus
//				 @Pro_ID INT
//				,@ProF_ID INT
//				,@ProE_ID INT
//				,@Valor INT
//				,@Posible_Controla INT    --posible 0, controla 1
			var sSQLCont  = " EXEC PA_BPM_Guarda_Estatus " + Pro_ID + ", " + ProF_ID  
			    sSQLCont += ", " + ProE_ID + ", " + Valor + ", " + ProE_Posibles
				 
			Ejecuta(sSQLCont,0)

		break;
		case 3:  //guardando los datos del simulador
			sResultado = ""
			try {	

				var sSQL = "IF NOT EXISTS (SELECT 1 FROM Fn_Producto_Simulador "
				    sSQL += " WHERE Pro_ID = " + Pro_ID + ") "
					sSQL += " INSERT INTO Fn_Producto_Simulador (Pro_ID) VALUES (" + Pro_ID + ")"
				
				Ejecuta(sSQL,0)				

				var sSQL = "UPDATE Fn_Producto_Simulador "
					sSQL += " SET " + Campo + " = '" + Valor + "' "
					sSQL += " WHERE Pro_ID = " + Pro_ID 
				
				Ejecuta(sSQL,0)		
	
				sResultado = "ok"			
			} catch(err) {
				sResultado = "falla"	
			}
			Response.Write(sResultado)
		break;	
		case 4:  //guardando las funciones de los estatus
			sResultado = "-2"
			try {	

				var sSQL = "UPDATE BPM_Proceso_Flujo_Estatus "
					sSQL += " SET ProE_Funcion = '" + Valor + "' "
					sSQL += " WHERE Pro_ID = " + Pro_ID 
					sSQL += " AND ProF_ID = " + ProF_ID 
					sSQL += " AND ProE_ID = " + ProE_ID
					sSQL += " AND ProE_Posibles = 1 " 										
			 	
				Ejecuta(sSQL,0)		
	
				sResultado = "0"		//regresa cero cuando solo fue un update	
			} catch(err) {
				sResultado = "-2"	    //al eror
			}
			Response.Write(sResultado)
		break;
		case 14:  //guardando las validaciones de los estatus
			sResultado = "-2"
			try {	

				var sSQL = "UPDATE BPM_Proceso_Flujo_Estatus "
					sSQL += " SET ProE_Validacion = '" + Valor + "' "
					sSQL += " WHERE Pro_ID = " + Pro_ID 
					sSQL += " AND ProF_ID = " + ProF_ID 
					sSQL += " AND ProE_ID = " + ProE_ID
					sSQL += " AND ProE_Posibles = 1 " 										
			 	
				Ejecuta(sSQL,0)		
	
				sResultado = "0"		//regresa cero cuando solo fue un update	
			} catch(err) {
				sResultado = "-2"	    //al eror
			}
			Response.Write(sResultado)
		break;		
		
		
		
	}


%>
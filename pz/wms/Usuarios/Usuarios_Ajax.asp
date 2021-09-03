<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	
	var Tarea = Parametro("Tarea",0)
	var Cli_ID = Parametro("Cli_ID",-1)
	var Emp_ID = Parametro("Emp_ID",-1)	
	var Ope_ID = Parametro("Ope_ID",-1)	
	var EVtc_ID = Parametro("EVtc_ID",-1)
	var EVtcD_ID = Parametro("EVtcD_ID",-1)	
	var ERmb_ID = Parametro("ERmb_ID",-1)			
	var Com_ID = Parametro("Com_ID",1)	
	var Usu_ID = Parametro("Usu_ID",-1)
	var Doc_ID = Parametro("Doc_ID",-1)	
	var Docs_ID = Parametro("Docs_ID",-1)	
	var Prov_ID = Parametro("Prov_ID",-1)
	var Cli_Usu_ID = Parametro("Cli_Usu_ID",-1)
	var Prov_Usu_ID = Parametro("Prov_Usu_ID",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
	var ID_Unico = Parametro("ID_Unico",-1)	
	var Alr_ID = Parametro("Alr_ID",-1)
	var AlrS_ID = Parametro("AlrS_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var ProR_ID = Parametro("ProR_ID",-1)		
	var Chkdo = Parametro("Chkdo",false)
	
	
	var Docs_Titulo = utf8_decode(Parametro("Docs_Titulo",""))
	var Docs_RutaArchivo = utf8_decode(Parametro("Docs_RutaArchivo",""))
	var Docs_Observaciones = utf8_decode(Parametro("Docs_Observaciones",""))
	var Docs_Nombre = utf8_decode(Parametro("Docs_Nombre",""))		
	
	var sResultado = ""

	if(Tarea < 4) {
		try {	
		
			var sSQL = "Exec PA_Usuarios_Notificaciones " + ID_Unico
				sSQL += ", " + AlrS_ID + "," + Alr_ID					
				sSQL += ", " + Tarea + "," + Chkdo + "," + IDUsuario
	
			Ejecuta(sSQL,0)		
		
			sResultado = "OK"		
		} catch(err) {
			sResultado = "falla"	
		}
	}


	if(Tarea == 8) {
		try {	

			var sSQL = "DELETE FROM BPM_Proceso_Rol_Usuario "
			    sSQL += " WHERE Pro_ID = " + Pro_ID 
				sSQL += " and ProR_ID = " + ProR_ID
				sSQL += " and Ope_ID = " + ID_Unico

			Ejecuta(sSQL,0)		
			
			if( Chkdo == 1 ) {
				var sSQL = "INSERT INTO BPM_Proceso_Rol_Usuario( Pro_ID, ProR_ID, Ope_ID ) " 
					sSQL += " VALUES( " + Pro_ID + ", " + ProR_ID + ", " + ID_Unico + " ) "
	
				Ejecuta(sSQL,0)				
			
			}
		
			sResultado = "OK"		
		} catch(err) {
			sResultado = "falla"	
		}
	}	

	if(Tarea == 9) {
		try {	

			var sSQL = "DELETE FROM BPM_Proceso_Rol_Usuario "
			    sSQL += " WHERE Pro_ID = " + Pro_ID 
				sSQL += " and ProR_ID = " + ProR_ID
				sSQL += " and Emp_ID = " + ID_Unico

			Ejecuta(sSQL,0)		
			
			if( Chkdo == 1 ) {
				var sSQL = "INSERT INTO BPM_Proceso_Rol_Usuario( Pro_ID, ProR_ID, Emp_ID ) " 
					sSQL += " VALUES( " + Pro_ID + ", " + ProR_ID + ", " + ID_Unico + " ) "
	Response.Write(sSQL)
				Ejecuta(sSQL,0)				
			
			}
		
			sResultado = "OK"		
		} catch(err) {
			sResultado = "falla"	
		}
	}	

	
	if(Tarea == 10) {
		try {	

			var sSQL = "DELETE FROM BPM_Proceso_Rol_Usuario "
			    sSQL += " WHERE Pro_ID = " + Pro_ID 
				sSQL += " and ProR_ID = " + ProR_ID
				sSQL += " and Usu_ID = " + ID_Unico

			Ejecuta(sSQL,0)		
			
			if( Chkdo == 1 ) {
				var sSQL = "INSERT INTO BPM_Proceso_Rol_Usuario( Pro_ID, ProR_ID, Usu_ID ) " 
					sSQL += " VALUES( " + Pro_ID + ", " + ProR_ID + ", " + ID_Unico + " ) "
	
				Ejecuta(sSQL,0)				
			
			}
		
			sResultado = "OK"		
		} catch(err) {
			sResultado = "falla"	
		}
	}	


 	if(Tarea == 11) {
		var sResultado = ""
		var sSQL = " SELECT Dep_ID, Dep_Nombre "
			sSQL += " FROM Compania_Departamento "
			if(Com_ID>0){
				sSQL += " WHERE Com_ID = " + Com_ID
			} else {
				sSQL += " WHERE Com_ID = 1 "  			
			}

		var rsRS = AbreTabla(sSQL,1,0)
		
		while (!rsRS.EOF){
			if(sResultado != "") { 
				sResultado += ","
			}
			   sResultado += rsRS.Fields.Item("Dep_ID").Value 
			   sResultado += ":" 
			   sResultado += rsRS.Fields.Item("Dep_Nombre").Value 
			rsRS.MoveNext() 
		}
			rsRS.Close()	
			
		Response.Write(sResultado)
	}
	
	
	//guardar facturas a la bd de viaticos
 	if(Tarea == 12) {
			try {	
						
			   var sCondicion = " Emp_ID = " + Emp_ID
		           sCondicion += " AND EVtc_ID = " + EVtc_ID
		           sCondicion += " AND EVtcD_ID = " + EVtcD_ID				   
		           sCondicion += " AND Doc_ID = " + Doc_ID	

				sResultado = SiguienteID("Docs_ID","Empleado_Viaticos_Documentos",sCondicion,0)
				
			} catch(err) {
				sResultado = "ERROR"
			}

			
		Response.Write(sResultado)
	}
	
	//guardar facturas a la bd de viaticos
 	if(Tarea == 13) {
			
			try {
				//  Doc_ID   7 = factura, 16 Prueba de recepcion de mercancia

				var sSQLACT = "IF NOT EXISTS (SELECT 1 FROM Empleado_Viaticos_Documentos "
					sSQLACT += " WHERE Emp_ID = " + Emp_ID
					sSQLACT += " AND EVtc_ID = " + EVtc_ID
					sSQLACT += " AND EVtcD_ID = " + EVtcD_ID						
					sSQLACT += " AND Doc_ID = " + Doc_ID						
					sSQLACT += " AND Docs_ID = " + Docs_ID + " )"									
				
				    sSQLACT +=  "INSERT INTO Empleado_Viaticos_Documentos (Emp_ID, EVtc_ID, EVtcD_ID, Doc_ID, Docs_ID, Docs_UsuarioCargo,  "
					if(Doc_ID == 7 ) {
						sSQLACT += " Docs_EsFactura "
					}
					if(Doc_ID == 16 ) {
						sSQLACT += " Docs_EsRecepcion "
					}
					if(Doc_ID == 18 ) {
						sSQLACT += " Docs_EsPago "
					}					
					sSQLACT += " ) VALUES (" + Emp_ID + "," + EVtc_ID + "," + EVtcD_ID + "," + Doc_ID + "," + Docs_ID
					sSQLACT += " , dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ")"  
					sSQLACT += " , 1 )"
				 
				 Ejecuta(sSQLACT,0)
			 
				sResultado = "OK"
			} catch(err) {
				sResultado = "ERROR"
			}		
			
			try {	
				var sSQL = "UPDATE Empleado_Viaticos_Documentos "
					sSQL += " SET Docs_Titulo = '" + Docs_Titulo + "'" 
					sSQL += " , Docs_RutaArchivo = '" + Docs_RutaArchivo + "'"
					sSQL += " , Docs_Observaciones = '" + Docs_Observaciones + "'"
					sSQL += " , Docs_Nombre = '" + Docs_Nombre + "'"
					if(Doc_ID == 7 ) {
						sSQL += " , Docs_EsUnCFDI = 1 "      //esto disparara el trigger para hacer la accion de carga facturas
					}
					sSQL += " WHERE Emp_ID = " + Emp_ID
					sSQL += " AND EVtc_ID = " + EVtc_ID
					sSQL += " AND EVtcD_ID = " + EVtcD_ID
					sSQL += " AND Doc_ID = " + Doc_ID
					sSQL += " AND Docs_ID = " + Docs_ID

				 Ejecuta(sSQL,0)		
				
				sResultado = 1	
			} catch(err) {
				sResultado = -1	
			}
			
			
			sResultado = "OK"
			Response.Write(sResultado)
		}
		
	//guardar facturas a la bd de reembolsos
 	if(Tarea == 14) {
			try {	
						
			   var sCondicion = " Emp_ID = " + Emp_ID
		           sCondicion += " AND ERmb_ID = " + ERmb_ID			   
		           sCondicion += " AND Doc_ID = " + Doc_ID	

				sResultado = SiguienteID("Docs_ID","Empleado_Reembolso_Documentos",sCondicion,0)
				
			} catch(err) {
				sResultado = "ERROR"
			}

			
		Response.Write(sResultado)
	}	
		
		
	
	//guardar facturas a la bd de reembolsos
 	if(Tarea == 15) {
			
			try {
				//  Doc_ID   7 = factura, 16 Prueba de recepcion de mercancia

				var sSQLACT = "IF NOT EXISTS (SELECT 1 FROM Empleado_Reembolso_Documentos "
					sSQLACT += " WHERE Emp_ID = " + Emp_ID
					sSQLACT += " AND ERmb_ID = " + ERmb_ID						
					sSQLACT += " AND Doc_ID = " + Doc_ID						
					sSQLACT += " AND Docs_ID = " + Docs_ID + " )"									
				
				    sSQLACT +=  "INSERT INTO Empleado_Reembolso_Documentos (Emp_ID, ERmb_ID, Doc_ID, Docs_ID, Docs_UsuarioCargo,  "
					if(Doc_ID == 7 ) {
						sSQLACT += " Docs_EsFactura "
					}
					if(Doc_ID == 16 ) {
						sSQLACT += " Docs_EsRecepcion "
					}
					if(Doc_ID == 18 ) {
						sSQLACT += " Docs_EsPago "
					}					
					sSQLACT += " ) VALUES (" + Emp_ID + "," + ERmb_ID + "," + Doc_ID + "," + Docs_ID
					sSQLACT += " , dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ")"  
					sSQLACT += " , 1 )"
				 
				 Ejecuta(sSQLACT,0)
			 
				sResultado = "OK"
			} catch(err) {
				sResultado = "ERROR"
			}		
			
			try {	
				var sSQL = "UPDATE Empleado_Reembolso_Documentos "
					sSQL += " SET Docs_Titulo = '" + Docs_Titulo + "'" 
					sSQL += " , Docs_RutaArchivo = '" + Docs_RutaArchivo + "'"
					sSQL += " , Docs_Observaciones = '" + Docs_Observaciones + "'"
					sSQL += " , Docs_Nombre = '" + Docs_Nombre + "'"
					if(Doc_ID == 7 ) {
						sSQL += " , Docs_EsUnCFDI = 1 "      //esto disparara el trigger para hacer la accion de carga facturas
					}
					sSQL += " WHERE Emp_ID = " + Emp_ID
					sSQL += " AND ERmb_ID = " + ERmb_ID
					sSQL += " AND Doc_ID = " + Doc_ID
					sSQL += " AND Docs_ID = " + Docs_ID

				 Ejecuta(sSQL,0)		
				
				sResultado = 1	
			} catch(err) {
				sResultado = -1	
			}
			
			
			sResultado = "OK"
			Response.Write(sResultado)
		}
			
%>
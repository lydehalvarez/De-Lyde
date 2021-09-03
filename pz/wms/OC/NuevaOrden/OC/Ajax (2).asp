<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea   = Parametro("Tarea",0)

var OC_ID   = Parametro("OC_ID",-1)
var Usu_ID  = Parametro("Usu_ID",-1)                      //entra como idunico -- iIDUsuario
var OC_CompradorID  = Parametro("OC_CompradorID",-1)      //entra como idunico 
var OC_UsuIDSolicita  = Parametro("OC_UsuIDSolicita",-1)  //entra directo

var Com_ID  = Parametro("Com_ID",-1)
var Pry_ID   = Parametro("Des_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Are_ID = Parametro("Are_ID",-1)  //uno  
var Dep_ID  = Parametro("Dep_ID",-1)
var Loc_ID  = Parametro("Loc_ID",-1)
var CC_ID   = Parametro("CC_ID",-1)
var Tg_ID   = Parametro("Tg_ID",-1)	
var CB_ID   = Parametro("CB_ID",-1)

var Pro_ID   = Parametro("Pro_ID",1)
var Chkd    = Parametro("Chkd",0)	
var OC_TipoOCCG47 = Parametro("OC_TipoOCCG47",1)
var OC_EstatusCG51 = Parametro("OC_EstatusCG51",1)	
var Campo  = Parametro("Campo","")					
var Valor  = utf8_decode(Parametro("Valor",""))
var Doc_ID = Parametro("Doc_ID",-1)
var Docs_ID = Parametro("Docs_ID",-1)

var OC_PlazoCG1 = Parametro("OC_PlazoCG1",-1)
var OC_PeriodoCG2 = Parametro("OC_PeriodoCG2",-1)
var OC_Total = Parametro("OC_Total",-1)

var OC_Concepto = utf8_decode(Parametro("OC_Concepto",""))  
var OC_Total = Parametro("OC_Total",0)
var OC_Factura  = utf8_decode(Parametro("OC_Factura",""))
var Doc_Nombre  = utf8_decode(Parametro("Doc_Nombre",""))
var Doc_Nombre  = utf8_decode(Parametro("Doc_Nombre",""))
var Docs_RutaArchivo  = utf8_decode(Parametro("Docs_RutaArchivo",""))
var Docs_Titulo  = utf8_decode(Parametro("Docs_Titulo",""))
var Docs_Observaciones  = utf8_decode(Parametro("Docs_Observaciones",""))
var OC_Comentarios  = utf8_decode(Parametro("OC_Comentarios",""))
var OC_Descripcion  = utf8_decode(Parametro("OC_Descripcion",""))		
var OC_CondicionPago  = utf8_decode(Parametro("OC_CondicionPago","")) 
var OC_CondicionPagoCG18 = Parametro("OC_CondicionPagoCG18",1)

var OC_FechaRequerida = Parametro("OC_FechaRequerida","")
var OC_FechaInicio = Parametro("OC_FechaInicio","")
var OC_FechaFin = Parametro("OC_FechaFin","")
				   				
var sResultado = ""
		

function RegistraHistoria(p, o, u, tp){
	
    var OCH_ID = 1
	var sSQL = " SELECT ISNULL(MAX(OCH_ID),0) + 1 "
		sSQL += " FROM OrdenCompra_Historia "
		sSQL += " WHERE Prov_ID = " + Prov_ID
		sSQL += " AND OC_ID = " + OC_ID
	
	var rsRS = AbreTabla(sSQL,1,0)
	
	if (!rsRS.EOF){
		   OCH_ID = rsRS.Fields.Item(0).Value 
	}
	rsRS.Close()	
	
	try {			

		var sSQL = "INSERT INTO OrdenCompra_Historia( Prov_ID, OC_ID, OCH_ID, OCH_TipoCG51, Usu_ID ) "
			sSQL += " VALUES ( " + p 
			sSQL += ", " + o
			sSQL += ", " + OCH_ID
			sSQL += ", " + tp + ", dbo.fn_Usuario_DameIDUsuario(" + u + ") )"

		Ejecuta(sSQL,0)					

		sResultado = 1	
	} catch(err) {
		sResultado = -1	
	}
}


function ComentarHistoria(p, o, u, Sc, Obs){
	
    var OCH_ID = 1
	var sSQL = " SELECT ISNULL(MAX(OCH_ID),0) + 1 "
		sSQL += " FROM OrdenCompra_Historia "
		sSQL += " WHERE Prov_ID = " + Prov_ID
		sSQL += " AND OC_ID = " + OC_ID
	
	var rsRS = AbreTabla(sSQL,1,0)
	
	if (!rsRS.EOF){
		   OCH_ID = rsRS.Fields.Item(0).Value 
	}
	rsRS.Close()	
	
	try {			

		var sSQL = "INSERT INTO OrdenCompra_Historia( Prov_ID, OC_ID, OCH_ID, OCH_TipoCG51, Usu_ID, OCH_Seccion, OCH_Descripcion ) "
			sSQL += " VALUES ( " + p 
			sSQL += ", " + o
			sSQL += ", " + OCH_ID
			sSQL += ", 0, dbo.fn_Usuario_DameIDUsuario(" + u + ") "
			sSQL += ", '" + Sc + "' , '" + Obs + "' )"

		Ejecuta(sSQL,0)					

		sResultado = 1	
	} catch(err) {
		sResultado = -1	
	}
}

 
switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
			bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		
		case 1:	// Nueva orden de compra 
				//ojo , se divide en un insert seguro y muchos updates por tema
		    var OC_ID = 0
			
			try {		
			   //var sCondicion = " Prov_ID = " + Prov_ID
               var sCondicion = ""
			   OC_ID = SiguienteID("OC_ID","OrdenCompra",sCondicion,0)
			   sResultado = OC_ID
			
			} catch(err) {
				OC_ID = 0
			}
		
			try {  
                
				//todos los id de usuarios son directos no son idunicos
                var sSQLACT = "INSERT INTO OrdenCompra ( OC_ID, Pro_ID, OC_BPM_Pro_ID"
                    sSQLACT += ",OC_TipoOCCG47, OC_FechaElaboracion"
                    sSQLACT += ",OC_UsuIDSolicita, OC_CompradorID, OC_UsuIDOriginador"
                    sSQLACT += ",OC_BPM_UsuID, Com_ID )"
                    sSQLACT += " VALUES (" + OC_ID + "," + Pro_ID + "," + Pro_ID                
                    sSQLACT += "," + OC_TipoOCCG47 + ", GETDATE() "
                    sSQLACT += "," + OC_UsuIDSolicita + "," + OC_CompradorID + "," + Usu_ID
                    sSQLACT += "," + Usu_ID + "," + Com_ID + ")"                   

                /*   
				var sSQLACT = "INSERT INTO OrdenCompra (Prov_ID, OC_ID, OC_TipoOCCG47, OC_FechaElaboracion, OC_BPM_Pro_ID "
				    sSQLACT += " , OC_UsuIDSolicita, OC_CompradorID, OC_UsuIDOriginador, OC_BPM_UsuID ) "
					sSQLACT += " VALUES (" + Prov_ID + "," + OC_ID + "," + OC_TipoOCCG47 + ", GETDATE()," + OC_TipoOCCG47
					sSQLACT += ", " + OC_UsuIDSolicita 
					sSQLACT += ", dbo.fn_Usuario_DameIDUsuario(" + OC_CompradorID + ") " 
					sSQLACT += ", dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ") "
					sSQLACT += ", dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ") )"
			     */

				    Ejecuta(sSQLACT,0)

				sResultado = OC_ID
			} catch(err) {
				sResultado = -1
			}
			
	
			try {  

                var sSQLACT = "UPDATE OrdenCompra "
                    sSQLACT += " SET Com_ID = " + Com_ID
                    sSQLACT += " ,OC_Concepto = '" + OC_Concepto + "'"
                    sSQLACT += " ,OC_Descripcion = '" + OC_Descripcion + "'"
                    sSQLACT += " ,OC_CondicionPago = '" + OC_CondicionPago + "'"
					sSQLACT += " ,OC_CondicionPagoCG18 = " + OC_CondicionPagoCG18
  
					if ( Pry_ID > -1 ){
				    	sSQLACT += " ,Pry_ID = " + Pry_ID
					}   

					if ( Pry_ID > -1 ){
				    	sSQLACT += " ,Loc_ID = " + Loc_ID
					}   
					if ( OC_Total > -1 ){
				    	sSQLACT += " ,OC_Total = " + OC_Total
					}  			
					if ( OC_PeriodoCG2 > -1 ){
				    	sSQLACT += " ,OC_PeriodoCG2 = " + OC_PeriodoCG2
					}  								
					                      
                    sSQLACT += " WHERE OC_ID = " + OC_ID
    		
				Ejecuta(sSQLACT,0)
			 
			} catch(err) {
				sResultado = "error en el query"
			}	
			
// seccion de updates cortos segun el tema
						
			//fechas
			if(OC_FechaRequerida != ""){
				try {  
					OC_FechaRequerida = CambiaFormatoFecha(OC_FechaRequerida,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
					if (OC_FechaRequerida != '--') {
						var sSQLACT = "UPDATE OrdenCompra "
							sSQLACT += " SET OC_FechaRequerida = '" + OC_FechaRequerida + "'"
							sSQLACT += " WHERE OC_ID = " + OC_ID
					
						Ejecuta(sSQLACT,0)
					}
				} catch(err) {
					sResultado = "error en el query"
				}	
			}

			if(OC_FechaInicio != ""){
				try {  
					OC_FechaInicio = CambiaFormatoFecha(OC_FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
					if (OC_FechaInicio != '--') {
						var sSQLACT = "UPDATE OrdenCompra "
							sSQLACT += " SET OC_FechaInicio = '" + OC_FechaInicio + "'"
							sSQLACT += " WHERE OC_ID = " + OC_ID
					
						Ejecuta(sSQLACT,0)
					}
				} catch(err) {
					sResultado = "error en el query"
				}	
			}

			if(OC_FechaFin != ""){
				try {  
					OC_FechaFin = CambiaFormatoFecha(OC_FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
					if (OC_FechaFin != '--') {
						var sSQLACT = "UPDATE OrdenCompra "
							sSQLACT += " SET OC_FechaFin = '" + OC_FechaFin + "'"
							sSQLACT += " WHERE OC_ID = " + OC_ID
					
						Ejecuta(sSQLACT,0)
					}
				} catch(err) {
					sResultado = "error en el query"
				}	
			}	


			Response.Write(sResultado)
		break; 
		case 2:	// edicion de una OC de Anticipo
		
			try {  
				var sSQLACT = "UPDATE OrdenCompra  "
				    sSQLACT += " SET Com_ID = " + Com_ID
				    sSQLACT += " ,OC_Descripcion = '" + OC_Descripcion + "'"			
				    sSQLACT += " ,OC_CondicionPago = '" + OC_CondicionPago + "'"
				    sSQLACT += " ,Pry_ID = " + Pry_ID
				    sSQLACT += " ,Tg_ID = " + Tg_ID
				    sSQLACT += " ,Dep_ID = " + Dep_ID
				    sSQLACT += " ,CC_ID = " + CC_ID	
				    sSQLACT += " ,OC_Total = " + OC_Total
					sSQLACT += " ,OC_BPM_UsuID = " + Usu_ID
				    //sSQLACT += " ,OC_BPM_UsuID = dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ") " 	   
					sSQLACT += " WHERE Prov_ID = " + Prov_ID 
					sSQLACT += " AND OC_ID = " + OC_ID   
					
				Ejecuta(sSQLACT,0)
				
				var sSQLACT = "UPDATE OrdenCompra  "
				    sSQLACT += " SET OC_Comentarios = '" + OC_Comentarios + "'"												   	   
					sSQLACT += " WHERE Prov_ID = " + Prov_ID 
					sSQLACT += " AND OC_ID = " + OC_ID   
					
				Ejecuta(sSQLACT,0)				
		
			if(OC_FechaRequerida != ""){
				try {  
					OC_FechaRequerida = CambiaFormatoFecha(OC_FechaRequerida,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
					if (OC_FechaRequerida != '--') {
						var sSQLACT = "UPDATE OrdenCompra "
							sSQLACT += " SET OC_FechaRequerida = '" + OC_FechaRequerida + "'"
							sSQLACT += " WHERE OC_ID = " + OC_ID
					
						Ejecuta(sSQLACT,0)
					}
				} catch(err) {
					sResultado = "error en el query"
				}	
			}
				
			 
			} catch(err) {
				sResultado = -1
			}			
		break; 
		case 3:	// se autoriza la orden de compra por parte de direccion
		
			try {  

				var sSQLACT = "UPDATE OrdenCompra  "
				    sSQLACT += " SET OC_EsSolicitud = 0 "
				    sSQLACT += " , OC_UsuIDAutorizador =  dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ")"	
					sSQLACT += " , OC_FechaAutorizada = getdate() "
					sSQLACT += " , OC_BPM_UsuID =  dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ")"	
					sSQLACT += " WHERE Prov_ID = " + Prov_ID 
					sSQLACT += " AND OC_ID = " + OC_ID   
					
				Ejecuta(sSQLACT,0)
				
                RegistraHistoria(Prov_ID, OC_ID, Usu_ID, OC_EstatusCG51)
				
			 
			} catch(err) {
				sResultado = -1
			}			
		break; 				
		case 4:	// Cambio de compañia de una OC
		
			try {  

				var sSQLACT = "UPDATE OrdenCompra  "
				    sSQLACT += " SET Com_ID = " + Com_ID						   	   
					sSQLACT += " WHERE Prov_ID = " + Prov_ID 
					sSQLACT += " AND OC_ID = " + OC_ID   
					
				Ejecuta(sSQLACT,0)
				
				ComentarHistoria(Prov_ID, OC_ID, Usu_ID, "Clasificacion", "Cambio de compañia")
			 
			} catch(err) {
				sResultado = -1
			}			
		break; 		
		case 5:	// Cambio del tipo de gasto de una OC
		
			try {  

				var sSQLACT = "UPDATE OrdenCompra  "
				    sSQLACT += " SET Tg_ID = " + Tg_ID						   	   
					sSQLACT += " WHERE Prov_ID = " + Prov_ID 
					sSQLACT += " AND OC_ID = " + OC_ID   
					
				Ejecuta(sSQLACT,0)

				ComentarHistoria(Prov_ID, OC_ID, Usu_ID, "Clasificacion", "Cambio de tipo de gasto")
			 
			} catch(err) {
				sResultado = -1
			}			
		break; 	
		case 6:	// registra la clasificacion de la oc
 
			try {  

				var sSQLD = "DELETE FROM OrdenCompra_Clasificacion  "					   	   
					sSQLD += " WHERE Prov_ID = " + Prov_ID 
					sSQLD += " AND OC_ID = " + OC_ID   
					sSQLD += " AND CC_ID = " + CC_ID   					
					
				Ejecuta(sSQLD,0)

			} catch(err) {
				sResultado = -1
			}					   
		
			if(Chkd == 1){
				try {  
	
					var sSQLI = "INSERT INTO OrdenCompra_Clasificacion (Prov_ID, OC_ID, Pry_ID, Dep_ID "
						sSQLI += " , CC_ID, OCC_Usu_ID, OCC_Valor ) "
						sSQLI += " VALUES (" + Prov_ID + "," + OC_ID + ", -1, -1, " + CC_ID 
						sSQLI += ", dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ") ,1 )"
									
					Ejecuta(sSQLI,0)
				 
				} catch(err) {
					sResultado = -1
				}
			}
				
		break; 		
		case 7:	// registra la clasificacion del departamento
 
			try {  

				var sSQLD = "DELETE FROM OrdenCompra_Clasificacion  "					   	   
					sSQLD += " WHERE Prov_ID = " + Prov_ID 
					sSQLD += " AND OC_ID = " + OC_ID   
					sSQLD += " AND Dep_ID = " + Dep_ID  
					sSQLD += " AND Com_ID = " + Com_ID   					
					
				Ejecuta(sSQLD,0)

			} catch(err) {
				sResultado = -1
			}					   
		
			if(Chkd == 1){
				try {  
	
					var sSQLI = "INSERT INTO OrdenCompra_Clasificacion (Prov_ID, OC_ID, Pry_ID, Dep_ID "
						sSQLI += " ,Com_ID , CC_ID, OCC_Usu_ID, OCC_Valor ) "
						sSQLI += " VALUES (" + Prov_ID + "," + OC_ID + ", -1, " + Dep_ID
						sSQLI += "," + Com_ID + ", -1, dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ") ,1 )"
									
					Ejecuta(sSQLI,0)
				 
				} catch(err) {
					sResultado = -1
				}
			}
				
		break; 			
		case 8:	// registra la clasificacion del proyecto
 
			try {  

				var sSQLD = "DELETE FROM OrdenCompra_Clasificacion  "					   	   
					sSQLD += " WHERE Prov_ID = " + Prov_ID 
					sSQLD += " AND OC_ID = " + OC_ID   
					sSQLD += " AND Pry_ID = " + Pry_ID   
					sSQLD += " AND Com_ID = " + Com_ID 					
					
				Ejecuta(sSQLD,0)

			} catch(err) {
				sResultado = -1
			}					   
		
			if(Chkd == 1){
				try {  
	
					var sSQLI = "INSERT INTO OrdenCompra_Clasificacion (Prov_ID, OC_ID, Pry_ID, Dep_ID "
						sSQLI += " ,Com_ID , CC_ID, OCC_Usu_ID, OCC_Valor ) "
						sSQLI += " VALUES (" + Prov_ID + "," + OC_ID + ", " + Pry_ID + ", -1" 
						sSQLI += "," + Com_ID + ", -1, dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ") ,1 )"
									
					Ejecuta(sSQLI,0)
				 
				} catch(err) {
					sResultado = -1
				}
			}
				
		break; 	
		case 9:	// se actualiza la descripcion
		
			if(OC_Descripcion != "") {
				try {  
					var sSQLACT = "UPDATE OrdenCompra  "
						sSQLACT += " SET OC_Descripcion = '" + OC_Descripcion + "'"
                        sSQLACT += " , Prov_ID = " + Prov_ID
						//sSQLACT += " WHERE Prov_ID = " + Prov_ID 
						sSQLACT += " WHERE  OC_ID = " + OC_ID   
	
					Ejecuta(sSQLACT,0)
				 
				} catch(err) {
					sResultado = -1
				}		
			}
		break; 
}

%>
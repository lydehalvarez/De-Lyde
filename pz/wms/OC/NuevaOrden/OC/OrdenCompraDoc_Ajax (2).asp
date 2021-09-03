<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
							
	var Tarea = Parametro("Tarea",0)
	
	var Com_ID = Parametro("Com_ID",-1)	
	var Dep_ID = Parametro("Dep_ID",-1)	
	
	var OC_ID   = Parametro("OC_ID",-1)
	var OCPar_ID  = Parametro("OCPar_ID",-1)
	var OCParD_ID = Parametro("OCParD_ID",-1)
	var Usu_ID  = Parametro("Usu_ID",-1)     //entra como idunico -- iIDUsuario
    var OCPar_Titulo       = decodeURIComponent(Parametro("OCPar_Titulo",""))
	var OCPar_Descripcion  = decodeURIComponent(Parametro("OCPar_Descripcion",""))
	var OCParD_Descripcion = decodeURIComponent(Parametro("OCParD_Descripcion",""))	
	var OCParD_Sucursal    = decodeURIComponent(Parametro("OCParD_Sucursal",""))	
	var OCParD_Comentario  = decodeURIComponent(Parametro("OCParD_Comentario",""))
	var OCParD_UUIDtexto   = Parametro("OCParD_UUIDtexto","")	
 
    var OCParD_Fecha = Parametro("OCParD_Fecha","")
    var OCParD_Folio = Parametro("OCParD_Folio","")	
    var OCParD_Autorizado = Parametro("OCParD_Autorizado",0)

	var OCParD_Importe = Parametro("OCParD_Importe","0")
	var OCParD_Impuestos = Parametro("OCParD_Impuestos","0")
	var OCParD_Total = Parametro("OCParD_Total","0")

	var IDUnica = Parametro("IDUnica",-1)	

    //=============Autorizacion================
    //OC_ID, ComAR_ID, Pro_ID, ProF_ID, ProE_ID, Usu_ID, OCA_Comentario, OCA_Autorizo, ComAU_Nivel, ComAU_TipoCG53, OCA_FechaAutorizo   
    var ComAR_ID = Parametro("ComAR_ID",-1)
    var Pro_ID = Parametro("Pro_ID",-1) 
    var ProF_ID = Parametro("ProF_ID",-1)    
    var ProE_ID = Parametro("ProE_ID",-1)  
    
    var OCA_Comentario  = decodeURIComponent(Parametro("OCA_Comentario",""))
   //=============Autorizacion================
   
    var sResultado = ""
  
   switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
			bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
        case 1:
            if(OCPar_ID == -1) {
				try {
					
					var sCond  = " OC_ID = " + OC_ID  
					OCPar_ID = BuscaSoloUnDato("ISNULL(MAX(OCPar_ID) ,0) + 1","OrdenCompra_Partida",sCond ,0,0)
					
                    var sINSEV = " INSERT INTO OrdenCompra_Partida(OC_ID, OCPar_ID) "
					    sINSEV += "VALUES (" + OC_ID + "," + OCPar_ID + ")"

						Ejecuta(sINSEV,0)
 
						sResultado = OCPar_ID
 
                } catch(err) {				
					sResultado = -1
			    }	
			}
					
			try {
        
                var sSQL = "UPDATE OrdenCompra_Partida "
					sSQL += " SET OCPar_Titulo = '" + OCPar_Titulo + "'"
                    sSQL += ",OCPar_Descripcion = '" + OCPar_Descripcion + "'"
					
                    sSQL += " WHERE OC_ID = " + OC_ID  
					sSQL += " AND OCPar_ID = " + OCPar_ID
            // Response.Write("<br>" + sSQL)
                   Ejecuta(sSQL,0)

		        sResultado = OCPar_ID
				
			} catch(err) {
				sResultado = -1	
			}	

			Response.Write(sResultado) 

        break;
      case 2:
            
				//try {
	                if(OCParD_ID == -1) {				
   
                        var sCond  = " OC_ID = " + OC_ID 

                        OCParD_ID = BuscaSoloUnDato("ISNULL(MAX(OCParD_ID) ,0) + 1","OrdenCompra_Partida_Detalle",sCond ,0,0)

                        var sINSEV = " INSERT INTO OrdenCompra_Partida_Detalle(OC_ID, OCParD_ID) "
                            sINSEV += "VALUES (" + OC_ID + "," + OCParD_ID + ")"

                            Ejecuta(sINSEV,0)

                            sResultado = OCParD_ID
                    }
                /*
                } catch(err) {				
					sResultado = -1
			    }	*/
					
			//try {
        
                var sSQL = "UPDATE OrdenCompra_Partida_Detalle "
					sSQL += " SET OCParD_Sucursal = '" + OCParD_Sucursal + "'"
                    sSQL += ",OCParD_Descripcion = '" + OCParD_Descripcion + "'"
                    sSQL += ",OCParD_Folio = '" + OCParD_Folio + "'"	
                    sSQL += ",OCParD_Comentario = '" + OCParD_Comentario + "'"

                    sSQL += ",OCParD_UUIDtexto = '" + OCParD_UUIDtexto + "'"  

					sSQL += ",OCParD_Importe = " + OCParD_Importe
					sSQL += ",OCParD_Impuestos = " + OCParD_Impuestos	
					sSQL += ",OCParD_Total = " + OCParD_Total				
                    OCParD_Fecha = CambiaFormatoFecha(OCParD_Fecha,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
					if (OCParD_Fecha != '--') {
				    	sSQL += " ,OCParD_Fecha = '" + OCParD_Fecha + "'"
					}
                    sSQL += " WHERE OC_ID = " + OC_ID  
					sSQL += " AND OCParD_ID = " + OCParD_ID
       
                   Ejecuta(sSQL,0)

		        sResultado = OCParD_ID
				
			//} catch(err) {
			//	sResultado = -1	
			//}	

			Response.Write(sResultado) 

        break;
      case 3:
		   
		   	sResultado = "Error"
            if(OCParD_ID > -1) {
				try {
			
                    var sSQL = " DELETE FROM OrdenCompra_Partida_Detalle "
					    sSQL += " WHERE OC_ID = " + OC_ID 
						sSQL += " AND OCParD_ID = " + OCParD_ID
	
						Ejecuta(sSQL,0)
 
						sResultado = "Borrado"
 
                } catch(err) {				
					sResultado = "Error"
			    }	
			}

			Response.Write(sResultado) 

        break;
      case 4:
		   
		   	sResultado = ""
				//try {
			
                   var sSQL = "UPDATE OrdenCompra_Partida_Detalle "
					   sSQL += " SET OCParD_Autorizado = " + OCParD_Autorizado
                       sSQL += " WHERE OC_ID = " + OC_ID  
					   sSQL += " AND OCParD_ID = " + OCParD_ID

					Ejecuta(sSQL,0)
						
 				if(OCParD_Autorizado == 1){
					sResultado = "Autorizado"
				} else {
					sResultado = "Desutorizado"
				}
 
               // } catch(err) {				
				//	sResultado = "Error"
			   // }	
			

			Response.Write(sResultado) 

        break;
      case 5:
            //OC_ID, ComAR_ID, Pro_ID, ProF_ID, ProE_ID, Usu_ID, OCA_Comentario, OCA_Autorizo, ComAU_Nivel, ComAU_TipoCG53, OCA_FechaAutorizo
				//try {
	                if(ComAR_ID == -1) {				
   
                        var sCond  = " OC_ID = " + OC_ID 
                            ComAR_ID = BuscaSoloUnDato("ISNULL(MAX(ComAR_ID) ,0) + 1","OrdenCompra_Autorizacion",sCond ,0,0)

                        var sINSEV = " INSERT INTO OrdenCompra_Autorizacion(OC_ID, ComAR_ID) "
                            sINSEV += "VALUES (" + OC_ID + "," + ComAR_ID + ")"

                            Ejecuta(sINSEV,0)

                            sResultado = ComAR_ID
                    }
                /*
                } catch(err) {				
					sResultado = -1
			    }	*/
					
			//try {
        
                var sSQL = "UPDATE OrdenCompra_Autorizacion "
					sSQL += " SET OCA_Comentario = '" + OCA_Comentario + "'"
					sSQL += ",Pro_ID = " + Pro_ID
					sSQL += ",ProF_ID = " + ProF_ID	
					sSQL += ",ProE_ID = " + ProE_ID
                    sSQL += ",OCA_Autorizo = 1"
                    sSQL += ",Usu_ID =  dbo.fn_Usuario_DameIDUsuario(" + Usu_ID + ")"
                    sSQL += " WHERE OC_ID = " + OC_ID  
					sSQL += " AND ComAR_ID = " + ComAR_ID
       
                   Ejecuta(sSQL,0)

                //,dbo.fn_Usuario_DameUsuario(Usu_ID) fn_Usuario_DameUsuario
                var sCondUsuAut = " OC_ID = " + OC_ID + " AND ComAR_ID = " + ComAR_ID
                var sUsuAutorizo = BuscaSoloUnDato("dbo.fn_Usuario_DameUsuario("+ Usu_ID +")","OrdenCompra_Autorizacion",sCondUsuAut,-1,0)    
		        sResultado = ComAR_ID + "|" + sUsuAutorizo
				
			//} catch(err) {
			//	sResultado = -1	
			//}	

			Response.Write(sResultado) 

        break;
    
    
    
	}
	
	
%>    
    
    
    
    

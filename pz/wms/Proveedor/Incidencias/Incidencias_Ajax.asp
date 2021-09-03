<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
    var Tarea = Parametro("Tarea",-1)
    var InsO_ID = Parametro("InsO_ID",-1)
	var ID_Unico = Parametro("ID_Unico",-1)
	var InsO_ID = Parametro("InsO_ID",-1)
	var Ins_ID = Parametro("Ins_ID",-1)
    var Chkdo = Parametro("Chkdo",0)
	var InsCm_Observacion = decodeURIComponent(Parametro("InsCm_Observacion",""))
	var sResultado = ""
    var InsT_Padre = Parametro("InsT_Padre",0)
	var InsT_Nombre = decodeURIComponent(Parametro("InsT_Nombre",""))
	var InsT_Descripcion = decodeURIComponent(Parametro("InsT_Descripcion",""))
	var InsT_PrioridadCG33 = Parametro("InsT_PrioridadCG33",1)
	var InsT_SeveridadCG32 = Parametro("InsT_SeveridadCG32",1)
	var InsT_EstrellasCG33 = Parametro("InsT_EstrellasCG33",0)
	var InsT_PrioridadABC = Parametro("InsT_PrioridadABC",1)
	var InsT_Orden = Parametro("InsT_Orden",1)
    var InsT_MoScoWCG24 = Parametro("InsT_MoScoWCG24",4)
	var InsT_TallaCG25 = Parametro("InsT_TallaCG25",0)
	var InsT_SLAAtencion = Parametro("InsT_SLAAtencion",-1)
	var InsT_SLAResolucion = Parametro("InsT_SLAResolucion",-1)
    var InsT_Problema_For_ID = Parametro("InsT_Problema_For_ID",-1)
    var InsT_Comentarios_For_ID = Parametro("InsT_Comentarios_For_ID",-1)
	var InsT_TipoCG28 = Parametro("InsT_TipoCG28",4)
	var InsT_TipoMedicionCG29 = Parametro("InsT_TipoMedicionCG29",-1)
	var Ins_Titulo = decodeURIComponent(Parametro("Ins_Titulo",""))
	var Ins_Asunto = decodeURIComponent(Parametro("Ins_Asunto",""))
	var Ins_Descripcion = decodeURIComponent(Parametro("Ins_Descripcion",""))
	var Ins_Problema = decodeURIComponent(Parametro("Ins_Problema",""))
	var Ins_Causa = decodeURIComponent(Parametro("Ins_Causa",""))
    var TA_ID = Parametro("TA_ID",-1)
    var TA_Folio = Parametro("TA_Folio","")
    var OC_ID = Parametro("OC_ID",-1)
    var OV_ID = Parametro("OV_ID",-1)
    var OV_Folio = Parametro("OV_Folio","")
    var Cli_ID = Parametro("Cli_ID",-1)
    var CCgo_ID = Parametro("CCgo_ID",-1)
    var Prov_ID = Parametro("Prov_ID",-1)
    var Pt_ID = Parametro("Pt_ID",-1)
    var Tag_ID = Parametro("Tag_ID",-1)
    var Man_ID = Parametro("Man_ID",-1)
    var ManD_ID = Parametro("ManD_ID",-1)
    var Inv_ID = Parametro("Inv_ID",-1)
    var Pro_ID = Parametro("Pro_ID",-1)
    var Lot_ID = Parametro("Lot_ID",-1)
    var Alm_ID = Parametro("Alm_ID",-1)
    var Ins_Usu_Reporta = Parametro("Ins_Usu_Reporta",-1)
    var Ins_Usu_Recibe = Parametro("Ins_Usu_Recibe",-1)
    var Ins_Tarea_FechaAtendida = Parametro("Ins_Tarea_FechaAtendida","")
    var Ins_Tarea_FechaLIberada = Parametro("Ins_Tarea_FechaLIberada","")
    var Ins_Usu_Escalado = Parametro("Ins_Usu_Escalado",-1)
    var Ins_EstatusCG27 = Parametro("Estatus",1)
    var InsT_ID = Parametro("InsT_ID",-1)
    var InsCm_ID = Parametro("InsCm_ID",-1)
    var InsCm_Padre = Parametro("InsCm_Padre",0)
    var InsT_ID = Parametro("InsT_ID",-1)
    var Ins_Prioridad = Parametro("Ins_Prioridad",-1)
    var Ins_Severidad = Parametro("Ins_Severidad",-1)
    var Tag_Nombre = Parametro("Tag_Nombre","")
    var Tag_Descripcion = Parametro("Tag_Descripcion","")
    var Tag_Origen = Parametro("Tag_Origen",-1)
    var Tag_Publica = Parametro("Tag_Publica",-1)
    var IDUsuario = Parametro("Usuario", -1)  
	var Asignado = Parametro("Asignado", -1)  
	var Ins_GrupoID = Parametro("Ins_GrupoID", -1)
	var Ins_TipoInvolucradoCG26 = Parametro("Ins_TipoInvolucradoCG26", -1)
	var T_Involucrado = Parametro("T_Involucrado", -1)
	var Involucrado = Parametro("Involucrado", -1)

    switch (parseInt(Tarea)) {
         case 1:
            try {	

                var sSQL = "DELETE FROM Incidencia_Usuario "
                    sSQL += " WHERE InsO_ID = " + InsO_ID 
                    sSQL += " and ID_Unico = " + ID_Unico

                Ejecuta(sSQL,0)		

                sResultado = "OK"		
            } catch(err) {
                sResultado = "falla"	
            }

            sResultado = "OK"               
            
            if(Chkdo == 1){
                try {	

                    var sSQL = "INSERT INTO Incidencia_Usuario(InsO_ID, InU_IDUnico) " 
                        sSQL += " VALUES (" + InsO_ID + "," + ID_Unico + ")"					

                    Ejecuta(sSQL,0)		

                    sResultado = "OK"		
                } catch(err) {
                    sResultado = "falla"	
                }                
            }

         break;

		case 2:
		         var sSQL = "INSERT INTO Incidencia_Comentario(Ins_ID, InsCm_Padre,"
				 	if(Asignado > -1){
					  sSQL += "InsCm_AsignadoA,"
					}
				  	  sSQL += " InsCm_Observacion, InsCm_Autor_IDU) " 
                      sSQL += " VALUES (" + Ins_ID + "," + InsCm_Padre 
						if(Asignado > -1){
						 sSQL += "," + Asignado
						}
						sSQL += ", '"+InsCm_Observacion +"', " + IDUsuario +")"					
					
                    Ejecuta(sSQL,0)		
					
					
					if(Asignado > -1){
						var sSQL = "UPDATE Incidencia SET Ins_Usu_Escalado = "+Asignado
								+ " WHERE Ins_ID="+Ins_ID
	
                    	Ejecuta(sSQL,0)		
					}
		break;
		
				case 3:
				            var InsT_ID = SiguienteID("InsT_ID","Incidencia_Tipo","",0)

		         var sSQL = " INSERT INTO Incidencia_Tipo(InsT_Padre, InsT_ID, InsT_Nombre, InsT_Descripcion, InsT_PrioridadCG33, InsT_SeveridadCG32, InsT_EstrellasCG33, "						
				 				+ " InsT_PrioridadABC, InsT_Orden, InsT_MoScoWCG24, InsT_TallaCG25, InsT_SLAAtencion, "
                         		+ " InsT_SLAResolucion, InsT_Problema_For_ID, InsT_Comentarios_For_ID, InsT_TipoCG28, InsT_TipoMedicionCG29) " 
                        		+ " VALUES (" + InsT_Padre + "," + InsT_ID + ",'" + InsT_Nombre + "','" + InsT_Descripcion + "'," + InsT_PrioridadCG33 + "," + InsT_SeveridadCG32 
								+ "," + InsT_EstrellasCG33 + "," + InsT_PrioridadABC + ","+ "" + InsT_Orden + "," + InsT_MoScoWCG24 + "," + InsT_TallaCG25 + "," + InsT_SLAAtencion
							    + "," + InsT_SLAResolucion + "," + InsT_Problema_For_ID + "," + InsT_Comentarios_For_ID + "," + InsT_TipoCG28 + "," + InsT_TipoMedicionCG29 +")"					
				
                    Ejecuta(sSQL,0)		
			
		break;
	
		case 4:
		
				
				if(TA_Folio !=""){
				sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_Folio = '" + TA_Folio + "'"	
				var rsTA = AbreTabla(sSQL,1,0)
					if(!rsTA.EOF){
						TA_ID = rsTA.Fields.Item("TA_ID").Value
					}else{
						sResultado = 0
					}
            	}
				
				if(OV_Folio !=""){
				sSQL = "SELECT OV_ID FROM Orden_Venta WHERE OV_Folio = '" + OV_Folio + "'"	
				var rsOV = AbreTabla(sSQL,1,0)
					if(!rsOV.EOF){
						OV_ID = rsOV.Fields.Item("OV_ID").Value
					}else{
					sResultado = 0
					}
            	}
				if((OV_ID>-1||TA_ID>-1)||(OV_Folio =="" && TA_Folio =="")){
				            var Ins_ID = SiguienteID("Ins_ID","Incidencia","",0)

		         var sSQL = " INSERT INTO Incidencia (Ins_ID, Ins_Titulo, Ins_Asunto, Ins_Descripcion, Ins_Problema, Ins_Causa, TA_ID, OC_ID, OV_ID, Cli_ID, "
				 				+ " CCgo_ID, Prov_ID, Pt_ID, Tag_ID, Man_ID, ManD_ID, Inv_ID, Lot_ID, Ins_Usu_Reporta, Ins_Usu_Recibe, "
								+ "  Ins_Usu_Escalado, Ins_EstatusCG27, InsT_ID, InsO_ID, InsCm_ID, Ins_Prioridad, Ins_Severidad, Ins_PuedeVer_ProveedorID) " 
                        		+ " VALUES (" + Ins_ID + ",'" + Ins_Titulo + "','" + Ins_Asunto + "','" + Ins_Descripcion + "','" + Ins_Problema + "','" + Ins_Causa 
								+ "'," + TA_ID + "," + OC_ID + ","+ OV_ID + "," + Cli_ID + "," + CCgo_ID + "," + Prov_ID
							    + "," + Pt_ID + "," + Tag_ID + "," + Man_ID + "," + ManD_ID +"," + Inv_ID + "," + Lot_ID + "," + Ins_Usu_Reporta + "," + Ins_Usu_Recibe
								+ "," + Ins_Usu_Escalado + "," + Ins_EstatusCG27 
								+ "," + InsT_ID + "," + InsO_ID + "," + InsCm_ID + "," + Ins_Prioridad +"," + Ins_Severidad + ", "+Prov_ID+")"					
             
				if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result
				}
		break;
		case 5:
				            Tag_ID = SiguienteID("Tag_ID","TAG","",0)

		         var sSQL = " INSERT INTO TAG(Tag_ID, Tag_Nombre , Tag_UsuarioPropietario)"
                        		+ " VALUES (" + Tag_ID + ",'" + Tag_Nombre + "'," + ID_Unico + ")"
                  if(Ejecuta(sSQL,0)){
				result = 1
		
				}else{
				result = 0
				}
			
			sResultado  = '{"result":'+result+',"tagid":'+Tag_ID+'}'
			
			
		break;
		case 6:

		         var sSQL = " UPDATE TAG SET  Tag_Descripcion='"+Tag_Descripcion+"' , Tag_Publica ="+Tag_Publica+" , Tag_OrigenCG252="+Tag_Origen
                        		+ " WHERE Tag_ID="+Tag_ID
					
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result

		break;
		
		case 7:
        var sSQL= "DELETE FROM Tag_Usuarios WHERE Tag_ID = "+ Tag_ID
		if(IDUsuario > -1){
			sSQL+=" and Usu_ID = "+ IDUsuario
		}
			
		Ejecuta(sSQL,0)
		break;
		
		case 8:
		if(TA_ID==-1 && OV_ID ==-1 && Alm_ID ==-1 && Inv_ID==-1){
						result = "<p style='color:red;'>No es posible relacionar tags desde esta ventana</p>"
	
		}else{
			     var sSQL = " INSERT INTO TAG_Marcados(Tag_ID, TA_ID, OV_ID, Alm_ID, Inv_ID, Pro_ID)"
                        		+ " VALUES (" + Tag_ID + "," + TA_ID + "," + OV_ID + ", " + Alm_ID + "," + Inv_ID + ", " + Pro_ID+ ")"
						
                  if(Ejecuta(sSQL,0)){
					result= ""
				}else{
				result = "<p style='color:red;'>Error al relacionar tag</p>"
				}
		}
							sResultado =result

		break;
			case 9:
        var sSQL= "DELETE FROM Tag_Marcados WHERE Tag_ID = "+ Tag_ID
					  + " AND TA_ID = " + TA_ID + " AND OV_ID=" + OV_ID + " AND Alm_ID = " + Alm_ID + " AND Inv_ID=" + Inv_ID
		Ejecuta(sSQL,0)
		break;
		
				case 10:
		         var sSQL = "INSERT INTO Tag_Usuarios(Tag_ID, Usu_ID) " 
                        sSQL += " VALUES (" + Tag_ID + "," + IDUsuario+ ")"					
                    Ejecuta(sSQL,0)		

		
		
		break;
			case 11:
// ESTO ESTA EN UN TRIGGER
	//			var sSQL = " INSERT INTO Incidencia_HistoriaLectura (Ins_ID, InsH_Leyo_UID)"
//								+ "VALUES ("+Ins_ID+", "+ IDUsuario+")"
//					
//						Ejecuta(sSQL,0)
//								
		         var sSQL = " UPDATE Incidencia SET  Ins_UltimoLeyo_UID="+IDUsuario + ", Ins_UltimoLeyoFecha = getdate()"
                        		+ " WHERE Ins_ID="+Ins_ID
				//Response.Write(sSQL)
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result

		break;
				case 12:

		var sSQL = " UPDATE Incidencia_Tipo SET "
						if(InsT_Padre > 0){
							sSQL +=" InsT_Padre = "+InsT_Padre+", "
						}
				sSQL += " InsT_Nombre = '" + InsT_Nombre + "' , InsT_Descripcion= '" + InsT_Descripcion + "', "				 
				sSQL += " InsT_PrioridadCG33=" + InsT_PrioridadCG33 + ", InsT_SeveridadCG32=" + InsT_SeveridadCG32 + ", InsT_EstrellasCG33= "+ InsT_EstrellasCG33 		
				sSQL += ", InsT_PrioridadABC=" + InsT_PrioridadABC + ", InsT_Orden= " + InsT_Orden + ", InsT_MoScoWCG24=" + InsT_MoScoWCG24
				sSQL += ", InsT_TallaCG25="+ InsT_TallaCG25 + ", InsT_SLAAtencion=" + InsT_SLAAtencion
				sSQL += ", InsT_SLAResolucion=" + InsT_SLAResolucion + ", InsT_Problema_For_ID=" + InsT_Problema_For_ID 
				sSQL += ", InsT_Comentarios_For_ID=" + InsT_Comentarios_For_ID + ", InsT_TipoCG28=" + InsT_TipoCG28 + ", InsT_TipoMedicionCG29=" + InsT_TipoMedicionCG29 										
				sSQL += " WHERE InsT_ID=" + InsT_ID               	
						Response.Write(sSQL)
                    Ejecuta(sSQL,0)		
			
		break;
			case 13:
			var FechaLiberado = "''"
			if(Ins_EstatusCG27==4){
			FechaLiberado = "getdate()"	
			}
		         var sSQL = " UPDATE Incidencia SET  Ins_EstatusCG27="+Ins_EstatusCG27 
				 				+ " , Ins_Tarea_FechaLiberada = " + FechaLiberado
                        		+ " WHERE Ins_ID="+Ins_ID
				//Response.Write(sSQL)
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
			sResultado =result

		break;
				case 14:
				  
		         var sSQL = "INSERT INTO Incidencia_Involucrados(Ins_ID, Ins_GrupoID, Ins_UsuarioID, Ins_TipoInvolucradoCG26) " 
                        sSQL += " VALUES (" + Ins_ID + "," + Ins_GrupoID+ "," + IDUsuario + "," + Ins_TipoInvolucradoCG26+")"					
        
						if(Ejecuta(sSQL,0)){
		
						result = 1
				
						}else{
						result = 0
						}
					
					sResultado  = '{"result":'+result+'}'
		
		
		break;
		case 15:
		
		         var sSQL = " UPDATE Incidencia_Involucrados SET Ins_TipoInvolucradoCG26="+Ins_TipoInvolucradoCG26 
				 			if(T_Involucrado==1){
				 				sSQL += "WHERE  Ins_GrupoID = " + Involucrado
							}if(T_Involucrado==2){
				 				sSQL += "WHERE  Ins_UsuarioID = " + Involucrado
							}
        				sSQL += " AND Ins_ID= "+ Ins_ID
				
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
				sResultado  = '{"result":'+result+'}'

		break;
		case 16:
		
		         var sSQL = " DELETE FROM Incidencia_Involucrados " 
				 			if(T_Involucrado==1){
				 				sSQL += "WHERE  Ins_GrupoID = " + Involucrado
							}if(T_Involucrado==2){
				 				sSQL += "WHERE  Ins_UsuarioID = " + Involucrado
							}
        				sSQL += " AND Ins_ID= "+ Ins_ID
				
                  if(Ejecuta(sSQL,0)){

				result = 1
		
				}else{
				result = 0
				}
			
				sResultado  = '{"result":'+result+'}'

		break;
		 }
    Response.Write(sResultado)
			
%>

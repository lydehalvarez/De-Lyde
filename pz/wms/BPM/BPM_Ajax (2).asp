<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea = Parametro("Tarea",0)
var BPM_Pro_ID = Parametro("Pro_ID",-1)
var BPM_Flujo = Parametro("Flujo",-1)
var BPM_Estatus = Parametro("Estatus",-1)

var ProF_ID = Parametro("ProF_ID",1)
var ProD_ID = Parametro("ProD_ID",1)

var Cli_ID = Parametro("Cli_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)  
var TA_ID = Parametro("TA_ID",-1)

var Emp_ID = Parametro("Emp_ID",1)
var EVtc_ID = Parametro("EVtc_ID",-1)
var ERmb_ID = Parametro("ERmb_ID",-1)

var Usu_ID = Parametro("Usu_ID",-1)
var IDUnica = Parametro("IDUnica",-1)

var sResultado = ""

switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
			bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		case 1:	//Cambio de estatus de una orden de servicio
			try {  
   
               if(CliOC_ID > 0){
				var sSQLACT = "UPDATE Cliente_OrdenCompra  "
				    sSQLACT += " SET BPM_Estatus = d.ProD_ConEstatus_ProE_ID "	
					sSQLACT += " , BPM_Flujo = d.ProD_EnviarA_ProF_ID " 	
				    sSQLACT += " , CliOC_EstatusCG52 = e.ProE_EstatusSTD " 
				    sSQLACT += " , BPM_Cambio = getdate() "
					sSQLACT += " , BPM_AlrID = ProD_TieneAlerta "
					sSQLACT += " , BPM_UsuID = " + IDUnica 
				    sSQLACT += " FROM BPM_Proceso_Flujo_Decisiones d, BPM_Proceso_Estatus e "
					sSQLACT += " WHERE d.Pro_ID = BPM_Pro_ID "
					sSQLACT += " AND e.Pro_ID = d.Pro_ID " 					
					sSQLACT += " AND d.ProF_ID = BPM_Flujo "
					sSQLACT += " AND e.ProE_ID = d.ProD_ConEstatus_ProE_ID "
					sSQLACT += " AND Cliente_OrdenCompra.Cli_ID = " + Cli_ID 
                    sSQLACT += " AND Cliente_OrdenCompra.CliOC_ID = " + CliOC_ID 
					sSQLACT += " AND d.ProD_ID = " + ProD_ID
				 }
                 if(TA_ID > 0)   {
                    var sSQLACT = "UPDATE TransferenciaAlmacen  "
                        sSQLACT += " SET BPM_Estatus = d.ProD_ConEstatus_ProE_ID "	
                        sSQLACT += " , BPM_Flujo = d.ProD_EnviarA_ProF_ID " 	
                        sSQLACT += " , TA_EstatusCG52 = e.ProE_EstatusSTD " 
                        sSQLACT += " , BPM_Cambio = getdate() "
                        sSQLACT += " , BPM_AlrID = ProD_TieneAlerta "
                        sSQLACT += " , BPM_UsuID = " + IDUnica 
                        sSQLACT += " FROM BPM_Proceso_Flujo_Decisiones d, BPM_Proceso_Estatus e "
                        sSQLACT += " WHERE d.Pro_ID = BPM_Pro_ID "
                        sSQLACT += " AND e.Pro_ID = d.Pro_ID " 					
                        sSQLACT += " AND d.ProF_ID = BPM_Flujo "
                        sSQLACT += " AND e.ProE_ID = d.ProD_ConEstatus_ProE_ID "
                        sSQLACT += " AND TransferenciaAlmacen.Cli_ID = " + Cli_ID 
                        sSQLACT += " AND TransferenciaAlmacen.CliOC_ID = " + CliOC_ID 
                        sSQLACT += " AND d.ProD_ID = " + ProD_ID
                 }
   //Response.Write(sSQLACT)
				 Ejecuta(sSQLACT,0)
				 
				 sResultado = 1
				
			} catch(err) {
				sResultado = -1
			}	
			Response.Write(sResultado)
			break; 
		case 4:	//Carga estatus de un viatico			
			
			break; 
		}


%>
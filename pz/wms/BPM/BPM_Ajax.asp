<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea = Parametro("Tarea",0)
var BPM_Pro_ID = Parametro("Pro_ID",-1)
var BPM_Flujo = Parametro("Flujo",-1)
var BPM_Estatus = Parametro("Estatus",-1)

var ProF_ID = Parametro("ProF_ID",1)
var ProD_ID = Parametro("ProD_ID",1)

var OV_ID = Parametro("OV_ID",1)

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
				var sSQLACT = "UPDATE Orden_Venta  "
				    sSQLACT += " SET OV_BPM_Estatus = d.ProD_ConEstatus_ProE_ID "	
					sSQLACT += " , OV_BPM_Flujo = d.ProD_EnviarA_ProF_ID " 	
				    sSQLACT += " , OV_EstatusCG51 = e.ProE_EstatusSTD " 
				    sSQLACT += " , OV_BPM_Cambio = getdate() "
					sSQLACT += " , OV_BPM_AlrID = ProD_TieneAlerta "
					sSQLACT += " , OV_BPM_UsuID = " + IDUnica 
				    sSQLACT += " FROM BPM_Proceso_Flujo_Decisiones d, BPM_Proceso_Estatus e "
					sSQLACT += " WHERE d.Pro_ID = OV_BPM_Pro_ID "
					sSQLACT += " AND e.Pro_ID = d.Pro_ID " 					
					sSQLACT += " AND d.ProF_ID = OV_BPM_Flujo "
					sSQLACT += " AND e.ProE_ID = d.ProD_ConEstatus_ProE_ID "
					sSQLACT += " AND Orden_Venta.OV_ID = " + OV_ID 
					sSQLACT += " AND d.ProD_ID = " + ProD_ID
				 
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
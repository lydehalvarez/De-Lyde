<!--#include file="../../Includes/iqon.asp" -->

<%

var sWgSQL = "select mw.* "
	sWgSQL += " from Menu_Widget mw "
	sWgSQL += " where mw.Sys_ID = 1 "  
	sWgSQL += " and mw.Mnu_ID = 61 " 
	

Response.Write("<br> sql = " + sWgSQL)
	try {		
		 var rsWG = AbreTabla(sWgSQL,1,2)
		 Response.Write("<br> si lo abrio")
			if (!rsWG.EOF) {
				iEsPanza  = rsWG.Fields.Item("MW_EsPanza").Value
Response.Write("<br> iEsPanza = " + iEsPanza)
Response.Write("<br> comodinArchivoAjax = " + rsWG.Fields.Item("MW_Ejecutable").Value)
				comodinArchivoAjax = "" + rsWG.Fields.Item("MW_Ejecutable").Value 
Response.Write("<br> comodinNombreDiv = " + rsWG.Fields.Item("WG_NombreDIV").Value)
				comodinNombreDiv = "" + rsWG.Fields.Item("WG_NombreDIV").Value 

				if (FiltraVacios(rsWG.Fields.Item("MN_Estilos").Value) != "") {
						sCargaEstilos += CargaArchivo("" +rsWG.Fields.Item("MN_Estilos").Value)
						Response.Write("<br> sCargaEstilos = " + sCargaEstilos)                                    
				} 
				if (FiltraVacios(rsWG.Fields.Item("MW_PZJS").Value) != "") {
					Response.Write("<br> sCargaIncludesDeJavaScript = " +  rsWG.Fields.Item("MW_PZJS").Value)
					sCargaIncludesDeJavaScript += CargaArchivo("" + rsWG.Fields.Item("MW_PZJS").Value)
					
				}
				if (FiltraVacios(rsWG.Fields.Item("MW_PZJQ").Value) != "") {
					sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("MW_PZJQ").Value)
					Response.Write("<br> sCodigoParaELJQuery = " + sCodigoParaELJQuery)
				}		

			}
		
		rsWG.Close()
			 
	} catch(err) {
		bOcurrioError = true
		AgregaDebug("Error en el plugin de Cargapanzas","================== ERROR ====================================")

		AgregaDebug("Fallo el plugin ",rsWG.Fields.Item("Mnu_ID").Value)
		AgregaDebug("Error description ",err.description)
		AgregaDebug("Error number ",err.number)
		AgregaDebug("Error message ",err.message)	  
		AgregaDebug("Fin Error en Cargapanzas","===============================================================")
	}
	
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Documento sin título</title>
</head>

<body>
</body>
</html>

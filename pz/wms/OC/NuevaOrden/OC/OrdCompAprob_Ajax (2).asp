<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
var bIQ4Web = false
var Tarea = Parametro("Tarea",0)
var iProvID = Parametro("Prov_ID",-1)

var OC_ID = Parametro("OC_ID",-1)
var iOCID = Parametro("OC_ID",-1)   
var iSerID = Parametro("Ser_ID",-1)
   
var sCampo = Parametro("Campo","")
var sValor = decodeURIComponent(Parametro("Valor",""))

var iEsFecha = Parametro("EsFecha",0)
if (iEsFecha == 1) {
	sValor = CambiaFormatoFecha(sValor,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
}
   
var sCond = ""
var sSQL = ""
	sCond = " Prov_ID = " + iProvID
   
var sCondPS = ""
    sCondPS = " OC_ID = " + OC_ID + " AND Prov_ID = " + iProvID

var sCondOC = ""   
    sCondOC = " OC_ID = " + OC_ID
   
var sResultado = 1

	switch (parseInt(Tarea)) {
			
        //OrdenCompra    
        case 1:
            
			var iRegExiste = BuscaSoloUnDato("ISNULL(COUNT(*),0)","OrdenCompra",sCondOC,0,0)
				//Response.Write(iRegExiste)
				
				try {

					if (parseInt(iRegExiste) == 0) {
						var sCondOCID = "" 
						iOCID = BuscaSoloUnDato("ISNULL((MAX(OC_ID)),0) + 1","OrdenCompra",sCondOCID,-1,0)
						
					var sInsReg = " INSERT OrdenCompra"
						sInsReg += " (OC_ID, Prov_ID, " + sCampo + ") "
						sInsReg += " VALUES (" + iOCID + "," + iProvID + ", '" + sValor + "')"
						
						if (bIQ4Web) { Response.Write("sInsReg&nbsp;" + sInsReg + "<br />") }
						
						Ejecuta(sInsReg,0)
						
						sResultado = 1 + "|" + iOCID
   
					}
					
					if(parseInt(iRegExiste) > 0) {
    
						sSQL = "UPDATE OrdenCompra SET " + sCampo + "='" + sValor + "' WHERE " + sCondOC
    
						if (bIQ4Web) { Response.Write("sSQL&nbsp;" + sSQL + "<br />") }
						
						Ejecuta(sSQL,0)

						sResultado = 1 + "|" + iOCID 
					}
					
				} catch(err) {
						sResultado = -1
				}

			Response.Write(sResultado)    
    
    
        break;
    

    
    }

%>   
   
   
   

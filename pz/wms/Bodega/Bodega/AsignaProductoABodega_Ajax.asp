<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
  var bIQon4Web = false 
  var Tarea  = Parametro("Tarea",0)
   
  var iProID = Parametro("Pro_ID",-1)
  var iBodID = Parametro("Bod_ID",-1)
  var Poner  = Parametro("Poner",-1)
  var Usu_ID  = Parametro("Usu_ID",-1)

  var jDatos = "{}"
  var jError = "{}"
  var jResultado = 0
  var sResultado = ""
   
   /*
  Bodega_Producto
  Bod_ID, Pro_ID
  */  
   
	switch (parseInt(Tarea)) {
   
		case 1:
   
			try {
   
				var sSQL = " DELETE FROM Bodega_Producto "
					  sSQL += " WHERE Pro_ID = " + iProID
					  sSQL += " AND Bod_ID = " + iBodID
   
	          if(bIQon4Web) { Response.Write(sSQL) }
   
					  Ejecuta(sSQL,0)
   
            jDatos = '{"Pro_ID":'+iProID
                   + ',"message":"ID borrado correctamente"}'
   
					  jResultado = 1
					
					if (Poner == 1 ) {
   
				var sSQL = " INSERT INTO Bodega_Producto(Bod_ID, Pro_ID) "
            sSQL  += " VALUES ( " + iBodID + "," + iProID + " )"
   
							  Ejecuta(sSQL,0)

                jDatos = '{"Pro_ID":'+iProID
                       + ',"message":"ID agregado correctamente"}' 
							  jResultado = 2
   
					}
			} 
			catch(err) {
          jError = '{"name":"'+err.name+'"'
                + ',"message":"'+err.message+'"}'
   
              jResultado = 0
			}
   
   
			break;

	}

  var jsonTAG = '{'
      + '"Resultado":' + jResultado
      + ',"Datos":' + jDatos 
      + ',"Error":' + jError      
      + ',"Accion":' + Tarea
      + ',"Query":"' + sSQL + '"'
    + '} '

  Response.Write(jsonTAG)   
  
   
   
%>


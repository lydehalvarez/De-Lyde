<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var bIQ4Web = false   

  var Tarea = Parametro("Tarea",0)

  if(bIQ4Web){ Response.Write("Tarea: " + Tarea ) }  

  var iTipoBusq = Parametro("TipoBusqueda",1)
  var sInvSerie = Parametro("Inv_Serie","")
  var iUbi_ID = Parametro("Ubi_ID",-1)  
  var iPt_ID = Parametro("Pt_ID",-1)
  var iPro_ID = Parametro("Pro_ID",-1)    

  //Manejo de variables de resultados 
  var jDatos = "{}"
  var jError = "{}"
  var jResultado = 0
  var sResultado = ""   

  switch (parseInt(Tarea)) {  
   
    case 1:  
    
      var sResTmp = ""
      var sSQL = ""

      try {

        var sSQL = "EXEC SPR_Inventario_CargaInicial_XSerieoRFID "
                    //+ "@Opcion = 1 "
                    + " @TipoBusqueda = " + iTipoBusq
                    + " @UbiID = " + iUbi_ID
                    + " @PtID = " + iPt_ID
                    + " @ProID = " + iPro_ID
                    + ",@Inv_Serie = '" + sInvSerie + "'"

        var rsGral = AbreTabla(sSQL,1,0)

        if(!rsGral.EOF){
          jDatos = rsGral.Fields.Item(0).Value

        }

        rsGral.Close()

        jResultado = 1

      } 
      catch(err) {

        jError = '{"name":"'+err.name+'"'
               + ',"message":"'+err.message+'"}'

        jResultado = 0

      }      
   
    break;
   
  }

  //Resultado en forma general
  if(sResultado == ""){

    var jsonTAG = '{'
        + '"Resultado":' + jResultado
        + ',"Datos":' + jDatos 
        + ',"Error":' + jError      
        + ',"Tarea":' + Tarea
        + ',"Query":"' + sSQL + '"'
      + '} '

    Response.Write(jsonTAG)
   
  } else {
   
    Response.Write(sResultado)  
   
  }   
   
   
%>   

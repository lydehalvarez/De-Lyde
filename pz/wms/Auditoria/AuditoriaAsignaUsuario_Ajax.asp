<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

  var bIQon4Web = false 
  var Tarea  = Parametro("Tarea",0)
   //Aud_ID:ijsAudID,Cli_ID:ijsCliID,Cli_Usu_ID:iValor,Poner:Poner
  var iAudID = Parametro("Aud_ID",-1)
  var iCliID = Parametro("Cli_ID",-1)
  var iCliUsuID = Parametro("Cli_Usu_ID",-1)
  var iUsuID = Parametro("Usu_ID",-1) 
  var Poner  = Parametro("Poner",-1) 
   
  var jDatos = "{}"
  var jError = "{}"
  var jResultado = 0
  var sResultado = ""  
     
  /*
  Auditoria_Usuario
  Aud_ID, Usu_ID, Cli_ID, Cli_Usu_ID, AudU_TipoSupAud
  */    
   
  switch (parseInt(Tarea)) {
   
    case 1:

      try {

        var sSQL = " DELETE FROM Auditorias_Auditores "
            sSQL += " WHERE Aud_ID = " + iAudID
            sSQL += " AND Cli_ID = " + iCliID
            sSQL += " AND Cli_Usu_ID = " + iCliUsuID

            if(bIQon4Web) { Response.Write(sSQL) }

            Ejecuta(sSQL,0)

            jDatos = '{"Cli_Usu_ID":'+iCliUsuID
                   + ',"message":"ID borrado correctamente"}'

            jResultado = 1

          if (Poner == 1 ) {

        var sSQL = " INSERT INTO Auditorias_Auditores(Aud_ID, Cli_ID, Cli_Usu_ID, Aud_Externo) "
            sSQL  += " VALUES ( " + iAudID + ","+ iCliID + "," + iCliUsuID + ",1)"

                Ejecuta(sSQL,0)

                jDatos = '{"Cli_Usu_ID":'+iCliUsuID
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

    case 2:

      try {
        
        var sCondCliUsu = " Aud_ID = " + iAudID + " AND Cli_ID = " + iCliID
            sCondCliUsu += " AND Cli_Usu_ID = " + iCliUsuID
        var iExisteCliUsuID = BuscaSoloUnDato("COUNT(*)","Auditorias_Auditores",sCondCliUsu,0,0)
        //Response.Write("Existe: " + iExisteCliUsuID + " | Poner: " + Poner)
        if(iExisteCliUsuID == 0){
          
          var sSQL = " DELETE FROM Auditorias_Auditores "
              sSQL += " WHERE Aud_ID = " + iAudID
              sSQL += " AND Cli_ID = " + iCliID
              sSQL += " AND Cli_Usu_ID = " + iCliUsuID

              if(bIQon4Web) { Response.Write(sSQL) }

              Ejecuta(sSQL,0)

              jDatos = '{"Cli_Usu_ID":'+iCliUsuID
                     + ',"message":"ID borrado correctamente"}'

              jResultado = 1
          }
          
          if (Poner == 1 && iExisteCliUsuID == 0) {

            var sSQL = " INSERT INTO Auditorias_Auditores(Aud_ID, Cli_ID, Cli_Usu_ID, Aud_TipoSupAud, Aud_Externo) "
                sSQL  += " VALUES ( " + iAudID + ","+ iCliID + "," + iCliUsuID + ",1,1)"

                Ejecuta(sSQL,0)

                jDatos = '{"Cli_Usu_ID":'+iCliUsuID
                       + ',"message":"ID agregado correctamente y será supervisor"}'
            
                jResultado = 2

          } else {
                      
            var sSQL = " UPDATE Auditorias_Auditores "
                sSQL += " SET Aud_TipoSupAud = " + Poner
                sSQL += " , Aud_Externo = " + Poner
                sSQL += " WHERE Aud_ID = "+iAudID
                sSQL += " AND Cli_ID = "+iCliID
                sSQL += " AND Cli_Usu_ID = "+iCliUsuID
                
                Ejecuta(sSQL,0)
            
                jDatos = '{"Cli_Usu_ID":'+iCliUsuID
                       + ',"message":"Deja de ser supervisor"}'
            
                jResultado = 2
            
          }
            
            
            
      } 
      catch(err) {
          jError = '{"name":"'+err.name+'"'
                + ',"message":"'+err.message+'"}'

              jResultado = 0
      }

    break;
   
    case 3:

      try {

        var sSQL = " DELETE FROM Auditorias_Auditores "
            sSQL += " WHERE Aud_ID = " + iAudID
            sSQL += " AND Usu_ID = " + iUsuID

            if(bIQon4Web) { Response.Write(sSQL) }

            Ejecuta(sSQL,0)

            jDatos = '{"Usu_ID":'+iUsuID
                   + ',"message":"ID borrado correctamente"}'

            jResultado = 1

          if (Poner == 1 ) {

        var sSQL = " INSERT INTO Auditorias_Auditores(Aud_ID, Usu_ID) "
            sSQL  += " VALUES ( " + iAudID + "," + iUsuID + " )"

                Ejecuta(sSQL,0)

                jDatos = '{"Usu_ID":'+iUsuID
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
   
    case 4:

      try {

        var sCondCliUsu = " Aud_ID = " + iAudID 
            sCondCliUsu += " AND Usu_ID = " + iUsuID
        var iExisteUsuID = BuscaSoloUnDato("COUNT(*)","Auditorias_Auditores",sCondCliUsu,0,0)
        
        //Response.Write("Existe: " + iExisteUsuID + " | Poner: " + Poner)
        if(iExisteUsuID == 0){
          
          var sSQL = " DELETE FROM Auditorias_Auditores "
              sSQL += " WHERE Aud_ID = " + iAudID
              sSQL += " AND Usu_ID = " + iUsuID

              if(bIQon4Web) { Response.Write(sSQL) }

              Ejecuta(sSQL,0)

              jDatos = '{"Usu_ID":'+iUsuID
                     + ',"message":"ID borrado correctamente"}'

              jResultado = 1

         }
              
         if (Poner == 1 && iExisteUsuID == 0) {

            var sSQL = " INSERT INTO Auditorias_Auditores(Aud_ID, Usu_ID, Aud_TipoSupAud) "
                sSQL  += " VALUES ( " + iAudID + "," + iUsuID + ", 1)"

                    Ejecuta(sSQL,0)

                    jDatos = '{"Usu_ID":'+iUsuID
                           + ',"message":"ID agregado correctamente y será supervisor"}' 
                    jResultado = 2

        } else {
                      
            var sSQL = " UPDATE Auditorias_Auditores "
                sSQL += " SET Aud_TipoSupAud = " + Poner
                sSQL += " WHERE Aud_ID = "+iAudID
                sSQL += " AND Usu_ID = "+iUsuID
                
                Ejecuta(sSQL,0)
            
                jDatos = '{"Usu_ID":'+iCliUsuID
                       + ',"message":"Deja de ser supervisor"}'
            
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
  
  
  

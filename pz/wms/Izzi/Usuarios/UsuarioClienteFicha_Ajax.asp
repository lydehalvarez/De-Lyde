<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

    var ibQ4Web = false
    var Tarea = Parametro("Tarea",0)

    var iCliID = Parametro("Cli_ID",-1)

    var iCliUsuID = Parametro("Cli_Usu_ID",-1) 

    if (ibQ4Web) { Response.Write("Tarea: "+Tarea+" Cli_ID:&nbsp;"+iCliID + " | Cli_Usu_ID:" + iCliUsuID+"<br>") }   

    var sUsu_Nombre = utf8_decode(Parametro("Usu_Nombre",""))

    var sUsu_Usuario = utf8_decode(Parametro("Usu_Usuario",""))
    var sUsu_Descripcion = utf8_decode(Parametro("Usu_Descripcion",""))
    var sUsu_Email = utf8_decode(Parametro("Usu_Email",""))
    var iUsu_Grupo = Parametro("Usu_Grupo",-1)   
    var iUsu_TipoUsuarioCG61 = Parametro("Usu_TipoUsuarioCG61",-1)  
    var iUsu_Estatus = Parametro("Usu_Estatus",0) 
    var iUsu_Padre = Parametro("Usu_Padre",-1) 

      if (ibQ4Web) { Response.Write("Entramos...:<br>") }   

  var sResultado = -1

  switch (parseInt(Tarea)) {

    case 1:

        try {
          //Usu_Password se maneja en BDD 
          var sCondCli = "Cli_ID = " + iCliID
          var iCliUsuID = BuscaSoloUnDato("ISNULL((MAX(Cli_Usu_ID) + 1),0)","Cliente_Usuario",sCondCli,-1,0)

          var sCliUsu = " INSERT INTO Cliente_Usuario (Cli_ID, Cli_Usu_ID, Usu_Nombre, Usu_Usuario, Usu_Descripcion "
              sCliUsu += ",Usu_Email,Usu_Grupo,Usu_TipoUsuarioCG61, Usu_Estatus, Usu_Padre) "
              sCliUsu += " VALUES (" + iCliID + "," + iCliUsuID + ",'" + sUsu_Nombre + "','" + sUsu_Usuario + "','" + sUsu_Descripcion + "'"
              sCliUsu += ",'" + sUsu_Email + "'," + iUsu_Grupo + "," + iUsu_TipoUsuarioCG61 + " ," + iUsu_Estatus + "," + iUsu_Padre + ")"

            if (ibQ4Web) { 
              Response.Write("sCliUsu:&nbsp;" + sCliUsu + "<br />") 
            } else {
              Ejecuta(sCliUsu,0)
            }

            sResultado = iCliUsuID

        } catch(err) {
            sResultado = -1 
        }

        //Response.Write(sResultado)

    break;

    case 2:

        try {

          var sEdiCliUsu = "UPDATE Cliente_Usuario SET "
              sEdiCliUsu += "Usu_Nombre = '" + sUsu_Nombre + "'"
              sEdiCliUsu += ",Usu_Usuario = '" + sUsu_Usuario + "'"
              sEdiCliUsu += ",Usu_Descripcion = '" + sUsu_Descripcion + "'"
              sEdiCliUsu += ",Usu_Email = '" + sUsu_Email + "'"
              sEdiCliUsu += ",Usu_Grupo = " + iUsu_Grupo
              sEdiCliUsu += ",Usu_TipoUsuarioCG61 = " + iUsu_TipoUsuarioCG61
              sEdiCliUsu += ",Usu_Estatus = " + iUsu_Estatus
              sEdiCliUsu += ",Usu_Padre = " + iUsu_Padre
              sEdiCliUsu += " WHERE Cli_ID = " + iCliID
              sEdiCliUsu += " AND Cli_Usu_ID = " + iCliUsuID

            if (ibQ4Web) { 
              Response.Write(sEdiCliUsu+"<br />") 
            } else {
             Ejecuta(sEdiCliUsu,0)
            }

            sResultado = iCliUsuID

        } catch(err) {
              sResultado = -1 
          }

        //Response.Write(sResultado)

    break;

    case 3:

      try {

        var sDeleteLog = " UPDATE Cliente_Usuario SET "
            sDeleteLog += " Usu_Estatus = 0"
            sDeleteLog += ", Usu_Habilitado = 0"
            sDeleteLog += ", Usu_Borrado = 1"
            sDeleteLog += " WHERE Cli_ID = " + iCliID
            sDeleteLog += " AND Cli_Usu_ID = " + iCliUsuID
        
          if (ibQ4Web) { 
            Response.Write(sDeleteLog+"<br />") 
          } else {
            Ejecuta(sDeleteLog,0)
          }

          sResultado = 1	

      } catch(err) {
        sResultado = 0 
      }

        //Response.Write(sResultado)	

    break;

  }

     Response.Write(sResultado)

  %>


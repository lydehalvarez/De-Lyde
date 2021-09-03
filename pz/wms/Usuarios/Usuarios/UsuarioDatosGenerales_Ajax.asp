<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
  <%

    var ibQ4Web = false
    var Tarea = Parametro("Tarea",0)

    var iUsuID = Parametro("Usu_ID",-1) 

    if (ibQ4Web) { Response.Write("Tarea: "+Tarea+" | Usu_ID:" + iUsuID+"<br>") }   

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
          var sCond = ""
          var iUsuID = BuscaSoloUnDato("ISNULL((MAX(Usu_ID) + 1),0)","Usuario",sCond,-1,0)

          var sUsuU = " INSERT INTO Usuario (Usu_ID, Usu_Nombre, Usu_Usuario, Usu_Descripcion "
              sUsuU += ",Usu_Email,Usu_Grupo,Usu_TipoUsuarioCG61, Usu_Estatus, Usu_Padre) "
              sUsuU += " VALUES (" + iUsuID + ",'" + sUsu_Nombre + "','" + sUsu_Usuario + "','" + sUsu_Descripcion + "'"
              sUsuU += ",'" + sUsu_Email + "'," + iUsu_Grupo + "," + iUsu_TipoUsuarioCG61 + " ," + iUsu_Estatus + "," + iUsu_Padre + ")"

            if (ibQ4Web) { 
              Response.Write("sUsuU:&nbsp;" + sUsuU + "<br />") 
            } else {
              Ejecuta(sUsuU,0)
            }

            sResultado = iUsuID

        } catch(err) {
            sResultado = -1 
        }

        //Response.Write(sResultado)

    break;

    case 2:

        try {

          var sEditUsuU = "UPDATE Usuario SET "
              sEditUsuU += "Usu_Nombre = '" + sUsu_Nombre + "'"
              sEditUsuU += ",Usu_Usuario = '" + sUsu_Usuario + "'"
              sEditUsuU += ",Usu_Descripcion = '" + sUsu_Descripcion + "'"
              sEditUsuU += ",Usu_Email = '" + sUsu_Email + "'"
              sEditUsuU += ",Usu_Grupo = " + iUsu_Grupo
              sEditUsuU += ",Usu_TipoUsuarioCG61 = " + iUsu_TipoUsuarioCG61
              sEditUsuU += ",Usu_Estatus = " + iUsu_Estatus
              sEditUsuU += ",Usu_Padre = " + iUsu_Padre
              sEditUsuU += " WHERE Usu_ID = " + iUsuID

            if (ibQ4Web) { 
              Response.Write(sEditUsuU+"<br />") 
            } else {
             Ejecuta(sEditUsuU,0)
            }

            sResultado = iUsuID

        } catch(err) {
              sResultado = -1 
          }

        //Response.Write(sResultado)

    break;

    case 3:

      try {

        var sDeleteLog = " UPDATE Usuario SET "
            sDeleteLog += " Usu_Estatus = 0"
            sDeleteLog += ", Usu_Habilitado = 0"
            sDeleteLog += ", Usu_Borrado = 1"
            sDeleteLog += " WHERE Usu_ID = " + iUsuID
        
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


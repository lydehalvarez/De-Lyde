<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

    var ibQ4Web = false
    var Tarea = Parametro("Tarea",0)

    var iProvID = Parametro("Prov_ID",-1)

    var iProvUsuID = Parametro("Prov_Usu_ID",-1) 

    if (ibQ4Web) { Response.Write("Tarea: "+Tarea+" Prov_ID:&nbsp;"+iProvID + " | Prov_Usu_ID:" + iProvUsuID+"<br>") }   

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
          var sCondProv = "Prov_ID = " + iProvID
          var iProvUsuID = BuscaSoloUnDato("ISNULL((MAX(Prov_Usu_ID) + 1),0)","Proveedor_Usuario",sCondProv,-1,0)

          var sProvUsu = " INSERT INTO Proveedor_Usuario (Prov_ID, Prov_Usu_ID, Usu_Nombre, Usu_Usuario, Usu_Descripcion "
              sProvUsu += ",Usu_Email,Usu_Grupo,Usu_TipoUsuarioCG61, Usu_Estatus, Usu_Padre) "
              sProvUsu += " VALUES (" + iProvID + "," + iProvUsuID + ",'" + sUsu_Nombre + "','" + sUsu_Usuario + "','" + sUsu_Descripcion + "'"
              sProvUsu += ",'" + sUsu_Email + "'," + iUsu_Grupo + "," + iUsu_TipoUsuarioCG61 + " ," + iUsu_Estatus + "," + iUsu_Padre + ")"

            if (ibQ4Web) { 
              Response.Write("sProvUsu:&nbsp;" + sProvUsu + "<br />") 
            } else {
              Ejecuta(sProvUsu,0)
            }

            sResultado = iProvUsuID

        } catch(err) {
            sResultado = -1 
        }

        //Response.Write(sResultado)

    break;

    case 2:

        try {

          var sEdiProvUsu = "UPDATE Proveedor_Usuario SET "
              sEdiProvUsu += "Usu_Nombre = '" + sUsu_Nombre + "'"
              sEdiProvUsu += ",Usu_Usuario = '" + sUsu_Usuario + "'"
              sEdiProvUsu += ",Usu_Descripcion = '" + sUsu_Descripcion + "'"
              sEdiProvUsu += ",Usu_Email = '" + sUsu_Email + "'"
              sEdiProvUsu += ",Usu_Grupo = " + iUsu_Grupo
              sEdiProvUsu += ",Usu_TipoUsuarioCG61 = " + iUsu_TipoUsuarioCG61
              sEdiProvUsu += ",Usu_Estatus = " + iUsu_Estatus
              sEdiProvUsu += ",Usu_Padre = " + iUsu_Padre
              sEdiProvUsu += " WHERE Prov_ID = " + iProvID
              sEdiProvUsu += " AND Prov_Usu_ID = " + iProvUsuID

            if (ibQ4Web) { 
              Response.Write(sEdiProvUsu+"<br />") 
            } else {
             Ejecuta(sEdiProvUsu,0)
            }

            sResultado = iProvUsuID

        } catch(err) {
              sResultado = -1 
          }

        //Response.Write(sResultado)

    break;

    case 3:

      try {

        var sDeleteLog = " UPDATE Proveedor_Usuario SET "
            sDeleteLog += " Usu_Estatus = 0"
            sDeleteLog += ", Usu_Habilitado = 0"
            sDeleteLog += ", Usu_Borrado = 1"
            sDeleteLog += " WHERE Prov_ID = " + iProvID
            sDeleteLog += " AND Prov_Usu_ID = " + iProvUsuID
        
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


<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var ibQ4Web = false
  var Tarea = Parametro("Tarea",0)

  var iEmpID = Parametro("Emp_ID",-1) 

  if (ibQ4Web) { Response.Write("Tarea: "+Tarea+" | Emp_ID:" + iEmpID + "<br>") }      
   
  var sEmpNombre = utf8_decode(Parametro("Emp_Nombre",""))
  var sEmpApellidoPaterno = utf8_decode(Parametro("Emp_ApellidoPaterno",""))
  var sEmpApellidoMaterno = utf8_decode(Parametro("Emp_ApellidoMaterno",""))
  var sEmpNombreCompleto = utf8_decode(Parametro("Emp_NombreCompleto",""))
  //var sEmpFechaNacimiento = utf8_decode(Parametro("Emp_FechaNacimiento",""))
  var sEmpFechaNacimiento = Parametro("Emp_FechaNacimiento","")
      if(!EsVacio(sEmpFechaNacimiento)){
          sEmpFechaNacimiento = CambiaFormatoFecha(sEmpFechaNacimiento,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
      } else {
          sEmpFechaNacimiento = null   
      }
  var iEmpGeneroCG3 = Parametro("Emp_GeneroCG3",-1)
  var iEmpEstadoCivilCG4 = Parametro("Emp_EstadoCivilCG4",-1)
  var sEmpRFC = utf8_decode(Parametro("Emp_RFC",""))
  var sEmpCURP = utf8_decode(Parametro("Emp_CURP",""))
  var sEmpTelefono = utf8_decode(Parametro("Emp_Telefono",""))
  var sEmpEmail = utf8_decode(Parametro("Emp_Email",""))
  var sEmpNumeroSeguroSocial = utf8_decode(Parametro("Emp_NumeroSeguroSocial",""))

  var sEmpNumeroEmpleado = utf8_decode(Parametro("Emp_NumeroEmpleado",""))
  var iEmpEstatusCG6 = Parametro("Emp_EstatusCG6",-1)
  var sEmpFechaIngreso = Parametro("Emp_FechaIngreso","")
      if(!EsVacio(sEmpFechaIngreso)){
          sEmpFechaIngreso = CambiaFormatoFecha(sEmpFechaIngreso,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
      } else {
          sEmpFechaIngreso = null   
      }
  var sEmpFechaSalida = Parametro("Emp_FechaSalida","")
      if(!EsVacio(sEmpFechaSalida)){
          sEmpFechaSalida = CambiaFormatoFecha(sEmpFechaSalida,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
      } else {
          sEmpFechaSalida = null   
      }   
  var fEmpSueldoMensual = utf8_decode(Parametro("Emp_SueldoMensual",0))
  var fEmpSueldoDiario = utf8_decode(Parametro("Emp_SueldoDiario",0))

  var iComID = Parametro("Com_ID",-1)
  var iDepID = Parametro("Dep_ID",-1)
  var iPueID = Parametro("Pue_ID",-1)
  var sEmpUsuario = utf8_decode(Parametro("Emp_Usuario",""))
  var iEmpEsOperador = Parametro("Emp_EsOperador",0)
  
  var sResultado = -1

  switch (parseInt(Tarea)) {

    case 1:

        try {
           
            var sCond = ""
            var iEmpID = BuscaSoloUnDato("ISNULL((MAX(Emp_ID) + 1),0)","Empleado",sCond,-1,0)

            var sEmpUsu = "INSERT INTO Empleado (Emp_ID,Emp_Nombre "
                sEmpUsu += ",Emp_ApellidoPaterno,Emp_ApellidoMaterno "
                sEmpUsu += ",Emp_FechaNacimiento,Emp_GeneroCG3,Emp_EstadoCivilCG4 "
                sEmpUsu += ",Emp_RFC,Emp_CURP,Emp_Telefono,Emp_Email "
                sEmpUsu += ",Emp_NumeroSeguroSocial,Emp_NumeroEmpleado "
                sEmpUsu += ",Emp_EstatusCG6,Emp_FechaIngreso,Emp_FechaSalida "
                sEmpUsu += ",Emp_SueldoMensual,Emp_SueldoDiario "
                sEmpUsu += ",Com_ID,Dep_ID,Pue_ID "
                sEmpUsu += ",Emp_Usuario,Emp_EsOperador) "
                sEmpUsu += "VALUES (" + iEmpID + ",'" + sEmpNombre + "' "
                sEmpUsu += ",'" + sEmpApellidoPaterno + "','" + sEmpApellidoMaterno + "' "

                //sEmpUsu += ",'" + sEmpFechaNacimiento + "'," 

                if(!EsVacio(sEmpFechaNacimiento)){
                    sEmpUsu += ", '"+sEmpFechaNacimiento+"'"
                } else {
                    sEmpUsu += ", null"
                }  

                sEmpUsu += ","+ iEmpGeneroCG3 + "," + iEmpEstadoCivilCG4 
                sEmpUsu += ",'" + sEmpRFC + "','" + sEmpCURP + "','" + sEmpTelefono + "','" + sEmpEmail + "' " 
                sEmpUsu += ",'" + sEmpNumeroSeguroSocial + "','" + sEmpNumeroEmpleado + "' "
   
                sEmpUsu += "," + iEmpEstatusCG6  
                //sEmpUsu +=  ", '"+sEmpFechaIngreso+"'"
   
                if(!EsVacio(sEmpFechaIngreso)){
                    sEmpUsu += ", '"+sEmpFechaIngreso+"'"
                } else {
                    sEmpUsu += ", null"
                }                    
   
                //+ "','" + sEmpFechaSalida + "', "
   
                if(!EsVacio(sEmpFechaSalida)){
                    sEmpUsu += ", '"+sEmpFechaSalida+"'"
                } else {
                    sEmpUsu += ", null"
                }     
   
                sEmpUsu += "," + fEmpSueldoMensual + ", " + fEmpSueldoDiario
                sEmpUsu += "," + iComID + ", " + iDepID + ", " + iPueID
                sEmpUsu += ",'" + sEmpUsuario + "'," + iEmpEsOperador + ")"

                if (ibQ4Web) { 
                Response.Write("sEmpUsu:&nbsp;" + sEmpUsu + "<br />") 
                } else {
                Ejecuta(sEmpUsu,0)
                }

            sResultado = iEmpID

        } catch(err) {
            sResultado = -1 
        }

        //Response.Write(sResultado)

    break;

    case 2:

        try {

            var sEditEmpUsu = "UPDATE Empleado SET "
                sEditEmpUsu += "Emp_Nombre = '" + sEmpNombre + "' "
                sEditEmpUsu += ",Emp_ApellidoPaterno = '" + sEmpApellidoPaterno + "' "
                sEditEmpUsu += ",Emp_ApellidoMaterno = '" + sEmpApellidoMaterno + "' "

                //sEditEmpUsu += ",Emp_FechaNacimiento = '" + sEmpFechaNacimiento + "' "
   
                if(!EsVacio(sEmpFechaNacimiento)){
                    sEditEmpUsu += ",Emp_FechaNacimiento = '" + sEmpFechaNacimiento + "' "
                } else {
                    sEditEmpUsu += ",Emp_FechaNacimiento = null"
                }  
   
                sEditEmpUsu += ",Emp_GeneroCG3 = " + iEmpGeneroCG3
                sEditEmpUsu += ",Emp_EstadoCivilCG4 = " + iEmpEstadoCivilCG4
                sEditEmpUsu += ",Emp_RFC = '" + sEmpRFC + "' "
                sEditEmpUsu += ",Emp_CURP = '" + sEmpCURP + "' "
                sEditEmpUsu += ",Emp_Telefono = '" + sEmpTelefono + "' "
                sEditEmpUsu += ",Emp_Email = '" + sEmpEmail + "' "
                sEditEmpUsu += ",Emp_NumeroSeguroSocial = '" + sEmpNumeroSeguroSocial + "' "
                sEditEmpUsu += ",Emp_NumeroEmpleado = '" + sEmpNumeroEmpleado + "' "
                sEditEmpUsu += ",Emp_EstatusCG6 = " + iEmpEstatusCG6
   
                //sEditEmpUsu += ",Emp_FechaIngreso = '" + sEmpFechaIngreso + "' "
   
                if(!EsVacio(sEmpFechaIngreso)){
                    sEditEmpUsu += ",Emp_FechaIngreso = '" + sEmpFechaIngreso + "' "
                } else {
                    sEditEmpUsu += ",Emp_FechaIngreso = null"
                }     
   
                //sEditEmpUsu += ",Emp_FechaSalida = '" + sEmpFechaSalida + "' "
   
                if(!EsVacio(sEmpFechaSalida)){
                    sEditEmpUsu += ",Emp_FechaSalida = '" + sEmpFechaSalida + "' "
                } else {
                    sEditEmpUsu += ",Emp_FechaSalida = null"
                }    
   
                sEditEmpUsu += ",Emp_SueldoMensual = " + fEmpSueldoMensual
                sEditEmpUsu += ",Emp_SueldoDiario = " + fEmpSueldoDiario
                sEditEmpUsu += ",Com_ID = " + iComID
                sEditEmpUsu += ",Dep_ID = " + iDepID
                sEditEmpUsu += ",Pue_ID = " + iPueID
                sEditEmpUsu += ",Emp_Usuario = '" + sEmpUsuario + "' "
                sEditEmpUsu += ",Emp_EsOperador = " + iEmpEsOperador
                sEditEmpUsu += " WHERE Emp_ID = " + iEmpID

                if (ibQ4Web) { 
                    Response.Write(sEditEmpUsu+"<br />") 
                } else {
                    Ejecuta(sEditEmpUsu,0)
                }

            sResultado = iEmpID

        } catch(err) {
              sResultado = -1 
          }

        //Response.Write(sResultado)

    break;

    case 3:

      try {

        var sDeleteLog = " UPDATE Empleado SET "
            sDeleteLog += "Emp_Activo = 0 "
            sDeleteLog += ", Emp_EstatusCG6 = 2 "
            //sDeleteLog += ", Usu_Habilitado = 0 "
            //sDeleteLog += ", Usu_Borrado = 1"
            sDeleteLog += "WHERE Emp_ID = " + iEmpID
        
          if (ibQ4Web) { 
            Response.Write(sDeleteLog+"<br />") 
          } else {
            Ejecuta(sDeleteLog,0)
          }

          sResultado = 1	

      } catch(err) {
        sResultado = 0 
      }

    break;
   
    case 4: 
      
      var iDepID = BuscaSoloUnDato("Dep_ID","Empleado","Com_ID="+iComID+" AND Emp_ID="+iEmpID,-1,0)
      //Response.Write(iDepID)
      var Seleccionado = iDepID 
      sResultado = "<select name='Dep_ID' id='Dep_ID' class='form-control'>"
      var sElemento = "<option value='-1'"
          if (Seleccionado == -1) { sElemento += " selected " }
          sElemento += ">Seleccione</option>"

      var CCSQL = "SELECT Dep_ID, Dep_Nombre FROM Compania_Departamento "
          CCSQL += " WHERE Com_ID = " + iComID
          /*if(iDepID > -1){ 
            CCSQL += " AND Dep_ID = " + iDepID 
          }*/
          CCSQL += " ORDER BY Dep_Nombre "
          //Response.Write(CCSQL)
      var rsCC = AbreTabla(CCSQL,1,0) 
      while (!rsCC.EOF){
        sElemento += "<option value='"+rsCC.Fields.Item(0).Value+"'"
            if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
        sElemento += ">" + rsCC.Fields.Item(1).Value + "</option>"
        rsCC.MoveNext()
      }
        sResultado += sElemento
      rsCC.Close()
      sResultado += "</select>"

      sResultado += "<script type='text/javascript'> "
        sResultado += "	$(document).ready(function () { "
        sResultado += " $('select#Dep_ID').select2(); "
        sResultado += " });"
      sResultado += "</script>"
   
    break;

    case 5: 
      
      var iPueID = BuscaSoloUnDato("Pue_ID","Empleado","Com_ID="+iComID+" AND Emp_ID="+iEmpID,-1,0)
      
      var Seleccionado = iPueID 
      sResultado = "<select name='Pue_ID' id='Pue_ID' class='form-control'>"
      var sElemento = "<option value='-1'"
          if (Seleccionado == -1) { sElemento += " selected " }
          sElemento += ">Seleccione</option>"

      var CCSQL = "SELECT Pue_ID, Pue_Nombre FROM Compania_Puesto "
          CCSQL += " WHERE Com_ID = " + iComID
          /*if(iPueID > -1){ 
            CCSQL += " AND Pue_ID = " + iPueID 
          }*/
          CCSQL += " ORDER BY Pue_Nombre "
          //Response.Write(CCSQL)
      var rsCC = AbreTabla(CCSQL,1,0) 
      while (!rsCC.EOF){
        sElemento += "<option value='"+rsCC.Fields.Item(0).Value+"'"
            if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
        sElemento += ">" + rsCC.Fields.Item(1).Value + "</option>"
        rsCC.MoveNext()
      }
        sResultado += sElemento
      rsCC.Close()
      sResultado += "</select>"

      sResultado += "<script type='text/javascript'> "
        sResultado += "	$(document).ready(function () { "
        sResultado += " $('select#Pue_ID').select2(); "
        sResultado += " });"
      sResultado += "</script>"
   
    break;        
        
        
        

  }

     Response.Write(sResultado)
  
   
%>   

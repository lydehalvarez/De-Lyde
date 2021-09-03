<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var bDebIQ = true

  var iEmpID = Parametro("Emp_ID",-1)
   
  var sEmpNombreCompleto = Parametro("Emp_NombreCompleto","") 
  var sEmpFechaNacimiento = Parametro("Emp_FechaNacimiento","") 
  var sEmpNumeroEmpleado = Parametro("Emp_NumeroEmpleado","") 
  var sEmpRFC = Parametro("Emp_RFC","") 
  var sEmpCURP = Parametro("Emp_CURP","")
  var iEmpEstatusCG6 = Parametro("Emp_EstatusCG6",-1) 
   
  var sSQL  = " SELECT Emp_ID,Emp_NombreCompleto, Emp_NumeroEmpleado ,Emp_RFC "
      sSQL += ",Emp_CURP, Emp_FechaNacimiento, CONVERT(VARCHAR(20),Emp_FechaNacimiento, 103) AS FECNAC "
      sSQL += ",Emp_EstatusCG6, (SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 6 AND Cat_ID = Emp_EstatusCG6) AS ESTATUS "
      sSQL += ",Emp_EsOperador, CASE Emp_EsOperador WHEN 1 THEN 'SI'  ELSE 'NO' END AS ESOPERADOR "
      sSQL += "FROM Empleado "
   
  var sCondEmp = ""
   
  if(!EsVacio(sEmpNombreCompleto)){
      if (sCondEmp != "") { sCondEmp += " AND " }
      sCondEmp += " Emp_NombreCompleto = '" + sEmpNombreCompleto + "'"
  }  

  if(!EsVacio(sEmpFechaNacimiento)){
      if (sCondEmp != "") { sCondEmp += " AND " }
      sCondEmp += " Emp_FechaNacimiento = '" + sEmpFechaNacimiento + "'"
  }  

  if(!EsVacio(sEmpNumeroEmpleado)){
      if (sCondEmp != "") { sCondEmp += " AND " }
      sCondEmp += " Emp_NumeroEmpleado = '" + sEmpNumeroEmpleado + "'"
  }      

  if(!EsVacio(sEmpRFC)){
      if (sCondEmp != "") { sCondEmp += " AND " }
      sCondEmp += " Emp_RFC = '" + sEmpRFC + "'"
  }      
   
  if(!EsVacio(sEmpCURP)){
      if (sCondEmp != "") { sCondEmp += " AND " }
      sCondEmp += " Emp_CURP = '" + sEmpCURP + "'"
  } 
   
  if (sCondEmp != "") {
      sSQL += " WHERE " + sCondEmp
  }    

  sSQL += " ORDER BY Emp_NombreCompleto, Emp_FechaRegistro DESC "   
   
   
  if(bDebIQ){
     Response.Write("<br>"+sSQL)
  }     
   
%>

<table class="table table-striped table-hover table-bordered" width="100%">
	<thead>
    	<tr>
        <th class="text-center">Num.</th>
        <th class="text-left">Nombre</th>
        <th class="text-center">N&uacute;mero de empleado</th>
        <th class="text-center">R.F.C.</th>
        <th class="text-center">CURP</th>
        <th class="text-center">Estatus</th>
        <th class="text-center">Operador</th>
        <th class="text-center">&nbsp;</th>
      </tr>
    </thead>
    <tbody>
    <%
      //Response.Buffer = true
      var Emp_ID = -1
      var iRegistros = 0

      var rsEmp = AbreTabla(sSQL,1,0)
       
	if(!rsEmp.EOF){
    //Response.Flush()
		while(!rsEmp.EOF){
       
		    Emp_ID = rsEmp.Fields.Item("Emp_ID").Value

        iRegistros++
       
	%>
      <tr>
        <td class="text-center"><%=iRegistros%></td>
        <td class="text-left"><%=rsEmp.Fields.Item("Emp_NombreCompleto").Value%></td>
        <td class="text-center"><%=rsEmp.Fields.Item("Emp_NumeroEmpleado").Value%></td>
        <td class="text-center"><small><%=rsEmp.Fields.Item("Emp_RFC").Value%></small></td>
        <td class="text-center"><%=rsEmp.Fields.Item("Emp_CURP").Value%></td> 
        <td class="text-center"><small><%=rsEmp.Fields.Item("ESTATUS").Value%></small></td>
        <td class="text-center"><small><%=rsEmp.Fields.Item("ESOPERADOR").Value%></small></td>
        <td valign="middle" class="text-center" nowrap>
					<div align="center">
						<a class="btn btn-xs btn-green tooltips" data-original-title="Seleccionar" data-placement="top" href="javascript:gridSelec(<%=Emp_ID%>)"><i class="fa fa-share"></i></a>
					</div>
        </td>
      </tr>
	<%
            rsEmp.MoveNext()
        } 
    rsEmp.Close()
	} else {
	%>
	<!--tr>
    	<td colspan="9">No se encontraron ubicaciones por auditar</td>
    </tr-->
    <tr class="odd">
        <td colspan="9" align="center" valign="top" class="dataTables_empty">No se encontraron empleados con estos criterios.</td>
    </tr>        
	<%
	}
    %>
    </tbody>
</table>

<script language="javascript" type="text/javascript">

  $(document).ready(function() {



  });

  function gridSelec(jqiEmpID) {

    $('#Emp_ID').val(jqiEmpID);   
    CambiaSiguienteVentana();
  }  
  
  
  
</script>  
  
  
  


























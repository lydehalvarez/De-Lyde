<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var Aud_ID = Parametro("Aud_ID",-1)
  var TipoAuditor = Parametro("TipoAuditor",1)
  var Cli_ID = Parametro("Cli_ID",-1)
  /*
  Valores de TipoAuditor:
  1: Usuario Interno - Usu_Habilitado = 1 & Usu_EsAuditor
  		Tabla Usuario
  2: Usuario Externo - Tabla nueva para dar de alta auditores externos
  		Tabla Cliente_Usuario
  */
  
  if(Aud_ID){
		var sSQL = "SELECT USU.Usu_ID, ISNULL(Usu_Email,'') AS Usu_Email "
			sSQL += ",(SELECT SI.IDUnica FROM Seguridad_Indice SI "
			sSQL += " WHERE SI.Usu_ID = USU.Usu_ID) AS IDUNICA "
		 
			sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
			sSQL += "WHERE AU.Aud_ID = " + Aud_ID
			sSQL += " AND AU.Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
			sSQL += " WHERE SI.Usu_ID = USU.Usu_ID)),'')) AS Seleccionado "
		 
			sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
			sSQL += "WHERE AU.Aud_ID = " + Aud_ID
			sSQL += " AND AU.Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
			sSQL += " WHERE SI.Usu_ID = USU.Usu_ID) AND AU.AudU_TipoSupAud = 1),'')) AS Supervisor "             
		 
			sSQL += ",USU.Usu_Nombre "
			sSQL += "FROM Usuario USU "
			sSQL += "WHERE USU.Usu_Habilitado = 1 AND USU.Usu_EsAuditor = 1 "
			sSQL += "ORDER BY USU.Usu_Nombre "
		 
			/*
			sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
			sSQL += "WHERE AU.Aud_ID ="+iAudID+" AND AU.Cli_ID = CU.Cli_ID "
			sSQL += "AND AU.Cli_Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
			sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID) "
			sSQL += "AND AU.AudU_TipoSupAud = 1),'')) AS Supervisor " 
			*/

  }else{
	  var sSQL = "SELECT CU.Cli_ID, CU.Cli_Usu_ID "
		sSQL += ",(SELECT SI.IDUnica FROM Seguridad_Indice SI " 
		sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID) AS IDUNICA "

		sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
		sSQL += "WHERE AU.Aud_ID ="+Aud_ID+" AND AU.Cli_ID = CU.Cli_ID "
		sSQL += "AND AU.Cli_Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
		sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID)),'')) AS Seleccionado "

		sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
		sSQL += "WHERE AU.Aud_ID ="+Aud_ID+" AND AU.Cli_ID = CU.Cli_ID "
		sSQL += "AND AU.Cli_Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
		sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID) "
		sSQL += "AND AU.AudU_TipoSupAud = 1),'')) AS Supervisor "

		sSQL += ",CU.Usu_Nombre "
		sSQL += "FROM Cliente_Usuario CU "
		sSQL += "WHERE CU.Usu_Habilitado = 1 "
		sSQL += "AND CU.Usu_EsAuditor = 1 "
		sSQL += "AND CU.Cli_ID = "+ Cli_ID
		sSQL += " ORDER BY CU.Usu_Nombre"
		
  }
  
  
  
   
%>
  
<div class="ibox-content">  
  <div class="row">
    <div class="col-md-12">
        <div class="table-responsive">
        <table class="table table-striped">
          <%
             
              var sUsuID = -1
              var rsGral = AbreTabla(sSQL,1,0)

              var sCSSCheckI = ""
              var sCSSCheckII = ""
              var sCSSCheckIII = ""
             
              if(!rsGral.EOF){
             
             %>
          <thead>
            <tr>
              <th class="text-center">Habilitado</th>
              <th class="text-center">Es supervisor</th>
              <th class="text-left">Usuario(s)</th>
              <th class="text-left">Correo electr&oacute;nico</th>
            </tr>
          </thead>
          <tbody>
          <% 
               while (!rsGral.EOF) {

                 var sChecked = ""
                 var sCheckedtmp = ""
                 
                 var sCheckedSup = ""
                 var sCheckedSupCli = ""                 

                 if (!EsVacio(rsGral.Fields.Item("Seleccionado").Value)) {

                   sChecked = "checked='checked'"
                   sCheckedtmp = rsGral.Fields.Item("Seleccionado").Value

                 }
                   
                 if (!EsVacio(rsGral.Fields.Item("Supervisor").Value)) {

                   sCheckedSup = "checked='checked'"
                   sCheckedSupCli = rsGral.Fields.Item("Supervisor").Value

                 }                   
                   
                 sUsuID = rsGral.Fields.Item("IDUNICA").Value
                 
              %>
            <tr>
              <td class="text-center">
                  <input type="checkbox" class="i-checks chkUsuID" <%=sChecked%> 
                  data-usuid="<%=sUsuID%>" data-checked="<%=sCheckedtmp%>" 
                  data-audid="<%=iAudID%>" id="chkUsu<%=sUsuID%>">               
              </td>
              <td class="text-center">
                  <input type="checkbox" class="i-checks chkSup" <%=sCheckedSup%> 
                  data-usuid="<%=sUsuID%>" 
                  data-checked="<%=sCheckedSupCli%>" 
                  data-audid="<%=iAudID%>" id="chkUsuSup<%=sUsuID%>">               
              </td>              
              <td class="text-left">
                  <%Response.Write(rsGral.Fields.Item("Usu_Nombre").Value) %>
              </td>
              <td class="text-left">
                  <%Response.Write(rsGral.Fields.Item("Usu_Email").Value) %>
              </td>                
            </tr>
            <%
             rsGral.MoveNext()
             }
             rsGral.Close()
              } else { 
            %>
            <tr>
              <th colspan="3" class="text-center">
              <p class="text-center">
                <a class="faq-question" href="#">No se encontraron registros</a>
              </p>
              </th>
            </tr>  
            <%} %>  
          </tbody>
        </table>
      </div>
    </div>
  </div>  
</div>  
  
<script language="javascript">
                                                               
  $(document).ready(function(){

      $('.i-checks').iCheck({
          checkboxClass: 'icheckbox_square-green',
      });

      //$('.chkSup').iCheck('disable');

  }); 
  
  $(".chkUsuID").on('ifClicked', function(event){

      if( $(this).is(':checked') ){
        iChecado =0;	
      } else {
        iChecado =1;	
      }                             
      
      var iAudID = $(this).attr("data-audid");
      var iUsuID = $(this).attr("data-usuid");
      sChecked = $(this).attr("data-checked");
      //console.log(iAudID + " | " + iUsuID + " | Seleccionamos el Usuario: "+iChecado);
      if(iChecado == 0){
        //$('#chkUsuSup'+iUsuID).iCheck('uncheck');
        $('#chkUsuSup'+iUsuID).iCheck('uncheck');
      }
      GuardaChecks(iAudID,iUsuID,iChecado);               

  }); 
  
  
  function GuardaChecks(ijsAudID,iValor,Checado) {

    var sMensaje = "";
    var Poner = 0;

    if (Checado==1) { Poner = 1 }
    
    //console.log("GuardaChecks: " + ijsAudID + " | " + iValor + " | Seleccionamos el Usuario: "+Checado);
    $.post("/pz/wms/Auditoria/AuditoriaAsignaUsuario_Ajax.asp", 
        { Tarea:3,Aud_ID:ijsAudID,Usu_ID:iValor,Poner:Poner
        },function(data) {
            //alert(data);
            //var iresul = parseInt(data);
            var response = JSON.parse(data);

            if (response.Resultado == 1) {
              sMensaje= "El usuario fue revocado correctamente";              
              Avisa("success",'Aviso',sMensaje);
            }

            if (response.Resultado == 2) {
              sMensaje= "El usuario fue asignado correctamente";               
              Avisa("success",'Aviso',sMensaje);
            }	
      
            if (response.Resultado == 0) {
              Avisa("error","Error",response.Error.message+ " " + response.Error.name);
            }	      
      
        });  

  }  
  
  $(".chkSup").on('ifClicked', function(event){

      if( $(this).is(':checked') ){
        iChecado =0;	
      } else {
        iChecado =1;	
      }                             
      
      var iAudID = $(this).attr("data-audid");
      var iUsuID = $(this).attr("data-usuid");
      sChecked = $(this).attr("data-checked");
      //console.log(iAudID + " | " + iUsuID + " | Seleccionamos el Usuario: "+iChecado);
      $('#chkUsu'+iUsuID).iCheck('check');
      GuardaChecksSup(iAudID,iUsuID,iChecado);               

  });  
  
   function GuardaChecksSup(ijsAudID,iValor,Checado) {

    var sMensaje = "";
    var Poner = 0;

    if (Checado==1) { Poner = 1 }
    
    //console.log("GuardaChecks: " + ijsAudID + " | " +  iValor + " | Seleccionamos el Usuario: "+Checado);
    $.post("/pz/wms/Auditoria/AuditoriaAsignaUsuario_Ajax.asp", 
        { Tarea:4,Aud_ID:ijsAudID,Usu_ID:iValor,Poner:Poner
        },function(data) {
            //alert(data);
            //var iresul = parseInt(data);
            var response = JSON.parse(data);

            if (response.Resultado == 1) {
              sMensaje= "El usuario fue revocado correctamente";              
              Avisa("success",'Aviso',sMensaje);
            }

            if (response.Resultado == 2) {
              sMensaje= "El usuario fue asignado correctamente";               
              Avisa("success",'Aviso',sMensaje);
            }	
      
            if (response.Resultado == 0) {
              Avisa("error","Error",response.Error.message+ " " + response.Error.name);
            }	      
      
        });  

  }   
  
</script> 
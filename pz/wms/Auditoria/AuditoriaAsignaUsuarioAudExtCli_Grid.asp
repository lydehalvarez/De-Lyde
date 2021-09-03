<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var bDebug = false
  var iAudID = Parametro("Aud_ID",-1)
  var iCliID = Parametro("Cli_ID",-1)
  var iTipoAuditor = Parametro("TipoAuditor",1) 
  /*
  Valores de TipoAuditor:
  1: Usuario Interno - Usu_Habilitado = 1 & Usu_EsAuditor
  2: Usuario Externo - Tabla nueva para dar de alta auditores externos
  */
  if(bDebug){ Response.Write("Aud_ID: " + iAudID + " | TipoAuditor: " + iTipoAuditor) }
   
   
%>
  
<div class="ibox-content">  
  <div class="row">
    <div class="col-md-12">
        <div class="table-responsive">
        <table class="table table-striped">
          <%
             /*
              var sSQL = "SELECT CU.Cli_ID, CU.Cli_Usu_ID "
                sSQL += ",(SELECT SI.IDUnica FROM Seguridad_Indice SI " 
                sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID) AS IDUNICA "

                sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
                sSQL += "WHERE AU.Aud_ID ="+iAudID+" AND AU.Cli_ID = CU.Cli_ID "
                sSQL += "AND AU.Cli_Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
                sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID)),'')) AS Seleccionado "

                sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
                sSQL += "WHERE AU.Aud_ID ="+iAudID+" AND AU.Cli_ID = CU.Cli_ID "
                sSQL += "AND AU.Cli_Usu_ID = (SELECT SI.IDUnica FROM Seguridad_Indice SI "
                sSQL += "WHERE SI.Cli_ID = CU.Cli_ID AND SI.Cli_Usu_ID = CU.Cli_Usu_ID) "
                sSQL += "AND AU.AudU_TipoSupAud = 1),'')) AS Supervisor "

                sSQL += ",CU.Usu_Nombre "
                sSQL += "FROM Cliente_Usuario CU "
                sSQL += "WHERE CU.Usu_Habilitado = 1 "
                sSQL += "AND CU.Usu_EsAuditor = 1 "
                sSQL += "AND CU.Cli_ID = "+ iCliID
                sSQL += " ORDER BY CU.Usu_Nombre"
             */

              var sSQL = "SELECT CU.Cli_ID, CU.Cli_Usu_ID "
                sSQL += ",(ISNULL((SELECT 'checked' FROM Auditorias_Auditores AU "
                sSQL += "WHERE AU.Aud_ID ="+iAudID
                sSQL += "AND AU.Cli_ID = CU.Cli_ID AND AU.Cli_Usu_ID = CU.Cli_Usu_ID),'')) AS Seleccionado "
                sSQL += ",(ISNULL((SELECT 'checked' FROM Auditoria_Usuario AU "
                sSQL += "WHERE AU.Aud_ID ="+iAudID
                sSQL += "AND AU.Cli_ID = CU.Cli_ID AND AU.Cli_Usu_ID = CU.Cli_Usu_ID "
                sSQL += "AND AU.AudU_TipoSupAud = 1),'')) AS Supervisor "
                sSQL += ",CU.Usu_Nombre "
                sSQL += "FROM Cliente_Usuario CU "
                sSQL += "WHERE CU.Usu_Habilitado = 1 " 
                sSQL += "AND CU.Usu_EsAuditor = 1 " 
                sSQL += "AND CU.Cli_ID ="+ iCliID
                sSQL += "ORDER BY CU.Usu_Nombre "            
             
              if (bDebug) { Response.Write(sSQL) }
              //Response.End()
              var sCliUsuID = -1
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
                   
                 sCliUsuID = rsGral.Fields.Item("Cli_Usu_ID").Value
                 
              %>
            <tr>
              <td class="text-center">
                  <input type="checkbox" class="i-checks chkCliUsuID" <%=sChecked%> href="javascript:void(0)" data-cliusuid="<%=sCliUsuID%>" data-checked="<%=sCheckedtmp%>" data-cliid="<%=iCliID%>" data-audid="<%=iAudID%>" id="chkUsu<%=sCliUsuID%>">               
              </td>
              <td class="text-center">
                  <input type="checkbox" class="i-checks chkCliSup" <%=sCheckedSup%> href="javascript:void(0)" data-cliusuid="<%=sCliUsuID%>" data-checked="<%=sCheckedSupCli%>" data-cliid="<%=iCliID%>" data-audid="<%=iAudID%>" id="chkUsuSup<%=sCliUsuID%>">               
              </td>              
              <td class="text-left">
                  <%Response.Write(rsGral.Fields.Item("Usu_Nombre").Value) %>
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

      //$('.chkCliSup').iCheck('disable');

  }); 
  
  $(".chkCliUsuID").on('ifClicked', function(event){

      if( $(this).is(':checked') ){
        iChecado =0;	
      } else {
        iChecado =1;	
      }                             
      
      var iAudID = $(this).attr("data-audid");
      var iCliID = $(this).attr("data-cliid");
      var iCliUsuID = $(this).attr("data-cliusuid");
      sChecked = $(this).attr("data-checked");
      //console.log(iAudID + " | " + iCliID + " | " + iCliUsuID + " | Seleccionamos el Usuario: "+iChecado);
      if(iChecado == 0){
        //$('#chkCliSup'+iCliUsuID).iCheck('uncheck');
        $('#chkUsuSup'+iCliUsuID).iCheck('uncheck');
      }
    
      GuardaChecks(iAudID,iCliID,iCliUsuID,iChecado);               

  }); 
  
  
  function GuardaChecks(ijsAudID,ijsCliID,iValor,Checado) {

    var sMensaje = "";
    var Poner = 0;

    if (Checado==1) { Poner = 1 }
    
    //console.log("GuardaChecks: " + ijsAudID + " | " + ijsCliID + " | " + iValor + " | Seleccionamos el Usuario: "+Checado);
    $.post("/pz/wms/Auditoria/AuditoriaAsignaUsuario_Ajax.asp", 
        { Tarea:1,Aud_ID:ijsAudID,Cli_ID:ijsCliID,Cli_Usu_ID:iValor,Poner:Poner
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
  
  $(".chkCliSup").on('ifClicked', function(event){

      if( $(this).is(':checked') ){
        iChecado =0;	
      } else {
        iChecado =1;	
      }                             
      
      var iAudID = $(this).attr("data-audid");
      var iCliID = $(this).attr("data-cliid");
      var iCliUsuID = $(this).attr("data-cliusuid");
      sChecked = $(this).attr("data-checked");
      //console.log(iAudID + " | " + iCliID + " | " + iCliUsuID + " | Seleccionamos el Usuario: "+iChecado);
      $('#chkUsu'+iCliUsuID).iCheck('check');
      GuardaChecksSup(iAudID,iCliID,iCliUsuID,iChecado);               

  });  
  
   function GuardaChecksSup(ijsAudID,ijsCliID,iValor,Checado) {

    var sMensaje = "";
    var Poner = 0;

    if (Checado==1) { Poner = 1 }
    
    //console.log("GuardaChecksSup: " + ijsAudID + " | " + ijsCliID + " | " + iValor + " | Seleccionamos el Usuario: "+Checado);
    $.post("/pz/wms/Auditoria/AuditoriaAsignaUsuario_Ajax.asp", 
        { Tarea:2,Aud_ID:ijsAudID,Cli_ID:ijsCliID,Cli_Usu_ID:iValor,Poner:Poner
        },function(data) {
            //alert(data);
            //var iresul = parseInt(data);
            var response = JSON.parse(data);

            if (response.Resultado == 1) {
              sMensaje= "El usuario fue revocado correctamente";              
              Avisa("success",'Aviso',sMensaje);
            }

            if (response.Resultado == 2) {
              if(Poner == 1){
                sMensaje= "El usuario fue asignado como Supervisor correctamente";               
              } else {
                sMensaje= "El usuario fue revocado como Supervisor correctamente";
              }
              
              Avisa("success",'Aviso',sMensaje);
            }	
      
            if (response.Resultado == 0) {
              Avisa("error","Error",response.Error.message+ " " + response.Error.name);
            }	      
      
        });  

  }   
  
</script> 
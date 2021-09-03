<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   
  var bDebug = false
  var iBodID = Parametro("Bod_ID",-1)
  
   
%>  

  
<div class="wrapper">  
  <div class="row">
    <div class="col-md-12">
        <div class="table-responsive">
        <table class="table table-striped">
          <thead>
            <tr>
              <th class="text-center">&nbsp;</th>
              <th class="text-left">Producto</th>
              <!--th class="text-left"></th-->
            </tr>
          </thead>
          <tbody>
          <%

            var sSQL = "SELECT PRO.Pro_ID "
                sSQL += ",(ISNULL((SELECT 'checked' FROM Bodega_Producto BODPRO "
                sSQL += "WHERE BODPRO.Bod_ID = " + iBodID
                sSQL += " AND BODPRO.Pro_ID = PRO.Pro_ID),'')) AS Seleccionado "
                sSQL += ",(ISNULL((SELECT 'checked' FROM Bodega_Producto BODPRO "
                sSQL += "WHERE BODPRO.Bod_ID <> " + iBodID
                sSQL += " AND BODPRO.Pro_ID = PRO.Pro_ID),'')) AS SeleccEnOtro "
                sSQL += ",PRO.Pro_Nombre "
                sSQL += "FROM Producto PRO "
                sSQL += "WHERE PRO.Pro_EsInsumo = 1 "
                sSQL += "AND PRO.Pro_Habilitado = 1 "
                sSQL += "ORDER BY PRO.Pro_Nombre "         
             
               if (bDebug) { Response.Write(sSQL) }

               var sProID = -1
               var rsGral = AbreTabla(sSQL,1,0)

               var sCSSCheckI = ""
               var sCSSCheckII = ""
               var sCSSCheckIII = ""   

               while (!rsGral.EOF) {

                 var sChecked = ""
                 var sCheckedtmp = ""

                 if (!EsVacio(rsGral.Fields.Item("Seleccionado").Value)) {

                   sChecked = "checked='checked'"
                   sCheckedtmp = rsGral.Fields.Item("Seleccionado").Value

                 }

                 var sDisabledtmp = ""
                   
                 if (!EsVacio(rsGral.Fields.Item("SeleccEnOtro").Value)) {

                   sDisabledtmp = "checked='checked' disabled title='Seleccionado en otra bodega'"

                 }
                   
                   
                   
                 sProID = rsGral.Fields.Item("Pro_ID").Value
                 
              %>
            <tr>
              <td class="text-center">
                  <input type="checkbox" class="i-checks chkProID" <%=sChecked%> href="javascript:void(0)" data-proid="<%=sProID%>" data-checked="<%=sCheckedtmp%>" <%=sDisabledtmp%>>               
              </td>
              <td class="text-left">
                  <%Response.Write(rsGral.Fields.Item("Pro_Nombre").Value) %>
              </td>
            </tr>
            <%
             rsGral.MoveNext()
             }
             rsGral.Close()
            %>
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


}); 
  
  $(".chkProID").on('ifClicked', function(event){

      if( $(this).is(':checked') ){
        iChecado =0;	
      } else {
        iChecado =1;	
      }                             

      var iProID = $(this).attr("data-proid");
      sChecked = $(this).attr("data-checked");

      //alert(iArmID + " " + iChecado);
      //alert("Checado " + iChecado);                  
      GuardaChecks(iProID,iChecado);               

  });  
  
  function GuardaChecks(iValor,Checado) {

    var sMensaje = "";
    var Poner = 0;

    if (Checado==1) { Poner = 1 }	

    $.post("/pz/wms/Bodega/Bodega/AsignaProductoABodega_Ajax.asp", 
        { Tarea:1,Pro_ID:iValor,Poner:Poner,Bod_ID:$("#Bod_ID").val()
        },function(data) {
            //alert(data);
            //var iresul = parseInt(data);
            var response = JSON.parse(data);

            if (response.Resultado == 1) {
              sMensaje= "El producto fue revocado correctamente";              
              Avisa("success",'Aviso',sMensaje);
            }

            if (response.Resultado == 2) {
              sMensaje= "El producto fue asignado correctamente";               
              Avisa("success",'Aviso',sMensaje);
            }	
      
            if (response.Resultado == 0) {
              Avisa("error","Error",response.Error.message+ " " + response.Error.name);
            }	      
      
        });  

  }  
  
</script>  
  

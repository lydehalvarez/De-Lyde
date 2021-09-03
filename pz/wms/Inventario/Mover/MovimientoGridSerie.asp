<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
     
  var bIQ4Web = false
  var bVerLey = false 
  var iPtID = Parametro("Pt_ID",-1)
  var iMBNumero = Parametro("MB_Numero",-1)
  var iOpInvMovID = Parametro("OpInvMov_ID",-1)
  var iOpInvMovDMBCantidad = Parametro("OpInvMovD_MBCantidad",0) 

  var sSQLMBSer = "SELECT OPMD.OpInvMovD_ID, OPMD.Pt_ID, OPMD.OpInvMovD_MB, OPMD.Inv_ID,I.Inv_Serie "
      sSQLMBSer += ",CASE OpInvMovD_Seleccionado WHEN 1 THEN 'checked' WHEN 0 THEN '' ELSE '' END AS Seleccionado "
      sSQLMBSer += ",ISNULL(OPMD.OpInvMovD_MBCantidad,0) AS OpInvMovD_MBCantidad "
      sSQLMBSer += "FROM Operacion_Inventario_Movimiento_Detalle OPMD "
      sSQLMBSer += "JOIN Inventario I "
      sSQLMBSer += "ON I.Inv_ID = OPMD.Inv_ID "
      sSQLMBSer += "WHERE OPMD.OpInvMovD_Tipo = 4 "
      sSQLMBSer += " AND OPMD.OpInvMov_ID = "+ iOpInvMovID
      sSQLMBSer += " AND OPMD.Pt_ID = " + iPtID 
      sSQLMBSer += " AND OPMD.OpInvMovD_MB = " + iMBNumero
      sSQLMBSer += " ORDER BY OPMD.Ubi_ID ASC, OPMD.PT_ID ASC, OPMD.OpInvMovD_MB ASC, I.Inv_Serie ASC " 
   
      if(bIQ4Web){ Response.Write(sSQLMBSer) }
       //Response.End()
      if(bIQ4Web){ Response.Write("Total de Series por MasterBox...: " + iOpInvMovDMBCantidad) }
   
   
   
%>
<hr>

<div class="table-responsive">
  <table class="table table-striped no-margins cssGridSerie" id="Tabla<%=iPtID%>" data-mbnum="<%=iMBNumero%>" width="100%">
  <thead>
    <tr>
      <th class="text-success text-center">#</th>
      <th class="text-success text-left"><input type="checkbox" class="i-checks chkAllSerie" id="chkAllSerie<%=iPtID%><%=iMBNumero%>" data-isptid="<%=iPtID%>" data-mbnum="<%=iMBNumero%>" data-mbtot="<%=iOpInvMovDMBCantidad%>"><% if(bVerLey){ %> - chkAllSerie<% }%> </th>
      <th class="text-success text-center"><small>MasterBox&nbsp;</small><%=iMBNumero%> <i class="fa fa-cube fa-lg text-success"></i><input type="hidden" name="CantTotalSeriePorMB" id="CantTotalSeriePorMB" value="<%=iOpInvMovDMBCantidad%>"></th>
    </tr>
  </thead>
  <tbody>
    <%
      var rsMBSer = AbreTabla(sSQLMBSer,1,0)
      var iOpInvMovD_ID = -1
      var sSerSerie = ""
      var iReg = 0
      var iInv_ID = -1
       
        while(!rsMBSer.EOF){
          iReg++
          sSerSerie = rsMBSer.Fields.Item("Inv_Serie").Value
          iOpInvMovD_ID = rsMBSer.Fields.Item("OpInvMovD_ID").Value
          iInv_ID = rsMBSer.Fields.Item("Inv_ID").Value
          
          var sChecked = ""
          var sCheckedtmp = ""

          if (!EsVacio(rsMBSer.Fields.Item("Seleccionado").Value)) {

           sChecked = "checked='checked'"
           sCheckedtmp = rsMBSer.Fields.Item("Seleccionado").Value

          }         
          
    %>   
    <tr>
      <td class="text-center"><%=iReg%></td>
      <td class="text-left"><a title="<%=iInv_ID%>" data-clipboard-text="<%=sSerSerie%>" class="textCopy"><small><%=sSerSerie%></small></a></td>
      <td class="text-center">
        <input type="checkbox" class="i-checks chkSerie" id="chkSerie<%=iInv_ID%>" <%=sChecked%> href="javascript:void(0)" data-isptid="<%=iPtID%>" data-mbnum="<%=iMBNumero%>" data-opinvmovdid="<%=iOpInvMovD_ID%>" data-checked="<%=sCheckedtmp%>" data-invid="<%=iInv_ID%>"><% if(bVerLey){ %> - chkSerie<% }%>
      </td>
    </tr>
	<% 

          rsMBSer.MoveNext()
        } 
    rsMBSer.Close()
 
	%>     
  </tbody>
  </table>
</div>

<script type="text/javascript">
  
  //console.log(document.getElementById("uploadPreview"));
  //return $toastlast;
  var $toast = "" //toastr[shortCutFunction](msg, title);
  $toastlast = $toast;
  
  function getLastToast(){
      return $toastlast;
  }
  
  getLastToast();
  /*$('#clearlasttoast').click(function () {
      toastr.clear(getLastToast());
  });*/
  
  var sMensaje = "";
  
  $(document).ready(function() {
    
    /*
    $('.i-checks').iCheck({
      checkboxClass: 'icheckbox_square-green'
    });
    */
    
    var iOpInvMovID = -1;
    var sChecked = "";
    var iChecado = 0;
    var isPtID = -1;
    var iPtID = -1;
    
    var iTotalSerie = 0
    var iTotalSerieCheck = 0;
    var iTotalchkPtlS = 0;
    var iTotalchkPtlCheckS = 0;
    
    var iInvID = -1;
    
    var iTotalDSeriesSelec = 0;
    var iMBNum = 0;
    var iTotMB = 0;
    
    //Juego del checkbox general del MasterBox en vista
    $(".chkAllSerie").change(function() {
      
        iPtID = $(this).data('isptid');
        iMBNum = $(this).data('mbnum');
        iTotMB = $(this).data('mbtot');
      
      if($(this).is(":checked")) {    //Check - chkAllSerie
        //console.log("data-isptid: " + iPtID);
        //$(".chkSerie").prop("checked", true);
        $("#divGridSerie"+iPtID+" #Tabla"+iPtID + " .chkSerie").prop("checked", true);
        //$("#Tabla"+isPtID + " .chkSerie").prop("checked", true);
        iChecado = 1;
        
        iOpInvMovID = $("#OpInvMov_ID").val();
        //console.log("iChecado: " + iChecado + " | data-isptid: " + iPtID + " | data-mbnum: " + iMBNum + " | OpInvMov_ID: " + iOpInvMovID);
        
        MarcarTodasLasSeriesMB(iPtID,iMBNum,iChecado);
        //MarcarTodo(iOpInvMovID,iChecado,1);
        VerificaCantidad(iPtID,iTotMB,iChecado);
        
        if($("#Pt_Cantidad_Actual"+iPtID).val() == $("#CantDSeriesAMov"+iPtID).val()){
          $("#dvdEsTotal"+iPtID).html("<span class='label label-primary'>Total</span>");
          $("#OpInvMovD_EsTotal"+iPtID).val(1);
        }        
        
      } else {  //Uncheck - chkAllSerie

        //$(".chkSerie").prop("checked", false);
        $("#divGridSerie"+iPtID+" #Tabla"+iPtID + " .chkSerie").prop("checked", false);
        //$("#Tabla"+isPtID + " .chkSerie").prop("checked", false);
        iChecado = 0;
        
        iOpInvMovID = $("#OpInvMov_ID").val();
        //console.log("iChecado: " + iChecado + " | data-isptid: " + iPtID + " | data-mbnum: " + iMBNum + " | OpInvMov_ID: " + iOpInvMovID);
        
        MarcarTodasLasSeriesMB(iPtID,iMBNum,iChecado);        
        VerificaCantidad(iPtID,iTotMB,iChecado);
        
        $("#dvdEsTotal"+iPtID).html("<span class='label label-warning-light'>Parcial</span>");
        $("#OpInvMovD_EsTotal"+iPtID).val(0);
        
      }
                         
                         
    });
    
    
    function MarcarTodasLasSeriesMB(ijqPtID,iValor,Checado){
      
      var Poner = 0;

      if (Checado==1) { Poner = 1 }	      
      
      $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp", 
          { Tarea:8,OpInvMov_ID:$("#OpInvMov_ID").val(),Pt_ID:ijqPtID,OpInvMovD_MB:iValor,Poner:Poner
          },function(data) {
              //alert(data);
              var response = JSON.parse(data);
        
              if (response.Resultado == 1) {
                sMensaje= "El total de Series del MasterBox fueron excluidos correctamente";              
                Avisa("success",'Aviso',sMensaje);
              }

              if (response.Resultado == 2) {
                sMensaje= "El total de Series del MasterBox fueron seleccionados correctamente";               
                Avisa("success",'Aviso',sMensaje);
              }	
        
              if (response.Resultado == 0) {
                Avisa("error","Error",response.Error.message+ " " + response.Error.name);              
              }
        
          });        
      
    }
    
             
    function VerificaCantidad(ijsPtID,ijsTotMB,ijsChecado){
    
      var iTotSerMB = 0;
        iTotSerMB = ijsTotMB;
        //console.log("#CantDSeriesAMov"+ijsPtID + " : " + $("#CantDSeriesAMov"+ijsPtID).val());
      if(ijsChecado == 1){
        iTotSerMB = parseInt($("#CantDSeriesAMov"+ijsPtID).val()) + iTotSerMB;
        $("#CantDSeriesAMov"+ijsPtID).val(iTotSerMB);
      } else {
        iTotSerMB = parseInt($("#CantDSeriesAMov"+ijsPtID).val()) - iTotSerMB;
        $("#CantDSeriesAMov"+ijsPtID).val(iTotSerMB);
      }
      
    }

    
    //Checkbox de las series
    $(".chkSerie").change(function() { 
      
        isPtID = $(this).data('isptid');
        iMBNum = $(this).data('mbnum');
        iInvID = $(this).data('invid');  
        
        iOpInvMovID = $("#OpInvMov_ID").val();
        
      if($(this).is(":checked")) { //Check - chkSerie
        
        //console.log("Serie checada");

        iChecado = 1;  
        
        MarcarSerieSelec(isPtID,iMBNum,iInvID,iChecado);
        
        //iTotalSerie = $(".chkSerie").length;
        iTotalSerie = $("#divGridSerie"+isPtID+" #Tabla"+isPtID).find(".chkSerie").length;
        //iTotalSerieCheck = $(".chkSerie:checked").length;
        iTotalSerieCheck = $("#divGridSerie"+isPtID+" #Tabla"+isPtID).find(".chkSerie:checked").length;
        
        //console.log("Total de checks por pallet Pt_ID: = " + iTotalSerie);
        //console.log("Total de checks por pallet Pt_ID checados : = " + iTotalSerieCheck);         
        
        if(iTotalSerie == iTotalSerieCheck){
          //Checamos el total de la series del masterbox chkAllSerie
          //console.log("Checamos el check del MB general");
          //console.log("PtID: "+ isPtID + " | NumMB: " + iMBNum);
          //$("#divGridResultado").find("div label div input#chkAllPallets").iCheck("check");
          $("#chkAllSerie"+isPtID+iMBNum).prop("checked", true);
          
        }
        
        //===== Manejo del incremento de las series seleccionadas {start}
        var iTotalPallet = parseInt($("#CantDSeriesAMov"+isPtID).val());
        //console.log(" Total de series seleccionadas del Pallet: " + iTotalPallet);
        iTotalDSeriesSelec = iTotalPallet + 1;
        $("#CantDSeriesAMov"+isPtID).val(iTotalDSeriesSelec);
        //console.log("Valor de campo oculto total [+]:" + $("#CantDSeriesAMov"+isPtID).val());
        //$("#CantDSeriesAMov"+isPtID).val(iTotalDSeriesSelec);
        //===== Manejo del incremento de las series seleccionadas {end}

        //===== Manejo del tipo de movimiento de las series seleccionadas {start}
        if($("#Pt_Cantidad_Actual"+isPtID).val() == $("#CantDSeriesAMov"+isPtID).val()){
          $("#dvdEsTotal"+isPtID).html("<span class='label label-primary'>Total</span>");
          $("#OpInvMovD_EsTotal"+isPtID).val(1);
        }
        //===== Manejo del tipo de movimiento de las series seleccionadas {end}
        
      } else {
        
        //console.log("Serie NO checada");
        
        iChecado = 0;        
        
        MarcarSerieSelec(isPtID,iMBNum,iInvID,iChecado);
        
        $("#chkAllSerie"+isPtID+iMBNum).prop("checked", false);

        //===== Manejo del decremento de las series seleccionadas {start}
        var iTotalPallet = parseInt($("#CantDSeriesAMov"+isPtID).val());
        //console.log(" Total de series seleccionadas del Pallet: " + iTotalPallet);
        iTotalDSeriesSelec = parseInt(iTotalPallet-1);
        //console.log("restamos: " + iTotalDSeriesSelec);
        $("#CantDSeriesAMov"+isPtID).val(iTotalDSeriesSelec);
        //console.log("Valor de campo oculto total [-]:" + $("#CantDSeriesAMov"+isPtID).val());
        //$("#CantDSeriesAMov"+isPtID).val(iTotalDSeriesSelec);
        //===== Manejo del decremento de las series seleccionadas {end}      
        //===== Manejo del tipo de movimiento de las series seleccionadas {start}
        if($("#Pt_Cantidad_Actual"+isPtID).val() != $("#CantDSeriesAMov"+isPtID).val()){
          $("#dvdEsTotal"+isPtID).html("<span class='label label-warning-light'>Parcial</span>");
          $("#OpInvMovD_EsTotal"+isPtID).val(0);
        }
        //===== Manejo del tipo de movimiento de las series seleccionadas {end}            
        
      }
      
      
    });
    
    function MarcarSerieSelec(ijqPtID,ijqMBNum,iValor,Checado) {

      var Poner = 0;

      if (Checado==1) { Poner = 1 }	

      $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp", 
          { Tarea:5,OpInvMov_ID:$("#OpInvMov_ID").val(),OpInvMovD_MB:ijqMBNum,Inv_ID:iValor,Poner:Poner
          },function(data) {
              //alert(data);
              var response = JSON.parse(data);
        
              if (response.Resultado == 1) {
                sMensaje= "La serie fue eliminada de la selecci&oacute;n correctamente";              
                Avisa("success",'Aviso',sMensaje);
              }

              if (response.Resultado == 2) {
                sMensaje= "La serie fue seleccionada correctamente";               
                Avisa("success",'Aviso',sMensaje);
              }	
        
              if (response.Resultado == 0) {
                Avisa("error","Error",response.Error.message+ " " + response.Error.name);              
              }
        
          });  

    }   

    function VerificaAllSerie(){
      
      var ijqPtID = <%=iPtID%>;
      //console.log("Pallet: " + ijqPtID);
      var iMBNum = <%=iMBNumero%>;
      //console.log("Pallet: " + ijqPtID + " | iMBNum:" + iMBNum);
      
      //Si el chkAllPallets esta activo se activa el chkPtID y el chkAllSerie
      //1.- SI chkAllPallets es checado; el chkAllSerie se checa
      if( $('.chkAllPallets').prop('checked') ) {
      
        $(".chkAllSerie").prop("checked", true);
         
      }
      //2.- SI #chkPtID es checado, el chkAllSerie se checa
      if( $("#chkPtID"+ijqPtID).prop('checked') ) {
        
        $("#chkAllSerie"+ijqPtID+iMBNum).prop("checked", true);
        
      }
      
    }
    
    VerificaAllSerie();
    VerificaTotalSerie();
    
  });

  function VerificaTotalSerie(){
    //La uso solamente para verificar cuando se carga por primera vez el Master Box con todas sus series
    var iPtID = <%=iPtID%>;
    var iMBNUM = <%=iMBNumero%>;
    //1.- Verifico el total de SeriesChecadas
    var iTotalSeriesChequeados = 0
    //$(".chkSerie:checked").length;
      //console.log("Pt_ID: " + iPtID);
      iTotalSeriesChequeados = $("#divGridSerie"+iPtID+" #Tabla"+iPtID).find(".chkSerie:checked").length;
      //console.log("Total de Series chequeados: " + iTotalSeriesChequeados);
      if($("#CantTotalSeriePorMB",0).val() == iTotalSeriesChequeados){
        
        $("#chkAllSerie"+iPtID+iMBNUM).prop("checked", true);
        
      }
    
  }
  


  
  
  
</script>  
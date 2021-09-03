<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var bIQ4Web = false
   
  var Pt_ID = Parametro("Pt_ID",-1)
  var TipoBusq = Parametro("TipoBusq",-1)
  var OpInvMov_ID = Parametro("OpInvMov_ID",-1)

  if(bIQ4Web){ Response.Write("Pt_ID: " + Pt_ID + " | TipoBusq: " + TipoBusq + " | OpInvMov_ID: " + OpInvMov_ID) }

  var sSQLMB  = "SELECT Pt_ID, OpInvMovD_MB, OpInvMovD_MBCantidad "
      sSQLMB += "FROM Operacion_Inventario_Movimiento_Detalle OPMD "
      sSQLMB += "WHERE OPMD.Pt_ID = " + Pt_ID
      sSQLMB += " AND OPMD.OpInvMovD_Tipo = 3 "
      sSQLMB += " AND OPMD.OpInvMov_ID = "+ OpInvMov_ID
      sSQLMB += " ORDER BY OpInvMovD_MB "   
   

      if(bIQ4Web){ Response.Write("<br>sSQLMB: "+sSQLMB) }
        
   
%>
<hr>
<div class="ibox">
  <!--div class="ibox-content"-->
    <div class="m-t text-righ">
      <%
        var rsMB = AbreTabla(sSQLMB,1,0)
        var iReg = 0
        var iMBNum = 0
        var iMBCant = 0
        var irowshort = 4
        var iResParr = 0
        var iPtMasNumMB = 0
         
            while(!rsMB.EOF){
              iReg++
              iMBNum = rsMB.Fields.Item("OpInvMovD_MB").Value      
              iMBCant = rsMB.Fields.Item("OpInvMovD_MBCantidad").Value 
              iResParr = iReg%irowshort
              iPtMasNumMB = 0
              iPtMasNumMB = parseInt(Pt_ID+iMBNum)
               
      %>
      <button data-toggle="button" type="button" class="btn btn-xs btn-white btnVerSerie" id="btnVerSerie<%=iPtMasNumMB%>" data-ptid="<%=Pt_ID%>" data-nummb="<%=iMBNum%>" data-totsermb="<%=iMBCant%>" aria-pressed="false"><i class="fa fa-chevron-down"></i> - <i class="fa fa-cube"></i> MB <%=iMBNum%> - <%=iMBCant%></button>
      <button data-toggle="button" type="button" class="btn btn-xs btn-white btnCerrarVerSerie" id="btnCerrarVerSerie<%=iPtMasNumMB%>" data-ptid="<%=Pt_ID%>" data-nummb="<%=iMBNum%>" data-totsermb="<%=iMBCant%>" aria-pressed="false"><i class="fa fa-chevron-up"></i> - <i class="fa fa-cube"></i> MB <%=iMBNum%> - <%=iMBCant%></button>
      <input type="hidden" name="divCajaMB" id="divCajaMB" value="1">  
      <% 

              if(iResParr == 0) {
                Response.Write("<p></p>")
              }

              rsMB.MoveNext()

            } 
        rsMB.Close()

      %>   
    </div>
 <!--/div-->     
</div>
<script type="text/javascript" language="javascript">

  var loading = '<div class="spiner-example">'+
          '<div class="sk-spinner sk-spinner-three-bounce">'+
            '<div class="sk-bounce1"></div>'+
            '<div class="sk-bounce2"></div>'+
            '<div class="sk-bounce3"></div>'+
          '</div>'+
        '</div>'+
        '<div>Cargando informaci&oacute;n, espere un momento...</div>'   
  
  $(document).ready(function() { 

    var sMensaje = "";
    
    $('.btnCerrarVerSerie').hide();

    $(".btnVerSerie").click(function(e){
      e.preventDefault();
      
      $(this).hide('slow');
      
      var iPtID = $(this).data('ptid');
      var iMBNum = $(this).data('nummb');
      var iTotSerMB = $(this).data('totsermb');
      var iOpInvMovID = $("#OpInvMov_ID").val();
      var iMBSelecc = $("#divGridMasterBox"+iPtID+" #divCajaMB").val();
      
      //console.log("Pt_ID: " + iPtID + " | Numero de MB: " + iMBNum + " | Total de Serie en-MB: " + iTotSerMB + " | Valor estando en la caja: " + iMBSelecc);

      var sbtncomp = iPtID+""+iMBNum;
      //console.log("sbtncomp: " + sbtncomp);
      
      if(iMBSelecc != iMBNum){
        //console.log("iMBSelecc: " + iMBSelecc + " | iMBNum: " + iMBNum);
        $("#divGridMasterBox"+iPtID+" #btnCerrarVerSerie"+iPtID+""+iMBSelecc).hide();
        //console.log("iPtID: " + iPtID + " | iMBSelecc: " + iMBSelecc);
        $("#divGridMasterBox"+iPtID+" #btnVerSerie"+iPtID+""+iMBSelecc).show();
        
        $("#divGridMasterBox"+iPtID+" #divCajaMB").val(iMBNum);
        //$("#divGridSerie"+iPtID).attr("data-mbselec",iMBNum);
        $('#divGridSerie'+iPtID).empty();
        //$('#divGridSerie'+iPtID).html(""); 
        
      }
      
      $("#divGridMasterBox"+iPtID+" #btnCerrarVerSerie"+sbtncomp).show('slow');
            
      CargarSerie(iPtID,iMBNum,iOpInvMovID,iTotSerMB);
      
    });
    
    
/*=============== JD =====================================*/ 
    
    $('.btnCerrarVerSerie').click(function(e) {
      e.preventDefault();
      
      $(this).hide('slow');
      
      var iPtID = $(this).data('ptid');
      var iMBNum = $(this).data('nummb');
      var iOpInvMovID = $("#OpInvMov_ID").val();
      //console.log("Pt_ID: " + iPtID + " | MB_Numero: " + iMBNum);
      var sbtncomp = iPtID+""+iMBNum;
      //console.log("sbtncomp: " + sbtncomp);
      
      $("#divGridMasterBox"+iPtID+" #btnVerSerie"+sbtncomp).show('slow');
      
      $("#divGridMasterBox"+iPtID+" #btnCerrarVerSerie"+sbtncomp).hide('slow');
          
      setTimeout(function(){
        //$("#divGridSerie"+iPtID).empty();
        $("#divGridSerie"+iPtID).html(loading);
        $('#divGridSerie'+iPtID).html("");
      },800);
      
    });     

    
  });
  
  function CargarSerie(ijqPtID,ijqMBNum,iOpInvMovID,ijqTotSerMB) {
      var datos = {
          Pt_ID:ijqPtID,
          MB_Numero:ijqMBNum,
          OpInvMov_ID:iOpInvMovID,
          OpInvMovD_MBCantidad:ijqTotSerMB
      }
      //console.log("Datos: "+ datos);
      //$("#divGridSerie"+ijqPtID).empty();
      $("#divGridSerie"+ijqPtID).html(loading);
      $("#divGridSerie"+ijqPtID).load("/pz/wms/Inventario/Mover/MovimientoGridSerie.asp",datos);

  }     
    
    
</script>

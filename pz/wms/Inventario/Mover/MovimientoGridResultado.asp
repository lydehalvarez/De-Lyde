<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var bIQ4Web = true
   
  var bVerLey = false

  var iTipoSelec = Parametro("TipoSeleccion",-1)
  var iUsuID = Parametro("IDUsuario",-1) 
  var iOpInvMov_ID = Parametro("OpInvMov_ID",-1) //62
  //var stxtSeries = Parametro("Series","355903114882125")  //@sBuscarSerie
 
  var sSqlI =  "SELECT P.Pro_Nombre, P.Pro_ID "   
      sSqlI += ",OPMD.Pt_ID, OPMD.OpInvMovD_Error, P.Pro_SKU "
      sSqlI += ",PA.Pt_LPN, U.Ubi_Nombre, PA.Pt_Cantidad_Actual, U.Ubi_ID " 
      sSqlI += "FROM Operacion_Inventario_Movimiento_Detalle OPMD "
      sSqlI += "JOIN Producto P "
      sSqlI += "ON OPMD.Pro_ID = P.Pro_ID "
      sSqlI += "JOIN Pallet PA "
      sSqlI += "ON OPMD.Pt_ID = PA.Pt_ID "
      sSqlI += "JOIN Ubicacion U "
      sSqlI += "ON OPMD.Ubi_ID = U.Ubi_ID "
		  sSqlI += "WHERE OPMD.OpInvMovD_Tipo = 2 "
		  sSqlI += "AND OPMD.OpInvMov_ID = "+ iOpInvMov_ID
      sSqlI += " ORDER BY P.Pro_SKU"
   
   
%>


<div class="input-group">
  <label> <input type="checkbox" class="i-checks chkAllPallets" id="chkAllPallets"> <span class="text-navy">Seleccionar todos <% if(bVerLey){ %> - chkAllPallets<% }%></span></label>
</div>
<ul class="sortable-list connectList agile-list" id="todo">
  
<!--Muestra las series que no se localizaron {start}-->  
<%
  var sSQLError = "SELECT MOVDET.OpInvMov_Serie FROM Operacion_Inventario_Movimiento_Detalle MOVDET "
      sSQLError += "WHERE MOVDET.OpInvMovD_Tipo = 1 "
		  sSQLError += "AND MOVDET.OpInvMov_ID = "+ iOpInvMov_ID
      sSQLError += " AND MOVDET.OpInvMovD_Error > 0 "
   
   //   if(bIQ4Web){ Response.Write("<br>"+sSQLError) }     
      var icontReg = 0
      var iNumImp = 0
      var rsErr = AbreTabla(sSQLError,1,0)
      if(!rsErr.EOF){
        
   
%>
  
<li class="danger-element" id="task0">
    <h4><i class="fa fa-times-circle text-danger"> Series no localizadas</i></h4>
    <div class="agile-detail">
      <div class="row m-t-sm">
        <div class="col-sm-12">
          <table class="table table-hover no-margins">
            <thead>
              <tr>
                  <th>#</th>
                  <th>Serie</th>
                  <!--th>#</th>
                  <th>Serie</th-->                
              </tr>
            </thead>
            <tbody>
              <%  
                  var irowsh = 2
                  var irowPrint = 0
                  while(!rsErr.EOF){
                  icontReg++
                  //irowPrint = icontReg%irowsh
              %>
              <tr>
                  <td class="text-danger"><strong><%=icontReg%></strong></td>
                  <td class="text-danger"><a title="<%=rsErr.Fields.Item("OpInvMov_Serie").Value%>" data-clipboard-text="<%=rsErr.Fields.Item("OpInvMov_Serie").Value%>" class="textCopy"><%=rsErr.Fields.Item("OpInvMov_Serie").Value%></a></td>
                  <!--td></td>
                  <td></td-->
              </tr>
              <%  rsErr.MoveNext()
                  } 
              %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
</li>
<!--Muestra las series que no se localizaron {start}-->  
<% 
    } 
     rsErr.Close()
     
%>
<!--Muestra las series que no se localizaron {end}-->  
<!--Muestra las series localizadas {start}-->    
<%
    var iPtID = -1
    var sPtID = ""
   
    var iRegistros = 0
    var sCondMB = ""     
    var iTotalMB = 0 
    var iTotalGralMB = 0
    var iTotalSerSelec = 0
    var sPtls = ""
     
  //  if(bIQ4Web){ Response.Write("<br>sSqlI<br>"+sSqlI) }     

    var rsI = AbreTabla(sSqlI,1,0)   
   
		while(!rsI.EOF){

      iPtID = rsI.Fields.Item("Pt_ID").Value
      iRegistros++

      sPtID = "data-ptid='"+iPtID+"'"
      iTotalGralMB = 0      
      iTotalGralMB = BuscaSoloUnDato("SUM(OpInvMovD_MBCantidad)","Operacion_Inventario_Movimiento_Detalle","Pt_ID ="+iPtID +"AND OpInvMov_ID = "+ iOpInvMov_ID,0,0)
      //Esto es cuando se da clic al checkbox
      sCondTotalSerSelec = " OpInvMov_ID = "+iOpInvMov_ID+" AND OpInvMovD_Tipo = 4 AND OpInvMovD_Seleccionado = 1 AND Pt_ID = "+iPtID
      //iTotalSerSelec = BuscaSoloUnDato("COUNT(*)","Operacion_Inventario_Movimiento_Detalle",sCondTotalSerSelec,0,0)
      if(sPtls != ""){ 
        sPtls += ","
      }
      sPtls += iPtID     
   
      iProID = rsI.Fields.Item("Pro_ID").Value
   
%> 
  <li class="success-element cssControl<%=iPtID%> csstask" id="task<%=iPtID%>" data-ptid="<%=iPtID%>">
    <div class="ibox">
      <div class="ibox-title" style="border-style:inherit">
        <h5 class="text-success"><i class="fa fa-codepen"></i> LPN: <a title="<%=iPtID%>" data-clipboard-text="<%=rsI.Fields.Item("Pt_LPN").Value%>" class="textCopy tooltip-demo"><%=rsI.Fields.Item("Pt_LPN").Value%></a></h5>&nbsp;&nbsp;<label class="font-bold text-navy"><!--i-checks-->
        <input type="checkbox" class="i-checks chkPtID" id="chkPtID<%=iPtID%>" value="<%=iPtID%>" data-ptid="<%=iPtID%>">
        &nbsp;&nbsp;<% if(bVerLey){ Response.Write(iPtID)  %> - chkPtIDs<% }%>
        </label> 
        <label class="pull-right"> 
          
          <button class="btn btn-default btn-xs btnSeleccionar" id="btnSeleccionar<%=iPtID%>" data-ptid="<%=iPtID%>" type="button">Seleccionar <i class="fa fa-share"></i></button>
          <button class="btn btn-default btn-xs btnLimpiar" id="btnLimpiar<%=iPtID%>" data-ptid="<%=iPtID%>" type="button" style="display: none">Limpiar <i class="fa fa-trash"></i></button>
          <button class="btn btn-default btn-xs btnRegresar" id="btnRegresar<%=iPtID%>" data-ptid="<%=iPtID%>" type="button" style="display: none">Quitar <i class="fa fa-reply"></i></button>          
        </label>
      </div>
      <div class="ibox-content">
        <div class="team-members">
          <div id="divDecisiones<%=iPtID%>">
            
          </div>
          <p></p>
          <hr class="hr-line-dashed">
          <h5><i class="fa fa-map-marker text-navy"> UBICACI&Oacute;N:</i> <a title="<%=rsI.Fields.Item("Ubi_ID").Value%>" data-clipboard-text="<%=rsI.Fields.Item("Ubi_Nombre").Value%>" class="textCopy"><%=rsI.Fields.Item("Ubi_Nombre").Value%></a> </h5>
          <p></p>
          <h5><i class="fa fa-dropbox text-navy"> PRODUCTO:</i><cite> <abbr><a title="<%=iProID%>" data-clipboard-text="<%=rsI.Fields.Item("Pro_SKU").Value%>" class="textCopy"><%=rsI.Fields.Item("Pro_SKU").Value%></a></abbr> <%=rsI.Fields.Item("Pro_Nombre").Value%></cite></h5>
        </div>
        <div>
          <div class="stat-percent"></div>
          <div class="progress progress-mini progress-striped active" style="height: 3px;">
            <div class="progress-bar" style="width:100%;"></div>
          </div>
        </div>
        <div class="row m-t-sm">
          <div class="col-sm-4">
            <%
            sCondMB = "Pt_ID = "+iPtID+" AND OpInvMovD_Tipo = 3 AND OpInvMov_ID ="+iOpInvMov_ID 
            iTotalMB = BuscaSoloUnDato("COUNT(OpInvMovD_MB)","Operacion_Inventario_Movimiento_Detalle",sCondMB,0,0)
            %>
            <div class="font-bold">
              <small>Total de Master Box</small>
            </div>
              <button type="button" class="btn btn-xs btn-outline btn-primary btnMB btnAbrirMasterBox" <%=sPtID%> id="btnAbrirMasterBox<%=iPtID%>"><i class="fa fa-chevron-down"></i> - <i class="fa fa-cubes"></i> MB - <%=iTotalMB%></button>
              <button type="button" class="btn btn-xs btn-outline btn-success btnMB btnCerrarMasterBox" <%=sPtID%> id="btnCerrarMasterBox<%=iPtID%>"><i class="fa fa-chevron-up"></i> - <i class="fa fa-cubes"></i> MB - <%=iTotalMB%></button>
              <small><%=iTotalGralMB%></small><input type="hidden" name="TotalGralMB" class="cssTotalGralMB" id="TotalGralMB<%=iPtID%>" value="<%=iTotalGralMB%>">
          </div> 
          <div class="col-sm-4">
            <div class="font-bold">
              <small>Tipo de Movimiento</small>
            </div>
            <div id="dvdEsTotal<%=iPtID%>"><span class="label label-warning-light">Parcial</span></div>
            <input type="hidden" name="OpInvMovD_EsTotal" id="OpInvMovD_EsTotal" value="0">
          </div> 
          <div class="col-sm-4 text-right">
            <div class="font-bold">
            <small>Cantidad</small>
            </div><input type="input" class="form-control-xs" id="CantDSeriesAMov<%=iPtID%>" style="border-color:#1ab394; border: 0;" value="<%=iTotalSerSelec%>" size="
              2" readonly>/ <%=rsI.Fields.Item("Pt_Cantidad_Actual").Value%><input type="hidden" name="Pt_Cantidad_Actual" id="Pt_Cantidad_Actual<%=iPtID%>" value="<%=rsI.Fields.Item("Pt_Cantidad_Actual").Value%>"><input type="hidden" name="CantTotalSerieSelecPallet" id="CantTotalSerieSelecPallet<%=iPtID%>" value="0"><!--i class="fa fa-level-up text-navy"></i--> 
          </div>
        </div>
        <div class="row m-t-sm">
          <div class="col-sm-4">
            <div class="input-group-btn btn-xs">
                <button type="button" data-toggle="dropdown" class="btn btn-primary btn-xs dropdown-toggle">Master Box <span class="caret"></span></button>
                <ul class="dropdown-menu">
                    <li><input type="checkbox" class="i-checks chkMB" id="" href="javascript:void(0)"><small>&nbsp;MB 1 - 28</small></li>
                    <li><input type="checkbox" class="i-checks chkMB" id="" href="javascript:void(0)"><small>&nbsp;MB 2 - 20</small></li>
                    <li><input type="checkbox" class="i-checks chkMB" id="" href="javascript:void(0)"><small>&nbsp;MB 3 - 19</small></li>
                    <li><input type="checkbox" class="i-checks chkMB" id="" href="javascript:void(0)"><small>&nbsp;MB 4 - 20</small></li>
                    <li><input type="checkbox" class="i-checks chkMB" id="" href="javascript:void(0)"><small>&nbsp;MB 5 - 19</small></li>
                </ul>
            </div>
          </div>
        </div>
        <hr>      
      </div>                            
    </div>
    <div id="divGridMasterBox<%=iPtID%>"></div>
    
    <div id="divGridSerie<%=iPtID%>"></div>            
  </li>
  
	<% 
            rsI.MoveNext()
        } 
    rsI.Close()
 
	%>
  <input type="hidden" name="Ptls" id="Ptls" value="<%=sPtls%>">
<!--Muestra las series localizadas {end}-->
</ul>
            
<!-- jquery UI -->
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>            
            

<script type="text/javascript">

  var loading = '<div class="spiner-example">'+
          '<div class="sk-spinner sk-spinner-three-bounce">'+
            '<div class="sk-bounce1"></div>'+
            '<div class="sk-bounce2"></div>'+
            '<div class="sk-bounce3"></div>'+
          '</div>'+
        '</div>'+
        '<div>Cargando informaci&oacute;n, espere un momento...</div>'  
  
  $(document).ready(function() {    

    //$('.chosen-select').chosen({width: "100%"});
    
    $('.btnCerrarMasterBox').hide();
    
    /*
    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    
    */
    
    /*
    $('.i-checks').iCheck({
      checkboxClass: 'icheckbox_square-green',
      radioClass: 'iradio_square-green'
    });    
    */
    
    $(".btnLimpiar").click(function(e){
      e.preventDefault();
      var iPtID = $(this).data('ptid');
      $("#task"+iPtID).remove();
    });
      
    $(".btnAbrirMasterBox").click(function(e){
      e.preventDefault();
      
      $(this).hide('slow');
      
      var iPtID = $(this).data('ptid');
      //console.log("Pt_ID: " + iPtID);
      $('#btnCerrarMasterBox'+iPtID).show('slow');
      CargarMasterBox(iPtID);
      
    }); 
    
    $('.btnCerrarMasterBox').click(function(e) {
      e.preventDefault();
      
      $(this).hide('slow');
      
      var iPtID = $(this).data('ptid');
      
      $('#btnAbrirMasterBox'+iPtID).show('slow');
      $('#btnCerrarMasterBox'+iPtID).hide('slow');
      
      setTimeout(function(){
        
        $('#divGridSerie'+iPtID).empty();
        $("#divGridSerie"+iPtID).html(loading);
        $('#divGridSerie'+iPtID).html("");
        
        $('#divGridMasterBox'+iPtID).empty();
        $("#divGridMasterBox"+iPtID).html(loading);
        $('#divGridMasterBox'+iPtID).html("");
        
      },800);
      
    });      
    
      
    $('.btnSeleccionar').click(function(event){
      event.preventDefault();
      var iPtID = $(this).data('ptid');
      //var Obj = $(this);
      //var iTask = $(this).data('task');
      if(ValidaSeleccion(iPtID)){
        
        //console.log("ptid: " + iPtID);
        $(event.target).closest('li').detach().appendTo('#inprogress');
        //$(event.target).closest('li').detach().prepend('#inprogress');
        $('#btnSeleccionar'+iPtID).hide('slow');
        $('#btnRegresar'+iPtID).show('slow');
        //Cambios JD
        $("#btnLimpiarLPNs").prop('disabled', false);
        //Busca el estilo indicado dentro de hasClass = regresa true o false
        if ($("#ulListadoPallets a > i").hasClass("fa fa-chevron-up")){
          $('.collapse-link').trigger("click");
        }
        
        LevantaOcultaDecisiones(iPtID,1);
        
      }
                               
    });      

    
    $('.btnRegresar').click(function(event){
      event.preventDefault();
      //var Obj = $(this);
      //var iTask = $(this).data('task');
      var iPtID = $(this).data('ptid');
      //console.log("ptid: " + iPtID);
      $(event.target).closest('li').detach().appendTo('#todo');
      //$(event.target).closest('li').detach().prepend('#todo');
      $('#btnRegresar'+iPtID).hide('slow');
      $('#btnSeleccionar'+iPtID).show('slow');
      var iExisListPalletSelec = $("#inprogress li").length;
      //console.log(iExisListPalletSelec);
      if(iExisListPalletSelec === 0){
        $("#btnLimpiarLPNs").prop('disabled', true);
      }
      LevantaOcultaDecisiones(iPtID,0);
      
    });       

    function LevantaOcultaDecisiones(ijqPtID,ijqOpc){
      
      var sDatos = {
          Pt_ID:ijqPtID,
          OpInvMov_ID:$("#OpInvMov_ID").val(),
          Ubi_ID:$("#DestUbi_ID").val()
      }
      
      if(ijqOpc == 0){
        $("#divDecisiones"+ijqPtID).empty();
      }
      if(ijqOpc == 1){
        $("#divDecisiones"+ijqPtID).load("/pz/wms/Inventario/Mover/MovimientoDecisiones.asp",sDatos);
      }
      
    }
    
    function CargarMasterBox(ijqPtID) {
        //console.log("#cboTipoBusqueda: "+$("#cboTipoBusqueda").val() );
        var datos = {
            Pt_ID:ijqPtID,
            TipoBusq:$("#cboTipoBusqueda").val(),
            OpInvMov_ID:$("#OpInvMov_ID").val()
        }
        //console.log("datos: " + datos);
        //$("#divGridMasterBox"+ijqPtID).empty();
        //$("#divGridMasterBox"+ijqPtID).html(loading);
        $("#divGridMasterBox"+ijqPtID).load("/pz/wms/Inventario/Mover/MovimientoMasterBox.asp",datos);

    }    

    var iOpInvMovID = -1;
    var iChecado = 0;
    var iCantMovID = 0;
    var sArrPtls = $("#Ptls").val();
        sArrPtls = sArrPtls.trim().split(","); 
    
    $(".chkAllPallets").change(function() {    
    
      if($(this).is(":checked")) {  //Check - chkAllPallets
        //console.log("El checkbox SI esta seleccionado");
        
        iChecado = 1;
        iOpInvMovID = $("#OpInvMov_ID").val();
        
        MarcarTodo(iOpInvMovID,iChecado,1);
        
        var iCant = 0;
        for(i = 0; i < sArrPtls.length; i++){
          //console.log("Num.-"+i + " - " + sArrPtls[i] + " | TotalGralMB: " + $("#TotalGralMB"+sArrPtls[i]).val() + " | CantDSeriesAMov: " + $("#CantDSeriesAMov"+sArrPtls[i]).val());
          //Asigna el total de la cantidad de los pallets a la Cantidad de series a mover
          iCant = parseInt($("#TotalGralMB"+sArrPtls[i]).val());
          $("#CantDSeriesAMov"+sArrPtls[i]).val(iCant);
          // TotalGralMB Pt_Cantidad_Actual
          //console.log("Pt_Cantidad_Actual: " + $("#Pt_Cantidad_Actual"+sArrPtls[i]).val());
          //console.log("CantDSeriesAMov: " + $("#CantDSeriesAMov"+sArrPtls[i]).val());
          if($("#Pt_Cantidad_Actual"+sArrPtls[i]).val() == $("#CantDSeriesAMov"+sArrPtls[i]).val() ) {
            //console.log("Entramos.......");
            $("#dvdEsTotal"+sArrPtls[i]).html("<span class='label label-primary'>Total</span>");
            $("#OpInvMovD_EsTotal"+sArrPtls[i]).val(1);
                       
          }  

        }
        
        $(".chkPtID").prop("checked", true);
        
        MarcaSeriesSI(1);
        
      } else {  //Uncheck - chkAllPallets
        //console.log("El checkbox NO esta seleccionado");
        
        iChecado = 0;
        iOpInvMovID = $("#OpInvMov_ID").val();

        //console.log("iChecado: "+iChecado+" | iOpInvMovID: "+iOpInvMovID + " | Uncheck");  

        MarcarTodo(iOpInvMovID,iChecado,1);

        for(j = 0; j < sArrPtls.length; j++) {
          //console.log("Num.-"+j + " - " + sArrPtls[j]);
          $("#CantDSeriesAMov"+sArrPtls[j]).val(0);
          $("#dvdEsTotal"+sArrPtls[j]).html("<span class='label label-warning-light'>Parcial</span>");
          $("#OpInvMovD_EsTotal"+sArrPtls[j]).val(0);
          //$("#chkPtID"+sArrPtls[j]).iCheck("unchecked");
        }          
        
        $(".chkPtID").prop("checked", false);
        
        MarcaSeriesSI(0);
      }      
      
    });
      


    
    
    
    function MarcarTodo(iValor,Checado,iTipo) {

      var Poner = 0;

      if (Checado==1) { Poner = 1 }	

      $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp", 
          { Tarea:6,Tipo:iTipo,OpInvMov_ID:iValor,Poner:Poner
          },function(data) {
              //alert(data);
              var response = JSON.parse(data);

              if (response.Resultado == 1) {
                sMensaje= "El total de pallets fueron excluidos de la selecci&oacute;n correctamente 1";              
                Avisa("success",'Aviso',sMensaje);
              }

              if (response.Resultado == 2) {
                sMensaje= "El total de Pallets fueron seleccionados correctamente 1";               
                Avisa("success",'Aviso',sMensaje);
              }	

              if (response.Resultado == 0) {
                Avisa("error","Error",response.Error.message+ " " + response.Error.name);              
              }

          });  

    }    

    
    function MarcaSeriesSI(ijsChecado){
      
      var iExisteGridSerie = $('.cssGridSerie').length;
      //console.log("ExistenConGridSeries: " + iExisteGridSerie + " | Checado: " + ijsChecado);
      if(iExisteGridSerie > 0 && ijsChecado == 1){
        $(".chkAllSerie").prop("checked", true);
        $(".chkSerie").prop("checked", true); 
      }

      if(iExisteGridSerie > 0 && ijsChecado == 0){
        $(".chkAllSerie").prop("checked", false);
        $(".chkSerie").prop("checked", false); 
      }
        
    }
   
        
    var iTotalchkPtl = 0;
    var iTotalchkPtlCheck = 0;    
    //checked a cada pallet
    
    $(".chkPtID").change(function() {
    
      if($(this).is(":checked")) { //Check - chkPtID

        var iPtID = $(this).val();
          iOpInvMovID = $("#OpInvMov_ID").val();      
          iChecado = 1;
        
        //console.log("iChecado: "+iChecado+" | iOpInvMovID: "+iOpInvMovID + " | Check"); 
        //Cada que un pallet se quite el chequeo debemos de verificar cuantos pallets están jugando
        iTotalchkPtl = $(".chkPtID").length;
        iTotalchkPtlCheck = $(".chkPtID:checked").length;
        
        if(iTotalchkPtl == iTotalchkPtlCheck){
        
          $(".chkAllPallets").prop("checked", true);
        
        }
        
        var iTotalSerieMB = $("#TotalGralMB"+iPtID).val();
        $("#CantDSeriesAMov"+iPtID).val(iTotalSerieMB);

        //Si el total de los pallets involucrados es igual al total del producto cambiamos estás banderas
        if($("#CantDSeriesAMov"+iPtID).val() == $("#Pt_Cantidad_Actual"+iPtID).val()){
          $("#dvdEsTotal"+iPtID).html("<span class='label label-primary'>Total</span>");
          $("#OpInvMovD_EsTotal"+iPtID).val(1);
        }

        MarcarTodoPallet(iPtID,iChecado,1);        
        
        ExisteMBConSeriesAbiertas(iPtID,iChecado);

      } else { //Uncheck - chkPtID

        var iPtID = $(this).val();
          iOpInvMovID = $("#OpInvMov_ID").val();      
          iChecado = 0;

          //console.log("iChecado: "+iChecado+" | iOpInvMovID: "+iOpInvMovID + " | UnCheck");
        
          $("#dvdEsTotal"+iPtID).html("<span class='label label-warning-light'>Parcial</span>");
          $("#OpInvMovD_EsTotal"+iPtID).val(0);
          $("#CantDSeriesAMov"+iPtID).val(0);        

          //Al quitar el check de un pallet el check general se quita
          $(".chkAllPallets").prop("checked", false);
        
          MarcarTodoPallet(iPtID,iChecado,1);
          ExisteMBConSeriesAbiertas(iPtID,iChecado);
        
      }

    });
    
    
    function MarcarTodoPallet(iValor,Checado,iTipo) {

      var Poner = 0;

      if (Checado==1) { Poner = 1 }	

      $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp", 
          { Tarea:7,Tipo:iTipo,OpInvMov_ID:$("#OpInvMov_ID").val(),Pt_ID:iValor,Poner:Poner
          },function(data) {
              //alert(data);
              var response = JSON.parse(data);

              if (response.Resultado == 1) {
                sMensaje= "El total de pallets fueron excluidos de la selecci&oacute;n correctamente 2";              
                Avisa("success",'Aviso',sMensaje);
              }

              if (response.Resultado == 2) {
                sMensaje= "El total de Pallets fueron seleccionados correctamente 2";               
                Avisa("success",'Aviso',sMensaje);
              }	

              if (response.Resultado == 0) {
                Avisa("error","Error",response.Error.message+ " " + response.Error.name);              
              }

          });  

    }     

    //$('body').on('ifClicked', '#chkPtID', function(e) {
    $('body #todo, #inprogress').sortable({
      //$("#todo, #inprogress").sortable({
        connectWith: ".connectList",
        placeholder: "ui-state-highlight",
        update: function( event, ui ) {

            var todo = $( "#todo" ).sortable( "toArray" );
            var inprogress = $( "#inprogress" ).sortable( "toArray" );
            //var completed = $( "#completed" ).sortable( "toArray" );
            //$('.output').html("ToDo: " + window.JSON.stringify(todo) + "<br/>" + "In Progress: " + window.JSON.stringify(inprogress) + "<br/>" + "Completed: " + window.JSON.stringify(completed));
        }
    }).disableSelection();
    
    //$(".csstask" ).sortable( "disable" );
    
    //Existe abierto un MasterBox
    function ExisteMBConSeriesAbiertas(ijsPtID,ijsChecado){
    
      //console.log('Informacion: ijsPtID: ' + ijsPtID + " | Existe: " + $('#divGridSerie'+ijsPtID).length);
      var iExiste = $('#divGridSerie'+ijsPtID).length;
    
      if (iExiste > 0 && ijsChecado == 1) {
        //console.log("Tiene info");
        //Tomamos el Numero de Master Box que esta abierto para recargarlo
        //necesitamos pallet y num de master box
        var iMBNumAct = $("#Tabla"+ijsPtID).attr("data-mbnum");
        //console.log("iMBNumAct: "+iMBNumAct);
        //Cargar de nuevo
        //console.log("#chkAllSerie"+ijsPtID+iMBNumAct);
        $("#chkAllSerie"+ijsPtID+iMBNumAct).prop("checked", true);
        //$(".chkSerie").prop("checked", true);
        $('#divGridSerie'+ijsPtID).find(".chkSerie").prop("checked", true);
      } 

      if (iExiste > 0 && ijsChecado == 0) {
        //console.log("Tiene info");
        //Tomamos el Numero de Master Box que esta abierto para recargarlo
        //necesitamos pallet y num de master box
        var iMBNumAct = $("#Tabla"+ijsPtID).attr("data-mbnum");
        //console.log("iMBNumAct: "+iMBNumAct);
        //Cargar de nuevo
        //console.log("#chkAllSerie"+ijsPtID+iMBNumAct);
        $("#chkAllSerie"+ijsPtID+iMBNumAct).prop("checked", false);
        //$(".chkSerie").prop("checked", true);
        $('#divGridSerie'+ijsPtID).find(".chkSerie").prop("checked", false);
      }       
      
      
    }

    function ValidaSeleccion(ijqPtID){
      
    //console.log($("#cboTipoBusqueda").val()); CantDSeriesAMov36403
      
    if($("#CantDSeriesAMov"+ijqPtID).val() == 0){
      sMensaje= "Por favor seleccione por lo menos una serie a mover, gracias."
      Avisa("warning", "Movimiento", "" + sMensaje);
      //$("#CantDSeriesAMov"+ijqPtID).focus();
      return false;        
    }
    
    if($("#DestUbi_ID").val() == -1){
      sMensaje= "Por favor seleccione una ubicaci&oacute;n para poder realizar la selecci&oacute;n, gracias."
      Avisa("warning", "Movimiento", "" + sMensaje);
      $("#DestUbi_ID").focus();
      return false;        
    }      
    
     return true;
      
    
    }
    
    
    
    
    
    
});    

  
</script>
      
      
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
   var bIQ4Web = true   

   
   
   
%>
  
  
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">

  
<div id="wrapper">

  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
      
      <div class="wrapper wrapper-content  animated fadeInRight">
        <div class="row">
          <div class="col-lg-6"> 
            <div class="ibox">
              <div class="ibox-content">
                <h4>Ubicaci&oacute;n origen.</h4>
                <hr>
                <p class="small"><i class="fa fa-search"></i>&nbsp;&nbsp;B&uacute;squeda</p>
                  <div class="form-horizontal">
                    <div class="form-group">
                      <label class="col-md-offset-0 col-md-4 control-label" id="lblTipoBusqueda">Tipo de B&uacute;squeda:</label>
                      <div class="col-md-4">    
                        <select id="cboTipoBusqueda" name="cboTipoBusqueda" class="form-control input-sm cboSelect"> 
                          <option value="-1" selected="selected">Seleccione</option>
                          <option value="1">Serie</option>
                          <option value="2">MasterBox</option>
                          <option value="3">LPN</option>
                          <option value="4">SKU</option>
                          <option value="5">Ubicaci&oacute;n</option>
                        </select>
                      </div>
                    </div>
                    <div class="form-group">
                      <label class="col-md-offset-0 col-md-4 control-label" id="lblSerieLPNSKUUbi">Serie(s):</label>
                      <div class="col-md-8">   
                        <textarea id="txtaBuscar" name="txtaBuscar" class="form-control input input-sm" placeholder="Serie(s)"></textarea>
                        <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> Coloque el n&uacute;mero de Serie(s) </span>
                      </div>
                    </div>
                    <div class="form-group">
                      
                    </div>
                    <div class="form-group pull-right m-t-n-xs">
                      <button class="btn btn-sm btn-primary btnBuscarEnInventario" type="button"><strong><i class="fa fa-search"></i> Buscar</strong></button>
                      <button class="btn btn-sm btn-success btnLimpiarFiltrosBusq" type="button"><strong><i class="fa fa-eraser"></i> Limpiar b&uacute;squeda</strong></button>
                    </div>

                    <div class="form-group">
                      
                    </div>
                    <div class="form-group">
                      
                    </div>
                    <div class="form-group">
                      
                    </div>
                    <div class="form-group">
                      
                    </div>
                    <div class="form-group">
                      
                    </div>
                    <div class="form-group">
                      
                    </div>                   
                    <div class="form-group">
                      
                    </div>                 
                  </div>
                  <hr class="hr-line-dashed text-info">
                  <div id="divGridResultado"></div>  
              </div>
            </div>
          </div>
          <div class="col-lg-6">
            <div class="ibox">
              <div class="ibox-content">
                <h4>Ubicaci&oacute;n destino.</h4>
                <hr>
                <p class="small"><i class="fa fa-codepen"></i>&nbsp;&nbsp;Ubicaci&oacute;n donde se mover&aacute;</p>
                <div class="form-horizontal">
                  <div class="form-group">
                    <label class="col-md-offset-0 col-md-2 control-label" id="lblAreID">&Aacute;rea</label>
                    <div class="col-md-5">
                      <% 
                       var sEventos = "class='form-control input-sm cboSelect' style='width: 100%'"
                       var sCond = " Are_TipoCG88 IN (1,3,6) AND Are_Habilitado = 1"
                      CargaCombo("DestAre_ID",sEventos,"Are_ID","Are_Nombre","Ubicacion_Area",sCond,"Are_Nombre",Parametro("DestAre_ID",-1),0,"Seleccione","Editar") 
                      %>
                    </div>
                    <label class="col-md-offset-0 col-md-1 control-label" id="lblDestPt_SKU">SKU</label>
                    <div class="col-md-4">  
                      <!--input type="text" id="DestPt_SKU" class="form-control input-sm" autocomplete="off" placeholder="SKU"-->
                      <div class="input-group m-b">
                        <input type="text" id="DestPt_SKU" class="form-control input-sm" autocomplete="off" placeholder="SKU">
                        <span class="input-group-addon btnBuscaSKU btn-primary"><i class="fa fa-search-plus"></i></span>
                      </div>
                      
                    </div>  
                  </div>
                  <div class="form-group">
                    <label class="col-md-offset-0 col-md-2 control-label" id="lblRacID">Rack</label>
                    <div class="col-md-5" id="divRac">
                      <select name="DestRac_ID" id="DestRac_ID" class="form-control input-sm cboSelect DestRac_ID" style="width: 100%">
                        <option value="-1">Seleccione</option>
                      </select>
                    </div>
                  </div>                    
                  <div class="form-group">
                    <label class="col-md-offset-0 col-md-2 control-label" id="lblUbiID">Ubicaci&oacute;n</label>
                    <div class="col-md-6" id="divUbi">
                      <select name="DestUbi_ID" id="DestUbi_ID" class="form-control input-sm cboSelect DestUbi_ID" style="width: 100%">
                        <option value="-1">Seleccione</option>
                      </select>
                      <!--span class="help-block m-b-none"><i class="fa fa-info-circle"></i> Especificar el dato es de suma importancia para realizar el movimiento. </span-->
                    </div>
                  </div>
                  <div class="form-group" id="rowUBI">
                    <label class="col-md-offset-0 col-md-2 control-label" id="lblUbiID2"></label>
                    <div class="col-md-7"> 
                      <!--input type="text" id="DestUbi_Nombre" class="form-control input-sm" autocomplete="off" placeholder="Ubicaci&oacute;n"-->
                      <div class="input-group m-b">
                        <input type="text" id="DestUbi_Nombre" class="form-control input-sm" onclick="this.select();" placeholder="Ubicaci&oacute;n">
                        <span class="input-group-addon btnBuscaUbica btn-primary"><i class="fa fa-search-plus"></i></span>
                      </div>
                      <span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;Puede introducir la ubicaci&oacute;n y dar clic en el bot&oacute;n <i class="fa fa-search-plus"></i>&nbsp; &oacute; presionar la tecla <strong>Entrar</strong></span>
                    </div>
                  </div>                    
                  <p></p>
                  <div class="form-group pull-right m-t-n-xs">
                    <!--div class="btn-group"-->
                      <button class="btn btn-sm btn-primary btnBuscarUbicaDestino" type="button" id="btnBuscarUbicaDestino"><strong><i class="fa fa-search"></i> Buscar</strong></button>  
                      <button class="btn btn-sm btn-success btnLimpiarFiltros" type="button"><strong><i class="fa fa-eraser"></i> Limpiar filtros</strong></button>
                    <!--/div-->    
                  </div>
                  <div class="form-group">
                    
                  </div> 
                  <div class="form-group pull-left m-t-n-xs">
                    <button class="btn btn-sm btn-success btnLimpiarLPNs" id="btnLimpiarLPNs" type="button" disabled><strong><i class="fa fa-eraser"></i>&nbsp;Limpiar LPN Seleccionado(s)</strong></button>  
                  </div>  
                </div>
                <p></p>
                <div id="divUbiDestPallets">
                  <!--start-->
                  <!--end-->
                </div>   
                <ul class="sortable-list connectList agile-list" id="inprogress">
                  <p></p>
                  <p></p>
                  <p></p>
                  <p></p>
                  <p></p>
                  <p></p>
                  <p></p>
                  <!--li class="success-element" id="task4000">
                      &Aacute;rea de series seleccionadas 
                      <div class="agile-detail">
                          <a href="#" class="pull-right btn btn-xs btn-white"></a>
                          <i class="fa fa-check-square-o"></i> 
                      </div>
                  </li-->
                </ul>  
                <!--div id="divGridDestino">cae el destino</div--> 
              </div>
            </div>  
          </div>    
        </div>
      </div>  

    </div>
  </div>  
    
</div>  
<input type="hidden" name="OpInvMov_ID" id="OpInvMov_ID" value="-1">
    
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
  
<script type="text/javascript">

var sMensaje = ""

var loading = '<div class="spiner-example">'+
        '<div class="sk-spinner sk-spinner-three-bounce">'+
          '<div class="sk-bounce1"></div>'+
          '<div class="sk-bounce2"></div>'+
          '<div class="sk-bounce3"></div>'+
        '</div>'+
      '</div>'+
      '<div>Cargando informaci&oacute;n, espere un momento...</div>'
  
$(document).ready(function() {  

  $(".cboSelect").select2();
  
  $("#txtaBuscar").blur(function(){
    
    var sBuscar = decodeURI($("#txtaBuscar").val())
        //console.log("I: " + sBuscar);
        sBuscar = sBuscar.replace(/'/g, "-"); //cambio apostrofes por guiones
        //console.log("II: " + sBuscar);
        $("#txtaBuscar").val(sBuscar);
  });
  
  $('#txtaBuscar').keyup(function(e){
    if(e.keyCode == 13) {
      $(".btnBuscarEnInventario").trigger("click");
    }
  });  

  $(".btnBuscarEnInventario").click(function(){
    //console.log("ArrABus: " + ArrABus);
    if(ValidaBusqueda()){
      var iUsuID = $("#IDUsuario").val();
      var iTipoBusqu = $("#cboTipoBusqueda").val();
      
      InsertaObjetivo(iUsuID,iTipoBusqu);

    }

  }); 
  
  function ValidaBusqueda(){
    //console.log($("#cboTipoBusqueda").val());
    if($("#cboTipoBusqueda").val() == -1){
      sMensaje= "Por favor seleccione una opci&oacute;n de b&uacute;squeda."
      Avisa("warning", "Movimiento", "" + sMensaje);
      $("#cboTipoBusqueda").focus();
      return false;        
    }

    if($("#txtaBuscar").val() == ""){
      sMensaje= "Por favor introduzca la serie &oacute; series a buscar."
      Avisa("warning", "Movimiento", "" + sMensaje);
      $("#txtaBuscar").focus();
      return false;        
    }      

     return true;

  }    
  
  
  function InsertaObjetivo(ijsUsuID,ijsTipoBusqu){
    
    //console.log("Usu_ID: " + ijsUsuID + " | Tipo busqueda: " + ijsTipoBusqu);
    
    $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp"
      ,{Tarea:3,Usu_ID:ijsUsuID,TipoBusq:ijsTipoBusqu }
      ,function(data) {
        //console.log(data);
        var response = JSON.parse(data);
        //console.log(response);
        
        if(parseInt(response.Resultado) == 1){
					//Avisa("success","Aviso",response.Datos.message); 
					$('#OpInvMov_ID').val(response.Datos.ID);
          EnvioDatosObjetivoBusqueda(response.Datos.ID);
          setTimeout(function(){                  
            //console.log("setTimeout(func,500) example...");
            CargarGridInven(response.Datos.ID);
          },500);          
          
          sMensaje = "La carga de la b&uacute;squeda se realizo correctamente"

				} else{
					Avisa("error","Error",response.Error.message+ " " + response.Error.name);
          $('#OpInvMov_ID').val(-1);
				}    
        
        Avisa("success","Aviso",sMensaje); 
      
      }); 
         
  }  

  function EnvioDatosObjetivoBusqueda(ijqIDOpMov) {
    
    var strBuscar = $("#txtaBuscar").val();
    var ArrABus = strBuscar.trim().split("\n").join(",");
        //console.log(ArrABus);
        //var sMensaje = "";
        $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp",{ Tarea:4,OpInvMov_ID:ijqIDOpMov,ArrSer:ArrABus }
         ,function(data) {
              var response = JSON.parse(data);
              /*
              if(arrPrm[0] == 1){
                  sMensaje= "Se realizo correctamente";
                  Avisa("success", "Movimiento", "" + sMensaje);
                  //CargarGrid();
              } else {
                  sMensaje= " fue asignado correctamente";
                  Avisa("success", "Movimiento", "" + sMensaje);                          
              }
              */
        });         

  }   
  
  function CargarGridInven(ijqOpInvMovID) {

      var datos = {
          OpInvMov_ID:ijqOpInvMovID,
          TipoBusqueda:$("#cboTipoBusqueda").val(),
          Usu_ID:$("#IDUsuario").val()
      }

      $("#divGridResultado").hide("slow");
      $("#divGridResultado").html(loading);
      $("#divGridResultado").load("/pz/wms/Inventario/Mover/MovimientoGridResultado.asp",datos);
      $("#divGridResultado").show("slow");
    
  } 
  
  
  $(".btnLimpiarFiltrosBusq").click(function(){

      $('#cboTipoBusqueda').val(-1);
      //Se ejecuta así que validar
      //$('#cboTipoBusqueda').select2("val",$('#cboTipoBusqueda option:nth-child(1)').val());
      $('#cboTipoBusqueda').select2("val",-1);
    
      $("#txtaBuscar").val("");
    
      $("#divGridResultado").hide("");
      $("#divGridResultado").html(loading);    
      $("#divGridResultado").html(""); 

  });    

  
  $("#DestAre_ID").change(function(){ 
    //console.log("Entramos_DestAre_ID");
    var ivalAreID = $(this).val();
    if(ivalAreID > -1){
      if(ivalAreID > -1){
        ComboRack(ivalAreID,2,-1);
      }
    }
  });  
  
  function ComboRack(ijsAreID,ijsBusqDest,ijsValSel) {
    //console.log("Cargamos el combo del Rac..... " + ijsValSel);
    var iValSel = ijsValSel;
    var sNomCboCarga = "";
    
    if(ijsBusqDest == 1){
      sNomCboCarga = "#BusqRac_ID";
    } if(ijsBusqDest == 2){
      sNomCboCarga = "#DestRac_ID";    
    }

    var sparam = {
      Tarea:1
      ,Are_ID:ijsAreID
      ,Rac_ID:iValSel
    }
    
    $("#divRac").load("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp", sparam);    
    
  }
  
  $(document).on('change', '#DestRac_ID', function(){  
    //$("#DestRac_ID").change(function(){
    //alert("Seleccion de RACK.......");
    var ivalAreID = $("#DestAre_ID").val();
    var ivalRacID = $(this).val();
    
    if(ivalRacID > -1){
      ComboUbicacion(ivalAreID,ivalRacID,2);
    }
    
  });   

  function ComboUbicacion(ijsAreID,ijsRacID,ijsBusqDest,ijsValSel) {

    var iValSel = ijsValSel;
    var sNomCboCarga = "";
    
    if(ijsBusqDest == 1){
      sNomCboCarga = "#BusqUbi_ID";
    } if(ijsBusqDest == 2){
      sNomCboCarga = "#DestUbi_ID";    
    }
    
    var sparam = {
       Tarea:2
      ,Are_ID:ijsAreID
      ,Rac_ID:ijsRacID
      ,Ubi_ID:iValSel
    }
    //console.log(sparam);
    $("#divUbi").load("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp", sparam);	
    //console.log("Seleccionado: ");
    
  }	   
  
  $(".btnBuscarUbicaDestino").click(function(){
    //console.log("#btnBuscarUbicaDestino_#DestUbi_ID: " + $("#DestUbi_ID").val());
    
    //if($("#DestUbi_ID").val() > -1){
      var datos = {
          DestUbi_ID:$("#DestUbi_ID").val(),
          DestUbi_Nombre:$("#DestUbi_Nombre").val()
      }

      if(ValidaBusquedaUbicacion()){

        $("#divUbiDestPallets").hide("slow");
        $("#divUbiDestPallets").html(loading);
        $("#divUbiDestPallets").load("/pz/wms/Inventario/Mover/Movimiento_PalletEnUbi.asp",datos);
        $("#divUbiDestPallets").show("slow");

      }
    //}
  }); 
  
  function ValidaBusquedaUbicacion(){
    //DestUbi_ID DestUbi_Nombre
    //console.log("ValidaBusquedaUbicacion()");
    if($("#DestUbi_ID").val() == -1){
      sMensaje= "Debe seleccionar la ubicaci&oacute;n &oacute; introducir el nombre para la b&uacute;squeda."
      Avisa("warning", "Movimiento", "" + sMensaje);
      $("#DestUbi_ID").focus();
      
      return false;        
    }
    /*
    if($("#DestUbi_Nombre").val() == "" && $("#DestUbi_ID").val() == -1){
      sMensaje= "Por favor introduzca la ubicacioacute;n a buscar, gracias."
      Avisa("warning", "Movimiento", "" + sMensaje);
      $("#DestUbi_Nombre").focus();
      return false;        
    }      
    */
     return true;

  } 
  
  $(document).on('change','#DestUbi_ID', function(){
     //console.log("Cambio de ubicacion");
     var ivalDestUbiID = $(this).val();
      //console.log(ivalDestUbiID);
     if(ivalDestUbiID > -1 || ivalDestUbiID != null){
       //console.log("ivalDestUbiID: " + ivalDestUbiID);
        /*setTimeout(function(){
          $(".btnBuscarUbicaDestino").trigger("click");
          var sUbiNombre = $("#DestUbi_ID option:selected").text();
            document.frmDatos.DestUbi_Nombre.value = sUbiNombre;
        },500);*/
        if($('#DestUbi_Nombre').val() != ""){
          MostrarPallets();
        }
        var iPtID = -1;
        //console.log("Longitud: " + $("#inprogress li").length );
        if($("#inprogress li").length > 0){
          //$(event.target).closest('#inprogress li').detach().appendTo('#todo');
          $(".btnRegresar").trigger("click");
        }

        //JD
        //$(".btnBuscarUbicaDestino").trigger("click");
    }
    
  });
  
   //Búsqueda por UBICACION {start}
  
  $('#DestUbi_Nombre').keyup(function(e){
    var sUBI = $("#DestUbi_Nombre").val();
    //console.log("#DestUbi_Nombre: " + sUBI);
    if(e.keyCode == 13) {
      $(".btnBuscaUbica").trigger("click");
    }
  });  
  
  $(".btnBuscaUbica").click(function(){
    var sUBI = $("#DestUbi_Nombre").val();
    //if(sUBI != "" || sUBI != null){
      BusquedaPorUbica(sUBI);
    //}
  });
  
  function BusquedaPorUbica(sjsUBI){
  
      //console.log("Ubicacion: " + sjsUBI);
      var sElemento = "";
      var SelAnt = -1;
      var sNomCboCarga = "";
          sNomCboCarga = "#DestUbi_ID";    

      //$('#DestAre_ID').val(-1);
      $('#DestAre_ID').select2("val",-1);
      //Mandamos a -1 uno el Área
      //Todo porque se usa *select2* {start}
      $('#DestRac_ID').prop('disabled', false);
      $('#DestRac_ID').val(-1);
      $('#DestRac_ID option').remove();
      $('#DestRac_ID').append('<option value="-1">Seleccione</option>');
      $('#DestRac_ID').select2("val",-1);
      //Todo porque se usa *select2* {end}

      $('#DestUbi_ID').val(-1);
      $('#DestUbi_ID').empty();
      $('#DestUbi_ID option').remove();
      $('#DestUbi_ID').append('<option value="-1">Seleccione</option>');
      $('#DestUbi_ID').select2("val",-1);

      $(sNomCboCarga).empty();

      //$(sNomCboCarga).append('<option value="-1">Seleccione</option>');

      $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp"
      ,{Tarea:11,Ubi_Nombre:sjsUBI },function(data) {
        var response = JSON.parse(data);
        //console.log("data: " + data);

        if(parseInt(response.Resultado) == 1){

          //console.log("Are_ID: " + response.Datos.Are_ID + " | Rac_ID: " + response.Datos.Rac_ID + " | Ubi_ID: " + response.Datos.Ubi_ID + " | Ubi_Nombre: " + response.Datos.Ubi_Nombre);
          $('#DestAre_ID').select2("val",response.Datos.Are_ID);
          
          $("#DestRac_ID").select2("val",response.Datos.Rac_ID);
          setTimeout(function(){
            ComboRack(response.Datos.Are_ID,2,response.Datos.Rac_ID);
          },200);
          
          $("#DestUbi_ID").select2("val",response.Datos.Ubi_ID);
          setTimeout(function(){
            //ComboUbicacion(ijsAreID,ijsRacID,ijsBusqDest,ijsValSel)
            ComboUbicacion(response.Datos.Are_ID,response.Datos.Rac_ID,2,response.Datos.Ubi_ID);
            //$(".btnBuscarUbicaDestino").trigger("click");
            MostrarPallets();
          },300);
                  
          
        } else {
          
          sMensaje= "La ubicaci&oacute;n no existe."
          Avisa("warning", "Movimiento - B&uacute;squeda por ubicaci&oacute;n", "" + sMensaje);
          //$('#DestUbi_ID').empty();
        }

      });    
    
  }
  
  //Búsqueda por UBICACION {end}

  
  //Búsqueda por SKU {start}
  
  $(".btnBuscaSKU").click(function(){
    var sSKU = $("#DestPt_SKU").val();
    BusquedaPorSku(sSKU);
  });
  
  $('#DestPt_SKU').keyup(function(e){
    if(e.keyCode == 13) {
      $(".btnBuscaSKU").trigger("click");
    }
  });  

  
  function BusquedaPorSku(sjsSKU){
  
     //console.log("SKU: " + sjsSKU);
    var sElemento = "";
    var SelAnt = -1;
    var sNomCboCarga = "";
        sNomCboCarga = "#DestUbi_ID";    
    
    $(sNomCboCarga).empty();
    
    $(sNomCboCarga).append('<option value="-1">Seleccione</option>');
    
     $.post("/pz/wms/Inventario/Mover/Movimiento_Ajax.asp"
      ,{Tarea:10,Pt_SKU:sjsSKU }
      ,function(data) {
        //var response = JSON.parse(data);
        //console.log(response);
        //if(parseInt(response.Resultado) == 1){
        if(data != "Error"){
          
          $('#DestAre_ID').prop('disabled', true);
          $('#DestRac_ID').prop('disabled', true);
          //console.log("Resultados: " + data);
          var arrPrm = data.split("|");

          for (j=0;j<arrPrm.length;j++) {
            var Txt = String(arrPrm[j])

            var arrCampo = Txt.split(",");

            sElemento = '<option value="' + arrCampo[0] + '" '

            if (parseInt(SelAnt) == arrCampo[0]) { sElemento += ' selected ' }

            sElemento += '>' + arrCampo[1] + '</option>'

            $(sNomCboCarga).append(String(sElemento));
            //console.log(sElemento);
          } 
        } else {
          
          sMensaje= "El SKU no existe."
          Avisa("warning", "Movimiento", "" + sMensaje);
          $('#DestAre_ID').prop('disabled', false);
          $('#DestRac_ID').prop('disabled', false);
          $('#DestUbi_ID').empty();
          
        }
     
      });    
    
  }  
  
  
  
  
  //Búsqueda por SKU {end}  
  
  
  $(".btnLimpiarFiltros").click(function(){
    
    //====Area===== {start}
    //$('#DestAre_ID').prop('disabled', false);
    $('#DestAre_ID').val(-1);
    //Se ejecuta así que validar
    $('#DestAre_ID').select2("val",-1);
    //$('#DestAre_ID').select2('data', null);
    //====Area===== {end}
    
    //====Rack===== {start}
    //Todo porque se usa *select2* {start}
    //$('#DestRac_ID').prop('disabled', false);
    $('#DestRac_ID').val(-1);
    $('#DestRac_ID option').remove();
    $('#DestRac_ID').append('<option value="-1">Seleccione</option>');
    //$('#DestRac_ID').select2("val",$('#DestRac_ID option:nth-child(1)').val());
    $('#DestRac_ID').select2("val",-1);
    //Todo porque se usa *select2* {end}
    //====Rack===== {end}
    
    //====Ubicación===== {start}
    $('#DestUbi_ID').val(-1);
    $('#DestUbi_ID').empty();
    $('#DestUbi_ID option').remove();
    $('#DestUbi_ID').append('<option value="-1">Seleccione</option>');
    $('#DestUbi_ID').select2("val",-1);
    //====Ubicación===== {end}
    
    
    $("#DestUbi_Nombre").val("");
    //$("#rowUBI").addClass("form-control");
    $('#DestPt_SKU').val("");
    $('#DestAre_ID').prop('disabled', false);
    $('#DestRac_ID').prop('disabled', false);
    
    
    var iLong = $("#divUbiDestPallets #ulListadoPallets").length;
    //console.log("length: " + iLong);

    if(iLong > 0){
      $("#divUbiDestPallets").hide("");
      $("#divUbiDestPallets").html("");
      $("#divUbiDestPallets").show("");
    }    
    
  });
  
  
  function MostrarPallets(){
    
    setTimeout(function(){
      //console.log("DestUbi_ID: " + document.frmDatos.DestUbi_ID.value)
      if($('#DestUbi_ID').val() > -1){
        $(".btnBuscarUbicaDestino").trigger("click");
      }
    },300);
    
  }

  $(".btnLimpiarLPNs").click(function(){
    $("#btnLimpiarLPNs").prop('disabled', true);
     var iLong = $("#inprogress").length;
    //console.log("length: " + iLong);
    if(iLong > 0){
      $("#inprogress li").remove();
    }   
    

    
    
  });
  
  
});  
  
</script>  
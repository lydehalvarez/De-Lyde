<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)
	var Pro_ID = Parametro("Pro_ID",0)	
 	
	var Pro_Habilitado = 1
	var Tg_ID = 1	
	var Com_ID = 1	
	var Combo_Modo = "Edicion"	

  	var sSQL = "Select ISNULL(Prov_RazonSocial,'') as RazonSocial , Prov_RFC, Prov_ContactoVenta "
	    sSQL += " , Prov_EmailVentas, Prov_TelefonoVentas  "
	    sSQL += " , dbo.fn_CatGral_DameDato(56,Prov_PersonalidadJuridicaCG56) as PersonalidadJuridica "
		sSQL += " , ISNULL(CONVERT(NVARCHAR(20),Prov_UltimaCompra ,103),'') as UltimaCompra "
	    sSQL += " FROM Proveedor "
	    sSQL += " WHERE Prov_ID = " + Prov_ID

 	var rsPr = AbreTabla(sSQL,1,0)	
	if (!rsPr.EOF){ 
		var Prov_RazonSocial = rsPr.Fields.Item("RazonSocial").Value
		var Prov_RFC = rsPr.Fields.Item("Prov_RFC").Value		
		var PersonalidadJuridica = rsPr.Fields.Item("PersonalidadJuridica").Value
		var Prov_TelefonoVentas = rsPr.Fields.Item("Prov_TelefonoVentas").Value		
		var Prov_EmailVentas = rsPr.Fields.Item("Prov_EmailVentas").Value
		var Prov_ContactoVenta = rsPr.Fields.Item("Prov_ContactoVenta").Value
		var UltimaCompra = rsPr.Fields.Item("UltimaCompra").Value					
	}



	var sSQL = "SELECT OC_Descripcion, OC_Folio, OC_EstatusCG51, Tg_ID, Com_ID "
		sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDSolicita) as UsuSolicita "
        sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_CompradorID) as Comprador "
        sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDOriginador) as UsuIDOriginador "		
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaElaboracion,103) as FechaElaboracion "  
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaRequerida,103) as OC_FechaRequerida " 
	    sSQL += " FROM OrdenCompra "
		sSQL += " WHERE Prov_ID = " + Prov_ID
		sSQL += " AND OC_ID = " + OC_ID
	
		
	var rsOC = AbreTabla(sSQL,1,0)
    if (!rsOC.EOF){
		Tg_ID = rsOC.Fields.Item("Tg_ID").Value
		Com_ID = rsOC.Fields.Item("Com_ID").Value		
		var UsuSolicita = rsOC.Fields.Item("UsuSolicita").Value
		var Comprador = rsOC.Fields.Item("Comprador").Value	
		var OC_Descripcion = rsOC.Fields.Item("OC_Descripcion").Value
		var UsuIDOriginador = rsOC.Fields.Item("UsuIDOriginador").Value		
		var FechaElaboracion = rsOC.Fields.Item("FechaElaboracion").Value		
		var OC_FechaRequerida = rsOC.Fields.Item("OC_FechaRequerida").Value	
		var OC_Folio = rsOC.Fields.Item("OC_Folio").Value	
		var OC_EstatusCG51 = rsOC.Fields.Item("OC_EstatusCG51").Value											
	}
	
	
	//Combo_Modo = "Consulta"
	
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
    
    
<div class="wrapper wrapper-content animated fadeInRight">
  <div class="ibox-content">
    <div class="row">
      <div class="col-lg-12">
        <div class="m-b-md">
          <h2 class="pull-right"><%=OC_Folio%></h2>
          <h2><%=Prov_RazonSocial%></h2>
        </div>
        <!-- dl class="dl-horizontal">
            <dt>Status:</dt> <dd><span class="label label-primary">Active</span></dd>
        </dl -->
      </div>
    </div>
    <div class="row">
      <div class="col-md-7">
        <!--div class="row">
          <label class="col-md-3 control-label" id="lblCom_ID">Compa&ntilde;&iacute;a</label>
          <div class="col-md-6"-->
            <% /*
            var sEventos = " class='input-sm form-control objCBO' onchange='javascript:CambioCompania()' "
            var sCondicion = ""
            CargaCombo("Com_ID",sEventos,"Com_ID","Com_RazonSocial","Compania",sCondicion,"",Com_ID,0,"Seleccione una compa&ntilde;&iacute;a","Consulta") 
               */
            %><!--br>
          </div>
        </div-->
        <div class="row">
          <label class="col-md-3 control-label" id="lblTG_ID">Tipo de gasto</label>
          <div class="col-md-5"><input type="hidden" name="Com_ID" id="Com_ID" value="<%=Com_ID%>">
            <%
            var sEventos = " class='form-control m-b objCBO' onchange='javascript:CambioGasto()' "  
            var sCondicion = " Tg_Habilitado = 1 " 
            CargaCombo("Tg_ID",sEventos,"Tg_ID","Tg_Nombre","Cat_TipoGasto",sCondicion,"Tg_Orden",Tg_ID,0,"Seleccione un tipo de gasto",Combo_Modo) 
            %>
          </div>
          <div class="col-md-4">
            &nbsp;
          </div>
        </div>
        <br>
        <div class="row">
          <div class="col-md-6">
            <div class="ibox">
              <div class="ibox-title">
                <h5>Desarrollo</h5>
              </div>
              <div class="ibox-content">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                  <% 
                  var sSQL  = "select D.Des_ID, D.Des_Nombre, D.Des_Descripcion "
                  sSQL +=     " , ISNULL(OCC_Valor,0) as Seleccionado "
                  sSQL += " from Desarrollo D  "
                  sSQL += " left join OrdenCompra_Clasificacion f "
                  sSQL += " ON Prov_ID = " + Prov_ID + " and OC_ID = " + OC_ID
                  sSQL += " and D.Com_ID = f.Com_ID AND f.Com_ID = " + Com_ID
                  sSQL += " and D.Des_ID = f.Pry_ID "     
                  sSQL += " and OCC_Valor = 1 "
                    //Response.Write("Desarrollo " + sSQL)
                  var rsDes = AbreTabla(sSQL,1,0)

                  while (!rsDes.EOF){
                %>                    
                <tr>
                 <td>&nbsp;&nbsp;
                 <input class="i-checks chkPry" type="checkbox" 
                <%  if (rsDes.Fields.Item("Seleccionado").Value == 1) { Response.Write("checked='checked'") } %>
                                               value="<%=rsDes.Fields.Item("Des_ID").Value%>"></td>
                 <td><%=rsDes.Fields.Item("Des_Nombre").Value%></td>
               </tr>
                 <%                   
                        rsDes.MoveNext() 
                    }
                    rsDes.Close()   
                 %>   
                </table>
                <hr>
                <span class="text-muted small">*Seleccione un Desarrollo o varios a la vez</span>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="ibox">
              <div class="ibox-title">
                <h5>Departamento</h5>
              </div>
              <div class="ibox-content">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                  <% 
                  var sSQL  = "select c.Dep_ID, Dep_Nombre, Dep_Descripcion "
                  sSQL +=     " , ISNULL(OCC_Valor,0) as Seleccionado "
                  sSQL += " from Compania_Departamento c  "
                  sSQL += " left join OrdenCompra_Clasificacion f "
                  sSQL += " ON Prov_ID = " + Prov_ID + " and OC_ID = " + OC_ID
                  sSQL += " and c.Com_ID = f.Com_ID AND f.Com_ID = " + Com_ID
                  sSQL += " and c.Dep_ID = f.Dep_ID "     
                  sSQL += " and OCC_Valor = 1 "
                  sSQL += " Order by Dep_Orden  "

                  var rsDep = AbreTabla(sSQL,1,0)

                  while (!rsDep.EOF){
                %>                    
                   <tr>
                     <td>&nbsp;&nbsp;
                     <input class="i-checks chkDepto" type="checkbox" 
    <%  if (rsDep.Fields.Item("Seleccionado").Value == 1) { Response.Write(" checked='checked' ") } %>
                           value="<%=rsDep.Fields.Item("Dep_ID").Value%>"></td>
                     <td><%=rsDep.Fields.Item("Dep_Nombre").Value%></td>
                   </tr>
                 <%                   
                        rsDep.MoveNext() 
                    }
                    rsDep.Close()   
                 %>     
                </table>
                <hr>
                <span class="text-muted small">*Seleccione un Departamento o varios a la vez</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-5">
        <br>
        <br>
        <p></p>
        <div class="ibox">
          <div class="ibox-title">
            <h5>Centro de costo</h5>
          </div>
          <div class="ibox-content">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <%     
              var sSQL  = "select c.CC_ID, CC_Nombre, CC_Descripcion, CC_Clave "
              sSQL +=     " , ISNULL(OCC_Valor,0) as Seleccionado "
              sSQL += " from CentroCosto c  "
              sSQL += " left join OrdenCompra_Clasificacion f "
              sSQL += " ON Prov_ID = " + Prov_ID + " and OC_ID = " + OC_ID
              sSQL += " and c.CC_ID = f.CC_ID "
              sSQL += " and OCC_Valor = 1 "
              sSQL += " Order by CC_Orden  "

                 var rsCC = AbreTabla(sSQL,1,0)

              while (!rsCC.EOF){
            %>                    
               <tr>
                 <td title="<%=rsCC.Fields.Item("CC_Descripcion").Value%>">&nbsp;&nbsp;
                 <input class="i-checks chkCC" type="checkbox" 
                 <%  if (rsCC.Fields.Item("Seleccionado").Value == 1) { Response.Write("checked='checked'") } %>
                       value="<%=rsCC.Fields.Item("CC_ID").Value%>"></td>
                 <td><%=rsCC.Fields.Item("CC_Clave").Value%> - 
                     <%=rsCC.Fields.Item("CC_Nombre").Value%>
                     </td>
               </tr>
             <%                   
                    rsCC.MoveNext() 
                }
                rsCC.Close()   
             %>    
            </table>
            <hr>
            <span class="text-muted small">*Seleccione uno o m&aacute;s Centros de Costo</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
                
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>                
<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>               

                
<script type="text/javascript">

$(document).ready(function(){
	
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
    });    
	
	 
 });

    //$(".chkPry").click(function(){ 
    $(".chkPry").on('ifClicked', function(event){
        
        var checkbox = $(this);
        var Chkdo = 0
        var Checado = !checkbox.is(':checked');
        if(Checado){
            Chkdo = 1
        } 
        var Valor = checkbox.val();
        $.post( "/pz/fnd/OC/Ajax.asp"
                   , {  Tarea:8
                       ,Prov_ID:$("#Prov_ID").val()
                       ,OC_ID:$("#OC_ID").val()
                       ,Usu_ID:$("#IDUsuario").val()
                       ,Pry_ID:Valor
                       ,Com_ID:$("#Com_ID").val()
                       ,Chkd:Chkdo
            }, function() {
                var sMensaje = "Se registro el cambio en el departamento "
                var sTitulo = "Cambio correcto"	
                Avisa("success",sTitulo,sMensaje)	 			
            });			
    });			

	//$(".chkDepto").click(function(){ 
	$(".chkDepto").on('ifClicked', function(event){
        
		var checkbox = $(this);
		var Chkdo = 0
		var Checado = !checkbox.is(':checked');
		if(Checado){
			Chkdo = 1
		} 
		var Valor = checkbox.val();
		$.post( "/pz/fnd/OC/Ajax.asp"
				   , {  Tarea:7
					   ,Prov_ID:$("#Prov_ID").val()
					   ,OC_ID:$("#OC_ID").val()
					   ,Usu_ID:$("#IDUsuario").val()
					   ,Dep_ID:Valor
					   ,Com_ID:$("#Com_ID").val()
					   ,Chkd:Chkdo
			}, function() {
				var sMensaje = "Se registro el cambio en el departamento "
				var sTitulo = "Cambio correcto"	
				Avisa("success",sTitulo,sMensaje)	 			
			});			
	});	
    
    
    
	//$(".chkCC").click(function(){
    $(".chkCC").on('ifClicked', function(event){    
	//console.log("Clic en Centro de Costos!!!!!");
		var checkbox = $(this);
		var Chkdo = 0
		var Checado = !checkbox.is(':checked');
		if(Checado){
			Chkdo = 1
		} 
		var Valor = checkbox.val();
		$.post( "/pz/fnd/OC/Ajax.asp"
				   , {  Tarea:6
					   ,Prov_ID:$("#Prov_ID").val()
					   ,OC_ID:$("#OC_ID").val()
					   ,Usu_ID:$("#IDUsuario").val()
					   ,CC_ID:Valor
					   ,Chkd:Chkdo
			}, function() {
				var sMensaje = "Se registro el cambio en el centro de costo "
				var sTitulo = "Cambio correcto"	
				Avisa("success",sTitulo,sMensaje)	 			
			});			
	});    
    
    
    
	function CambioCompania() {
		
		$.post( "/pz/fnd/OC/Ajax.asp"
				   , {  Tarea:4
					   ,Prov_ID:$("#Prov_ID").val()
					   ,OC_ID:$("#OC_ID").val()
					   ,Usu_ID:$("#IDUsuario").val()
					   ,Com_ID:$("#Com_ID").val()
			}, function() {
				var sMensaje = "Se cambio la compa&ntilde;ia correctamente "
				var sTitulo = "Cambio correcto"	
				Avisa("success",sTitulo,sMensaje)	 			
			});		
			
			
	}

    $(".objCBO").select2({
        /*placeholder: "Selecciona un equipo de ventas",
        allowClear: false*/
    });     
    
	function CambioGasto() {
		
		$.post( "/pz/fnd/OC/Ajax.asp"
				   , {  Tarea:5
					   ,Prov_ID:$("#Prov_ID").val()
					   ,OC_ID:$("#OC_ID").val()
					   ,Usu_ID:$("#IDUsuario").val()
					   ,Tg_ID:$("#Tg_ID").val()
			}, function() {
				var sMensaje = "Se cambio el tipo de gasto correctamente "
				var sTitulo = "Cambio correcto"	
				Avisa("success",sTitulo,sMensaje)	 			
			});			
	}
	
</script>

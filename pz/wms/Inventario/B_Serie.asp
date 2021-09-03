<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
  var Serie = Parametro("Serie", "") 
%>

<div id="wrapper">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-9">
              <div class="ibox"> 
                <div class="ibox-content">
                    <div class="row"> 
                        <div class="col-sm-12 m-b-xs">        
                            <div class="row">
                                <label class="col-sm-2 control-label">Serie:</label>
                                <div class="col-sm-4 m-b-xs">
                                <input id="input_Serie" class="input-sm form-control" type="text" 
                                       value="<%=Serie%>" style="width:200px">
                                </div>
                                <div class="col-sm-6 m-b-xs">
                                    &nbsp;
                                </div>
                            </div>    
                        </div>
                    </div>
                 </div>   
                 <div class="ibox-content"  id="divSerie"></div>
              </div>
            </div>
            <div class="col-sm-3">
                <div id="divLateral1"></div>
                <div id="divLateral2"></div>
            </div>
        </div>
    </div>
</div>
                           
<script type="application/javascript">



$(document).ready(function(){
  
	$('#input_Serie').focus();
	$('#input_Serie').on('change',function(e) {
		e.preventDefault()
		CargaDatos()
	});
     
     
	<%if( Serie != ""){%>
		CargaDatos()
	<%}%>
     
});
  
    function CargaDatos(){
		Serie.Cargando($("#divSerie"));
		$("#divSerie").load("/pz/wms/Inventario/B_Serie_Resultado.asp",
		{Serie:$("#input_Serie").val()
		}).show()
		
		$("#input_Serie").val("")
		$("#input_Serie").focus();
    }

	 function CargarTRA(TRA){

	   var sDatos = "TA_ID=" + TRA 
	   $("#Contenido").load("/pz/wms/TA/TA_Ficha.asp?" + sDatos)

	}	
	
	 function CargarOV(OV){

		var sDatos = "OV_ID=" + OV 
			  	
		$("#Contenido").load("/pz/wms/OV/OV_Ficha.asp?" + sDatos)
	
	}	
	 function CargarOC(OC, Cli){

		var sDatos = "CliOC_ID=" + OC
		  	   sDatos += "&Cli_ID=" + Cli
			  	
		$("#Contenido").load("/pz/wms/OC/Cli_OrdenCompra.asp?" + sDatos)
	
	}	
	

function loading(view){ 

	var loading = '<div class="spiner-example">'+
				   ' <div class="sk-spinner sk-spinner-three-bounce">'+
						'<div class="sk-bounce1"></div>'+
					   ' <div class="sk-bounce2"></div>'+
					  '  <div class="sk-bounce3"></div>'+
				   ' </div>'+
			   ' </div>'
	view.hide('slow')  
	view.html(loading)	   
	view.show('slow')  
}
	 
var Serie = {
	Cargando:function(view){
		loading(view)
	},
	ASN:function(Inv_ID,Cli_ID){
		var data = {
			Inv_ID:Inv_ID,
			Cli_ID:Cli_ID
		}
		$("#divLateral1").load("/pz/wms/Inventario/Serie_ASN.asp",data)
		
	},
	TRA_Pedidos:function(Inv_ID){
		$("#dvTA").hide('slow',function(){
			$(this).html(Global_loading);
			$(this).show('slow');
		})
		$("#dvTA").load("/pz/wms/Inventario/Serie_TRA.asp",{Inv_ID:Inv_ID},function(){
			$(this).hide('slow',function(){
				$(this).show('slow');
			});
		})
	},
	SO_Pedidos:function(Inv_ID){
		$("#dvOV").hide('slow',function(){
			$(this).html(Global_loading);
			$(this).show('slow');
		})

		$("#dvOV").load("/pz/wms/Inventario/Serie_OV.asp",{Inv_ID:Inv_ID},function(){
			$(this).hide('slow',function(){
				$(this).show('slow');
			});
		})
	}
	
	
}
    
</script>  

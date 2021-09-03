<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	
	var Transfer = "SELECT TOP 30 * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Numero FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Nume "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " ,TA_TipoDeRutaCG94 as TipoTienda "
		Transfer += " ,[dbo].[fn_CatGral_DameDato](94,TA_TipoDeRutaCG94) Tipo "
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE TA_ArchivoID = "+TA_ArchivoID
		Transfer += " AND TA_EstatusCG51 < 4 "
		Transfer += " ORDER BY TA_Orden ASC "

     var rsTran = AbreTabla(Transfer,1,0)
	 if(!rsTran.EOF){
		 var TA_TipoTransferenciaCG65 = rsTran.Fields.Item("TA_TipoTransferenciaCG65").Value 
	 }
	 
	 
	 
%>
<div class="wrapper wrapper-content animated fadeInRight">
      <div class="ibox-content">
        <div class="row">
            <div class="col-md-4">
                <div id="Procesado"></div>
            </div> 
            


            
            <div class="col-md-3">
                <div class="input-group">
                <input type="text" autocomplete="on" class="form-control txtBuscador" placeholder="Busca el TRA que sea" value=""/>
                <span class="input-group-btn"><a title="Buscar" class="btn btn-success btnBusc"><i class="fa fa-search"></i></a></span>
                <span class="input-group-btn"><a title="ESC" class="btn btn-danger btnBorraTRA"><i class="fa fa-trash"></i></a></span>
                </div>
            </div>
            
          <div class="col-md-4 text-right">
              <div class="btn-group" role="group" aria-label="Basic example">
                <button type="button" class="btn btn-primary btnRecarga"><i class="fa fa-refresh"></i>&nbsp;&nbsp;Carga nuevos TRA</button>  
                <button type="button" class="btn btn-warning btnPendientes"><i class="fa fa-exclamation"></i>&nbsp;&nbsp;Pendientes Hoja</button>  
            </div>
            
         </div>
      </div>
    </div>
	<div id="Cargando" class="text-center">
        <div class="ibox-content">
            <div class="spiner-example">
            <div class="sk-spinner sk-spinner-wandering-cubes">
            <div class="sk-cube1"></div>
            <div class="sk-cube2"></div>
            </div>
            </div> 
            <div>Cargando transferencias espere un momento por favor...</div>   
        </div> 
	</div>
	<div id="ContenidoSurtido">
    </div>
</div>
 
<!--<script src="/pz/wms/Transferencia/Transferencia_Surtido.js"></script>
--><script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="application/javascript">

$(document).ready(function(e) {
	var Data = {
		TA_ArchivoID:$('#TA_ArchivoID').val(),
		IDUsuario:$('#IDUsuario').val()
	}
    CargaSurtido(Data);
});


$('.btnRecarga').click(function(e) {
    e.preventDefault();
	var Data = {
		TA_ArchivoID:$('#TA_ArchivoID').val(),
		IDUsuario:$('#IDUsuario').val()
	}
	CargaSurtido(Data);
});

$('.btnBorraTRA').click(function(e) {
    e.preventDefault();
	$('.txtBuscador').val("")
	$('.txtBuscador').focus()
});

$('.btnPendientes').click(function(e) {
    e.preventDefault();
	var Data = {
		TA_ArchivoID:$('#TA_ArchivoID').val(),
		IDUsuario:$('#IDUsuario').val(),
		Pendiente:1
	}
	CargaSurtido(Data);
});

$('.btnBusc').click(function(e) {
    e.preventDefault();
	CargaSurtido();
});


$('.txtBuscador').on('keypress',function(e) {
    if(e.which == 13) {
		CargaSurtido();
    }
});

function CargaSurtido(){
	var DatoIngreso = $('.txtBuscador').val();
		DatoIngreso = DatoIngreso.replace("'","-")
		
	var request = {
		TA_Folio:DatoIngreso,
		IDUsuario:$('#IDUsuario').val()
	}	
	
    $('#ibox2').children('.ibox-content').toggleClass('sk-loading');
	Procesado();
	$('#Cargando').show('slow')
	
	console.log(request)
	$.ajax({
		type: 'POST',
		async:true,
		data:request,
		cache:false,
		url: "/pz/wms/Transferencia/Formatos/ELEKTRA/Transferencia_Generico.asp",
		success: function(data){
			console.log(data)
			$('#Cargando').hide('slow')
			if(data != ""){
				$('html, body').animate({ scrollTop: $('#ContenidoSurtido').offset().top }, 'slow');
				$('#ContenidoSurtido').html(data)	
			}else{
				$('#Cargando').hide('slow')
				swal({
				  title: data.data.message,
				  text: "Elektra no gener&oacute; correctamente el documento",
				  type: "warning",
				  confirmButtonClass: "btn-success",
				  confirmButtonText: "Ok" ,
				  closeOnConfirm: true,
				  html: true
				},
				function(data){
				});		
			}
		},
		error: function(){
		    $('#Cargando').hide('slow')
			swal({
			  title: "Ocurri&oacute; un error "+request.TA_Folio,
			  text: "Intenta buscar de nuevo",
			  type: "error",
			  confirmButtonClass: "btn-success",
			  confirmButtonText: "Ok" ,
			  closeOnConfirm: true,
			  html: true
			});		
		}
	});
	
	
//	$.post("/pz/wms/Transferencia/Formatos/ELEKTRA/Transferencia_Generico.asp",	request, function(data){
//		$('#Cargando').hide('slow')
//		if(data != ""){
//			$('html, body').animate({ scrollTop: $('#ContenidoSurtido').offset().top }, 'slow');
//			$('#ContenidoSurtido').html(data)	
//		}
//	});
}

function Procesado(){
	$('#Procesado').hide('slow')
	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",{
		TA_ArchivoID:$('#TA_ArchivoID').val(),
		Tarea:8
	}
	, function(data){
		if(data != ""){
			$('#Procesado').show('slow')
			$('#Procesado').html(data)	
		}
	});
}

$('.btnSendHoja').click(function(e) {
    e.preventDefault();
	var TA_ID = $(this).data('taid')
	$.ajax({
		type: 'GET',
		contentType:'application/json',
		url: "https://elektra.lydeapi.com/api/recupera/hoja/ruta?TA_ID="+TA_ID,
		success: function(data){
			console.log(data) 
			if(data.data.result != -1){
				Avisa("success","Aviso","Hoja de ruta recibida");
				if(data.data.data.folios != null){
					TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de ruta "+data.data.data.folios[0])
				}
			}else{
				swal({
				  title: data.data.message,
				  text: "Elektra no gener&oacute; correctamente el documento",
				  type: "warning",
				  confirmButtonClass: "btn-success",
				  confirmButtonText: "Ok" ,
				  closeOnConfirm: true,
				  html: true
				},
				function(data){
				});		
			}
		}
	});
});


</script>
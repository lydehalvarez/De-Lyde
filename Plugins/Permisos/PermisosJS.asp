
<script language="JavaScript">
<!--
 
function GuardaValores(iIDSeguridad ,iEsFuncion ,iValorPermiso ,bChecado ,iAvisa, iUsuariosaliendoGrupo) {
	
	if (iUsuariosaliendoGrupo == 1) {
		//$("#dvError").html('/Plugins/Permisos/Permisos_Ajax.asp?Tarea=4&Gru_ID=' + $("#sGru_ID").val() + '&Usu_ID=' + $("#Usu_ID").val() + '&iqCli_ID=' + $("#iqCli_ID").val() );
		
		
		$.post("/Plugins/Permisos/Permisos_Ajax.asp", 
			{ Tarea:4
			 ,Gru_ID:$("#sGru_ID").val()
			 ,Usu_ID:$("#Usu_ID").val()
			 ,iqCli_ID:$("#iqCli_ID").val()
			 ,SistemaActual:$("#SistemaActual").val()
			 ,SistemaATrabajar:$("#SistemaATrabajar").val()
			},function(data) {
				$("#sUsuConGpo").val(0);
				$("#sGru_ID").val(-1);
				$("#sUsu_ID").val($("#Usu_ID").val());			
				$("#dvAviso").empty();	
				GuardaElPermiso(iIDSeguridad ,iEsFuncion ,iValorPermiso ,bChecado ,iAvisa, iUsuariosaliendoGrupo);			
			});
	} else {
		GuardaElPermiso(iIDSeguridad ,iEsFuncion ,iValorPermiso ,bChecado ,iAvisa, iUsuariosaliendoGrupo);	
	}
}

function GuardaElPermiso(iIDSeguridad ,iEsFuncion ,iValorPermiso ,bChecado ,iAvisa, iUsuariosaliendoGrupo) {
	
		var Quitar = 0
		if (bChecado) { Quitar = 1 }
		
		var iTarea = 2;
		if (parseInt(iEsFuncion) == 1) { iTarea = 3 }
		
//		var sData = "Tarea=" + iTarea
//			sData += "&Seg_ID=" + iIDSeguridad
//			sData += "&TipoPermiso=" + iValorPermiso
//			sData += "&Quitar=" + Quitar 
//			sData += "&Gru_ID=" + $("#sGru_ID").val()
//			sData += "&Mnu_ID=" + $("#Mnu_ID").val()
//			sData += "&Usu_ID=" + $("#sUsu_ID").val()
//			sData += "&SistemaATrabajar=" + $("#SistemaATrabajar").val()
//			sData += "&sUsuConGpo=" + $("#sUsuConGpo").val()
//		$("#dvError").html("/Plugins/Permisos/Permisos_Ajax.asp?" + sData );
		
		$.post("/Plugins/Permisos/Permisos_Ajax.asp", 
				{ Tarea:iTarea
				 ,Seg_ID:iIDSeguridad
				 ,TipoPermiso:iValorPermiso
				 ,Quitar:Quitar 
				 ,Gru_ID:$("#sGru_ID").val()
				 ,Mnu_ID:$("#Mnu_ID").val()
				 ,Usu_ID:$("#sUsu_ID").val()
				 ,SistemaATrabajar:$("#SistemaATrabajar").val()
				 ,iqCli_ID:$("#iqCli_ID").val()
			     ,SistemaActual:$("#SistemaActual").val()
				 ,sUsuConGpo:$("#sUsuConGpo").val()
				},function(data) {
					if(iAvisa==1) {
						var iresul = parseInt(data)
						if (iresul==0) {
							sMensaje= "Ocurrio un error desconocido al guardar el permiso, notifique al administrador"
							$.jGrowl(sMensaje, { header: 'Error', sticky: true, life: 2500, glue:'before'});
						}
						if (iresul==1) {
							$.jGrowl("El permiso fue revocado correctamente", { header: 'Permiso revocado', sticky: false, life: 2500, glue:'before'});	
						}
						if (iresul==2) {
							$.jGrowl("El permiso fue otorgado correctamente", { header: 'Permiso otorgado', sticky: false, life: 2500, glue:'before'});	
						}	
					}
					ValidaChecks();
		});
		
}


var oPrevElement;

function styleSwap(oElement, sEvent, sOff, sOn) {
	var cssClass
    if(sEvent == 'click') {
        if(oPrevElement != null) {
            oPrevElement.className = sOff;
        }
        if (oElement) { oElement.className = sOff; }
        oPrevElement = oElement; 
    }
    else {
        
        if (sEvent=='hover') cssClass = sOn;
        else cssClass = sOff;
        if (oPrevElement==null) {
            oElement.className = cssClass;
        }
        else {
            if(oPrevElement.id != oElement.id) {
                oElement.className = cssClass;
            }
        }
    }
}

function Notifica() {
	if (document.frmDatos.Notifica.value == 1) {
		//$.jGrowl("Los permisos se guardaron correctamente", { header: 'Aviso', sticky: false, life: 3500, glue:'before', position:'center' });	
		var sErrMsg  = "<p id=\"MsgBoxTitulo\"><strong>OK:</strong></p>"
		sErrMsg += "<p>Los permisos se guardaron correctamente<br><br>"
		$.msgbox(sErrMsg, {type: "info"});
	}
}


function CheckAll(){
	for (var i=0;i<document.frmDatos.elements.length;i++)	{
		var e = document.frmDatos.elements[i];
		if ((e.name == 'chkSeg') && (e.type=='checkbox')) {
		e.checked = document.frmDatos.chkTodos.checked;
		}
	}
}


function CambiaCombo(e) {
	LlenaConPermisos(e.value)
}

function ValidaChecks() {
	var itotalDeChecks = 0;
	var iChecksChecados = 0;
	$('.chSeg').each(function(){
		itotalDeChecks++;
		if ($(this).is(':checked')) {
			iChecksChecados++;	
		}
	});
	$("#chTodos").attr('checked',(itotalDeChecks == iChecksChecados));
}

function LlenaConPermisos(IDMenu) {
	$("#MatrizSeguridad").empty();
	$("#MatrizSeguridad").html('<img src="/images/Ajax_CirculoVerde.gif" width="106" height="98" border="0" class="IconoEspera"/>')
	sMensaje = "Cargando informaci&oacute;n";
		$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
	 
	  
	$.post("/Plugins/Permisos/Permisos_Ajax.asp", { Tarea:1,Gru_ID:$("#sGru_ID").val(),Usu_ID:$("#sUsu_ID").val()
	                                                ,SistemaATrabajar:$("#SistemaATrabajar").val()
													,iqCli_ID:$("#iqCli_ID").val()
													,SistemaActual:$("#SistemaActual").val()
	                                                ,Mnu_ID:IDMenu,sUsuConGpo:$("#sUsuConGpo").val()},function(data) {
	if (data != "") {
//		var sTmp = String(data);
//		arrDatos = sTmp.split("|");
//		$("#Cue_Nombre").val(arrDatos[0]);
//		if (arrDatos[1] == 1) {
//			$('input[name=Cue_Habilitado]').attr('checked', true);
//		} else {
//			$('input[name=Cue_Habilitado]').attr('checked', false);	
//		}
//		$("#Cue_DescripcionCorta").val(arrDatos[2]);
//		$("#Cue_Descripcion").val(arrDatos[3]);
		$("#MatrizSeguridad").html(data);
		//comprobando si todos estan habilitados
		ValidaChecks();
	} else {
		sMensaje = "Error al cargar los permisos del grupo, avise al administrador";
		$.jGrowl(sMensaje, { header: 'Aviso', sticky: true, life: 2500, glue:'before'});
	}
});
}

//-->
</script>
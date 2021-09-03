<script type="text/javascript" src="/js/jquery.form.js"></script>
<script language="JavaScript">
<!--
//Permisos/GrupoPermisosJS.asp
function AcFGuardar()   {
	document.frmDatos.Accion.value ="Guardar";	
	document.frmDatos.Modo.value = "Editar";
	$('#frmDatos').submit();
}
 

function CambiaCombo() { 
	document.frmDatos.Accion.value ="Vuelta";	
	document.frmDatos.Modo.value = "Editar";
	$('#frmDatos').submit();
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


//-->
</script>
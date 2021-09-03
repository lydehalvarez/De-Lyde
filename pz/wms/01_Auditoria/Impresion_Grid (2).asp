<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
    var bDebIQ = false
   
	var SKU = Parametro("SKU","")
    var Aud_ID = Parametro("Aud_ID",-1)
    var Pro_ID = Parametro("Pro_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
   
    var iAudUAsignadoA = Parametro("AudU_AsignadoA",-1)
    var iAudUTipoConteoCG142 = Parametro("AudU_TipoConteoCG142",-1)
    var iUbiID = Parametro("Ubi_ID",-1)
    var sPtSKU = Parametro("Pt_SKU",-1)
    var iAudUVeces = Parametro("AudU_Veces",-1)
    var iPtResultadoCG147 = Parametro("Pt_ResultadoCG147",-1)
    var sLPN = Parametro("LPN","")
    var iAudUImpreso = Parametro("AudU_Impreso","")

    //Response.Write("IDUsuario: " + Parametro("IDUsuario",-1))   
   
   
var sSQL = " SELECT AUDUBI.Aud_ID, AUDUBI.Pt_ID "
    sSQL += ", AUDUBI.AudU_ID, AUDUBI.AudU_Veces, AUDUBI.AudU_Impreso " 
    sSQL += ",ISNULL((SELECT UBI.Ubi_Nombre FROM Ubicacion UBI WHERE UBI.Ubi_ID = "
    sSQL += "     (SELECT AUDPALL.Ubi_ID FROM Auditorias_Pallet AUDPALL "
    sSQL += "           WHERE AUDPALL.Pt_ID = AUDUBI.Pt_ID  AND AUDPALL.Aud_ID = " 
    sSQL += "                AUDUBI.Aud_ID)),'') AS UBICACION "
    sSQL += ",ISNULL((SELECT UBA.Are_Nombre FROM Ubicacion_Area UBA " 
	sSQL += "      WHERE UBA.Are_ID = (SELECT UB.Are_ID FROM Ubicacion UB "
	sSQL += "              WHERE UB.Ubi_ID = (SELECT AUDPALL.Ubi_ID FROM Auditorias_Pallet AUDPALL "
	sSQL += "                  WHERE AUDPALL.Pt_ID = AUDUBI.Pt_ID "
    sSQL += " AND AUDPALL.Aud_ID = AUDUBI.Aud_ID))),'') AS AREA "
    sSQL += ",ISNULL((SELECT AUDPALI.Pt_LPN FROM Auditorias_Pallet AUDPALI "
    sSQL += "   WHERE AUDPALI.Pt_ID = AUDUBI.Pt_ID AND AUDPALI.Aud_ID = AUDUBI.Aud_ID),'') AS LPN "
    sSQL += ",ISNULL((SELECT AUDPALIII.Pt_SKU FROM Auditorias_Pallet AUDPALIII "
    sSQL += "           WHERE AUDPALIII.Pt_ID = AUDUBI.Pt_ID AND AUDPALIII.Aud_ID = AUDUBI.Aud_ID),'') "
    sSQL += "                 AS ARTICULO_SKU "
    sSQL += ",ISNULL((SELECT PRO.Pro_Nombre FROM Producto PRO WHERE PRO.Pro_ID = "
    sSQL += " (SELECT AUDPALLE.Pro_ID FROM Auditorias_Pallet AUDPALLE "
    sSQL += "    WHERE AUDPALLE.Pt_ID = AUDUBI.Pt_ID AND AUDPALLE.Aud_ID = AUDUBI.Aud_ID)),'') AS PRODUCTO "
    sSQL += ",ISNULL((SELECT U.Usu_Nombre FROM Usuario U "
    sSQL += "         WHERE U.Usu_ID = AUDUBI.AudU_AsignadoA),'') AS AUDITOR "
    sSQL += ",(SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 142 "
    sSQL += " AND Cat_ID = AUDUBI.AudU_TipoConteoCG142) TIPOCONTEO "
    sSQL += ",CASE AudU_Terminado WHEN 1 THEN 'Contada' WHEN 0 THEN 'No esta iniciada' ELSE '' END AS ESTATUS "
    sSQL += " FROM Auditorias_Ubicacion AUDUBI "
   
    var sCondAudUbi = "AUDUBI.Aud_ID = " + Aud_ID
   
    if(iAudUAsignadoA > -1 ){
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.AudU_AsignadoA = " + iAudUAsignadoA
    }
   
    if(iAudUTipoConteoCG142 > -1 ){ 
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.AudU_TipoConteoCG142 = " + iAudUTipoConteoCG142
    }  
    
    if(iAudUVeces > -1 ){
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.AudU_Veces = " + iAudUVeces
    }  
    
    if(iPtResultadoCG147 > -1 ){ 
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.Pt_ID = (SELECT AUDPALI.Pt_ID FROM Auditorias_Pallet AUDPALI "
        sCondAudUbi += "                  WHERE AUDPALI.Pt_ID = AUDUBI.Pt_ID AND AUDPALI.Aud_ID = AUDUBI.Aud_ID "
        sCondAudUbi += "                        AND AUDPALI.Pt_ResultadoCG147 = "+iPtResultadoCG147+") "
    
    }
    
    if(iUbiID > -1 ){ 
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.Pt_ID IN (SELECT UBIP.Pt_ID FROM Auditorias_Pallet UBIP "
        sCondAudUbi += " WHERE UBIP.Aud_ID = "+Aud_ID+" AND UBIP.Ubi_ID ="+iUbiID+")"
    
    }
    
    if(sPtSKU > -1 ){ 
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.Pt_ID IN (SELECT UBIP.Pt_ID FROM Auditorias_Pallet UBIP "
        sCondAudUbi += " WHERE UBIP.Aud_ID = "+Aud_ID+" AND UBIP.Pt_SKU ="+sPtSKU+")"
    
    }    

    if(sLPN != "" ){ 
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.Pt_ID IN (SELECT UBIP.Pt_ID FROM Auditorias_Pallet UBIP "
        sCondAudUbi += " WHERE UBIP.Aud_ID = "+Aud_ID+" AND UBIP.Pt_LPN LIKE '%"+sLPN+"%')"
    
    }    
        
    if(iAudUImpreso > 0 && !EsVacio(iAudUImpreso) ){ 
        if (sCondAudUbi != "") { sCondAudUbi += " AND " }
        sCondAudUbi += " AUDUBI.AudU_Impreso = " +iAudUImpreso
    }          
    
    if (sCondAudUbi != "") {
        sSQL += " WHERE " + sCondAudUbi
    }    

    sSQL += " ORDER BY UBICACION, ARTICULO_SKU "
    
    if(bDebIQ){

       //Response.Write("AudU_ID: " + Parametro("AudU_ID",-1) + "<br>")
       Response.Write(sSQL)
    }   
   
    var iSonTotalBusqueda = BuscaSoloUnDato("COUNT(*)","Auditorias_Ubicacion AUDUBI",sCondAudUbi,0,0)
    
    
    
%>
<span class="text-muted small pull-right">Total de b&uacute;squeda:&nbsp;<strong><%=iSonTotalBusqueda%></strong></span>
<hr>    
<table class="table table-striped table-hover table-bordered" width="100%">
	<thead>
    	<tr>
            <th width="24" class="text-center" align="center" valign="middle"><input type="checkbox" name="chkTodos" class="chkTodos" /></th>
            <th width="24" class="text-center">Num.</th>
            <th width="24" class="text-center">Bloque Impresi&oacute;n</th>
        	<th class="text-left">Ubicaci&oacute;n</th>
        	<th class="text-left">LPN</th>
            <th class="text-left">Art&iacute;culo</th>
        	<th class="text-left">Auditor</th>
        	<th class="text-left">Tipo conteo</th>
        	<th class="text-center">Estatus</th>
            <th width="87">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <%
    var Pt_ID = -1
    var sEtiqueta = ""
	var strArea = ""
    var iRegistros = 0
    var iAudUImpreso = 0
	
	var rsInv = AbreTabla(sSQL,1,0)
       
	if(!rsInv.EOF){
		while(!rsInv.EOF){
       
		    Pt_ID = rsInv.Fields.Item("Pt_ID").Value
            /*sEtiqueta = rsInv.Fields.Item("Ubi_Etiqueta").Value*/
		    strArea = rsInv.Fields.Item("AREA").Value
            iAudUImpreso = rsInv.Fields.Item("AudU_Impreso").Value
            iRegistros++
       
            if(sEtiqueta != "") {
                sEtiqueta = "<br><small>" + sEtiqueta + "</small>"
            }
       
	%>
	<tr>
        <td class="text-center" valign="middle">
            <input type="checkbox" id="chkPtID" class="chkPtID" data-ptid="<%=Pt_ID%>" value="<%=Pt_ID%>" <%//=chkExHabilitado%> >
        </td>
        <td class="text-center"><%=iRegistros%></td>
        <td class="text-center"><%=iAudUImpreso%></td>
    	<td class="text-left"><%=rsInv.Fields.Item("UBICACION").Value%>
            <br><small><%=strArea%></small>
        </td>
    	<td class="text-left"><small><%=rsInv.Fields.Item("LPN").Value%></small></td>
        <td class="text-left"><%=rsInv.Fields.Item("ARTICULO_SKU").Value%><br>
            <small><%=rsInv.Fields.Item("PRODUCTO").Value%></small>
            </td> 
    	<td class="text-left"><small><%=rsInv.Fields.Item("AUDITOR").Value%></small></td>
    	<td class="text-left"><small><%=rsInv.Fields.Item("TIPOCONTEO").Value%></small></td>
    	<td class="text-left"><small><%=rsInv.Fields.Item("ESTATUS").Value%></small></td>
    	<td valign="middle" class="text-center">
			<button class="btn btn-info btnImprimeIndv btn-xs" data-audid="<%=rsInv.Fields.Item("Aud_ID").Value%>" data-ptid="<%=Pt_ID%>"><i class="fa fa-print"></i>&nbsp;&nbsp;<span class="bold">Imprimir</span></button>
		</td>
    </tr>
	<%
            rsInv.MoveNext()
        } 
    rsInv.Close()
	} else {
	%>
	<!--tr>
    	<td colspan="9">No se encontraron ubicaciones por auditar</td>
    </tr-->
    <tr class="odd">
        <td colspan="9" align="center" valign="top" class="dataTables_empty">No se encontraron ubicaciones por auditar</td>
    </tr>        
	<%
	}
    %>
    </tbody>
</table>
<script language="javascript">

$(document).ready(function() {
    
    $(".chkTodos").click(function(){
        //Click y checked
        var objChkTodos = $(this);
        var ChecadoPt = objChkTodos.is(':checked');
        //console.log("Checked Todos: " + ChecadoPt);
        //Si checked es true
        if(ChecadoPt){
            $(".chkPtID").prop("checked",true);
        } else {
            $(".chkPtID").prop("checked",false);
        }
    });
    
    
    $(".chkPtID").click(function(e) {
    
        //console.log("Longitud total individual: "+ $(".chkPtID").length + " | LongitudChecada Individual: " + $(".chkPtID:checked").length);
        
        if(parseInt($(".chkPtID").length) == parseInt($(".chkPtID:checked").length)) {
            //console.log("CheckTodos true");
            $(".chkTodos").prop("checked",true);
            
        } else {
            //console.log("CheckTodos false");
            $(".chkTodos").prop("checked",false);
        }

    });    
        
                
    $('.btnImprimeIndv').click(function(e) {
        e.preventDefault();
        RecepImprime($(this).data("audid"),$(this).data("ptid"));
    });        
        
        
    function RecepImprime(f,o){
        var newWin=window.open("/pz/wms/Auditoria/Impresion_Papeleta2.asp?Aud_ID="+f+"&PT_ID="+o);
    }        
    
    
    $('#btnAsignar').click(function(e){
        e.preventDefault();
        
        var sSelec = '';
        var bMensaje = true;;
        var iAuditor = $("#cbAuditor").val();
        
        
        $('.chkPtID').each(function(){
            if (this.checked) {
                if(sSelec != ''){ sSelec += ','}
                sSelec += $(this).val();
                bMensaje = false;
            }
        }); 
        
        var bolError = false;
		var arrError = [];
		
		if(sSelec == ""){
			bolError = true
			arrError.push("Seleccionar al menos una ubicaci&oacute;n a asignar");
		}

		if(iAuditor == -1){
			bolError = true
			arrError.push("Seleccionar un Auditor, para su asignaci&oacute;n");
		}        
        
        if( bolError ){
			
			Avisa("warning", "Asignaci&oacute;n de Auditor", "Verificar formulario<br>" + arrError.join("<br>"));
			
		} else {        
        
            Asigna($("#cbAuditor").val(),sSelec);
        
        }
        /*
        if (bMensaje)
            alert('Debes seleccionar al menos una opción');
        else
            alert('Has seleccionado: '+sSelec); 
        */
    });
    
    
    function Asigna(iAudUAsigA,sArrPtID) {
        
        var sMensaje = "";
						
		$.post("/pz/wms/Auditoria/Impresion_Ajax.asp", 
				{ Tarea:1,Aud_ID:$("#Aud_ID").val(),AudU_AsignadoA:iAudUAsigA,ArrPtID:sArrPtID
				},function(data) {
                    //alert(data);
                    var iresul = parseInt(data);

                    if(iresul == 0){
                        sMensaje= "El Auditor fue revocado correctamente";
                    } else {
                        sMensaje= "El Auditor fue asignado correctamente"; 
                    }
            
                    Avisa("success",'Aviso',sMensaje);
						
		});         
        
        

    }    
    
    
        
    
});  
</script>





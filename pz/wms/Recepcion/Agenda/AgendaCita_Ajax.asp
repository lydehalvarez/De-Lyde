<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var Tarea = Parametro("Tarea", -1)
	var Ag_ID = Parametro("Ag_ID",-1)
	
	var sResultado = ""
	var result = 0
	var message = ""
	var data = ""
	
	
switch (parseInt(Tarea)) {
		case 1:	
	%>
        <div class="form-group">
            <label class="control-label col-md-2">Puerta</label>
            <div class="col-md-3">
                <%
                    var sCond = "Alm_TipoCG88 = 5 AND Alm_ID = 3"
                    CargaCombo("AlmP_ID"," class='form-control' ","AlmP_ID","AlmP_Nombre",
                    "Almacen_Posicion",sCond,"AlmP_Nombre",-1,0,"Selecciona","Editar")
                %>
            </div>
        </div>
	<%
		break;
}
sResultado = '{"result":'+result+',"message":"'+message+'"}'
Response.Write(sResultado)
%>


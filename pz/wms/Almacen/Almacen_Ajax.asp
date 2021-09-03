<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea",-1)
	var Edo_ID = Parametro("Edo_ID",-1)

    var result = ""
    var message = ""
   
	switch (parseInt(Tarea)) {
		case 1://Carga el combo de Aeropuerto
	   
                var sEventos = "class='form-control combman'"
                var sCondicion = "Edo_ID = "+ Edo_ID
                CargaCombo( "CboAer_ID", sEventos, "Aer_ID", "Aer_Nombre", "Cat_Aeropuerto"
                          , sCondicion, "", "Editar", 0, "--Seleccionar--")
%>            
            <script type="text/javascript">
                    $("#CboAer_ID").select2(); 
            </script>
<%     break;

    }
 

%>

<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->

<%

	var Catalogo = "SELECT * FROM Cat_Catalogo WHERE Sec_ID = 34"
	var ID = Parametro("ID",-1)
	var IID = Parametro("IID",-1)
	var Serie = Parametro("Serie",-1)
	var Serializado = Parametro("Serializado",-1)

%>



<div class="row"> 
	<div class="col-md-12">
        <div class="ibox-content">
            <div>
                <label>Condic&oacute;n del producto:</label>&nbsp;&nbsp;&nbsp;
                <label><input class="Cond" type="radio" value="0" id="Buena" name="gpo2"/>&nbsp;Buena </label>
                <label>&nbsp;&nbsp;&nbsp;&nbsp;<input class="Cond" type="radio" value="1" id="Mala" name="gpo2"/>&nbsp;Mala</label>
            </div>
        </div>
        <div class="ibox-content" id="ItemMalEstado">
            <div>
            <table class="table">
            	<thead>
                	<tr>
            			<th>Opci&oacute;n</th>
            			<th>Selecciona</th>
            		</tr>
                </thead>
            <%
			   var rsCat = AbreTabla(Catalogo,1,0)
			   var Cat_Nombre = ""
			   var Cat_ID = ""
				if(!rsCat.EOF){
					while (!rsCat.EOF){
						Cat_ID = rsCat.Fields.Item("Cat_ID").Value
						Cat_Nombre = rsCat.Fields.Item("Cat_Nombre").Value
			
			%>
                	<tr>
                    	<td><%=Cat_Nombre%></td>
                    	<td><input class="Percance" type="checkbox" value="<%=Cat_ID%>"/></td>
					</tr>            
                
			<%
                rsCat.MoveNext() 
                }
            rsCat.Close()
			}
            %>       
            </table>
            </div>
        </div>
    </div>
</div>


<input type="hidden" id="iD" value="<%=ID%>"/>
<input type="hidden" id="iiD" value="<%=IID%>"/>
<input type="hidden" id="Serie" value="<%=Serie%>"/>
<input type="hidden" id="Serializado" value="<%=Serializado%>"/>


<script type="application/javascript">

$('#ItemMalEstado').hide();

$('.Cond').iCheck({ radioClass: 'iradio_square-green'}); 
$('.Percance').iCheck({ checkboxClass: 'icheckbox_square-green'}); 

$('.Cond').on('ifChanged', function(event) {
	if($(event.target).val() == 1){
		$('#ItemMalEstado').show('slow');
	}else{
		$('.Percance').iCheck('uncheck');
		$('#ItemMalEstado').hide('slow');
	}
});

$('.Percance').on('ifChanged', function(event) {
	if(event.target.checked){
		console.log("Check")
	}else{
		console.log("UnCheck")
	}
});

</script>

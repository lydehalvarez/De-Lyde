<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2	2020-JUN-09 Agregado de impresion: Se agregan Botones para imprimir

    var urlBaseTemplate = "/Template/inspina/";
%>
    <link href="<%= urlBaseTemplate %>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%= urlBaseTemplate %>css/plugins/dropzone/basic.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>css/plugins/dropzone/dropzone.css" rel="stylesheet">
    
    <link href="<%= urlBaseTemplate %>css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
    <link href="<%= urlBaseTemplate %>css/style.css" rel="stylesheet">

    <script src="<%= urlBaseTemplate %>js/jquery-3.1.1.min.js"></script>
    <script src="<%= urlBaseTemplate %>js/bootstrap.min.js"></script>
    <script src="<%= urlBaseTemplate %>js/inspinia.js"></script>

    <!-- DROPZONE -->
    <script src="<%= urlBaseTemplate %>js/plugins/dropzone/dropzone.js"></script>

    <script type="text/javascript">

        $(document).ready(function(){
          $("#limpiar").on("click", function() {
              var arrFiles = $('.dropzone')[0].dropzone.files;

              arrFiles.forEach(function(file) { 
                file.previewElement.remove(); 
              });

              arrFiles.splice(0, arrFiles.length);

              $('.dropzone').removeClass('dz-started');
          });
        })
       
    </script>

    <script type="text/javascript">

      Dropzone.options.dropzoneForm = {
          paramName: "file"
        , maxFilesize: 4
        , dictDefaultMessage: "<i class='fa fa-file-text-o fa-5x'></i><br><strong>Zona de carga de archivos. </strong></br>dar click aqu&iacute;"
        , addRemoveLinks: true
        , dictRemoveFile: "Eliminar"
        , dictCancelUpload: "Cancelar Carga"        
      };
     
    </script>

  <form action="#" class="dropzone" id="dropzoneForm">

    <div class="fallback">
      <input name="inpFile" id="inpFile" type="file" multiple />
    </div>
      
  </form>
  <button id="limpiar">Limpiar</button>
    
    
aqui va el token

<p>token</p>
<p id="dvrespuesta"></p>

<script>
	$(document).ready(function() {


        dametoken()
        
    });
    
    
 	function dametoken() {
                              
	
 
        
        
        $.post("https://dev.izziapiweb.mx/sandbox/v1/inventory/selectSim/oauth2/token"
                       ,{client_id:'lyde',client_secret:'lyde_secret'
                         ,'provision_key':'QojzkXTaJemBzTRspGzY2qo8ywpoiJfp',scope:'write'})
            .done(function(data){
                 $("#dvrespuesta").html(data)
              }, "json")
            .fail(function(xhr, textStatus, error){
                console.log(xhr.statusText);
                console.log(textStatus);
                console.log(error);
                $("#dvrespuesta").html(error)
              });

        
//        $.ajax({
//            type: "POST",
//            url: URL,
//            data: DATA,
//            dataType: "json",
//            success: function (json) {
//                //Do something with the returned json object.
//            },
//            error: function (xhr, status, errorThrown) {
//                //Here the status code can be retrieved like;
//                xhr.status;
//
//                //The message added to Response object in Controller can be retrieved as following.
//                xhr.responseText;
//            }
//        });
        
        
		
	}       
    
    
</script>	


    $("#MenuPrincipal li").each(function(){
	 	var c = $(this);
        	
        if( $("#MNUSL").val() == c.data("mnuid") ) {
            c.addClass( "active open" );
            if( c.data("padre") > 0 ) {
            	MarcaElMenuPadre(c.data("padre"));
            }
        }
        
     });
     
     function MarcaElMenuPadre(pp){
     
     	$("#MenuPrincipal li").each(function(){
	 		var c2 = $(this);
     	    if( c2.data("mnuid") == pp ) {
            	c2.addClass( "active open" );
                if( c2.data("padre") > 0 ) {
                    MarcaElMenuPadre(c2.data("padre"));
                }
            }
         });
     	
     }
     
     
     
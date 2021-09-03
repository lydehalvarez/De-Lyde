<%
var Json = {
    Tipo: {
        RecordSet: 1
        , Arreglo: 2
    }
    , Convertir: function( prmObj, prmTipo ){
        
        var strJson = ''
        var bolEsInicio = 0;

        switch( prmTipo ){
            this.Tipo.RecordSet: {
                
                for( var i = 0; !(prmObj.EOF); i++, prmObj.MoveNext() ){
                    strJson += ( i > 0 ) ? "," : "";
                    strJson += "[";
					
					for( var j = 0; j < prmObj.Fields.Count; j++ ){
                        strJson += ( j > 0 ) ? "," : "";
                        strJson += '"' + prmObj.Fields.Item(j).Name + '": "' + prmObj.Fields.Item(j).Value + '"'
                    }

                    strJSON += "]";
                }

            } break;
        }

        return '{' + strJSON + '}'

    }
}
%>
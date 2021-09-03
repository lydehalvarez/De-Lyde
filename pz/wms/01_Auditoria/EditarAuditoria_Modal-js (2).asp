<script type="text/javascript">
    var emptyDateText="dd/mm/aaaa";
    
    $("#clear-form-new-audit").on("click", () => clearForm("#newAuditForm"));

    $("#save-form-new-audit").on("click", saveAudit);

    function clearForm(containerId) {
        var selects = $($(containerId + " select"));
        var dates = $($(containerId + " .date"));
        var texts = $($(containerId + " input:text").not(".date"));
        var textareas = $($(containerId + " textarea"));
        $.each(selects, function (elem) {
            var $element = $(selects[elem]);
            clearIsValidClasses($element);
            $element.val(-1);
        });
        
        $.each(dates, function (elem) {
            var $dates = $(dates[elem]);
            clearIsValidClasses($dates);
            $dates.val(emptyDateText);
            var internalInputs = $dates.data("inputIds").split(",")
            $.each(internalInputs, function (index){
                $("#"+internalInputs[index]).val("");
            });
        });
        
        $.each(texts, function (elem) {
            var $text = $(texts[elem]);
            clearIsValidClasses($text);
            $text.val("");
        });
        
        $.each(textareas, function (elem) {
            var $textArea = $(textareas[elem]);
            clearIsValidClasses($textArea);
            $textArea.val("");
        });

        $("#newAuditRequiredData").hide();
    }

    function saveAudit(e) {
        e.preventDefault();
        if(!isValidForm($(this).data("target"))){
            $("#newAuditRequiredData").show();
            return;
        }

        $("#newAuditRequiredData").hide();
        $("#newModal").modal("hide");
        save(getRequest());
        clearForm("#newAuditForm");
    }

    function save(request) {
        var sTipo = "error";
	    $.post( "/pz/wms/Auditoria/AuditoriaCiclicas_ajax.asp",
            request,
            function(data){
                var response = JSON.parse(data);
			    if(response.result == 1){
			       sTipo = "success";   
			    } 
			    Avisa(sTipo,"Aviso",response.message);
        });
    }

    function isValidForm(formId) {
        var inputs = $(formId).find(".request-input");
        var valid = true;
        $.each(inputs,(index) => {
            valid &= isValid(inputs[index]);
        });

        return valid;
    }

    function isValid(elem) {
        var isValid= true;
        var $elem =$(elem);
        var required = $elem.data("required") ?? false;
        var type = $elem.data("type") ?? "default";
        var val = $elem.val();
        switch(type){
            case "text":
                isValid = required ? val !== "" ? true : false : true;
            break;

            case "date":
            var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
                isValid = required ? dateRegex.test(val) : val === "" ? true : dateRegex.test(val);
            break;
            
            case "select":
                isValid = required ? val !== "-1" ? true : false : true;
            break;

            case "default":
            break;
        }

        setIsValidClass($elem, isValid);
        
        return isValid
    }

    function clearIsValidClasses($elem) {
        var $divElem = $($elem.closest("div .form-group"));
        $divElem.removeClass("has-success");
        $divElem.removeClass("has-error");
    }

    function setIsValidClass($elem, isValid) { 
        var $divElem = $($elem.closest("div .form-group"));
        if(isValid) {
            $divElem.addClass("has-success");
            $divElem.removeClass("has-error");
        }
        else {
            $divElem.addClass("has-error");
            $divElem.removeClass("has-success");
        }
    }

    function getRequest() {
        
        return {
            Client: $("#newAuditClient").val(),
            AuditorResponsable: $("#newAuditResponsableAuditor").val(),
            AuditType: $("#newAuditType").val(),
            AuditTypeWork: $("#newAuditTypeWork").val(),
            InitDate: $("#newAuditInitDate").val(),
            Name: $("#newAuditName").val(),
            Description: $("#newAuditDescription").val(),
            Creator: $("#IDUsuario").val()
        }
    }

</script>

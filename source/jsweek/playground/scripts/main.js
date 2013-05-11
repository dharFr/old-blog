(function(e) {
    "use strict";
    e.fn.red = function(e) {
        return e ? this.removeClass("red") : this.addClass("red");
    };
})(jQuery), $(function() {
    "use strict";
    console.log("Document ready");
});
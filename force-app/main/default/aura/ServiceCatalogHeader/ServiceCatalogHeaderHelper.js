({
    getURLParameter : function(param) {
        var url = new URL(window.location.href);
        return url.searchParams.get(param);
    }
})
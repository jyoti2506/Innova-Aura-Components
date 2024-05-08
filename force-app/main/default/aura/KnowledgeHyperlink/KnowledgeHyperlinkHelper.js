({
    articleUrl : function(component) {
        var baseUrl = '/Service/s/knowledge-article?recId=';
        return baseUrl + component.get("v.articlerecord.Id");
    }
})
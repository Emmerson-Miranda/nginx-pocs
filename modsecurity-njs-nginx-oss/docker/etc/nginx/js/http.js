// Doc https://nginx.org/en/docs/njs/

function echoRequest(r) {
    var a, s, h;

    s = "JS summary\n\n";

    s += "Method: " + r.method + "\n";
    s += "HTTP version: " + r.httpVersion + "\n";
    s += "Host: " + r.headersIn.host + "\n";
    s += "Remote Address: " + r.remoteAddress + "\n";
    s += "URI: " + r.uri + "\n";

    s += "\nHeaders:\n";
    for (h in r.headersIn) {
        s += "  header '" + h + "' is '" + r.headersIn[h] + "' - ";
    }

    s += "\nArgs:\n";
    for (a in r.args) {
        s += "  arg '" + a + "' is '" + r.args[a] + "' - ";
    }

    s += "\n\n" + r.requestBody;
    s += "\n\n";

    r.headersOut["Content-Length"] = s.length;
    r.log("echoRequest - length : " + s.length);
    r.log("echoRequest - body : " + s);
    r.return(200, s);
}


function orchestratingRequest(r) {
    r.log("Starting request ... ");

    function print(name, obj){
        r.log(name + " - status " + obj.status);
        r.log(name + " - requestBody  " + obj.requestBody);
        r.log(name + " - responseBody  " + obj.responseBody);
        var str = "" + obj.responseBody;
        r.log(name + " - responseBodyLength  " + str.length);
        r.log(name + " - uri  " + obj.uri);
        r.log(name + " - method  " + obj.method);
        r.log(name + " - Content-Length  " + obj.headersIn["Content-Length"]);
    }

    function processBackendResponse(reply){
        print("processBackendResponse", reply);
        var str = "" + reply.responseBody;
        r.headersOut["Content-Length"] = str.length;
        r.return(reply.status, reply.responseBody); 
        r.finish();
    }

    function processWafResponse(reply){
        print("processWafResponse", reply);   
    
        if (reply.status == 200) {
            var opts = {  method: r.method, body: r.requestBody };
            r.subrequest("/_myapi/backend", opts, processBackendResponse);
        } else {
            r.return(reply.status, reply.responseBody); 
            r.finish();
        }
    }

    //var h;
    //for (h in r.headersIn) {
    //    r.headersOut[h] = r.headersIn[h];
    //}

    print("orchestratingRequest", r);  

    var opts = {  method: r.method,  body: r.requestBody };
    r.subrequest("/_myapi/waf", opts, processWafResponse);

    //let reply = await ngx.fetch('http://nginx.org/');
    //let body = await reply.text();
    //r.return(200, body);
}

function emptyResponse(r) {
    //this is needed to be called by WAF location otherwise NGINX will return 404
    r.log("emptyResponse");
    r.headersOut["Content-Length"] = "2";
    r.return(200, "Hi"); 
}
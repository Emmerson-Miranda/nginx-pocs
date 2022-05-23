// Doc https://nginx.org/en/docs/njs/
// Doc http://nginx.org/en/docs/http/ngx_http_js_module.html
// Doc http://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_id

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

function print(r, name, obj){
    r.log(name + " - status " + obj.status);
    r.log(name + " - requestBody  " + obj.requestBody);
    r.log(name + " - responseBody  " + obj.responseBody);
    var str = "" + obj.responseBody;
    r.log(name + " - responseBodyLength  " + str.length);
    r.log(name + " - uri  " + obj.uri);
    r.log(name + " - method  " + obj.method);
    r.log(name + " - Content-Length  " + obj.headersIn["Content-Length"]);
}

function processBackendResponse(r, reply){
    print(r, "processBackendResponse", reply);
    var str = "" + reply.responseBody;
    r.headersOut["Content-Length"] = str.length;
    r.return(reply.status, reply.responseBody); 
    r.finish();
}

function processWafResponse(r, reply){
    print(r, "processWafResponse", reply);   

    if (reply.status == 200) {
        var opts = {  method: r.method, body: r.requestBody };
        r.subrequest(r.variables.backendlocation, opts, function(response){processBackendResponse(r, response);});
    } else {
        r.return(reply.status, reply.responseBody); 
        r.finish();
    }
}

function orchestratingRequest(r) {
    r.log("Starting request ... ");

    print(r, "orchestratingRequest", r);  

    var opts = {  method: r.method,  body: r.requestBody };
    r.subrequest(r.variables.waflocation, opts, function(response){processWafResponse(r, response);});

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

export default {emptyResponse, orchestratingRequest, echoRequest}
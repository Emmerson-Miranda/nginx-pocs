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

    //s += "\n\n" + r.body;

    r.log(s);
    r.return(200, s);
}
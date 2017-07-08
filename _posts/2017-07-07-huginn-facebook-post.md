---
layout: post
title: Automation - Huginn - Facebook Page Post
---

![alt text](https://github.com/huginn/huginn/raw/master/public/android-chrome-144x144.png "Huginn")


This what I did to post to Facebook with the Post Agent,

https://developers.facebook.com/apps/

Click Add new app

```
Create a New App ID

Get started integrating Facebook into your app or website
Display Name: The name you want to associate with this App ID
Contact Email: user@domain.com

By proceeding, you agree to the Facebook Platform Policies     Cancel   Create App ID
```

Click Create App ID

Click Dashboard

Copy your API Version, App ID and App Secret

```
API Version: v2.8
App ID: 123456789012345
App Secret: ●●●●●●●● Show
```

Click Settings Basic

Add some terms of service...

```
Privacy Policy URL: https://www.google.com/policies/privacy/
Terms of Service URL: https://www.google.com/policies/terms/
```

Add a Category.

```
Category: Apps for pages
```

Click Settings Advanced, turn on allow API Access to App Settings.

```
Allow API Access to App Settings
Set to No to prevent changes to app settings through API calls
```

Find your Facebook Page ID

```
1. Go to your page
2. Click " Settings "
3. Click " Page Info "
4. you can see " Facebook Page ID "
```

Generate an Access Token.

you can do this from the terminal:

```
curl -X GET /oauth/access_token
    ?client_id={app-id}
    &client_secret={app-secret}
    &grant_type=client_credentials
```

or use the Graph API Explorer.

https://developers.facebook.com/tools/explorer/

```
Graph API Explorer

Application: Click the name of the application you made above.
Click Get Token dropdown and then choose the Page you want to post to.

Access Token: <AccessTokenString>
```

Copy the Access Token string.

You can also look at your tokens here:

https://developers.facebook.com/tools/accesstoken/

Make 3 credentials in Huginn for use among other things.

```
facebookapptoken: {AppToken}
facebookpageid: {PageID}
facebookaccesstoken: {AccessTokenString}
```

**Note:** *Be careful re-hitting the explorer generation page for tokens as it may de-validate your current token and you will be pulling out your hair wondering why your last token is not working.*

```
FaceBookGraphAPI Details
Type: Post Agent
Schedule: Never
Last checked: 4mo ago
Keep events: Forever
Last event created: never
Last received event: ~1mo ago
Events created: 0
Event sources: MeetUpAPI
Propagate immediately: No
Event receivers: None
Working: No
Options:
{
  "post_url": "https://graph.facebook.com/v2.8/{% credential facebookpageid %}/feed",
  "expected_receive_period_in_days": "1",
  "content_type": "json",
  "method": "post",
  "payload": {
    "message": "What: {{ Name }}{% line_break %}Where: {{ Location }}{% line_break %}When: {{ Time | divided_by: 1000 | date: '%c' }}{% line_break %}Description: {{ Description }}",
    "access_token": "{% credential facebookaccesstoken %}",
    "link": "{{ Link }}"
  },
  "headers": {
    "Accept": "application/json",
    "Content-Type": "application/json"
  },
  "emit_events": "false",
  "no_merge": "false"
}
```

**Note:** *Facebook says this is not secure because your AppID can now be seen by anyone that has access to the app, but if your the only one that has access deal with it however you see fit. They say you should use appID and appSecret*

# Welcome to the Smart Locks app

This was done initially as a coding challenge, for a fictive company selling smart locks. The smart locks have their own app with which you can open them. Every now and then the company servers send a csv file with the lock behaviors. This is what such csv file looks like:

    timestamp,lock_id,kind,status_change
    2017-05-01T00:32:50Z,9db3b7eb,sensor,online
    2017-05-01T00:40:20Z,6e711d12,gateway,online
    2017-05-01T00:43:50Z,3831469f,sensor,offline

## What the app does

The app is able to receive the csv generated report, coming from the company servers and stores this information in a PostgreSQL database.

Only the company servers are authorized to contact this endpoint with their codename.

We provide them with an access token they can use to access the app.

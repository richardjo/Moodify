# Moodify
## About

Welcome to Moodify, an iOS application that recommends songs to its users depending on their mood and listening patterns gathered using the Spotify API. 

Moodify uses a simple algorithm to generate playlists matching a user's mood: playlists are selected from a pool of a user's "top songs" gathered from a their artists data, songs data, and Spotify-generated recommendations. These top songs are filtered to create a single playlist that matches a user's "mood" which is calculated from user-provided "happiness" and "energy" values. For example, users that provide high "happiness" and "energy" values will receive quick-tempo songs that are easy to dance to. 

However, this algorithm has its limitations. Because the algorithm draws its suggestions from the user's listening history, it's limited by the songs the user has previously listened to. 

## Demo

![<iframe src="https://drive.google.com/file/d/16yqS3lWhhShneqrB63kP2i9ZSDKt66rF/preview" width="640" height="480"></iframe>](%3Ciframe%20src=%22https://drive.google.com/file/d/16yqS3lWhhShneqrB63kP2i9ZSDKt66rF/preview%22%20width=%22640%22%20height=%22480%22%3E%3C/iframe%3E)

## Installation

This project uses [CocoaPods](https://github.com/CocoaPods/CocoaPods) for dependency management.

[Alamofire](https://github.com/Alamofire/Alamofire) is used for network requests to the Spotify API. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) is used to parse JSON responses from the Spotify API.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjE0NTYzOTE1MCwtNjI2NTAxMDYyLC0xNz
cyMjEyNjc5LC0xMzQxOTI4NjY3LDEwNDc1MTk2ODRdfQ==
-->
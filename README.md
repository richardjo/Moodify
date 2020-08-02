# Moodify
## About

Welcome to Moodify, an iOS application that recommends songs to its users depending on their mood and listening patterns gathered using the Spotify API. 

Moodify uses a simple algorithm to generate playlists matching a user's mood: playlists are selected from a pool of "top songs" gathered from a user's artists data, songs data, and Spotify-generated recommendations. These top songs are filtered to create a single playlist that matches a user's "mood", calculated from user-provided "happiness" and "energy" values. For example, users that provide high "happiness" and "energy" values will receive quick-tempo songs that are easy to dance to. 

However, this algorithm has its limitations. Because the algorithm draws its suggestions from the user's listening history, it's limited by the songs the user has previously listened to. More importantly, if the user listens to songs (usually sad songs) that they normally do not listen to, they'll receive inaccurate rec o 

## Installation

This project uses [CocoaPods](https://github.com/CocoaPods/CocoaPods) for dependency management.

[Alamofire](https://github.com/Alamofire/Alamofire) is used for network requests to the Spotify API. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) is used to parse JSON responses from the Spotify API.
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTc5Mzk0MjQzLC0xMzQxOTI4NjY3LDEwND
c1MTk2ODRdfQ==
-->
# Moodify
## About

Welcome to Moodify, an iOS application that recommends songs to its users depending on their mood and listening patterns gathered using the Spotify API. 

Moodify uses a simple algorithm to generate playlists matching a user's mood: playlists are selected from a pool of "top songs" gathered from a user's artists data, songs data, and Spotify-generated recommendations. These top songs are filtered to create a single playlist that matches a user's "mood", calculated from user-provided "happiness" and "energy" values. For example, users that provide high "happiness" and "energy" values will receive quick-tempo songs that are easy to dance to. 

Although this algorithm is  the user selects moods that are outside of their normal listening 

## Installation

This project uses [CocoaPods](https://github.com/CocoaPods/CocoaPods) for dependency management.

[Alamofire](https://github.com/Alamofire/Alamofire) is used for network requests to the Spotify API. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) is used to parse JSON responses from the Spotify API.
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwODE2MTY1NDIsLTEzNDE5Mjg2NjcsMT
A0NzUxOTY4NF19
-->
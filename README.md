# JamChop

JamChop is a site that allows users to create custom mp3 albums from youtube videos. Users enter a youtube video URL in the search bar, recieve a list of track suggestions if they exist in the description, can edit track start times/orders/titles, and download a zipped up file containing the album.

## Getting Started

This is a fairly simple rails app that is very much a work in progress. it is not quite ready for multiple contributors, but should be within the next few days.

### dependencies:
* [youtube-dl](https://rg3.github.io/youtube-dl/download.html)
* [ffmpeg](https://www.ffmpeg.org/)
* [imagemagick](https://www.imagemagick.org/script/index.php)
* ruby 2.4.1


## TODO
* write tests and setup CI
* user input validation
* proper separation of environments
* worker heroku dynos using sidekiq
* clean up frontend



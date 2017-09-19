# JamChop

JamChop is a site that allows users to create custom mp3 albums from youtube videos. Users enter a youtube video URL in the search bar, recieve a list of track suggestions if they exist in the description, can edit track start times/orders/titles, and download a zipped up file containing the album.


##Contributing

To contribute to this project please fork the repository and create a pull request once you have made your changes. Pull request will automatically gnenerate heroku feature environments, which can be viewed at https://jam-chop-pr-[PR_NUMBER].herokuapp.com .

### Getting Started

This is a fairly simple rails app that is very much a work in progress. 

#### dependencies:

* [youtube-dl](https://rg3.github.io/youtube-dl/download.html)
* [ffmpeg](https://www.ffmpeg.org/)
* [imagemagick](https://www.imagemagick.org/script/index.php)
* ruby 2.4.1

#### setting up

Once the above dependencies have been installed, this is a straightforward rails application.
* `git clone https://github.com/your_username/jam_chop.git`
* `cd jam_chop`
* `bundle install`
* `rails db:migrate`
* `touch .env`
* obtain a youtube api key and put `YOUTUBE_API_KEY="your_obtained_youtube_api_key"`
* `rails s`
* now visit `localhost:3000` and you should be on your way.

#### data storage

In development environments all converted mp3 albums are stored on the local filesytem in `public/uploads`, and in staging and production they are uploaded to aws s3 buckets. Staging and production servers run `rails uploads:delete` every hour to clear up stale albums, but your local machine won't do that, so make sure to clear up that folder once in a while.

## TODO
* write tests and setup CI
* user input validation
* proper separation of environments
* worker heroku dynos using sidekiq
* clean up frontend
* email notifications
* get coverage reports
* exception handling

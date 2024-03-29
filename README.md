# README


** SetUp

- Make sure Ruby is installed. Ruby version 3.3.0 is recommended.
- Make sure you have a Ruby version manager, like e.g. rbenv. Alternatively, pick RVM.
- Make sure you have Bundler installed. If not, run $ gem install bundler.
- Run $ bundle install to install all dependencies, including Rails 7.1.3. Note: Rails runs in API mode, so there are no views.
- Run $ rails db:create db:migrate to create the database, run all migrations.
- To start Rails, run $ rails s.

** Testing APIs and API Documentation


- Run $ rake routes to see all GET, POST, PUT and DELETE HTTP-routes.
- Install Postman to start testing the APIs
- After successful import, make sure to set the url environment key to value: localhost:3000. You are ready to go!

** The Bowling Workflow


- To start a game, call this POST endpoint: http://localhost:3000/games'. It will create a game with id: 1, if database was empty before.
- we need to create the frames pins knockdown. We do this by calling this POST endpoint: http://localhost:3000/games/:game_id/frames/roll?frame_number=1&pins=10
- To check results, call this GET endpoint: http://localhost:3000/games/:id/score. This endpoint is used to display the entire scoreboard.
- At frame 10, the game ends. The API won't allow more than 10 frames.
- Each frame only two bowling is allow except the last frame if there is strike and spare case.

** API's
- http://localhost:3000/games
- http://localhost:3000/games/:game_id/frames/roll?frame_number=1&pins=10
- http://localhost:3000/games/:id/score

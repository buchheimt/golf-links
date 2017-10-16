# Golf Links

Golf Links is a Rails app for managing tee times. It allows users to interact with tee times (create, join, leave) and associated courses. Currently users interact with each other on a basic level (through tee times), but I plan to add more social features eventually. A JQuery front-end and JSON API will be the next major update, per Flatiron School's portfolio project requirements.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

This project started off using an SQLite database, but has since moved to PostgreSQL so it could be deployed to Heroku. You'll need to have PostgreSQL set up locally, but there are plenty of guides out there like [this one](http://www.techrepublic.com/blog/diy-it-guy/diy-a-postgresql-database-server-setup-anyone-can-handle/) if you're unfamiliar.

### Installing

Start off by forking and/or cloning this repo.

Next, make sure all gem dependencies are installed
```
bundle install
```
(Assuming PostgreSQL is properly set up)
Create the database
```
rake db:create
```
Run migrations
```
rake db:migrate
```
Fill database with test users
```
rake db:seed
```
Start up the Rails server
```
rails s
```

Now just navigate to localhost:3000 on your web browser and get started!


## Running the tests

There is a rspec test suite covering core features and model associations/validations, simply run `rspec` once set-up.

## Deployment

Golf Links is currently deployed to Heroku [here](https://golflinks.herokuapp.com).

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/buchheimt/3786e82ddc64f4d09d246a2a639ed143) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Everyone at [Flatiron School/Learn.co](https://flatironschool.com/) for creating a fantastic curriculum and awesome learning environment.
* [uinames.com](uinames.com) for great test user data!

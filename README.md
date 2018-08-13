# Portfolio API

This is the GraphQL API which acts as the back-end for JamesGallagher.io, my portfolio website. This API allows for the administation of all content featured on the website, including posts, portfolio projects, and comments.

This application uses:

- Ruby on Rails
- GraphQL
- Heroku (Deployment)
- PostgreSQL (Database)

## Getting Started

### Installing

*Please note, this API is complete and unmaintained.*

To start, clone the repository using git clone:

```
git clone https://github.com/jamesgallagher432/portfolio-api
```

You can use Docker for this application by using:

```
docker-compose up
```

This will do all of the heavy lifting for you in getting your app setup.

Once installed, to access the docer container internally, please run

```
docker exec -it portfolio_api_app_1 bash
```

In this example, the app container is named founder_community_app_1. Please substitute the name of the container if the command fails due to the container name being changes. You can locate the container's name by listing all docker containers with: `docker ps -a`.

**Use without Docker**

You can run this application manually by using:

Use the following to install dependencies:

```
bundle install
```

Next, build the database and install the required seeds:

```
rake db:setup
rake db:migrate
rake db:seed
```

Finally, you can execute the application by using:

```
rails s
```

This project makes use of the GraphiQL interface for easy query testing and is automatically disabled in production mode. To make queries to this API, you can either use the GraphiQL interface or the GraphQL endpoint, as seen below:

```
GraphiQL Instance - http://localhost:3000/graphiql
GraphQL Endpoint - http://localhost:3000/graphql
```

## Deployment

In order to deploy this application, you can run it locally using the aforementioned commands, or deploy through Heroku by using the following button:

[![Deploy](https://camo.githubusercontent.com/83b0e95b38892b49184e07ad572c94c8038323fb/68747470733a2f2f7777772e6865726f6b7563646e2e636f6d2f6465706c6f792f627574746f6e2e737667)](https://heroku.com/deploy?template=https://github.com/james-stewart2/project-management)

## Running the tests

This application practices TDD (Test-Driven Development) so there are tests for all create and search mutations.

This application has several unit tests which can be found in the `test/` directory. You can execute the unit tests by using:

```
rake test
```

## Database Structure

Below is the structure of the database used in this application.

[![Database Structure](https://github.com/jamesgallagher432/portfolio-api/raw/master/Database%20Structure.png)](https://github.com/jamesgallagher432/portfolio-api/raw/master/Database%20Structure.png)

## Authors

- **James Gallagher**

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/jamesgallagher432/project-management/blob/master/LICENSE.md) file for details

## Acknowledgments

Thanks to everyone of the amazing contributors to this project!

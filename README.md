# revelationmap
Implementing a REST API for stellar data being used in a Mongoose Traveller Deepnight Revelation campaign.

As a learning excercise, the REST server is being built in different languages/frameworks.

## Languages

### nodejs

Express is the web server and knex is used for database access.

I have experience with both, so not much new here. The service was up and running in a couple of hours.

nodejs felt comfortable as async web services sit well with my mental model. 

### Rust

Axium is used for the REST framework and SQLx for database access.

It has been a long time since I worked in a strongly typed language. I kept getting 'C' flashbacks. Which, probably, was bad
as Rust is not 'C'.

It took about 2 days to get the service up and running. That is not a reflection on Axios/SQLx; the bulk of the time was trying to figure
out how to do things in Rust. I discovered [Rustlings](https://github.com/rust-lang/rustlings) after I finished the Rust project. I plan on going through
them and then implementing the service again to see how much quicker it can be implemented.

Given the minimal exposure I have had with Rust, it feels like the problems it concerns itself with are not the problems
I concern myself with. I can see the appeal for certain domains. But, for web services, Express/Rails feels more natural.

### Ruby

Rails was used for, well, everything. 'cause, Rails. :)

I had never written anything in Ruby. After working through [Ruby Koans](https://www.rubykoans.com),
I started on implementing the server in Rails. It was up and running in about half a day.

Ruby feels like my kind-of language. I like the "everything is an object" approach to life. It will
be interesting to compare Ruby and Smalltalk.

## Performance

The /solarsystems?ulsx=-19&ulsy=-2 was used to time the server responses. This call returns ~280 solar systems.

| Language | Server Time |
| -------- | ----------- |
| nodejs   |  180ms      |
| Rust     |  120ms      |
| Ruby     |   80ms      |

The Rust response time when running in development mode is ~780ms. Compiling for production seems to be a good idea. :)
 

# README

Very little code was needed to get this server up and running. Rails does a good
job of supplying the boilerplates needed for a Rails project. The only tricky (ish)
part was figuring out how to create models for tables that already existed
in the database.

In the end, inheritance was used over a service module for the solarsystems and 
stars endpoints. The controllers for stars and solarsystems only need to override
a single method. It felt cleaner to use inheritance and supply the needed method.
 If the parameter
filters end up being used outside of these two views, the code can be refactored
to use a service module.

Kamal was left in place in case the app will be deployed via docker.

There is a possibility of a websocket usecase so Cable was left in place. 

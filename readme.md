# the wrds package

This package is designed to be an easy way to get set up with the WRDS back-end database without having to hard-code passwords into scripts or to know much about setting up ODBC connections. The Wharton Research Data Services website has a front end which allows you to pull data, and a server which you can use to schedule SAS scripts, but they also have a nice PostgreSQL back-end, which is fast and more complete than the front-end interfaces. 

There are a few reasons you might want to use this to pull data:

1. Scheduled queries that pull data on a regular basis
1. Data doesn't fit in memory, and you want the SQL do so some heavy lifting
1. You want to join across datasets which you can't attach on the front end
1. You don't like web interfaces and want to feel superior to people who point and click

# Requirements

Since WRDS has a PostgreSQL backend, you will need PostgreSQL drivers to access it. You can find and install them from here: https://odbc.postgresql.org/. Once those are installed, boot up a fresh R session, load the package and you should be up and running.

# Bugs, Questions, etc.

If you find bugs or have questions feel free to open an issue or pull request. You can also reach me by email at bcg@mit.edu.

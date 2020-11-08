# the wrds package

This package is designed to be an easy way to get set up with the WRDS back-end database without having to hard-code passwords into scripts or to know much about setting up ODBC connections. The Wharton Research Data Services website has a front end which allows you to pull data, and a server which you can use to schedule SAS scripts, but they also have a nice PostgreSQL back-end, which is fast and more complete than the front-end interfaces. 

There are a few reasons you might want to use this to pull data:

1. Scheduled queries that pull data on a regular basis
1. Data doesn't fit in memory, and you want the SQL do so some heavy lifting
1. You want to join across datasets which you can't attach on the front end
1. You don't like web interfaces and want to feel superior to people who point and click

To install the package, just run

`devtools::install_github("be-green/wrds")`

# Requirements

Since WRDS has a PostgreSQL backend, you will need PostgreSQL drivers to access it. You can find and install them from here: https://odbc.postgresql.org/. Once those are installed, boot up a fresh R session, load the package and you should be up and running.

# Features & Workflow

This is in the most basic possible form that it could take. I'm planning on adding more features as they become useful to me. If you are familiar with the DBI package, you can just connect to WRDS via `connect_to_wrds()` and then plug away! If you are more of a novice at SQL, I'm going to try to add some features that make it a teensy bit easier to use.

## Getting set up with your username and password

The package will work if you want to pass your username and password as text in a script, but that is generally considered bad form for security reasons. Slightly less bad is to store your username and password as environment variables on your local machine. That way you get to write scripts and access things, but the code just looks up your stuff in a local file on your computer instead of having you accidentally commit your password and pushing it to github for the world to see. That way someone else can also use your script, and it will use their credentials (this also avoids violating license agreements).

Suppose my wrds username was `uid`, and my password was `pass`. The workflow goes like this:

```
# Set up username and password (only need to do once)

set_wrds_user("uid")
set_wrds_pass("pass")

```

This sets up the `WRDS_USER` and `WRDS_PASS` variables in your `.Renviron` file in your home directory, and refreshes the environment variables in your session to use those. By default, you will try to connect to wrds using that username and password.

## Connecting to WRDS

Once we've done that, you just connect via `connect_to_wrds()`.
```
con <- connect_to_wrds()
```

If you already have worked with databases and the DBI package, this is just an ODBC connection so everything from the DBI and odbc packages will work. However there are a couple wrapper methods I wrote to make things a bit easier.

```
# list all database schemas available on back end of WRDS
list_schemas(con)

# list all schemas matching the phrase "crsp"
list_schemas(con, "crsp")
```

You can also list all the tables available, optionally limiting them to a specific schema. Here we list all of the thompson reuters worldscope tables.

```
list_tables(con, "tr_worldscope")
```

If you have a table of interest but just want to grab the top `n` rows to look at, there's a nice function called "peek" that is made just for you.

```
peek(con, "monthly_nav")
```

If you want to write your own sql query, you can pass it to 

```
query(con, "select * from monthly_nav limit 10")
```

Or you can write it in a separate file, save that, and pass the file name

```
query(con, "monthly_nav_top_10.sql")
```

# Bugs, Questions, etc.

If you find bugs or have questions feel free to open an issue or pull request. You can also reach me by email at bcg@mit.edu.

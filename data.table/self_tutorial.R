flights <- fread("flights14.csv")
flights
dim(flights)

# number of rows beyond which truncation
# occurs in data.table print
getOption("datatable.print.nrows")

# basic subsetting
ans <- flights[origin == "JFK" & month == 6L]

# basic ordering:
# first, in ascending order of `origin`
# second, in descending order of `dest`
ans <- flights[order(origin, -dest)]

# basic selection:
# NOTE: this is happening after the first bracket
ans <- flights[, arr_delay]
# in case you want this to return as a `data.table`
# instead of a vector:
ans <- flights[, list(arr_delay)]
# or
ans <- flights[, .(arr_delay, dep_delay)]
# data.frame way to do it would be:
# NOTE: the `with = FALSE` is necessary
ans <- flights[, c("arr_delay", "dep_delay"), with = FALSE]
# Setting with=FALSE disables the ability to refer to columns 
# as if they are variables, thereby restoring the "data.frame mode"
# However, with is set to TRUE in data.table
# because the property of considering columns as variables
# is useful and capitalised on in data.table

# this is useful because, we can do this:
ans <- flights[, -c("arr_delay", "dep_delay"), with = FALSE]
# and this:
ans <- flights[, year:day, with = FALSE]

# you can also do aliasing
ans <- flights[, .(delay_arr = arr_delay, 
                   delay_dep =  dep_delay)]

# basic computation:
# NOTE: this is happening after the first bracket
ans <- flights[, sum((arr_delay + dep_delay) < 0)]

# subsetting (i) and computing (j) at the same time
ans <- flights[origin == "JFK" & month == 6L,
               .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]
# NOTE: the . in front is ESSENTIAL,
# otherwise, there can't be 2 outputs from the j section
# PROCESS:
#   step 1 - subsetting `JFK` and `June`
#   step 2 - selecting `arr_delay` and `dep_delay`
#   step 3 - computing mean of `arr_delay` and `dep_delay`
# BENEFIT: the gradual truncation enforces optimisation
#   both in terms of time and memory

ans <- flights[origin == "JFK" & month == 6L, length(dest)]
# the `length` function needs to have a variable inside it...
# `dest` was just lucky
# this is the same as `dim(flights[origin == "JFK" & month == 6L])[1]`

# but better approach is demonstrated below
ans <- flights[origin == "JFK" & month == 6L, .N]
# the count is returns as vector
# ` .(.N) ` could also be used to return another data.table

####################
# the 3rd argument #
####################

# .N is a special variable 
# that holds the number of rows in the current group. 
# Grouping by origin obtains 
# the number of rows, .N, for each group.
ans <- flights[, .(.N), by = (origin)]
# NOTE: `by` will preserve the original order of the data
# aftter the grouping, i.e. whatever comes first, is kept first

# the same thing alongside subsetting
ans <- flights[carrier == "AA", .N, by = origin]

# the same thing with subsetting as well as
# combination with another variable.
# There're more groups here due to the pairing of the two variables
ans <- flights[carrier == "AA", .N, by = .(origin, dest)]

# enough of counting... let's move on to better stuff
# here's how we can do average of 2 different variables
# by grouping them on the basis of another set of 3 variables
ans <- flights[carrier == "AA",
               .(mean(arr_delay), mean(dep_delay)),
               by = .(origin, dest, month)]
# once again, the ordering in the result is based on the 
# original order...
# if we wish to change that order based on the grouping:
ans <- flights[carrier == "AA",
               .(mean(arr_delay), mean(dep_delay)),
               keyby = .(origin, dest, month)]

# IF, however, we need to change the order
# in ascending order of one/more variable(s) and
# descending order of (an)other variable(s), 
# we would have to do something extra
ans <- flights[carrier == "AA",
               .N,
               by = .(origin, dest)][
                 order(origin, -dest)
                 ]
# chaining comes into play, when things can't be done in one go.
# it's better than having an intermediate result
# since that would be taxing in terms of space...
# given on top is an example of vertical chaining

# grouping section can take in conditions as well,
# as a factor of what the grouping should be based on:
ans <- flights[, .N, .(dep_delay > 0, arr_delay > 0)]


# yet another useful technique is using `.SD`
DT = data.table(ID = c("b","b","b","a","a","c"), 
                a = 1:6, b = 7:12, c=13:18)

DT[, lapply( # for every column of...
  .SD, # each group created based on ID...
  mean # compute the mean
  ), by = ID
  ]

# back to `flights`
flights[carrier == "AA",
        lapply(.SD, mean),
        by = .(origin, dest, month),
        .SDcols = c("arr_delay", "dep_delay")] # also specifying...
# which columns in `lapply` will be computed upon

# .SD pretty useful stuff to do other operations on as well
ans <- flights[, head(.SD, 2)[, .(dep_time, dep_delay)], by = month]

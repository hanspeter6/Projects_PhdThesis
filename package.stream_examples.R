
# load package
library(stream)

# create simulated datastream: three guassians in 2D space
set.seed(1000)
stream <- DSD_Gaussians(k = 3, d = 2)

# create instance of density-based data stream clustering algorithm D-Stream
# using grid cels as micro clusters. Grid cell size specified as 0.1
# and density of grid cell (Cm) needs to be at least 1.2 times average cell
# density to become a micro cluster. Then update the model with the next 500
# data points from the stream

dstream <- DSC_DStream(gridsize = 0.1, Cm = 1.2)
update(dstream, stream, n = 500)

# perform reclustering using k-means with 3 clusters and plot the micro and macro clusters
km <- DSC_Kmeans(k = 3)
recluster(km,dstream)
plot(km, stream, type = "both")

# 4.2. Example: Creating a data stream
set.seed(1000)
stream <- DSD_Gaussians(k = 3, d = 3, noise = .05, p = c(.5, .3, .1))
stream

p <- get_points(stream, n = 5)
p

#Note that the data was created by a generator with 5% noise. Noise points do not belong to
# any cluster and thus have a class label of NA.
p <- get_points(stream, n = 100, class = TRUE)
head(p, n = 10)

# Next, we plot 500 points from the data stream to get an idea about its structure.
plot(stream, n = 500)

#The data can also be projected on its first two principal components using method="pc".
plot(stream, n = 500, method = "pc")

# To show concept drift, we request four times 250 data points from the stream
# and plot them.
# To fast-forward in the stream we request 1400 points in between the plots
# and ignore them.

for(i in 1:4) {
  plot(stream, 250, xlim = c(0, 1), ylim = c(0, 1))
  tmp <- get_points(stream, n = 1400)
}


reset_stream(stream)
animate_data(stream, n = 10000, horizon = 100, xlim = c(0, 1), ylim = c(0, 1))

library(animation)
animation::ani.options(interval = .1)
ani.replay()

# Animations can also be saved as an animation embedded in a HTML document or an animated
# image in the Graphics Interchange Format (GIF) which can easily be used in presentations.
saveHTML(ani.replay(), img.name = "animate")
#saveGIF(ani.replay())
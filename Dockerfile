# Use nginx base image
FROM node:18-alpine

# install serve package
RUN npm install -g server

# set working directory
WORKDIR /app

# copy build folder
COPY build ./build

# expose port
EXPOSE 3000

# run react app
CMD ["server", "-s", "build", "-l", "3000"]

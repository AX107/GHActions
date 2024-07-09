#Download Node Alpine image
FROM node:alpine As build
 
#Setup the working directory
WORKDIR /usr/src/app
 
#Copy package.json
COPY package.json package-lock.json ./
 
#Install dependencies
RUN npm install
 
#Copy other files and folder to working directory
COPY . .
 
#Build Angular application in PROD mode
RUN npm run build --prod
 
#Download NGINX Image
FROM nginx:alpine
 
#Copy built angular app files to NGINX HTML folder
COPY --from=build /usr/src/app/dist/gh_action/ /usr/share/nginx/html

EXPOSE 80

# Add a health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
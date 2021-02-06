FROM node:latest
WORKDIR /usr/src/app

# Install dependencies
COPY package.json ./
RUN npm install

# Copy in source code
COPY src ./

# Compile typescript into outDir, `dist`
COPY tsconfig.json ./
RUN npm run build

# Run server
RUN npm install pm2 -g
EXPOSE 4000
CMD ["pm2-runtime","dist/app.js"]
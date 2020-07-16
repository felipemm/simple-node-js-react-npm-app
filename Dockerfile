# Stage - the production environment
FROM nginx:1.17.10-alpine
COPY /build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
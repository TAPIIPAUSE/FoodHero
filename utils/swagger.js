import swaggerAutogen from "swagger-autogen";

const docs = {
  swagger: "2.0",
  info: {
    title: "Foodhero API",
    version: "1.0.0",
    description: "API documentation for Foodhero",
  },
  host: "localhost:3000",
  basePath: "/",
  schemes: ["http"],
  tags: [
    {
      name: "Inventory",
      description: "Endpoints related to inventory management",
    },
    {
      name: "User",
      description: "Endpoints related to user management",
    },
  ],
  apis: ["../schema/*.js"],
};

const output = "./swagger-output.json";
const routes = ["../main.js","../routes/*.js"];

swaggerAutogen(output, routes,  docs);
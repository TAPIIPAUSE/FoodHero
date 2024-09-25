# Welcome to FoodHero BackEnd Service

## Description
This readme file will guide the developer through the steps of generating the data within FoodHero Application. 

### We will be looking through 

#### 1)Installation

#### 2)Run the code

#### 3)JSON Input Format for Generating the data

## Installation
To install the project dependencies and Nodemon, follow these steps:

1. Install Node.js (If installed already, doesn't require) 

https://nodejs.org/en

2. Install the project dependencies:
   
```bash
npm install -g nodemon
npm install
```

3. Create .env file
In .env file, paste this credentials
```
#TOKEN_SECRET=09f26e402586e2faa8da4c98a35f1b20d6b033c6097befa8be3486a829587fe2f90a832bd3ff9d42710a4da095a2ce285b009f0c3730cd9b8e1af3eb84df6611

TOKEN_SECRET = james
```

## Set up Database
Create your local Database & Try to connet to the code in main.js at URI variable


## To Run Backend Service
You can check this command in package.json
```bash
npm start 
```

## API Service Guide

#### Base URL
```
http://localhost:3000
```

### User Module

#### 1. Register: POST
URL:
```
http://localhost:3000/api/v1/users/register
```

JSON Body:
```
{
    "username": {string},
    "email": {string},
    "password": {string}
}
```

#### 2. Login: POST
URL:
```
http://localhost:3000/api/v1/users/login
```

JSON Body:
```
{
    "username": {string},
    "password": {string}
}
```

#### 3. Create House: POST
URL:
```
http://localhost:3000/api/v1/users/create_house
```

JSON Body:
```
{
    "house_name": {string},
}
```

This function will create the house based on that user's input house name,
It will automatically assign the house ID to that user and update every related field in database.
It also generate the hID based on the current pointer in House model.

#### 4. Create Organization: POST
URL:
```
http://localhost:3000/api/v1/users/create_org
```

JSON Body:
```
{
    "org_name": {string},
}
```

This function will create the organization based on that user's input organization name,
It will automatically assign the organization ID to that user and update every related field in database.
It also generate the hID based on the current pointer in House model.

Screw You








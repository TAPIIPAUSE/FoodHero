// import express from 'express';
import bcrypt from 'bcryptjs';
import express from "express";
import UnitType from '../schema/unitTypeSchema.js';
import jwt from 'jsonwebtoken';
import passport from "passport";
import LocalStrategy from 'passport-local'

const router = express.Router();

router.post('/addUnit',async(req,res) => {

    const {type} = req.body;

    const existingUnitType = await UnitType.findOne({ type });
    if (existingUnitType) {
      return res.status(400).send('Unit Type already exists');
    }

    const newUnitType = new UnitType({
        type
    })

    console.log("This will be your new unit:", type)

    await newUnitType.save();

    res.status(200).send("New Unit Type Registered");
})

export default router;
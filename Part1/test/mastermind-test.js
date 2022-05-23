//[assignment] write your own unit test to show that your Mastermind variation circuit is working as expected
const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

describe("System of mastermind test", function () {
    this.timeout(100000000);

    it("true number", async () => {
        const circuit = await wasm_tester("contracts/circuits/MastermindVariation.circom");
        await circuit.loadConstraints();
        
        const INPUT = {
            "pubGuessA": "2",
            "pubGuessB": "1",
            "pubGuessC": "3",
            "pubGuessD": "4",
            "pubNumHit": "4",
            "pubNumBlow": "0",
            "pubSolnHash": "17547883788763757664630189280140341185562035118470501384694873005203045477323",
            "guessTimes": "1",

            "privSolnA": "2",
            "privSolnB": "1",
            "privSolnC": "3",
            "privSolnD": "4",
            "privSalt":  "333",
        }
        //console.log("aw");

        const witness = await circuit.calculateWitness(INPUT, true);


        assert(Fr.eq(Fr.e(witness[0]),Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]),Fr.e(17547883788763757664630189280140341185562035118470501384694873005203045477323n)));
    });
});
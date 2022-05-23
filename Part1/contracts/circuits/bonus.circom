// [bonus] implement an example game from part d

//
pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template GuessGame() {

    // The picture number is from 1 to 5
    signal input playerA;
    signal input playerB;
    signal input playerC;
    signal input playerD;
    signal input playerE;

    // Public inputs
    signal input inputWinnerSum;
    signal input gameHash;

    // Private inputs
    signal input privateWords;
    signal input truePhotoNum;
    

    // Output
    signal output gameOutHash;


    var players[5] = [playerA, playerB, playerC, playerD, playerE];
    var j = 0;
    component lessThan[10];
    component equalGuess[5];
    var winnerSum = 0;

    // Create a constraint that the players choose from 1 to 5.
    for (j=0; j<5; j++) {
        lessThan[j] = LessThan(4);
        lessThan[j].in[0] <== players[j];
        lessThan[j].in[1] <== 6;
        lessThan[j].out === 1;
        lessThan[j+5] = LessThan(4);
        lessThan[j+5].in[0] <== 0;
        lessThan[j+5].in[1] <== players[j];
        lessThan[j+5].out === 1;
    }

    // Cheack the true number from 1 to 5
    component photoInPhotos = LessThan(4);
    photoInPhotos.in[0] <== truePhotoNum;
    photoInPhotos.in[1] <== 6;
    photoInPhotos.out === 1;
  
    // Cheack if the players get the true picture
    for (j=0; j<5; j++) {
        equalGuess[j] = IsEqual();
        equalGuess[j].in[0] <== players[j];
        equalGuess[j].in[1] <== truePhotoNum;
        winnerSum += equalGuess[j].out;
    }
    
    // Create a constraint around the number of hit
    component equalSum = IsEqual();
    equalSum.in[0] <== winnerSum;
    equalSum.in[1] <== inputWinnerSum;
    equalSum.out === 1;

    // Verify that the hash of the private solution matches pubSolnHash
    component poseidon = Poseidon(2);
    poseidon.inputs[0] <== privateWords;
    poseidon.inputs[1] <== truePhotoNum;


    gameOutHash <== poseidon.out;
    gameHash === gameOutHash;
 }

 component main {public [inputWinnerSum, gameHash]} = GuessGame();
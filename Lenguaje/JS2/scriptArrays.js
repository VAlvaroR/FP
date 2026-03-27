let cantNum = parseInt(prompt("Introduce cantidad de números"));
let contador = 0;
let arr = [];

do {
    arr.push(parseInt(prompt("Introduce un numero")));
    contador++;
} while (contador < cantNum)

console.log("Array Creado! " + arr);

function findLargestNumber(array) {
    let numGrande = array[0];
    for (let i = 0; i < array.length; i++) {
        if (numGrande < array[i]) {
            numGrande = array[i];
        }
    }
    return numGrande;
}

console.log(findLargestNumber(arr));
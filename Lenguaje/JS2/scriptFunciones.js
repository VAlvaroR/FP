// Ejercicio 3.1
AR = {};

AR.area = function (radio) {
    return Math.PI * (radio ** 2);
}

AR.perimetro = function (radio) {
    return 2 * Math.PI * radio;
}

console.log("El área del circulo es: " + Math.round(AR.area(3) * 100) / 100);

console.log("El perimetro del circulo es: " + Math.round(AR.perimetro(3) * 100) / 100);

// Ejercicio 3.2
AR.calculatePower = function (base, exponent) {
    return base ** exponent;
}

console.log(AR.calculatePower(2, 3));
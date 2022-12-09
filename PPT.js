var eleccionDeUsuario = prompt("Escoge \n piedra \n papel \n tijeras");

var elecciondeComputadora = Math.random();
if (elecciondeComputadora < 0.35) {
    elecciondeComputadora = "piedra";
} else if(elecciondeComputadora <= 0.50) {
    elecciondeComputadora = "papel";
} else {
    elecciondeComputadora = "tijeras";
}

var compare = function() {
    if(eleccionDeUsuario === elecciondeComputadora) {
    return "Es un empate";
}
if(eleccionDeUsuario === "piedra") {
    if(elecciondeComputadora === "tijeras") {
        return "piedra gana";
    } else {
        return "papel gana";
    }
}
if(eleccionDeUsuario === "papel") {
    if(elecciondeComputadora === "piedra") {
        return "papel gana";
    } else {
        if(elecciondeComputadora === "tijeras") {
            return "tijeras gana";
    }
}
}
if(eleccionDeUsuario === "tijeras") {
    if(elecciondeComputadora === "piedra") {
        return "piedra gana";
    } else {
        if(elecciondeComputadora === "papel") {
            return "tijeras gana";
        }
    }
  }
};
console.log("Eleccion de usuario: " + eleccionDeUsuario);
console.log("Eleccion de computadora: " + elecciondeComputadora);
compare(eleccionDeUsuario, elecciondeComputadora);
let element = document.getElementsByTagName('h1');
console.log(element[0].textContent);
element[0].textContent = "Estoy agregando un nuevo texto";

let element2 = document.getElementsByTagName('p');
console.log(element2[0].textContent);
element2[0].textContent += "<span>Estoy agregando un nuevo texto</span>";

let element3 = document.getElementsByTagName('ul');
console.log(element3[1].innerHTML);

element[0].style.backgroundColor = "yellow";

let elements = document.getElementsByTagName('h2');
for (let i = 0; i < elements.length; i++) {
    elements[i].classList.add('.subtitulos');
}

let elements2 = document.getElementsByClassName('estilo-letras');
for (let i = 0; i < elements2.length; i++) {
    elements2[i].classList.remove('estilo-letras');
}

AR = {};

AR.tirarDados = function () {
    let res = document.getElementById('res');
    res.innerHTML = Math.floor(Math.random() * 6);
};
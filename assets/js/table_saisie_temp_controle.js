window.addEventListener('scroll', function () {
    var tableContainer = document.querySelector('.table-container');
    if (window.scrollY > 0) {
        tableContainer.style.top = window.scrollY + 'px';
    } else {
        tableContainer.style.top = 0;
    }
});


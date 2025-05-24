const section = document.querySelectorAll('section');
const navLinks = document.querySelectorAll('.nav-link');
const toggleBtn = document.getElementById('menu-toggle');
const navLinksContainer = document.getElementById('nav-links'); 

toggleBtn.addEventListener('click', () => {
    navLinksContainer.classList.toggle('active');
});
  
// Hide dropdown when a nav link is clicked (for mobile)
navLinks.forEach(link => {
    link.addEventListener('click', () => {
        navLinksContainer.classList.remove('active');
    });
});

window.addEventListener('scroll', () => {
    let current = '';

    section.forEach(section => {
        const sectionTop = section.offsetTop - 60;
        const sectionHeight = section.clientHeight;
        if (pageYOffset >= sectionTop && pageYOffset < sectionTop + sectionHeight) {
            current = section.getAttribute('id');
        }
    });
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});
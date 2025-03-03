document.addEventListener("DOMContentLoaded", function () {
    const navbar = document.querySelector(".navbar");
    const menuIcon = document.querySelector(".menu-icon");
    const navLinks = document.querySelector(".nav-links");

    window.addEventListener("scroll", function () {
        if (window.scrollY > 50) {
            navbar.style.backgroundColor = "rgba(0, 0, 0, 0.9)";
        } else {
            navbar.style.backgroundColor = "rgba(0, 0, 0, 0.8)";
        }
    });

    document.querySelectorAll('.nav-links a').forEach(anchor => {
        anchor.addEventListener('click', function (event) {
            event.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            target.scrollIntoView({ behavior: 'smooth' });
        });
    });

    menuIcon.addEventListener("click", function () {
        navLinks.classList.toggle("active");
    });

    // Gallery Carousel Functionality
    const carouselImages = document.querySelectorAll(".carousel img");
    const prevBtn = document.querySelector(".carousel .prev");
    const nextBtn = document.querySelector(".carousel .next");
    const dots = document.querySelectorAll(".carousel .dots span");

    let currentIndex = 0;
    let interval;

    function showImage(index) {
        // Ensure index wraps around correctly
        if (index >= carouselImages.length) {
            currentIndex = 0;
        } else if (index < 0) {
            currentIndex = carouselImages.length - 1;
        } else {
            currentIndex = index;
        }

        // Remove active class from all images
        carouselImages.forEach((img, i) => {
            img.classList.toggle("active", i === currentIndex);
            dots[i].classList.toggle("active", i === currentIndex);
        });
    }

    function nextImage() {
        showImage(currentIndex + 1);
    }

    function prevImage() {
        showImage(currentIndex - 1);
    }

    // Event Listeners for Navigation Buttons
    prevBtn.addEventListener("click", function () {
        prevImage();
        restartAutoSlide();
    });

    nextBtn.addEventListener("click", function () {
        nextImage();
        restartAutoSlide();
    });

    dots.forEach((dot, index) => {
        dot.addEventListener("click", function () {
            showImage(index);
            restartAutoSlide();
        });
    });

    // Auto-slide function
    function startAutoSlide() {
        interval = setInterval(nextImage, 5000); // Change every 5 seconds
    }

    function restartAutoSlide() {
        clearInterval(interval);
        startAutoSlide();
    }

    // Start the auto-slide when page loads
    startAutoSlide();
});

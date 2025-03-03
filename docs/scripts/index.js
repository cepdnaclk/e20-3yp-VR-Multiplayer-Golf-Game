document.addEventListener("DOMContentLoaded", function () {
  const navbar = document.querySelector(".navbar");
  const menuIcon = document.querySelector(".menu-icon");
  const navLinks = document.querySelector(".nav-links");

  window.addEventListener("scroll", function () {
    navbar.style.backgroundColor = window.scrollY > 50 ? "rgba(0, 0, 0, 0.9)" : "rgba(0, 0, 0, 0.8)";
  });

  document.querySelectorAll(".nav-links a").forEach((anchor) => {
    anchor.addEventListener("click", function (event) {
      event.preventDefault();
      const target = document.querySelector(this.getAttribute("href"));
      target.scrollIntoView({ behavior: "smooth" });
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
    currentIndex = (index + carouselImages.length) % carouselImages.length;
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

  function startAutoSlide() {
    interval = setInterval(nextImage, 5000);
  }

  function restartAutoSlide() {
    clearInterval(interval);
    startAutoSlide();
  }

  startAutoSlide();

  // Slideshow Functionality for Data Flow Stack
  let slideIndex = 1;
  showSlides(slideIndex);

  function plusSlides(n) {
    showSlides((slideIndex += n));
  }

  function showSlides(n) {
    const slides = document.getElementsByClassName("mySlides");
    slideIndex = (n + slides.length - 1) % slides.length + 1;
    Array.from(slides).forEach((slide, i) => {
      slide.style.display = i === slideIndex - 1 ? "block" : "none";
    });
  }

  document.querySelector(".slideshow-container .prev").addEventListener("click", function () {
    plusSlides(-1);
  });

  document.querySelector(".slideshow-container .next").addEventListener("click", function () {
    plusSlides(1);
  });
});

// Navbar scroll effect
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 60);
}, { passive: true });

// Mobile menu
const hamburger = document.getElementById('hamburger');
const mobileMenu = document.getElementById('mobile-menu');
hamburger.addEventListener('click', () => mobileMenu.classList.toggle('open'));
mobileMenu.querySelectorAll('a').forEach(l => l.addEventListener('click', () => mobileMenu.classList.remove('open')));

// Scroll reveal
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

// Form Web3Forms
const contattiForm = document.getElementById('contatti-form');
if (contattiForm) {
  contattiForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const btn = document.getElementById('form-submit-btn');
    const feedback = document.getElementById('form-feedback');
    btn.disabled = true;
    btn.textContent = 'Invio in corso…';
    feedback.textContent = '';
    feedback.className = 'form-feedback';
    try {
      const data = new FormData(contattiForm);
      const res = await fetch('https://api.web3forms.com/submit', {
        method: 'POST',
        body: data
      });
      const json = await res.json();
      if (json.success) {
        feedback.textContent = 'Messaggio inviato! Ti risponderò al più presto.';
        feedback.classList.add('form-feedback--success');
        contattiForm.reset();
      } else {
        throw new Error(json.message || 'Errore invio');
      }
    } catch {
      feedback.textContent = 'Qualcosa è andato storto. Prova a chiamarmi direttamente.';
      feedback.classList.add('form-feedback--error');
    } finally {
      btn.disabled = false;
      btn.textContent = 'Invia messaggio';
    }
  });
}

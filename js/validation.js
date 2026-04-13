document.addEventListener('DOMContentLoaded', function () {

    // ===== MENÚ HAMBURGUESA =====
    const hamburger = document.getElementById('hamburger');
    const nav = document.getElementById('siteNav');
    const headerControls = document.querySelector('.header-controls');

    if (hamburger && nav) {
        hamburger.addEventListener('click', function () {
            nav.classList.toggle('open');
            if (headerControls) headerControls.classList.toggle('open');
        });
    }

    // ===== VALIDACIÓN LOGIN =====
    const formLogin = document.getElementById('formLogin');
    if (formLogin) {
        formLogin.addEventListener('submit', function (e) {
            const username = document.getElementById('loginUsername');
            const password = document.getElementById('loginPassword');
            let valid = true;

            // Limpiar errores previos
            clearError(username);
            clearError(password);

            if (!username.value.trim()) {
                showError(username, 'El usuario es obligatorio.');
                valid = false;
            }

            if (!password.value.trim()) {
                showError(password, 'La contraseña es obligatoria.');
                valid = false;
            }

            if (!valid) {
                e.preventDefault();
            }
        });
    }

    // ===== AUTO-SUBMIT SELECTOR DE TEMPORADA =====
    const selectTemporada = document.getElementById('selectTemporada');
    if (selectTemporada) {
        selectTemporada.addEventListener('change', function () {
            const form = document.getElementById('formTemporada');
            if (form) form.submit();
        });
    }

    // ===== FALLBACK IMÁGENES =====
    document.querySelectorAll('img.foto-jugador, img.escudo-img, img.escudo-mini, img.escudo-grande, img.foto-grande').forEach(function (img) {
        img.addEventListener('error', function () {
            if (img.classList.contains('foto-jugador') || img.classList.contains('foto-grande')) {
                img.src = 'imagenes/imagenes_Jugadores/jugador-default.png';
            } else {
                img.src = 'imagenes/imagenes_Logos/logoFederacion.webp';
            }
        });
    });

    // ===== HELPERS =====
    function showError(input, msg) {
        input.style.borderColor = '#e74c3c';
        const existing = input.nextElementSibling;
        if (!existing || !existing.classList.contains('field-error')) {
            const span = document.createElement('span');
            span.className = 'field-error';
            span.style.cssText = 'color:#e74c3c;font-size:0.75rem;display:block;margin-top:2px;';
            span.textContent = msg;
            input.insertAdjacentElement('afterend', span);
        }
    }

    function clearError(input) {
        input.style.borderColor = '';
        const next = input.nextElementSibling;
        if (next && next.classList.contains('field-error')) {
            next.remove();
        }
    }
});

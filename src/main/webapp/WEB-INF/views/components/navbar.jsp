<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Menangkap parameter authMode yang dikirim dari login.jsp (isSignup ? "/register" : "/login")
    // Jika null (misalnya diakses langsung), default ke "/login"
    String authMode = request.getParameter("authMode");
    if (authMode == null) {
        authMode = "/login";
    }
%>

<nav class="navbar-pill">
    <div class="nav-logo">
        <a href="${pageContext.request.contextPath}<%= authMode %>">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Glamora" style="height: 35px;">
        </a>
    </div>
    
    <div class="nav-links">
        <div id="marker"></div>
        <%-- Link sekarang dinamis mengikuti mode authMode (Login atau Register) --%>
        <a href="${pageContext.request.contextPath}/about_us<%= authMode %>" class="nav-item">About Us</a>
        <a href="${pageContext.request.contextPath}/services<%= authMode %>" class="nav-item">Services</a>
        <a href="${pageContext.request.contextPath}/store<%= authMode %>" class="nav-item">Store</a>
        <a href="${pageContext.request.contextPath}/help<%= authMode %>" class="nav-item">Help</a>
    </div>
</nav>

<script>
    const marker = document.querySelector('#marker');
    const items = document.querySelectorAll('.nav-links a');
    const currentPath = window.location.pathname;

    function indicator(e) {
        marker.style.left = e.offsetLeft + "px";
        marker.style.width = e.offsetWidth + "px";
        marker.style.opacity = "1"; 
    }

    items.forEach(link => {
        // Logika Deteksi Halaman Aktif yang lebih fleksibel
        // Menggunakan URL browser untuk mencocokkan menu (About Us, Services, dll)
        if (currentPath.includes("/about_us") && link.getAttribute('href').includes("/about_us")) {
            link.classList.add('active');
        } else if (currentPath.includes("/services") && link.getAttribute('href').includes("/services")) {
            link.classList.add('active');
        } else if (currentPath.includes("/store") && link.getAttribute('href').includes("/store")) {
            link.classList.add('active');
        } else if (currentPath.includes("/help") && link.getAttribute('href').includes("/help")) {
            link.classList.add('active');
        }

        link.addEventListener('mouseenter', (e) => {
            indicator(e.target);
        });
        
        link.addEventListener('click', (e) => {
            items.forEach(item => item.classList.remove('active'));
            e.target.classList.add('active');
            indicator(e.target);
        });
    });

    window.addEventListener('load', () => {
        const activeLink = document.querySelector('.nav-links a.active');
        if (activeLink) {
            indicator(activeLink);
        } else if (items.length > 0) {
            // Default marker jika berada di root /login atau /register tanpa folder menu
            indicator(items[0]); 
        }
    });
    
    document.querySelector('.nav-links').addEventListener('mouseleave', () => {
        const activeLink = document.querySelector('.nav-links a.active');
        if (activeLink) indicator(activeLink);
    });
</script>
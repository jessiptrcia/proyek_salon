<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="navbar-pill">
    <div class="nav-logo">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Glamora">
    </div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/booking" class="active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/booking/form">Booking</a>
        <a href="${pageContext.request.contextPath}/booking/history">History</a>
        <a href="${pageContext.request.contextPath}/logout" style="color: #d8000c;">Logout</a>
    </div>
</nav>
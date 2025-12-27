document.addEventListener("DOMContentLoaded", function () {
    const marker = document.querySelector('#marker');
    const items = document.querySelectorAll('.nav-links a');

    function moveMarker(element) {
        // Mengatur posisi dan lebar marker sesuai elemen yang diklik/aktif
        marker.style.left = element.offsetLeft + "px";
        marker.style.width = element.offsetWidth + "px";
        marker.style.opacity = "1"; // Tampilkan marker setelah posisi dihitung
    }

    items.forEach((item) => {
        // Logika saat menu diklik
        item.addEventListener('click', (e) => {
            // Hapus class active dari semua menu
            items.forEach(link => link.classList.remove('active'));
            // Tambahkan class active ke menu yang diklik
            item.classList.add('active');
            
            moveMarker(item);
        });

        // Inisialisasi posisi awal marker berdasarkan menu yang punya class 'active'
        if (item.classList.contains('active')) {
            moveMarker(item);
        }
    });

    // Opsional: Jika tidak ada class active manual, inisialisasi di menu pertama
    if (!document.querySelector('.nav-links a.active') && items.length > 0) {
        moveMarker(items[0]);
    }
});
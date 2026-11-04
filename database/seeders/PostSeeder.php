<?php

namespace Database\Seeders;

use App\Enums\PostStatus;
use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Seeder;

class PostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $admin = User::first();
        $beritaCat = Category::where('slug', 'berita-kebijakan')->first();
        $layananCat = Category::where('slug', 'layanan-publik')->first();
        $pengumumanCat = Category::where('slug', 'pengumuman')->first();

        $posts = [
            [
                'title' => 'Peluncuran Aplikasi Layanan Digital Terpadu untuk Masyarakat',
                'slug' => 'peluncuran-aplikasi-layanan-digital-terpadu-untuk-masyarakat',
                'summary' => 'Instansi resmi meluncurkan portal informasi dan sistem tanya-jawab masyarakat secara digital untuk mempercepat pelayanan publik.',
                'content' => '<p>Dalam rangka mewujudkan tata kelola pemerintahan yang transparan dan akuntabel, instansi resmi meluncurkan portal layanan digital dan mobile terpadu.</p><p>Sistem ini dirancang untuk memudahkan masyarakat dalam mencari informasi publik, menyimak agenda kegiatan, serta menyampaikan pertanyaan atau aspirasi secara langsung.</p>',
                'status' => PostStatus::Published,
                'published_at' => now()->subDays(2),
                'is_featured' => true,
                'view_count' => 125,
                'category_id' => $beritaCat?->id,
                'user_id' => $admin?->id,
            ],
            [
                'title' => 'Panduan Pengajuan Permohonan Informasi Publik Tahun 2026',
                'slug' => 'panduan-pengajuan-permohonan-informasi-publik-tahun-2026',
                'summary' => 'Simak alur dan persyaratan permohonan informasi publik melalui kanal digital dan tatap muka secara transparan.',
                'content' => '<p>Masyarakat berhak memperoleh informasi publik sesuai ketentuan perundang-undangan yang berlaku. Berikut langkah-langkah yang dapat diikuti:</p><ul><li>Mengisi formulir pertanyaan online atau offline</li><li>Menyertakan identitas diri yang valid</li><li>Menunggu proses verifikasi maksimal 3 hari kerja</li></ul>',
                'status' => PostStatus::Published,
                'published_at' => now()->subDay(),
                'is_featured' => true,
                'view_count' => 84,
                'category_id' => $layananCat?->id,
                'user_id' => $admin?->id,
            ],
            [
                'title' => 'Jadwal Pemeliharaan Sistem Server dan Portal Layanan Publik',
                'slug' => 'jadwal-pemeliharaan-sistem-server-dan-portal-layanan-publik',
                'summary' => 'Pemberitahuan pemeliharaan rutin server dan infrastruktur jaringan pada akhir pekan ini.',
                'content' => '<p>Diberitahukan kepada seluruh pengguna layanan publik bahwa akan dilakukan kegiatan pemeliharaan berkala sistem cloud dan database.</p><p>Pemeliharaan dijadwalkan pada hari Sabtu pukul 22.00 WIB hingga Minggu pukul 04.00 WIB.</p>',
                'status' => PostStatus::Published,
                'published_at' => now()->subHours(6),
                'is_featured' => false,
                'view_count' => 45,
                'category_id' => $pengumumanCat?->id,
                'user_id' => $admin?->id,
            ],
        ];

        foreach ($posts as $post) {
            Post::query()->updateOrCreate(['slug' => $post['slug']], $post);
        }
    }
}

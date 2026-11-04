<?php

namespace Database\Seeders;

use App\Enums\PageStatus;
use App\Models\Page;
use App\Models\User;
use Illuminate\Database\Seeder;

class PageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $admin = User::first();

        $pages = [
            [
                'title' => 'Tentang Kami',
                'slug' => 'tentang-kami',
                'content' => '<h2>Profil Lembaga</h2><p>Kami merupakan institusi yang berdedikasi melayani kepentingan publik dengan profesionalitas tinggi, integritas, dan semangat inovasi berkelanjutan.</p><p>Melalui keterbukaan informasi dan respon cepat terhadap kebutuhan warga, kami berupaya menciptakan pelayanan yang mudah diakses oleh semua lapisan masyarakat.</p>',
                'status' => PageStatus::Published,
                'sort_order' => 1,
                'show_in_menu' => true,
                'user_id' => $admin?->id,
            ],
            [
                'title' => 'Visi & Misi',
                'slug' => 'visi-misi',
                'content' => '<h2>Visi</h2><p>Menjadi instansi pelayanan publik yang terdepan, modern, inklusif, dan terpercaya.</p><h2>Misi</h2><ol><li>Mewujudkan tata kelola organisasi yang bersih dan transparan.</li><li>Meningkatkan kualitas pelayanan publik berbasis teknologi informasi.</li><li>Menjalin komunikasi partisipatif dua arah dengan masyarakat.</li></ol>',
                'status' => PageStatus::Published,
                'sort_order' => 2,
                'show_in_menu' => true,
                'user_id' => $admin?->id,
            ],
            [
                'title' => 'Struktur Organisasi',
                'slug' => 'struktur-organisasi',
                'content' => '<h2>Struktur Pimpinan</h2><p>Bagan organisasi dan unit kerja teknis dirancang secara efektif dan efisien guna memastikan setiap alur koordinasi dan layanan berjalan optimal.</p>',
                'status' => PageStatus::Published,
                'sort_order' => 3,
                'show_in_menu' => true,
                'user_id' => $admin?->id,
            ],
        ];

        foreach ($pages as $page) {
            Page::query()->updateOrCreate(['slug' => $page['slug']], $page);
        }
    }
}

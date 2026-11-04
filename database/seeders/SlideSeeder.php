<?php

namespace Database\Seeders;

use App\Models\Slide;
use Illuminate\Database\Seeder;

class SlideSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $slides = [
            [
                'title' => 'Selamat Datang di Portal Informasi & Aspirasi Warga',
                'description' => 'Akses layanan administrasi terpadu dan kirim pertanyaan Anda langsung ke petugas kami.',
                'image' => 'slides/banner-welcome.jpg',
                'link_url' => '/tanya-kami',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'title' => 'Pelayanan Cepat, Transparan, dan Tanpa Pungli',
                'description' => 'Komitmen kami memberikan kemudahan dan kepastian pelayanan untuk seluruh masyarakat.',
                'image' => 'slides/banner-transparansi.jpg',
                'link_url' => '/layanan',
                'sort_order' => 2,
                'is_active' => true,
            ],
        ];

        foreach ($slides as $slide) {
            Slide::query()->updateOrCreate(['title' => $slide['title']], $slide);
        }
    }
}
